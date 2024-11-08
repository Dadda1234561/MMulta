package ai;

import l2s.commons.util.Rnd;
import l2s.gameserver.ai.Mystic;
import l2s.gameserver.model.Creature;
import l2s.gameserver.model.Skill;
import l2s.gameserver.model.instances.MonsterInstance;
import l2s.gameserver.model.instances.NpcInstance;
import l2s.gameserver.stats.Env;
import l2s.gameserver.stats.StatModifierType;
import l2s.gameserver.stats.Stats;
import l2s.gameserver.stats.funcs.Func;
import l2s.gameserver.templates.npc.MinionData;

/**
 * При спавне саммонят случайную охрану.
 * Защита прямо пропорциональна количеству охранников.
 */
public class GraveRobberSummoner extends Mystic
{
	private static final int[] Servitors = { 22683, 22684, 22685, 22686 };

	private int _lastMinionCount = 1;

	private class FuncMulMinionCount extends Func
	{
		public FuncMulMinionCount(Stats stat, int order, Object owner)
		{
			super(stat, order, owner);
		}

		@Override
		public void calc(Env env, StatModifierType modifierType)
		{
			env.value *= _lastMinionCount;
		}
	}

	public GraveRobberSummoner(NpcInstance actor)
	{
		super(actor);

		actor.getStat().addFuncs(new FuncMulMinionCount(Stats.MAGIC_DEFENCE, 0x30, actor));
		actor.getStat().addFuncs(new FuncMulMinionCount(Stats.POWER_DEFENCE, 0x30, actor));
	}

	@Override
	protected void onEvtSpawn()
	{
		super.onEvtSpawn();

		NpcInstance actor = getActor();
		actor.getMinionList().addMinion(Servitors[Rnd.get(Servitors.length)], null, Rnd.get(2), 0);
		actor.getMinionList().spawnMinions();
		_lastMinionCount = Math.max(actor.getMinionList().getAliveMinions().size(), 1);
	}

	@Override
	protected void onEvtAttacked(Creature attacker, Skill skill, int damage)
	{
		MonsterInstance actor = (MonsterInstance) getActor();
		if(actor.isDead())
			return;
		_lastMinionCount = Math.max(actor.getMinionList().getAliveMinions().size(), 1);
		super.onEvtAttacked(attacker, skill, damage);
	}

	@Override
	protected void onEvtDead(Creature killer)
	{
		NpcInstance actor = getActor();
		actor.getMinionList().despawnMinions();
		super.onEvtDead(killer);
	}
}