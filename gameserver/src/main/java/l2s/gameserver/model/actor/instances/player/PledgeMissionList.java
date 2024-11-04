package l2s.gameserver.model.actor.instances.player;

import l2s.commons.time.cron.SchedulingPattern;
import l2s.gameserver.dao.CharacterPledgeMissionsDAO;
import l2s.gameserver.data.xml.holder.PledgeMissionsHolder;
import l2s.gameserver.model.Player;
import l2s.gameserver.model.actor.variables.PlayerVariables;
import l2s.gameserver.model.pledge.Clan;
import l2s.gameserver.network.l2.components.SystemMsg;
import l2s.gameserver.templates.pledgemissions.PledgeMissionCategory;
import l2s.gameserver.templates.pledgemissions.PledgeMissionStatus;
import l2s.gameserver.templates.pledgemissions.PledgeMissionTemplate;
import l2s.gameserver.utils.ItemFunctions;

import java.util.*;
import java.util.concurrent.locks.Lock;
import java.util.concurrent.locks.ReentrantLock;

/**
 * @author Bonux (bonuxq@gmail.com)
 * @date 29.09.2019
 **/
public class PledgeMissionList {
	private static String DONE_MISSIONS_COUNT_VAR = "done_missions_count";
	private static SchedulingPattern RESET_DONE_MISSIONS_COUNTER_PATTERN = new SchedulingPattern("30 6 * * 3");

	private final Player owner;
	private final Map<Integer, PledgeMission> missions = new HashMap<>();

	private final Lock lock = new ReentrantLock();

	public PledgeMissionList(Player owner) {
		this.owner = owner;
	}

	public void restore() {
		CharacterPledgeMissionsDAO.getInstance().restore(owner, missions);
	}

	public void store() {
		CharacterPledgeMissionsDAO.getInstance().store(owner, values());
	}

	public Collection<PledgeMission> values() {
		lock.lock();
		try {
			return missions.values();
		} finally {
			lock.unlock();
		}
	}

	public PledgeMission get(PledgeMissionTemplate missionTemplate) {
		lock.lock();
		try {
			PledgeMission mission = missions.get(missionTemplate.getId());
			if (mission == null) {
				mission = new PledgeMission(owner, missionTemplate, false, 0);
				missions.put(mission.getId(), mission);
			}
			return mission;
		} finally {
			lock.unlock();
		}
	}

	public PledgeMissionStatus getStatus(PledgeMissionTemplate template) {
		return get(template).getStatus();
	}

	public PledgeMissionStatus getStatus(int missionId) {
		PledgeMissionTemplate template = PledgeMissionsHolder.getInstance().getMission(missionId);
		if (template == null)
			return PledgeMissionStatus.NOT_AVAILABLE;
		return getStatus(template);
	}

	public Collection<PledgeMissionTemplate> getAvailableMissions() {
		List<PledgeMissionTemplate> missions = new ArrayList<>();
		if (getAvailableMissionsCount() > getDoneMissionsCount())
			missions.addAll(PledgeMissionsHolder.getInstance().getMissions(PledgeMissionCategory.GENERAL));
		missions.addAll(PledgeMissionsHolder.getInstance().getMissions(PledgeMissionCategory.INTENSIVE));
		missions.addAll(PledgeMissionsHolder.getInstance().getMissions(PledgeMissionCategory.ACHIEVEMENT));
		missions.addAll(PledgeMissionsHolder.getInstance().getMissions(PledgeMissionCategory.EVENT));
		return missions;
	}

	public boolean complete(int missionId) {
		lock.lock();
		try {
			Clan clan = owner.getClan();
			if (clan == null)
				return false;

			PledgeMissionTemplate missionTemplate = PledgeMissionsHolder.getInstance().getMission(missionId);
			if (missionTemplate == null)
				return false;

			PledgeMission mission = get(missionTemplate);
			if (!mission.isAvailable() || mission.getStatus() == PledgeMissionStatus.COMPLETED)
				return false;

			if (owner.getWeightPenalty() >= 3 || owner.getInventoryLimit() * 0.8 < owner.getInventory().getSize()) {
				owner.sendPacket(SystemMsg.YOUR_INVENTORY_IS_FULL);
				return false;
			}

			int missionValue = mission.getValue();

			mission.setValue((int) (System.currentTimeMillis() / 1000));
			mission.setCompleted(true);

			if (!CharacterPledgeMissionsDAO.getInstance().insert(owner, mission)) {
				mission.setValue(missionValue);
				mission.setCompleted(false);
				return false;
			}

			int fameReward = missionTemplate.getFameReward();
			if (fameReward > 0)
				owner.setFame(owner.getFame() + fameReward, String.format("Pledge mission ID[%d] reward.", missionTemplate.getId()), true);

			int clanReputationReward = missionTemplate.getClanReputationReward();
			if (clanReputationReward > 0)
				clan.incReputation(clanReputationReward, true, String.format("Pledge mission ID[%d] reward.", missionTemplate.getId()));

			missionTemplate.getRewardItems().forEach((i) -> ItemFunctions.addItem(owner, i.getId(), i.getCount()));

			if (missionTemplate.getCategory() == PledgeMissionCategory.GENERAL)
				owner.setVar(DONE_MISSIONS_COUNT_VAR, getDoneMissionsCount() + 1, RESET_DONE_MISSIONS_COUNTER_PATTERN.next(System.currentTimeMillis()));
			
			int currentRep = owner.getVarInt(PlayerVariables.CURRENT_REPUTATION, 0);
			int totalRep = owner.getVarInt(PlayerVariables.TOTAL_REPUTATION, 0);
			owner.setVar(PlayerVariables.CURRENT_REPUTATION, currentRep + clanReputationReward);
			owner.setVar(PlayerVariables.TOTAL_REPUTATION, totalRep + clanReputationReward);
			return true;
		} finally {
			lock.unlock();
		}
	}

	public int getDoneMissionsCount() {
		return owner.getVarInt(DONE_MISSIONS_COUNT_VAR, 0);
	}

	public int getAvailableMissionsCount() {
		if (owner.isHonorableNoble())
			return 20;
		if (owner.isNoble())
			return 18;
		return 16;
	}

	@Override
	public String toString() {
		return "PledgeMissionList[owner=" + owner.getName() + "]";
	}
}
