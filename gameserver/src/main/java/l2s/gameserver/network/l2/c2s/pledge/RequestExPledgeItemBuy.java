package l2s.gameserver.network.l2.c2s.pledge;

import l2s.gameserver.data.xml.holder.ClanShopHolder;
import l2s.gameserver.model.Player;
import l2s.gameserver.model.items.Inventory;
import l2s.gameserver.network.l2.c2s.L2GameClientPacket;
import l2s.gameserver.network.l2.s2c.pledge.ExPledgeItemBuy;
import l2s.gameserver.templates.ClanShopProduct;
import l2s.gameserver.utils.ItemFunctions;

/**
 * @author Bonux (bonuxq@gmail.com)
 * @date 25.09.2019
 **/
public class RequestExPledgeItemBuy extends L2GameClientPacket {
	private int itemId;
	private int count;

	@Override
	protected boolean readImpl() {
		itemId = readD();
		count = readD();
		return true;
	}

	@Override
	protected void runImpl() {
		Player activeChar = getClient().getActiveChar();
		if (activeChar == null)
			return;

		if (activeChar.getClan() == null) {
			activeChar.sendActionFailed();
			return;
		}

		ClanShopProduct product = ClanShopHolder.getInstance().getClanShopProduct(itemId);
		if (product == null) {
			activeChar.sendPacket(ExPledgeItemBuy.FAIL);
			return;
		}

		if (activeChar.getClan().getLevel() < product.getClanLevel()) {
			activeChar.sendPacket(ExPledgeItemBuy.NOT_AUTHORIZED);
			return;
		}

		final Inventory inventory = activeChar.getInventory();
		final long slots = product.getItemInfo().getItem().isStackable() ? 1 : product.getItemInfo().getCount() * count;
		final long weight = product.getItemInfo().getItem().getWeight() * product.getItemInfo().getCount() * count;
		if (!inventory.validateWeight(weight) || !inventory.validateCapacity(slots)) {
			activeChar.sendPacket(ExPledgeItemBuy.REQUIREMENTS_NOT_MET);
			return;
		}

		inventory.writeLock();
		try {
			if ((activeChar.getAdena() < (product.getAdena() * count)) || (activeChar.getFame() < (product.getFame() * count))) {
				activeChar.sendPacket(ExPledgeItemBuy.REQUIREMENTS_NOT_MET);
				return;
			}

			if (product.getAdena() > 0)
				activeChar.reduceAdena(product.getAdena() * count, true);

			if (product.getFame() > 0)
				activeChar.setFame(activeChar.getFame() - (product.getFame() * count), "Pledge item buy", true);
		} finally {
			inventory.writeUnlock();
		}

		ItemFunctions.addItem(activeChar, itemId, product.getItemCount() * count, true);
		activeChar.sendPacket(ExPledgeItemBuy.SUCCESS);
	}
}