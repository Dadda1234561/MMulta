package ai.isle_of_prayer;

import java.util.ArrayList;
import java.util.List;
import java.util.concurrent.ScheduledFuture;

import l2s.commons.util.Rnd;
import l2s.gameserver.ThreadPoolManager;
import l2s.gameserver.ai.Fighter;
import l2s.gameserver.geometry.Location;
import l2s.gameserver.model.Creature;
import l2s.gameserver.model.Skill;
import l2s.gameserver.model.Spawner;
import l2s.gameserver.model.instances.NpcInstance;
import l2s.gameserver.model.items.ItemInstance;
import l2s.gameserver.stats.StatModifierType;
import l2s.gameserver.stats.Stats;
import l2s.gameserver.stats.funcs.FuncNew;
import l2s.gameserver.stats.funcs.FuncTemplate;
import l2s.gameserver.templates.StatsSet;
import l2s.gameserver.utils.ItemFunctions;
import l2s.gameserver.utils.NpcUtils;

/**
 * @author Diamond
 * @corrected n0nam3
 */
public class FafurionKindred extends Fighter
{
	private static final int DETRACTOR1 = 22270;
	private static final int DETRACTOR2 = 22271;

	private static final int Spirit_of_the_Lake = 2368;

	private static final int Water_Dragon_Scale = 9691;
	private static final int Water_Dragon_Claw = 9700;

	ScheduledFuture<?> poisonTask;
	ScheduledFuture<?> despawnTask;

	List<Spawner> spawns = new ArrayList<Spawner>();

	public FafurionKindred(NpcInstance actor)
	{
		super(actor);
		StatsSet params = new StatsSet();
		params.set("mode", StatModifierType.PER);
		actor.getStat().addFuncs(new FuncNew(Stats.HEAL_EFFECT, 0x30, actor, -100, params));
	}

	@Override
	protected void onEvtSpawn()
	{
		super.onEvtSpawn();

		spawns.clear();

		ThreadPoolManager.getInstance().schedule(new SpawnTask(DETRACTOR1), 500);
		ThreadPoolManager.getInstance().schedule(new SpawnTask(DETRACTOR2), 500);
		ThreadPoolManager.getInstance().schedule(new SpawnTask(DETRACTOR1), 500);
		ThreadPoolManager.getInstance().schedule(new SpawnTask(DETRACTOR2), 500);

		poisonTask = ThreadPoolManager.getInstance().scheduleAtFixedRate(new PoisonTask(), 3000, 3000);
		despawnTask = ThreadPoolManager.getInstance().schedule(new DeSpawnTask(), 300000);
	}

	@Override
	protected void onEvtDead(Creature killer)
	{
		cleanUp();

		super.onEvtDead(killer);
	}

	@Override
	protected void onEvtSeeSpell(Skill skill, Creature caster, Creature target)
	{
		NpcInstance actor = getActor();
		if(actor.isDead() || skill == null)
			return;
		// Лечим
		if(skill.getId() == Spirit_of_the_Lake)
			actor.setCurrentHp(actor.getCurrentHp() + 3000, false);
		actor.getAggroList().remove(caster, true);
	}

	@Override
	protected boolean randomWalk()
	{
		return false;
	}

	private void cleanUp()
	{
		if(poisonTask != null)
		{
			poisonTask.cancel(false);
			poisonTask = null;
		}
		if(despawnTask != null)
		{
			despawnTask.cancel(false);
			despawnTask = null;
		}

		for(Spawner spawn : spawns)
		{
			if(spawn != null)
				spawn.deleteAll();
		}	
		spawns.clear();
	}

	private class SpawnTask implements Runnable
	{
		private final int _id;

		public SpawnTask(int id)
		{
			_id = id;
		}

		@Override
		public void run()
		{
			spawns.add(NpcUtils.spawnSimple(_id, Location.findPointToStay(getActor(), 100, 120), 30, 40));
		}
	}

	private class PoisonTask implements Runnable
	{
		@Override
		public void run()
		{
			NpcInstance actor = getActor();
			actor.reduceCurrentHp(500, actor, null, true, false, true, false, false, false, false); // Травим дракошу ядом
		}
	}

	private class DeSpawnTask implements Runnable
	{
		@Override
		public void run()
		{
			NpcInstance actor = getActor();

			// Если продержались 5 минут, то выдаем награду, и деспавним
			dropItem(actor, Water_Dragon_Scale, Rnd.get(1, 2));
			if(Rnd.chance(36))
				dropItem(actor, Water_Dragon_Claw, Rnd.get(1, 3));

			cleanUp();
			actor.deleteMe();
		}
	}

	private void dropItem(NpcInstance actor, int id, int count)
	{
		ItemInstance item = ItemFunctions.createItem(id);
		item.setCount(count);
		item.dropToTheGround(actor, Location.findPointToStay(actor, 100));
	}
}