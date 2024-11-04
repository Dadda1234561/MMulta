package l2s.gameserver.dao;

import java.util.ArrayList;
import java.util.List;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

import l2s.commons.dbutils.DbUtils;
import l2s.gameserver.data.xml.holder.HomunculusHolder;
import l2s.gameserver.database.DatabaseFactory;
import l2s.gameserver.model.Player;
import l2s.gameserver.model.actor.instances.player.Homunculus;
import l2s.gameserver.templates.HomunculusTemplate;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

/**
 * @author nexvill
 */
public class CharacterHomunculusDAO
{
	private static final String SELECT_QUERY = "SELECT slot, homunculus_id, level, exp, skill1_level, skill2_level, skill3_level, skill4_level, skill5_level, active FROM character_homunculus WHERE char_id=?";
	private static final String INSERT_QUERY = "INSERT INTO `character_homunculus` (char_id, slot, homunculus_id, level, exp, skill1_level, skill2_level, skill3_level, skill4_level, skill5_level, active) VALUES (?,?,?,?,?,?,?,?,?,?,?)";
	private static final String DELETE_QUERY = "DELETE FROM character_homunculus WHERE char_id=? AND slot=? AND homunculus_id=? AND level=? AND exp=? AND skill1_level=? AND skill2_level=? AND skill3_level=? AND skill4_level=? AND skill5_level=? AND active=?";
	private static final String UPDATE_QUERY = "UPDATE character_homunculus SET level=?, exp=?, skill1_level=?, skill2_level=?, skill3_level=?, skill4_level=?, skill5_level=?, active=? WHERE char_id=? AND slot=? AND homunculus_id=?";
	private static final String UPDATE_SLOT_QUERY = "UPDATE character_homunculus SET slot = 0 WHERE char_id = ? AND slot = 1";

	private static final Logger _log = LoggerFactory.getLogger(CharacterHomunculusDAO.class);

	private static final CharacterHomunculusDAO _instance = new CharacterHomunculusDAO();

	public static CharacterHomunculusDAO getInstance()
	{
		return _instance;
	}

	public List<Homunculus> select(Player owner)
	{
		List<Homunculus> list = new ArrayList<Homunculus>();

		Connection con = null;
		PreparedStatement statement = null;
		ResultSet rset = null;
		try
		{
			con = DatabaseFactory.getInstance().getConnection();
			statement = con.prepareStatement(SELECT_QUERY);
			statement.setInt(1, owner.getObjectId());
			rset = statement.executeQuery();

			while(rset.next())
			{
				final int homunculus_id = rset.getInt("homunculus_id");
				final int slot = rset.getInt("slot");
				final int level = rset.getInt("level");
				final int exp = rset.getInt("exp");
				final int skill1_level = rset.getInt("skill1_level");
				final int skill2_level = rset.getInt("skill2_level");
				final int skill3_level = rset.getInt("skill3_level");
				final int skill4_level = rset.getInt("skill4_level");
				final int skill5_level = rset.getInt("skill5_level");
				final boolean isActive = rset.getInt("active") > 0;

				final HomunculusTemplate template = HomunculusHolder.getInstance().getHomunculusInfo(homunculus_id);

				Homunculus homunculus = null;
				boolean remove = template == null;
				if(!remove)
				{
					homunculus = new Homunculus(template, slot, level, exp, skill1_level, skill2_level, skill3_level, skill4_level, skill5_level, isActive);
				}

				if(remove)
					delete(owner, slot, homunculus_id, level, exp, skill1_level, skill2_level, skill3_level, skill4_level, skill5_level, isActive);
				else
					list.add(homunculus);
			}
		}
		catch(Exception e)
		{
			_log.error("CharacterHomunculusDAO.select(Player): " + e, e);
		}
		finally
		{
			DbUtils.closeQuietly(con, statement, rset);
		}
		return list;
	}

	public boolean insert(Player owner, Homunculus homunculus)
	{
		Connection con = null;
		PreparedStatement statement = null;
		try
		{
			con = DatabaseFactory.getInstance().getConnection();
			statement = con.prepareStatement(INSERT_QUERY);
			statement.setInt(1, owner.getObjectId());
			statement.setInt(2, homunculus.getSlot());
			statement.setInt(3, homunculus.getId());
			statement.setInt(4, homunculus.getLevel());
			statement.setInt(5, homunculus.getExp());
			statement.setInt(6, homunculus.getSkill1Level());
			statement.setInt(7, homunculus.getSkill2Level());
			statement.setInt(8, homunculus.getSkill3Level());
			statement.setInt(9, homunculus.getSkill4Level());
			statement.setInt(10, homunculus.getSkill5Level());
			statement.setInt(11, homunculus.isActive() ? 1 : 0);
			statement.execute();
		}
		catch(Exception e)
		{
			_log.warn(owner.getHomunculusList() + " could not add homunculus to homunculus list: " + homunculus, e);
			return false;
		}
		finally
		{
			DbUtils.closeQuietly(con, statement);
		}
		return true;
	}

	public boolean delete(Player owner, Homunculus homunculus)
	{
		return delete(owner, homunculus.getSlot(), homunculus.getId(), homunculus.getLevel(), homunculus.getExp(), homunculus.getSkill1Level(), homunculus.getSkill2Level(), homunculus.getSkill3Level(), homunculus.getSkill4Level(), homunculus.getSkill5Level(), homunculus.isActive());
	}

	private boolean delete(Player owner, int slot, int id, int level, int exp, int skill1_level, int skill2_level, int skill3_level, int skill4_level, int skill5_level, boolean active)
	{
		Connection con = null;
		PreparedStatement statement = null;
		try
		{
			con = DatabaseFactory.getInstance().getConnection();
			statement = con.prepareStatement(DELETE_QUERY);
			statement.setInt(1, owner.getObjectId());
			statement.setInt(2, slot);
			statement.setInt(3, id);
			statement.setInt(4, level);
			statement.setInt(5, exp);
			statement.setInt(6, skill1_level);
			statement.setInt(7, skill2_level);
			statement.setInt(8, skill3_level);
			statement.setInt(9, skill4_level);
			statement.setInt(10, skill5_level);
			statement.setInt(11, active ? 1 : 0);
			statement.execute();
		}
		catch(Exception e)
		{
			_log.warn(owner.getHomunculusList() + " could not delete homunculus: " + Homunculus.toString(id, active) + " ownerId: " + owner.getObjectId(), e);
			return false;
		}
		finally
		{
			DbUtils.closeQuietly(con, statement);
		}
		
		if (slot == 0)
		{
			updateSlot(owner);
		}
		return true;
	}
	
	private boolean updateSlot(Player owner)
	{
		Connection con = null;
		PreparedStatement statement = null;
		try
		{
			con = DatabaseFactory.getInstance().getConnection();
			statement = con.prepareStatement(UPDATE_SLOT_QUERY);
			statement.setInt(1, owner.getObjectId());
			statement.execute();
		}
		catch(Exception e)
		{
			_log.warn(owner.getHomunculusList() + " could not change homunculus slot on owner id: " + owner.getObjectId(), e);
			return false;
		}
		finally
		{
			DbUtils.closeQuietly(con, statement);
		}
		return true;
	}
	
	public boolean update(Player owner, Homunculus homunculus)
	{
		Connection con = null;
		PreparedStatement statement = null;
		try
		{
			con = DatabaseFactory.getInstance().getConnection();
			statement = con.prepareStatement(UPDATE_QUERY);
			statement.setInt(1, homunculus.getLevel());
			statement.setInt(2, homunculus.getExp());
			statement.setInt(3, homunculus.getSkill1Level());
			statement.setInt(4, homunculus.getSkill2Level());
			statement.setInt(5, homunculus.getSkill3Level());
			statement.setInt(6, homunculus.getSkill4Level());
			statement.setInt(7, homunculus.getSkill5Level());
			statement.setInt(8, homunculus.isActive() ? 1 : 0);
			statement.setInt(9, owner.getObjectId());
			statement.setInt(10, homunculus.getSlot());
			statement.setInt(11, homunculus.getId());
			statement.execute();
		}
		catch(Exception e)
		{
			_log.warn(owner.getHomunculusList() + " could not update homunculus list on owner id: " + owner.getObjectId(), e);
			return false;
		}
		finally
		{
			DbUtils.closeQuietly(con, statement);
		}
		return true;
	}
}
