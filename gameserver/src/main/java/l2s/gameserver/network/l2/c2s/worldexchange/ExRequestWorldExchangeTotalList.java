package l2s.gameserver.network.l2.c2s.worldexchange;

import l2s.gameserver.dao.WorldExchangeManager;
import l2s.gameserver.model.Player;
import l2s.gameserver.network.l2.c2s.L2GameClientPacket;
import l2s.gameserver.network.l2.s2c.worldexchange.ExWorldExchangeTotalList;

import java.util.Set;
import java.util.concurrent.ConcurrentHashMap;

public class ExRequestWorldExchangeTotalList extends L2GameClientPacket {
    final Set<Integer> itemIds = ConcurrentHashMap.newKeySet();

    @Override
    public boolean readImpl() {
        final int itemSize = readD();
        for (int i = 0; i < itemSize; i++) {
            itemIds.add(readD());
        }
        return true;
    }

    @Override
    public void runImpl() throws Exception {
        final Player player = getClient().getActiveChar();
        if (player == null) {
            return;
        }

        player.sendPacket(new ExWorldExchangeTotalList(WorldExchangeManager.getInstance().getTotalInfo(player, itemIds)));
    }
}
