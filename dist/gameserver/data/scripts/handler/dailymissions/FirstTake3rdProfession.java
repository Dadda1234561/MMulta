package handler.dailymissions;

import l2s.gameserver.listener.actor.player.OnClassChangeListener;
import l2s.gameserver.model.base.ClassId;

import l2s.gameserver.listener.CharListener;
import l2s.gameserver.model.Player;

import static l2s.gameserver.model.base.ClassLevel.THIRD;

public class FirstTake3rdProfession extends ProgressDailyMissionHandler
{
    private class HandlerListeners implements OnClassChangeListener
    {
        @Override
        public void onClassChange(Player player, ClassId classId, ClassId classId1) {
            if(player.getClassLevel() == THIRD)
            progressMission(player, 1, true, player.getLevel(), player.getRebirthCount());
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
