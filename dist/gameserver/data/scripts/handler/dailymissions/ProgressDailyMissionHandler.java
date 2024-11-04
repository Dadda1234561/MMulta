package handler.dailymissions;

import java.util.Collection;

import org.apache.commons.lang3.ArrayUtils;

import l2s.gameserver.data.xml.holder.DailyMissionsHolder;
import l2s.gameserver.model.Player;
import l2s.gameserver.model.actor.instances.player.DailyMission;
import l2s.gameserver.templates.dailymissions.DailyMissionStatus;
import l2s.gameserver.templates.dailymissions.DailyMissionTemplate;

public abstract class ProgressDailyMissionHandler extends ScriptDailyMissionHandler
{
	private static final int[] BOSS_TEMPLATES = {2011, 2012, 2013, 2014, 2015};

	@Override
	public DailyMissionStatus getStatus(Player player, DailyMission mission)
	{
		if (mission.isCompleted())
			return DailyMissionStatus.COMPLETED;
		if (mission.getCurrentProgress() >= mission.getRequiredProgress())
			return DailyMissionStatus.AVAILABLE;
		return DailyMissionStatus.NOT_AVAILABLE;
	}

	protected void progressMission(Player player, int value, boolean increase, int levelCondition, int rebirthCondition)
	{
		Collection<DailyMissionTemplate> missionTemplates = player.getDailyMissionList().getAvailableMissions();
		int notGettedRewards = 0;
		for (DailyMissionTemplate missionTemplate : missionTemplates)
		{
			if (missionTemplate.getHandler() != this)
				continue;

			DailyMission mission = player.getDailyMissionList().get(missionTemplate);

			if (missionTemplate.getCompletedMission() != 0)
			{
				DailyMissionTemplate completedMissionTemplate = DailyMissionsHolder.getInstance().getMission(missionTemplate.getCompletedMission());
				if (completedMissionTemplate == null)
					continue;

				DailyMission completedMission = player.getDailyMissionList().get(completedMissionTemplate);
				if (completedMission.getStatus() != DailyMissionStatus.COMPLETED)
					continue;
			}

			if ((mission.getStatus() == DailyMissionStatus.AVAILABLE) && mission.getCurrentProgress() >= mission.getRequiredProgress())
				notGettedRewards++;

			if (mission.isCompleted())
				continue;

			int minLevel = missionTemplate.getMinLevel();
			int maxLevel = missionTemplate.getMaxLevel();
			int minRebirth = missionTemplate.getMinRebirth();

			if (levelCondition > 0 && (levelCondition < minLevel || levelCondition > maxLevel))
				continue;

			if (rebirthCondition > 0 && rebirthCondition < minRebirth)
				continue;

			int playerRebirth = player.getRebirthCount();
			if (playerRebirth < minRebirth)
				continue;

			int playerLevel = player.getLevel();
			if (playerLevel < minLevel || playerLevel > maxLevel)
				continue;

			if (increase && canIncrease(player, mission, missionTemplate))
			{
				mission.setValue(mission.getValue() + value);
			}
			else
			{
				if (mission.getValue() == value)
					continue;

				mission.setValue(value);

				//FIXME: Костыль, совместимость после того как им выставилось больше необходимого
				if (mission.getValue() > mission.getRequiredProgress())
					mission.setValue(mission.getRequiredProgress());
			}
		}
		if (notGettedRewards > 0)
			player.sendDailyMissionStatus();
	}



	/** Additional boss damage checks */
	private boolean canIncrease(Player player, DailyMission mission, DailyMissionTemplate template) {
		if (!ArrayUtils.contains(BOSS_TEMPLATES, template.getId())) {
			return true;
		} else {
			return mission.getCurrentProgress() < mission.getRequiredProgress();
		}
	}
}
