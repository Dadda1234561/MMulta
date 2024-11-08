package ai.residences.clanhall;

import l2s.commons.util.Rnd;
import l2s.gameserver.model.Creature;
import l2s.gameserver.model.Skill;
import l2s.gameserver.model.instances.NpcInstance;
import l2s.gameserver.skills.SkillEntry;
import l2s.gameserver.skills.SkillEntryType;

/**
 * @author VISTALL
 * @date 16:38/22.04.2011
 */
public class MatchLeader extends MatchFighter
{
	public static final SkillEntry ATTACK_SKILL = SkillEntry.makeSkillEntry(SkillEntryType.NONE, 4077, 6);

	public MatchLeader(NpcInstance actor)
	{
		super(actor);
	}

	@Override
	protected void onEvtAttacked(Creature attacker, Skill skill, int damage)
	{
		super.onEvtAttacked(attacker, skill, damage);

		if(Rnd.chance(10))
			addTaskCast(attacker, ATTACK_SKILL);
	}
}
