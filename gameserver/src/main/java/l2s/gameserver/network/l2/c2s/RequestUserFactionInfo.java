package l2s.gameserver.network.l2.c2s;

import l2s.gameserver.model.Player;
import l2s.gameserver.network.l2.s2c.ExFactionInfo;

/**
 * @author Bonux
**/
public class RequestUserFactionInfo extends L2GameClientPacket
{
	private int _playerId;
	private int _action;

	@Override
	protected boolean readImpl()
	{
		_playerId = readD();
		_action = readC();
		return true;
	}

	@Override
	protected void runImpl()
	{
		Player activeChar = getClient().getActiveChar();
		if(activeChar == null)
			return;

		activeChar.sendPacket(new ExFactionInfo(_playerId, _action));
	}
}