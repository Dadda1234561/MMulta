package ai.custom;

import l2s.commons.util.Rnd;
import l2s.gameserver.ai.Fighter;
import l2s.gameserver.model.Creature;
import l2s.gameserver.model.Skill;
import l2s.gameserver.model.instances.NpcInstance;
import l2s.gameserver.utils.Functions;

/**
 * AI Lilim Servants: 27371-27379
 *
 * @author pchayka
 */
public class SSQLilimServantFighter extends Fighter
{
	private boolean _attacked = false;

	public SSQLilimServantFighter(NpcInstance actor)
	{
		super(actor);
	}

	@Override
	protected void onEvtAttacked(Creature attacker, Skill skill, int damage)
	{
		if(Rnd.chance(30) && !_attacked)
		{
			Functions.npcSay(getActor(), Rnd.chance(50) ? "Those who are afraid should get away and those who are brave should fight!" : "This place once belonged to Lord Shilen.");
			_attacked = true;
		}
		super.onEvtAttacked(attacker, skill, damage);
	}

	@Override
	protected void onEvtDead(Creature killer)
	{
		if(Rnd.chance(30))
			Functions.npcSay(getActor(), Rnd.chance(50) ? "Why are you getting in our way?" : "Shilen... our Shilen!");
		super.onEvtDead(killer);
	}
}