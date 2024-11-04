package handler.dailymissions;

import l2s.commons.time.cron.SchedulingPattern;
import org.apache.commons.lang3.ArrayUtils;

import l2s.gameserver.listener.CharListener;
import l2s.gameserver.listener.actor.OnKillListener;
import l2s.gameserver.model.Creature;
import l2s.gameserver.model.Player;

public class InstZoneBossKiller extends ProgressDailyMissionHandler
{
    protected static final int[] EMPTY_MONSTER_IDS = new int[0];

    public static final int[] RAID_ARRAY = {
            23777,
            24195,
            24213,
            25937,
            26330,
            40110,
            40111,
            40112,
            40113,
            40114,
            40115,
            19695,
            40109,
            34266,
            18847,
            29046,
            29175,
            40021,
            40020,
            29213,
            40022,
            40023
    };

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
                    if (checkNpcIdInRaidArray(RAID_ARRAY, victim.getNpcId()))
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

    public boolean checkNpcIdInRaidArray(int[] raidArray, int npcId) {
        for (int id : raidArray) {
            if (id == npcId) {
                return true;
            }
        }
        return false;
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
