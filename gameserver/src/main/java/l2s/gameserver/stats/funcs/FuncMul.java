package l2s.gameserver.stats.funcs;

import l2s.gameserver.Config;
import l2s.gameserver.stats.Env;
import l2s.gameserver.stats.StatModifierType;
import l2s.gameserver.stats.Stats;
import l2s.gameserver.templates.StatsSet;

public class FuncMul extends Func
{
	public FuncMul(Stats stat, int order, Object owner, double value, StatsSet params)
	{
		super(stat, order, owner, value, params);
	}

	@Override
	public void calc(Env env, StatModifierType modifierType)
	{
		if (Config.M_SKILL_POWER_MUL_AS_ADD_MODE && Stats.M_SKILL_POWER.equals(stat))
		{
			double newValue = Math.round((value - 1) * 100);
			env.value += newValue;
		}
		else
		{
			env.value *= value;
		}
	}
}
