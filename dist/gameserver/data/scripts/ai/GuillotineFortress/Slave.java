package ai.GuillotineFortress;

import java.util.List;

import l2s.gameserver.ThreadPoolManager;
import l2s.gameserver.ai.Fighter;
import l2s.gameserver.model.GameObjectsStorage;
import l2s.gameserver.model.Player;
import l2s.gameserver.model.World;
import l2s.gameserver.model.instances.NpcInstance;
import l2s.gameserver.network.l2.components.NpcString;
import l2s.gameserver.utils.NpcUtils;

/*
 * User: Iqman
 * Date: 21.05.13
 * Time: 19:39
 * Location: Guillotine Fortress raid stage 3 mass attack
 */
public class Slave extends Fighter
{
    public Slave(NpcInstance actor)
	{
        super(actor);
    }

	@Override
	protected void onEvtSpawn()
	{
		super.onEvtSpawn();

		List<NpcInstance> npcs = GameObjectsStorage.getNpcs(true, 25892);
		if(npcs.isEmpty())
			return; //dead

		List<Player> list = World.getAroundPlayers(npcs.get(0), 1200, 1200);
		if(list == null || list.isEmpty())
			return; //everyone died

		for(Player player : list)
		{
			getActor().getAggroList().addDamageHate(player, 10000, 10000);	//full hate
			break; //only the first for his side.
		}
		ThreadPoolManager.getInstance().schedule(new Despawn(), 300000L); //250 mobs is too much for us for server in one place
	}
	
	@Override
	protected boolean randomWalk()
	{
		return false;
	}
	
	private class Despawn implements Runnable
	{
		@Override
		public void run()
		{
			if(getActor() != null)
				getActor().deleteMe();
		}
	}	
}
