package l2s.gameserver.network.l2.c2s.homunculus;

import l2s.gameserver.model.Player;
import l2s.gameserver.network.l2.c2s.L2GameClientPacket;
import l2s.gameserver.network.l2.s2c.homunculus.ExHomunculusCreateProbList;

/**
 * @author sharp on 09.12.2022
 * t.me/sharp1que
 */
public class RequestExHomunculusProbList extends L2GameClientPacket {
    private int _type;
    private int _slotItemId;
    @Override
    protected boolean readImpl() throws Exception {
        _type = readC();
        _slotItemId = readD();
        return true;
    }

    @Override
    protected void runImpl() throws Exception {
        final Player player = getClient().getActiveChar();
        if (player == null) {
            return;
        }

        System.out.println(_type + " " + _slotItemId);
        player.sendPacket(new ExHomunculusCreateProbList());
    }
}
