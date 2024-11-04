package l2s.gameserver.network.l2.c2s.items.autopeel;


import l2s.gameserver.handler.items.IItemHandler;
import l2s.gameserver.model.Player;
import l2s.gameserver.model.items.ItemInstance;
import l2s.gameserver.network.l2.c2s.L2GameClientPacket;
import l2s.gameserver.network.l2.s2c.items.autopeel.ExResultItemAutoPeel;


import java.util.Map;
import java.util.logging.Logger;

public class RequestExItemAutoPeel extends L2GameClientPacket
{
    private static final Logger LOGGER = Logger.getLogger(RequestExItemAutoPeel.class.getName());

    int nItemSid;
    long nTotalPeelCount;
    long nRemainPeelCount;

    @Override
    public boolean readImpl()
    {
        nItemSid = readD();
        nTotalPeelCount = readQ();
        nRemainPeelCount = readQ();
        return true;
    }

    @Override
    protected void runImpl()
    {
        final Player player = getClient().getActiveChar();
        if (player == null)
        {
            return;
        }

        final ItemInstance item = player.getInventory().getItemByObjectId(nItemSid);
        if (item == null)
        {
            player.sendPacket(new ExResultItemAutoPeel(false, 0, 0, null));
            return;
        }

        if (nTotalPeelCount < 0 || nRemainPeelCount < 0)
        {
            player.sendPacket(new ExResultItemAutoPeel(false, 0, 0, null));
            return;
        }

        final IItemHandler handler = item.getItemType().getHandler();
        if (handler == null)
        {
            LOGGER.warning("No handler is defined for item " + item.getItemId() + " for " + player.getName());
            player.sendPacket(new ExResultItemAutoPeel(false, 0, 0, null));
            return;
        }

        final Map<ItemInstance, Long> extractedItems = handler.useItem(player, item);
        if (extractedItems == null)
        {
            LOGGER.warning("Error happened while extracting " + item.getName() + " for " + player.getName());
            player.sendPacket(new ExResultItemAutoPeel(false, 0, 0, null));
            return;
        }

        player.sendPacket(new ExResultItemAutoPeel(true, nTotalPeelCount, --nRemainPeelCount, extractedItems));
    }
}
