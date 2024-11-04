package npc.model;

import l2s.commons.collections.MultiValueSet;
import l2s.gameserver.ai.Fighter;
import l2s.gameserver.model.Creature;
import l2s.gameserver.model.instances.DefenderInstance;
import l2s.gameserver.templates.npc.NpcTemplate;

/**
 * @author Bonux
 **/
public class AdenVanguardInstance extends DefenderInstance {
	public AdenVanguardInstance(int objectId, NpcTemplate template, MultiValueSet<String> set) {
		super(objectId, template, set);
	}

	@Override
	public boolean isAutoAttackable(Creature attacker) {
		if(getAI() instanceof Fighter)
			return attacker.isMonster();
		return super.isAutoAttackable(attacker);
	}

	@Override
	public boolean canAttackCharacter(Creature target) {
		if(getAI() instanceof Fighter)
			return target.isMonster();
		return super.canAttackCharacter(target);
	}

	@Override
	public boolean isDefender() {
		if(getAI() instanceof Fighter)
			return true;
		return super.isDefender();
	}
}