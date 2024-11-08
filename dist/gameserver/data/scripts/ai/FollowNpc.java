package ai;

import java.util.concurrent.ScheduledFuture;

import l2s.commons.threading.RunnableImpl;
import l2s.commons.util.Rnd;
import l2s.gameserver.Config;
import l2s.gameserver.ThreadPoolManager;
import l2s.gameserver.ai.CtrlIntention;
import l2s.gameserver.ai.DefaultAI;
import l2s.gameserver.geometry.Location;
import l2s.gameserver.model.Creature;
import l2s.gameserver.model.instances.MonsterInstance;
import l2s.gameserver.model.instances.NpcInstance;

public class FollowNpc extends DefaultAI
{
	private boolean _thinking = false;
	private ScheduledFuture<?> _followTask;

	public FollowNpc(NpcInstance actor)
	{
		super(actor);
	}

	@Override
	protected boolean randomWalk()
	{
		if(getActor() instanceof MonsterInstance)
			return true;

		return false;
	}
	
	@Override
	protected void onEvtThink()
	{
		NpcInstance actor = getActor();
		if(_thinking || actor.isActionsDisabled() || actor.isAfraid() || actor.isDead() || actor.isMovementDisabled())
			return;

		_thinking = true;
		try
		{
			if(!Config.BLOCK_ACTIVE_TASKS && (getIntention() == CtrlIntention.AI_INTENTION_ACTIVE || getIntention() == CtrlIntention.AI_INTENTION_IDLE))
				thinkActive();
			else if(getIntention() == CtrlIntention.AI_INTENTION_FOLLOW)
				thinkFollow();
		}
		catch(Exception e)
		{
			_log.error("", e);
		}
		finally
		{
			_thinking = false;
		}
	}

	protected void thinkFollow()
	{
		NpcInstance actor = getActor();

		Creature target = actor.getMovement().getFollowTarget();

		//Находимся слишком далеко цели, либо цель не пригодна для следования, либо не можем перемещаться
		if(target == null || target.isAlikeDead() || actor.getDistance(target) > 4000 || actor.isMovementDisabled())
		{
			clientActionFailed();
			return;
		}

		//Уже следуем за этой целью
		if(actor.getMovement().isFollow() && actor.getMovement().getFollowTarget() == target)
		{
			clientActionFailed();
			return;
		}

		//Находимся достаточно близко
		if(actor.isInRange(target, Config.FOLLOW_RANGE + 20))
			clientActionFailed();

		if(_followTask != null)
		{
			_followTask.cancel(false);
			_followTask = null;
		}

		_followTask = ThreadPoolManager.getInstance().schedule(new ThinkFollow(), 250L);
	}

	protected class ThinkFollow extends RunnableImpl
	{
		public NpcInstance getActor()
		{
			return FollowNpc.this.getActor();
		}

		@Override
		public void runImpl()
		{
			NpcInstance actor = getActor();
			if(actor == null)
				return;

			Creature target = actor.getMovement().getFollowTarget();

			if(target == null || target.isAlikeDead() || actor.getDistance(target) > 4000)
			{
				setIntention(CtrlIntention.AI_INTENTION_ACTIVE);
				return;
			}

			if(!actor.isInRange(target, Config.FOLLOW_RANGE + 20) && (!actor.getMovement().isFollow() || actor.getMovement().getFollowTarget() != target))
			{
				Location loc = new Location(target.getX() + Rnd.get(-60, 60), target.getY() + Rnd.get(-60, 60), target.getZ());
				actor.getMovement().followToCharacter(loc, target, Config.FOLLOW_RANGE, false);
			}
			_followTask = ThreadPoolManager.getInstance().schedule(this, 250L);
		}
	}
}