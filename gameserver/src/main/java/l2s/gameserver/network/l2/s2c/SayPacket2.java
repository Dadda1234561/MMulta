package l2s.gameserver.network.l2.s2c;

import l2s.gameserver.instancemanager.RankManager;
import l2s.gameserver.model.GameObjectsStorage;
import l2s.gameserver.model.Player;
import l2s.gameserver.model.entity.rank.enums.RankingGroup;
import l2s.gameserver.network.l2.components.ChatType;
import l2s.gameserver.network.l2.components.NpcString;
import l2s.gameserver.network.l2.components.SysString;
import l2s.gameserver.network.l2.components.SystemMsg;

public class SayPacket2 extends NpcStringContainer
{
	// Flags
	private static final int IS_FRIEND = 1 << 0;
	private static final int IS_CLAN_MEMBER = 1 << 1;
	private static final int IS_MENTEE_OR_MENTOR = 1 << 2;
	private static final int IS_ALLIANCE_MEMBER = 1 << 3;
	private static final int IS_GM = 1 << 4;

	private ChatType _type;
	private SysString _sysString;
	private SystemMsg _systemMsg;

	private int _objectId;
	private String _charName;
	private int _mask;
	private int _charLevel = -1;
	private String _text;

	public SayPacket2(int objectId, ChatType type, SysString st, SystemMsg sm)
	{
		super(NpcString.NONE);
		_objectId = objectId;
		_type = type;
		_sysString = st;
		_systemMsg = sm;
	}

	public SayPacket2(int objectId, ChatType type, String charName, String text)
	{
		this(objectId, type, charName, NpcString.NONE, text);
	}

	public SayPacket2(int objectId, ChatType type, String charName, NpcString npcString, String... params)
	{
		super(npcString, params);
		_objectId = objectId;
		_type = type;
		_charName = charName;
		_text = params.length > 0 ? params[0] : null;
	}

	public void setCharName(String name)
	{
		_charName = name;
	}

	public void setSenderInfo(Player sender, Player receiver)
	{
		_charLevel = sender.getLevel();

		if(receiver.getFriendList().contains(sender.getObjectId()))
			_mask |= IS_FRIEND;

		if(receiver.getClanId() > 0 && receiver.getClanId() == sender.getClanId())
			_mask |= IS_CLAN_MEMBER;

		if(receiver.getMenteeList().getMentor() == sender.getObjectId() || sender.getMenteeList().getMentor() == receiver.getObjectId())
			_mask |= IS_MENTEE_OR_MENTOR;

		if(receiver.getAllyId() > 0 && receiver.getAllyId() == sender.getAllyId())
			_mask |= IS_ALLIANCE_MEMBER;

		// Does not shows level
		if(sender.isGM())
			_mask |= IS_GM;
	}

	@Override
	protected final void writeImpl()
	{
		writeD(_objectId);
		writeD(_type.ordinal());
		switch(_type)
		{
			case SYSTEM_MESSAGE:
				writeD(_sysString.getId());
				writeD(_systemMsg.getId());
				break;
			case TELL:
				writeS(_charName);
				writeElements();
				writeC(_mask);
				if((_mask & IS_GM) == 0)
					writeH(_charLevel); // changed from byte to short in 272
				break;
			case CLAN:
			case ALLIANCE:
				writeS(_charName);
				writeElements();
				writeC(0x00);	// TODO[UNDERGROUND]: UNK
				break;
			default:
				writeS(_charName);
				writeElements();
				break;
		}

		Player player = GameObjectsStorage.getPlayer(_charName);
		if (player != null) {
			if ((_type != ChatType.TELL) && (_type != ChatType.CLAN) && (_type != ChatType.ALLIANCE)) {
				int rankType = 0;
				RankManager rankManager = RankManager.getInstance();
				if (rankManager.isPlayerRankBetween(player, 1, 10, RankingGroup.Server)) {
					rankType = 1;
				}
				else if (rankManager.isPlayerRankBetween(player, 11, 50, RankingGroup.Server)) {
					rankType = 2;
				}
				else if (rankManager.isPlayerRankBetween(player, 51, 100, RankingGroup.Server)) {
					rankType = 3;
				}

				writeC(rankType);
				
				if (player.getClan() != null) {
					writeC(player.getClan().getCastle());
				}
			}
			else {
				writeC(0);
			}
		}

		if(_text != null) {
			if(player != null)
				player.getListeners().onChatMessageReceive(_type, _charName, _text);
		}
	}
}