package instances;

import java.util.List;
import java.util.concurrent.ScheduledFuture;

import l2s.gameserver.ThreadPoolManager;
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
import l2s.gameserver.model.instances.NpcInstance;
import l2s.gameserver.network.l2.components.NpcString;
import l2s.gameserver.network.l2.s2c.ExShowScreenMessage;
import l2s.gameserver.templates.StatsSet;
import l2s.gameserver.templates.npc.WalkerRoute;
import l2s.gameserver.templates.npc.WalkerRouteType;

/**
 * @author nexvill
**/
public class Kastia extends Reflection
{
	private class MonsterDeathListener implements OnDeathListener
	{
		private static final int KASTIA_100_BOX = 81147;
		private static final int KASTIA_105_BOX = 81148;
		private static final int KASTIA_110_BOX = 81149;
		private static final int KASTIA_115_BOX = 81465;
		private static final int KASTIA_120_BOX = 81466;
		private static final int KALIX = 24538;
		private static final int CLAV = 24542;
		private static final int SPATA = 24546;
		private static final int VISCHEZ = 24591;
		private static final int TYKAN = 24595;
		
		@Override
		public void onDeath(Creature victim, Creature killer)
		{
			if(victim.getNpcId() == _rulerNpcId)
			{
				cleanup();
				clearReflection(5, true);
				setReenterTime(System.currentTimeMillis(), true);
				for(Player player : getPlayers())
				{
					if (_rulerNpcId == KALIX)
					{
						player.getInventory().addItem(KASTIA_100_BOX, 1);
					}
					else if (_rulerNpcId == CLAV)
					{
						player.getInventory().addItem(KASTIA_105_BOX, 1);
					}
					else if (_rulerNpcId == SPATA)
					{
						player.getInventory().addItem(KASTIA_110_BOX, 1);
					}
					else if (_rulerNpcId == VISCHEZ)
					{
						player.getInventory().addItem(KASTIA_115_BOX, 1);
					}
					else if (_rulerNpcId == TYKAN)
					{
						player.getInventory().addItem(KASTIA_120_BOX, 1);
					}
					player.sendPacket(new ExShowScreenMessage(NpcString.YOU_HAVE_SUCCESSFULLY_COMPLETED_THE_KASTIAS_LABYRINTH_YOU_WILL_BE_TRANSPORTED_TO_THE_SURFACE_SHORTLYNALSO_YOU_CAN_LEAVE_THIS_PLACE_WITH_THE_HELP_OF_KASTIAS_RESEARCHER, 10000, ExShowScreenMessage.ScreenMessageAlign.TOP_CENTER, false));
					addSpawnWithoutRespawn(KASTIA_RESEARCHER, victim.getLoc(), 0);
				}
			}
			else if(getNpcs(true, _mobType1NpcId).isEmpty() && getNpcs(true, _mobType2NpcId).isEmpty() && getNpcs(true, _keeperNpcId).isEmpty() && getStage() <= 7)
			{
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

			 if(zone == _instanceZone)
			{
				cha.addListener(_playerDeathListener);
			}
		}

		@Override
		public void onZoneLeave(Zone zone, Creature cha)
		{
			if(cha.isPlayer() && zone == _instanceZone)
				cha.removeListener(_playerDeathListener);
		}
	}

	private class MonsterMovementTask implements Runnable
	{
		@Override
		public void run()
		{
			for(NpcInstance npc : getNpcs())
			{
				if(npc.getNpcId() == _mobType1NpcId || npc.getNpcId() == _mobType2NpcId || npc.getNpcId() == _keeperNpcId)
				{
					if(npc.getAggroList().isEmpty() && System.currentTimeMillis() < wavelastspawntime + 10000L)
					{
						npc.setRunning();
						DefaultAI ai = (DefaultAI) npc.getAI();
						ai.addTaskMove(Location.findPointToStay(_monsterMovePointLoc, 100, 200, npc.getGeoIndex()), true, false);
					}
				}
				for (Player player : getPlayers())
				{
					if (npc.getDistance(player.getLoc()) <= npc.getAggroRange())
					{
						npc.getAggroList().addDamageHate(player, 1, 100000);
					}
				}
			}
			if (System.currentTimeMillis() >= wavelastspawntime + 120000L)
			{
				nextStage();
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

	// Properties
	private int _startStage;

	// NPC's
	private int _mobType1NpcId;
	private int _mobType2NpcId;
	private int _keeperNpcId;
	private int _rulerNpcId;

	// Door's
	protected int _roomDoorId;
	protected int _raidDoorId;

	// Location's
	protected Location _monsterMovePointLoc = new Location(-111618, 18345, -10319);

	// ETC
	protected String _spawnGroupPrefix;

	// Zones
	protected Zone _instanceZone;

	// Listener's
	private final OnDeathListener _monsterDeathListener = new MonsterDeathListener();
	private final OnDeathListener _playerDeathListener = new PlayerDeathListener();
	private final OnZoneEnterLeaveListener _instanceZoneListener = new ZoneListener();

	private ScheduledFuture<?> _waveMovementTask;

	private int _stage = 0;
	
	private static final int KASTIA_RESEARCHER = 34566;

	private long wavelastspawntime;

	protected static final WalkerRoute FIRST_STATE_WALKER_ROUTE = new WalkerRoute(IdFactory.getInstance().getNextId(), WalkerRouteType.FINISH);

	@Override
	protected void onCreate()
	{
		StatsSet params = getInstancedZone().getAddParams();

		_startStage = params.getInteger("start_stage", 1);
		
		_mobType1NpcId = params.getInteger("mob_type_1_npc_id");
		_mobType2NpcId = params.getInteger("mob_type_2_npc_id");
		_rulerNpcId = params.getInteger("ruler_npc_id");
		_keeperNpcId = params.getInteger("keeper_npc_id");
		_spawnGroupPrefix = params.getString("spawn_group_prefix");
		
		_instanceZone = getZone("[kastia_instance]");

		_instanceZone.addListener(_instanceZoneListener);

		super.onCreate();
		
		startChallenge();
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
				break;
		}
	}

	protected void cleanup()
	{
		if(_waveMovementTask != null)
			_waveMovementTask.cancel(true);
	}

	protected void startChallenge()
	{
		_waveMovementTask = ThreadPoolManager.getInstance().scheduleAtFixedRate(new MonsterMovementTask(), 5000L, 3000L);
		stageStart(_startStage);
	}
}