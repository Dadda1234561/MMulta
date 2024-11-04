package l2s.gameserver.network.l2.s2c.costume;

import l2s.gameserver.network.l2.s2c.L2GameServerPacket;

public class ExCostumeUseItem extends L2GameServerPacket {

    final boolean success;
    final int costumeId;

    public ExCostumeUseItem(boolean success, int costumeId) {
        this.success = success;
        this.costumeId = costumeId;
    }

    @Override
    protected void writeImpl() {
        writeC(success); // bIsSuccess
        writeD(costumeId); // nCostumeId
    }
}
