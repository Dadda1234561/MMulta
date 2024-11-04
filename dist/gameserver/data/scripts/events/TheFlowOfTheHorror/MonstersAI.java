package events.TheFlowOfTheHorror;

import java.util.ArrayList;
import java.util.List;

import l2s.commons.util.Rnd;
import l2s.gameserver.ai.CtrlIntention;
import l2s.gameserver.ai.Fighter;
import l2s.gameserver.geometry.Location;
import l2s.gameserver.model.GameObjectsStorage;
import l2s.gameserver.model.instances.NpcInstance;


public class MonstersAI extends Fighter
{
	private List<Location> _points = new ArrayList<Location>();
	private int current_point = -1;

	public void setPoints(List<Location> points)
	{
		_points = points;
	}

	public MonstersAI(NpcInstance actor)
	{
		super(actor);
		_attackAITaskDelay = 500;
		setMaxPursueRange(30000);
	}

	@Override
	public boolean isGlobalAI()
	{
		return true;
	}

	@Override
	protected boolean thinkActive()
	{
		NpcInstance actor = getActor();
		if(actor == null || actor.isDead())
			return true;

		if(_def_think)
		{
			doTask();
			return true;
		}

		if(current_point > -1 || Rnd.chance(5))
		{
			if(current_point >= _points.size() - 1)
			{
				List<NpcInstance> targets = GameObjectsStorage.getNpcs(true, 30754);
				if(!targets.isEmpty())
				{
					clearTasks();
					// TODO actor.addDamageHate(targets.get(0), 0, 1000);
					setIntention(CtrlIntention.AI_INTENTION_ATTACK, targets.get(0));
					return true;
				}
				return true;
			}

			current_point++;

			actor.setRunning();

			clearTasks();

			// Добавить новое задание
			addTaskMove(_points.get(current_point), true, false);
			doTask();
			return true;
		}

		if(randomAnimation())
			return true;

		return false;
	}
}