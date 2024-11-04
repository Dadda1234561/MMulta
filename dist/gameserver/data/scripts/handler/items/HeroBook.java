package handler.items;

import l2s.gameserver.model.Playable;
import l2s.gameserver.model.items.ItemInstance;
import l2s.gameserver.network.l2.components.SystemMsg;
import l2s.gameserver.network.l2.s2c.SystemMessagePacket;
import l2s.gameserver.network.l2.s2c.herobook.ExHeroBookShowUI;

public class HeroBook extends ScriptItemHandler
{

    @Override
    public boolean useItem(Playable playable, ItemInstance item, boolean forceUse)
    {
        if (!playable.isPlayer())
        {
            playable.sendPacket(new SystemMessagePacket(SystemMsg.YOUR_PET_CANNOT_CARRY_THIS_ITEM));
            return false;
        }

        playable.sendPacket(new ExHeroBookShowUI());
        return true;
    }
}