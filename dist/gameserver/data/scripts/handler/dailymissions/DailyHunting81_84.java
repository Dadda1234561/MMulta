package handler.dailymissions;

import org.apache.commons.lang3.ArrayUtils;

import l2s.gameserver.listener.CharListener;
import l2s.gameserver.listener.actor.OnKillListener;
import l2s.gameserver.model.Creature;
import l2s.gameserver.model.Player;

public class DailyHunting81_84 extends ProgressDailyMissionHandler
{
    protected static final int[] EMPTY_MONSTER_IDS = new int[0];

    private class HandlerListeners implements OnKillListener
    {
        @Override
        public void onKill(Creature actor, Creature victim)
        {
            Player player = actor.getPlayer();
            if (player != null && victim.isMonster())
            {
                if (getMonsterIds().length == 0 || ArrayUtils.contains(getMonsterIds(), victim.getNpcId()))
                {
                    if (victim.getLevel() >= 81 && victim.getLevel() <= 84)
                        progressMission(player, 1, true, player.getLevel(), player.getRebirthCount());
                }
            }
        }

        @Override
        public boolean ignorePetOrSummon()
        {
            return true;
        }
    }

    private final HandlerListeners _handlerListeners = new HandlerListeners();

    protected int[] getMonsterIds()
    {
        return EMPTY_MONSTER_IDS;
    }

    @Override
    public CharListener getListener()
    {
        return _handlerListeners;
    }
}