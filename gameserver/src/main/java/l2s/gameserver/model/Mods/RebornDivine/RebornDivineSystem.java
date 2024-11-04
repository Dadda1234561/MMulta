package l2s.gameserver.model.Mods.RebornDivine;

import l2s.gameserver.common.DifferentMethods;
import l2s.gameserver.model.Player;
import l2s.gameserver.model.base.Experience;
import l2s.gameserver.network.l2.components.HtmlMessage;
import l2s.gameserver.skills.SkillEntry;
import l2s.gameserver.skills.SkillEntryType;
import l2s.gameserver.templates.item.ItemTemplate;
import l2s.gameserver.utils.ItemFunctions;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.text.SimpleDateFormat;
import java.util.concurrent.TimeUnit;

public class RebornDivineSystem {
    public static final Logger _log = LoggerFactory.getLogger(RebornDivineSystem.class);

    public static void info(Player player, int npcobj) {
        HtmlMessage html = new HtmlMessage(npcobj).setFile("scripts/MCST/Reborn.htm");
        if (player == null)
            return;
        int REBORN_COUNT = player.getRebirthCountDivine();
        RebornDivineSystemInfo info = RebornDivineSystemManager.getRebornId(REBORN_COUNT);

        if (info != null) {
            String content = "";
            String need_item = "";
            String reward_item = "";
            String level_need = "";
            int max_rebirth = 0;

            if (REBORN_COUNT == (info.getRebornId() - 1)) {
                for (String reward : info.getNeedItem().split(";")) {
                    String[] reward_array = reward.split(",");
                    if (reward_array.length == 2) {
                        need_item = need_item + Long.parseLong(reward_array[1]) + " " + DifferentMethods.getItemName(Integer.parseInt(reward_array[0])) + " ";
                    } else {
                        _log.error("Error reward_array.length != 2");
                    }
                }
                for (String reward : info.getReward().split(";")) {
                    String[] reward_array = reward.split(",");
                    if (reward_array.length == 2) {
                        reward_item = reward_item + Long.parseLong(reward_array[1]) + " " + DifferentMethods.getItemName(Integer.parseInt(reward_array[0])) + " ";
                    } else {
                        _log.error("Error reward_array.length != 2");
                    }
                }
                level_need = String.valueOf(info.getLevelNeed());
                max_rebirth = RebornDivineSystemManager.getSize();

            }
            html = html.replace("<?need_item?>", need_item);
            html = html.replace("<?max_rebirth?>", String.valueOf(max_rebirth));
        } else {
            html.setFile("scripts/MCST/Reborn_final.htm");
        }

        player.sendPacket(html);
    }

    public static void RebornDivineAdd(Player player, boolean bbs) {
        int REBORN_COUNT = player.getRebirthCountDivine();
        RebornDivineSystemInfo info = RebornDivineSystemManager.getRebornId(REBORN_COUNT);
        if (info != null) {
            if (player.getLevel() < info.getLevelNeed()) {
                player.sendScreenMessage("Ваш уровень мал для перерождения, нужно быть минимум " + info.getLevelNeed() + " на активном саб классе.");
                if (bbs)
                    DifferentMethods.communityNextPage(player, "_bbsskill:RebornDivine_show");
                return;
            }
            if (player.getVarLong("rebornTimeSub") > System.currentTimeMillis()) {
                player.sendScreenMessage("Будет готово для использования в " + new SimpleDateFormat("dd.MM.yyyy HH:mm").format(player.getVarLong("rebornTime")));
                if (bbs)
                    DifferentMethods.communityNextPage(player, "_bbsskill:RebornDivine_show");
                return;
            }
            if (player.getRebirthCountDivine() > RebornDivineSystemManager.getSize()) {
                player.sendScreenMessage("Больше нельзя перерождаться.");
                if (bbs)
                    DifferentMethods.communityNextPage(player, "_bbsskill:RebornDivine_show");
                return;
            }
            for (String paymentStr : info.getNeedItem().split(";")) {
                String[] paymentArr = paymentStr.split(",");
                if (paymentArr.length == 2) {

                    //проверяем имеет ли вообще чар итем
                    if (!player.getInventory().containsItem(Integer.parseInt(paymentArr[0]))) {
                        player.sendScreenMessage("Для перерождения, нужно иметь итем " + DifferentMethods.getItemName(Integer.parseInt(paymentArr[0])));
                        return;
                    }
                    //если итем есть, проверяем на количество
                    if (player.getInventory().getCountOf(Integer.parseInt(paymentArr[0])) < Long.parseLong(paymentArr[1])) {
                        player.sendScreenMessage("У вас нету нужного количества " + DifferentMethods.getItemName(Integer.parseInt(paymentArr[0])));
                        return;
                    }
                } else {
                    _log.error("Error paymentArr.length != 2");
                }
            }
            // забираем итем
            for (String paymentStr : info.getNeedItem().split(";")) {
                String[] paymentArr = paymentStr.split(",");
                if (paymentArr.length == 2) {
                    DifferentMethods.getPay(player, Integer.parseInt(paymentArr[0]), Integer.parseInt(paymentArr[1]), true);
                }
            }

            // Все гуд, выдаем награду
           for (String reward : info.getReward().split(";")) {
               if (reward.isEmpty()) {
                   continue;
               }
               String[] reward_array = reward.split(",");
               if (reward_array.length == 2) {
                   switch (Integer.parseInt(reward_array[0])) {
                       case ItemTemplate.ITEM_ID_FAME:
                           player.setFame(player.getFame() + Integer.parseInt(reward_array[1]), "RebornDivineService", true);
                           break;
                       case ItemTemplate.ITEM_ID_CLAN_REPUTATION_SCORE:
                           if (player.getClan() != null)
                               player.getClan().incReputation(Integer.parseInt(reward_array[1]), false, "RebornDivineService");
                           break;
                       case ItemTemplate.ITEM_ID_PC_BANG_POINTS:
                           player.addPcBangPoints(Integer.parseInt(reward_array[1]), false, true);
                           break;
                       default:
                           ItemFunctions.addItem(player, Integer.parseInt(reward_array[0]), Integer.parseInt(reward_array[1]), true);
                   }
               } else {
                   _log.error("Error reward_array.length != 2");
               }
           }

            long exp_add = Experience.getExpForLevel(info.getResetLevel()) - player.getExp();
            player.addExpAndSp(exp_add, 0);
            player.setRebirthCountDivine(player.getRebirthCountDivine() + 1);
            // When increasing rebirth count check for available class changes to 4rd proff.
            player.sendClassChangeAlert();
            player.setVar("rebornTimeSub", System.currentTimeMillis() + TimeUnit.HOURS.toMillis(info.getResetTime()), -1);
            if (bbs)
                DifferentMethods.communityNextPage(player, "_bbsskill:RebornDivine_show");
        }
    }
}