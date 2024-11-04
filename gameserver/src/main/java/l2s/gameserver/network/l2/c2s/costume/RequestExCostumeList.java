package l2s.gameserver.network.l2.c2s.costume;

import l2s.gameserver.model.Player;
import l2s.gameserver.network.l2.c2s.L2GameClientPacket;

public class RequestExCostumeList extends L2GameClientPacket {

    private int nType;

    @Override
    protected boolean readImpl() throws Exception {
        nType = readD();
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
