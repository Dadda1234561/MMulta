package l2s.gameserver.templates.jump;

import java.util.Collection;

import org.napile.primitive.maps.IntObjectMap;
import org.napile.primitive.maps.impl.HashIntObjectMap;

/**
 * @author Bonux
 */
public class JumpWay
{
	public static enum WayType
	{
		START_LOC,
		MULTI_WAY_LOC,
		ONE_WAY_LOC;
	}

	private final int _id;
	private final IntObjectMap<JumpPoint> _points = new HashIntObjectMap<JumpPoint>();

	private JumpPoint _firstPoint = null;

	public JumpWay(int id)
	{
		_id = id;
	}

	public int getId()
	{
		return _id;
	}

	public WayType getType()
	{
		if(_points.size() > 1)
		{
			if(_id == 0)
				return WayType.START_LOC;
			return WayType.MULTI_WAY_LOC;
		}
		else
			return WayType.ONE_WAY_LOC;
	}

	public Collection<JumpPoint> getPoints()
	{
		return _points.valueCollection();
	}

	public JumpPoint getFirstPoint()
	{
		return _firstPoint;
	}

	public JumpPoint getJumpPoint(int nextWayId)
	{
		return _points.get(nextWayId);
	}

	public void addPoint(JumpPoint point)
	{
		if(_firstPoint == null)
			_firstPoint = point;
		_points.put(point.getNextWayId(), point);
	}
}