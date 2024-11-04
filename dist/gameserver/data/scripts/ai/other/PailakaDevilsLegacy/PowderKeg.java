package ai.other.PailakaDevilsLegacy;

import l2s.gameserver.ai.DefaultAI;
import l2s.gameserver.model.Creature;
import l2s.gameserver.model.Skill;
import l2s.gameserver.model.instances.NpcInstance;
import l2s.gameserver.data.xml.holder.SkillHolder;
import l2s.gameserver.skills.SkillEntry;
import l2s.gameserver.skills.SkillEntryType;

public class PowderKeg extends DefaultAI
{
	public PowderKeg(NpcInstance actor)
	{
		super(actor);
	}

	@Override
	protected void onEvtAttacked(Creature attacker, Skill skill, int damage)
	{
		NpcInstance actor = getActor();
		if(actor == null)
			return;

		if(damage > 0)
		{
			actor.setTarget(actor);
			SkillEntry skillUse = SkillEntry.makeSkillEntry(SkillEntryType.NONE, 5714, 1);
			if(skillUse != null)
			{
				Creature target = skillUse.getTemplate().getAimingTarget(actor, attacker);
				actor.doCast(skillUse, target, true);
			}
		}
		super.onEvtAttacked(attacker, skill, damage);
	}

	@Override
	protected boolean randomWalk()
	{
		return false;
	}

	@Override
	protected boolean randomAnimation()
	{
		return false;
	}
}