package l2s.gameserver.dao;

import l2s.gameserver.model.actor.variables.Variable;

import java.util.Map;

/**
 * @author Bonux (bonuxq@gmail.com)
 * @date 23.09.2019
 **/
public interface IVariablesDAO {
	boolean delete(int clanId, String varName);

	boolean delete(String varName);

	boolean insert(int clanId, Variable var);

	void restore(int clanId, Map<String, Variable> variables);

	String getValue(int clanId, String var);
}
