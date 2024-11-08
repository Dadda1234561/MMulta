package ai;

import l2s.gameserver.ai.CtrlEvent;
import l2s.gameserver.ai.Mystic;
import l2s.gameserver.geometry.Location;
import l2s.gameserver.model.Creature;
import l2s.gameserver.model.Skill;
import l2s.gameserver.model.instances.NpcInstance;
import l2s.gameserver.utils.NpcUtils;

/** Author: Bonux
	При ударе монстра спавнятся 2 х Tanta Lizardman Scout и они агрятся на игрока.
**/
public class LizardmanSummoner extends Mystic
{
	private final int TANTA_LIZARDMAN_SCOUT = 22768;
	private final int SPAWN_COUNT = 2;
	private boolean spawnedMobs = false;

	public LizardmanSummoner(NpcInstance actor)
	{
		super(actor);
	}

	@Override
	protected void onEvtSpawn()
	{
		spawnedMobs = false;
		super.onEvtSpawn();
	}

	@Override
	protected void onEvtAttacked(Creature attacker, Skill skill, int damage)
	{
		if(!spawnedMobs && attacker.isPlayable())
		{
			NpcInstance actor = getActor();
			for(int i = 0; i < SPAWN_COUNT; i++)
			{
				int radius = ((i % 2) == 0 ? -1 : 1) * 16000;
				int x = (int) (actor.getX() + 80 * Math.cos(actor.headingToRadians(actor.getHeading() - 32768 + radius)));
				int y = (int) (actor.getY() + 80 * Math.sin(actor.headingToRadians(actor.getHeading() - 32768 + radius)));
				NpcInstance npc = NpcUtils.spawnSingle(TANTA_LIZARDMAN_SCOUT, new Location(x, y, actor.getZ()), actor.getReflection());
				npc.getAI().notifyEvent(CtrlEvent.EVT_AGGRESSION, attacker, 1000);
			}
			spawnedMobs = true;
		}
		super.onEvtAttacked(attacker, skill, damage);
	}
}
