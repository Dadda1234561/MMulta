package l2s.gameserver.network.l2.c2s;

import l2s.gameserver.Config;
import l2s.gameserver.model.Player;
import l2s.gameserver.model.items.ItemInstance;
import l2s.gameserver.network.l2.components.SystemMsg;
import l2s.gameserver.network.l2.s2c.ExApplyVariationOption;
import l2s.gameserver.network.l2.s2c.ExVariationResult;
import l2s.gameserver.network.l2.s2c.InventoryUpdatePacket;
import l2s.gameserver.templates.item.support.variation.VariationFee;
import l2s.gameserver.templates.item.support.variation.VariationResult;
import l2s.gameserver.utils.VariationUtils;
import org.apache.commons.lang3.tuple.Pair;

public final class RequestRefine extends L2GameClientPacket
{
	// format: (ch)dddd
	private int _targetItemObjId, _refinerItemObjId, _bIsVariationEventOn;

	@Override
	protected boolean readImpl()
	{
		_targetItemObjId = readD();
		_refinerItemObjId = readD();
		_bIsVariationEventOn = readC();
		return true;
	}

	@Override
	protected void runImpl()
	{
		Player activeChar = getClient().getActiveChar();
		if(activeChar == null)
			return;

		if(!Config.ALLOW_AUGMENTATION)
		{
			activeChar.sendActionFailed();
			return;
		}

		if(activeChar.isActionsDisabled())
		{
			activeChar.sendPacket(new ExVariationResult(0, 0, 0));
			return;
		}

		if(activeChar.isInStoreMode())
		{
			activeChar.sendPacket(new ExVariationResult(0, 0, 0));
			return;
		}

		if(activeChar.isInTrade())
		{
			activeChar.sendPacket(new ExVariationResult(0, 0, 0));
			return;
		}

		ItemInstance targetItem = activeChar.getInventory().getItemByObjectId(_targetItemObjId);
		ItemInstance refinerItem = activeChar.getInventory().getItemByObjectId(_refinerItemObjId);

		if(targetItem == null || refinerItem == null || activeChar.getLevel() < 46)
		{
			activeChar.sendPacket(new ExVariationResult(0, 0, 0), SystemMsg.AUGMENTATION_FAILED_DUE_TO_INAPPROPRIATE_CONDITIONS);
			return;
		}

		VariationFee fee = VariationUtils.getVariationFee(targetItem, refinerItem);
		if(fee == null)
		{
			activeChar.sendPacket(new ExVariationResult(0, 0, 0), SystemMsg.AUGMENTATION_FAILED_DUE_TO_INAPPROPRIATE_CONDITIONS);
			return;
		}
		
		ItemInstance feeItem = activeChar.getInventory().getItemByItemId(fee.getFeeItemId());
		if(feeItem == null)
		{
			activeChar.sendPacket(new ExVariationResult(0, 0, 0), SystemMsg.AUGMENTATION_FAILED_DUE_TO_INAPPROPRIATE_CONDITIONS);
			return;
		}

		boolean isAugmentedAlready = targetItem.getVariationStoneId() != 0;
		final VariationResult result = VariationUtils.tryAugmentItem(activeChar, targetItem, refinerItem, feeItem, fee.getFeeItemCount(), fee.getFeeAdenaCount());
		if(result.isSuccess())
		{
			activeChar.sendPacket(new ExVariationResult(result.option1ID(), result.option2ID(), 1));
			if (!isAugmentedAlready)
			{
				activeChar.sendPacket(new ExApplyVariationOption(result));
			}
		}
		else
		{
			activeChar.sendPacket(new ExVariationResult(0, 0, 0), SystemMsg.AUGMENTATION_FAILED_DUE_TO_INAPPROPRIATE_CONDITIONS);
		}

		boolean isFailure = false;
		for (Pair<Integer, Long> removeItems : result.getRemovableItems())
		{
			if(!activeChar.getInventory().destroyItemByItemId(removeItems.getKey(), removeItems.getValue()))
			{
				isFailure = true;
			}
		}

		if (isFailure)
		{
			activeChar.sendPacket(new ExVariationResult(0, 0, 0), SystemMsg.AUGMENTATION_FAILED_DUE_TO_INAPPROPRIATE_CONDITIONS);
			return;
		}

		activeChar.setLastVariationStoneId(refinerItem.getItemId());
		if (!targetItem.isAugmented())
		{
			VariationUtils.setVariation(activeChar, targetItem, refinerItem.getItemId(), result.option1ID(), result.option2ID());
		}
	}
}