package npc.model.custom;

import l2s.commons.collections.MultiValueSet;
import l2s.gameserver.data.htm.HtmCache;
import l2s.gameserver.data.xml.holder.AltDimensionHolder;
import l2s.gameserver.instancemanager.ReflectionManager;
import l2s.gameserver.model.Player;
import l2s.gameserver.model.entity.AltDimension;
import l2s.gameserver.model.instances.NpcInstance;
import l2s.gameserver.templates.npc.NpcTemplate;

import java.util.StringTokenizer;
import java.util.logging.Logger;

public class WarpGateInstance extends NpcInstance {
    private static final Logger LOGGER = Logger.getLogger(WarpGateInstance.class.getSimpleName());

    private final int locationId;

    public WarpGateInstance(int objectId, NpcTemplate template, MultiValueSet<String> set) {
        super(objectId, template, set);
        locationId = set.getInteger("location_id", -1);
    }



    @Override
    public void showChatWindow(Player player, int val, boolean firstTalk, Object... replace) {
        String html = HtmCache.getInstance().getHtml("custom/warpgate/40011.htm", player);
        showChatWindow(player, html, firstTalk, "%name%", buildName(), "%desc%", buildDescription());
    }

    private String buildName() {
        final AltDimension dimension = AltDimensionHolder.getInstance().getDimension(locationId);
        if (dimension == null) {
            return "";
        }
        return dimension.getName();
    }

    private String buildDescription() {
        final AltDimension dimension = AltDimensionHolder.getInstance().getDimension(locationId);
        if (dimension == null) {
            return "";
        }

        final StringBuilder sb = new StringBuilder("<table width=\"270\">");
        for (String desc : dimension.getDescription()) {
            sb.append("<tr>").append("<td align=\"CENTER\" width=\"270\"><font color=\"696969\">").append(desc).append("</font></td>");
        }

        sb.append("</tr></table>");
        return sb.toString();
    }

    @Override
    public void onBypassFeedback(Player player, String command) {
        // teleport bypass
        if (command.equals("goToDimension")) {
            if (!checkCondition(player)) {
                showChatWindow(player, 0, false);
                player.sendMessage("Телепортация невозможна. Не подходящие условия.");
            } else {
                teleportPlayerToDimension(player);
            }
        }
    }

    private void teleportPlayerToDimension(Player player) {
        AltDimension dimension = AltDimensionHolder.getInstance().getDimension(locationId);
        if (dimension == null) {
            LOGGER.info("Player " + player.getName() + " tried to teleport to non-existing location: " + locationId);
        } else {
            player.teleToLocation(dimension.getRandomLocation(), ReflectionManager.ALT_DIMENSION);
        }
    }

    private boolean checkCondition(Player player) {
        AltDimension dimension = AltDimensionHolder.getInstance().getDimension(locationId);
        if (dimension == null) {
            return false;
        }

        return player.getRebirthCount() >= dimension.getRebirths();
    }
}
