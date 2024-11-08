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

public class GuardofDawnStat extends DefaultAI
{
	private static final int _aggrorange = 120;
	private static final SkillEntry _skillEntry = SkillEntry.makeSkillEntry(SkillEntryType.NONE, 5978, 1);
	private Location _locTele = null;
	private boolean noCheckPlayers = false;

	public GuardofDawnStat(NpcInstance actor, Location telePoint)
	{
		super(actor);
		_attackAITaskDelay = 200;
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

		return true;
	}

	private boolean checkAroundPlayers(NpcInstance actor)
	{
		for(Playable target : World.getAroundPlayables(actor, _aggrorange, _aggrorange))
			if(target != null && target.isPlayer() && !target.isInvulnerable() && GeoEngine.canSeeTarget(actor, target))
			{
				actor.doCast(_skillEntry, target, true);
				Functions.npcSay(actor, "Intruder alert!! We have been infiltrated!");
				noCheckPlayers = true;
				ThreadPoolManager.getInstance().schedule(new Teleportation(getTelePoint(), target), 3000);
				return true;
			}
		return false;
	}

	private void setTelePoint(Location loc)
	{
		_locTele = loc;
	}

	private Location getTelePoint()
	{
		return _locTele;
	}

	@Override
	protected void thinkAttack()
	{}

	@Override
	protected boolean randomWalk()
	{
		return false;
	}

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