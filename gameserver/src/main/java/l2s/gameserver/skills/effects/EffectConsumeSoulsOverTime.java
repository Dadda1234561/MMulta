package l2s.gameserver.skills.effects;

import l2s.gameserver.handler.effects.EffectHandler;
import l2s.gameserver.model.Creature;
import l2s.gameserver.model.actor.instances.creature.Abnormal;
import l2s.gameserver.templates.skill.EffectTemplate;

public class EffectConsumeSoulsOverTime extends EffectHandler
{
	public EffectConsumeSoulsOverTime(EffectTemplate template)
	{
		super(template);
	}

	@Override
	protected boolean checkCondition(Abnormal abnormal, Creature effector, Creature effected)
	{
		if(effected.isDead() || effected.isRaid() || effected.getConsumedSouls() < 0)
			return false;
		return true;
	}

	@Override
	public boolean onActionTime(Abnormal abnormal, Creature effector, Creature effected)
	{
		if(effected.isDead())
			return false;

		if(effected.getConsumedSouls() < 0)
			return false;

		int damage = (int) getValue();

		if(effected.getConsumedSouls() < damage)
			effected.setConsumedSouls(0, null);
		else
			effected.setConsumedSouls(effected.getConsumedSouls() - damage, null);

		return true;
	}
}