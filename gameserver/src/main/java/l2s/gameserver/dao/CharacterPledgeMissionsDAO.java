package l2s.gameserver.dao;

import l2s.commons.dbutils.DbUtils;
import l2s.gameserver.data.xml.holder.PledgeMissionsHolder;
import l2s.gameserver.database.DatabaseFactory;
import l2s.gameserver.model.Player;
import l2s.gameserver.model.actor.instances.player.PledgeMission;
import l2s.gameserver.templates.pledgemissions.PledgeMissionTemplate;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.Collection;
import java.util.Map;

/**
 * @author Bonux
 */
public class CharacterPledgeMissionsDAO {
	private static final Logger _log = LoggerFactory.getLogger(CharacterPledgeMissionsDAO.class);

	private static final CharacterPledgeMissionsDAO _instance = new CharacterPledgeMissionsDAO();

	private static final String SELECT_QUERY = "SELECT mission_id, completed, value FROM character_pledge_missions WHERE char_id = ?";
	private static final String REPLACE_QUERY = "REPLACE INTO character_pledge_missions (char_id,mission_id,completed,value) VALUES(?,?,?,?)";
	private static final String DELETE_QUERY = "DELETE FROM character_pledge_missions WHERE char_id=? AND mission_id=?";

	public static CharacterPledgeMissionsDAO getInstance() {
		return _instance;
	}

	public void restore(Player owner, Map<Integer, PledgeMission> map) {
		Connection con = null;
		PreparedStatement statement = null;
		ResultSet rset = null;
		try {
			con = DatabaseFactory.getInstance().getConnection();
			statement = con.prepareStatement(SELECT_QUERY);
			statement.setInt(1, owner.getObjectId());
			rset = statement.executeQuery();
			while (rset.next()) {
				int mission_id = rset.getInt("mission_id");
				boolean completed = rset.getInt("completed") > 0;
				int value = rset.getInt("value");

				PledgeMissionTemplate template = PledgeMissionsHolder.getInstance().getMission(mission_id);
				if (template == null) {
					delete(owner, mission_id);
					continue;
				}

				map.put(mission_id, new PledgeMission(owner, template, completed, value));
			}
		} catch (Exception e) {
			_log.error("CharacterPledgeMissionsDAO.select(Player): " + e, e);
		} finally {
			DbUtils.closeQuietly(con, statement, rset);
		}
	}

	public boolean store(Player owner, Collection<PledgeMission> missions) {
		Connection con = null;
		PreparedStatement statement = null;
		try {
			con = DatabaseFactory.getInstance().getConnection();
			statement = con.prepareStatement(REPLACE_QUERY);
			statement.setInt(1, owner.getObjectId());
			for (PledgeMission mission : missions) {
				statement.setInt(2, mission.getId());
				statement.setInt(3, mission.isCompleted() ? 1 : 0);
				statement.setInt(4, mission.getValue());
				statement.addBatch();
			}
			statement.executeBatch();
		} catch (Exception e) {
			_log.warn(owner.getPledgeMissionList() + " could not store missions list: ", e);
			return false;
		} finally {
			DbUtils.closeQuietly(con, statement);
		}
		return true;
	}

	public boolean insert(Player owner, PledgeMission mission) {
		Connection con = null;
		PreparedStatement statement = null;
		try {
			con = DatabaseFactory.getInstance().getConnection();
			statement = con.prepareStatement(REPLACE_QUERY);
			statement.setInt(1, owner.getObjectId());
			statement.setInt(2, mission.getId());
			statement.setInt(3, mission.isCompleted() ? 1 : 0);
			statement.setInt(4, mission.getValue());
			statement.execute();
		} catch (Exception e) {
			_log.warn(owner.getPledgeMissionList() + " could not insert mission to missions list: " + mission, e);
			return false;
		} finally {
			DbUtils.closeQuietly(con, statement);
		}
		return true;
	}

	private boolean delete(Player owner, int missionId) {
		Connection con = null;
		PreparedStatement statement = null;
		try {
			con = DatabaseFactory.getInstance().getConnection();
			statement = con.prepareStatement(DELETE_QUERY);
			statement.setInt(1, owner.getObjectId());
			statement.setInt(2, missionId);
			statement.execute();
		} catch (Exception e) {
			_log.warn(owner.getPledgeMissionList() + " could not delete mission: OWNER_ID[" + owner.getObjectId() + "], MISSION_ID[" + missionId + "]:", e);
			return false;
		} finally {
			DbUtils.closeQuietly(con, statement);
		}
		return true;
	}
}
