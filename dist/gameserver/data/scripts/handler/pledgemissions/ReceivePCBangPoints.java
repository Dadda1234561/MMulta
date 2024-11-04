package handler.pledgemissions;

import l2s.gameserver.Config;
import l2s.gameserver.model.Player;
import l2s.gameserver.model.actor.instances.player.PledgeMission;
import l2s.gameserver.templates.pledgemissions.PledgeMissionStatus;

/**
 * @author Bonux
 **/
public class ReceivePCBangPoints extends ProgressPledgeMissionHandler {
	@Override
	public PledgeMissionStatus getStatus(Player player, PledgeMission mission) {
		if (!Config.ALT_PCBANG_POINTS_ENABLED)
			return PledgeMissionStatus.NOT_AVAILABLE;
		return super.getStatus(player, mission);
	}

	@Override
	public int getProgress(Player player, PledgeMission mission) {
		return player.getPcBangPoints();
	}
}
