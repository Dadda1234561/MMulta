package instances;

import java.util.ArrayList;
import java.util.List;
import java.util.concurrent.ScheduledFuture;

import l2s.commons.util.Rnd;
import l2s.gameserver.ThreadPoolManager;
import l2s.gameserver.ai.CtrlIntention;
import l2s.gameserver.ai.DefaultAI;
import l2s.gameserver.geometry.Location;
import l2s.gameserver.idfactory.IdFactory;
import l2s.gameserver.listener.actor.OnDeathListener;
import l2s.gameserver.listener.zone.OnZoneEnterLeaveListener;
import l2s.gameserver.model.Creature;
import l2s.gameserver.model.GameObject;
import l2s.gameserver.model.Player;
import l2s.gameserver.model.Spawner;
import l2s.gameserver.model.Zone;
import l2s.gameserver.model.entity.Reflection;
import l2s.gameserver.model.instances.DoorInstance;
import l2s.gameserver.model.instances.NpcInstance;
import l2s.gameserver.network.l2.components.NpcString;
import l2s.gameserver.network.l2.s2c.ExShowScreenMessage;
import l2s.gameserver.skills.AbnormalEffect;
import l2s.gameserver.skills.AbnormalType;
import l2s.gameserver.skills.SkillEntry;
import l2s.gameserver.skills.SkillEntryType;
import l2s.gameserver.templates.StatsSet;
import l2s.gameserver.templates.npc.WalkerRoute;
import l2s.gameserver.templates.npc.WalkerRouteType;
import l2s.gameserver.utils.Functions;

/**
 * @author Evil_dnk
 * @reworked by Bonux
**/
public abstract class Kartia extends Reflection
{
	private static enum KartiaState
	{
		NONE(0, 0),
		FARM_1_STAGE(1, 1),
		FARM_2_STAGE(1, 2),
		FARM_3_STAGE(1, 3),
		FARM_4_STAGE(1, 4),
		FARM_5_STAGE(1, 5),
		FARM_6_STAGE(1, 6),
		FARM_7_STAGE(1, 7),
		FARM_8_STAGE(1, 8),
		RB_1_STAGE(2, 1),
		RB_2_STAGE(2, 2),
		RB_3_STAGE(2, 3),
		RB_4_STAGE(2, 4),
		FINISHED(3, 0);

		private final int _phase;
		private final int _stage;

		private KartiaState(int phase, int stage)
		{
			_phase = phase;
			_stage = stage;
		}

		public int getPhase()
		{
			return _phase;
		}

		public int getStage()
		{
			return _stage;
		}
	}

	private class MonsterDeathListener implements OnDeathListener
	{
		@Override
		public void onDeath(Creature victim, Creature killer)
		{
			if(_ruler != null && victim == _ruler)
			{
				cleanup();
				clearReflection(5, true);
				setReenterTime(System.currentTimeMillis(), true);
				if(_expReward > 0 || _spReward > 0)
				{
					for(Player player : getPlayers())
						player.addExpAndSp(_expReward, _spReward);
				}
			}
			else if(victim.getNpcId() == _keeperNpcId)
			{
				if(getStage() == 7)
					startState1();
				else if(getStage() == 8)
					startState2();
			}
			else if(getNpcs(true, _mobType1NpcId).isEmpty() && getNpcs(true, _mobType2NpcId).isEmpty() && getNpcs(true, _keeperNpcId).isEmpty() && getStage() <= 11)
			{
				if(getStage() == 6)
				{
					_ssqCameraLight.setNpcState(1);
					_ssqCameraZone.setNpcState(2);
					_poisonZoneEnabled = true;
					nextStage();
					return;
				}
				else if(getStage() <= 11)
					nextStage();
			}
			else
				victim.removeListener(_monsterDeathListener);
		}
	}

	private class PlayerDeathListener implements OnDeathListener
	{
		@Override
		public void onDeath(Creature victim, Creature killer)
		{
			if(!victim.isPlayer())
				return;

			if(victim.getAbnormalList().contains(AbnormalType.RESURRECTION_SPECIAL))
				return;

			boolean exit = true;
			for(Player member : getPlayers())
			{
				if(!member.isDead())
				{
					exit = false;
					break;
				}
			}

			if(exit)
				ThreadPoolManager.getInstance().schedule(() -> clearReflection(5, true), 15000L);
		}
	}

	private class ZoneListener implements OnZoneEnterLeaveListener
	{
		@Override
		public void onZoneEnter(Zone zone, Creature cha)
		{
			if(!cha.isPlayer())
				return;

			if(zone == _excludedInstanceZone)
			{
				if(getStatus() == 0)
					cha.teleToLocation(_excludedZoneTeleportLoc, cha.getReflection());
			}
			else if(zone == _instanceZone)
			{
				cha.addListener(_playerDeathListener);

				if(_ssqCameraZone != null)
					_ssqCameraZone.setNpcState(0);
			}
		}

		@Override
		public void onZoneLeave(Zone zone, Creature cha)
		{
			if(cha.isPlayer() && zone == _instanceZone)
				cha.removeListener(_playerDeathListener);
		}
	}

	private class AltharTask implements Runnable
	{
		@Override
		public void run()
		{
			SkillEntry castSkillEntry = SkillEntry.makeSkillEntry(SkillEntryType.NONE, _hpAbsorbSkillId, _hpAbsorbSkillLevel);
			if(castSkillEntry == null)
				return;

			if(_captivateds.isEmpty())
				return;

			for(NpcInstance npc : getNpcs())
			{
				if(npc.isDead() || npc.getNpcId() == _captivatedNpcId || !npc.isMonster())
					continue;

				if(npc.getRealDistance3D(_kartiaAlthar) >= 500.0D || (npc.getZ() - _kartiaAlthar.getZ()) >= 150)
					continue;

				npc.doDie(npc);

				_kartiaAlthar.setNpcState(1);

				final NpcInstance captivated = Rnd.get(_captivateds);
				if(captivated != null)
				{
					_kartiaAlthar.setTarget(captivated);
					_kartiaAlthar.doCast(castSkillEntry, captivated, true);
					_kartiaAlthar.setHeading(0);

					ThreadPoolManager.getInstance().schedule(() ->
					{
						captivated.deleteMe();
						_captivateds.remove(captivated);
					}, 11000L);
				}
			}
		}
	}

	private class PoisenTask implements Runnable
	{
		@Override
		public void run()
		{
			if(getStatus() == 0 && _poisonZoneEnabled)
			{
				SkillEntry skill = SkillEntry.makeSkillEntry(SkillEntryType.NONE, _poisonZoneSkillId, _poisonZoneSkillLevel);
				if(skill != null)
				{
					for(Player player : getPlayers())
						_ssqCameraZone.doCast(skill, player, true);
				}
			}
		}
	}

	private class MonsterMovementTask implements Runnable
	{
		@Override
		public void run()
		{
			int counter = 0;
			for(NpcInstance npc : getNpcs())
			{
				if(npc.getNpcId() == _mobType1NpcId || npc.getNpcId() == _mobType2NpcId || npc.getNpcId() == _keeperNpcId)
				{
					if(getStatus() == 2 && getStage() >= 9)
					{
						if(npc.getAggroList().isEmpty() && System.currentTimeMillis() < wavelastspawntime + 10000L)
						{
							npc.setRunning();
							DefaultAI ai = (DefaultAI) npc.getAI();
							ai.addTaskMove(Location.findPointToStay(_monsterMovePointLoc, 100, 200, npc.getGeoIndex()), true, false);
						}
					}
				}
			}
		}
	}

	private class SpawnStage implements Runnable
	{
		private final int _spawnStage;

		public SpawnStage(int spawnStage)
		{
			_spawnStage = spawnStage;
			wavelastspawntime = System.currentTimeMillis();
		}

		@Override
		public void run()
		{
			List<Spawner> spawners = spawnByGroup(_spawnGroupPrefix + "_stage_" + _spawnStage);
			if(getStatus() == 0)
			{
				for(Spawner spawner : spawners)
				{
					for(NpcInstance npc : spawner.getAllSpawned())
					{
						if(npc.getNpcId() == _mobType1NpcId || npc.getNpcId() == _mobType2NpcId || npc.getNpcId() == _keeperNpcId)
							npc.getAI().setWalkerRoute(FIRST_STATE_WALKER_ROUTE);
					}
				}
			}
		}
	}

	// Properties
	private int _startStage;

	// Reward's
	private long _expReward;
	private long _spReward;

	// NPC's
	private int _ssqCameraNpcId;
	private int _altarNpcId;
	private int _mobType1NpcId;
	private int _mobType2NpcId;
	private int _rulerNpcId;
	private int _keeperNpcId;
	private int _captivatedNpcId;
	private int _supportTroopsNpcId;

	// Skill's
	private int _hpAbsorbSkillId;
	private int _hpAbsorbSkillLevel;
	private int _poisonZoneSkillId;
	private int _poisonZoneSkillLevel;

	// Door's
	protected int _roomDoorId;
	protected int _raidDoorId;

	// Location's
	protected Location _excludedZoneTeleportLoc;
	protected Location _rulerSpawnLoc;
	protected Location _supportTroopsSpawnLoc;
	protected Location _kartiaAltharSpawnLoc;
	protected Location _ssqCameraLightSpawnLoc;
	protected Location _ssqCameraZoneSpawnLoc;
	protected Location _aggroStartPointLoc;
	protected Location _aggroMovePointLoc;
	protected Location _monsterMovePointLoc;

	// ETC
	protected String _spawnGroupPrefix;

	// Zones
	protected Zone _instanceZone;
	protected Zone _excludedInstanceZone;

	private final List<NpcInstance> _captivateds = new ArrayList<NpcInstance>();
	private final List<NpcInstance> _supports = new ArrayList<NpcInstance>();

	// Listener's
	private final OnDeathListener _monsterDeathListener = new MonsterDeathListener();
	private final OnDeathListener _playerDeathListener = new PlayerDeathListener();
	private final OnZoneEnterLeaveListener _instanceZoneListener = new ZoneListener();

	private NpcInstance _kartiaAlthar = null;
	private NpcInstance _ssqCameraZone = null;
	private NpcInstance _ssqCameraLight = null;
	private NpcInstance _ruler = null;

	private int _savedCaptivateds = 0;
	private boolean _poisonZoneEnabled = false;

	private ScheduledFuture<?> _aggroCheckTask;
	private ScheduledFuture<?> _waveMovementTask;
	private ScheduledFuture<?> _altharCheckTask;
	private ScheduledFuture<?> _poisonZoneTask;

	private int _stage = 0;
	private int _status = 0;

	private long wavelastspawntime;

	protected static final WalkerRoute FIRST_STATE_WALKER_ROUTE = new WalkerRoute(IdFactory.getInstance().getNextId(), WalkerRouteType.FINISH);

	@Override
	protected void onCreate()
	{
		StatsSet params = getInstancedZone().getAddParams();

		_startStage = params.getInteger("start_stage", 1);

		_expReward = params.getLong("exp_reward", 0L);
		_spReward = params.getLong("sp_reward", 0L);

		_ssqCameraNpcId = params.getInteger("ssq_camera_npc_id");
		_altarNpcId = params.getInteger("altar_npc_id");
		_mobType1NpcId = params.getInteger("mob_type_1_npc_id");
		_mobType2NpcId = params.getInteger("mob_type_2_npc_id");
		_rulerNpcId = params.getInteger("ruler_npc_id");
		_keeperNpcId = params.getInteger("keeper_npc_id");
		_captivatedNpcId = params.getInteger("captivated_npc_id");
		_supportTroopsNpcId = params.getInteger("support_troops_npc_id");

		_hpAbsorbSkillId = params.getInteger("hp_absorb_skill_id");
		_hpAbsorbSkillLevel = params.getInteger("hp_absorb_skill_level", 1);
		_poisonZoneSkillId = params.getInteger("poison_zone_skill_id");
		_poisonZoneSkillLevel = params.getInteger("poison_zone_skill_level", 1);

		_spawnGroupPrefix = params.getString("spawn_group_prefix");

		_instanceZone.addListener(_instanceZoneListener);
		_excludedInstanceZone.addListener(_instanceZoneListener);

		super.onCreate();
	}

	@Override
	protected void onCollapse()
	{
		super.onCollapse();
		cleanup();
	}

	@Override
	public void addObject(GameObject o)
	{
		super.addObject(o);

		if(o.isMonster())
			((Creature) o).addListener(_monsterDeathListener);
	}

	protected int getStage()
	{
		return _stage;
	}

	public int getStatus()
	{
		return _status;
	}

	private void nextStage()
	{
		stageStart(getStage() + 1);
		for(Player player : getPlayers())
			currentLevel(player);

	}

	private void currentLevel(Player player)
	{
		if(getStage() >= 1 && getStage() <= 7)
			player.sendPacket(new ExShowScreenMessage(NpcString.STAGE_S1, 3000, ExShowScreenMessage.ScreenMessageAlign.TOP_CENTER, String.valueOf(getStage())));
		else if(getStage() >= 9)
			player.sendPacket(new ExShowScreenMessage(NpcString.STAGE_S1, 3000, ExShowScreenMessage.ScreenMessageAlign.TOP_CENTER, String.valueOf(getStage() - 8)));
	}

	private void stageStart(int stage)
	{
		_stage = stage;
		switch(stage)
		{
			case 1:
				ThreadPoolManager.getInstance().schedule(new SpawnStage(1), 3000);
				break;
			case 2:
				ThreadPoolManager.getInstance().schedule(new SpawnStage(2), 1000);
				break;
			case 3:
				ThreadPoolManager.getInstance().schedule(new SpawnStage(3), 1000);
				break;
			case 4:
				ThreadPoolManager.getInstance().schedule(new SpawnStage(4), 1000);
				break;
			case 5:
				ThreadPoolManager.getInstance().schedule(new SpawnStage(5), 1000);
				break;
			case 6:
				ThreadPoolManager.getInstance().schedule(new SpawnStage(6), 1000);
				break;
			case 7:
				ThreadPoolManager.getInstance().schedule(new SpawnStage(7), 1000);
				_poisonZoneEnabled = false;
				break;
			case 8:
				ThreadPoolManager.getInstance().schedule(new SpawnStage(8), 1000);
				break;
			case 9:
				ThreadPoolManager.getInstance().schedule(new SpawnStage(9), 1000);
				break;
			case 10:
				ThreadPoolManager.getInstance().schedule(new SpawnStage(10), 1000);
				break;
			case 11:
				ThreadPoolManager.getInstance().schedule(new SpawnStage(11), 1000);
				break;
			case 12:
				ThreadPoolManager.getInstance().schedule(new SpawnStage(12), 1000);
				freeRuler();
				break;
		}
	}

	private void deleteNpcses(int id)
	{
		for(NpcInstance mob : getNpcs(true, id))
			mob.deleteMe();
	}

	protected void startState1()
	{
		deleteNpcses(_mobType1NpcId);
		deleteNpcses(_mobType2NpcId);

		getDoor(_roomDoorId).openMe();
		_ssqCameraZone.setNpcState(3);
		_ssqCameraZone.setNpcState(0);
		_status = 1;
		saveCaptivateds();
		nextStage();
		Functions.npcSay(getNpcs(false, _keeperNpcId).get(0), NpcString.HOW_ITS_IMPOSSIBLE_RETURNING_TO_ABYSS_AGAIN);
	}

	protected void startState2()
	{
		_status = 2;
		getDoor(_raidDoorId).openMe();
		deleteNpcses(_mobType1NpcId);
		deleteNpcses(_mobType2NpcId);
		ThreadPoolManager.getInstance().schedule(() -> nextStage(), 20000L);

		_ruler = addSpawnWithoutRespawn(_rulerNpcId, _rulerSpawnLoc, 0);
		_ruler.getFlags().getInvulnerable().start();
		_ruler.startAbnormalEffect(AbnormalEffect.FLESH_STONE);
		_ruler.getAI().setIntention(CtrlIntention.AI_INTENTION_IDLE, _ruler);

		if(!_ruler.isParalyzed())
			_ruler.getFlags().getParalyzed().start();

		ThreadPoolManager.getInstance().schedule(() ->
		{
			//getDoor(_raidDoorId).closeMe();
			for(int i = 0; i < _savedCaptivateds; i++)
			{
				NpcInstance support;

				support = addSpawnWithoutRespawn(_supportTroopsNpcId, new Location(_supportTroopsSpawnLoc.x + Rnd.get(100, 250), _supportTroopsSpawnLoc.y + Rnd.get(100, 250), _supportTroopsSpawnLoc.z, _supportTroopsSpawnLoc.h), 0);
				_supports.add(support);
				support.setBusy(true);
				support.getAI().setIntention(CtrlIntention.AI_INTENTION_ACTIVE);
			}
		}, 15000L);
	}

	protected void cleanup()
	{
		if(_ssqCameraZone != null)
		{
			_ssqCameraZone.setNpcState(3);
			_ssqCameraZone.setNpcState(0);
			_ssqCameraZone.deleteMe();
		}
		if(_aggroCheckTask != null)
			_aggroCheckTask.cancel(true);
		if(_waveMovementTask != null)
			_waveMovementTask.cancel(true);
		if(_altharCheckTask != null)
			_altharCheckTask.cancel(true);
		if(_poisonZoneTask != null)
			_poisonZoneTask.cancel(true);
	}

	private synchronized void saveCaptivateds()
	{
		for(final NpcInstance captivated : _captivateds)
		{
			_savedCaptivateds += 1;
			ThreadPoolManager.getInstance().schedule(() -> captivated.deleteMe(), 5000);
		}
		_captivateds.clear();
	}

	private void freeRuler()//Выпустить кракена :)
	{
		if(_ruler != null)
		{
			_ruler.stopAbnormalEffect(AbnormalEffect.FLESH_STONE);
			if(_ruler.isInvulnerable())
				_ruler.getFlags().getInvulnerable().stop();
			if(_ruler.isParalyzed())
				_ruler.getFlags().getParalyzed().stop();
			_ruler.getAI().setIntention(CtrlIntention.AI_INTENTION_ATTACK);
		}
	}

	protected void startChallenge()
	{
		_kartiaAlthar = addSpawnWithoutRespawn(_altarNpcId, _kartiaAltharSpawnLoc, 0);
		_ssqCameraLight = addSpawnWithoutRespawn(_ssqCameraNpcId, _ssqCameraLightSpawnLoc, 0);
		_ssqCameraZone = addSpawnWithoutRespawn(_ssqCameraNpcId, _ssqCameraZoneSpawnLoc, 0);

		_ssqCameraZone.setNpcState(3);
		_ssqCameraZone.setNpcState(0);

		_ssqCameraLight.setNpcState(3);
		_ssqCameraLight.setNpcState(0);

		_kartiaAlthar.setRandomWalk(false);
		_kartiaAlthar.getFlags().getInvulnerable().start();
		_ssqCameraLight.setRandomWalk(false);
		_ssqCameraZone.setRandomWalk(false);

		for(DoorInstance door : getDoors())
			door.closeMe();

		spawnByGroup(_spawnGroupPrefix + "_captivated");

		for(NpcInstance npc : getNpcs(true, _captivatedNpcId))
		{
			if(npc.getNpcId() == _captivatedNpcId )
			{
				npc.getAI().setIntention(CtrlIntention.AI_INTENTION_IDLE);
				npc.doCast(SkillEntry.makeSkillEntry(SkillEntryType.NONE, 14988, 1), npc, true);
				_captivateds.add(npc);
			}
			npc.setBusy(true);
		}

		_waveMovementTask = ThreadPoolManager.getInstance().scheduleAtFixedRate(new MonsterMovementTask(), 5000L, 6000L);
		_altharCheckTask = ThreadPoolManager.getInstance().scheduleAtFixedRate(new AltharTask(), 5000L, 3000L);
		_poisonZoneTask = ThreadPoolManager.getInstance().scheduleAtFixedRate(new PoisenTask(), 2000L, 10000L);
		stageStart(_startStage);
	}
}