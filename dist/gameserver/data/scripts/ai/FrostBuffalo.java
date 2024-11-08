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
 * AI моба Frost Buffalo для Frozen Labyrinth.<br>
 * - Если был атакован физическим скилом, спавнится миньон-мобы Lost Buffalo 22093 в количестве 4 штук.<br>
 * - Не используют функцию Random Walk, если были заспавнены "миньоны"<br>
 * @author SYS
 */
public class FrostBuffalo extends Fighter
{
	private boolean _mobsNotSpawned = true;
	private static final int MOBS = 22093;
	private static final int MOBS_COUNT = 4;

	public FrostBuffalo(NpcInstance actor)
	{
		super(actor);
	}

	@Override
	protected void onEvtSeeSpell(Skill skill, Creature caster, Creature target)
	{
		NpcInstance actor = getActor();
		if(actor != target)
			return;
		if(skill.isMagic())
			return;
		if(_mobsNotSpawned)
		{
			_mobsNotSpawned = false;
			for(int i = 0; i < MOBS_COUNT; i++)
				try
				{
					NpcInstance npc = NpcUtils.spawnSingle(MOBS, Location.findPointToStay(actor, 100, 120));
					if(caster.isServitor())
						npc.getAI().notifyEvent(CtrlEvent.EVT_AGGRESSION, caster, Rnd.get(2, 100));
					npc.getAI().notifyEvent(CtrlEvent.EVT_AGGRESSION, caster.getPlayer(), Rnd.get(1, 100));
				}
				catch(Exception e)
				{
					e.printStackTrace();
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