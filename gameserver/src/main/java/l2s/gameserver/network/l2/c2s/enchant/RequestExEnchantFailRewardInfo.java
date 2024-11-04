package l2s.gameserver.network.l2.c2s.enchant;

import l2s.commons.dao.JdbcEntityState;
import l2s.gameserver.data.xml.holder.EnchantItemHolder;
import l2s.gameserver.model.EnchantFailInfo;
import l2s.gameserver.model.Player;
import l2s.gameserver.model.items.ItemInstance;
import l2s.gameserver.network.l2.c2s.L2GameClientPacket;
import l2s.gameserver.network.l2.components.SystemMsg;
import l2s.gameserver.network.l2.s2c.InventoryUpdatePacket;
import l2s.gameserver.network.l2.s2c.MagicSkillUse;
import l2s.gameserver.network.l2.s2c.enchant.EnchantResult;
import l2s.gameserver.network.l2.s2c.enchant.ExResetEnchantItemFailRewardInfo;
import l2s.gameserver.templates.item.support.EnchantScroll;
import l2s.gameserver.templates.item.support.EnchantStone;
import l2s.gameserver.templates.item.support.FailResultType;
import l2s.gameserver.utils.ItemFunctions;
import l2s.gameserver.utils.Log;

import java.util.ArrayList;
import java.util.List;

public class RequestExEnchantFailRewardInfo extends L2GameClientPacket
{
    private int _itemObjId;

    @Override
    protected boolean readImpl()
    {
        _itemObjId = readD();
        return true;
    }

    @Override
    protected void runImpl()
    {
        final Player player = getClient().getActiveChar();
        if (player == null)
            return;

        if ((player.getEnchantItem() == null) || (player.getEnchantScroll() == null))
        {
            return;
        }

        final EnchantScroll enchantScroll = EnchantItemHolder.getInstance().getEnchantScroll(player.getEnchantScroll().getItemId());
        if (enchantScroll == null)
        {
            return;
        }

        final ItemInstance enchantItem = player.getInventory().getItemByObjectId(_itemObjId);
        if (enchantItem == null)
        {
            return;
        }

        final ItemInstance supportStone = player.getSupportItem();


        final EnchantStone stone;
        if (supportStone != null)
        {
            stone = ItemFunctions.getEnchantStone(enchantItem, supportStone);
        }
        else
        {
            stone = null;
        }

        FailResultType resultType = enchantScroll.getResultType();
        if (stone != null && stone.getResultType().ordinal() > resultType.ordinal())
        {
            resultType = stone.getResultType();
        }

        final List<EnchantFailInfo> failInfo = new ArrayList<>();

        switch (resultType)
        {
            case CRYSTALS:
                failInfo.add(new EnchantFailInfo(enchantItem.getGrade().getCrystalId(), enchantItem.getCrystalCountOnEchant()));
                break;
            case DROP_ENCHANT:
            {
                failInfo.add(new EnchantFailInfo(enchantItem.getItemId(), 1));
                break;
            }
            default:
                break;
        }

        player.sendPacket(new ExResetEnchantItemFailRewardInfo(enchantItem, failInfo));
    }
}