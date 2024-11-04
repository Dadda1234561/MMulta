package l2s.gameserver.network.l2.s2c;

import java.util.Collection;

import l2s.gameserver.model.Player;
import l2s.gameserver.templates.jump.JumpPoint;
import l2s.gameserver.templates.jump.JumpWay.WayType;

/**
 * @author Bonux
**/
public class ExFlyMove extends L2GameServerPacket
{
	private final int _objId;
	private final WayType _type;
	private final int _trackId;
	private final Collection<JumpPoint> _points;

	public ExFlyMove(Player player, WayType type, int trackId, Collection<JumpPoint> points)
	{
		_objId = player.getObjectId();
		_type = type;
		_trackId = trackId;
		_points = points;
	}

	@Override
	protected void writeImpl()
	{
		writeD(_objId); //Player Object ID
		writeD(_type.ordinal()); //Fly Type (1 - Many Way, 2 - One Way)
		writeD(0x00); //UNK
		writeD(_trackId); //Track ID
		writeD(_points.size()); //Next Points Count
		for(JumpPoint point : _points)
		{
			writeD(point.getNextWayId()); //Next Way ID
			writeD(0x00); //UNK
			writeD(point.getX());
			writeD(point.getY());
			writeD(point.getZ());
		}
	}
}
