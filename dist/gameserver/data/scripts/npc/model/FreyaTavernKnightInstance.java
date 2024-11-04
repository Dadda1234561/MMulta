package npc.model;

import l2s.commons.collections.MultiValueSet;
import l2s.gameserver.model.Creature;
import l2s.gameserver.model.instances.NpcInstance;
import l2s.gameserver.templates.npc.NpcTemplate;

/**
 * @author Bonux
 */
public class FreyaTavernKnightInstance extends NpcInstance {
	public FreyaTavernKnightInstance(int objectId, NpcTemplate template, MultiValueSet<String> set) {
		super(objectId, template, set);
	}

	@Override
	public boolean isAutoAttackable(Creature attacker) {
		return attacker.getNpcId() == 23703;
	}

	@Override
	public boolean canAttackCharacter(Creature target) {
		return target.getNpcId() == 23703;
	}

	@Override
	public boolean isDefender() {
		return true;
	}
}