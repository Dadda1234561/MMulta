package l2s.gameserver.network.l2;

import l2s.commons.dbutils.DbUtils;
import l2s.commons.net.nio.impl.MMOClient;
import l2s.commons.net.nio.impl.MMOConnection;
import l2s.gameserver.Config;
import l2s.gameserver.config.FloodProtectorConfig;
import l2s.gameserver.config.FloodProtectorConfigs;
import l2s.gameserver.dao.CharacterDAO;
import l2s.gameserver.database.DatabaseFactory;
import l2s.gameserver.model.CharSelectInfoPackage;
import l2s.gameserver.model.GameObjectsStorage;
import l2s.gameserver.model.Player;
import l2s.gameserver.network.authcomm.AuthServerCommunication;
import l2s.gameserver.network.authcomm.SessionKey;
import l2s.gameserver.network.authcomm.gs2as.PlayerLogout;
import l2s.gameserver.network.l2.components.SystemMsg;
import l2s.gameserver.network.l2.s2c.L2GameServerPacket;
import l2s.gameserver.security.SecondaryPasswordAuth;
import l2s.gameserver.utils.Language;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.nio.ByteBuffer;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * Represents a client connected on Game Server
 */
public final class GameClient extends MMOClient<MMOConnection<GameClient>>
{
	private static final Logger _log = LoggerFactory.getLogger(GameClient.class);
	private static final String NO_IP = "?.?.?.?";

	public GameCrypt _crypt = null;

	public GameClientState _state;

	private final Map<String, FloodProtector> _floodProtectors = new HashMap<String, FloodProtector>();

	public static enum GameClientState
	{
		CONNECTED,
		AUTHED,
		IN_GAME,
		DISCONNECTED
	}

	/** Данные аккаунта */
	private String _login;
	private int _premiumAccountType = 0;
	private int _premiumAccountExpire;
	private int _points = 0;
	private Language _language = Config.DEFAULT_LANG;
	private long _phoneNumber = 0L;

	private Player _activeChar;
	private SessionKey _sessionKey;
	private String _ip = NO_IP;
	private int revision = 0;

	private int lastPing = 0;

	private SecondaryPasswordAuth _secondaryAuth = null;

	private List<Integer> _charSlotMapping = new ArrayList<Integer>();

	private String _hwid = null;

	public GameClient(MMOConnection<GameClient> con)
	{
		super(con);

		_state = GameClientState.CONNECTED;
		_ip = con.getSocket().getInetAddress().getHostAddress();
		_crypt = new GameCrypt();

		for(FloodProtectorConfig config : FloodProtectorConfigs.FLOOD_PROTECTORS)
			_floodProtectors.put(config.FLOOD_PROTECTOR_TYPE, new FloodProtector(this, config));
	}

	@Override
	protected void onDisconnection()
	{
		final Player player;

		setState(GameClientState.DISCONNECTED);
		player = getActiveChar();
		setActiveChar(null);

		if(player != null)
		{
			player.setNetConnection(null);
			player.scheduleDelete();
		}

		if(getSessionKey() != null)
		{
			if(isAuthed())
			{
				AuthServerCommunication.getInstance().removeAuthedClient(getLogin());
				AuthServerCommunication.getInstance().sendPacket(new PlayerLogout(getLogin()));
			}
			else
			{
				AuthServerCommunication.getInstance().removeWaitingClient(getLogin());
			}
		}
	}

 	@Override
	protected void onForcedDisconnection()
	{
		// TODO Auto-generated method stub
		// Дополнительно сохраняем при принудительном дисконекте и краше клиента
		Player player = getActiveChar();
		if (player == null)return;
		player.restoreVariables();
	}

	public void markRestoredChar(int charslot) throws Exception
	{
		int objid = getObjectIdForSlot(charslot);
		if(objid < 0)
			return;

		if(_activeChar != null && _activeChar.getObjectId() == objid)
			_activeChar.setDeleteTimer(0);

		Connection con = null;
		PreparedStatement statement = null;
		try
		{
			con = DatabaseFactory.getInstance().getConnection();
			statement = con.prepareStatement("UPDATE characters SET deletetime=0 WHERE obj_id=?");
			statement.setInt(1, objid);
			statement.execute();
		}
		catch(Exception e)
		{
			_log.error("", e);
		}
		finally
		{
			DbUtils.closeQuietly(con, statement);
		}
	}

	public void markToDeleteChar(int charslot) throws Exception
	{
		int objid = getObjectIdForSlot(charslot);
		if(objid < 0)
			return;

		if(_activeChar != null && _activeChar.getObjectId() == objid)
			_activeChar.setDeleteTimer((int) (System.currentTimeMillis() / 1000));

		Connection con = null;
		PreparedStatement statement = null;
		try
		{
			con = DatabaseFactory.getInstance().getConnection();
			statement = con.prepareStatement("UPDATE characters SET deletetime=? WHERE obj_id=?");
			statement.setLong(1, (int) (System.currentTimeMillis() / 1000L));
			statement.setInt(2, objid);
			statement.execute();
		}
		catch(Exception e)
		{
			_log.error("data error on update deletime char:", e);
		}
		finally
		{
			DbUtils.closeQuietly(con, statement);
		}
	}

	public void deleteChar(int charslot) throws Exception
	{
		//have to make sure active character must be nulled
		if(_activeChar != null)
			return;

		int objid = getObjectIdForSlot(charslot);
		if(objid == -1)
			return;

		CharacterDAO.getInstance().deleteCharByObjId(objid);
	}

	public Player loadCharFromDisk(int charslot)
	{
		int objectId = getObjectIdForSlot(charslot);
		if(objectId == -1)
			return null;

		Player character = null;
		Player oldPlayer = GameObjectsStorage.getPlayer(objectId);

		if(oldPlayer != null)
		{
			if(oldPlayer.isInOfflineMode() || oldPlayer.isLogoutStarted())
			{
				// оффтрейдового чара проще выбить чем восстанавливать
				oldPlayer.kick();
			}
			else
			{
				oldPlayer.sendPacket(SystemMsg.ANOTHER_PERSON_HAS_LOGGED_IN_WITH_THE_SAME_ACCOUNT);

				GameClient oldClient = oldPlayer.getNetConnection();
				if(oldClient != null)
				{
					oldClient.setActiveChar(null);
					oldClient.closeNow(false);
				}
				oldPlayer.setNetConnection(this);
				character = oldPlayer;
			}
		}

		if(character == null)
			character = Player.restore(objectId, false);

		if(character != null)
			setActiveChar(character);
		else
			_log.warn("could not restore obj_id: " + objectId + " in slot:" + charslot);

		return character;
	}

	public int getObjectIdForSlot(int charslot)
	{
		if(charslot < 0 || charslot >= _charSlotMapping.size())
		{
			_log.warn(getLogin() + " tried to modify Character in slot " + charslot + " but no characters exits at that slot.");
			return -1;
		}
		return _charSlotMapping.get(charslot);
	}

	public int getSlotForObjectId(int obj_id)
	{
		for(int i=0;i<_charSlotMapping.size();i++)
			if(_charSlotMapping.get(i) == obj_id)
				return i;
		return -1;
	}

	public Player getActiveChar()
	{
		return _activeChar;
	}

	/**
	 * @return Returns the sessionId.
	 */
	public SessionKey getSessionKey()
	{
		return _sessionKey;
	}

	public String getLogin()
	{
		return _login;
	}

	public void setLoginName(String loginName)
	{
		_login = loginName;

		if(Config.EX_SECOND_AUTH_ENABLED)
			_secondaryAuth = new SecondaryPasswordAuth(this);
	}

	public void setActiveChar(Player player)
	{
		_activeChar = player;
		if(player != null)
			player.setNetConnection(this);
	}

	public void setSessionId(SessionKey sessionKey)
	{
		_sessionKey = sessionKey;
	}

	public void setCharSelection(CharSelectInfoPackage[] chars)
	{
		_charSlotMapping.clear();

		for(CharSelectInfoPackage element : chars)
		{
			int objectId = element.getObjectId();
			_charSlotMapping.add(objectId);
		}
	}

	public void setCharSelection(int c)
	{
		_charSlotMapping.clear();
		_charSlotMapping.add(c);
	}

	public int getRevision()
	{
		return revision;
	}

	public void setRevision(int revision)
	{
		this.revision = revision;
	}

	public boolean checkFloodProtection(String type, String command)
	{
		FloodProtector floodProtector = _floodProtectors.get(type.toUpperCase());
		return floodProtector == null || floodProtector.tryPerformAction(command);
	}

	@Override
	public boolean encrypt(final ByteBuffer buf, final int size)
	{
		_crypt.encrypt(buf.array(), buf.position(), size);
		buf.position(buf.position() + size);
		return true;
	}

	@Override
	public boolean decrypt(ByteBuffer buf, int size)
	{
		boolean ret = _crypt.decrypt(buf.array(), buf.position(), size);

		return ret;
	}

	public void sendPacket(L2GameServerPacket gsp)
	{
		if(isConnected())
			getConnection().sendPacket(gsp);
	}

	public void sendPacket(L2GameServerPacket... gsp)
	{
		if(isConnected())
			getConnection().sendPacket(gsp);
	}

	public void sendPackets(List<L2GameServerPacket> gsp)
	{
		if(isConnected())
			getConnection().sendPackets(gsp);
	}

	public void close(L2GameServerPacket gsp)
	{
		if(isConnected())
			getConnection().close(gsp);
	}

	public String getIpAddr()
	{
		return _ip;
	}

	public byte[] enableCrypt()
	{
		byte[] key = BlowFishKeygen.getRandomKey();
		_crypt.setKey(key);
		return key;
	}

	public boolean hasPremiumAccount()
	{
		return _premiumAccountType != 0 && _premiumAccountExpire > System.currentTimeMillis() / 1000L;
	}

	public void setPremiumAccountType(int type)
	{
		_premiumAccountType = type;
	}

	public int getPremiumAccountType()
	{
		return _premiumAccountType;
	}

	public void setPremiumAccountExpire(int expire)
	{
		_premiumAccountExpire = expire;
	}

	public int getPremiumAccountExpire()
	{
		return _premiumAccountExpire;
	}

	public int getPoints()
	{
		return _points;
	}

	public void setPoints(int points)
	{
		_points = points;
	}

	public Language getLanguage()
	{
		return _language;
	}

	public void setLanguage(Language language)
	{
		_language = language;
	}

	public long getPhoneNumber()
	{
		return _phoneNumber;
	}

	public void setPhoneNumber(long value)
	{
		_phoneNumber = value;
	}

	public GameClientState getState()
	{
		return _state;
	}

	public void setState(GameClientState state)
	{
		_state = state;
	}

	public SecondaryPasswordAuth getSecondaryAuth()
	{
		return _secondaryAuth;
	}

	private int _failedPackets = 0;
	private int _unknownPackets = 0;

	public void onPacketReadFail()
	{
		if(_failedPackets++ >= 10)
		{
			_log.warn("Too many client packet fails, connection closed : " + this);
			closeNow(true);
		}
	}

	public void onUnknownPacket()
	{
		if(_unknownPackets++ >= 10)
		{
			_log.warn("Too many client unknown packets, connection closed : " + this);
			closeNow(true);
		}
	}

	@Override
	public String toString()
	{
		return _state + " IP: " + getIpAddr() + (_login == null ? "" : " Account: " + _login) + (_activeChar == null ? "" : " Player : " + _activeChar);
	}

	public boolean secondaryAuthed()
	{
		if(!Config.EX_SECOND_AUTH_ENABLED)
			return true;

		return getSecondaryAuth().isAuthed();
	}

	public String getHWID()
	{
		return _hwid == null ? "NONE" : _hwid;
	}

	public void setHWID(String hwid)
	{
		_hwid = hwid;
	}

	public int getLastPing()
	{
		return lastPing;
	}

	public void setLastPing(final int lastPing)
	{
		this.lastPing = lastPing;
	}
}