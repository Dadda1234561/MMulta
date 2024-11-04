package l2s.gameserver.handler.interfacecommands.impl;

import gnu.trove.map.hash.TIntLongHashMap;
import l2s.commons.dao.JdbcEntityState;
import l2s.gameserver.Config;
import l2s.gameserver.common.DifferentMethods;
import l2s.gameserver.data.xml.holder.ItemHolder;
import l2s.gameserver.handler.interfacecommands.IInterfaceCommandHandler;
import l2s.gameserver.model.Player;
import l2s.gameserver.model.actor.instances.player.VisualItemList;
import l2s.gameserver.model.items.Inventory;
import l2s.gameserver.model.items.ItemInstance;
import l2s.gameserver.network.l2.s2c.ExShowScreenMessage;
import l2s.gameserver.network.l2.s2c.ExUserInfoEquipSlot;
import l2s.gameserver.network.l2.s2c.InventoryUpdatePacket;
import l2s.gameserver.network.l2.s2c.UIPacket;
import l2s.gameserver.templates.item.ExItemType;
import l2s.gameserver.templates.item.ItemTemplate;
import l2s.gameserver.templates.item.data.ItemData;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

public class CostumePreviewCmd implements IInterfaceCommandHandler {

    private static final Logger _log = LoggerFactory.getLogger(CostumePreviewCmd.class);
    private static final String[] COMMANDS = {"costume_preview"};

    private enum ECostumeType {
        ECT_NONE,
        ECT_WEAPON,
        ECT_ARMOR,
        ECT_SHIELD,
        ECT_CLOAK
    }

    private ECostumeType getCostumeType(ItemInstance item) {
        return ECostumeType.ECT_NONE;
    }

    @Override
    public String[] getInterfaceCommandList() {
        return COMMANDS;
    }

    @Override
    public void useInterfaceCommand(String command, Player player) {
        VisualItemList visualItems = player.getVisualItems();
        if (command.startsWith("costume_preview")) {
            String cmd = command.split(" ")[1];
            switch (cmd) {
                case "list":
                    visualItems.sendAvailableItems();
                    break;
                case "reset":
                    resetItems(player);
                    break;
                case "remove":
                    removeItem(command, player);
                    break;
                case "set":
                    setItem(command, player);
                    break;
                case "buy":
                    buyItem(command, player);
                    break;
                case "wear":
                    wearItem(command, player);
                    break;
            }
        }
    }

    private void wearItem(String command, Player player) {
        int costumeId = 0;
        try {
            costumeId = Integer.parseInt(command.split(" ")[2]);
        } catch (Exception e) {
            _log.info(String.format("[%s]: Error happened while parsing costume id : %s", getClass().getSimpleName(), e.getMessage()));
            e.printStackTrace();
        }
        ItemTemplate template = ItemHolder.getInstance().getTemplate(costumeId);
        if (template == null) {
            _log.info("Player " + player.getName() + " trying to wear visual [" + costumeId + "] which is not available!");
            return;
        }
        if (!template.isEquipable()) {
            _log.info("Player " + player.getName() + " trying to wear visual [" + template.getName() + "]" + "[" + template.getItemId() + "] which is not equipable!");
            return;
        }
        int slot = Inventory.getPaperdollIndex(template.getBodyPart());
        if (slot == -1) {
            _log.info("Player " + player.getName() + " trying to wear visual [" + template.getName() + "]" + "[" + template.getItemId() + "] with wrong bodypart: " + template.getBodyPart());
            return;
        }
        player.getVisualItems().startVisualTask(slot, costumeId);
    }

    private void buyItem(String command, Player player) {
        int costumeId = 0;
        try {
            costumeId = Integer.parseInt(command.split(" ")[2]);
        } catch (Exception e) {
            _log.info(String.format("[%s]: Error happened while parsing costume id : %s", getClass().getSimpleName(), e.getMessage()));
            e.printStackTrace();
        }

        // check if valid item
        ItemTemplate template = ItemHolder.getInstance().getTemplate(costumeId);
        if (template == null) {
            _log.info("Player " + player.getName() + " trying to buy visual [" + costumeId + "] which is not available!");
            return;
        }

        // check if already bought
        if (player.getVisualItems().contains(costumeId)) {
            player.sendPacket(new ExShowScreenMessage("You already have this visual item.", 3000, ExShowScreenMessage.ScreenMessageAlign.BOTTOM_RIGHT, true));
            _log.info("Player " + player.getName() + " trying to buy visual [" + template.getName() + "]" + "[" + template.getItemId() + "] which he already has!");
            return;
        }

        final ItemData paymentInfo = Config.COSTUME_PRICES.get(costumeId);
        if (paymentInfo == null) {
            _log.info("Payment info not found for costume id = " + costumeId);
            return;
        }

        // get payment then
        if (!DifferentMethods.getPay(player, paymentInfo.getId(), paymentInfo.getCount(), true)) {
            return;
        }

        // save costume
        player.getVisualItems().addVisualItem(costumeId, true);
        // send new list
        player.getVisualItems().sendAvailableItems();

        ItemInstance item = null;
        if (template.isWeapon()) {
            // shield
            if (template.getBodyPart() == ItemTemplate.SLOT_L_HAND) {
                item = player.getInventory().getPaperdollItem(Inventory.PAPERDOLL_LHAND);
            } else {
                item = player.getActiveWeaponInstance();
            }
        } else if (template.isArmor()) {
            if (ExItemType.FULL_BODY.equals(template.getExType())) {
                item = player.getInventory().getPaperdollItem(Inventory.PAPERDOLL_CHEST);
            } else if (ExItemType.SIGIL.equals(template.getExType()) || ExItemType.SHIELD.equals(template.getExType())) {
                item = player.getInventory().getPaperdollItem(Inventory.PAPERDOLL_LHAND);
            } else if (ExItemType.CLOAK.equals(template.getExType())) {
                item = player.getInventory().getPaperdollItem(Inventory.PAPERDOLL_BACK);
            }
        }

        if (item == null) {
            player.sendPacket(new ExShowScreenMessage("Required item is not found!", 3000, ExShowScreenMessage.ScreenMessageAlign.BOTTOM_RIGHT, true));
            return;
        }

        setItemVisualID(player, costumeId, item);
        player.sendPacket(new ExShowScreenMessage(String.format("%s is now applied!", DifferentMethods.getItemName(costumeId)), 3000, ExShowScreenMessage.ScreenMessageAlign.BOTTOM_RIGHT, true));
    }

    private void resetItems(Player player) {
        // reset all visual items
        for (int i = 0; i < Inventory.PAPERDOLL_MAX; i++) {
            player.getVisualItems().stopVisualTask(i);
            player.getInventory().setPaperdollVisualId(i, 0);
        }
        // broadcast info
        player.sendPacket(new ExUserInfoEquipSlot(player));
        player.sendPacket(new UIPacket(player));
    }

    private boolean isValidCostumeType(ItemTemplate costumeItem, ItemInstance targetItem) {
        return true;
    }

    private void removeItem(String command, Player player) {
        int costumeId = 0;
        try {
            costumeId = Integer.parseInt(command.split(" ")[2]);
        } catch (Exception e) {
            _log.info(String.format("[%s]: Error happened while parsing costume id : %s", getClass().getSimpleName(), e.getMessage()));
            e.printStackTrace();
        }
        if (!player.getVisualItems().contains(costumeId)) {
            _log.info("Player " + player.getName() + " trying to remove visual [" + costumeId + "] which is not available!");
            return;
        }
        ItemTemplate template = ItemHolder.getInstance().getTemplate(costumeId);
        if (template == null) {
            _log.info("Player " + player.getName() + " trying to remove visual [" + costumeId + "] which is not available!");
        } else if (!template.isEquipable()) {
            _log.info("Player " + player.getName() + " trying to remove visual [" + template.getName() + "]" + "[" + template.getItemId() + "] which is not equipable!");
        } else {
            int slot = Inventory.getPaperdollIndex(template.getBodyPart());
            ItemInstance item = player.getInventory().getPaperdollItem(slot);
            if (item == null) {
                _log.info("Player " + player.getName() + " trying to remove visual [" + template.getName() + "]" + "[" + template.getItemId() + "] which is not equipped!");
                return;
            }

            player.sendPacket(new ExShowScreenMessage(String.format("%s is being removed!", DifferentMethods.getItemName(costumeId)), 3000, ExShowScreenMessage.ScreenMessageAlign.BOTTOM_RIGHT, true));
            setItemVisualID(player, 0, item);
            resetItems(player);
            player.getVisualItems().sendAvailableItems();
        }
    }

    private void setItem(String command, Player player) {
        int costumeId = 0;
        try {
            costumeId = Integer.parseInt(command.split(" ")[2]);
        } catch (Exception e) {
            _log.info(String.format("[%s]: Error happened while parsing costume id : %s", getClass().getSimpleName(), e.getMessage()));
            e.printStackTrace();
        }
        if (!player.getVisualItems().contains(costumeId)) {
            _log.info("Player " + player.getName() + " trying to set visual [" + costumeId + "] which is not available!");
            return;
        }
        ItemTemplate template = ItemHolder.getInstance().getTemplate(costumeId);
        if (template == null) {
            _log.info("Player " + player.getName() + " trying to set visual [" + costumeId + "] which is not available!");
        } else if (!template.isEquipable()) {
            _log.info("Player " + player.getName() + " trying to set visual [" + template.getName() + "]" + "[" + template.getItemId() + "] which is not equipable!");
        } else {
            int slot = Inventory.getPaperdollIndex(template.getBodyPart());
            ItemInstance item = player.getInventory().getPaperdollItem(slot);
            if (item == null) {
                _log.info("Player " + player.getName() + " trying to set visual [" + template.getName() + "]" + "[" + template.getItemId() + "] which is not equipped!");
                return;
            }

            // check if item is of the same type
            if (!isValidCostumeType(template, item)) {
                _log.info("Player " + player.getName() + " trying to set visual [" + template.getName() + "]" + "[" + template.getItemId() + "] with wrong type: " + template.getItemType() + " instead of " + item.getItemType());
                return;
            }
            setItemVisualID(player, costumeId, item);
            player.getVisualItems().sendAvailableItems();
        }
    }


    private void setItemVisualID(Player player, int costumeId, ItemInstance item) {
        item.setVisualId(costumeId);
        item.setJdbcState(JdbcEntityState.UPDATED);
        item.update();

        player.sendPacket(new InventoryUpdatePacket().addModifiedItem(player, item));
        player.getInventory().refreshEquip(item);

        if (item.isEquipped())
            player.getInventory().sendEquipInfo(item.getEquipSlot());
    }
}
