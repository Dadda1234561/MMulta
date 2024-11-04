package l2s.gameserver.network.l2.s2c.costume;

import gnu.trove.map.hash.TIntLongHashMap;
import l2s.gameserver.network.l2.s2c.L2GameServerPacket;

public class ExCostumeEvolution extends L2GameServerPacket {

    private final TIntLongHashMap targetList;
    private final TIntLongHashMap resultList;
    private final boolean bResult;


    public ExCostumeEvolution(boolean bResult, TIntLongHashMap targetList, TIntLongHashMap resultList) {
        this.bResult = bResult;
        this.targetList = targetList;
        this.resultList = resultList;
    }


    @Override
    protected void writeImpl() {
        writeC(bResult);
        writeD(targetList.size());
        targetList.forEachEntry((i, l) ->
        {
            writeD(i); // itemId
            writeQ(l); // itemCnt
            return true;
        });

        writeD(resultList.size());
        resultList.forEachEntry((i, l) ->
        {
            writeD(i); // itemId
            writeQ(l); // itemCnt
            return true;
        });
    }
}
