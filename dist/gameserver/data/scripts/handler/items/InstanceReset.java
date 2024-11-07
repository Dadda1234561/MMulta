package handler.items;

import l2s.gameserver.Config;
import l2s.gameserver.data.htm.HtmCache;
import l2s.gameserver.data.xml.holder.InstantZoneHolder;
import l2s.gameserver.handler.bypass.Bypass;
import l2s.gameserver.model.Player;
import l2s.gameserver.model.instances.NpcInstance;
import l2s.gameserver.model.items.ItemInstance;
import l2s.gameserver.network.l2.components.HtmlMessage;
import l2s.gameserver.templates.InstantZone;
import l2s.gameserver.utils.Language;
import l2s.gameserver.utils.Util;

public class InstanceReset extends SimpleItemHandler {

    @Override
    protected boolean useItemImpl(Player player, ItemInstance item, boolean ctrl) {
        showInstancePage(player, item);
        return true;
    }

    @Bypass("handler.items.InstanceReset:resetInstance")
    public void resetInstance(Player player, NpcInstance npc, String[] param) {
        if (param.length != 2) {
            return;
        }

        int templateId = -1;
        int itemObjectId = -1;
        try {
            templateId = Integer.parseInt(param[0]);
            itemObjectId = Integer.parseInt(param[1]);
        } catch (NumberFormatException e) {
            e.printStackTrace();
        }

        if (templateId == -1 || itemObjectId == -1) {
            return;
        }

        ItemInstance itemByItemId = player.getInventory().getItemByObjectId(itemObjectId);
        if (itemByItemId == null) {
            player.sendActionFailed();
            return;
        }

//        int resetCnt = player.getInstanceResetCount(templateId);
//        if (resetCnt >= Config.MAX_RESETS_PER_INSTANCE) {
//            player.sendActionFailed();
//            return;
//        }

        InstantZone instantZone = InstantZoneHolder.getInstance().getInstantZone(templateId);
        if (InstantZoneHolder.getInstance().getInstantZone(75) == instantZone
         || InstantZoneHolder.getInstance().getInstantZone(76) == instantZone
         || InstantZoneHolder.getInstance().getInstantZone(77) == instantZone
         || InstantZoneHolder.getInstance().getInstantZone(78) == instantZone) {
            player.sendMessage(player.isLangRus() ? "Вы не можете сбрасывать эту зону." : "You cannot reset this instance.");
            return;
        }
        int resetCount = player.getVarInt("InstanceResetCount", 5);
        if(resetCount >= 1) {
            if (!reduceItem(player, itemByItemId)) {
                player.sendActionFailed();
                return;
            }
            if (instantZone != null) {
//                player.setInstanceResetCnt(templateId, resetCnt + 1);
                player.removeInstanceReuse(templateId);
                player.sendMessage(String.format("%s is available now!", instantZone.getName()));

                player.setVar("InstanceResetCount", resetCount-1);
            }

            showInstancePage(player, itemByItemId);
        }
        else {
            if(player.getLanguage() == Language.RUSSIAN){
                player.sendMessage("Вы израсходовали доступное количество попыток сброса.");
            }
            else {
                player.sendMessage("You have reached the reset limit.");
            }

        }
    }

    private void showInstancePage(Player player, ItemInstance item) {
        String html = HtmCache.getInstance().getHtml("mods/instance_reset/index.htm", player);
        if (html != null) {
            StringBuilder sb = new StringBuilder("<table>");
            html = html.replace("%resetCount%", String.valueOf(player.getVarInt("InstanceResetCount", 5)));
            if (player.getInstanceReuses().isEmpty()) {
                sb.append("<tr><td align=CENTER width=300><font color=\"FF0000\">No instances to reset!</font></td></tr></table>");
                html = html.replace("%instanceList%", sb.toString());
                player.sendPacket(new HtmlMessage(0).setHtml(html));
                return;
            }
            sb.append("<tr><td align=LEFT width=200><font color=\"a9a9a9\">Instance</font></td><td width=100><font color=\"a9a9a9\">Resets in</font></td></tr>");
            for (int instanceId : InstantZoneHolder.getInstance().getLockedInstancesList(player)) {
                InstantZone instantZone = InstantZoneHolder.getInstance().getInstantZone(instanceId);
                if (instantZone == null) {
                    continue;
                }

                if (instantZone == InstantZoneHolder.getInstance().getInstantZone(75) ||
                    instantZone == InstantZoneHolder.getInstance().getInstantZone(76) ||
                    instantZone == InstantZoneHolder.getInstance().getInstantZone(77) ||
                    instantZone == InstantZoneHolder.getInstance().getInstantZone(78)) {
                    continue;
                }

                int nextEntrance = InstantZoneHolder.getInstance().getMinutesToNextEntrance(instanceId, player) * 60;

                sb.append("<tr>" +
                            "<td align=LEFT width=200><a action=\"bypass -h htmbypass_handler.items.InstanceReset:resetInstance ").append(instantZone.getId()).append(" ").append(item.getObjectId()).append("\">").append(instantZone.getName()).append("</a></td>" +
                            "<td width=100>").append(Util.formatTime(nextEntrance)).append("</td>" +
                        "</tr>");
            }
            sb.append("</table>");
            html = html.replace("%instanceList%", sb.toString());
            player.sendPacket(new HtmlMessage(0).setHtml(html));
        }
    }
}
