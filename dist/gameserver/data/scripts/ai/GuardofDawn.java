package ai;

import l2s.gameserver.ThreadPoolManager;
import l2s.gameserver.ai.DefaultAI;
import l2s.gameserver.geodata.GeoEngine;
import l2s.gameserver.geometry.Location;
import l2s.gameserver.model.Creature;
import l2s.gameserver.model.Playable;
import l2s.gameserver.model.Skill;
import l2s.gameserver.model.World;
import l2s.gameserver.model.instances.NpcInstance;
import l2s.gameserver.skills.SkillEntry;
import l2s.gameserver.skills.SkillEntryType;
import l2s.gameserver.utils.Functions;

/**
 * AI NPC для SSQ Dungeon
 * - Если находят чара в радиусе 120, то кричат в чат и отправляют на точку старта
 * - Видят и цепляют тех, кто находится в хайде
 * - Никогда и никого не атакуют
 * @author n0nam3
 * @date 20/09/2010 19:03
 */
public class GuardofDawn extends DefaultAI
{
	private static final int _aggrorange = 150;
	private static final SkillEntry _skillEntry = SkillEntry.makeSkillEntry(SkillEntryType.NONE, 5978, 1);
	private Location _locStart = null;
	private Location _locEnd = null;
	private Location _locTele = null;
	private boolean moveToEnd = true;
	private boolean noCheckPlayers = false;

	public GuardofDawn(NpcInstance actor, Location locationEnd, Location telePoint)
	{
		super(actor);
		_attackAITaskDelay = 200;
		setStartPoint(actor.getSpawnedLoc()); // точка старта, по сути место спавна.
		setEndPoint(locationEnd);
		setTelePoint(telePoint);
	}

	public class Teleportation implements Runnable
	{

		Location _telePoint = null;
		Playable _target = null;

		public Teleportation(Location telePoint, Playable target)
		{
			_telePoint = telePoint;
			_target = target;
		}

		@Override
		public void run()
		{
			_target.teleToLocation(_telePoint);
			noCheckPlayers = false;
		}
	}

	@Override
	protected boolean thinkActive()
	{
		NpcInstance actor = getActor();

		// проверяем игроков вокруг
		if(!noCheckPlayers)
			checkAroundPlayers(actor);

		// если есть задания - делаем их
		if(_def_think)
		{
			doTask();
			return true;
		}

		// заданий нет, значит можно давать новое, для этого ставим moveToEnd обратное значение
		moveToEnd = !moveToEnd;

		// добавляем задачу на движение
		if(!moveToEnd)
			addTaskMove(getEndPoint(), true, false);
		else
			addTaskMove(getStartPoint(), true, false);
		doTask();

		return true;
	}

	private boolean checkAroundPlayers(NpcInstance actor)
	{
		for(Playable target : World.getAroundPlayables(actor, _aggrorange, _aggrorange))
			if(target != null && target.isPlayer() && !target.isInvulnerable() && GeoEngine.canSeeTarget(actor, target))
			{
				actor.doCast(_skillEntry, target, true);
				Functions.npcSay(actor, "Intruder! Protect the Priests of Dawn!");
				noCheckPlayers = true;
				ThreadPoolManager.getInstance().schedule(new Teleportation(getTelePoint(), target), 3000);
				return true;
			}
		return false;
	}

	private void setStartPoint(Location loc)
	{
		_locStart = loc;
	}

	private void setEndPoint(Location loc)
	{
		_locEnd = loc;
	}

	private void setTelePoint(Location loc)
	{
		_locTele = loc;
	}

	private Location getStartPoint()
	{
		return _locStart;
	}

	private Location getEndPoint()
	{
		return _locEnd;
	}

	private Location getTelePoint()
	{
		return _locTele;
	}

	@Override
	protected void thinkAttack()
	{}

	@Override
	protected void onIntentionAttack(Creature target)
	{}

	@Override
	protected void onEvtAttacked(Creature attacker, Skill skill, int damage)
	{}

	@Override
	protected void onEvtAggression(Creature attacker, int aggro)
	{}

	@Override
	protected void onEvtClanAttacked(NpcInstance member, Creature attacker, int damage)
	{}

}