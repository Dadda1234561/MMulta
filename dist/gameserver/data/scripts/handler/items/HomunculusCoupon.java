package handler.items;

import l2s.gameserver.model.Player;
import l2s.gameserver.model.items.ItemInstance;
import l2s.gameserver.network.l2.s2c.homunculus.ExShowHomunculusCouponUi;

public class HomunculusCoupon extends SimpleItemHandler {
    @Override
    protected boolean useItemImpl(Player player, ItemInstance item, boolean ctrl) {
        if (player == null) {
            return false;
        }

//        if (!reduceItem(player, item)) {
//            return false;
//        }

        player.sendPacket(new ExShowHomunculusCouponUi());
        return true;
    }
}
