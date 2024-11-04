package l2s.gameserver.network.l2.c2s.costume;

import l2s.gameserver.model.Player;
import l2s.gameserver.network.l2.c2s.L2GameClientPacket;

public class RequestExCostumeCollectionSkillActive extends L2GameClientPacket {
    private int nCostumeCollectionId;
    @Override
    protected boolean readImpl() throws Exception {
        System.out.println(getClass().getSimpleName() + ": has " + _buf.remaining() + " bytes.");
        nCostumeCollectionId = readD();
        return true;
    }

    @Override
    protected void runImpl() throws Exception {
        Player activeChar = getClient().getActiveChar();
        if (activeChar == null) {
            return;
        }

        System.out.println(getClass().getSimpleName() + ": nCostumeCollectionId=" + nCostumeCollectionId);
    }
}
