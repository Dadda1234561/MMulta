package ai.hellbound;

import l2s.commons.util.Rnd;
import l2s.gameserver.ai.Fighter;
import l2s.gameserver.model.Creature;
import l2s.gameserver.model.GameObjectsStorage;
import l2s.gameserver.model.instances.DoorInstance;
import l2s.gameserver.model.instances.NpcInstance;
import l2s.gameserver.geometry.Location;
import l2s.gameserver.utils.NpcUtils;
import l2s.gameserver.utils.ReflectionUtils;

/**
 * RB Darion на крыше Tully Workshop
 *
 * @author pchayka
 */
public class Darion extends Fighter
{
	private static final int[] doors = {
			20250009,
			20250004,
			20250005,
			20250006,
			20250007
	};

	public Darion(NpcInstance actor)
	{
		super(actor);
	}

	@Override
	protected void onEvtSpawn()
	{
		super.onEvtSpawn();

		NpcInstance actor = getActor();
		for (int i = 0; i < 5; i++) {
			try {
				NpcUtils.spawnSingle(Rnd.get(25614, 25615), Location.findPointToStay(actor, 400, 900));
			} catch (Exception e) {
				e.printStackTrace();
			}
		}

		//Doors
		for(final int doorId : doors)
		{
			DoorInstance door = ReflectionUtils.getDoor(doorId);
			door.closeMe();
		}
	}

	@Override
	protected void onEvtDead(Creature killer)
	{
		//Doors
		for(final int doorId : doors)
		{
			DoorInstance door = ReflectionUtils.getDoor(doorId);
			door.openMe();
		}

		for(NpcInstance npc : GameObjectsStorage.getNpcs(false, 25614))
			npc.deleteMe();

		for(NpcInstance npc : GameObjectsStorage.getNpcs(false, 25615))
			npc.deleteMe();

		super.onEvtDead(killer);
	}

}