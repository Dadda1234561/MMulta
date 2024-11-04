package handler.dailymissions;

import l2s.gameserver.listener.CharListener;
import l2s.gameserver.listener.actor.OnKillListener;
import l2s.gameserver.model.Creature;
import l2s.gameserver.model.Player;

public class DailyHuntingPlayersPk extends ProgressDailyMissionHandler
{
    private class HandlerListeners implements OnKillListener
    {
        @Override
        public void onKill(Creature actor, Creature victim)
        {
            Player player = actor.getPlayer();
            if (player != null && victim.isPlayer())
            {
                if (victim.getKarma() == 0 && victim.getPvpFlag() == 0)
                    progressMission(player, 1, true, player.getLevel(), player.getRebirthCount());
            }
        }

        @Override
        public boolean ignorePetOrSummon()
        {
            return true;
        }
    }

    private final HandlerListeners _handlerListeners = new HandlerListeners();

    @Override
    public CharListener getListener()
    {
        return _handlerListeners;
    }
}
