package l2s.gameserver.network.l2.s2c.homunculus;

import l2s.gameserver.network.l2.s2c.L2GameServerPacket;

public class ExHomunculusActivateSlotResult extends L2GameServerPacket {

    private final int result;

    public ExHomunculusActivateSlotResult(int result) {
        this.result = result;
    }

    @Override
    protected void writeImpl() {
        writeD(result);
    }
}
