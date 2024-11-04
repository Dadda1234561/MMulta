package l2s.gameserver.network.l2.c2s;

import l2s.gameserver.model.Player;
import l2s.gameserver.model.actor.instances.player.FlyMove;

/**
 * @author UnAfraid
 * @reworked by Bonux
 */
public final class RequestFlyMove extends L2GameClientPacket
{
	private int _pointId;

	@Override
	protected boolean readImpl()
	{
		_pointId = readD();
		return true;
	}

	@Override
	protected void runImpl()
	{
		Player activeChar = getClient().getActiveChar();
		if(activeChar == null)
			return;

		FlyMove flyMove = activeChar.getFlyMove();
		if(flyMove == null)
			return;

		flyMove.move(_pointId);
	}
}