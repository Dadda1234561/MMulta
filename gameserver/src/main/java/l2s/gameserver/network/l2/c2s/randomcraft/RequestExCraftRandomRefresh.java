package l2s.gameserver.network.l2.c2s.randomcraft;

import l2s.gameserver.model.Player;
import l2s.gameserver.network.l2.c2s.L2GameClientPacket;
import l2s.gameserver.network.l2.s2c.randomcraft.ExCraftRandomRefresh;

public class RequestExCraftRandomRefresh extends L2GameClientPacket
{
	@Override
	protected boolean readImpl()
	{
		return true;
	}

	@Override
	protected void runImpl()
	{
		Player activeChar = getClient().getActiveChar();
		if (activeChar == null)
			return;

		activeChar.sendPacket(new ExCraftRandomRefresh(activeChar));
	}
}