package handler.items;

import l2s.gameserver.model.Playable;
import l2s.gameserver.model.Player;
import l2s.gameserver.model.items.ItemInstance;
import l2s.gameserver.network.l2.s2c.ExShowVariationMakeWindow;

/**
 * @author sharp on 09.02.2023
 * t.me/sharp1que
 */
public class VariationStone extends ScriptItemHandler
{
    @Override
    public boolean useItem(Playable playable, ItemInstance item, boolean ctrl)
    {
        if (!playable.isPlayer()) {
            return false;
        }

        Player player = playable.getPlayer();
        if (player.isActionsDisabled() || player.isBlocked()) {
            return false;
        }

        player.sendPacket(new ExShowVariationMakeWindow());
        return true;
    }
}
