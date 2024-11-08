package ai;

import l2s.gameserver.ThreadPoolManager;
import l2s.gameserver.ai.CtrlIntention;
import l2s.gameserver.ai.Fighter;
import l2s.gameserver.model.Creature;
import l2s.gameserver.model.Skill;
import l2s.gameserver.model.instances.NpcInstance;
import l2s.gameserver.skills.SkillEntry;
import l2s.gameserver.skills.SkillEntryType;

/**
 Obi-Wan
 26.10.2016
 */
public class BalokAI extends Fighter
{
	private long lastPrison = 0;
	private long lastInvul = 0;

	public BalokAI(NpcInstance actor)
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

		if(lastInvul < System.currentTimeMillis() && !npc.getAbnormalList().contains(5225) && npc.getCurrentHpPercents() < 50)
		{
			lastInvul = System.currentTimeMillis() + 120000;
			addTaskBuff(npc, SkillEntry.makeSkillEntry(SkillEntryType.NONE, 5225, 1));
			return true;
		}

		for(Creature creature : npc.getAroundCharacters(500, 500))
		{
			if(creature.getNpcId() == 23123 && !creature.isInvulnerable())
			{
				addTaskCast(creature, SkillEntry.makeSkillEntry(SkillEntryType.NONE, 14367, 1));
				ThreadPoolManager.getInstance().schedule(()->{
					creature.deleteMe();
					npc.setCurrentHp(npc.getCurrentHp() + npc.getMaxHp() * 0.3, false);
				}, 8000);
				return true;
			}
		}

		Creature target;
		if((target = prepareTarget()) == null)
		{
			setIntention(CtrlIntention.AI_INTENTION_ACTIVE);
			return true;
		}

		if(lastPrison < System.currentTimeMillis() && target.isPlayer())
		{
			lastPrison = System.currentTimeMillis() + 180000;
			addTaskCast(target, SkillEntry.makeSkillEntry(SkillEntryType.NONE, 5226, 1));
			return true;
		}

		return super.createNewTask();
	}

	@Override public boolean canAttackCharacter(Creature target)
	{
		return target.isPlayable() || target.getNpcId() == 23123 && !target.isInvulnerable();
	}
}