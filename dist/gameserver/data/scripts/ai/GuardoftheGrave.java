package ai;

import l2s.commons.util.Rnd;
import l2s.gameserver.ThreadPoolManager;
import l2s.gameserver.ai.Fighter;
import l2s.gameserver.data.xml.holder.NpcHolder;
import l2s.gameserver.model.Creature;
import l2s.gameserver.model.instances.NpcInstance;

/**
 * AI мобов Guard of the Grave на Crypts Of Disgrace.<br>
 * - Деспавнятся при простое более 2 минут<br>
 * - Не используют функцию Random Walk<br>
 * ID: 18815
 * @author n0nam3
 */
public class GuardoftheGrave extends Fighter
{
	private static final int DESPAWN_TIME = 2 * 45 * 1000;
	private static final int CHIEFTAINS_TREASURE_CHEST = 18816;

	public GuardoftheGrave(NpcInstance actor)
	{
		super(actor);
		actor.getFlags().getInvulnerable().start();
		actor.getFlags().getImmobilized().start();
	}

	@Override
	protected void onEvtSpawn()
	{
		super.onEvtSpawn();
		ThreadPoolManager.getInstance().schedule(new DeSpawnTask(), DESPAWN_TIME + Rnd.get(1, 30));
	}

	@Override
	protected boolean checkTarget(Creature target, int range)
	{
		NpcInstance actor = getActor();
		if(actor != null && target != null && !actor.isInRange(target, actor.getAggroRange()))
		{
			actor.getAggroList().remove(target, true);
			return false;
		}
		return super.checkTarget(target, range);
	}

	protected void spawnChest(NpcInstance actor)
	{
		try
		{
			NpcInstance npc = NpcHolder.getInstance().getTemplate(CHIEFTAINS_TREASURE_CHEST).getNewInstance();
			npc.setSpawnedLoc(actor.getLoc());
			npc.setCurrentHpMp(npc.getMaxHp(), npc.getMaxMp(), true);
			npc.spawnMe(npc.getSpawnedLoc());
		}
		catch(Exception e)
		{
			e.printStackTrace();
		}
	}

	private class DeSpawnTask implements Runnable
	{
		@Override
		public void run()
		{
			NpcInstance actor = getActor();
			spawnChest(actor);
			actor.deleteMe();
		}
	}
}