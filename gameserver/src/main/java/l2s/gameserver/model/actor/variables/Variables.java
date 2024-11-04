package l2s.gameserver.model.actor.variables;

import l2s.gameserver.dao.IVariablesDAO;

import java.util.Collection;
import java.util.Iterator;
import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;

/**
 * @author Bonux (bonuxq@gmail.com)
 * @date 23.09.2019
 **/
public abstract class Variables implements Iterable<Variable> {
	protected final Map<String, Variable> variables = new ConcurrentHashMap<>();

	protected abstract IVariablesDAO getDAO();

	protected abstract int getOwnerId();

	@Override
	public Iterator<Variable> iterator() {
		return variables.values().iterator();
	}

	public void restore() {
		getDAO().restore(getOwnerId(), variables);
	}

	public Collection<Variable> values() {
		return variables.values();
	}

	public Variable get(String name) {
		return variables.get(name);
	}

	public boolean set(String name, Object value) {
		return set(name, value, -1);
	}

	public boolean set(String name, Object value, long expirationTime) {
		Variable var = new Variable(name, String.valueOf(value), expirationTime);
		if (getDAO().insert(getOwnerId(), var)) {
			variables.put(name, var);
			return true;
		}
		return true;
	}

	public boolean unset(String name) {
		if (name == null || name.isEmpty())
			return false;
		if (variables.containsKey(name) && getDAO().delete(getOwnerId(), name))
			return variables.remove(name) != null;
		return false;
	}

	public String getString(String name) {
		return getString(name, null);
	}

	public String getString(String name, String defaultValue) {
		Variable var = get(name);
		if (var != null && !var.isExpired())
			return var.getValue();
		return defaultValue;
	}

	public long getExpireTime(String name) {
		Variable var = get(name);
		if (var != null)
			return var.getExpireTime();
		return 0;
	}

	public int getInt(String name) {
		return getInt(name, 0);
	}

	public int getInt(String name, int defaultValue) {
		String var = getString(name);
		if (var != null)
			return Integer.parseInt(var);
		return defaultValue;
	}

	public long getLong(String name) {
		return getLong(name, 0L);
	}

	public long getLong(String name, long defaultValue) {
		String var = getString(name);
		if (var != null)
			return Long.parseLong(var);
		return defaultValue;
	}

	public double getDouble(String name) {
		return getDouble(name, 0.);
	}

	public double getDouble(String name, double defaultValue) {
		String var = getString(name);
		if (var != null)
			return Double.parseDouble(var);
		return defaultValue;
	}

	public boolean getBoolean(String name) {
		return getBoolean(name, false);
	}

	public boolean getBoolean(String name, boolean defaultValue) {
		String var = getString(name);
		if (var != null)
			return !(var.equals("0") || var.equalsIgnoreCase("false"));
		return defaultValue;
	}
}
