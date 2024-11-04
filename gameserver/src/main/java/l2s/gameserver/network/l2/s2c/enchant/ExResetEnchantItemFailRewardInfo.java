package l2s.gameserver.network.l2.s2c.enchant;

import l2s.gameserver.data.xml.holder.ItemHolder;
import l2s.gameserver.model.EnchantFailInfo;
import l2s.gameserver.model.items.ItemInstance;
import l2s.gameserver.network.l2.s2c.L2GameServerPacket;
import l2s.gameserver.templates.item.ItemTemplate;

import java.util.ArrayList;
import java.util.List;

public class ExResetEnchantItemFailRewardInfo extends L2GameServerPacket
{
    private final ItemInstance _enchantedItem;
    final List<EnchantFailInfo> _failEnchantInfo;

    public ExResetEnchantItemFailRewardInfo(ItemInstance enchantedItem, List<EnchantFailInfo> failEnchantInfo)
    {
        _enchantedItem = enchantedItem;
        _failEnchantInfo = failEnchantInfo;
    }

    @Override
    protected final void writeImpl()
    {
        writeD(_enchantedItem.getItemId()); // item id
        writeD(0); // enchant challenge point group id
        writeD(0); // enchant challenge points
        writeD(_failEnchantInfo.size());
        for (EnchantFailInfo info : _failEnchantInfo)
        {
            writeD(info.itemId());
            writeD(info.itemCount());
        }
    }
}