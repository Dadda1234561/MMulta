package l2s.gameserver.network.l2.s2c.items.autopeel;

import l2s.gameserver.model.items.ItemInstance;
import l2s.gameserver.network.l2.s2c.L2GameServerPacket;

import java.util.Map;

import static java.util.Objects.isNull;
import static java.util.Objects.nonNull;

public class ExResultItemAutoPeel extends L2GameServerPacket
{
    final boolean bResult;
    final long nTotalPeelCount;
    long nRemainPeelCount;
    final Map<ItemInstance, Long> vResultItemList;

    public ExResultItemAutoPeel(boolean bResult, long nTotalPeelCount, long nRemainPeelCount, Map<ItemInstance, Long> vResultItemList)
    {
        this.bResult = bResult;
        this.nTotalPeelCount = nTotalPeelCount;
        this.nRemainPeelCount = nRemainPeelCount;
        this.vResultItemList = vResultItemList;
    }

    @Override
    protected final void writeImpl()
    {
       writeC(bResult ? 1 : 0);

       writeQ(nTotalPeelCount);
       writeQ(nRemainPeelCount);

        writeD(isNull(vResultItemList) ? 0 : vResultItemList.size());
        if (nonNull(vResultItemList))
        {
            for (ItemInstance item : vResultItemList.keySet())
            {
                writeD(item.getItemId());
                writeQ(vResultItemList.get(item));
                writeD(0); // AnnounceLevel, isRare = 4
            }
        }
    }
}
