package handler.pledgemissions;

import l2s.gameserver.model.Player;
import l2s.gameserver.model.actor.instances.player.PledgeMission;
import l2s.gameserver.templates.pledgemissions.PledgeMissionStatus;

import java.util.Calendar;

/**
 * @author Bonux
 **/
public class Weekend extends ScriptPledgeMissionHandler {
	@Override
	public PledgeMissionStatus getStatus(Player player, PledgeMission mission) {
		if (mission.isCompleted())
			return PledgeMissionStatus.COMPLETED;

		Calendar currentCalendar = Calendar.getInstance();
		if (currentCalendar.get(Calendar.DAY_OF_WEEK) == Calendar.SATURDAY || currentCalendar.get(Calendar.DAY_OF_WEEK) == Calendar.SUNDAY)
			return PledgeMissionStatus.PROGRESS_DONE;

		return PledgeMissionStatus.IN_PROGRESS;
	}

	@Override
	public int getProgress(Player player, PledgeMission mission) {
		if (getStatus(player, mission) == PledgeMissionStatus.IN_PROGRESS)
			return 0;
		return mission.getRequiredProgress();
	}
}
