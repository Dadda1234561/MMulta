package l2s.gameserver.network.l2.c2s.compound;

import l2s.gameserver.model.Player;
import l2s.gameserver.model.items.ItemInstance;
import l2s.gameserver.network.l2.c2s.L2GameClientPacket;
import l2s.gameserver.network.l2.s2c.compound.ExEnchantOneRemoveFail;
import l2s.gameserver.network.l2.s2c.compound.ExEnchantOneRemoveOK;

/**
 * @author Bonux
**/
public class RequestNewEnchantRemoveOne extends L2GameClientPacket
{
	private int _item1ObjectId;

	@Override
	protected boolean readImpl()
	{
		_item1ObjectId = readD();
		return true;
	}

	@Override
	protected void runImpl()
	{
		final Player activeChar = getClient().getActiveChar();
		if(activeChar == null)
			return;

		final ItemInstance item1 = activeChar.getInventory().getItemByObjectId(_item1ObjectId);
		if(item1 == null)
		{
			activeChar.sendPacket(ExEnchantOneRemoveFail.STATIC);
			return;
		}

		if(activeChar.getSynthesisItem1() != item1)
		{
			activeChar.sendPacket(ExEnchantOneRemoveFail.STATIC);
			return;
		}

		activeChar.setSynthesisItem1(null);
		activeChar.sendPacket(ExEnchantOneRemoveOK.STATIC);
	}
}