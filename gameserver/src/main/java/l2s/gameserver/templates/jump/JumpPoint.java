package l2s.gameserver.templates.jump;

import l2s.gameserver.geometry.ILocation;

/**
 * @author Bonux
 */
public class JumpPoint implements ILocation
{
	private final int _x, _y, _z;
	private final int _nextWayId;

	public JumpPoint(int x, int y, int z, int nextWayId)
	{
		_x = x;
		_y = y;
		_z = z;
		_nextWayId = nextWayId;
	}

	@Override
	public int getX()
	{
		return _x;
	}

	@Override
	public int getY()
	{
		return _y;
	}

	@Override
	public int getZ()
	{
		return _z;
	}

	@Override
	public int getHeading()
	{
		return 0;
	}

	public int getNextWayId()
	{
		return _nextWayId;
	}
}