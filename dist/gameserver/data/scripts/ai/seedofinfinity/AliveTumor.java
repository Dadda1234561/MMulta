package ai.seedofinfinity;

import l2s.gameserver.skills.SkillEntry;
import l2s.gameserver.skills.SkillEntryType;
import org.apache.commons.lang3.ArrayUtils;
import l2s.gameserver.ai.DefaultAI;
import l2s.gameserver.model.Creature;
import l2s.gameserver.model.Skill;
import l2s.gameserver.model.instances.NpcInstance;

/**
 * @author pchayka
 */

public class AliveTumor extends DefaultAI
{
	private long checkTimer = 0;
	private int coffinsCount = 0;
	private static final int[] regenCoffins = { 18706, 18709, 18710 };

	public AliveTumor(NpcInstance actor)
	{
		super(actor);
		actor.getFlags().getImmobilized().start();
	}

	@Override
	protected boolean thinkActive()
	{
		NpcInstance actor = getActor();

		if(checkTimer + 10000 < System.currentTimeMillis())
		{
			checkTimer = System.currentTimeMillis();
			int i = 0;
			for(NpcInstance n : actor.getAroundNpc(400, 300))
				if(ArrayUtils.contains(regenCoffins, n.getNpcId()) && !n.isDead())
					i++;
			if(coffinsCount != i)
			{
				coffinsCount = i;
				coffinsCount = Math.min(coffinsCount, 12);
				if(coffinsCount > 0)
					actor.altOnMagicUse(actor, SkillEntry.makeSkillEntry(SkillEntryType.NONE, 5940, coffinsCount));
			}
		}
		return super.thinkActive();
	}

	@Override
	protected void onEvtAttacked(Creature attacker, Skill skill, int damage)
	{
	}

	@Override
	protected void onEvtAggression(Creature target, int aggro)
	{
	}
}