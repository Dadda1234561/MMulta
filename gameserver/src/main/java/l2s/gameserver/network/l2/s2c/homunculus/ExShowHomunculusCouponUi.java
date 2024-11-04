package l2s.gameserver.network.l2.s2c.homunculus;

import l2s.gameserver.network.l2.s2c.L2GameServerPacket;

public class ExShowHomunculusCouponUi extends L2GameServerPacket {

    public static ExShowHomunculusCouponUi STATIC_PACKET = new ExShowHomunculusCouponUi();

    @Override
    protected void writeImpl() {
        writeC(0x00);
    }
}
