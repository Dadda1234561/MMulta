package ai.feyas;

import java.util.HashSet;
import java.util.Set;

import l2s.commons.collections.LazyArrayList;
import l2s.gameserver.ThreadPoolManager;
import l2s.gameserver.ai.DefaultAI;
import l2s.gameserver.model.Creature;
import l2s.gameserver.model.Player;
import l2s.gameserver.model.Skill;
import l2s.gameserver.model.World;
import l2s.gameserver.model.instances.NpcInstance;
import l2s.gameserver.network.l2.s2c.MagicSkillUse;
import l2s.gameserver.skills.SkillCastingType;
import l2s.gameserver.skills.SkillEntry;
import l2s.gameserver.skills.SkillEntryType;

public class SwampSpirit extends DefaultAI
{

	public SwampSpirit(NpcInstance actor)
	{
		super(actor);
	}

	@Override
	protected boolean randomAnimation()
	{
		return false;
	}

	@Override
	protected boolean randomWalk()
	{
		return false;
	}

	@Override
	protected boolean thinkActive()
	{
		NpcInstance actor = getActor();
		
		if(actor == null)
			return false;

		for(Player player : World.getAroundPlayers(actor, 300, 300))
		{
			if(player != null && !player.isDead() && !player.isAlikeDead() && player.getCurrentHp() != player.getMaxHp())
			{
				SkillEntry skillEntry;
				if(actor.getNpcId() == 32915)
				{
					skillEntry = SkillEntry.makeSkillEntry(SkillEntryType.NONE, 14064, 1);
					actor.broadcastPacket(new MagicSkillUse(actor, player, 14064, 1, 0, 0, SkillCastingType.NORMAL));
				}
				else
				{
					skillEntry = SkillEntry.makeSkillEntry(SkillEntryType.NONE, 14065, 1);
					actor.broadcastPacket(new MagicSkillUse(actor, player, 14065, 1, 0, 0, SkillCastingType.NORMAL));
				}
				Set<Creature> targets = new HashSet<Creature>(); //if more than one
				targets.add(player);
				actor.callSkill(player, skillEntry, targets, true, false);
				//Thread.sleep(1500); //to let them finish the casting! to do thread.
				actor.decayMe();
				ThreadPoolManager.getInstance().schedule(new SpawnTask(actor), 180000L);
				return true; //one player only
			}
		}
		return false;
	}

	private class SpawnTask implements Runnable
	{
		private NpcInstance _npc;

		public SpawnTask(NpcInstance npc)
		{
			_npc = npc;
		}

		@Override
		public void run()
		{
			_npc.spawnMe();
		}
	}

	@Override
	protected void onEvtAttacked(Creature attacker, Skill skill, int damage)
	{}

	@Override
	protected void onEvtAggression(Creature target, int aggro)
	{}
}