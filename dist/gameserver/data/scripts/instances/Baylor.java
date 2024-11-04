package instances;

import ai.BaylorF;
import ai.BaylorGolemAI;
import ai.BaylorS;
import l2s.gameserver.ThreadPoolManager;
import l2s.gameserver.geometry.Location;
import l2s.gameserver.listener.actor.OnDeathListener;
import l2s.gameserver.listener.zone.OnZoneEnterLeaveListener;
import l2s.gameserver.model.Creature;
import l2s.gameserver.model.Zone;
import l2s.gameserver.model.entity.Reflection;
import l2s.gameserver.model.instances.DoorInstance;
import l2s.gameserver.model.instances.NpcInstance;

import java.util.ArrayList;
import java.util.List;

public class Baylor extends Reflection
{
	private static final int BAYLOR = 29213;
	private static final int GOLEM = 29215;
	private static final List<NpcInstance> GOLEMS = new ArrayList<>();

	public Location LOC_1 = new Location(152680, 143576, -12704);
	public Location LOC_2 = new Location(151864, 142040, -12704);

	private static final Location FIRST_POSITION = new Location(153512, 141960, -12736, 10750);
	//private static final Location LAST_POSITION = new Location(153784, 142232, -12762, 0);

	private final DeathListener _deathListener = new DeathListener();

	private static final int[] DOORS = {
		24220009,
		24220011,
		24220012,
		24220014,
		24220015,
		24220016,
		24220017,
		24220019
	};

	public static final Location[] LOCATIONS = {
		new Location(152680, 143576, -12704),
		new Location(151864, 142040, -12704),
		new Location(152104, 141224, -12704),
		new Location(153592, 140344, -12704),
		new Location(154440, 140600, -12704),
		new Location(155016, 141256, -12704),
		new Location(155256, 142088, -12704),
		new Location(154408, 143560, -12704)
	};

	private NpcInstance baylorf = null;
	//private NpcInstance baylors = null;
	private NpcInstance signalNpc = null;

	private boolean zoneLocked = false;

	@Override
	protected void onCreate()
	{
		super.onCreate();
		ZoneListener zoneListener = new ZoneListener(this);
		getZone("[baylor]").addListener(zoneListener);
	}

	public class BaylorSpawn implements Runnable
	{
		private final Reflection reflection;

		public BaylorSpawn(Reflection reflection) {
			this.reflection = reflection;
		}

		@Override
		public void run() {
			baylorf = addSpawnWithoutRespawn(BAYLOR, FIRST_POSITION, 0);
			baylorf.addListener(_deathListener);
			baylorf.setAI(new BaylorF(baylorf));

			//ThreadPoolManager.getInstance().schedule(() ->
			//{
			//	baylorf.setAI(new BaylorF(baylorf));
			//	baylors = addSpawnWithoutRespawn(BAYLOR, LAST_POSITION, 0);
			//	baylors.addListener(_deathListener);
			//	baylors.setAI(new BaylorS(baylors));
			//}, 18000);

			for(int i = 0; i < LOCATIONS.length; i++) {
				Location loc = LOCATIONS[i];
				DoorDeathListener doorDeathListener = new DoorDeathListener(DOORS[i]);
				for(int j = 0; j < 2; j++) {
					NpcInstance npc = addSpawnWithoutRespawn(GOLEM, Location.findPointToStay(loc, 900, reflection.getGeoIndex()), 0);
					npc.addListener(doorDeathListener);
					npc.setAI(new BaylorGolemAI(npc));
					GOLEMS.add(npc);
				}
			}

			signalNpc = addSpawnWithoutRespawn(18474, Location.findPointToStay(new Location(154360, 142072, -12736), 0, getGeoIndex()), 0);
		}
	}

	private static class DoorDeathListener implements OnDeathListener
	{
		private int count = 0;
		private int doorId = -1;

		public DoorDeathListener(int doorId) {
			this.doorId = doorId;
		}

		@Override
		public void onDeath(Creature actor, Creature killer) {
			if (actor.isNpc() && actor.getNpcId() == GOLEM) {
				count++;
				if(count == 2) {
					Reflection ref = actor.getReflection();
					if (doorId > 0 && ref != null && ref.getDoor(doorId) != null) {
						DoorInstance door = ref.getDoor(doorId);
						door.openMe(killer.getPlayer(), false);
					}
				}
			}
		}
	}

	private class DeathListener implements OnDeathListener
	{
		@Override
		public void onDeath(Creature self, Creature killer)
		{
			if(self.isNpc() && self == baylorf)
			{
				if(self == baylorf)
				{
					self.removeListener(_deathListener);
					baylorf = null;
				}
				else
				{
					self.removeListener(_deathListener);
				}

				if(baylorf == null)
				{
					setReenterTime(System.currentTimeMillis(), true);
					startCollapseTimer(5, true);

					// npc clean up
					if (signalNpc != null) {
						signalNpc.deleteMe();
					}
					signalNpc = null;
					for (NpcInstance golem : GOLEMS) {
						if (golem != null) {
							golem.deleteMe();
						}
					}
					GOLEMS.clear();
					for (NpcInstance npc : getNpcs(true)) {
						if (npc.getNpcId() == 40012)
						{
							continue;
						}
						npc.deleteMe();
					}
				}
			}
		}
	}

	public class ZoneListener implements OnZoneEnterLeaveListener
	{
		private final Reflection reflection;

		public ZoneListener(Reflection reflection)
		{
			this.reflection = reflection;
		}

		@Override
		public void onZoneEnter(Zone zone, Creature cha)
		{
			if(zoneLocked || cha == null || !cha.isPlayer())
			{
				return;
			}
			zoneLocked = true;

			ThreadPoolManager.getInstance().schedule(new BaylorSpawn(reflection), 10000);
		}

		@Override
		public void onZoneLeave(Zone zone, Creature cha)
		{
			//
		}
	}
}