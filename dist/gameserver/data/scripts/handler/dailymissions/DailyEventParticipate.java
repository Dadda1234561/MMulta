package handler.dailymissions;

import l2s.gameserver.listener.PlayerListener;
import l2s.gameserver.listener.actor.player.OnEventParticipateListener;
import l2s.gameserver.model.Player;
import org.apache.commons.lang3.ArrayUtils;

/**
 * @author sharp
 * https://t.me/sharp1que
 */
public class DailyEventParticipate extends ProgressDailyMissionHandler
{
    protected static final String[] EVENT_NAMES = new String[0];

    private class ListenerHandler implements OnEventParticipateListener
    {
        @Override
        public void onEventParticipate(Player player, String eventName, boolean isWin)
        {
            if (player == null)
            {
                return;
            }

            if (isWin)
            {
                return;
            }

            if (getEventIds().length == 0 || ArrayUtils.contains(getEventIds(), eventName))
            {
                progressMission(player, 1, true, player.getLevel(), player.getRebirthCount());
            }
        }
    }

    private final ListenerHandler _listener = new ListenerHandler();

    protected String[] getEventIds()
    {
        return EVENT_NAMES;
    }

    @Override
    public PlayerListener getListener()
    {
        return _listener;
    }
}
