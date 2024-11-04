package l2s.gameserver.network.l2.c2s.timerestrictfield;

import l2s.gameserver.model.Player;
import l2s.gameserver.network.l2.c2s.L2GameClientPacket;
import l2s.gameserver.network.l2.s2c.timerestrictfield.ExTimeRestrictFieldHostUserEnter;

public class RequestExTimeRestrictFieldHostUserEnter extends L2GameClientPacket
{
	private int nEnterFieldID;

	@Override
	protected boolean readImpl() throws Exception
	{
		nEnterFieldID = readD();
		return true;
	}

	@Override
	protected void runImpl() throws Exception
	{
		Player player = getClient().getActiveChar();
		if(player == null)
		{
			return;
		}

		player.sendPacket(new ExTimeRestrictFieldHostUserEnter(nEnterFieldID));
	}
}
