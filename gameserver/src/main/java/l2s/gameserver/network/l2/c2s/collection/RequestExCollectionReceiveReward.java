package l2s.gameserver.network.l2.c2s.collection;

import l2s.gameserver.model.Player;
import l2s.gameserver.network.l2.c2s.L2GameClientPacket;

/**
 * @author sharp
 * t.me/sharp1que
 */
public class RequestExCollectionReceiveReward extends L2GameClientPacket {
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
    }
}
