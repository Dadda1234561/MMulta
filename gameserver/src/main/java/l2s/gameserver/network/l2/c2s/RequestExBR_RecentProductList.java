package l2s.gameserver.network.l2.c2s;

import l2s.gameserver.Config;
import l2s.gameserver.model.Player;
import l2s.gameserver.network.l2.s2c.ExBR_RecentProductListPacket;

public class RequestExBR_RecentProductList extends L2GameClientPacket
{
	@Override
	public boolean readImpl()
	{
		// триггер
		return true;
	}

	@Override
	public void runImpl()
	{
		if(!Config.EX_USE_PRIME_SHOP)
			return;

		Player activeChar = getClient().getActiveChar();

		if(activeChar == null)
			return;

		activeChar.sendPacket(new ExBR_RecentProductListPacket(activeChar));
	}
}