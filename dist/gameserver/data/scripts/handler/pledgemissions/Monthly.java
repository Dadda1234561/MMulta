package handler.pledgemissions;

import l2s.commons.time.cron.SchedulingPattern;
import l2s.gameserver.model.Player;
import l2s.gameserver.model.actor.instances.player.PledgeMission;
import l2s.gameserver.templates.pledgemissions.PledgeMissionStatus;

/**
 * @author Bonux
 **/
public class Monthly extends ScriptPledgeMissionHandler {
	private static final SchedulingPattern REUSE_PATTERN = new SchedulingPattern("30 6 1 * *");

	@Override
	public PledgeMissionStatus getStatus(Player player, PledgeMission mission) {
		if (mission.isCompleted())
			return PledgeMissionStatus.COMPLETED;
		return PledgeMissionStatus.PROGRESS_DONE;
	}

	@Override
	public SchedulingPattern getReusePattern() {
		return REUSE_PATTERN;
	}

	@Override
	public int getProgress(Player player, PledgeMission mission) {
		if (getStatus(player, mission) == PledgeMissionStatus.IN_PROGRESS)
			return 0;
		return mission.getRequiredProgress();
	}
}
