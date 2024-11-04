package l2s.gameserver.model;

import l2s.gameserver.model.actor.instances.creature.Abnormal;
import l2s.gameserver.network.l2.s2c.ExAlterSkillRequest;
import l2s.gameserver.skills.SkillEntry;

import java.util.Set;
import java.util.concurrent.CopyOnWriteArraySet;

/**
 * @author Bonux
 */
public class SkillChain {
	private final Abnormal abnormal;
	private final SkillEntry skillEntry;
	private final Set<Player> casters = new CopyOnWriteArraySet<>();

	public SkillChain(Abnormal abnormal, SkillEntry skillEntry) {
		this.abnormal = abnormal;
		this.skillEntry = skillEntry;
	}

	public Creature getOwner() {
		return abnormal.getEffected();
	}

	public SkillEntry getSkillEntry() {
		return skillEntry;
	}

	public boolean isPublic() {
		return abnormal.getSkill().isPublicChain();
	}

	public int getDuration() {
		return Math.min(abnormal.getTimeLeft(), 10);    // TODO: Вынести в параметры скиллов при надобности.
	}

	public void onStartCast(SkillEntry skillEntry1) {
		if (!skillEntry.equals(skillEntry1))
			return;
		abnormal.exit();
	}

	public void checkTargetOwners() {
		boolean remove = !abnormal.isActive();
		if (remove) {
			for (Player caster : casters)
				caster.setTargetSkillChain(null);
		} else {
			if (isPublic()) {
				for (Player player : World.getAroundPlayers(getOwner())) {
					if (player.getTarget() == getOwner() && !player.isCastingNow()) {
						player.setTargetSkillChain(this);
					}
				}
			} else {
				Player player = abnormal.getEffector().getPlayer();
				if (player != null && player.getTarget() == getOwner() && !player.isCastingNow()) {
					player.setTargetSkillChain(this);
				}
			}
		}
	}

	public void onAdd(Player player) {
		player.sendPacket(new ExAlterSkillRequest(skillEntry.getId(), abnormal.getSkill().getId(), getDuration()));
		casters.add(player);
	}

	public void onRemove(Player player) {
		player.sendPacket(new ExAlterSkillRequest(-1, -1, -1));
		casters.remove(player);
	}
}
