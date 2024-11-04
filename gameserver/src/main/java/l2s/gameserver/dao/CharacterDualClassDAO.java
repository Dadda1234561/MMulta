package l2s.gameserver.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

import l2s.commons.dbutils.DbUtils;
import l2s.gameserver.database.DatabaseFactory;
import l2s.gameserver.model.Player;
import l2s.gameserver.model.actor.instances.player.DualClass;
import l2s.gameserver.model.base.DualClassType;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

public class CharacterDualClassDAO
{
	private static final Logger _log = LoggerFactory.getLogger(CharacterDualClassDAO.class);
	private static CharacterDualClassDAO _instance = new CharacterDualClassDAO();

	public static final String SELECT_SQL_QUERY = "SELECT class_id, default_class_id, exp, sp, curHp, curCp, curMp, active, type, dual_certification, vitality, used_vitality_potions FROM character_dualclasses WHERE char_obj_id=?";
	public static final String INSERT_SQL_QUERY = "INSERT INTO character_dualclasses (char_obj_id, class_id, default_class_id, exp, sp, curHp, curMp, curCp, maxHp, maxMp, maxCp, level, active, type, dual_certification, vitality, used_vitality_potions) VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)";

	public static CharacterDualClassDAO getInstance()
	{
		return _instance;
	}

	public boolean insert(int objId, int classId, int dafaultClassId, long exp, long sp, double curHp, double curMp, double curCp, double maxHp, double maxMp, double maxCp, int level, boolean active, DualClassType type, int dualCertification, int vitality, int vitalityUsedPotions)
	{
		Connection con = null;
		PreparedStatement statement = null;
		try
		{
			con = DatabaseFactory.getInstance().getConnection();
			statement = con.prepareStatement(INSERT_SQL_QUERY);
			statement.setInt(1, objId);
			statement.setInt(2, classId);
			statement.setInt(3, dafaultClassId);
			statement.setLong(4, exp);
			statement.setLong(5, sp);
			statement.setDouble(6, curHp);
			statement.setDouble(7, curMp);
			statement.setDouble(8, curCp);
			statement.setDouble(9, maxHp);
			statement.setDouble(10, maxMp);
			statement.setDouble(11, maxCp);
			statement.setInt(12, level);
			statement.setInt(13, (active ? 1 : 0));
			statement.setInt(14, type.ordinal());
			statement.setInt(15, dualCertification);
			statement.setInt(16, vitality);
			statement.setInt(17, vitalityUsedPotions);
			statement.executeUpdate();
		}
		catch(final Exception e)
		{
			_log.error("CharacterDualClassDAO:insert(player)", e);
			return false;
		}
		finally
		{
			DbUtils.closeQuietly(con, statement);
		}
		return true;
	}

	public List<DualClass> restore(Player player)
	{
		List<DualClass> result = new ArrayList<DualClass>();

		Connection con = null;
		PreparedStatement statement = null;
		ResultSet rset = null;
		try
		{
			con = DatabaseFactory.getInstance().getConnection();
			statement = con.prepareStatement(SELECT_SQL_QUERY);
			statement.setInt(1, player.getObjectId());
			rset = statement.executeQuery();
			while(rset.next())
			{
				DualClass subClass = new DualClass(player);
				//Порядок не менять, будут плохие последствия!
				subClass.setType(DualClassType.VALUES[rset.getInt("type")]);
				subClass.setClassId(rset.getInt("class_id"));
				subClass.setDefaultClassId(rset.getInt("default_class_id"));
				subClass.setExp(rset.getLong("exp"), false);
				subClass.setSp(rset.getLong("sp"));
				subClass.setHp(rset.getDouble("curHp"));
				subClass.setMp(rset.getDouble("curMp"));
				subClass.setCp(rset.getDouble("curCp"));
				subClass.setActive(rset.getInt("active") == 1);
				subClass.setDualCertification(rset.getInt("dual_certification"));
				subClass.setVitality(rset.getInt("vitality"));
				subClass.setUsedVitalityPotions(rset.getInt("used_vitality_potions"));
				result.add(subClass);
			}
		}
		catch(Exception e)
		{
			_log.error("CharacterDualClassDAO:restore(player)", e);
		}
		finally
		{
			DbUtils.closeQuietly(con, statement, rset);
		}
		return result;
	}

	public boolean store(Player player)
	{
		Connection con = null;
		Statement statement = null;
		try
		{
			con = DatabaseFactory.getInstance().getConnection();
			statement = con.createStatement();

			StringBuilder sb;
			for(DualClass dualClass : player.getDualClassList().values())
			{
				sb = new StringBuilder("UPDATE character_dualclasses SET ");
				sb.append("exp=").append(dualClass.getExp()).append(",");
				sb.append("sp=").append(dualClass.getSp()).append(",");
				sb.append("curHp=").append(dualClass.getHp()).append(",");
				sb.append("curMp=").append(dualClass.getMp()).append(",");
				sb.append("curCp=").append(dualClass.getCp()).append(",");
				sb.append("level=").append(dualClass.getLevel()).append(",");
				sb.append("active=").append(dualClass.isActive() ? 1 : 0).append(",");
				sb.append("type=").append(dualClass.getType().ordinal()).append(",");
				sb.append("dual_certification='").append(dualClass.getDualCertification()).append("',");
				sb.append("vitality='").append(dualClass.getVitality()).append("',");
				sb.append("used_vitality_potions='").append(dualClass.getUsedVitalityPotions()).append("'");
				sb.append(" WHERE char_obj_id=").append(player.getObjectId()).append(" AND class_id=").append(dualClass.getClassId()).append(" LIMIT 1");
				statement.executeUpdate(sb.toString());
			}

			sb = new StringBuilder("UPDATE character_dualclasses SET ");
			sb.append("maxHp=").append(player.getMaxHp()).append(",");
			sb.append("maxMp=").append(player.getMaxMp()).append(",");
			sb.append("maxCp=").append(player.getMaxCp());
			sb.append(" WHERE char_obj_id=").append(player.getObjectId()).append(" AND active=1 LIMIT 1");
			statement.executeUpdate(sb.toString());
		}
		catch(final Exception e)
		{
			_log.error("CharacterDualClassDAO:store(player)", e);
			return false;
		}
		finally
		{
			DbUtils.closeQuietly(con, statement);
		}
		return true;
	}
}