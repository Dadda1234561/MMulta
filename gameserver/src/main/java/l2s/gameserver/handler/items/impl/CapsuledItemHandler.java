package l2s.gameserver.handler.items.impl;

import java.util.Collections;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;

import l2s.commons.util.Rnd;
import l2s.gameserver.data.xml.holder.ItemHolder;
import l2s.gameserver.model.Playable;
import l2s.gameserver.model.Player;
import l2s.gameserver.model.items.ItemInstance;
import l2s.gameserver.network.l2.s2c.SystemMessagePacket;
import l2s.gameserver.templates.item.ItemTemplate;
import l2s.gameserver.templates.item.data.CapsuledItemData;
import l2s.gameserver.templates.item.data.CapsuledRewardType;
import l2s.gameserver.templates.item.data.ChancedItemData;
import l2s.gameserver.utils.ItemFunctions;

/**
 * @author Bonux
 */
public class CapsuledItemHandler extends DefaultItemHandler {

    @Override
    public boolean useItem(Playable playable, ItemInstance item, boolean ctrl) {
        Player player;
        if (playable.isPlayer())
            player = (Player) playable;
        else if (playable.isPet())
            player = playable.getPlayer();
        else
            return false;

        int itemId = item.getItemId();
        long totalCnt = item.getCount();

        if (!canBeExtracted(player, item))
            return false;

        long i = totalCnt;
        final Map<Integer, Long> receivedItems = new ConcurrentHashMap<>();
        for (; i > 0; i--) {

            if (!canBeExtracted(player, item)) {
                break;
            }

            for (Map.Entry<CapsuledRewardType, List<CapsuledItemData>> entry : item.getTemplate().getCapsuledItems().entrySet()) {
                if (entry.getKey().equals(CapsuledRewardType.CHANCE_RANDOM)) {
                    for (CapsuledItemData ci : entry.getValue()) {
                        if (Rnd.chance(ci.getChance())) {
                            long count;
                            long minCount = ci.getMinCount();
                            long maxCount = ci.getMaxCount();
                            if (minCount == maxCount)
                                count = minCount;
                            else
                                count = Rnd.get(minCount, maxCount);

                            ItemTemplate template = ItemHolder.getInstance().getTemplate(ci.getId());
                            if (template != null && template.isStackable()) {
                                long existingCount = receivedItems.getOrDefault(ci.getId(), 0L);
                                receivedItems.put(ci.getId(), existingCount + count);
                            } else {
                                ItemFunctions.addItem(player, ci.getId(), count, ci.getEnchantLevel(), true);
                            }

                        }
                    }
                }
                else if (entry.getKey().equals(CapsuledRewardType.WEIGHTED_RANDOM)) {
                    // calculate the total weight of all items
                    double totalWeight = entry.getValue().stream().mapToDouble(ChancedItemData::getChance).sum();

                    // randomly pick an item based on its probability
                    double randomValue = Rnd.nextDouble() * totalWeight;
                    double cumulativeWeight = 0.0;
                    CapsuledItemData selectedItem = null;
                    for (CapsuledItemData ci : entry.getValue()) {
                        cumulativeWeight += ci.getChance();
                        if (randomValue <= cumulativeWeight) {
                            selectedItem = ci;
                            break;
                        }
                    }

                    if (selectedItem == null) {
                        LOGGER.info("[CapsuledItemsHandler]: Did not manage to get an item from Item[ID=" + item.getItemId() + "]");
                    }
                    else {
                        long count = Rnd.get(selectedItem.getMinCount(), selectedItem.getMaxCount());
                        ItemTemplate template = ItemHolder.getInstance().getTemplate(selectedItem.getId());
                        if (template != null && template.isStackable()) {
                            long existingCount = receivedItems.getOrDefault(selectedItem.getId(), 0L);
                            receivedItems.put(selectedItem.getId(), existingCount + count);
                        }
                        else {
                            ItemFunctions.addItem(player, selectedItem.getId(), count, selectedItem.getEnchantLevel(), true);
                        }
                    }
                }
            }
        }

        if(ItemFunctions.deleteItem(player, itemId, (totalCnt - i), true)) {
            for (Map.Entry<Integer, Long> entry : receivedItems.entrySet()) {
                ItemFunctions.addItem(player, entry.getKey(), entry.getValue(), 0, true);
            }
        }
        return true;
    }

    @Override
    public Map<ItemInstance, Long> useItem(Playable playable, ItemInstance item) {
        Player player;
        if (playable.isPlayer())
            player = (Player) playable;
        else if (playable.isPet())
            player = playable.getPlayer();
        else
            return Collections.emptyMap();

        int itemId = item.getItemId();

        if (!canBeExtracted(player, item))
            return Collections.emptyMap();

        if (!reduceItem(player, item))
            return Collections.emptyMap();

        //sendUseMessage(player, item); На оффе не посылается.

        final Map<ItemInstance, Long> receivedItems = new HashMap<>();
        for (Map.Entry<CapsuledRewardType, List<CapsuledItemData>> entry : item.getTemplate().getCapsuledItems().entrySet())
        {
            if (entry.getKey().equals(CapsuledRewardType.CHANCE_RANDOM))
            {
                for (CapsuledItemData ci : entry.getValue())
                {
                    if (Rnd.chance(ci.getChance()))
                    {
                        long count;
                        long minCount = ci.getMinCount();
                        long maxCount = ci.getMaxCount();
                        if (minCount == maxCount)
                            count = minCount;
                        else
                            count = Rnd.get(minCount, maxCount);

                        receivedItems.put(player.getInventory().addItem(ci.getId(), count, ci.getEnchantLevel()), count);
                        player.sendPacket(SystemMessagePacket.obtainItems(ci.getId(), count, ci.getEnchantLevel()));
                    }
                }
            }
            else if (entry.getKey().equals(CapsuledRewardType.WEIGHTED_RANDOM))
            {
                // calculate the total weight of all items
                double totalWeight = entry.getValue().stream().mapToDouble(ChancedItemData::getChance).sum();

                // randomly pick an item based on its probability
                double randomValue = Rnd.nextDouble() * totalWeight;
                double cumulativeWeight = 0.0;
                CapsuledItemData selectedItem = null;
                for (CapsuledItemData ci : entry.getValue())
                {
                    cumulativeWeight += ci.getChance();
                    if (randomValue <= cumulativeWeight) {
                        selectedItem = ci;
                        break;
                    }
                }

                if (selectedItem == null)
                {
                    LOGGER.info("[CapsuledItemsHandler]: Did not manage to get an item from Item[ID=" + item.getItemId() + "]");
                    player.sendPacket(SystemMessagePacket.removeItems(itemId, 1));
                    return Collections.emptyMap();
                }
                else
                {
                    long count = Rnd.get(selectedItem.getMinCount(), selectedItem.getMaxCount());
                    receivedItems.put(player.getInventory().addItem(selectedItem.getId(), count, selectedItem.getEnchantLevel()), count);
                    player.sendPacket(SystemMessagePacket.obtainItems(selectedItem.getId(), count, selectedItem.getEnchantLevel()));
                }
            }
        }

        player.sendPacket(SystemMessagePacket.removeItems(itemId, 1));
        return receivedItems;
    }
}
