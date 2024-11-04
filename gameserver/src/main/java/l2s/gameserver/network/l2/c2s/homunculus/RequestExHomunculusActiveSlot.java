package l2s.gameserver.network.l2.c2s.homunculus;

import l2s.gameserver.model.Player;
import l2s.gameserver.network.l2.c2s.L2GameClientPacket;
import l2s.gameserver.network.l2.s2c.homunculus.ExHomunculusActivateSlotResult;


public class RequestExHomunculusActiveSlot extends L2GameClientPacket {

    private int slotIndex;

    @Override
    protected boolean readImpl() throws Exception {
        slotIndex = readD();
        return true;
    }

    @Override
    protected void runImpl() throws Exception {
        Player activeChar = getClient().getActiveChar();
        if (activeChar == null) {
            return;
        }

        System.out.println(getClass().getSimpleName() + ": slotIndex=" + slotIndex);
        activeChar.sendPacket(new ExHomunculusActivateSlotResult(1));
    }
}
