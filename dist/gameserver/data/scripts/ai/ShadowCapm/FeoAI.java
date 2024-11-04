package ai.ShadowCapm;

import java.util.HashMap;
import java.util.Map;

import l2s.commons.util.Rnd;
import l2s.gameserver.ai.Mystic;
import l2s.gameserver.model.Creature;
import l2s.gameserver.model.Skill;
import l2s.gameserver.model.instances.NpcInstance;
import l2s.gameserver.skills.SkillEntry;
import l2s.gameserver.skills.SkillEntryType;

//By Evil_dnk

public class FeoAI extends Mystic
{
	//Feo
	final SkillEntry f_four = getSkill(23748, 1), f_storm = getSkill(23749, 1), f_mass = getSkill(23752, 1);
	//Debuffs
	final SkillEntry f_fear = getSkill(23751, 1), f_hell = getSkill(23750, 1);

	// Vars
	private long _fear = 0;
	private long _bind = 0;

	public FeoAI(NpcInstance actor)
	{
		super(actor);
	}


	@Override
	protected void onEvtAttacked(Creature attacker, Skill skill, int damage)
	{
		super.onEvtAttacked(attacker, skill, damage);
	}

	@Override
	protected boolean createNewTask()
	{
		clearTasks();
		Creature target;
		if ((target = prepareTarget()) == null)
		{
			return false;
		}

		NpcInstance actor = getActor();
		if (actor.isDead())
		{
			return false;
		}

		double distance = actor.getDistance(target);

		if (_fear < System.currentTimeMillis() && Rnd.chance(15))
		{
			_fear = System.currentTimeMillis() + 120000L;
			return chooseTaskAndTargets(f_fear, target, distance);
		}

		if (_bind < System.currentTimeMillis() && Rnd.chance(15))
		{
			_bind = System.currentTimeMillis() + 300000L;
			return chooseTaskAndTargets(f_hell, target, distance);
		}

		Map<SkillEntry, Integer> d_skill = new HashMap<SkillEntry, Integer>();
		addDesiredSkill(d_skill, target, distance, f_four);
		addDesiredSkill(d_skill, target, distance, f_storm);
		addDesiredSkill(d_skill, target, distance, f_mass);

		SkillEntry r_skill = selectTopSkill(d_skill);
		if (r_skill != null && !r_skill.getTemplate().isDebuff())
		{
			target = actor;
		}

		return chooseTaskAndTargets(r_skill, target, distance);
	}

	private SkillEntry getSkill(int id, int level)
	{
		return SkillEntry.makeSkillEntry(SkillEntryType.NONE, id, level);
	}

	@Override
	protected boolean randomWalk()
	{
		return false;
	}

	@Override
	protected boolean teleportHome()
	{
		return false;
	}

	@Override
	protected boolean returnHome(boolean clearAggro, boolean teleport, boolean running, boolean force)
	{
		return false;
	}

	@Override
	protected void onEvtSpawn()
	{
		super.onEvtSpawn();
		_fear = System.currentTimeMillis() + 4000L;
		_bind = System.currentTimeMillis() + 4000L;
	}

}