package l2s.gameserver.common;

import l2s.gameserver.Announcements;
import l2s.gameserver.data.htm.HtmCache;
import l2s.gameserver.data.xml.holder.ItemHolder;
import l2s.gameserver.handler.bbs.BbsHandlerHolder;
import l2s.gameserver.handler.bbs.IBbsHandler;
import l2s.gameserver.instancemanager.ServerVariables;
import l2s.gameserver.model.GameObjectsStorage;
import l2s.gameserver.model.Player;
import l2s.gameserver.model.items.ItemInstance;
import l2s.gameserver.network.l2.components.ChatType;
import l2s.gameserver.network.l2.s2c.ExShowScreenMessage;
import l2s.gameserver.network.l2.components.CustomMessage;
import l2s.gameserver.templates.item.ItemTemplate;

import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.Optional;

public class DifferentMethods {
    private static final DateFormat TIME_FORMAT = new SimpleDateFormat("HH:mm");
    public static int max_online = 0;
    public static int max_online_day = 0;
    public static void clear(Player player) {
        for (ItemInstance item : player.getInventory().getItems()) {
            if (item.getCount() == 1) {
                player.sendMessage(item.getName() + " был удален.");
            }
            else {
                if (item.getCount() > 1) {
                    player.sendMessage(String.valueOf(item.getCount()) + " " + item.getName() + " было удалено.");
                }
            }
            player.getInventory().destroyItemByItemId(item.getItemId(), item.getCount());
        }

        for (ItemInstance item : player.getWarehouse().getItems()) {
            if (item.getCount() == 1) {
                player.sendMessage(item.getName() + " был удален.");
            }
            else {
                if (item.getCount() > 1) {
                    player.sendMessage(String.valueOf(item.getCount()) + " " + item.getName() + " было удалено.");
                }
            }
            player.getWarehouse().destroyItemByItemId(item.getItemId(), item.getCount());
        }

        if ((player.getClan() != null) && (player.isClanLeader())) {
            for (ItemInstance item : player.getClan().getWarehouse().getItems()) {
                if (item.getCount() == 1) {
                    player.sendMessage(item.getName() + " был удален.");
                }
                else {
                    if (item.getCount() > 1L) {
                        player.sendMessage(String.valueOf(item.getCount()) + " " + item.getName() + " было удалено.");
                    }
                }
                player.getClan().getWarehouse().destroyItemByItemId(item.getItemId(), item.getCount());
            }
        }
        player.sendMessage("За подмену данных все предметы были удалены.");
    }

    public static String getErrorHtml(Player player, String bypass) {
        String _msg = HtmCache.getInstance().getHtml("error.htm", player);
        _msg = _msg.replace("<?bypass?>", bypass);
        return _msg;
    }

    public static void communityNextPage(Player player, String link) {
        IBbsHandler handler = BbsHandlerHolder.getInstance().getCommunityHandler(link);
        if(link != null)
            if(handler != null)
                handler.onBypassCommand(player, link);
    }

    public static String time() {
        return TIME_FORMAT.format(new Date(System.currentTimeMillis()));
    }

    public static boolean getPay(Player player, int itemid, long count, int enchantLevel, boolean sendMessage) {
        if (count == 0)
            return true;

        boolean check = false;
        switch (itemid) {
            case ItemTemplate.ITEM_ID_FAME:
                break;
            case ItemTemplate.ITEM_ID_CLAN_REPUTATION_SCORE:
                break;
            case ItemTemplate.ITEM_ID_PC_BANG_POINTS:
            case 0:
                if (player.getPremiumPoints() >= count) {
                    player.reducePremiumPoints((int) count);
                    check = true;
                }
                break;
            default:
                ItemInstance item = player.getInventory().getItemByItemId(itemid);
                if (item != null && item.getCount() >= count && item.getEnchantLevel() >= enchantLevel) {
                    player.getInventory().destroyItemByItemId(itemid, count);
                    check = true;
                }
                break;
        }
        if (!check) {
            if (sendMessage)
                enoughtItem(player, itemid, count, enchantLevel);
            return false;
        }
        if (sendMessage)
            player.sendMessage(player.isLangRus()
                    ? "Исчезло: " + count + " " + getItemName(itemid) + " зачарован на + " + enchantLevel
                    : "Disappeared: " + count + " of " + getItemName(itemid) + " enchanted to level + " + enchantLevel);

        return true;
    }

    public static boolean getPay(Player player, int itemid, long count, boolean sendMessage) {
        return getPay(player, itemid, count, 0, sendMessage);
    }

    private static void enoughtItem(Player player, int itemid, long count, int enchantLevel) {
        String screenMessage = enchantLevel > 0
                ? new CustomMessage("communityboard.enoughItemCountWithEnchant")
                .addNumber(count)
                .addItemName(itemid)
                .addNumber(enchantLevel)
                .toString(player)
                : new CustomMessage("communityboard.enoughItemCount")
                .addNumber(count)
                .addItemName(itemid)
                .toString(player);
        player.sendPacket(new ExShowScreenMessage(screenMessage, 3000, ExShowScreenMessage.ScreenMessageAlign.TOP_CENTER, true));
        String chatMessage = enchantLevel > 0
                ? new CustomMessage("communityboard.enoughItemCountWithEnchant")
                .addNumber(count)
                .addItemName(itemid)
                .addNumber(enchantLevel)
                .toString(player)
                : new CustomMessage("communityboard.enoughItemCount")
                .addNumber(count)
                .addItemName(itemid)
                .toString(player);
        player.sendMessage(chatMessage);
    }


    public static void addItem(Player player, int itemid, long count) {
        player.getInventory().addItem(itemid, count);
        player.sendMessage("Вы получили " + count + " " + getItemName(itemid));
    }

    public static long addMinutes(long count) {
        return count * 1000L * 60L;
    }

    public static long addDay(long count) {
        return count * 1000L * 60L * 60L * 24L;
    }

    public static String getItemName(int itemId) {
        if (itemId == ItemTemplate.ITEM_ID_FAME)
            return "Славы";

        if (itemId == ItemTemplate.ITEM_ID_PC_BANG_POINTS)
            return "Очков PC Клуба";

        if (itemId == ItemTemplate.ITEM_ID_CLAN_REPUTATION_SCORE)
            return "Очков репутации клана";

        return ItemHolder.getInstance().getTemplate(itemId).getName();
    }

    public static String getItemIcon(int itemId) {
        return ItemHolder.getInstance().getTemplate(itemId).getIcon();
    }

    public static String declension(Player player, int count, String Type) {
        String one = "";
        String two = "";
        String five = "";

        if (Type.equals("Days")) {
            one = new CustomMessage("common.declension.day.1").toString();
            two = new CustomMessage("common.declension.day.2").toString();
            five = new CustomMessage("common.declension.day.5").toString();
        }

        if (Type.equals("Hour")) {
            one = new CustomMessage("common.declension.hour.1").toString();
            two = new CustomMessage("common.declension.hour.2").toString();
            five = new CustomMessage("common.declension.hour.5").toString();
        }

        if (Type.equals("Piece")) {
            one = new CustomMessage("common.declension.piece.1").toString();
            two = new CustomMessage("common.declension.piece.2").toString();
            five = new CustomMessage("common.declension.piece.5").toString();
        }

        if (count > 100)
            count %= 100;

        if (count > 20)
            count %= 10;

        switch (count) {
            case 1:
                return one;
            case 2:
            case 3:
            case 4:
                return two;
        }
        return five;
    }

    /*public static void sayToAll(String address, String[] replacements) {
        Announcements.getInstance().addAnnouncement(address, replacements, ChatType.CRITICAL_ANNOUNCE);
    }*/

    public static boolean findInList(int[] list, int id) {
        for (int i : list) {
            if (i == id)
                return true;
        }
        return false;
    }

    public static boolean findInList(String[] list, String id) {
        for (String i : list) {
            if (i.equalsIgnoreCase(id))
                return true;
        }
        return false;
    }

    // Method for converting remaining seconds to string in format of "1h 1m"
    public static String convertTimeToString(long time)
    {
        if (time <= 0)
            return "0ч 0м";

        String result = "";
        long days = time / 86400;
        long hours = (time - days * 86400) / 3600;
        long minutes = (time - days * 86400 - hours * 3600) / 60;
        long seconds = time - days * 86400 - hours * 3600 - minutes * 60;

        if (hours > 0)
            result += hours + "ч ";
        if (minutes > 0)
            result += minutes + "м ";

        if(hours == 0 && minutes == 0 && seconds != 0) {
            result += seconds + "сек";
        }

        return result;
    }

    /*public static void setMaxOnline()
    {
        int online = Math.max(GameObjectsStorage.getAllPlayersCount(), max_online_day);
        if (max_online_day < online)
        {
            max_online_day = online;
            if (max_online_day > max_online)
            {
                max_online = max_online_day;
                ServerVariables.set("MaxOnline", max_online_day);
            }
        }
    }*/
}