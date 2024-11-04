package zones;

import java.util.List;
import java.util.concurrent.TimeUnit;

import l2s.commons.util.Rnd;
import l2s.gameserver.ThreadPoolManager;
import l2s.gameserver.instancemanager.SpawnManager;
import l2s.gameserver.listener.script.OnInitScriptListener;
import l2s.gameserver.model.GameObjectsStorage;
import l2s.gameserver.model.Player;
import l2s.gameserver.model.Zone;
import l2s.gameserver.model.World;
import l2s.gameserver.network.l2.components.NpcString;
import l2s.gameserver.network.l2.s2c.EventTriggerPacket;
import l2s.gameserver.network.l2.s2c.ExShowScreenMessage;
import l2s.gameserver.network.l2.s2c.L2GameServerPacket;
import l2s.gameserver.utils.ReflectionUtils;

/**
 * @author Bonux
 */
public class KainakVillage implements OnInitScriptListener
{
	private class ChangeStatus implements Runnable
	{
		@Override
		public void run()
		{
			changeVillageStatus(!_isNowPeace);
		}
	}

	private static final String PEACE_ZONE_NAME = "[kainac_peace_zone_1]";
	private static final String BATTLE_ZONE_NAME = "[kainac_battle_zone_1]";

	private static final long PEACE_ZONE_DELAY = TimeUnit.MILLISECONDS.convert(3, TimeUnit.HOURS); // 3 ч. TODO: Перепроверить.
	private static final long BATTLE_ZONE_DELAY = TimeUnit.MILLISECONDS.convert(1, TimeUnit.HOURS); // 1 ч. TODO: Перепроверить.

	private static final int PVP_TRIGGER = 20140700;

	private static final String ASSASSINS_KAINAK_SPAWN_GROUP = "assassing_kainak";

	private boolean _isNowPeace = true;

	@Override
	public void onInit()
	{
		changeVillageStatus(Rnd.chance(75));
	}

	private void changeVillageStatus(boolean peace)
	{
		_isNowPeace = peace;

		Zone zone = ReflectionUtils.getZone(!_isNowPeace ? PEACE_ZONE_NAME : BATTLE_ZONE_NAME);
		zone.setActive(false);
		zone = ReflectionUtils.getZone(_isNowPeace ? PEACE_ZONE_NAME : BATTLE_ZONE_NAME);
		zone.setActive(true);

		L2GameServerPacket trigger = new EventTriggerPacket(PVP_TRIGGER, !_isNowPeace);
		for(Player player : GameObjectsStorage.getPlayers(false, false))
			player.sendPacket(trigger);

		List<Player> players = World.getPlayersOnMap(18, 14);
		players.addAll(World.getPlayersOnMap(19, 13));
		players.addAll(World.getPlayersOnMap(19, 14));
		players.addAll(World.getPlayersOnMap(19, 15));
		players.addAll(World.getPlayersOnMap(20, 13));
		players.addAll(World.getPlayersOnMap(20, 14));
		players.addAll(World.getPlayersOnMap(20, 15));

		L2GameServerPacket msg = new ExShowScreenMessage(!_isNowPeace ? NpcString.GAINAK_IN_WAR : NpcString.GAINAK_IN_PEACE, 5000, ExShowScreenMessage.ScreenMessageAlign.TOP_CENTER, true, 1, 0, true);
		for(Player player : players)
			player.sendPacket(msg);

		if(_isNowPeace)
			SpawnManager.getInstance().despawn(ASSASSINS_KAINAK_SPAWN_GROUP);
		else
			SpawnManager.getInstance().spawn(ASSASSINS_KAINAK_SPAWN_GROUP);

		ThreadPoolManager.getInstance().schedule(new ChangeStatus(), _isNowPeace ? PEACE_ZONE_DELAY : BATTLE_ZONE_DELAY);
	}
}