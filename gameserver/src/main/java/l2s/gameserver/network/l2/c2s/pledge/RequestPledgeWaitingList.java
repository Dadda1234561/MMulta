package l2s.gameserver.network.l2.c2s.pledge;

import l2s.gameserver.model.Player;
import l2s.gameserver.network.l2.c2s.L2GameClientPacket;
import l2s.gameserver.network.l2.s2c.pledge.ExPledgeWaitingList;

/**
 * @author GodWorld
 * @reworked by Bonux
**/
public class RequestPledgeWaitingList extends L2GameClientPacket
{
	private int _clanId;

	@Override
	protected boolean readImpl()
	{
		_clanId = readD();
		return true;
	}

	@Override
	protected void runImpl()
	{
		Player activeChar = getClient().getActiveChar();
		if(activeChar == null)
			return;

		activeChar.sendPacket(new ExPledgeWaitingList(_clanId));
	}
}