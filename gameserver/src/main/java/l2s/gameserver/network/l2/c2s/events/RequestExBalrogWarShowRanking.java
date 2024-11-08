package l2s.gameserver.network.l2.c2s.events;

import l2s.gameserver.model.Player;
import l2s.gameserver.network.l2.c2s.L2GameClientPacket;
import l2s.gameserver.network.l2.s2c.events.balrog.ExBalrogwarShowRanking;

public class RequestExBalrogWarShowRanking extends L2GameClientPacket {
    @Override
    protected boolean readImpl() throws Exception {
        return true;
    }

    @Override
    protected void runImpl() throws Exception {
        Player player = getClient().getActiveChar();
        if (player == null) {
            return;
        }

        player.sendPacket(new ExBalrogwarShowRanking());
    }
}
