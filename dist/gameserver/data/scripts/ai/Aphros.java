package ai;

import java.util.ArrayList;
import java.util.List;
import java.util.HashMap;
import java.util.Map;
import l2s.commons.util.Rnd;

import l2s.gameserver.ai.Fighter;
import l2s.gameserver.model.Creature;
import l2s.gameserver.model.Skill;
import l2s.gameserver.model.instances.NpcInstance;
import l2s.gameserver.skills.SkillEntry;
import l2s.gameserver.skills.SkillEntryType;
import l2s.gameserver.utils.NpcUtils;
import l2s.gameserver.model.instances.DoorInstance;
import l2s.gameserver.utils.ReflectionUtils;

public class Aphros extends Fighter
{
	private static final int[] NpcDoors = { 33133, 33134, 33135, 33136 };
	// damage skills
	final SkillEntry s_fatal = getSkill(14465, 1), s_black = getSkill(14462, 1);
	//private static final Location[] DoorsLocations = { new Location(213700, 115925, -864), new Location(214354, 115265, -864), new Location(213700, 114595, -800), new Location(213030, 115265, -800) };
private static List<NpcInstance> activeDoors = new ArrayList<NpcInstance>();
	private static final int[] Doors = { 26210041, 26210042, 26210043, 26210044 };
	private int RaidHpState = 0;
	private static long _notOrdinalattackDelay = 0;
	
	public Aphros(NpcInstance actor)
	{
		super(actor);
		
	}
	private SkillEntry getSkill(int id, int level)
	{
		return SkillEntry.makeSkillEntry(SkillEntryType.NONE, id, level);
	}
		@Override
	protected boolean createNewTask()
	{
		clearTasks();
		Creature target;
		if((target = prepareTarget()) == null)
			return false;

		NpcInstance actor = getActor();
		if(actor.isDead())
			return false;

	

		//Различные дебафы
		if(_notOrdinalattackDelay < System.currentTimeMillis())
		{
			
			if(Rnd.chance(60))
			{
				if(Rnd.chance(60))
					addTaskCast(target, s_fatal);
				else
					addTaskCast(target, s_black);
				
				
			}
			
			_notOrdinalattackDelay = System.currentTimeMillis() + (Rnd.get(1000, 2000));
		}

		double distance = actor.getDistance(target);
		final int _hpStage = 0;
		Map<SkillEntry, Integer> d_skill = new HashMap<SkillEntry, Integer>();
		switch(_hpStage)
		{
			case 1:
				addDesiredSkill(d_skill, target, distance, s_black);
				break;
			case 2:				
				addDesiredSkill(d_skill, target, distance, s_fatal);
				break;			
			default:
				break;
		}

	

		SkillEntry r_skill = selectTopSkill(d_skill);
		if(r_skill != null && !r_skill.getTemplate().isDebuff())
			target = actor;

		return chooseTaskAndTargets(r_skill, target, distance);
	}

	@Override
	protected void onEvtSpawn()
	{
		_notOrdinalattackDelay= System.currentTimeMillis() + 30000L;
		super.onEvtSpawn();
		for (int doorId : Doors)
		{
			DoorInstance door = ReflectionUtils.getDoor(doorId);
			door.closeMe();	
		}
		/*if (activeDoors.isEmpty())
		{
			List<Location> temp = new ArrayList<Location>(4);
			for (Location loc : DoorsLocations)
				temp.add(new Location(loc.getX(), loc.getY(), loc.getZ()));

			for (int door : NpcDoors)
			{
				int index = Rnd.get(0, temp.size() - 1);
				activeDoors.add(NpcUtils.spawnSingle(door, temp.get(index)));
				temp.remove(index);
			}
		}*/
	}
	
	@Override
	protected void onEvtAttacked(Creature attacker, Skill skill, int damage)
	{
		NpcInstance actor = getActor();
			
		if (actor.isDead())
			return;

		if (actor.getNpcId() == 25775)
		{
			if(actor.getCurrentHpPercents() <= 80 && actor.getCurrentHpPercents() > 60 && RaidHpState == 0)
			{
				spawnMinions(actor, 1);
				spawnMinions(actor, 1);
				//AphrosManager._effectZone.setActive(true);
				//Skill tempSkill = SkillHolder.getInstance().getSkill(14464, 1);
				//AphrosManager._effectZone.getTemplate().setZoneSkill(tempSkill);
				RaidHpState = 1;
			}
			else if(actor.getCurrentHpPercents() <= 60 && actor.getCurrentHpPercents() > 40 && RaidHpState == 1)
			{
				spawnMinions(actor, 1);
spawnMinions(actor, 1);
spawnMinions(actor, 1);				
				RaidHpState = 2;
			}
			else if(actor.getCurrentHpPercents() <= 40 && actor.getCurrentHpPercents() > 20 && RaidHpState == 2)
			{
				spawnMinions(actor, 1);
				spawnMinions(actor, 1);
				spawnMinions(actor, 1);
				spawnMinions(actor, 1);
				RaidHpState = 3;
			}
			else if(actor.getCurrentHpPercents() <= 20 && actor.getCurrentHpPercents() > 10 && RaidHpState == 3)
			{
				
				//Location oldLoc = AphrosManager.AphrosNpc.getLoc();
				//AphrosManager.AphrosNpc.deleteMe();
				//AphrosManager.AphrosNpc = NpcUtils.spawnSingle(25866, oldLoc);
				//AphrosManager.AphrosNpc.setCurrentHp(AphrosManager.AphrosNpc.getCurrentHp() / 10.0D, true);
				//Skill tempSkill = SkillHolder.getInstance().getSkill(14624, 1);
				//AphrosManager._effectZone.getTemplate().setZoneSkill(tempSkill);
			}
		}

		super.onEvtAttacked(attacker, skill, damage);
	}	
	/*@Override
	public void onEvtDead(Creature killer)
	{
		NpcInstance actor = getActor();
		if(actor.getNpcId() == 25866)
			AphrosManager.stopRaid();
		super.onEvtDead(killer);
	}*/
	
	private void spawnMinions(NpcInstance actor, int count)
	{
				NpcInstance minion = NpcUtils.spawnSingle(25865, actor.getLoc());
		
	}	
}
