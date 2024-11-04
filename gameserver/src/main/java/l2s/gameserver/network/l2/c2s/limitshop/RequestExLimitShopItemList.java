package l2s.gameserver.network.l2.c2s.limitshop;

import l2s.gameserver.model.Player;
import l2s.gameserver.network.l2.c2s.L2GameClientPacket;

/**
 * @author sharp on 05.12.2022
 * t.me/sharp1que
 */
public class RequestExLimitShopItemList extends L2GameClientPacket {
    @Override
    protected boolean readImpl() throws Exception {
        return true;
    }

    @Override
    protected void runImpl() throws Exception {
        final Player player = getClient().getActiveChar();
        if (player == null) {
            return;
        }

        player.sendPacket();
    }
}
