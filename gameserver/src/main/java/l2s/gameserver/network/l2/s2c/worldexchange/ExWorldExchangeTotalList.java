package l2s.gameserver.network.l2.s2c.worldexchange;

import l2s.gameserver.network.l2.s2c.L2GameServerPacket;
import l2s.gameserver.templates.StatsSet;

import java.util.Set;

public class ExWorldExchangeTotalList extends L2GameServerPacket {

    final Set<StatsSet> _totalList;

    public ExWorldExchangeTotalList(Set<StatsSet> totalList) {
        _totalList = totalList;
    }

    @Override
    public void writeImpl()
    {
        writeD(_totalList.size()); // nSize
        for (final StatsSet info : _totalList) {
            writeD(info.getInteger("itemId", 0)); // nItemClassID
            writeQ(info.getLong("minPricePerPiece", 1L)); // nMinPricePerPiece
            writeQ(info.getLong("nPrice", 1L)); // nPrice
            writeQ(info.getLong("nAmount", 1L)); // nAmount
        }

    }
}
