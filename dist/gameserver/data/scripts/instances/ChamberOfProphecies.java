package instances;

import java.util.List;
import java.util.concurrent.ScheduledFuture;

import l2s.gameserver.ThreadPoolManager;
import l2s.gameserver.ai.CtrlIntention;
import l2s.gameserver.ai.DefaultAI;
import l2s.gameserver.geometry.Location;
import l2s.gameserver.listener.actor.OnDeathListener;
import l2s.gameserver.model.Creature;
import l2s.gameserver.model.Player;
import l2s.gameserver.model.entity.Reflection;
import l2s.gameserver.model.instances.NpcInstance;
import l2s.gameserver.network.l2.components.NpcString;
import l2s.gameserver.network.l2.s2c.ExShowScreenMessage;
import l2s.gameserver.network.l2.s2c.updatetype.NpcInfoType;
import l2s.gameserver.utils.Functions;

//by Evil_dnk
public class ChamberOfProphecies extends Reflection
{
	private static final String STAGE_SPAWN_GROUP_1 = "cop_room1";
	private static final String STAGE_SPAWN_GROUP_2 = "cop_room2";
	private static final String STAGE_SPAWN_GROUP_3 = "cop_room2_1";
	private static final String STAGE_SPAWN_GROUP_4 = "cop_room3";
	private static final String STAGE_SPAWN_GROUP_5 = "cop_room3_2";
	private static final String STAGE_SPAWN_GROUP_6 = "cop_room4";

	private int[] MONSTER_IDS = {
		19568,
		19569,
		19570,
		19571,
		19572,
		19573
	};

	private NpcInstance _ferinNpc = null;
	private NpcInstance _makkumNpc = null;
	private NpcInstance _halterNpc = null;

	private ScheduledFuture<?> _followTask;

	private DeathListener _deathListener = new DeathListener();

	private int _stage = 0;

	public ChamberOfProphecies(Player player)
	{
		setReturnLoc(player.getLoc());
	}

	@Override
	public void onPlayerEnter(final Player player)
	{
		if(getFerrin() != null && _stage > 1 && _stage < 6)
		{
			getFerrin().teleToLocation(player.getLoc());
			getFerrin().getMovement().setFollowTarget(player);
		}

		super.onPlayerEnter(player);
	}

	private class SpawnStage implements Runnable
	{
		private String _spawnGroup;

		public SpawnStage(String spawnGroup)
		{
			_spawnGroup = spawnGroup;
		}
		
		@Override
		public void run()
		{
			spawnByGroup(_spawnGroup);
			invokeDeathListener();
		}
	}

	public void nextStage()
	{
		stageStart(_stage + 1);
	}

	public int getStage()
	{
		return _stage;
	}

	public void stageStart(int stage)
	{
		_stage = stage;

		switch(_stage)
		{
			case 1:
				ThreadPoolManager.getInstance().schedule(new SpawnStage(STAGE_SPAWN_GROUP_1), 3000);
				break;
			case 2:
				ThreadPoolManager.getInstance().schedule(new SpawnStage(STAGE_SPAWN_GROUP_2), 1000);
				openDoor(17230102);
				break;
			case 3:
				ThreadPoolManager.getInstance().schedule(new SpawnStage(STAGE_SPAWN_GROUP_3), 1000);
				break;
			case 4:
				ThreadPoolManager.getInstance().schedule(new SpawnStage(STAGE_SPAWN_GROUP_4), 1000);
				openDoor(17230103);
				break;
			case 5:
				ThreadPoolManager.getInstance().schedule(new SpawnStage(STAGE_SPAWN_GROUP_5), 1000);
				break;
			case 6:
				ThreadPoolManager.getInstance().schedule(new SpawnStage(STAGE_SPAWN_GROUP_6), 1000);
				openDoor(17230104);
				getFerrin().getMovement().setFollowTarget(getVanHalter());
				Functions.npcSay(getVanHalter(), NpcString.THATS_THE_MONSTER_THAT_ATTACKED_FAERON_YOURE_OUTMATCHED_HERE_GO_AHEAD_ILL_CATCH_UP);
				if(getPlayers() != null && !getPlayers().isEmpty())
					getPlayers().get(0).sendPacket(new ExShowScreenMessage(NpcString.LEAVE_THIS_PLACE_TO_KAINNGO_TO_THE_NEXT_ROOM, 7000, ExShowScreenMessage.ScreenMessageAlign.TOP_CENTER, true));
				spawnByGroup("cop_grail");
				break;
		}
	}

	private void invokeDeathListener()
	{
		for(int mobid : MONSTER_IDS)
		{
			for(NpcInstance mob : getNpcs(true, mobid))
				mob.addListener(_deathListener);
		}
	}

	private class DeathListener implements OnDeathListener
	{
		@Override
		public void onDeath(Creature victim, Creature killer)
		{
			if(getNpcs(true, 19569).isEmpty() && getNpcs(true, 19570).isEmpty() && getNpcs(true, 19571).isEmpty() && getNpcs(true, 19572).isEmpty() && getNpcs(true, 19573).isEmpty() && getNpcs(true, 19568).isEmpty())
			{
				if(getStage() < 10)
					nextStage();
			}
			else
				victim.removeListener(_deathListener);
		}
	}

	public NpcInstance getVanHalter()
	{
		return _halterNpc;
	}

	public NpcInstance getFerrin()
	{
		return _ferinNpc;
	}

	public NpcInstance getMakkum()
	{
		if(getNpcs(true, 19571).size() != 0)
			_makkumNpc = getNpcs(true, 19571).get(0);
		return _makkumNpc;
	}

	public void initFriend(Player player)
	{
		// spawn npc helpers
		if(_halterNpc != null)
			_halterNpc.deleteMe();

		_halterNpc = addSpawnWithoutRespawn(33979, new Location(-88504, 184680, -10476, 49151), 150);
		_halterNpc.setAI(new DefaultAI(_halterNpc));
		_halterNpc.setRunning();
		_halterNpc.getMovement().setFollowTarget(player);

		if(_ferinNpc != null)
			_ferinNpc.deleteMe();

		_ferinNpc = addSpawnWithoutRespawn(34001, new Location(-88504, 184680, -10476, 49151), 150);
		_ferinNpc.setRunning();
		_ferinNpc.getMovement().setFollowTarget(player);
		_ferinNpc.getAI().setIntention(CtrlIntention.AI_INTENTION_FOLLOW, player, 100);

		if(_followTask != null)
			_followTask.cancel(true);

		_followTask = ThreadPoolManager.getInstance().scheduleAtFixedRate(new FollowTask(), 2000L, 7000L);

		openDoor(17230101);
	}

	private class FollowTask implements Runnable
	{
		@Override
		public void run()
		{
			List<NpcInstance> around = getVanHalter().getAroundNpc(800, 150);
			if(around != null && !around.isEmpty())
			{
				for(NpcInstance npc : around)
				{
					int _id = npc.getNpcId();
					if(_id != 34001)
					{
						getVanHalter().setSpawnedLoc(getVanHalter().getLoc());
						getVanHalter().broadcastCharInfoImpl(NpcInfoType.VALUES);
						break;
					}
					else
					{
						if(getVanHalter().getTarget() == null && around.size() == 1)
						{
							getVanHalter().setSpawnedLoc(getVanHalter().getLoc());
							getVanHalter().broadcastCharInfoImpl(NpcInfoType.VALUES);
							if(getPlayers() != null && !getPlayers().isEmpty())
								getVanHalter().getMovement().setFollowTarget(getPlayers().get(0));
						}
					}
				}
			}
			else
			{
				getVanHalter().setSpawnedLoc(getVanHalter().getLoc());
				getVanHalter().broadcastCharInfoImpl(NpcInfoType.VALUES);
				if(getPlayers() != null && !getPlayers().isEmpty())
					getVanHalter().getMovement().setFollowTarget(getPlayers().get(0));
			}
		}
	}

	@Override
	protected void onCollapse()
	{
		super.onCollapse();
		clear();
	}

	public void clear()
	{
		if(getVanHalter() != null)
			getVanHalter().deleteMe();
		if(getFerrin() != null)
			getFerrin().deleteMe();
		if(_followTask != null)
			_followTask.cancel(true);
		if(getMakkum() != null)
			getMakkum().deleteMe();
	}
}
