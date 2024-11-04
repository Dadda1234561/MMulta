package l2s.gameserver.model.pledge;

import l2s.commons.dbutils.DbUtils;
import l2s.gameserver.database.DatabaseFactory;
import l2s.gameserver.model.Player;
import l2s.gameserver.network.l2.s2c.NickNameChangedPacket;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.sql.Connection;
import java.sql.PreparedStatement;

public class UnitMember
{
	private static final Logger _log = LoggerFactory.getLogger(UnitMember.class);

	private Player _player;

	private Clan _clan;
	private String _name;
	private String _title;
	private int _objectId;
	private int _level;
	private int _classId;
	private int _sex;
	private int _pledgeType;
	private int _powerGrade;

	public UnitMember(Clan clan, String name, String title, int level, int classId, int objectId, int pledgeType, int powerGrade, int sex, int subUnit)
	{
		_clan = clan;
		_objectId = objectId;
		_name = name;
		_title = title;
		_level = level;
		_classId = classId;
		_pledgeType = pledgeType;
		_powerGrade = powerGrade;
		_sex = sex;

		if(powerGrade != 0)
		{
			RankPrivs r = clan.getRankPrivs(powerGrade);
			r.setParty(clan.countMembersByRank(powerGrade));
		}
	}

	public UnitMember(Player player)
	{
		_objectId = player.getObjectId();
		_player = player;
	}

	public void setPlayerInstance(Player player, boolean exit)
	{
		_player = exit ? null : player;
		if(player == null)
		{
			return;
		}

		_clan = player.getClan();
		_name = player.getName();
		_title = player.getTitle();
		_level = player.getLevel();
		_classId = player.getClassId().getId();
		_pledgeType = player.getPledgeType();
		_powerGrade = player.getPowerGrade();
		_sex = player.getSex().ordinal();
	}

	public Player getPlayer()
	{
		return _player;
	}

	public boolean isOnline()
	{
		Player player = getPlayer();
		return player != null && !player.isInOfflineMode();
	}

	public Clan getClan()
	{
		Player player = getPlayer();
		return player == null ? _clan : player.getClan();
	}

	public int getClassId()
	{
		Player player = getPlayer();
		return player == null ? _classId : player.getClassId().getId();
	}

	public int getSex()
	{
		Player player = getPlayer();
		return player == null ? _sex : player.getSex().ordinal();
	}

	public int getLevel()
	{
		Player player = getPlayer();
		return player == null ? _level : player.getLevel();
	}

	public String getName()
	{
		Player player = getPlayer();
		return player == null ? _name : player.getName();
	}

	public int getObjectId()
	{
		return _objectId;
	}

	public String getTitle()
	{
		Player player = getPlayer();
		return player == null ? _title : player.getTitle();
	}

	public void setTitle(String title)
	{
		Player player = getPlayer();
		_title = title;
		if(player != null)
		{
			player.setTitle(title);
			player.broadcastPacket(new NickNameChangedPacket(player));
		}
		else
		{
			Connection con = null;
			PreparedStatement statement = null;
			try
			{
				con = DatabaseFactory.getInstance().getConnection();
				statement = con.prepareStatement("UPDATE characters SET title=? WHERE obj_Id=?");
				statement.setString(1, title);
				statement.setInt(2, getObjectId());
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
	}

	public SubUnit getSubUnit()
	{
		return _clan.getSubUnit(_pledgeType);
	}

	public int getPledgeType()
	{
		Player player = getPlayer();
		return player == null ? _pledgeType : player.getPledgeType();
	}

	public void setPledgeType(int pledgeType)
	{
		Player player = getPlayer();
		_pledgeType = pledgeType;
		if(player != null)
			player.setPledgeType(pledgeType);
		else
			updatePledgeType();
	}

	private void updatePledgeType()
	{
		Connection con = null;
		PreparedStatement statement = null;
		try
		{
			con = DatabaseFactory.getInstance().getConnection();
			statement = con.prepareStatement("UPDATE characters SET pledge_type=? WHERE obj_Id=?");
			statement.setInt(1, _pledgeType);
			statement.setInt(2, getObjectId());
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

	public int getPowerGrade()
	{
		Player player = getPlayer();
		return player == null ? _powerGrade : player.getPowerGrade();
	}

	public void setPowerGrade(int newPowerGrade)
	{
		Player player = getPlayer();
		int oldPowerGrade = getPowerGrade();
		_powerGrade = newPowerGrade;
		if(player != null)
			player.setPowerGrade(newPowerGrade);
		else
			updatePowerGrade();
		updatePowerGradeParty(oldPowerGrade, newPowerGrade);
	}

	private void updatePowerGradeParty(int oldGrade, int newGrade)
	{
		if(oldGrade != 0)
		{
			RankPrivs r1 = getClan().getRankPrivs(oldGrade);
			r1.setParty(getClan().countMembersByRank(oldGrade));
		}
		if(newGrade != 0)
		{
			RankPrivs r2 = getClan().getRankPrivs(newGrade);
			r2.setParty(getClan().countMembersByRank(newGrade));
		}
	}

	private void updatePowerGrade()
	{
		Connection con = null;
		PreparedStatement statement = null;
		try
		{
			con = DatabaseFactory.getInstance().getConnection();
			statement = con.prepareStatement("UPDATE characters SET pledge_rank=? WHERE obj_Id=?");
			statement.setInt(1, _powerGrade);
			statement.setInt(2, getObjectId());
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

	public boolean isClanLeader()
	{
		return _clan.isLeader(_objectId);
	}
}