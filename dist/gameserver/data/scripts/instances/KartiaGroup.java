package instances;

import l2s.gameserver.geometry.Location;
import l2s.gameserver.network.l2.components.NpcString;
import l2s.gameserver.templates.npc.WalkerRoutePoint;

/**
 * @author Evil_dnk
 * @reworked by Bonux
**/
public class KartiaGroup extends Kartia
{
	static
	{
		FIRST_STATE_WALKER_ROUTE.addPoint(new WalkerRoutePoint(new Location(-120888, -10456, -11680), new NpcString[0], -1, 5, true, false)); // На оффе в этой точке они тупят 5 секунд.
		FIRST_STATE_WALKER_ROUTE.addPoint(new WalkerRoutePoint(new Location(-119880, -10456, -11920), new NpcString[0], -1, 0, true, false));
	}

	@Override
	protected void onCreate()
	{
		_roomDoorId = 16170012;
		_raidDoorId = 16170013;

		_excludedZoneTeleportLoc = new Location(-119832, -10424, -11920);

		_rulerSpawnLoc = new Location(-120864, -15872, -11400, 15596);
		_supportTroopsSpawnLoc = new Location(-120901, -14562, -11424, 47595);

		_kartiaAltharSpawnLoc = new Location(-119684, -10453, -11307, 0);
		_ssqCameraLightSpawnLoc = new Location(-119684, -10453, -11307, 0);
		_ssqCameraZoneSpawnLoc = new Location(-119907, -10443, -11924, 0);

		_instanceZone = getZone("[kartia_instance_party]");
		_excludedInstanceZone = getZone("[kartia_excluded_zone_party]");

		_aggroStartPointLoc = new Location(-120854, -13928, -11462);
		_aggroMovePointLoc = new Location(-120854, -13928, -11462);

		_monsterMovePointLoc = new Location(-120872, -15080, -11452);

		super.onCreate();

		startChallenge();
	}
}