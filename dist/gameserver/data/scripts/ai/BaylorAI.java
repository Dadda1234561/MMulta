package ai;

import l2s.gameserver.ai.CtrlIntention;
import l2s.gameserver.ai.Fighter;
import l2s.gameserver.model.Creature;
import l2s.gameserver.model.Skill;
import l2s.gameserver.model.instances.MonsterInstance;
import l2s.gameserver.model.instances.NpcInstance;
import l2s.gameserver.skills.SkillEntry;
import l2s.gameserver.skills.SkillEntryType;

/**
 Obi-Wan
 13.10.2016
 */
public class BaylorAI extends Fighter
{
	private long lastPrison = 0;
	private long lastInvul = 0;

	public BaylorAI(NpcInstance actor)
	{
		super(actor);
	}

	@Override
	protected boolean createNewTask()
	{
		clearTasks();

		NpcInstance npc = getActor();

		if(npc == null || npc.isCastingNow())
		{
			return false;
		}

		if(lastInvul < System.currentTimeMillis() && !npc.getAbnormalList().contains(5225) && npc.getCurrentHpPercents() < 20)
		{
			lastInvul = System.currentTimeMillis() + 120000;
			addTaskBuff(npc, SkillEntry.makeSkillEntry(SkillEntryType.NONE, 5225, 1));
			return true;
		}

		Creature target;
		if((target = prepareTarget()) == null)
		{
			setIntention(CtrlIntention.AI_INTENTION_ACTIVE);
			return true;
		}

		if(lastPrison < System.currentTimeMillis() && target.isPlayer())
		{
			lastPrison = System.currentTimeMillis() + 300000;
			addTaskCast(target, SkillEntry.makeSkillEntry(SkillEntryType.NONE, 5226, 1));
			return true;
		}

		return super.createNewTask();
	}

	@Override
	public boolean canAttackCharacter(Creature target)
	{
		return target.isPlayable() || (target.getAI() instanceof BaylorGolemAI && ((BaylorGolemAI) target.getAI()).isRun());
	}
}