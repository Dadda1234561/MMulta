package l2s.gameserver.network.l2.c2s.costume;

import l2s.gameserver.model.Player;
import l2s.gameserver.network.l2.c2s.L2GameClientPacket;

public class RequestExCostumeExtract extends L2GameClientPacket {
    @Override
    protected boolean readImpl() throws Exception {
        System.out.println(getClass().getSimpleName() + ": has " + _buf.remaining() + " bytes.");

        // readH();
        // readD();
        // readQ();
        System.out.println(_buf.remaining());
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
