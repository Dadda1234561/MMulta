package l2s.gameserver.model.pledge;

import l2s.commons.dbutils.DbUtils;
import l2s.gameserver.database.DatabaseFactory;
import l2s.gameserver.model.base.DualClassType;
import org.napile.primitive.maps.IntObjectMap;
import org.napile.primitive.maps.impl.CHashIntObjectMap;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.Collection;

/**
* @author VISTALL
* @date  15:01/01.12.2010
*/
public class SubUnit
{
	private static final Logger _log = LoggerFactory.getLogger(SubUnit.class);

	private IntObjectMap<UnitMember> _members = new CHashIntObjectMap<UnitMember>();

	private int _type;
	private Clan _clan;

	public SubUnit(Clan c, int type)
	{
		_clan = c;
		_type = type;
	}

	public Clan getClan() {
		return _clan;
	}

	public int getType()
	{
		return _type;
	}

	public boolean isUnitMember(int obj)
	{
		return _members.containsKey(obj);
	}

	public void addUnitMember(UnitMember member)
	{
		_members.put(member.getObjectId(), member);
	}

	public UnitMember getUnitMember(int obj)
	{
		if(obj == 0)
			return null;
		return _members.get(obj);
	}

	public UnitMember getUnitMember(String obj)
	{
		for(UnitMember m : getUnitMembers())
		{
			if(m.getName().equalsIgnoreCase(obj))
				return m;
		}

		return null;
	}

	public void removeUnitMember(int objectId)
	{
		UnitMember m = _members.remove(objectId);
		if(m == null)
			return;

		removeMemberInDatabase(m);

		m.setPlayerInstance(null, true);
	}

	public void replace(int objectId, int newUnitId)
	{
		SubUnit newUnit = _clan.getSubUnit(newUnitId);
		if(newUnit == null)
			return;

		UnitMember m = _members.remove(objectId);
		if(m == null)
			return;

		m.setPledgeType(newUnitId);
		newUnit.addUnitMember(m);

		if(m.getPowerGrade() > 5)
			m.setPowerGrade(_clan.getAffiliationRank(m.getPledgeType()));
	}

	public int size()
	{
		return _members.size();
	}

	public Collection<UnitMember> getUnitMembers()
	{
		return _members.valueCollection();
	}

	private static void removeMemberInDatabase(UnitMember member)
	{
		Connection con = null;
		PreparedStatement statement = null;
		try
		{
			con = DatabaseFactory.getInstance().getConnection();
			statement = con.prepareStatement("UPDATE characters SET clanid=0, pledge_type=?, pledge_rank=0, title='', leaveclan=? WHERE obj_Id=?");
			statement.setInt(1, Clan.SUBUNIT_NONE);
			statement.setLong(2, System.currentTimeMillis() / 1000);
			statement.setInt(3, member.getObjectId());
			statement.execute();
		}
		catch(Exception e)
		{
			_log.warn("Exception: " + e, e);
		}
		finally
		{
			DbUtils.closeQuietly(con, statement);
		}
	}

	public void restore()
	{
		Connection con = null;
		PreparedStatement statement = null;
		ResultSet rset = null;
		try
		{
			con = DatabaseFactory.getInstance().getConnection();
			statement = con.prepareStatement(//
			"SELECT `c`.`char_name` AS `char_name`," + //
			"`s`.`level` AS `level`," + //
			"`s`.`class_id` AS `classid`," + //
			"`c`.`obj_Id` AS `obj_id`," + //
			"`c`.`title` AS `title`," + //
			"`c`.`pledge_rank` AS `pledge_rank`," + //
			"`c`.`sex` AS `sex` " + //
			"FROM `characters` `c` " + //
			"LEFT JOIN `character_dualclasses` `s` ON (`s`.`char_obj_id` = `c`.`obj_Id` AND `s`.`type` = '" + DualClassType.BASE_CLASS.ordinal() + "') " + //
			"WHERE `c`.`clanid`=? AND `c`.`pledge_type`=? ORDER BY `c`.`lastaccess` DESC");

			statement.setInt(1, _clan.getClanId());
			statement.setInt(2, _type);
			rset = statement.executeQuery();

			while(rset.next())
			{
				UnitMember member = new UnitMember(_clan, rset.getString("char_name"), rset.getString("title"), rset.getInt("level"), rset.getInt("classid"), rset.getInt("obj_Id"), _type, rset.getInt("pledge_rank"), rset.getInt("sex"), Clan.SUBUNIT_NONE);
				addUnitMember(member);
			}
		}
		catch(Exception e)
		{
			_log.warn("Error while restoring clan members for clan: " + _clan.getClanId() + " " + e, e);
		}
		finally
		{
			DbUtils.closeQuietly(con, statement, rset);
		}
	}
}
