package ai.hellbound;

import l2s.commons.threading.RunnableImpl;
import l2s.gameserver.ThreadPoolManager;
import l2s.gameserver.ai.Fighter;
import l2s.gameserver.data.xml.holder.NpcHolder;
import l2s.gameserver.geometry.Location;
import l2s.gameserver.model.Creature;
import l2s.gameserver.model.GameObjectsStorage;
import l2s.gameserver.model.SimpleSpawner;
import l2s.gameserver.model.instances.NpcInstance;

/**
 * Darion Challenger 7го этажа Tully Workshop
 * @author pchayka
 */
public class DarionChallenger extends Fighter
{
	private static final int TeleportCube = 32467;

	public DarionChallenger(NpcInstance actor)
	{
		super(actor);
	}

	@Override
	protected void onEvtDead(Creature killer)
	{
		if(checkAllDestroyed())
			try
		{
				SimpleSpawner sp = new SimpleSpawner(NpcHolder.getInstance().getTemplate(TeleportCube));
				//sp.setLoc(new Location(-12527, 279714, -11622, 16384));
				sp.setSpawnRange(new Location(-12527, 279714, -11622, 16384));
				sp.doSpawn(true);
				sp.stopRespawn();
				ThreadPoolManager.getInstance().schedule(new Unspawn(), 600 * 1000L); // 10 mins
		}
		catch(Exception e)
		{
			e.printStackTrace();
		}
		super.onEvtDead(killer);
	}

	private static boolean checkAllDestroyed()
	{
		if(!GameObjectsStorage.getNpcs(true, 25600).isEmpty())
			return false;
		if(!GameObjectsStorage.getNpcs(true, 25601).isEmpty())
			return false;
		if(!GameObjectsStorage.getNpcs(true, 25602).isEmpty())
			return false;

		return true;
	}

	private class Unspawn extends RunnableImpl
	{
		public Unspawn()
		{}

		@Override
		public void runImpl()
		{
			for(NpcInstance npc : GameObjectsStorage.getNpcs(true, TeleportCube))
				npc.deleteMe();
		}
	}
}