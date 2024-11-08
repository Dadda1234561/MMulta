package zones;

import l2s.commons.math.random.RndSelector;
import l2s.gameserver.ThreadPoolManager;
import l2s.gameserver.ai.CtrlEvent;
import l2s.gameserver.listener.script.OnInitScriptListener;
import l2s.gameserver.listener.zone.OnZoneEnterLeaveListener;
import l2s.gameserver.model.Creature;
import l2s.gameserver.model.Player;
import l2s.gameserver.model.Zone;
import l2s.gameserver.model.instances.NpcInstance;
import l2s.gameserver.utils.NpcUtils;
import l2s.gameserver.utils.ReflectionUtils;

public class MonsterTrap implements OnInitScriptListener
{
	private static ZoneListener _zoneListener;
	private static String[] zones = {
			"[SoD_trap_center]",
			"[SoD_trap_left]",
			"[SoD_trap_right]",
			"[SoD_trap_left_back]",
			"[SoD_trap_right_back]"
	};

	@Override
	public void onInit()
	{
		_zoneListener = new ZoneListener();

		for(String s : zones)
		{
			Zone zone = ReflectionUtils.getZone(s);
			zone.addListener(_zoneListener);
		}
	}

	private class ZoneListener implements OnZoneEnterLeaveListener
	{
		@Override
		public void onZoneEnter(Zone zone, Creature cha)
		{
			Player player = cha.getPlayer();
			if(player == null || zone.getParams() == null)
				return;

			String[] params;

			int reuse = zone.getParams().getInteger("reuse"); // В секундах
			int despawn = zone.getParams().getInteger("despawn", 5 * 60); // В секундах
			boolean attackOnSpawn = zone.getParams().getBool("attackOnSpawn", true);
			long currentMillis = System.currentTimeMillis();
			long nextReuse = zone.getParams().getLong("nextReuse", currentMillis);
			if(nextReuse > currentMillis)
				return;
			zone.getParams().set("nextReuse", currentMillis + reuse * 1000L);

			//Структура: chance1:id11,id12...;chance2:id21,id22...
			String[] groups = zone.getParams().getString("monsters").split(";");
			RndSelector<int[]> rnd = new RndSelector<int[]>();
			for(String group : groups)
			{
				//Структура: chance:id1,id2,idN
				params = group.split(":");
				int chance = Integer.parseInt(params[0]);
				params = params[1].split(",");
				int[] mobs = new int[params.length];
				for(int j = 0; j < params.length; j++)
					mobs[j] = Integer.parseInt(params[j]);
				rnd.add(mobs, chance);
			}

			int[] mobs = rnd.chance();

			for(int npcId : mobs)
			{
				NpcInstance mob = NpcUtils.spawnSingle(npcId, zone.getTerritory(), player.getReflection(), despawn * 1000L);
				if(mob != null)
				{
					if(mob.isAggressive() && attackOnSpawn)
						mob.getAI().notifyEvent(CtrlEvent.EVT_AGGRESSION, player, 100);
				}
			}
		}

		@Override
		public void onZoneLeave(Zone zone, Creature cha)
		{
			//
		}
	}
}
