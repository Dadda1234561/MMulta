package ai.ShadowCapm;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import l2s.commons.util.Rnd;
import l2s.gameserver.ai.DefaultAI;
import l2s.gameserver.model.Creature;
import l2s.gameserver.model.Skill;
import l2s.gameserver.model.instances.NpcInstance;
import l2s.gameserver.skills.SkillEntry;
import l2s.gameserver.skills.SkillEntryType;

//By Evil_dnk

public class AlgisaAI extends DefaultAI
{
	//Algiza
	final SkillEntry a_debuf = getSkill(23763, 1), a_debuff2 = getSkill(23766, 1),  a_debuff3 = getSkill(23767, 1);

			//Self
	final SkillEntry a_targ = getSkill(23768, 1);
			//Heal all
	final SkillEntry a_sabl = getSkill(23764, 1);
			//Invul
	final SkillEntry a_invul = getSkill(23765, 1);

	private long _invul = 0;
	private long _sabl = 0;
	private long _targ = 0;

	public AlgisaAI(NpcInstance actor)
	{
		super(actor);
	}


	@Override
	protected void onEvtAttacked(Creature attacker, Skill skill, int damage)
	{
		if(Rnd.chance(5) && _targ < System.currentTimeMillis())
		{
			_targ = System.currentTimeMillis() + 600000L;
			getActor().altOnMagicUse(getActor(), a_targ);
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

		if(Rnd.chance(25) && _invul < System.currentTimeMillis())
		{
			_invul = System.currentTimeMillis() + 120000L;
			List<NpcInstance> around = actor.getAroundNpc(1100, 1100);
			if(around != null && !around.isEmpty())
			{
				for(NpcInstance npc : around)
				{
					if(npc.getFaction().toString().equalsIgnoreCase("shadow_camp"))
					{
						getActor().altOnMagicUse(npc, a_invul);
					}
				}
			}
			addTaskBuff(getActor(), a_invul);
		}

		if(Rnd.chance(25) && _sabl < System.currentTimeMillis())
		{
			_sabl = System.currentTimeMillis() + 5000L;
			List<NpcInstance> around = actor.getAroundNpc(1100, 1100);
			if(around != null && !around.isEmpty())
			{
				for(NpcInstance npc : around)
				{
					if(npc.getFaction().toString().equalsIgnoreCase("shadow_camp"))
					{
						getActor().altOnMagicUse(npc, a_sabl);
					}
				}
			}
			addTaskBuff(getActor(), a_sabl);
		}

		Map<SkillEntry, Integer> d_skill = new HashMap<SkillEntry, Integer>();
		addDesiredSkill(d_skill, target, distance, a_debuf);
		addDesiredSkill(d_skill, target, distance, a_debuff2);
		addDesiredSkill(d_skill, target, distance, a_debuff3);

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
		_invul = System.currentTimeMillis() + 4000L;
		_sabl = System.currentTimeMillis() + 4000L;
		_targ = System.currentTimeMillis() + 4000L;
	}

}