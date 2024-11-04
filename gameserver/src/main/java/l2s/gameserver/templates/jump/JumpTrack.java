package l2s.gameserver.templates.jump;

import java.util.Collection;

import l2s.gameserver.geometry.ILocation;

import org.napile.primitive.maps.IntObjectMap;
import org.napile.primitive.maps.impl.HashIntObjectMap;

/**
 * @author Bonux
 */
public class JumpTrack implements ILocation
{
	private final int _id;
	private final int _x, _y, _z;
	private final IntObjectMap<JumpWay> _trackWays = new HashIntObjectMap<JumpWay>();

	public JumpTrack(int id, int x, int y, int z)
	{
		_id = id;
		_x = x;
		_y = y;
		_z = z;
	}

	public int getId()
	{
		return _id;
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

	public Collection<JumpWay> getWays()
	{
		return _trackWays.valueCollection();
	}

	public JumpWay getWay(int id)
	{
		return _trackWays.get(id);
	}

	public void addWay(JumpWay way)
	{
		_trackWays.put(way.getId(), way);
	}
}