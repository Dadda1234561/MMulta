package l2s.gameserver.network.l2.s2c.events.balrog;

import l2s.gameserver.network.l2.s2c.L2GameServerPacket;

public class ExBalrogwarGetReward extends L2GameServerPacket {

    private final boolean bIsSuccess;

    public ExBalrogwarGetReward(boolean bIsSuccess) {
        this.bIsSuccess = bIsSuccess;
    }

    @Override
    protected void writeImpl() {
        writeC(bIsSuccess);
    }
}
