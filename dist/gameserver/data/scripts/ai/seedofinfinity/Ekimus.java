package ai.seedofinfinity;

import l2s.gameserver.ai.CtrlEvent;
import l2s.gameserver.ai.Mystic;
import l2s.gameserver.model.Creature;
import l2s.gameserver.model.Skill;
import l2s.gameserver.model.instances.NpcInstance;
import instances.HeartInfinityAttack;

/**
 * @author pchayka
 */
public class Ekimus extends Mystic
{
	private long delayTimer = 0;

	public Ekimus(NpcInstance actor)
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
	protected void onEvtAttacked(Creature attacker, Skill skill, int damage)
	{
		NpcInstance actor = getActor();
		for(NpcInstance npc : actor.getReflection().getNpcs(true, 29151))
			npc.getAI().notifyEvent(CtrlEvent.EVT_AGGRESSION, attacker, damage);
		super.onEvtAttacked(attacker, skill, damage);
	}

	@Override
	protected void thinkAttack()
	{
		if(delayTimer + 5000 < System.currentTimeMillis())
		{
			delayTimer = System.currentTimeMillis();
			if(getActor().getReflection().getInstancedZoneId() == 121)
				((HeartInfinityAttack) getActor().getReflection()).notifyEkimusAttack();
		}
		super.thinkAttack();
	}

	@Override
	protected boolean thinkActive()
	{
		if(delayTimer + 5000 < System.currentTimeMillis())
		{
			delayTimer = System.currentTimeMillis();
			if(getActor().getReflection().getInstancedZoneId() == 121)
				((HeartInfinityAttack) getActor().getReflection()).notifyEkimusIdle();
		}
		return super.thinkActive();
	}
}