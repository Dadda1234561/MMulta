package handler.dailymissions;

import org.apache.commons.lang3.ArrayUtils;

import l2s.gameserver.listener.CharListener;
import l2s.gameserver.listener.actor.OnKillListener;
import l2s.gameserver.model.Creature;
import l2s.gameserver.model.Player;

public class FirstKillBossZaken extends ProgressDailyMissionHandler
{
    public static final int ZAKEN = 40109;

    private class HandlerListeners implements OnKillListener
    {
        @Override
        public void onKill(Creature actor, Creature victim)
        {
            Player player = actor.getPlayer();
            if (player != null && victim.getNpcId() == ZAKEN)
            {
               progressMission(player, 1, true, player.getLevel(), player.getRebirthCount());
            }
        }

        @Override
        public boolean ignorePetOrSummon()
        {
            return true;
        }
    }

    @Override
    public boolean isReusable()
    {
        return false;
    }

    private final HandlerListeners _handlerListeners = new HandlerListeners();

    @Override
    public CharListener getListener()
    {
        return _handlerListeners;
    }
}
