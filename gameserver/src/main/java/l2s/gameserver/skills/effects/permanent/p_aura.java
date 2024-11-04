package l2s.gameserver.skills.effects.permanent;

import java.util.Set;

import l2s.commons.util.Rnd;
import l2s.gameserver.handler.effects.EffectHandler;
import l2s.gameserver.model.Creature;
import l2s.gameserver.model.Skill;
import l2s.gameserver.model.actor.instances.creature.Abnormal;
import l2s.gameserver.model.instances.MonsterInstance;
import l2s.gameserver.skills.EffectUseType;
import l2s.gameserver.skills.SkillEntry;
import l2s.gameserver.skills.SkillEntryType;
import l2s.gameserver.templates.skill.EffectTemplate;
import l2s.gameserver.utils.SkillUtils;

/**
 * @author Bonux
**/
public final class p_aura extends EffectHandler
{
	private final SkillEntry _skillEntry;

	public p_aura(EffectTemplate template)
	{
		super(template);

		int id = getParams().getInteger("id");
		int level = getParams().getInteger("level", 1);
		int sub_level = getParams().getInteger("sub_level", 0);

		_skillEntry = SkillEntry.makeSkillEntry(SkillEntryType.NONE, id, SkillUtils.getSkillLevelMask(level, sub_level));
	}

	@Override
	public int getInterval()
	{
		return 7; // offlike
	}

	@Override
	public boolean onActionTime(Abnormal abnormal, Creature effector, Creature effected)
	{
		if(_skillEntry == null)
			return false;

		Skill skill = _skillEntry.getTemplate();
		if(!skill.isAura())
			return false;

		Set<Creature> targets = skill.getTargets(_skillEntry, effector, effected, false);
		for(Creature target : targets)
		{
			if(getSkill().calcEffectsSuccess(effector, target, false))
			{
				if(skill.isSynergy() || !target.getAbnormalList().contains(getSkill()))
				{
					skill.getEffects(effector, target);
					if (skill.isDebuff() && target.isMonster())
					{
						((MonsterInstance) target).getAggroList().addDamageHate(effector, 0, -skill.getEffectPoint());
					}
					for (EffectTemplate et : skill.getEffectTemplates(EffectUseType.NORMAL_INSTANT))
					{
						final EffectHandler handler = et.getHandler();
						if(!et.getTargetType().checkTarget(target))
							return false;

						if(et.getChance() >= 0 && !Rnd.chance(et.getChance()))
							return false;
						if(!handler.checkConditionImpl(effector, target))
							return false;
						handler.instantUse(effector, target, false);
					}
				}
			}
		}
		return true;
	}
}