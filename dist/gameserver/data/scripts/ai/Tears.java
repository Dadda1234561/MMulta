package ai;

import gnu.trove.map.TIntObjectMap;

import java.util.ArrayList;
import java.util.List;
import java.util.concurrent.ScheduledFuture;

import l2s.commons.util.Rnd;
import l2s.gameserver.ThreadPoolManager;
import l2s.gameserver.ai.CtrlEvent;
import l2s.gameserver.ai.DefaultAI;
import l2s.gameserver.geometry.Location;
import l2s.gameserver.model.Creature;
import l2s.gameserver.model.Party;
import l2s.gameserver.model.Player;
import l2s.gameserver.model.Skill;
import l2s.gameserver.model.instances.NpcInstance;
import l2s.gameserver.network.l2.s2c.MagicSkillUse;
import l2s.gameserver.skills.SkillEntry;
import l2s.gameserver.skills.SkillEntryType;
import l2s.gameserver.utils.Functions;
import l2s.gameserver.utils.NpcUtils;

/**
 * @author Diamond
 */
public class Tears extends DefaultAI
{
	private class DeSpawnTask implements Runnable
	{
		@Override
		public void run()
		{
			for(NpcInstance npc : spawns)
				if(npc != null)
					npc.deleteMe();
			spawns.clear();
			despawnTask = null;
		}
	}

	private class SpawnMobsTask implements Runnable
	{
		@Override
		public void run()
		{
			spawnMobs();
			spawnTask = null;
		}
	}

	final SkillEntry Invincible;
	final SkillEntry Freezing;

	private static final int Water_Dragon_Scale = 2369;
	private static final int Tears_Copy = 25535;

	ScheduledFuture<?> spawnTask;
	ScheduledFuture<?> despawnTask;

	List<NpcInstance> spawns = new ArrayList<NpcInstance>();

	private boolean _isUsedInvincible = false;

	private int _scale_count = 0;
	private long _last_scale_time = 0;

	public Tears(NpcInstance actor)
	{
		super(actor);

		TIntObjectMap<Skill> skills = getActor().getTemplate().getSkills();

		Invincible = SkillEntry.makeSkillEntry(SkillEntryType.NONE, skills.get(5420));
		Freezing = SkillEntry.makeSkillEntry(SkillEntryType.NONE, skills.get(5238));
	}

	@Override
	protected void onEvtSeeSpell(Skill skill, Creature caster, Creature target)
	{
		NpcInstance actor = getActor();
		if(actor.isDead() || skill == null || caster == null)
			return;

		if(System.currentTimeMillis() - _last_scale_time > 5000)
			_scale_count = 0;

		if(skill.getId() == Water_Dragon_Scale)
		{
			_scale_count++;
			_last_scale_time = System.currentTimeMillis();
		}

		Player player = caster.getPlayer();
		if(player == null)
			return;

		int count = 1;
		Party party = player.getParty();
		if(party != null)
			count = party.getMemberCount();

		// Снимаем неуязвимость
		if(_scale_count >= count)
		{
			_scale_count = 0;
			actor.getAbnormalList().stop(Invincible, false);
		}
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
		double actor_hp_precent = actor.getCurrentHpPercents();
		int rnd_per = Rnd.get(100);

		if(actor_hp_precent < 15 && !_isUsedInvincible)
		{
			_isUsedInvincible = true;
			addTaskBuff(actor, Invincible);
			Functions.npcSay(actor, "Готовьтесь к смерти!!!");
			return true;
		}

		if(rnd_per < 5 && spawnTask == null && despawnTask == null)
		{
			actor.broadcastPacketToOthers(new MagicSkillUse(actor, actor, 5441, 1, 3000, 0));
			spawnTask = ThreadPoolManager.getInstance().schedule(new SpawnMobsTask(), 3000);
			return true;
		}

		if(!actor.isAMuted() && rnd_per < 75)
			return chooseTaskAndTargets(null, target, distance);

		return chooseTaskAndTargets(Freezing, target, distance);
	}

	private void spawnMobs()
	{
		NpcInstance actor = getActor();

		Location pos;
		Creature hated;

		// Спавним 9 копий
		for(int i = 0; i < 9; i++)
		{
			pos = Location.findPointToStay(144298, 154420, -11854, 300, 320, actor.getGeoIndex());
			NpcInstance copy = NpcUtils.spawnSingle(Tears_Copy, pos, actor.getReflection());
			spawns.add(copy);

			// Атакуем случайную цель
			hated = actor.getAggroList().getRandomHated(getMaxHateRange());
			if(hated != null)
				copy.getAI().notifyEvent(CtrlEvent.EVT_AGGRESSION, hated, Rnd.get(1, 100));
		}

		// Прячемся среди них
		pos = Location.findPointToStay(144298, 154420, -11854, 300, 320, actor.getReflectionId());
		actor.teleToLocation(pos);

		// Атакуем случайную цель
		hated = actor.getAggroList().getRandomHated(getMaxHateRange());
		if(hated != null)
			actor.getAI().notifyEvent(CtrlEvent.EVT_AGGRESSION, hated, Rnd.get(1, 100));

		if(despawnTask != null)
			despawnTask.cancel(false);
		despawnTask = ThreadPoolManager.getInstance().schedule(new DeSpawnTask(), 30000);
	}

	@Override
	protected boolean randomWalk()
	{
		return false;
	}
}