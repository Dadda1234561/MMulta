package l2s.gameserver.stats.conditions;

import l2s.gameserver.stats.Env;

public class ConditionPlayerMaximumVitalityPoints extends Condition
{
	private final int _vp;

	public ConditionPlayerMaximumVitalityPoints(int points)
	{
		_vp = points;
	}

	@Override
	protected boolean testImpl(Env env)
	{
		return env.character.getPlayer().getVitality() <= _vp;
	}
}