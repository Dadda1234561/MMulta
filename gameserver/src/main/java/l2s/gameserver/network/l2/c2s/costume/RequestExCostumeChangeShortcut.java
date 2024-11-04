package l2s.gameserver.network.l2.c2s.costume;

import l2s.gameserver.model.costume.ShortcutInfo;
import l2s.gameserver.model.Player;
import l2s.gameserver.network.l2.c2s.L2GameClientPacket;

import java.util.ArrayList;
import java.util.List;

public class RequestExCostumeChangeShortcut extends L2GameClientPacket {
    final List<ShortcutInfo> changeList = new ArrayList<>();

    @Override
    protected boolean readImpl() throws Exception {
        System.out.println(getClass().getSimpleName() + ": has " + _buf.remaining() + " bytes.");
        for (int i = 0; i < readD(); i++) {
            changeList.add(new ShortcutInfo(readD(), readD(), readD(), readC() == 1));
        }
        return true;
    }

    @Override
    protected void runImpl() throws Exception {
        Player activeChar = getClient().getActiveChar();
        if (activeChar == null) {
            return;
        }
    }
}
