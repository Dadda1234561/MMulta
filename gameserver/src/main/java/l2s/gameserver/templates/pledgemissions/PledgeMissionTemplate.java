package l2s.gameserver.templates.pledgemissions;

import l2s.gameserver.handler.pledgemissions.IPledgeMissionHandler;
import l2s.gameserver.handler.pledgemissions.PledgeMissionHandlerHolder;
import l2s.gameserver.templates.item.data.ItemData;

import java.util.ArrayList;
import java.util.List;

/**
 * @author Bonux (bonuxq@gmail.com)
 * @date 29.09.2019
 **/
public class PledgeMissionTemplate {
	private final int id;
	private final IPledgeMissionHandler handler;
	private final PledgeMissionCategory category;
	private final boolean repeatable;
	private final int minPledgeLevel;
	private final int pledgeMastery;
	private final int minPlayerLevel;
	private final int maxPlayerLevel;
	private final boolean mainClass;
	private final boolean dualClass;
	private final boolean subClass;
	private final boolean isAllLvl;
	private final int previousMissionId;
	private final int startDate;
	private final int startTime;
	private final int endDate;
	private final int endTime;
	private final int activateTime;
	private final int deactivateTime;
	private final int unk;
	private final int[] availableDay;
	private final int goalCount;
	private final int clanReputationReward;
	private final int fameReward;
	private final List<ItemData> rewardItems = new ArrayList<>();

	public PledgeMissionTemplate(int id, String handler, PledgeMissionCategory category, boolean repeatable, int minPledgeLevel, int pledgeMastery, int minPlayerLevel, int maxPlayerLevel, boolean mainClass, boolean dualClass, boolean subClass, boolean isAllLvl, int previousMissionId, int startDate, int startTime, int endDate, int endTime, int activateTime, int deactivateTime, int unk, int[] availableDay, int goalCount, int clanReputationReward, int fameReward) {
		this.id = id;
		this.handler = PledgeMissionHandlerHolder.getInstance().getHandler(handler);
		this.category = category;
		this.repeatable = repeatable;
		this.minPledgeLevel = minPledgeLevel;
		this.pledgeMastery = pledgeMastery;
		this.minPlayerLevel = minPlayerLevel;
		this.maxPlayerLevel = maxPlayerLevel;
		this.mainClass = mainClass;
		this.dualClass = dualClass;
		this.subClass = subClass;
		this.isAllLvl = isAllLvl;
		this.previousMissionId = previousMissionId;
		this.startDate = startDate;
		this.startTime = startTime;
		this.endDate = endDate;
		this.endTime = endTime;
		this.activateTime = activateTime;
		this.deactivateTime = deactivateTime;
		this.unk = unk;
		this.availableDay = availableDay;
		this.goalCount = goalCount;
		this.clanReputationReward = clanReputationReward;
		this.fameReward = fameReward;
	}

	public int getId() {
		return id;
	}

	public IPledgeMissionHandler getHandler() {
		return handler;
	}

	public PledgeMissionCategory getCategory() {
		return category;
	}

	public boolean isRepeatable() {
		return repeatable;
	}

	public int getMinPledgeLevel() {
		return minPledgeLevel;
	}

	public int getPledgeMastery() {
		return pledgeMastery;
	}

	public int getMinPlayerLevel() {
		return minPlayerLevel;
	}

	public int getMaxPlayerLevel() {
		return maxPlayerLevel;
	}

	public boolean isMainClass() {
		return mainClass;
	}

	public boolean isDualClass() {
		return dualClass;
	}

	public boolean isSubClass() {
		return subClass;
	}

	public boolean isAllLvl() {
		return isAllLvl;
	}

	public int getPreviousMissionId() {
		return previousMissionId;
	}

	public int getStartDate() {
		return startDate;
	}

	public int getStartTime() {
		return startTime;
	}

	public int getEndDate() {
		return endDate;
	}

	public int getEndTime() {
		return endTime;
	}

	public int getActivateTime() {
		return activateTime;
	}

	public int getDeactivateTime() {
		return deactivateTime;
	}

	public int getUnk() {
		return unk;
	}

	public int[] getAvailableDay() {
		return availableDay;
	}

	public int getGoalCount() {
		return goalCount;
	}

	public int getClanReputationReward() {
		return clanReputationReward;
	}

	public int getFameReward() {
		return fameReward;
	}

	public List<ItemData> getRewardItems() {
		return rewardItems;
	}
}
