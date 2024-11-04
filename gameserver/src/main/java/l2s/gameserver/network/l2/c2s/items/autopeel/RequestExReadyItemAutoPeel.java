package l2s.gameserver.network.l2.c2s.items.autopeel;

import l2s.gameserver.handler.items.IItemHandler;
import l2s.gameserver.handler.items.ItemHandler;
import l2s.gameserver.model.Player;
import l2s.gameserver.model.items.ItemInstance;
import l2s.gameserver.network.l2.c2s.L2GameClientPacket;
import l2s.gameserver.network.l2.s2c.items.autopeel.ExReadyItemAutoPeel;

public class RequestExReadyItemAutoPeel extends L2GameClientPacket {
    int nItemSid;

    @Override
    protected boolean readImpl() {
        nItemSid = readD();
        return true;
    }

    @Override
    protected void runImpl() {
        final Player player = getClient().getActiveChar();
        if (player == null) {
            return;
        }

        final ItemInstance item = player.getInventory().getItemByObjectId(nItemSid);
        if (item == null) {
            player.sendPacket(new ExReadyItemAutoPeel(false, nItemSid));
            return;
        }

        final IItemHandler handler = item.getItemType().getHandler();
        if (handler == null) {
            player.sendPacket(new ExReadyItemAutoPeel(false, nItemSid));
            return;
        }

        player.sendPacket(new ExReadyItemAutoPeel(true, nItemSid));
    }
}
