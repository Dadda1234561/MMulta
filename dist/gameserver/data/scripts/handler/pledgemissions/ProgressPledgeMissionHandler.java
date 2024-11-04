package handler.pledgemissions;

import l2s.gameserver.model.Player;
import l2s.gameserver.model.PlayerGroup;
import l2s.gameserver.model.actor.instances.player.PledgeMission;
import l2s.gameserver.templates.pledgemissions.PledgeMissionStatus;
import l2s.gameserver.templates.pledgemissions.PledgeMissionTemplate;

import java.util.Collection;

/**
 * @author Bonux (bonuxq@gmail.com)
 * @date 29.09.2019
 **/
public abstract class ProgressPledgeMissionHandler extends ScriptPledgeMissionHandler {
	@Override
	public PledgeMissionStatus getStatus(Player player, PledgeMission mission) {
		if (mission.isCompleted())
			return PledgeMissionStatus.COMPLETED;
		if (mission.getCurrentProgress() >= mission.getRequiredProgress())
			return PledgeMissionStatus.PROGRESS_DONE;
		return PledgeMissionStatus.IN_PROGRESS;
	}

	protected void progressMission(Player player, int value, boolean increase, int levelCondition) {
		Collection<PledgeMissionTemplate> missionTemplates = player.getPledgeMissionList().getAvailableMissions();
		for (PledgeMissionTemplate missionTemplate : missionTemplates) {
			if (missionTemplate.getHandler() != this)
				continue;

			for(Player member : getProgressPlayerGroup(player))
				progressMission0(member, value, increase, levelCondition, missionTemplate);
		}
	}

	private boolean progressMission0(Player player, int value, boolean increase, int levelCondition, PledgeMissionTemplate missionTemplate) {
		PledgeMission mission = player.getPledgeMissionList().get(missionTemplate);
		if (!mission.isAvailable())
			return false;

		int minLevel = missionTemplate.getMinPlayerLevel();
		int maxLevel = missionTemplate.getMaxPlayerLevel();
		if (levelCondition > 0 && (minLevel > 0 && levelCondition < minLevel || maxLevel > 0 && levelCondition > maxLevel))
			return false;

		if (increase) {
			mission.setValue(mission.getValue() + value);
		} else {
			if (mission.getValue() != value)
				mission.setValue(value);
		}
		return true;
	}

	protected PlayerGroup getProgressPlayerGroup(Player player) {
		return player;
	}
}
