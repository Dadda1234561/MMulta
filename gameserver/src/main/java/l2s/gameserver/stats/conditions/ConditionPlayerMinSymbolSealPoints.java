package l2s.gameserver.stats.conditions;

import l2s.gameserver.stats.Env;

/**
 * @author nexvill
 */

public class ConditionPlayerMinSymbolSealPoints extends Condition
{
	private final int _points;

	public ConditionPlayerMinSymbolSealPoints(int points)
	{
		_points = points;
	}

	@Override
	protected boolean testImpl(Env env)
	{
		return env.character.getPlayer().getSymbolSealPoints() <= _points;
	}
}