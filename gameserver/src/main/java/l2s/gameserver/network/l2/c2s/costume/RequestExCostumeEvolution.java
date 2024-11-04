package l2s.gameserver.network.l2.c2s.costume;

import gnu.trove.map.hash.TIntLongHashMap;
import l2s.gameserver.model.Player;
import l2s.gameserver.network.l2.c2s.L2GameClientPacket;

public class RequestExCostumeEvolution extends L2GameClientPacket {

    private final TIntLongHashMap targetList = new TIntLongHashMap();
    private final TIntLongHashMap materialList = new TIntLongHashMap();

    @Override
    protected boolean readImpl() throws Exception {
        System.out.println(getClass().getSimpleName() + ": has " + _buf.remaining() + " bytes.");

        for (int i = 0; i < readD(); i++) {
            targetList.put(readD(), readQ());
        }
        for (int i = 0; i < readD(); i++) {
            materialList.put(readD(), readQ());
        }
        return true;
    }

    @Override
    protected void runImpl() throws Exception {
        Player activeChar = getClient().getActiveChar();
        if (activeChar == null) {
            return;
        }

        System.out.println(getClass().getSimpleName() + ": parsed " + targetList.size() + " targets and " + materialList.size() + " materials.");
    }
}
