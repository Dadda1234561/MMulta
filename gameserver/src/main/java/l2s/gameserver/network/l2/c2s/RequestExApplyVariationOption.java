package l2s.gameserver.network.l2.c2s;

import l2s.gameserver.model.Player;
import l2s.gameserver.model.items.ItemInstance;
import l2s.gameserver.network.l2.s2c.ExApplyVariationOption;
import l2s.gameserver.utils.VariationUtils;

/**
 * @author sharp on 08.01.2023
 * t.me/sharp1que
 */
public class RequestExApplyVariationOption extends L2GameClientPacket
{
    private int nVariationItemSID, nItemOption1, nItemOption2;

    @Override
    protected boolean readImpl() throws Exception
    {
        nVariationItemSID = readD();
        nItemOption1 = readD();
        nItemOption2 = readD();
        return true;
    }

    @Override
    protected void runImpl() throws Exception
    {
        final Player player = getClient().getActiveChar();
        if (player == null)
        {
            return;
        }

        final ItemInstance targetItem = player.getInventory().getItemByObjectId(nVariationItemSID);
        if (targetItem == null)
        {
            return;
        }

        final int lastStoneId = player.getLastVariationStoneId();
        if (lastStoneId == 0)
        {
            _log.info("Player {} tried to apply variation without stone id stored!", player.getName());
            player.sendPacket(new ExApplyVariationOption(false, nVariationItemSID, nItemOption1, nItemOption2));
            player.sendActionFailed();
            return;
        }

        // check if variations are valid for this item

        VariationUtils.setVariation(player, targetItem, player.getLastVariationStoneId(), nItemOption1, nItemOption2);
        player.sendPacket(new ExApplyVariationOption(true, nVariationItemSID, nItemOption1, nItemOption2));
    }
}
