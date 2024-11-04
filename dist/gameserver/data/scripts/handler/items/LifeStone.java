package handler.items;

import l2s.gameserver.model.Player;
import l2s.gameserver.model.items.ItemInstance;
import l2s.gameserver.network.l2.components.SystemMsg;
import l2s.gameserver.network.l2.s2c.ExPutIntensiveResultForVariationMake;
import l2s.gameserver.network.l2.s2c.ExShowVariationMakeWindow;

public class LifeStone extends SimpleItemHandler
{
	@Override
	protected boolean useItemImpl(Player player, ItemInstance item, boolean ctrl)
	{
		int itemId = item.getItemId();
		player.sendPacket(SystemMsg.SELECT_THE_ITEM_TO_BE_AUGMENTED, ExShowVariationMakeWindow.STATIC);
		player.sendPacket(new ExPutIntensiveResultForVariationMake(item.getObjectId(), itemId, 0, 0));
		return true;
	}
}
