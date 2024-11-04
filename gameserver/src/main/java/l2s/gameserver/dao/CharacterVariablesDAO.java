package l2s.gameserver.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.Map;

import l2s.commons.dbutils.DbUtils;
import l2s.gameserver.database.DatabaseFactory;
import l2s.gameserver.model.actor.variables.Variable;
import l2s.gameserver.utils.Strings;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

/**
 * @author Bonux
 */
public class CharacterVariablesDAO implements IVariablesDAO
{
	private static final Logger _log = LoggerFactory.getLogger(CharacterVariablesDAO.class);
	private static final CharacterVariablesDAO _instance = new CharacterVariablesDAO();

	public static final String SELECT_SQL_QUERY = "SELECT name, value, expire_time FROM character_variables WHERE obj_id = ?";
	public static final String SELECT_FROM_PLAYER_SQL_QUERY = "SELECT value, expire_time FROM character_variables WHERE obj_id = ? AND name = ?";
	public static final String DELETE_SQL_QUERY = "DELETE FROM character_variables WHERE obj_id = ? AND name = ? LIMIT 1";
	public static final String DELETE_ALL_SQL_QUERY = "DELETE FROM character_variables WHERE name = ?";
	public static final String DELETE_EXPIRED_SQL_QUERY = "DELETE FROM character_variables WHERE expire_time > 0 AND expire_time < ?";
	public static final String INSERT_SQL_QUERY = "REPLACE INTO character_variables (obj_id, name, value, expire_time) VALUES (?,?,?,?)";

	public CharacterVariablesDAO()
	{
		deleteExpiredVars();
	}

	public static CharacterVariablesDAO getInstance()
	{
		return _instance;
	}

	private void deleteExpiredVars()
	{
		Connection con = null;
		PreparedStatement statement = null;
		try
		{
			con = DatabaseFactory.getInstance().getConnection();
			statement = con.prepareStatement(DELETE_EXPIRED_SQL_QUERY);
			statement.setLong(1, System.currentTimeMillis());
			statement.execute();
		}
		catch(final Exception e)
		{
			_log.error("CharacterVariablesDAO:deleteExpiredVars()", e);
		}
		finally
		{
			DbUtils.closeQuietly(con, statement);
		}
	}

	@Override
	public boolean delete(int playerObjId, String varName)
	{
		Connection con = null;
		PreparedStatement statement = null;
		try
		{
			con = DatabaseFactory.getInstance().getConnection();
			statement = con.prepareStatement(DELETE_SQL_QUERY);
			statement.setInt(1, playerObjId);
			statement.setString(2, varName);
			statement.execute();
		}
		catch(final Exception e)
		{
			_log.error("CharacterVariablesDAO:delete(playerObjId,varName)", e);
			return false;
		}
		finally
		{
			DbUtils.closeQuietly(con, statement);
		}
		return true;
	}

	@Override
	public boolean delete(String varName)
	{
		Connection con = null;
		PreparedStatement statement = null;
		try
		{
			con = DatabaseFactory.getInstance().getConnection();
			statement = con.prepareStatement(DELETE_ALL_SQL_QUERY);
			statement.setString(1, varName);
			statement.execute();
		}
		catch(final Exception e)
		{
			_log.error("CharacterVariablesDAO:delete(varName)", e);
			return false;
		}
		finally
		{
			DbUtils.closeQuietly(con, statement);
		}
		return true;
	}

	@Override
	public boolean insert(int playerObjId, Variable var)
	{
		Connection con = null;
		PreparedStatement statement = null;
		try
		{
			con = DatabaseFactory.getInstance().getConnection();
			statement = con.prepareStatement(INSERT_SQL_QUERY);
			statement.setInt(1, playerObjId);
			statement.setString(2, var.getName());
			statement.setString(3, var.getValue());
			statement.setLong(4, var.getExpireTime());
			statement.executeUpdate();
		}
		catch(final Exception e)
		{
			_log.error("CharacterVariablesDAO:insert(playerObjId,var)", e);
			return false;
		}
		finally
		{
			DbUtils.closeQuietly(con, statement);
		}
		return true;
	}

	@Override
	public void restore(int playerObjId, Map<String, Variable> variables)
	{
		Connection con = null;
		PreparedStatement statement = null;
		ResultSet rset = null;
		try
		{
			con = DatabaseFactory.getInstance().getConnection();
			statement = con.prepareStatement(SELECT_SQL_QUERY);
			statement.setInt(1, playerObjId);
			rset = statement.executeQuery();
			while(rset.next())
			{
				long expireTime = rset.getLong("expire_time");
				if(expireTime > 0 && expireTime < System.currentTimeMillis())
					continue;

				Variable variable = new Variable(rset.getString("name"), Strings.stripSlashes(rset.getString("value")), expireTime);
				variables.put(variable.getName(), variable);
			}
		}
		catch(Exception e)
		{
			_log.error("CharacterVariablesDAO:restore(playerObjId,variables)", e);
		}
		finally
		{
			DbUtils.closeQuietly(con, statement, rset);
		}
	}

	@Override
	public String getValue(int playerObjId, String var)
	{
		String value = null;

		Connection con = null;
		PreparedStatement statement = null;
		ResultSet rset = null;
		try
		{
			con = DatabaseFactory.getInstance().getConnection();
			statement = con.prepareStatement(SELECT_FROM_PLAYER_SQL_QUERY);
			statement.setInt(1, playerObjId);
			statement.setString(2, var);
			rset = statement.executeQuery();
			if(rset.next())
			{
				long expireTime = rset.getLong("expire_time");
				if(expireTime <= 0 || expireTime >= System.currentTimeMillis())
					value = Strings.stripSlashes(rset.getString("value"));
			}
		}
		catch(Exception e)
		{
			_log.error("CharacterVariablesDAO:getValue(playerObjId,var)", e);
		}
		finally
		{
			DbUtils.closeQuietly(con, statement, rset);
		}
		return value;
	}
}
