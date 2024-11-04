package l2s.gameserver.network.l2.c2s;

import l2s.gameserver.model.Player;
import l2s.gameserver.network.l2.s2c.ExRaidTeleportInfo;

/**
 * @author sharp on 09.12.2022
 * t.me/sharp1que
 */
public class RequestExRaidTeleportInfo extends L2GameClientPacket{
    @Override
    protected boolean readImpl() throws Exception {
        readC(); //
        return true;
    }

    @Override
    protected void runImpl() throws Exception {
        final Player player = getClient().getActiveChar();
        if (player == null) {
            return;
        }

        player.sendPacket(new ExRaidTeleportInfo());
    }
}
