package l2s.gameserver.network.l2.c2s.compound;

import l2s.gameserver.data.xml.holder.SynthesisDataHolder;
import l2s.gameserver.model.Player;
import l2s.gameserver.model.items.ItemInstance;
import l2s.gameserver.network.l2.c2s.L2GameClientPacket;
import l2s.gameserver.network.l2.components.SystemMsg;
import l2s.gameserver.network.l2.s2c.SystemMessagePacket;
import l2s.gameserver.network.l2.s2c.compound.ExEnchantRetryToPutItemFail;
import l2s.gameserver.network.l2.s2c.compound.ExEnchantRetryToPutItemOk;
import l2s.gameserver.templates.item.support.SynthesisData;

public class RequestNewEnchantRetryToPutItems extends L2GameClientPacket
{
    private int _firstItemObjectId;
    private int _secondItemObjectId;

    @Override
    protected boolean readImpl()
    {
        _firstItemObjectId = readD();
        _secondItemObjectId = readD();
        return true;
    }

    @Override
    protected void runImpl() {
        final Player player = getClient().getActiveChar();
        if (player == null) {
            return;
        } else if (player.isInStoreMode()) {
            getClient().sendPacket(new SystemMessagePacket(SystemMsg.YOU_CANNOT_DO_THAT_WHILE_IN_A_PRIVATE_STORE_OR_PRIVATE_WORKSHOP));
            getClient().sendPacket(ExEnchantRetryToPutItemFail.STATIC);
            return;
        } else if (player.isInTrade() || player.isProcessingRequest()) {
            getClient().sendPacket(new SystemMessagePacket(SystemMsg.YOU_CANNOT_USE_THIS_SYSTEM_DURING_TRADING_PRIVATE_STORE_AND_WORKSHOP_SETUP));
            getClient().sendPacket(ExEnchantRetryToPutItemFail.STATIC);
            return;
        }

        // Make sure player owns first item.
        final ItemInstance itemOne = player.getInventory().getItemByObjectId(_firstItemObjectId);
        if (itemOne == null) {
            getClient().sendPacket(ExEnchantRetryToPutItemFail.STATIC);
            return;
        }
        player.setSynthesisItem1(itemOne);

        // Make sure player owns second item.
        final ItemInstance itemTwo = player.getInventory().getItemByObjectId(_secondItemObjectId);
        if (itemTwo == null) {
            getClient().sendPacket(ExEnchantRetryToPutItemFail.STATIC);
            return;
        }
        player.setSynthesisItem2(itemTwo);

        // check if synthesis data exists..
        final SynthesisData synthesisData = SynthesisDataHolder.getInstance().getData(itemOne.getItemId(), itemTwo.getItemId());
        if (synthesisData == null) {
            getClient().sendPacket(ExEnchantRetryToPutItemFail.STATIC);
            return;
        }

        // ????
        if ((itemOne.getObjectId() == itemTwo.getObjectId()) && (!itemOne.isStackable() || (player.getInventory().getCountOf(itemOne.getItemId()) < 2))) {
            getClient().sendPacket(ExEnchantRetryToPutItemFail.STATIC);
            return;
        }

        getClient().sendPacket(ExEnchantRetryToPutItemOk.STATIC);
    }
}
