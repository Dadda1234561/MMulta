package bosses;

import l2s.commons.geometry.Polygon;
import l2s.commons.util.Rnd;
import l2s.gameserver.ThreadPoolManager;
import l2s.gameserver.ai.DefaultAI;
import l2s.gameserver.ai.NpcAI;
import l2s.gameserver.data.xml.holder.SkillHolder;
import l2s.gameserver.geometry.Location;
import l2s.gameserver.geometry.Territory;
import l2s.gameserver.listener.actor.OnCurrentHpDamageListener;
import l2s.gameserver.listener.actor.OnDeathListener;
import l2s.gameserver.listener.script.OnInitScriptListener;
import l2s.gameserver.listener.zone.OnZoneEnterLeaveListener;
import l2s.gameserver.model.Creature;
import l2s.gameserver.model.EpicBossState;
import l2s.gameserver.model.Player;
import l2s.gameserver.model.Skill;
import l2s.gameserver.model.Spawner;
import l2s.gameserver.model.Zone;
import l2s.gameserver.model.actor.instances.creature.Abnormal;
import l2s.gameserver.model.instances.NpcInstance;
import l2s.gameserver.network.l2.components.NpcString;
import l2s.gameserver.network.l2.components.SceneMovie;
import l2s.gameserver.network.l2.s2c.ExShowScreenMessage;
import l2s.gameserver.network.l2.s2c.ExShowScreenMessage.ScreenMessageAlign;
import l2s.gameserver.network.l2.s2c.FlyToLocationPacket;
import l2s.gameserver.network.l2.s2c.L2GameServerPacket;
import l2s.gameserver.network.l2.s2c.MagicSkillUse;
import l2s.gameserver.network.l2.s2c.PlaySoundPacket;
import l2s.gameserver.network.l2.s2c.updatetype.NpcInfoType;
import l2s.gameserver.skills.SkillEntry;
import l2s.gameserver.skills.SkillEntryType;
import l2s.gameserver.utils.ItemFunctions;
import l2s.gameserver.utils.NpcUtils;
import l2s.gameserver.utils.ReflectionUtils;
import l2s.gameserver.utils.TimeUtils;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.Collections;
import java.util.List;
import java.util.concurrent.ScheduledFuture;
import java.util.concurrent.TimeUnit;
import java.util.concurrent.atomic.AtomicBoolean;
import java.util.concurrent.atomic.AtomicInteger;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

/**
 * @reworked by Bonux
**/
public class HeliosManager implements OnInitScriptListener
{
	private static final Logger _log = LoggerFactory.getLogger(HeliosManager.class);

	private static class ZoneEnterLeaveListener implements OnZoneEnterLeaveListener
	{
		@Override
		public void onZoneEnter(Zone zone, Creature actor)
		{
			if(!isStarted())
			{
				if(actor.isPlayer())
					actor.getPlayer().teleToClosestTown();
			}
		}

		@Override
		public void onZoneLeave(Zone zone, Creature actor)
		{
			//
		}
	}

	private static class CheckLastAttack implements Runnable
	{
		@Override
		public void run()
		{
			if(_state.getState() == EpicBossState.State.ALIVE)
			{
				if(_lastAttackTime + (BossesConfig.HELIOS_SLEEP_TIME * TimeUnit.MINUTES.toMillis(1)) < System.currentTimeMillis())
					sleep();
				else
					_sleepCheckTask = ThreadPoolManager.getInstance().schedule(new CheckLastAttack(), TimeUnit.MINUTES.toMillis(1));
			}
		}
	}

	public static class DeathListener implements OnDeathListener
	{
		@Override
		public void onDeath(Creature self, Creature killer)
		{
			if(self.getNpcId() == FINAL_HELIOS_NPC_ID)
			{
				if(_stage.compareAndSet(4, 0))
				{
					broadcastPacket(new ExShowScreenMessage(NpcString.HELIOS_DEFEATED_TAKES_FLIGHT_DEEP_IN_TO_THE_SUPERION_FORT_HIS_THRONE_IS_RENDERED_INACTIVE, 10000, ScreenMessageAlign.TOP_CENTER, true, true));
					heliosSay("Npcdialog1.helios_battle_11");
					deleteNpcs();
					_state.setNextRespawnDate(getRespawnTime());
					_state.setState(EpicBossState.State.INTERVAL);
					_state.save();
				}
			}
			else if(self.getNpcId() == MIMILLION_NPC_ID)
			{
				broadcastPacket(new ExShowScreenMessage(NpcString.MIMILLION_FALLS_AND_THE_RED_LIGHTNING_SPEAR_VANISHES, 10000, ScreenMessageAlign.TOP_CENTER, true, true));
				_redTriggerNpc.removeEventTrigger(RED_EVENT_TRIGGER_ID);
				_redTriggerNpc.deleteMe();
			}
			else if(self.getNpcId() == MIMILLUS_NPC_ID)
			{
				broadcastPacket(new ExShowScreenMessage(NpcString.MIMILLUS_FALLS_AND_THE_BLUE_LIGHTNING_SPEAR_VANISHES, 10000, ScreenMessageAlign.TOP_CENTER, true, true));
				_blueTriggerNpc.removeEventTrigger(BLUE_EVENT_TRIGGER_ID);
				_blueTriggerNpc.deleteMe();
			}
		}
	}

	public static class CurrentHpListener implements OnCurrentHpDamageListener
	{
		private boolean lock = false;

		@Override
		public void onCurrentHpDamage(final Creature actor, double damage, Creature attacker, Skill skill)
		{
			if(actor == null || actor.isDead())
				return;

			if(lock)
				return;

			lock = true;

			if(actor.getNpcId() == FIRST_HELIOS_NPC_ID)
			{
				_lastAttackTime = System.currentTimeMillis();

				if(Rnd.chance(5))
					heliosSay(Rnd.get(HELIOS_RANDOM_PHRASES));

				if(_stage.compareAndSet(2, 3))
				{
					broadcastPacket(new ExShowScreenMessage(NpcString.THE_ADEN_WARRIORS_BEGIN_BATTLE_WITH_THE_GIANT_EMPEROR_HELIOS, 10000, ScreenMessageAlign.TOP_CENTER, true, true));
					heliosSay("Npcdialog1.helios_battle_1");

					_sleepCheckTask = ThreadPoolManager.getInstance().schedule(new CheckLastAttack(), TimeUnit.MINUTES.toMillis(10));
					_minionTask = ThreadPoolManager.getInstance().scheduleAtFixedRate(() -> {
						heliosSay("Npcdialog1.helios_battle_2");

							Location loc = HELIOS_MINIONS_SPAWN_TERRITORY.getRandomLoc(_heliosNpc.getGeoIndex(), false);
							for(int j = 0; j < 2; j++)
							{
								_royalNpcs.add(NpcUtils.spawnSingle(ROYAL_TEMPLAR_COLONEL_NPC_ID, Location.findPointToStay(loc, 0, 300, _heliosNpc.getGeoIndex()).setH(loc.h)));
								_royalNpcs.add(NpcUtils.spawnSingle(ROYAL_SHARPSHOOTER_NPC_ID, Location.findPointToStay(loc, 0, 300, _heliosNpc.getGeoIndex()).setH(loc.h)));
								_royalNpcs.add(NpcUtils.spawnSingle(ROYAL_ARCHMAGE_NPC_ID, Location.findPointToStay(loc, 0, 300, _heliosNpc.getGeoIndex()).setH(loc.h)));
								_royalNpcs.add(NpcUtils.spawnSingle(ROYAL_GATEKEEPER_NPC_ID, Location.findPointToStay(loc, 0, 300, _heliosNpc.getGeoIndex()).setH(loc.h)));
								TimeUnit.MINUTES.toMillis(30000);
							}


						ThreadPoolManager.getInstance().schedule(() -> {
							broadcastPacket(new ExShowScreenMessage(NpcString.HELIOS_BEGINS_ENCHANTING_HIS_GIANT_MINIONS_ON_THE_ADEN_CONTINENT_USING_THE_EMPERORS_AUTHORITY, 10000, ScreenMessageAlign.TOP_CENTER, true, true));
							actor.broadcastPacket(new MagicSkillUse(actor, HELIOS_RAGE_SKILL_ID, 1, 2000, 0));
							for(NpcInstance npc : _royalNpcs)
							{
								if(!npc.isVisible() || npc.isDead())
									continue;

								int level = 0;
								int maxLevel = 0;
								for(Abnormal abnormal : npc.getAbnormalList())
								{
									if(abnormal.getSkill().getId() == HELIOS_RAGE_SKILL_ID)
									{
										level = abnormal.getSkill().getLevel();
										maxLevel = abnormal.getSkill().getMaxLevel();
										break;
									}
								}

								Skill s = SkillHolder.getInstance().getSkill(HELIOS_RAGE_SKILL_ID, Math.min(level + 1, maxLevel));
								if(s != null)
									s.getEffects(actor, npc);
							}
						}, TimeUnit.SECONDS.toMillis(15));
					}, TimeUnit.MINUTES.toMillis(1), TimeUnit.MINUTES.toMillis(3));
				}

				if(actor.getCurrentHp() - damage < actor.getMaxHp() * 0.60)
				{
					broadcastPacket(new ExShowScreenMessage(NpcString.HELIOS_APPEARANCE_CHANGES_AND_HE_BEGINS_TO_GROW_STRONGER, 10000, ScreenMessageAlign.TOP_CENTER, true, true));
					actor.removeListener(this);
					ThreadPoolManager.getInstance().schedule(() -> {
						heliosSay("Npcdialog1.helios_battle_10");
						actor.deleteMe();

						for(Player player : _epicZone.getInsidePlayers())
							player.startScenePlayer(SceneMovie.SC_HELIOS_TRANS_A);

						_heliosNpc = NpcUtils.spawnSingle(SECOND_HELIOS_NPC_ID, HELIOS_SPAWN_LOC);
						_heliosNpc.getFlags().getImmobilized().start(HeliosManager.class);
						_heliosNpc.addListener(_currentHpListener);
					}, TimeUnit.SECONDS.toMillis(2));
				}
			}
			else if(actor.getNpcId() == SECOND_HELIOS_NPC_ID)
			{
				_lastAttackTime = System.currentTimeMillis();

				if(Rnd.chance(5))
					heliosSay(Rnd.get(HELIOS_RANDOM_PHRASES));

				if(_stage.compareAndSet(3, 4))
				{
					ThreadPoolManager.getInstance().schedule(HeliosManager::startLeopoldTask, TimeUnit.MINUTES.toMillis(1));
					ThreadPoolManager.getInstance().schedule(HeliosManager::startKamaelTask, TimeUnit.MINUTES.toMillis(2));

					ThreadPoolManager.getInstance().schedule(() -> {
						ThreadPoolManager.getInstance().schedule(() -> {
							broadcastPacket(new ExShowScreenMessage(NpcString.HELIOS_PICKS_UP_THE_RED_LIGHTNING_SPEAR_AND_BEGINS_GATHERING_HIS_POWER, 10000, ScreenMessageAlign.TOP_CENTER, true, true));
							_redTriggerNpc = NpcUtils.spawnSingle(HELIOS_RED_LIGHTNING_NPC_ID, HELIOS_RED_LIGHTNING_SPAWN_LOC);
							_redTriggerNpc.addEventTrigger(RED_EVENT_TRIGGER_ID);
						}, TimeUnit.SECONDS.toMillis(10));

						ThreadPoolManager.getInstance().schedule(() -> {
							broadcastPacket(new ExShowScreenMessage(NpcString.HELIOS_PICKS_UP_THE_BLUE_LIGHTNING_SPEAR_AND_BEGINS_GATHERING_HIS_POWER, 10000, ScreenMessageAlign.TOP_CENTER, true, true));
							_blueTriggerNpc = NpcUtils.spawnSingle(HELIOS_BLUE_LIGHTNING_NPC_ID, HELIOS_BLUE_LIGHTNING_SPAWN_LOC);
							_blueTriggerNpc.addEventTrigger(BLUE_EVENT_TRIGGER_ID);
						}, TimeUnit.SECONDS.toMillis(20));

						ThreadPoolManager.getInstance().schedule(() -> {
							broadcastPacket(new ExShowScreenMessage(NpcString.MIMILLION_AND_MIMILLUS_APPEAR_IN_ORDER_TO_PROTECT_THE_ENUMA_ELISH_OF_RED_LIGHTNING_AND_THE_ENUMA_ELISH_OF_BLUE_LIGHTNING, 10000, ScreenMessageAlign.TOP_CENTER, true, true));
							NpcInstance npc = NpcUtils.spawnSingle(MIMILLION_NPC_ID, MIMILLION_SPAWN_LOC);
							npc.addListener(_deathListener);
							_otherNpcs.add(npc);
							npc = NpcUtils.spawnSingle(MIMILLUS_NPC_ID, MIMILLUS_SPAWN_LOC);
							npc.addListener(_deathListener);
							_otherNpcs.add(npc);
						}, TimeUnit.SECONDS.toMillis(30));
					}, TimeUnit.MINUTES.toMillis(3));
				}

				if(actor.getCurrentHp() - damage < actor.getMaxHp() * 0.3)
				{
					broadcastPacket(new ExShowScreenMessage(NpcString.HELIOS_APPEARANCE_CHANGES_AND_HE_BEGINS_TO_GROW_STRONGER, 10000, ScreenMessageAlign.TOP_CENTER, true, true));
					actor.removeListener(this);
					ThreadPoolManager.getInstance().schedule(() -> {
						heliosSay("Npcdialog1.helios_battle_10");
						actor.deleteMe();

						for(Player player : _epicZone.getInsidePlayers())
							player.startScenePlayer(SceneMovie.SC_HELIOS_TRANS_B);

						_heliosNpc = NpcUtils.spawnSingle(FINAL_HELIOS_NPC_ID, HELIOS_SPAWN_LOC);
						_heliosNpc.getFlags().getImmobilized().start(HeliosManager.class);
						_heliosNpc.addListener(_currentHpListener);
						_heliosNpc.addListener(_deathListener);

						ThreadPoolManager.getInstance().schedule(() -> {
							broadcastPacket(new ExShowScreenMessage(NpcString.HELIOS_USES_THE_PRANARACH_SHIELD_OF_LIGHT_TO_MINIMIZE_DAMAGE, 10000, ScreenMessageAlign.TOP_CENTER, true, true));
							actor.broadcastPacket(new MagicSkillUse(actor, SHIELD_OF_LIGHT_PRANARACH_100_SKILL_ID, 1, 2000, 0));
							SkillHolder.getInstance().getSkill(SHIELD_OF_LIGHT_PRANARACH_100_SKILL_ID, 1).getEffects(_heliosNpc, _heliosNpc);
						}, TimeUnit.SECONDS.toMillis(30));

					}, TimeUnit.SECONDS.toMillis(2));
				}
			}
			else if(actor.getNpcId() == FINAL_HELIOS_NPC_ID)
			{
				_lastAttackTime = System.currentTimeMillis();
			}
			lock = false;
		}
	}

	// NPC's
	private static final int LEOPOLD_RED_DECAL_NPC_ID = 19645;	// Красное Клеймо Леопольда
	private static final int LEOPOLD_BLUE_DECAL_NPC_ID = 19646;	// Синее Клеймо Леопольда
	private static final int FIRST_HELIOS_NPC_ID = 29303;	// Хелиос (Первая стадия)
	private static final int SECOND_HELIOS_NPC_ID = 29304;	// Хелиос (Втора стадия)
	private static final int FINAL_HELIOS_NPC_ID = 29305;	// Хелиос (Финальная стадия)
	private static final int LEOPOLD_NPC_ID = 29306;	// Леопольд
	private static final int HELIOS_RED_LIGHTNING_NPC_ID = 29307;	// Красная Молния Хелиоса
	private static final int HELIOS_BLUE_LIGHTNING_NPC_ID = 29308;	// Синяя Молния Хелиоса
	private static final int LEOPOLD_ORIGIN_NPC_ID = 29309;	// Сущность Леопольда
	private static final int ENUMA_ELISH_ORIGIN_NPC_ID = 29310;	// Сущность Леопольда
	private static final int ROYAL_TEMPLAR_COLONEL_NPC_ID = 29311;	// Королевский Храмовник Полковник
	private static final int ROYAL_SHARPSHOOTER_NPC_ID = 29312;	// Королевский Меткий Стрелок
	private static final int ROYAL_ARCHMAGE_NPC_ID = 29313;	// Королевский Архимаг
	private static final int ROYAL_GATEKEEPER_NPC_ID = 29314;	// Королевский Хранитель Портала
	private static final int MIMILLION_NPC_ID = 29315;	// Мимирион
	private static final int MIMILLUS_NPC_ID = 29316;	// Мимирус

	// Skills
	private static final int SHIELD_OF_LIGHT_PRANARACH_100_SKILL_ID = 16624;	// Щит Света - Пранарах (100%)
	private static final int HELIOS_RAGE_SKILL_ID = 16625;	// Гнев Хелиоса
	private static final int LEOPOLD_BOMB_SKILL_ID = 16629;	// Ночь Леопольда
	private static final int LEOPOLD_PLASMA_BOMB_SKILL_ID = 16630;	// Плазменная Бомба Леопольда
	private static final int LEOPOLD_ENERGY_BOMB_SKILL_ID = 16631;	// Энергетическая Бомба Леопольда

	// Other
	private static final int BLUE_EVENT_TRIGGER_ID = 22220000;
	private static final int RED_EVENT_TRIGGER_ID = 22220002;

	// Locations
	public static final Location TELEPORT_POSITION = new Location(79304, 153608, 2304);

	private static final Location HELIOS_SPAWN_LOC = new Location(92773, 161910, 3488, 39293);
	private static final Location HELIOS_RED_LIGHTNING_SPAWN_LOC = new Location(92344, 162552, 3488);
	private static final Location HELIOS_BLUE_LIGHTNING_SPAWN_LOC = new Location(92308, 161272, 3488);
	private static final Location MIMILLION_SPAWN_LOC = new Location(92168, 162424, 3488, 39293);
	private static final Location MIMILLUS_SPAWN_LOC = new Location(93032, 161160, 3488, 39293);

	private static final Location[] LEOPOLD_SPAWN_LOCATIONS = {
		new Location(89675, 161791, 3672, 55296),
		new Location(90207, 162146, 3672, 55296),
		new Location(90905, 162613, 3672, 55296),
		new Location(91298, 162875, 3672, 55296),
		new Location(93102, 160174, 3672, 22528),
		new Location(92710, 159912, 3672, 22528),
		new Location(92011, 159445, 3672, 22528),
		new Location(91479, 159090, 3672, 22528)
	};

	private static final Location[] KAMAEL_1_SPAWN_LOCATIONS = {
		new Location(91818, 163121, 4242, 55220),
		new Location(92015, 163261, 4244, 55136),
		new Location(91754, 162962, 3987, 55664),
		new Location(91967, 163101, 3987, 54708),
		new Location(91516, 163125, 3987, 38204),
		new Location(93616, 160608, 4246, 22540),
		new Location(93714, 161539, 3599, 38152),
		new Location(93944, 161260, 3901, 39008),
		new Location(93692, 160762, 3982, 22436),
		new Location(93479, 160629, 3982, 21976),
		new Location(93478, 160211, 3982, 38408),
		new Location(93344, 160425, 3984, 39552),
		new Location(92606, 163302, 3897, 40756),
		new Location(92691, 163173, 3897, 39456),
		new Location(93662, 161801, 3599, 32116),
		new Location(92872, 162789, 3601, 46764),
		new Location(93083, 162708, 3601, 39020)
	};

	private static final Location[] KAMAEL_2_SPAWN_LOCATIONS = {
		new Location(92992, 162762, 3601, 43768),
		new Location(92799, 162882, 3601, 38680),
		new Location(93650, 161899, 3598, 38836),
		new Location(92645, 163241, 3897, 39808),
		new Location(93403, 160324, 3984, 39320),
		new Location(93582, 160698, 3982, 22828),
		new Location(93382, 160557, 3982, 22420),
		new Location(93907, 161327, 3901, 38892),
		new Location(93984, 161200, 3901, 39132),
		new Location(93712, 160672, 4243, 23616),
		new Location(93520, 160544, 4244, 21504),
		new Location(93636, 161647, 3599, 31380),
		new Location(91590, 163009, 3987, 39140),
		new Location(91917, 163190, 4245, 55508),
		new Location(91874, 163036, 3987, 55792),
		new Location(92071, 163169, 3987, 54852),
		new Location(91423, 163235, 3987, 38400)
	};

	private static final Territory HELIOS_MINIONS_SPAWN_TERRITORY = new Territory().add(new Polygon().add(92040, 162824).add(93336, 160904).add(91400, 159608).add(90136, 161512).setZmin(3388).setZmax(3588));

	private static final String[] HELIOS_RANDOM_PHRASES = {
		"Npcdialog1.helios_battle_3",
		"Npcdialog1.helios_battle_5",
		"Npcdialog1.helios_battle_6",
		"Npcdialog1.helios_battle_7",
		"Npcdialog1.helios_battle_9"
	};

	private static final ZoneEnterLeaveListener _zoneEnterLeaveListener = new ZoneEnterLeaveListener();
	private static final DeathListener _deathListener = new DeathListener();
	private static final CurrentHpListener _currentHpListener = new CurrentHpListener();

	private static Zone _enterZone = null;
	private static Zone _epicZone = null;

	private static NpcInstance _heliosNpc = null;
	private static NpcInstance _redTriggerNpc = null;
	private static NpcInstance _blueTriggerNpc = null;

	private static final List<NpcInstance> _leopoldNpcs = new ArrayList<NpcInstance>();
	private static final List<Spawner> _kamael1Npcs = new ArrayList<Spawner>();
	private static final List<Spawner> _kamael2Npcs = new ArrayList<Spawner>();
	private static final List<NpcInstance> _royalNpcs = new ArrayList<NpcInstance>();
	private static final List<NpcInstance> _otherNpcs = new ArrayList<NpcInstance>();

	private static final EpicBossState _state = new EpicBossState(FINAL_HELIOS_NPC_ID);

	private static final AtomicInteger _stage = new AtomicInteger(0);

	private static final AtomicBoolean _firstKamaelStringSended = new AtomicBoolean(false);

	private static ScheduledFuture<?> _epicSpawnTask;
	private static ScheduledFuture<?> _intervalEndTask = null;
	private static ScheduledFuture<?> _sleepCheckTask;
	private static ScheduledFuture<?> _onAnnihilatedTask;
	private static ScheduledFuture<?> _minionTask = null;
	private static ScheduledFuture<?> _leopoldTask = null;
	private static ScheduledFuture<?> _kamaelTask = null;

	private static long _lastHeliosSay = 0;
	private static long _lastAttackTime = 0;

	@Override
	public void onInit()
	{
		_enterZone = ReflectionUtils.getZone("[helios_enter_zone]");
		_enterZone.addListener(_zoneEnterLeaveListener);
		_epicZone = ReflectionUtils.getZone("[helios_boss_zone_epic]");
		_epicZone.addListener(_zoneEnterLeaveListener);

		_log.info(getClass().getSimpleName() + ": State of Helios is " + _state.getState() + ".");
		if(!_state.getState().equals(EpicBossState.State.NOTSPAWN))
		{
			setIntervalEndTask();
			_log.info(getClass().getSimpleName() + ": Next spawn date of Helios is " + TimeUtils.toSimpleFormat(_state.getRespawnDate()) + ".");
		}
	}

	public synchronized static void startEpic()
	{
		if(!_stage.compareAndSet(0, 1))
			return;

		_epicSpawnTask = ThreadPoolManager.getInstance().schedule(() -> spawnEpic(), BossesConfig.HELIOS_SPAWN_DELAY * TimeUnit.MINUTES.toMillis(1));
	}

	public static void spawnEpic()
	{
		if(!_stage.compareAndSet(1, 2))
			return;

		_heliosNpc = NpcUtils.spawnSingle(FIRST_HELIOS_NPC_ID, HELIOS_SPAWN_LOC);
		_heliosNpc.getFlags().getImmobilized().start(HeliosManager.class);
		_heliosNpc.addListener(_currentHpListener);

		Arrays.stream(LEOPOLD_SPAWN_LOCATIONS).forEach(location -> _leopoldNpcs.add(NpcUtils.spawnSingle(LEOPOLD_NPC_ID, location)));
		Arrays.stream(KAMAEL_1_SPAWN_LOCATIONS).forEach(location -> _kamael1Npcs.add(NpcUtils.spawnSimple(LEOPOLD_ORIGIN_NPC_ID, location, 180, 0)));
		Arrays.stream(KAMAEL_2_SPAWN_LOCATIONS).forEach(location -> _kamael2Npcs.add(NpcUtils.spawnSimple(ENUMA_ELISH_ORIGIN_NPC_ID, location, 180, 0)));
	}

	public static boolean isStarted()
	{
		return _stage.get() > 0;
	}

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

		_intervalEndTask = ThreadPoolManager.getInstance().schedule(() -> {
			_state.setState(EpicBossState.State.NOTSPAWN);
			_state.save();
		}, _state.getInterval());
	}

	private static void setUnspawn()
	{
		if(_epicSpawnTask != null)
		{
			_epicSpawnTask.cancel(false);
			_epicSpawnTask = null;
		}
		if(_intervalEndTask != null)
		{
			_intervalEndTask.cancel(false);
			_intervalEndTask = null;
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

		deleteNpcs();
		banishForeigners();

		if(_heliosNpc != null)
		{
			_heliosNpc.deleteMe();
			_heliosNpc = null;
		}

		_stage.set(0);
		_firstKamaelStringSended.set(false);

		_lastHeliosSay = 0;
		_lastAttackTime = 0;
	}

	private static void deleteNpcs()
	{
		if(_minionTask != null)
		{
			_minionTask.cancel(false);
			_minionTask = null;
		}
		if(_leopoldTask != null)
		{
			_leopoldTask.cancel(false);
			_leopoldTask = null;
		}
		if(_kamaelTask != null)
		{
			_kamaelTask.cancel(false);
			_kamaelTask = null;
		}

		if(_redTriggerNpc != null)
		{
			_redTriggerNpc.deleteMe();
			_redTriggerNpc = null;
		}
		if(_blueTriggerNpc != null)
		{
			_blueTriggerNpc.deleteMe();
			_blueTriggerNpc = null;
		}

		for(NpcInstance npc : _leopoldNpcs)
			npc.deleteMe();

		_leopoldNpcs.clear();

		for(Spawner spawner : _kamael1Npcs)
			spawner.deleteAll();

		_kamael1Npcs.clear();

		for(Spawner spawner : _kamael2Npcs)
			spawner.deleteAll();

		_kamael2Npcs.clear();

		for(NpcInstance npc : _royalNpcs)
			npc.deleteMe();

		_royalNpcs.clear();

		for(NpcInstance npc : _otherNpcs)
			npc.deleteMe();

		_otherNpcs.clear();
	}

	private static void banishForeigners()
	{
		for(Player player : _enterZone.getInsidePlayers())
			player.teleToClosestTown();

		for(Player player : _epicZone.getInsidePlayers())
			player.teleToClosestTown();
	}

	private synchronized static void checkAnnihilated()
	{
		if(_onAnnihilatedTask == null && isPlayersAnnihilated())
			_onAnnihilatedTask = ThreadPoolManager.getInstance().schedule(() -> sleep(), TimeUnit.SECONDS.toMillis(5));
	}

	private static void broadcastPacket(L2GameServerPacket... packets)
	{
		for(Player player : _epicZone.getInsidePlayers())
			player.sendPacket(packets);
	}

	private static boolean isPlayersAnnihilated()
	{
		for(Player player : _epicZone.getInsidePlayers())
		{
			if(!player.isDead())
				return false;
		}
		return true;
	}

	public static int getInsidePlayersCount()
	{
		int result = _enterZone.getInsidePlayers().size();
		result += _epicZone.getInsidePlayers().size();
		return result;
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

	public static boolean isReborned()
	{
		return _state.getState() == EpicBossState.State.NOTSPAWN;
	}

	private static long getRespawnTime()
	{
		return BossesConfig.HELIOS_RESPAWN_TIME_PATTERN.next(System.currentTimeMillis());
	}

	public static boolean checkRequiredItems(Player player)
	{
		for(int[] item : BossesConfig.HELIOS_ENTERANCE_NECESSARY_ITEMS)
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
		if(BossesConfig.HELIOS_ENTERANCE_CAN_CONSUME_NECESSARY_ITEMS)
		{
			for(int[] item : BossesConfig.HELIOS_ENTERANCE_NECESSARY_ITEMS)
			{
				int itemId = item.length > 0 ? item[0] : 0;
				int itemCount = item.length > 1 ? item[1] : 0;
				if(itemId > 0 && itemCount > 0 && !ItemFunctions.deleteItem(player, itemId, itemCount, true))
					return false;
			}
		}
		return true;
	}

	private static void startLeopoldTask()
	{
		if(_leopoldTask != null)
			return;

		for(NpcInstance leopold : _leopoldNpcs)
		{
			leopold.setRHandId(46377); // TODO: Подобрать правильный ID.
			leopold.broadcastCharInfoImpl(NpcInfoType.EQUIPPED);
		}

		_leopoldTask = ThreadPoolManager.getInstance().scheduleAtFixedRate(() -> {
			broadcastPacket(new ExShowScreenMessage(NpcString.THE_SIEGE_CANNON_LEOPOLD_ON_THE_THRONE_OF_HELIOS_BEGINS_TO_PREPARE_TO_FIRE, 10000, ScreenMessageAlign.TOP_CENTER, true, true));
			heliosSay("Npcdialog1.helios_battle_4");
			for(NpcInstance leopold : _leopoldNpcs)
			{
				if(Rnd.chance(33))
				{
					boolean red = Rnd.chance(50);
					leopold.setRHandId(red ? 46377 : 46379); // TODO: Подобрать правильные ID.
					leopold.broadcastCharInfoImpl(NpcInfoType.EQUIPPED);
					ThreadPoolManager.getInstance().schedule(() -> {
						Player player = Rnd.get(_epicZone.getInsidePlayers());
						if(player != null)
						{
							_otherNpcs.add(NpcUtils.spawnSingle(red ? LEOPOLD_RED_DECAL_NPC_ID : LEOPOLD_BLUE_DECAL_NPC_ID, player.getLoc(), 5000));
							Skill skill = SkillHolder.getInstance().getSkill(Rnd.chance(33) ? LEOPOLD_BOMB_SKILL_ID : red ? LEOPOLD_PLASMA_BOMB_SKILL_ID : LEOPOLD_ENERGY_BOMB_SKILL_ID, 1);
							NpcAI ai = leopold.getAI();
							if(ai instanceof DefaultAI)
								((DefaultAI) ai).addTaskCast(player, SkillEntry.makeSkillEntry(SkillEntryType.NONE, skill));
						}
					}, TimeUnit.SECONDS.toMillis(5));
				}
			}
		}, TimeUnit.SECONDS.toMillis(15), TimeUnit.SECONDS.toMillis(45));
	}

	private static void startKamaelTask()
	{
		if(_kamaelTask != null)
			return;

		for(Spawner spawner : _kamael1Npcs)
		{
			for(NpcInstance npc : spawner.getAllSpawned())
			{
				npc.setRHandId(10128); // TODO: Подобрать правильный ID. Применение оружия при респавне.
				npc.broadcastCharInfoImpl(NpcInfoType.EQUIPPED);
			}
		}

		for(Spawner spawner : _kamael2Npcs)
		{
			for(NpcInstance npc : spawner.getAllSpawned())
			{
				npc.setRHandId(15302); // TODO: Подобрать правильный ID. Применение оружия при респавне.
				npc.broadcastCharInfoImpl(NpcInfoType.EQUIPPED);
			}
		}

		_kamaelTask = ThreadPoolManager.getInstance().scheduleAtFixedRate(() -> {
			if(_firstKamaelStringSended.compareAndSet(false, true) || Rnd.chance(20))
			{
				broadcastPacket(new ExShowScreenMessage(NpcString.THE_KAMAEL_ORIGINS_ABOVE_THE_THRONE_OF_HELIOS_BEGIN_TO_SOAR, 10000, ScreenMessageAlign.TOP_CENTER, true, true));
				heliosSay("Npcdialog1.helios_battle_8");
			}
			for(int i = 0; i < 3; i++)
			{
				List<Spawner> kamaels = new ArrayList<Spawner>(Rnd.chance(50) ? _kamael1Npcs : _kamael2Npcs);
				Collections.shuffle(kamaels);
				for(Spawner spawner : kamaels)
				{
					for(NpcInstance kamael : spawner.getAllSpawned())
					{
						if(!kamael.isVisible() || kamael.isDead() || kamael.isInCombat())
							continue;

						Player player = Rnd.get(_epicZone.getInsidePlayers());
						if(player != null)
						{
							kamael.setRunning();
							Location loc = Location.findPointToStay(player.getLoc(), 200, player.getGeoIndex());
							kamael.broadcastPacket(new FlyToLocationPacket(kamael, loc, FlyToLocationPacket.FlyType.THROW_UP, 5, 50, 0));
							ThreadPoolManager.getInstance().schedule(() -> {
								kamael.setLoc(loc);
								kamael.getAggroList().addDamageHate(player, 50_000, 50_000);
								kamael.getAI().Attack(player, true, false);
							}, TimeUnit.SECONDS.toMillis(16));
							break;
						}
					}
				}
			}
		}, TimeUnit.SECONDS.toMillis(1), TimeUnit.SECONDS.toMillis(10));
	}

	private static void heliosSay(String say)
	{
		if((_lastHeliosSay + TimeUnit.SECONDS.toMillis(10)) > System.currentTimeMillis())
			return;

		if(_heliosNpc == null)
			return;

		_lastHeliosSay = System.currentTimeMillis();
		_heliosNpc.broadcastPacket(new PlaySoundPacket(PlaySoundPacket.Type.NPC_VOICE, say, 0, _heliosNpc.getObjectId(), _heliosNpc.getLoc()));
	}
}