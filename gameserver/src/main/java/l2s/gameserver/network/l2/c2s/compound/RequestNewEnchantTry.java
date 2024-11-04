package l2s.gameserver.network.l2.c2s.compound;

import l2s.commons.util.Rnd;
import l2s.gameserver.data.xml.holder.SynthesisDataHolder;
import l2s.gameserver.listener.Acts;
import l2s.gameserver.model.Player;
import l2s.gameserver.model.items.Inventory;
import l2s.gameserver.model.items.ItemInstance;
import l2s.gameserver.network.l2.c2s.L2GameClientPacket;
import l2s.gameserver.network.l2.components.SystemMsg;
import l2s.gameserver.network.l2.s2c.compound.ExEnchantFail;
import l2s.gameserver.network.l2.s2c.compound.ExEnchantSucess;
import l2s.gameserver.templates.item.data.ItemData;
import l2s.gameserver.templates.item.support.SynthesisData;
import l2s.gameserver.utils.ItemFunctions;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.util.ArrayList;
import java.util.List;

/**
 * @author Bonux
**/
public class RequestNewEnchantTry extends L2GameClientPacket
{
	private static final Logger LOGGER = LoggerFactory.getLogger(RequestNewEnchantTry.class);

	@Override
	protected boolean readImpl()
	{
		//
		return true;
	}

	@Override
	protected void runImpl()
	{
		final Player activeChar = getClient().getActiveChar();
		if(activeChar == null)
			return;

		//if(activeChar.isActionsDisabled()) // TODO: Check.
		//{
		//	System.out.println("activeChar = " + activeChar);
		//	activeChar.setSynthesisItem1(null);
		//	activeChar.setSynthesisItem2(null);
		//	activeChar.sendPacket(ExEnchantFail.STATIC);
		//	return;
		//}

		if(activeChar.isInStoreMode()) // TODO: Check.
		{
			activeChar.setSynthesisItem1(null);
			activeChar.setSynthesisItem2(null);
			activeChar.sendPacket(ExEnchantFail.STATIC);
			return;
		}

		if(activeChar.isInTrade()) // TODO: Check.
		{
			activeChar.setSynthesisItem1(null);
			activeChar.setSynthesisItem2(null);
			activeChar.sendPacket(ExEnchantFail.STATIC);
			return;
		}

		if(activeChar.isFishing()) // TODO: Check.
		{
			activeChar.setSynthesisItem1(null);
			activeChar.setSynthesisItem2(null);
			activeChar.sendPacket(ExEnchantFail.STATIC);
			return;
		}

		if(activeChar.isInTrainingCamp()) // TODO: Check.
		{
			activeChar.setSynthesisItem1(null);
			activeChar.setSynthesisItem2(null);
			activeChar.sendPacket(ExEnchantFail.STATIC);
			return;
		}

		final ItemInstance item1 = activeChar.getSynthesisItem1();
		if(item1 == null)
		{
			activeChar.setSynthesisItem1(null);
			activeChar.setSynthesisItem2(null);
			activeChar.sendPacket(ExEnchantFail.STATIC);
			return;
		}

		final ItemInstance item2 = activeChar.getSynthesisItem2();
		if(item2 == null)
		{
			activeChar.setSynthesisItem1(null);
			activeChar.setSynthesisItem2(null);
			activeChar.sendPacket(ExEnchantFail.STATIC);
			return;
		}

		if(item1 == item2 && item1.getCount() <= 1)
		{
			activeChar.setSynthesisItem1(null);
			activeChar.setSynthesisItem2(null);
			activeChar.sendPacket(ExEnchantFail.STATIC);
			return;
		}

		SynthesisData data = null;
		for(SynthesisData d : SynthesisDataHolder.getInstance().getDatas())
		{
			if(item1.getItemId() == d.getItem1Id() && item2.getItemId() == d.getItem2Id())
			{
				data = d;
				break;
			}

			if(item1.getItemId() == d.getItem2Id() && item2.getItemId() == d.getItem1Id())
			{
				data = d;
				break;
			}
		}

		if(data == null)
		{
			activeChar.setSynthesisItem1(null);
			activeChar.setSynthesisItem2(null);
			activeChar.sendPacket(ExEnchantFail.STATIC);
			return;
		}

		boolean locationAvailable = false;
		for(int locationId : data.getLocationIds()) {
			if(locationId == -1 || locationId == activeChar.getLocationId()) {
				locationAvailable = true;
				break;
			}
		}

		if(!locationAvailable)
		{
			activeChar.setSynthesisItem1(null);
			activeChar.setSynthesisItem2(null);
			activeChar.sendPacket(ExEnchantFail.STATIC);
			return;
		}

		if(data.getChance() < 0)
		{
			activeChar.setSynthesisItem1(null);
			activeChar.setSynthesisItem2(null);
			activeChar.sendPacket(ExEnchantFail.STATIC);
			LOGGER.warn("Chance in synthesis data ID1[" + data.getItem1Id() + "] ID2[" + data.getItem2Id() + "] not specified!");
			return;
		}

		if (activeChar.getAdena() <= data.getCommission())
		{
			activeChar.sendPacket(SystemMsg.YOU_DO_NOT_HAVE_ENOUGH_ADENA, ExEnchantFail.STATIC);
			return;
		}

		final Inventory inventory = activeChar.getInventory();

		inventory.writeLock();

		try
		{
			if(inventory.getItemByObjectId(item1.getObjectId()) == null)
			{
				activeChar.setSynthesisItem1(null);
				activeChar.setSynthesisItem2(null);
				activeChar.sendPacket(ExEnchantFail.STATIC);
				return;
			}

			if(inventory.getItemByObjectId(item2.getObjectId()) == null)
			{
				activeChar.setSynthesisItem1(null);
				activeChar.setSynthesisItem2(null);
				activeChar.sendPacket(ExEnchantFail.STATIC);
				return;
			}

			List<ItemData> synthesisItems = new ArrayList<>();
			synthesisItems.add(new ItemData(item1.getItemId(), 1));
			synthesisItems.add(new ItemData(item2.getItemId(), 1));


			// Commission
			if (ItemFunctions.deleteItem(activeChar, item1, 1, true) && ItemFunctions.deleteItem(activeChar, item2, 1, true) && ItemFunctions.deleteItem(activeChar, 57, data.getCommission(), true))
			{
				final boolean isSuccess = Rnd.chance(data.getChance());
				final ItemData rewardItemData = isSuccess ? data.getSuccessItemData() : data.getFailItemData();
				if (rewardItemData != null) {
					// send result
					if (isSuccess) {
						activeChar.sendPacket(new ExEnchantSucess(rewardItemData.getId()));
					} else {
						activeChar.sendPacket(new ExEnchantFail(rewardItemData.getId(), data.getSuccessItemData().getId()));
					}
					// add item
					ItemFunctions.addItem(activeChar, rewardItemData.getId(), rewardItemData.getCount(), true);
				}

				activeChar.getListeners().onAct(Acts.ITEM_SYNTHESIS_ACT, synthesisItems, rewardItemData, isSuccess);
			}
			else
			{
				activeChar.sendPacket(ExEnchantFail.STATIC);
				return;
			}

			// else send fail ?

			activeChar.setSynthesisItem1(null);
			activeChar.setSynthesisItem2(null);
		}
		finally
		{
			inventory.writeUnlock();
		}
	}
}