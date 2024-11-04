package l2s.gameserver.network.l2.s2c.costume;

import l2s.gameserver.model.costume.CostumeInfo;
import l2s.gameserver.model.costume.ShortcutInfo;
import l2s.gameserver.network.l2.s2c.L2GameServerPacket;

import java.util.Collections;
import java.util.List;

public class ExSendCostumeListFull extends L2GameServerPacket {
    private final List<CostumeInfo> costumeList;
    private final List<ShortcutInfo> shortcutList;

    private int collectionId = 0;
    private int reuseTime = 0;

    public ExSendCostumeListFull() {
        this.costumeList = Collections.emptyList();
        this.shortcutList = Collections.emptyList();
    }

    public ExSendCostumeListFull(List<CostumeInfo> costumeList, List<ShortcutInfo> shortcutList) {
        this.costumeList = costumeList;
        this.shortcutList = shortcutList;
    }

    public ExSendCostumeListFull(List<CostumeInfo> costumeList, List<ShortcutInfo> shortcutList, int collectionId, int reuseTime) {
        this.costumeList = costumeList;
        this.shortcutList = shortcutList;
        this.collectionId = collectionId;
        this.reuseTime = reuseTime;
    }

    @Override
    protected void writeImpl() {

        writeD(costumeList.size()); // vCostumeList nSize
        for (CostumeInfo info : costumeList) {
            writeD(info.getCostumeId());
            writeQ(info.getAmount());
            writeC(1);
            writeC(1);
        }

        writeD(shortcutList.size()); // vShortcutList nSize
        for (ShortcutInfo info : shortcutList) {
            writeD(info.getPage());
            writeD(info.getSlotIndex());
            writeD(info.getCostumeId());
            writeC(info.isAutoUse());
        }

        writeD(1); // nCostumeCollectionId
        writeD(-1); // nCostumeCollectionReuseCooltime
    }
}
