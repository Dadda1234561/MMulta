package ai.seedofinfinity;

import l2s.commons.util.Rnd;
import l2s.gameserver.ai.DefaultAI;
import l2s.gameserver.geometry.Location;
import l2s.gameserver.model.Creature;
import l2s.gameserver.model.Skill;
import l2s.gameserver.model.instances.NpcInstance;
import instances.HeartInfinityDefence;

/**
 * @author pchayka
 */

public class EkimusFood extends DefaultAI
{
	private static final Location[] _route1 = {new Location(-179544, 207400, -15496),
			new Location(-178856, 207464, -15496),
			new Location(-178168, 207864, -15496),
			new Location(-177512, 208728, -15496),
			new Location(-177336, 209528, -15496),
			new Location(-177448, 210328, -15496),
			new Location(-177864, 211048, -15496),
			new Location(-178584, 211608, -15496),
			new Location(-179304, 211848, -15496),
			new Location(-179512, 211864, -15496),
			new Location(-179528, 211448, -15472)};

	private static final Location[] _route2 = {new Location(-179576, 207352, -15496),
			new Location(-180440, 207544, -15496),
			new Location(-181256, 208152, -15496),
			new Location(-181752, 209112, -15496),
			new Location(-181720, 210264, -15496),
			new Location(-181096, 211224, -15496),
			new Location(-180264, 211720, -15496),
			new Location(-179528, 211848, -15496),
			new Location(-179528, 211400, -15472)};

	private Location[] _points;

	private int _lastPoint = 0;

	public EkimusFood(NpcInstance actor)
	{
		super(actor);
		setMaxPursueRange(Integer.MAX_VALUE - 10);
		_points = Rnd.chance(50) ? _route1 : _route2;
		actor.getFlags().getDebuffImmunity().start();
	}

	@Override
	public boolean checkAggression(Creature target)
	{
		return false;
	}

	@Override
	protected void onEvtArrived()
	{
		startMoveTask();
		super.onEvtArrived();
	}

	@Override
	protected boolean thinkActive()
	{
		if(!_def_think)
			startMoveTask();
		return true;
	}

	private void startMoveTask()
	{
		NpcInstance npc = getActor();
		_lastPoint++;
		if(_lastPoint >= _points.length)
		{
			if(!npc.getReflection().isDefault())
			{
				((HeartInfinityDefence) npc.getReflection()).notifyWagonArrived();
				npc.deleteMe();
				return;
			}
		}
		addTaskMove(Location.findPointToStay(_points[_lastPoint], 250, npc.getGeoIndex()), true, false);
		doTask();
	}

	@Override
	protected void onEvtAttacked(Creature attacker, Skill skill, int damage)
	{
	}

	@Override
	protected boolean randomWalk()
	{
		return false;
	}

	@Override
	protected boolean hasRandomWalk()
	{
		return false;
	}

	@Override
	protected boolean teleportHome()
	{
		return false;
	}
}
