package l2s.gameserver.stats.conditions;

import l2s.gameserver.stats.Env;

public class ConditionPlayerMaximumRandomCraftPoints extends Condition
{
    private final int _randomCraftPoints;

    public ConditionPlayerMaximumRandomCraftPoints(int points)
    {
        _randomCraftPoints = points;
    }

    @Override
    protected boolean testImpl(Env env)
    {
        return env.character.getPlayer().getCraftGaugePoints() <= _randomCraftPoints;
    }
}