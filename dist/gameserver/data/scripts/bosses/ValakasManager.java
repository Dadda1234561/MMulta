package bosses;

import static l2s.gameserver.ai.CtrlIntention.AI_INTENTION_ACTIVE;

import java.util.ArrayList;
import java.util.List;
import java.util.concurrent.ScheduledFuture;

import l2s.commons.util.Rnd;
import l2s.gameserver.Announcements;
import l2s.gameserver.ThreadPoolManager;
import l2s.gameserver.geometry.Location;
import l2s.gameserver.listener.actor.OnDeathListener;
import l2s.gameserver.listener.script.OnInitScriptListener;
import l2s.gameserver.model.Creature;
import l2s.gameserver.model.EpicBossState;
import l2s.gameserver.model.Player;
import l2s.gameserver.model.Zone;
import l2s.gameserver.model.actor.listener.CharListenerList;
import l2s.gameserver.model.instances.BossInstance;
import l2s.gameserver.model.instances.NpcInstance;
import l2s.gameserver.network.l2.components.ChatType;
import l2s.gameserver.network.l2.components.NpcString;
import l2s.gameserver.network.l2.s2c.ExShowScreenMessage;
import l2s.gameserver.network.l2.s2c.PlaySoundPacket;
import l2s.gameserver.network.l2.s2c.SocialActionPacket;
import l2s.gameserver.skills.SkillEntry;
import l2s.gameserver.skills.SkillEntryType;
import l2s.gameserver.utils.ItemFunctions;
import l2s.gameserver.utils.Log;
import l2s.gameserver.utils.NpcUtils;
import l2s.gameserver.utils.ReflectionUtils;
import l2s.gameserver.utils.TimeUtils;

import l2s.gameserver.utils.Util;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import l2s.gameserver.model.EpicBossState.State;
import spawns.TersiManager;

/**
 * @author pchayka
 */
public class ValakasManager implements OnInitScriptListener
{
	public static final long THIRTY_MIN_IN_MILLIS = (30 * 60 * 1000L);
	private static final Logger _log = LoggerFactory.getLogger(ValakasManager.class);

	public static class DeathListener implements OnDeathListener
	{
		@Override
		public void onDeath(Creature self, Creature killer)
		{
			if(self.isPlayer() && _state != null && _state.getState() == State.ALIVE && _zone != null && _zone.checkIfInZone(self.getX(), self.getY()))
				checkAnnihilated();
			else if(self.isNpc() && self.getNpcId() == Valakas)
				ThreadPoolManager.getInstance().schedule(new SpawnDespawn(12), 1);
		}
	}

	public static final Location TELEPORT_POSITION = new Location(203940, -111840, 66);

	private static final int _teleportCubeLocation[][] = {{214880, -116144, -1644, 0},
			{213696, -116592, -1644, 0},
			{212112, -116688, -1644, 0},
			{211184, -115472, -1664, 0},
			{210336, -114592, -1644, 0},
			{211360, -113904, -1644, 0},
			{213152, -112352, -1644, 0},
			{214032, -113232, -1644, 0},
			{214752, -114592, -1644, 0},
			{209824, -115568, -1421, 0},
			{210528, -112192, -1403, 0},
			{213120, -111136, -1408, 0},
			{215184, -111504, -1392, 0},
			{215456, -117328, -1392, 0},
			{213200, -118160, -1424, 0}};

	private static List<NpcInstance> _teleportCube = new ArrayList<NpcInstance>();
	private static List<NpcInstance> _spawnedMinions = new ArrayList<NpcInstance>();
	private static BossInstance _valakas;

	// Tasks.
	private static ScheduledFuture<?> _valakasSpawnTask = null;
	private static ScheduledFuture<?> _intervalEndTask = null;
	private static ScheduledFuture<?> _announceTask = null;
	private static ScheduledFuture<?> _socialTask = null;
	private static ScheduledFuture<?> _mobiliseTask = null;
	private static ScheduledFuture<?> _moveAtRandomTask = null;
	private static ScheduledFuture<?> _respawnValakasTask = null;
	private static ScheduledFuture<?> _sleepCheckTask = null;
	private static ScheduledFuture<?> _onAnnihilatedTask = null;

	private static final int Valakas = 29028;
	private static final int _teleportCubeId = 31759;
	private static EpicBossState _state;
	private static Zone _zone;

	private static long _lastAttackTime = 0;

	private static final OnDeathListener DEATH_LISTENER = new DeathListener();

	private static boolean Dying = false;

	private static boolean _entryLocked = false;

	private static class CheckLastAttack implements Runnable
	{
		@Override
		public void run()
		{
			if(_state.getState() == EpicBossState.State.ALIVE)
				if(_lastAttackTime + (BossesConfig.VALAKAS_SLEEP_TIME * 60000) < System.currentTimeMillis())
					sleep();
				else
					_sleepCheckTask = ThreadPoolManager.getInstance().schedule(new CheckLastAttack(), 60000);
		}
	}

	private static class IntervalEnd implements Runnable
	{
		@Override
		public void run()
		{
			_state.setState(EpicBossState.State.NOTSPAWN);
			_state.save();
		}
	}

	private static class onAnnihilated implements Runnable
	{
		@Override
		public void run()
		{
			sleep();
		}
	}

	private static class SpawnDespawn implements Runnable
	{
		private int _distance = 2550;
		private int _taskId;
		private List<Player> _players = getPlayersInside();

		SpawnDespawn(int taskId)
		{
			_taskId = taskId;
		}

		@Override
		public void run()
		{
			if(_taskId == 1)
			{
				// Do spawn.
				_valakas = (BossInstance) NpcUtils.spawnSingle(Valakas, new Location(212852, -114842, -1632, 833));
				if(_valakas == null)
				{
					_log.warn(ValakasManager.class.getSimpleName() + ": Valakas cannot spawned!");
					return;
				}

				_entryLocked = true;

				_valakas.block();
				_valakas.broadcastPacket(new PlaySoundPacket(PlaySoundPacket.Type.MUSIC, "BS03_A", 1, _valakas.getObjectId(), _valakas.getLoc()));

				_state.setNextRespawnDate(getRespawnTime());
				_state.setState(EpicBossState.State.ALIVE);
				_state.save();

				_socialTask = ThreadPoolManager.getInstance().schedule(new SpawnDespawn(2), 16);
				return;
			}

			if(_valakas == null)
			{
				_log.warn(ValakasManager.class.getSimpleName() + ": Cannot find Valakas npc!");
				return;
			}

			switch(_taskId)
			{
				case 2:
					// Do social.
					_valakas.broadcastPacket(new SocialActionPacket(_valakas.getObjectId(), 1));

					// Set camera.
					for(Player pc : _players)
						if(pc.getDistance(_valakas) <= _distance)
						{
							pc.enterMovieMode();
							pc.specialCamera(_valakas, 1800, 180, -1, 1500, 15000, 0, 0, 1, 0);
						}
						else
							pc.leaveMovieMode();

					_socialTask = ThreadPoolManager.getInstance().schedule(new SpawnDespawn(3), 1500);
					break;
				case 3:
					// Set camera.
					for(Player pc : _players)
						if(pc.getDistance(_valakas) <= _distance)
						{
							pc.enterMovieMode();
							pc.specialCamera(_valakas, 1300, 180, -5, 3000, 15000, 0, -5, 1, 0);
						}
						else
							pc.leaveMovieMode();

					_socialTask = ThreadPoolManager.getInstance().schedule(new SpawnDespawn(4), 3300);
					break;
				case 4:
					// Set camera.
					for(Player pc : _players)
						if(pc.getDistance(_valakas) <= _distance)
						{
							pc.enterMovieMode();
							pc.specialCamera(_valakas, 500, 180, -8, 600, 15000, 0, 60, 1, 0);
						}
						else
							pc.leaveMovieMode();

					_socialTask = ThreadPoolManager.getInstance().schedule(new SpawnDespawn(5), 2900);
					break;
				case 5:
					// Set camera.
					for(Player pc : _players)
						if(pc.getDistance(_valakas) <= _distance)
						{
							pc.enterMovieMode();
							pc.specialCamera(_valakas, 800, 180, -8, 2700, 15000, 0, 30, 1, 0);
						}
						else
							pc.leaveMovieMode();

					_socialTask = ThreadPoolManager.getInstance().schedule(new SpawnDespawn(6), 2700);
					break;
				case 6:
					// Set camera.
					for(Player pc : _players)
						if(pc.getDistance(_valakas) <= _distance)
						{
							pc.enterMovieMode();
							pc.specialCamera(_valakas, 200, 250, 70, 0, 15000, 30, 80, 1, 0);
						}
						else
							pc.leaveMovieMode();

					_socialTask = ThreadPoolManager.getInstance().schedule(new SpawnDespawn(7), 1);
					break;
				case 7:
					// Set camera.
					for(Player pc : _players)
						if(pc.getDistance(_valakas) <= _distance)
						{
							pc.enterMovieMode();
							pc.specialCamera(_valakas, 1100, 250, 70, 2500, 15000, 30, 80, 1, 0);
						}
						else
							pc.leaveMovieMode();

					_socialTask = ThreadPoolManager.getInstance().schedule(new SpawnDespawn(8), 3200);
					break;
				case 8:
					// Set camera.
					for(Player pc : _players)
						if(pc.getDistance(_valakas) <= _distance)
						{
							pc.enterMovieMode();
							pc.specialCamera(_valakas, 700, 150, 30, 0, 15000, -10, 60, 1, 0);
						}
						else
							pc.leaveMovieMode();

					_socialTask = ThreadPoolManager.getInstance().schedule(new SpawnDespawn(9), 1400);
					break;
				case 9:
					// Set camera.
					for(Player pc : _players)
						if(pc.getDistance(_valakas) <= _distance)
						{
							pc.enterMovieMode();
							pc.specialCamera(_valakas, 1200, 150, 20, 2900, 15000, -10, 30, 1, 0);
						}
						else
							pc.leaveMovieMode();

					_socialTask = ThreadPoolManager.getInstance().schedule(new SpawnDespawn(10), 6700);
					break;
				case 10:
					// Set camera.
					for(Player pc : _players)
						if(pc.getDistance(_valakas) <= _distance)
						{
							pc.enterMovieMode();
							pc.specialCamera(_valakas, 750, 170, -10, 3400, 15000, 10, -15, 1, 0);
						}
						else
							pc.leaveMovieMode();

					_socialTask = ThreadPoolManager.getInstance().schedule(new SpawnDespawn(11), 5700);
					break;
				case 11:
					// Reset camera.
					for(Player pc : _players)
						pc.leaveMovieMode();

					_valakas.unblock();
					broadcastScreenMessage(NpcString.VALAKAS_ARROGAANT_FOOL_YOU_DARE_TO_CHALLENGE_ME);

					// Move at random.
					if(_valakas.getAI().getIntention() == AI_INTENTION_ACTIVE)
						_valakas.getMovement().moveToLocation(new Location(Rnd.get(211080, 214909), Rnd.get(-115841, -112822), -1662, 0), 0, false);

					_sleepCheckTask = ThreadPoolManager.getInstance().schedule(new CheckLastAttack(), 600000);
					break;

				// Death Movie
				case 12:
					_valakas.broadcastPacket(new PlaySoundPacket(PlaySoundPacket.Type.MUSIC, "B03_D", 1, _valakas.getObjectId(), _valakas.getLoc()));
					broadcastScreenMessage(NpcString.VALAKAS_THE_EVIL_FIRE_DRAGON_VALAKAS_DEFEATED);
					onValakasDie();
					for(Player pc : _players)
						if(pc.getDistance(_valakas) <= _distance)
						{
							pc.enterMovieMode();
							pc.specialCamera(_valakas, 2000, 130, -1, 0, 15000, 0, 0, 1, 1);
						}
						else
							pc.leaveMovieMode();

					_socialTask = ThreadPoolManager.getInstance().schedule(new SpawnDespawn(13), 500);
					break;
				case 13:
					for(Player pc : _players)
						if(pc.getDistance(_valakas) <= _distance)
						{
							pc.enterMovieMode();
							pc.specialCamera(_valakas, 1100, 210, -5, 3000, 15000, -13, 0, 1, 1);
						}
						else
							pc.leaveMovieMode();

					_socialTask = ThreadPoolManager.getInstance().schedule(new SpawnDespawn(14), 3500);
					break;
				case 14:
					for(Player pc : _players)
						if(pc.getDistance(_valakas) <= _distance)
						{
							pc.enterMovieMode();
							pc.specialCamera(_valakas, 1300, 200, -8, 3000, 15000, 0, 15, 1, 1);
						}
						else
							pc.leaveMovieMode();

					_socialTask = ThreadPoolManager.getInstance().schedule(new SpawnDespawn(15), 4500);
					break;
				case 15:
					for(Player pc : _players)
						if(pc.getDistance(_valakas) <= _distance)
						{
							pc.enterMovieMode();
							pc.specialCamera(_valakas, 1000, 190, 0, 500, 15000, 0, 10, 1, 1);
						}
						else
							pc.leaveMovieMode();

					_socialTask = ThreadPoolManager.getInstance().schedule(new SpawnDespawn(16), 500);
					break;
				case 16:
					for(Player pc : _players)
						if(pc.getDistance(_valakas) <= _distance)
						{
							pc.enterMovieMode();
							pc.specialCamera(_valakas, 1700, 120, 0, 2500, 15000, 12, 40, 1, 1);
						}
						else
							pc.leaveMovieMode();

					_socialTask = ThreadPoolManager.getInstance().schedule(new SpawnDespawn(17), 4600);
					break;
				case 17:
					for(Player pc : _players)
						if(pc.getDistance(_valakas) <= _distance)
						{
							pc.enterMovieMode();
							pc.specialCamera(_valakas, 1700, 20, 0, 700, 15000, 10, 10, 1, 1);
						}
						else
							pc.leaveMovieMode();

					_socialTask = ThreadPoolManager.getInstance().schedule(new SpawnDespawn(18), 750);
					break;
				case 18:
					for(Player pc : _players)
						if(pc.getDistance(_valakas) <= _distance)
						{
							pc.enterMovieMode();
							pc.specialCamera(_valakas, 1700, 10, 0, 1000, 15000, 20, 70, 1, 1);
						}
						else
							pc.leaveMovieMode();

					_socialTask = ThreadPoolManager.getInstance().schedule(new SpawnDespawn(19), 2500);
					break;
				case 19:
					for(Player pc : _players)
					{
						pc.leaveMovieMode();
						pc.altOnMagicUse(pc, SkillEntry.makeSkillEntry(SkillEntryType.NONE, 23312, 1));
					}
					break;
			}
		}
	}

	private static void banishForeigners()
	{
		for(Player player : getPlayersInside())
			player.teleToClosestTown();
	}

	private synchronized static void checkAnnihilated()
	{
		if(_onAnnihilatedTask == null && isPlayersAnnihilated())
			_onAnnihilatedTask = ThreadPoolManager.getInstance().schedule(new onAnnihilated(), 5000);
	}

	private static List<Player> getPlayersInside()
	{
		return getZone().getInsidePlayers();
	}

	private static long getRespawnTime()
	{
		return BossesConfig.VALAKAS_RESPAWN_TIME_PATTERN.next(System.currentTimeMillis());
	}

	public static Zone getZone()
	{
		return _zone;
	}

	private static boolean isPlayersAnnihilated()
	{
		for(Player pc : getPlayersInside())
			if(!pc.isDead())
				return false;
		return true;
	}

	private static void onValakasDie()
	{
		if(Dying)
			return;

		Dying = true;
		_state.setNextRespawnDate(getRespawnTime());
		_state.setState(EpicBossState.State.INTERVAL);
		_state.save();

		_entryLocked = false;
		for(int[] ints : _teleportCubeLocation)
			_teleportCube.add(NpcUtils.spawnSingle(_teleportCubeId, new Location(ints[0], ints[1], ints[2], ints[3])));
		Log.add("Valakas died", "bosses");
		Announcements.announceToAll(new ExShowScreenMessage(NpcString.THE_EVIL_FIRE_DRAGON_VALAKAS_HAS_BEEN_DEFEATED_, 10000, ExShowScreenMessage.ScreenMessageAlign.TOP_CENTER, true, true));
		TersiManager.spawnTersi();
	}

	// Start interval.
	private static void setIntervalEndTask()
	{
		setUnspawn();

		if(_state.getState().equals(EpicBossState.State.ALIVE))
		{
			_state.setState(EpicBossState.State.NOTSPAWN);
			_state.save();
			return;
		}

		if(!_state.getState().equals(EpicBossState.State.INTERVAL))
		{
			_state.setNextRespawnDate(getRespawnTime());
			_state.setState(EpicBossState.State.INTERVAL);
			_state.save();
		}

		final long remainingTime = _state.getInterval();
		if (_state.getState().equals(State.INTERVAL) && remainingTime > THIRTY_MIN_IN_MILLIS)
		{
			final long announceDelay = (remainingTime - THIRTY_MIN_IN_MILLIS);
			// cancel old
			if (_announceTask != null)
			{
				_announceTask.cancel(false);
				_announceTask = null;
			}
			// schedule new
			_announceTask = ThreadPoolManager.getInstance().schedule(() -> Announcements.announceToAllFromStringHolder("custom.CustomEpicBoss.PreSpawn", "Valakas", "30"), announceDelay);
			_log.info("ValakasManager: Scheduled pre-spawn announce to " + TimeUtils.toSimpleFormat(System.currentTimeMillis() + announceDelay));
		}
		else
		{
			_log.info("ValakasManager: Not scheduling pre-spawn announce to as time to spawn is " + TimeUtils.toSimpleFormat(System.currentTimeMillis() + remainingTime) + ". [" + Util.formatTime((int) (remainingTime / 1000)) + " ]");
		}

		_intervalEndTask = ThreadPoolManager.getInstance().schedule(new IntervalEnd(), remainingTime);
	}

	// Clean Valakas's lair.
	private static void setUnspawn()
	{
		// Eliminate players.
		banishForeigners();

		_entryLocked = false;

		if(_valakas != null)
			_valakas.deleteMe();

		for(NpcInstance npc : _spawnedMinions)
			npc.deleteMe();

		// Delete teleport cube.
		for(NpcInstance cube : _teleportCube)
		{
			cube.getSpawn().stopRespawn();
			cube.deleteMe();
		}
		_teleportCube.clear();

		if(_valakasSpawnTask != null)
		{
			_valakasSpawnTask.cancel(false);
			_valakasSpawnTask = null;
		}
		if(_intervalEndTask != null)
		{
			_intervalEndTask.cancel(false);
			_intervalEndTask = null;
		}
		if(_socialTask != null)
		{
			_socialTask.cancel(false);
			_socialTask = null;
		}
		if(_mobiliseTask != null)
		{
			_mobiliseTask.cancel(false);
			_mobiliseTask = null;
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
		if(_respawnValakasTask != null)
		{
			_respawnValakasTask.cancel(false);
			_respawnValakasTask = null;
		}
		if(_onAnnihilatedTask != null)
		{
			_onAnnihilatedTask.cancel(false);
			_onAnnihilatedTask = null;
		}
	}

	private static void sleep()
	{
		setUnspawn();
		if(_state.getState().equals(EpicBossState.State.ALIVE))
		{
			_state.setState(EpicBossState.State.NOTSPAWN);
			_state.save();
		}
	}

	public static void setLastAttackTime()
	{
		_lastAttackTime = System.currentTimeMillis();
	}

	// Setting Valakas spawn task.
	//public synchronized static void setValakasSpawnTask()
	//{
	//	if(_valakasSpawnTask == null)
	//		_valakasSpawnTask = ThreadPoolManager.getInstance().schedule(new SpawnDespawn(1), BossesConfig.VALAKAS_SPAWN_DELAY * 60000);
	//}

	public static boolean isSpawnTaskStarted()
	{
		return _valakasSpawnTask != null;
	}

	public static void broadcastScreenMessage(NpcString npcs)
	{
		for(Player p : getPlayersInside())
			p.sendPacket(new ExShowScreenMessage(npcs, 8000, ExShowScreenMessage.ScreenMessageAlign.TOP_CENTER, false));
	}

	public static void addValakasMinion(NpcInstance npc)
	{
		_spawnedMinions.add(npc);
	}

	@Override
	public void onInit()
	{
		CharListenerList.addGlobal(DEATH_LISTENER);
		_state = new EpicBossState(Valakas);
		_zone = ReflectionUtils.getZone("[valakas_epic]");
		_log.info("ValakasManager: State of Valakas is " + _state.getState() + ".");
		if(!_state.getState().equals(EpicBossState.State.NOTSPAWN))
		{
			setIntervalEndTask();
			_log.info("ValakasManager: Next spawn date of Valakas is " + TimeUtils.toSimpleFormat(_state.getRespawnDate()) + ".");
		}
	}

	public static boolean isReborned()
	{
		return _state.getState() == EpicBossState.State.NOTSPAWN;
	}

	public static boolean isEntryLocked()
	{
		return _entryLocked;
	}

	public static boolean checkRequiredItems(Player player)
	{
		for(int[] item : BossesConfig.VALAKAS_ENTERANCE_NECESSARY_ITEMS)
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
		if(BossesConfig.VALAKAS_ENTERANCE_CAN_CONSUME_NECESSARY_ITEMS)
		{
			for(int[] item : BossesConfig.VALAKAS_ENTERANCE_NECESSARY_ITEMS)
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