package handler.items;

import l2s.gameserver.Config;
import l2s.gameserver.data.xml.holder.SkillAcquireHolder;
import l2s.gameserver.model.Player;
import l2s.gameserver.model.items.ItemInstance;
import l2s.gameserver.network.l2.s2c.UIPacket;

/**
 * @author sharp on 03.02.2023
 * t.me/sharp1que
 */
public class AbilityPoint extends SimpleItemHandler
{
    @Override
    protected boolean useItemImpl(Player player, ItemInstance item, boolean ctrl)
    {
        final int currentPoints = player.getAvailableAbilityPoints();
        final int maxAbilitiesPoints = SkillAcquireHolder.getInstance().getMaxAbilitiesPoints();

        if (player.getLevel() < SkillAcquireHolder.getInstance().getAbilitiesMinLevel())
        {
            player.sendMessage(String.format("Необходим %d уровень.", SkillAcquireHolder.getInstance().getAbilitiesMinLevel()));
            player.sendActionFailed();
            return false;
        }

        if (currentPoints == maxAbilitiesPoints)
        {
            player.sendMessage(String.format("Достигнут лимит: %d очков.", SkillAcquireHolder.getInstance().getMaxAbilitiesPoints()));
            player.sendActionFailed();
            return false;
        }

        if(!reduceItem(player, item))
            return false;

        if (currentPoints < maxAbilitiesPoints)
        {
            player.setVar("AVAILABLE_ABILITY_POINTS", (currentPoints + 1));
            sendUseMessage(player, item);
            player.broadcastCharInfo();
        }
        return false;
    }
}
