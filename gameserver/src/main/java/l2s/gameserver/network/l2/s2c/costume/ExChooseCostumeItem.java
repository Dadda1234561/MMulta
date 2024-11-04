package l2s.gameserver.network.l2.s2c.costume;

import l2s.gameserver.network.l2.s2c.L2GameServerPacket;

public class ExChooseCostumeItem extends L2GameServerPacket {
    private final int nItemClassID;

    public ExChooseCostumeItem(int nItemClassID) {
        this.nItemClassID = nItemClassID;
    }

    @Override
    protected void writeImpl() {
        writeD(nItemClassID);
    }
}
