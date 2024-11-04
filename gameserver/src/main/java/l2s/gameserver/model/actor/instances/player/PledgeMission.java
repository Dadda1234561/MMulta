package l2s.gameserver.model.actor.instances.player;

import l2s.gameserver.dao.CharacterPledgeMissionsDAO;
import l2s.gameserver.model.Player;
import l2s.gameserver.model.pledge.Clan;
import l2s.gameserver.templates.pledgemissions.PledgeMissionCategory;
import l2s.gameserver.templates.pledgemissions.PledgeMissionStatus;
import l2s.gameserver.templates.pledgemissions.PledgeMissionTemplate;
import org.apache.commons.lang3.ArrayUtils;

import java.util.Calendar;

/**
 * @author Bonux (bonuxq@gmail.com)
 * @date 29.09.2019
 **/
public class PledgeMission implements Comparable<PledgeMission> {
	private final Player owner;
	private final PledgeMissionTemplate template;
	private final boolean finallyCompleted;
	private boolean completed;
	private int value;

	public PledgeMission(Player owner, PledgeMissionTemplate template, boolean completed, int value) {
		this.owner = owner;
		this.template = template;
		this.completed = completed;
		this.value = value;
		finallyCompleted = completed && !this.template.isRepeatable(); // После рестарта не отображаем окончательно завершенные задания.
	}

	public int getId() {
		return template.getId();
	}

	public PledgeMissionTemplate getTemplate() {
		return template;
	}

	public void setCompleted(boolean value) {
		completed = value;
	}

	public boolean isCompleted() {
		if (completed) {
			if (template.isRepeatable()) {
				int value = getValue();
				long reuseTime = template.getHandler().getReusePattern().next(value * 1000L);
				if (reuseTime <= System.currentTimeMillis()) {
					setValue(0);
					setCompleted(false);
					if (!CharacterPledgeMissionsDAO.getInstance().insert(owner, this)) {
						setValue(value);
						setCompleted(true);
						return true;
					}
					return false;
				}
			}
			return true;
		}
		return false;
	}

	public boolean isFinallyCompleted() {
		return finallyCompleted;
	}

	public void setValue(int value) {
		this.value = value;
	}

	public int getValue() {
		return value;
	}

	public PledgeMissionStatus getStatus() {
		Clan clan = owner.getClan();
		if (clan == null)
			return PledgeMissionStatus.NOT_AVAILABLE;
		if (template.getCategory() == PledgeMissionCategory.EVENT) // TODO: Покачто отключим.
			return PledgeMissionStatus.NOT_AVAILABLE;
		if (template.getCategory() == PledgeMissionCategory.GENERAL) {
			if (owner.getPledgeMissionList().getDoneMissionsCount() >= owner.getPledgeMissionList().getAvailableMissionsCount())
				return PledgeMissionStatus.NOT_AVAILABLE;
		}
		if (template.getMinPledgeLevel() > 0 && clan.getLevel() < template.getMinPledgeLevel())
			return PledgeMissionStatus.NOT_AVAILABLE;
		if (template.getPledgeMastery() > 0 && !clan.hasMastery(template.getPledgeMastery()))
			return PledgeMissionStatus.NOT_AVAILABLE;
		if (!template.isAllLvl() && (template.getMinPlayerLevel() > 0 && owner.getLevel() < template.getMinPlayerLevel()))
			return PledgeMissionStatus.NOT_AVAILABLE;
		if (!template.isAllLvl() && (template.getMaxPlayerLevel() > 0 && owner.getLevel() > template.getMaxPlayerLevel()))
			return PledgeMissionStatus.NOT_AVAILABLE;
		if (owner.isBaseClassActive() && !template.isMainClass())
			return PledgeMissionStatus.NOT_AVAILABLE;
		if (owner.isDualClassActive() && !template.isDualClass())
			return PledgeMissionStatus.NOT_AVAILABLE;
		if (!owner.isBaseClassActive() && !owner.isDualClassActive() && !template.isSubClass())
			return PledgeMissionStatus.NOT_AVAILABLE;
		if (template.getAvailableDay().length > 0 && !ArrayUtils.contains(template.getAvailableDay(), Calendar.getInstance().get(Calendar.DAY_OF_WEEK)))
			return PledgeMissionStatus.NOT_AVAILABLE;
		if (template.getPreviousMissionId() > 0) {
			PledgeMissionStatus prevMissionStatus = owner.getPledgeMissionList().getStatus(template.getPreviousMissionId());
			if (prevMissionStatus != PledgeMissionStatus.COMPLETED)
				return PledgeMissionStatus.NOT_AVAILABLE;
		}
		return template.getHandler().getStatus(owner, this);
	}

	public boolean isAvailable() {
		return getStatus() != PledgeMissionStatus.NOT_AVAILABLE;
	}

	public int getRequiredProgress() {
		return template.getGoalCount();
	}

	public int getCurrentProgress() {
		if (isCompleted())
			return getRequiredProgress();
		return template.getHandler().getProgress(owner, this);
	}

	@Override
	public String toString() {
		return "PledgeMission[id=" + template.getId() + ", completed=" + completed + ", value=" + value + "]";
	}

	@Override
	public int compareTo(PledgeMission o) {
		return getId() - o.getId();
	}
}