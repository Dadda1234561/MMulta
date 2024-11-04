package handler.dailymissions;

import l2s.gameserver.listener.CharListener;
import l2s.gameserver.listener.actor.player.OnEventParticipateListener;
import l2s.gameserver.model.Player;
import org.apache.commons.lang3.ArrayUtils;

/**
 * @author sharp
 * https://t.me/sharp1que
 */
public class DailyEventFinish extends ProgressDailyMissionHandler
{
    /* TvT, CTF, Cat Royal */
    protected static final String[] EVENT_NAMES = new String[] {"TvT", "CtF", "Cat Royal"};

    private class ListenerHandler implements OnEventParticipateListener
    {
        @Override
        public void onEventParticipate(Player player, String eventName, boolean isWin)
        {
            if (player == null)
            {
                return;
            }

            if (!isWin)
            {
                return;
            }

            if (getEventNames().length == 0 || ArrayUtils.contains(getEventNames(), eventName))
            {
                progressMission(player, 1, true, player.getLevel(), player.getRebirthCount());
            }
        }
    }

    protected String[] getEventNames()
    {
        return EVENT_NAMES;
    }

    private final ListenerHandler _listener = new ListenerHandler();

    @Override
    public CharListener getListener()
    {
        return _listener;
    }
}
