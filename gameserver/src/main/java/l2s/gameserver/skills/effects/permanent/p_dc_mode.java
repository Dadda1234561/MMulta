package l2s.gameserver.skills.effects.permanent;

import java.util.ArrayList;
import java.util.List;

import l2s.gameserver.handler.effects.EffectHandler;
import l2s.gameserver.model.Creature;
import l2s.gameserver.model.Skill;
import l2s.gameserver.model.actor.instances.creature.Abnormal;
import l2s.gameserver.skills.SkillEntry;
import l2s.gameserver.templates.skill.EffectTemplate;

/**
 * @author Bonux
**/
public final class p_dc_mode extends EffectHandler
{
	private class p_dc_mode_impl extends EffectHandler
	{
		private final List<Skill> _addedToggles = new ArrayList<Skill>();

		public p_dc_mode_impl(EffectTemplate template)
		{
			super(template);
		}

		@Override
		public void onStart(Abnormal abnormal, Creature effector, Creature effected)
		{
			effected.setDualCastEnable(true);
			for(SkillEntry skillEntry : effected.getAllSkills())
			{
				Skill skill = skillEntry.getTemplate();
				if(!skill.isToggleGrouped())
					continue;

				if(skill.getToggleGroupId() != 1)
					continue;

				if(effected.getAbnormalList().contains(skill))
					continue;

				skill.getEffects(effector, effected, false);

				_addedToggles.add(skill);
			}
		}

		@Override
		public void onExit(Abnormal abnormal, Creature effector, Creature effected)
		{
			effected.setDualCastEnable(false);

			for(Skill skill : _addedToggles)
				effected.getAbnormalList().stop(skill, false);
		}
	}

	public p_dc_mode(EffectTemplate template)
	{
		super(template);
	}

	@Override
	public EffectHandler getImpl()
	{
		return new p_dc_mode_impl(getTemplate());
	}
}