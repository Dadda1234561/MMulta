package l2s.gameserver.model.actor.instances.player;

import java.util.Arrays;
import java.util.Deque;
import java.util.LinkedList;
import java.util.List;

import l2s.gameserver.geometry.Location;
import l2s.gameserver.model.Player;
import l2s.gameserver.network.l2.s2c.ExFlyMove;
import l2s.gameserver.network.l2.s2c.ExFlyMoveBroadcast;
import l2s.gameserver.network.l2.s2c.FlyToLocationPacket;
import l2s.gameserver.templates.jump.JumpPoint;
import l2s.gameserver.templates.jump.JumpTrack;
import l2s.gameserver.templates.jump.JumpWay;
import l2s.gameserver.templates.jump.JumpWay.WayType;

/**
 * @author  Bonux
 */
 //Сделать стейбл точку при обрыве прыжка.
public class FlyMove
{
	private final Player _owner;
	private final JumpTrack _track;

	private Location _stablePoint = null;
	private JumpWay _currentJumpWay = null;

	public FlyMove(Player owner, JumpTrack track)
	{
		_owner = owner;
		_track = track;
	}

	public Location getStablePoint()
	{
		return _stablePoint;
	}

	public synchronized void move(int nextWayId)
	{
		if(nextWayId == 0) // Начинаем
		{
			if(_owner.isInFlyMove())
				return;

			_currentJumpWay = _track.getWay(0);
			if(_currentJumpWay == null)
				return;

			_stablePoint = new Location(_owner); // TODO: У прыжков должны быть отдельныые стабильные координаты (оффлайк).

			WayType type = _currentJumpWay.getType();

			_owner.setFlyMove(this);
			_owner.sendPacket(new FlyToLocationPacket(_owner, _track, FlyToLocationPacket.FlyType.DUMMY, 0, 0, 0));
			_owner.sendPacket(new ExFlyMove(_owner, type, _track.getId(), _currentJumpWay.getPoints()));
			if(type == WayType.ONE_WAY_LOC)
				_owner.broadcastPacketToOthers(new ExFlyMoveBroadcast(_owner, type, _track.getId(), _currentJumpWay.getFirstPoint()));
			else
				_owner.broadcastPacketToOthers(new ExFlyMoveBroadcast(_owner, type, _track.getId(), _track));
			_owner.setLoc(_track);
		}
		else
		{
			if(_currentJumpWay == null)
			{
				breakJumping(true);
				return;
			}

			JumpPoint point = _currentJumpWay.getJumpPoint(nextWayId);
			if(point == null)
			{
				breakJumping(true);
				return;
			}

			WayType type = _currentJumpWay.getType();

			if(type != WayType.ONE_WAY_LOC)
				_owner.broadcastPacketToOthers(new ExFlyMoveBroadcast(_owner, type, _track.getId(), point));

			_owner.setLoc(point);

			_currentJumpWay = _track.getWay(nextWayId);
			if(_currentJumpWay == null)
			{
				breakJumping(false);
				return;
			}

			type = _currentJumpWay.getType();

			_owner.sendPacket(new ExFlyMove(_owner, type, _track.getId(), _currentJumpWay.getPoints()));

			if(type == WayType.ONE_WAY_LOC)
				_owner.broadcastPacketToOthers(new ExFlyMoveBroadcast(_owner, type, _track.getId(), _currentJumpWay.getFirstPoint()));
		}
	}
	
	private void breakJumping(boolean teleport)
	{
		_owner.setFlyMove(null);

		if(teleport && _stablePoint != null)
			_owner.teleToLocation(_stablePoint);
	}
}