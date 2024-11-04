package l2s.gameserver.network.l2.s2c.costume;

import l2s.gameserver.model.costume.ShortcutInfo;
import l2s.gameserver.network.l2.s2c.L2GameServerPacket;

import java.util.List;

public class ExCostumeShortcutList extends L2GameServerPacket {
    private final boolean bResult;
    private final List<ShortcutInfo> shortcutInfos;

    public ExCostumeShortcutList(boolean bResult, List<ShortcutInfo> shortcutInfos) {
        this.bResult = bResult;
        this.shortcutInfos = shortcutInfos;
    }

    @Override
    protected void writeImpl() {
        writeC(bResult);
        writeD(shortcutInfos.size());
        for (ShortcutInfo info : shortcutInfos) {
            writeD(info.getPage());
            writeD(info.getSlotIndex());
            writeD(info.getCostumeId());
            writeC(info.isAutoUse());
        }
    }
}
