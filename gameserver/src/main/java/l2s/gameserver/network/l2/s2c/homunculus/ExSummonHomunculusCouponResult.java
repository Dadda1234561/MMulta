package l2s.gameserver.network.l2.s2c.homunculus;

import l2s.gameserver.network.l2.s2c.L2GameServerPacket;

public class ExSummonHomunculusCouponResult extends L2GameServerPacket {
    private final int type;
    private final int index;

    public ExSummonHomunculusCouponResult(int type, int nIdx) {
        this.type = type;
        this.index = nIdx;
    }

    @Override
    protected void writeImpl() {
        writeD(type);
        writeD(index);
    }
}
