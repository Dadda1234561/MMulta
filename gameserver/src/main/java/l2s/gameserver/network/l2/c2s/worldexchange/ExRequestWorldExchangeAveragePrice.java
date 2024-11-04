package l2s.gameserver.network.l2.c2s.worldexchange;

import l2s.gameserver.dao.WorldExchangeManager;
import l2s.gameserver.model.Player;
import l2s.gameserver.network.l2.c2s.L2GameClientPacket;
import l2s.gameserver.network.l2.s2c.worldexchange.ExWorldExchangeAveragePrice;

public class ExRequestWorldExchangeAveragePrice extends L2GameClientPacket {

    private int itemId;

    @Override
    public boolean readImpl() {
        itemId = readD();
        return true;
    }

    @Override
    public void runImpl() throws Exception {
        final Player player = getClient().getActiveChar();
        if (player == null) {
            return;
        }


        final long averageItemPrice = WorldExchangeManager.getInstance().getAverageItemPrice(itemId);
        if (averageItemPrice >= 0) {
            player.sendPacket(new ExWorldExchangeAveragePrice(itemId, averageItemPrice));
        }
    }
}
