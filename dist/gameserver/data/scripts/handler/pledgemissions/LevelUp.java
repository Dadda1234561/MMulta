package handler.pledgemissions;

import l2s.gameserver.model.Player;
import l2s.gameserver.model.actor.instances.player.PledgeMission;

public class LevelUp extends ProgressPledgeMissionHandler
{
	@Override
	public int getProgress(Player player, PledgeMission mission)
	{
		return player.getBaseDualClass().getLevel();
	}
}
