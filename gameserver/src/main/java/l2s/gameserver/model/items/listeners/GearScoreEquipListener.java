package l2s.gameserver.model.items.listeners;

import l2s.gameserver.listener.actor.player.OnEnchantItemListener;
import l2s.gameserver.listener.inventory.OnEquipListener;
import l2s.gameserver.model.Playable;
import l2s.gameserver.model.Player;
import l2s.gameserver.model.items.Inventory;
import l2s.gameserver.model.items.ItemInstance;
import l2s.gameserver.templates.item.ItemTemplate;

public class GearScoreEquipListener implements OnEquipListener {
    private static final GearScoreEquipListener INSTANCE = new GearScoreEquipListener();

    public static GearScoreEquipListener getInstance() {
        return INSTANCE;
    }

    @Override
    public int onEquip(int slot, ItemInstance item, Playable actor) {
        int score = 0;
        if (item == null) return 0;
        if (!actor.isPlayer()) return 0;

        int flags = 0;
        if (item.getOwnerId() != actor.getObjectId()) return 0;
        ItemTemplate template = item.getTemplate();
        if (template == null || template.hasNoGearScore()) {
            return 0;
        }
        score = actor.getPlayer().getGearScore().getPoints();
        actor.getPlayer().refreshGearScore(false, false);
        if (score != actor.getPlayer().getGearScore().getPoints()) flags |= Inventory.UPDATE_GEAR_SCORE_FLAG;
        return flags;
    }

    @Override
    public int onUnequip(int slot, ItemInstance item, Playable actor) {
        return this.onEquip(slot, item, actor);
    }

    @Override
    public int onRefreshEquip(ItemInstance item, Playable actor) {
        return this.onEquip(item.getEquipSlot(), item, actor);
    }

    private class EnchantListener implements OnEnchantItemListener {

        @Override
        public void onEnchantItem(Player player, ItemInstance item, boolean success) {
            if (item == null) return;
            if (!player.isPlayer()) return;

            player.refreshGearScore(false, false);
        }
    }
}
