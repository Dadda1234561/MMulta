package l2s.gameserver.dao;

import l2s.commons.dbutils.DbUtils;
import l2s.gameserver.database.DatabaseFactory;
import l2s.gameserver.model.actor.variables.Variable;
import l2s.gameserver.utils.Strings;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.Map;

/**
 * @author Bonux (bonuxq@gmail.com)
 * @date 23.09.2019
 **/
public class ClanVariablesDAO implements IVariablesDAO {
	private static final Logger _log = LoggerFactory.getLogger(ClanVariablesDAO.class);
	private static final ClanVariablesDAO _instance = new ClanVariablesDAO();

	public static final String SELECT_SQL_QUERY = "SELECT name, value, expire_time FROM clan_variables WHERE clan_id = ?";
	public static final String SELECT_FROM_PLAYER_SQL_QUERY = "SELECT value, expire_time FROM clan_variables WHERE clan_id = ? AND name = ?";
	public static final String DELETE_SQL_QUERY = "DELETE FROM clan_variables WHERE clan_id = ? AND name = ? LIMIT 1";
	public static final String DELETE_ALL_SQL_QUERY = "DELETE FROM clan_variables WHERE name = ?";
	public static final String DELETE_EXPIRED_SQL_QUERY = "DELETE FROM clan_variables WHERE expire_time > 0 AND expire_time < ?";
	public static final String INSERT_SQL_QUERY = "REPLACE INTO clan_variables (clan_id, name, value, expire_time) VALUES (?,?,?,?)";

	public ClanVariablesDAO() {
		deleteExpiredVars();
	}

	public static ClanVariablesDAO getInstance() {
		return _instance;
	}

	private void deleteExpiredVars() {
		Connection con = null;
		PreparedStatement statement = null;
		try {
			con = DatabaseFactory.getInstance().getConnection();
			statement = con.prepareStatement(DELETE_EXPIRED_SQL_QUERY);
			statement.setLong(1, System.currentTimeMillis());
			statement.execute();
		} catch (final Exception e) {
			_log.error("ClanVariablesDAO:deleteExpiredVars()", e);
		} finally {
			DbUtils.closeQuietly(con, statement);
		}
	}

	@Override
	public boolean delete(int clanId, String varName) {
		Connection con = null;
		PreparedStatement statement = null;
		try {
			con = DatabaseFactory.getInstance().getConnection();
			statement = con.prepareStatement(DELETE_SQL_QUERY);
			statement.setInt(1, clanId);
			statement.setString(2, varName);
			statement.execute();
		} catch (final Exception e) {
			_log.error("ClanVariablesDAO:delete(clanId,varName)", e);
			return false;
		} finally {
			DbUtils.closeQuietly(con, statement);
		}
		return true;
	}

	@Override
	public boolean delete(String varName) {
		Connection con = null;
		PreparedStatement statement = null;
		try {
			con = DatabaseFactory.getInstance().getConnection();
			statement = con.prepareStatement(DELETE_ALL_SQL_QUERY);
			statement.setString(1, varName);
			statement.execute();
		} catch (final Exception e) {
			_log.error("ClanVariablesDAO:delete(varName)", e);
			return false;
		} finally {
			DbUtils.closeQuietly(con, statement);
		}
		return true;
	}

	@Override
	public boolean insert(int clanId, Variable var) {
		Connection con = null;
		PreparedStatement statement = null;
		try {
			con = DatabaseFactory.getInstance().getConnection();
			statement = con.prepareStatement(INSERT_SQL_QUERY);
			statement.setInt(1, clanId);
			statement.setString(2, var.getName());
			statement.setString(3, var.getValue());
			statement.setLong(4, var.getExpireTime());
			statement.executeUpdate();
		} catch (final Exception e) {
			_log.error("ClanVariablesDAO:insert(clanId,var)", e);
			return false;
		} finally {
			DbUtils.closeQuietly(con, statement);
		}
		return true;
	}

	@Override
	public void restore(int clanId, Map<String, Variable> variables) {
		Connection con = null;
		PreparedStatement statement = null;
		ResultSet rset = null;
		try {
			con = DatabaseFactory.getInstance().getConnection();
			statement = con.prepareStatement(SELECT_SQL_QUERY);
			statement.setInt(1, clanId);
			rset = statement.executeQuery();
			while (rset.next()) {
				long expireTime = rset.getLong("expire_time");
				if (expireTime > 0 && expireTime < System.currentTimeMillis())
					continue;

				Variable variable = new Variable(rset.getString("name"), Strings.stripSlashes(rset.getString("value")), expireTime);
				variables.put(variable.getName(), variable);
			}
		} catch (Exception e) {
			_log.error("ClanVariablesDAO:restore(clanId,variables)", e);
		} finally {
			DbUtils.closeQuietly(con, statement, rset);
		}
	}

	@Override
	public String getValue(int clanId, String var) {
		String value = null;

		Connection con = null;
		PreparedStatement statement = null;
		ResultSet rset = null;
		try {
			con = DatabaseFactory.getInstance().getConnection();
			statement = con.prepareStatement(SELECT_FROM_PLAYER_SQL_QUERY);
			statement.setInt(1, clanId);
			statement.setString(2, var);
			rset = statement.executeQuery();
			if (rset.next()) {
				long expireTime = rset.getLong("expire_time");
				if (expireTime <= 0 || expireTime >= System.currentTimeMillis())
					value = Strings.stripSlashes(rset.getString("value"));
			}
		} catch (Exception e) {
			_log.error("ClanVariablesDAO:getVarFromClan(clanId,var)", e);
		} finally {
			DbUtils.closeQuietly(con, statement, rset);
		}
		return value;
	}
}
