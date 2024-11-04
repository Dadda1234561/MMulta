package l2s.gameserver.network.l2.s2c.costume;

import l2s.gameserver.network.l2.s2c.L2GameServerPacket;

public class ExCostumeLock extends L2GameServerPacket {
    private final boolean bResult;
    private final int nCostumeId;
    private final int nLockState;

    public ExCostumeLock(boolean bResult, int nCostumeId, int nLockState) {
        this.bResult = bResult;
        this.nCostumeId = nCostumeId;
        this.nLockState = nLockState;
    }

    @Override
    protected void writeImpl() {
        writeC(bResult);
        writeD(nCostumeId);
        writeC(nLockState);
    }
}
