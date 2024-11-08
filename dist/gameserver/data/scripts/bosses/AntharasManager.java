package bosses;

import java.util.List;
import java.util.concurrent.ScheduledFuture;
import java.util.concurrent.TimeUnit;
import java.util.concurrent.atomic.AtomicInteger;

import l2s.gameserver.Announcements;
import l2s.gameserver.ThreadPoolManager;
import l2s.gameserver.ai.NpcAI;
import l2s.gameserver.geometry.Location;
import l2s.gameserver.instancemanager.SpawnManager;
import l2s.gameserver.listener.actor.OnDeathListener;
import l2s.gameserver.listener.zone.OnZoneEnterLeaveListener;
import l2s.gameserver.model.Creature;
import l2s.gameserver.model.EpicBossState;
import l2s.gameserver.model.Player;
import l2s.gameserver.model.Spawner;
import l2s.gameserver.model.Zone;
import l2s.gameserver.model.instances.NpcInstance;
import l2s.gameserver.network.l2.components.NpcString;
import l2s.gameserver.network.l2.s2c.ExShowScreenMessage;
import l2s.gameserver.scripts.annotation.OnScriptInit;
import l2s.gameserver.utils.ItemFunctions;
import l2s.gameserver.utils.Log;
import l2s.gameserver.utils.ReflectionUtils;
import l2s.gameserver.utils.TimeUtils;

import l2s.gameserver.utils.Util;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import ai.AntharasAI;
import l2s.gameserver.model.EpicBossState.State;
import spawns.TersiManager;

/**
 * @author pchayka
 * @reworked by Bonux
**/
public class AntharasManager
{

	public static final long THIRTY_MIN_IN_MILLIS = (30 * 60 * 1000L);

	private static class DungeonZoneListener implements OnZoneEnterLeaveListener
	{
		@Override
		public void onZoneEnter(Zone zone, Creature actor)
		{
			if(actor.isPlayer())
				actor.addListener(DUNGEON_PLAYER_LISTENERS);
			if (_processState.get() == NONE_STATE && _startAntharasRaid == null)
			{
				_startAntharasRaid = ThreadPoolManager.getInstance().schedule(AntharasManager::startAntharasBoss, TimeUnit.MINUTES.toMillis(10));
			}
		}

		@Override
		public void onZoneLeave(Zone zone, Creature actor)
		{
			if(actor.isPlayer())
				actor.removeListener(DUNGEON_PLAYER_LISTENERS);
		}
	}

	public static class DungeonPlayerListeners implements OnDeathListener
	{
		@Override
		public void onDeath(Creature self, Creature killer)
		{
			if(!self.isPlayer())
				return;

			if(_state.getState() == State.ALIVE)
				checkAnnihilated();
		}
	}

	private static final Logger _log = LoggerFactory.getLogger(AntharasManager.class);

	// Constants
	public static final Location TELEPORT_POSITION = new Location(179700, 113800, -7709);

	private static final int ANTHARAS_NPC_ID = 29068;	// Антарас - Дракон Земли

	private static final DungeonZoneListener ZONE_LISTENER = new DungeonZoneListener();
	private static final DungeonPlayerListeners DUNGEON_PLAYER_LISTENERS = new DungeonPlayerListeners();

	// tasks.
	private static ScheduledFuture<?> _intervalEndTask = null;
	private static ScheduledFuture<?> _startAntharasRaid = null;
	private static ScheduledFuture<?> _announceTask = null;
	private static ScheduledFuture<?> _moveAtRandomTask = null;
	private static ScheduledFuture<?> _sleepCheckTask = null;
	private static ScheduledFuture<?> _onAnnihilatedTask = null;

	// Process States
	private static final int NONE_STATE = 0;
	private static final int STARTED_STATE = 1;
	private static final int ENTRY_LOCKED_STATE = 2;
	private static final int DYING_STATE = 3;

	// Vars
	private static final AtomicInteger _processState = new AtomicInteger(NONE_STATE);

	private static NpcInstance _antharasNpc = null;
	private static EpicBossState _state;
	private static Zone _zone;
	private static long _lastAttackTime = 0;

	@OnScriptInit
	public static void onInit()
	{
		_state = new EpicBossState(ANTHARAS_NPC_ID);
		_zone = ReflectionUtils.getZone("[antharas_epic]");
		_zone.addListener(ZONE_LISTENER);

		_log.info(AntharasManager.class.getSimpleName() + ": State of Antharas is " + _state.getState() + ".");

		if(!_state.getState().equals(State.NOTSPAWN))
		{
			setIntervalEndTask();
			_log.info(AntharasManager.class.getSimpleName() + ": Next spawn date of Antharas is " + TimeUtils.toSimpleFormat(_state.getRespawnDate()) + ".");
		}
	}

	public static NpcInstance getAntharasNpc()
	{
		return _antharasNpc;
	}

	public static Zone getZone()
	{
		return _zone;
	}

	private static long getRespawnTime()
	{
		return BossesConfig.ANTHARAS_RESPAWN_TIME_PATTERN.next(System.currentTimeMillis());
	}

	public static boolean isBossStarted()
	{
		return _processState.get() >= STARTED_STATE;
	}

	public static boolean isEntryLocked()
	{
		return _processState.get() == ENTRY_LOCKED_STATE;
	}

	public static boolean isReborned()
	{
		return _state.getState() == State.NOTSPAWN;
	}

	public static List<Player> getPlayersInside()
	{
		return getZone().getInsidePlayers();
	}

	private static boolean isPlayersAnnihilated()
	{
		for(Player player : getPlayersInside())
		{
			if(!player.isDead())
				return false;
		}
		return true;
	}

	public static void setLastAttackTime()
	{
		_lastAttackTime = System.currentTimeMillis();
	}

	public static void startAntharasBoss()
	{
		if(!_processState.compareAndSet(NONE_STATE, ENTRY_LOCKED_STATE))
			return;

		if (_startAntharasRaid != null)
		{
			_startAntharasRaid.cancel(false);
			_startAntharasRaid = null;
		}

		List<Spawner> spawners = SpawnManager.getInstance().spawn("antharas_dungeon_boss", false);
		loop: for(Spawner spawner : spawners)
		{
			for(NpcInstance npc : spawner.getAllSpawned())
			{
				if(npc.getNpcId() == ANTHARAS_NPC_ID)
				{
					_antharasNpc = npc;
					break loop;
				}
			}
		}

		if(_antharasNpc == null)
		{
			_processState.set(NONE_STATE);
			_log.warn(AntharasManager.class.getSimpleName() + ": Antharas cannot spawned!");
			return;
		}

		NpcAI ai = _antharasNpc.getAI();
		if(ai instanceof AntharasAI)
		{
			((AntharasAI) ai).startPresentation(1000);
		}
	}

	public static void closeEntry()
	{
		if(!_processState.compareAndSet(STARTED_STATE, ENTRY_LOCKED_STATE))
			return;

		_state.setNextRespawnDate(getRespawnTime());
		_state.setState(State.ALIVE);
		_state.save();
	}

	public static void startSleepCheckTask()
	{
		_sleepCheckTask = ThreadPoolManager.getInstance().schedule(() ->{
			if(_state.getState() == State.ALIVE)
			{
				if(_lastAttackTime + (BossesConfig.ANTHARAS_SLEEP_TIME * 60000) < System.currentTimeMillis())
					sleep();
				else
					startSleepCheckTask();
			}
		}, 60000);
	}

	private synchronized static void checkAnnihilated()
	{
		if(!isPlayersAnnihilated())
			return;

		if(_onAnnihilatedTask == null)
			_onAnnihilatedTask = ThreadPoolManager.getInstance().schedule(() -> sleep(), 5000);
	}

	public static void onAntharasDie()
	{
		if(!_processState.compareAndSet(ENTRY_LOCKED_STATE, DYING_STATE))
			return;

		_state.setNextRespawnDate(getRespawnTime());
		_state.setState(State.INTERVAL);
		_state.save();

		SpawnManager.getInstance().spawn("antharas_dungeon_cube", false);
		Log.add("Antharas died", "bosses");
		Announcements.announceToAll(new ExShowScreenMessage(NpcString.THE_EVIL_LAND_DRAGON_ANTHARAS_HAS_BEEN_DEFEATED_BY_BRAVE_HEROES_, 10000, ExShowScreenMessage.ScreenMessageAlign.TOP_CENTER, true, true));
		TersiManager.spawnTersi();
	}

	private static void setIntervalEndTask()
	{
		setUnspawn();

		if(_state.getState().equals(State.ALIVE))
		{
			_state.setState(State.NOTSPAWN);
			_state.save();
			return;
		}

		if(!_state.getState().equals(State.INTERVAL))
		{
			_state.setNextRespawnDate(getRespawnTime());
			_state.setState(State.INTERVAL);
			_state.save();
		}

		final long remainingTime = _state.getInterval();
		if (_state.getState().equals(State.INTERVAL) && remainingTime > THIRTY_MIN_IN_MILLIS)
		{
			final long announceDelay = (remainingTime - THIRTY_MIN_IN_MILLIS);
			// cancel old task
			if (_announceTask != null)
			{
				_announceTask.cancel(false);
				_announceTask = null;
			}
			// schedule announce task
			_announceTask = ThreadPoolManager.getInstance().schedule(() -> Announcements.announceToAllFromStringHolder("custom.CustomEpicBoss.PreSpawn", "Antharas", "30"), announceDelay);
			_log.info("AntharasManager: Scheduled pre-spawn announce to " + TimeUtils.toSimpleFormat(System.currentTimeMillis() + announceDelay));
		}
		else
		{
			_log.info("AntharasManager: Not scheduling pre-spawn announce to as time to spawn is " + TimeUtils.toSimpleFormat(System.currentTimeMillis() + remainingTime) + ". [" + Util.formatTime((int) (remainingTime / 1000)) + " ]");
		}

		_intervalEndTask = ThreadPoolManager.getInstance().schedule(() ->
		{
			_state.setState(State.NOTSPAWN);
			_state.save();
		}, remainingTime);
	}

	// clean Antharas's lair.
	private static void setUnspawn()
	{
		if(_intervalEndTask != null)
		{
			_intervalEndTask.cancel(false);
			_intervalEndTask = null;
		}
		if(_moveAtRandomTask != null)
		{
			_moveAtRandomTask.cancel(false);
			_moveAtRandomTask = null;
		}
		if(_sleepCheckTask != null)
		{
			_sleepCheckTask.cancel(false);
			_sleepCheckTask = null;
		}
		if(_onAnnihilatedTask != null)
		{
			_onAnnihilatedTask.cancel(false);
			_onAnnihilatedTask = null;
		}
		if (_startAntharasRaid != null)
		{
			_startAntharasRaid.cancel(true);
			_startAntharasRaid = null;
		}
		if (_announceTask != null)
		{
			_announceTask.cancel(false);
			_announceTask = null;
		}

		// eliminate players.
		for(Player player : getPlayersInside())
			player.teleToClosestTown();

		SpawnManager.getInstance().despawn("antharas_dungeon_boss");
		SpawnManager.getInstance().despawn("antharas_dungeon_cube");

		_antharasNpc = null;

		_processState.set(NONE_STATE);
	}

	private static void sleep()
	{
		setUnspawn();
		if(_state.getState().equals(State.ALIVE))
		{
			_state.setState(State.NOTSPAWN);
			_state.save();
		}
	}

	public static boolean checkRequiredItems(Player player)
	{
		for(int[] item : BossesConfig.ANTHARAS_ENTERANCE_NECESSARY_ITEMS)
		{
			int itemId = item.length > 0 ? item[0] : 0;
			int itemCount = item.length > 1 ? item[1] : 0;
			if(itemId > 0 && itemCount > 0 && !ItemFunctions.haveItem(player, itemId, itemCount))
				return false;
		}
		return true;
	}

	public static boolean consumeRequiredItems(Player player)
	{
		if(BossesConfig.ANTHARAS_ENTERANCE_CAN_CONSUME_NECESSARY_ITEMS)
		{
			for(int[] item : BossesConfig.ANTHARAS_ENTERANCE_NECESSARY_ITEMS)
			{
				int itemId = item.length > 0 ? item[0] : 0;
				int itemCount = item.length > 1 ? item[1] : 0;
				if(itemId > 0 && itemCount > 0 && !ItemFunctions.deleteItem(player, itemId, itemCount, true))
					return false;
			}
		}
		return true;
	}
}