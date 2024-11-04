package handler.dailymissions;

import l2s.commons.time.cron.SchedulingPattern;
import org.apache.commons.lang3.ArrayUtils;

import l2s.gameserver.listener.CharListener;
import l2s.gameserver.listener.actor.OnKillListener;
import l2s.gameserver.model.Creature;
import l2s.gameserver.model.Player;

public class WeeklyHuntingBossMoreLegend extends ProgressDailyMissionHandler
{
    protected static final int[] EMPTY_MONSTER_IDS = new int[0];
    private static final SchedulingPattern REUSE_PATTERN = new SchedulingPattern("30 6 * * 1");

    private class HandlerListeners implements OnKillListener
    {
        @Override
        public void onKill(Creature actor, Creature victim)
        {
            Player player = actor.getPlayer();
            if (player != null && victim.isRaid())
            {
                if (getMonsterIds().length == 0 || ArrayUtils.contains(getMonsterIds(), victim.getNpcId()))
                {
                    if (victim.getLevel() >= 20 && victim.getLevel() <= 120)
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
    public SchedulingPattern getReusePattern()
    {
        return REUSE_PATTERN;
    }

    @Override
    public CharListener getListener()
    {
        return _handlerListeners;
    }
}
