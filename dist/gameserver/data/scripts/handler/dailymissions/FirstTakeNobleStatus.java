package handler.dailymissions;

import l2s.gameserver.model.Player;
import l2s.gameserver.model.actor.instances.player.DailyMission;

public class FirstTakeNobleStatus extends ProgressDailyMissionHandler
{
    @Override
    public int getProgress(Player player, DailyMission mission)
    {
        return player.isNoble() ? 1 : 0;
    }

    @Override
    public boolean isReusable()
    {
        return false;
    }
}
