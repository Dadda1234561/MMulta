package l2s.gameserver.network.l2.s2c.worldexchange;

import l2s.gameserver.network.l2.s2c.L2GameServerPacket;

public class ExWorldExchangeSellCompleteAlarm extends L2GameServerPacket {
    private final int _itemID;
    private final long _amount;

    public ExWorldExchangeSellCompleteAlarm(int itemID, long amount) {
        _itemID = itemID;
        _amount = amount;
    }

    @Override
    public void writeImpl() {
       writeD(_itemID); // nItemClassID
       writeQ(_amount); // qAmount
    }

}
