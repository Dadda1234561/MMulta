package l2s.gameserver.network.l2.s2c.worldexchange;

import l2s.gameserver.network.l2.s2c.L2GameServerPacket;

public class ExWorldExchangeAveragePrice extends L2GameServerPacket {

    final int itemId;
    final long avgPrice;

    public ExWorldExchangeAveragePrice(int itemId, long avgPrice) {
        this.itemId = itemId;
        this.avgPrice = avgPrice;
    }

    @Override
    public void writeImpl() {

        writeD(itemId); // nItemID
        writeQ(avgPrice); // nAveragePrice

    }
}
