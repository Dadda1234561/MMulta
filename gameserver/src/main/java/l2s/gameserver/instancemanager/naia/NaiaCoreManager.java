package l2s.gameserver.instancemanager.naia;

import l2s.commons.geometry.Polygon;
import l2s.commons.util.Rnd;
import l2s.gameserver.ThreadPoolManager;
import l2s.gameserver.geometry.Location;
import l2s.gameserver.geometry.Territory;
import l2s.gameserver.model.GameObjectsStorage;
import l2s.gameserver.model.Zone;
import l2s.gameserver.model.instances.NpcInstance;
import l2s.gameserver.utils.Functions;
import l2s.gameserver.utils.NpcUtils;
import l2s.gameserver.utils.ReflectionUtils;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

/**
 * @author pchayka
 */
public final class NaiaCoreManager
{
	private static final Logger _log = LoggerFactory.getLogger(NaiaTowerManager.class);
	private static final NaiaCoreManager _instance = new NaiaCoreManager();
	private static Zone _zone;
	private static boolean _active = false;
	private static boolean _bossSpawned = false;
	private static final Territory _coreTerritory = new Territory().add(new Polygon().add(-44789, 246305).add(-44130, 247452).add(-46092, 248606).add(-46790, 247414).add(-46139, 246304).setZmin(-14220).setZmax(-13800));

	//Spores
	private static final int fireSpore = 25605;
	private static final int waterSpore = 25606;
	private static final int windSpore = 25607;
	private static final int earthSpore = 25608;
	//Bosses
	private static final int fireEpidos = 25609;
	private static final int waterEpidos = 25610;
	private static final int windEpidos = 25611;
	private static final int earthEpidos = 25612;

	private static final int teleCube = 32376;

	private static final int respawnDelay = 120; // 2min
	private static final long coreClearTime = 4 * 60 * 60 * 1000L; // 4hours
	private static final Location spawnLoc = new Location(-45496, 246744, -14209);

	public static final NaiaCoreManager getInstance()
	{
		return _instance;
	}

	public NaiaCoreManager()
	{
		_zone = ReflectionUtils.getZone("[naia_core_poison]");
		_log.info("Naia Core Manager: Loaded");
	}

	public static void launchNaiaCore()
	{
		if(isActive())
			return;

		_active = true;
		ReflectionUtils.getDoor(18250025).closeMe();
		_zone.setActive(true);
		NpcUtils.spawnSimple(fireSpore, _coreTerritory, 10, 30);
		NpcUtils.spawnSimple(waterSpore, _coreTerritory, 10, 30);
		NpcUtils.spawnSimple(windSpore, _coreTerritory, 10, 30);
		NpcUtils.spawnSimple(earthSpore, _coreTerritory, 10, 30);
		ThreadPoolManager.getInstance().schedule(new ClearCore(), coreClearTime);
	}

	private static boolean isActive()
	{
		return _active;
	}

	public static void setZoneActive(boolean value)
	{
		_zone.setActive(value);
	}

	public static void spawnEpidos(int index)
	{
		if(!isActive())
			return;
		
		int epidostospawn = 0;
		switch(index)
		{
			case 1:
			{
				epidostospawn = fireEpidos;
				break;
			}
			case 2:
			{
				epidostospawn = waterEpidos;
				break;
			}
			case 3:
			{
				epidostospawn = windEpidos;
				break;
			}
			case 4:
			{
				epidostospawn = earthEpidos;
				break;
			}
			default:
				break;
		}

		_bossSpawned = NpcUtils.spawnSingle(epidostospawn, spawnLoc) != null;
	}

	public static boolean isBossSpawned()
	{
		return _bossSpawned;
	}

	public static void removeSporesAndSpawnCube()
	{
		int[] spores = { fireSpore, waterSpore, windSpore, earthSpore };
		for(NpcInstance spore : GameObjectsStorage.getNpcs(false, spores))
			spore.deleteMe();

		NpcInstance npc = NpcUtils.spawnSingle(teleCube, spawnLoc);
		Functions.npcShout(npc, "Teleportation to Beleth Throne Room is available for 2 minutes");
	}

	private static class ClearCore implements Runnable
	{
		@Override
		public void run()
		{
			int[] spores = { fireSpore, waterSpore, windSpore, earthSpore };
			int[] epidoses = { fireEpidos, waterEpidos, windEpidos, earthEpidos };
			for(NpcInstance spore : GameObjectsStorage.getNpcs(false, spores))
				spore.deleteMe();
			for(NpcInstance epidos : GameObjectsStorage.getNpcs(false, epidoses))
				epidos.deleteMe();

			_active = false;
			ReflectionUtils.getDoor(18250025).openMe();
			_zone.setActive(false);
		}
	}
}