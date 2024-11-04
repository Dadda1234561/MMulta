package l2s.gameserver.stats.conditions;

import l2s.gameserver.model.Player;
import l2s.gameserver.stats.Env;

public class ConditionPlayerFightClub extends Condition {

    private final boolean _value;

    public ConditionPlayerFightClub(boolean v)
    {
        _value = v;
    }

    @Override
    protected boolean testImpl(Env env)
    {
        final Player player = env.character.getPlayer();
        if(player != null)
        {
            if(player.isInCtF())
                return false;
            return player.isInFightClub() == _value;
        }
        return !_value;
    }

}
