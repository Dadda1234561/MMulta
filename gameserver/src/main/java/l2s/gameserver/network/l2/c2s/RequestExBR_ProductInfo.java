package l2s.gameserver.network.l2.c2s;

import l2s.gameserver.Config;
import l2s.gameserver.model.Player;
import l2s.gameserver.network.l2.s2c.ExBR_ProductInfoPacket;

public class RequestExBR_ProductInfo extends L2GameClientPacket
{
	private int _productId;

	@Override
	protected boolean readImpl()
	{
		_productId = readD();
		return true;
	}

	@Override
	protected void runImpl()
	{
		if(!Config.EX_USE_PRIME_SHOP)
			return;

		Player activeChar = getClient().getActiveChar();

		if(activeChar == null)
			return;

		activeChar.sendPacket(new ExBR_ProductInfoPacket(activeChar, _productId));
	}
}