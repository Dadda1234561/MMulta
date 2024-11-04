package ai.ShadowCapm;

import java.util.HashMap;
import java.util.Map;

import l2s.gameserver.ai.Fighter;
import l2s.gameserver.model.Creature;
import l2s.gameserver.model.Skill;
import l2s.gameserver.model.instances.NpcInstance;
import l2s.gameserver.skills.SkillEntry;
import l2s.gameserver.skills.SkillEntryType;

//By Evil_dnk

public class TyrrAI extends Fighter
{

	// Tyrr
	final SkillEntry w_deb = getSkill(23733, 1), w_weap = getSkill(23734, 1), w_sonic = getSkill(23735, 1);
	        //Jump
	final SkillEntry  w_jump = getSkill(23736, 1);
			//Heal
	final SkillEntry  w_heal = getSkill(23737, 1);
	private static long _heal = 0;
	private static long _jump = 0;

	public TyrrAI(NpcInstance actor)
	{
		super(actor);
	}

	@Override
	protected void onEvtAttacked(Creature attacker, Skill skill, int damage)
	{
		if(getActor().getCurrentHpPercents() < 30 && _heal < System.currentTimeMillis())
		{
			_heal = System.currentTimeMillis() + 600000L;
			addTaskBuff(getActor(), w_heal);
		}

		super.onEvtAttacked(attacker, skill, damage);
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

		double distance = actor.getDistance(target);
		// Basic Attack
		if(distance > 200 && _jump < System.currentTimeMillis())
		{
			_jump = System.currentTimeMillis() + 5000L;
			return chooseTaskAndTargets(w_jump, target, distance);
		}

		Map<SkillEntry, Integer> d_skill = new HashMap<SkillEntry, Integer>();
		addDesiredSkill(d_skill, target, distance, w_deb);
		addDesiredSkill(d_skill, target, distance, w_weap);
		addDesiredSkill(d_skill, target, distance, w_sonic);

		SkillEntry r_skill = selectTopSkill(d_skill);
		if(r_skill != null && !r_skill.getTemplate().isDebuff())
			target = actor;

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
		_heal = System.currentTimeMillis() + 4000L;
		_jump = System.currentTimeMillis() + 4000L;
	}

}