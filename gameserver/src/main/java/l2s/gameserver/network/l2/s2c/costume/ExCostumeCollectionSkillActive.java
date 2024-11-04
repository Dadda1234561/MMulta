package l2s.gameserver.network.l2.s2c.costume;

import l2s.gameserver.network.l2.s2c.L2GameServerPacket;

public class ExCostumeCollectionSkillActive extends L2GameServerPacket {
    private final int nCostumeCollectionId;
    private final int nCostumeCollectionReuseCooltime;

    public ExCostumeCollectionSkillActive(int collectionId, int reuseCoolTime) {
        this.nCostumeCollectionId = collectionId;
        this.nCostumeCollectionReuseCooltime = reuseCoolTime;
    }

    @Override
    protected void writeImpl() {
        writeD(nCostumeCollectionId);
        writeD(nCostumeCollectionReuseCooltime);
    }
}
