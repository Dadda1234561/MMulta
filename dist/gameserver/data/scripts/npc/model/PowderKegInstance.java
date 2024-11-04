package npc.model;

import l2s.commons.collections.MultiValueSet;
import l2s.gameserver.model.Creature;
import l2s.gameserver.model.Skill;
import l2s.gameserver.model.instances.NpcInstance;
import l2s.gameserver.skills.SkillEntry;
import l2s.gameserver.templates.npc.NpcTemplate;

/**
 * @author Bonux
**/
public class PowderKegInstance extends NpcInstance
{
	public PowderKegInstance(int objectId, NpcTemplate template, MultiValueSet<String> set)
	{
		super(objectId, template, set);
	}

	@Override
	public boolean isAutoAttackable(Creature attacker)
	{
		return true;
	}

	@Override
	public void altOnMagicUse(Creature aimingTarget, SkillEntry skill)
	{
		super.altOnMagicUse(aimingTarget, skill);

		if(skill.getId() == 5714)
			doDie(null);
	}
}