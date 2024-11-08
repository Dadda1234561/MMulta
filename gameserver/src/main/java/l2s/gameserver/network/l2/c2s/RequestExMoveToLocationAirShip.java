package l2s.gameserver.network.l2.c2s;

import l2s.gameserver.model.Player;
import l2s.gameserver.model.entity.boat.ClanAirShip;

/**
 * Format: d d|dd
 */
public class RequestExMoveToLocationAirShip extends L2GameClientPacket
{
	private int _moveType;
	private int _param1, _param2;

	@Override
	protected boolean readImpl()
	{
		_moveType = readD();
		switch(_moveType)
		{
			case 4: // AirShipTeleport
				_param1 = readD() + 1;
				break;
			case 0: // Free move
				_param1 = readD();
				_param2 = readD();
				break;
			case 2: // Up
				readD(); //?
				readD(); //?
				break;
			case 3: //Down
				readD(); //?
				readD(); //?
				break;
		}
		return true;
	}

	@Override
	protected void runImpl()
	{
		Player player = getClient().getActiveChar();
		if(player == null || player.getBoat() == null || !player.getBoat().isClanAirShip())
			return;

		ClanAirShip airship = (ClanAirShip) player.getBoat();
		if(airship.getDriver() == player)
			switch(_moveType)
			{
				case 4: // AirShipTeleport
					airship.addTeleportPoint(player, _param1);
					break;
				case 0: // Free move
					if(!airship.isCustomMove())
						break;
					airship.getMovement().moveToLocation(airship.getLoc().setX(_param1).setY(_param2), 0, false);
					break;
				case 2: // Up
					if(!airship.isCustomMove())
						break;
					airship.getMovement().moveToLocation(airship.getLoc().changeZ(100), 0, false);
					break;
				case 3: // Down
					if(!airship.isCustomMove())
						break;
					airship.getMovement().moveToLocation(airship.getLoc().changeZ(-100), 0, false);
					break;
			}
	}
}