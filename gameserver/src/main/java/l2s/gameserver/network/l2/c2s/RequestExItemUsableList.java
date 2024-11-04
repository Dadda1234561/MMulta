package l2s.gameserver.network.l2.c2s;

import l2s.gameserver.model.Player;

/**
 * @author sharp on 07.12.2022
 * t.me/sharp1que
 */
public class RequestExItemUsableList extends L2GameClientPacket{
    @Override
    protected boolean readImpl() throws Exception {
        readC(); // dummy
        return true;
    }

    @Override
    protected void runImpl() throws Exception {
        final Player player = getClient().getActiveChar();
        if (player == null) {
            return;
        }

        player.sendItemList(false);
    }
}
