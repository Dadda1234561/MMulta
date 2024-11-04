package ai;

import l2s.commons.util.Rnd;
import l2s.gameserver.ai.CtrlEvent;
import l2s.gameserver.ai.Fighter;
import l2s.gameserver.geometry.Location;
import l2s.gameserver.model.Creature;
import l2s.gameserver.model.Skill;
import l2s.gameserver.model.instances.NpcInstance;
import l2s.gameserver.utils.NpcUtils;

/**
 * AI моба Pronghorn для Frozen Labyrinth.<br>
 * - Если был атакован физическим скилом, спавнится миньон-мобы Pronghorn Spirit 22087 в количестве 4 штук.<br>
 * - Не используют функцию Random Walk, если были заспавнены "миньоны"<br>
 * @author SYS
 */
public class Pronghorn extends Fighter
{
	private boolean _mobsNotSpawned = true;
	private static final int MOBS = 22087;
	private static final int MOBS_COUNT = 4;

	public Pronghorn(NpcInstance actor)
	{
		super(actor);
	}

	@Override
	protected void onEvtSeeSpell(Skill skill, Creature caster, Creature target)
	{
		NpcInstance actor = getActor();
		if(skill.isMagic())
			return;
		if(_mobsNotSpawned)
		{
			_mobsNotSpawned = false;
			for(int i = 0; i < MOBS_COUNT; i++)
			{
				NpcInstance npc = NpcUtils.spawnSingle(MOBS, Location.findPointToStay(actor, 100, 120), actor.getReflection());
				npc.getAI().notifyEvent(CtrlEvent.EVT_AGGRESSION, caster, Rnd.get(1, 100));
			}
		}
	}

	@Override
	protected void onEvtDead(Creature killer)
	{
		_mobsNotSpawned = true;
		super.onEvtDead(killer);
	}

	@Override
	protected boolean randomWalk()
	{
		return _mobsNotSpawned;
	}
}