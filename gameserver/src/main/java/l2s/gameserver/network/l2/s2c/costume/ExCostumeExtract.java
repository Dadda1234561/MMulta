package l2s.gameserver.network.l2.s2c.costume;

import l2s.gameserver.network.l2.s2c.L2GameServerPacket;

public class ExCostumeExtract extends L2GameServerPacket {

    private final boolean bResult;
    private final int nExtractCostumeId;
    private final long nExtractCostumeAmount;
    private final int nResultItemClassId;
    private final long nResultAmount;

    private final long nTotalAmount;

    public ExCostumeExtract(boolean bResult, int nExtractCostumeId, long nExtractCostumeAmount, int nResultItemClassId, long nResultAmount, long nTotalAmount) {
        this.bResult = bResult;
        this.nExtractCostumeId = nExtractCostumeId;
        this.nExtractCostumeAmount = nExtractCostumeAmount;
        this.nResultItemClassId = nResultItemClassId;
        this.nResultAmount = nResultAmount;
        this.nTotalAmount = nTotalAmount;
    }

    @Override
    protected void writeImpl() {
        writeC(bResult);
        writeD(nExtractCostumeId);
        writeQ(nExtractCostumeAmount);
        writeD(nResultItemClassId);
        writeQ(nResultAmount);
        writeQ(nTotalAmount);
    }
}
