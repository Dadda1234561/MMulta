package ai;

import l2s.gameserver.ai.CtrlEvent;
import l2s.gameserver.ai.Mystic;
import l2s.gameserver.geometry.Location;
import l2s.gameserver.model.Creature;
import l2s.gameserver.model.Skill;
import l2s.gameserver.model.instances.NpcInstance;
import l2s.gameserver.utils.NpcUtils;

/**
 * AI Seer Flouros.<br>
 * - Спавнит "миньонов" при атаке.<br>
 * - _hps - таблица процентов hp, после которых спавнит "миньонов".<br>
 * @author n0nam3
 */
public class SeerFlouros extends Mystic
{
	private int _hpCount = 0;
	private static final int MOB = 18560;
	private static final int MOBS_COUNT = 2;
	private static final int[] _hps = { 80, 60, 40, 30, 20, 10, 5, -5 };

	public SeerFlouros(NpcInstance actor)
	{
		super(actor);
	}

	@Override
	protected void onEvtAttacked(Creature attacker, Skill skill, int damage)
	{
		NpcInstance actor = getActor();
		if(!actor.isDead())
			if(actor.getCurrentHpPercents() < _hps[_hpCount])
			{
				spawnMobs(attacker);
				_hpCount++;
			}
		super.onEvtAttacked(attacker, skill, damage);
	}

	private void spawnMobs(Creature attacker)
	{
		NpcInstance actor = getActor();
		for(int i = 0; i < MOBS_COUNT; i++)
		{
			NpcInstance npc = NpcUtils.spawnSingle(MOB, Location.findPointToStay(actor, 100, 120), actor.getReflection());
			npc.getAI().notifyEvent(CtrlEvent.EVT_AGGRESSION, attacker, 100);
		}
	}

	@Override
	protected void onEvtDead(Creature killer)
	{
		_hpCount = 0;
		super.onEvtDead(killer);
	}
}