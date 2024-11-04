package npc.model;


import l2s.commons.collections.MultiValueSet;
import l2s.gameserver.data.htm.HtmCache;
import l2s.gameserver.data.xml.holder.AltDimensionHolder;
import l2s.gameserver.instancemanager.ReflectionManager;
import l2s.gameserver.model.Player;
import l2s.gameserver.model.base.ClassLevel;
import l2s.gameserver.model.entity.AltDimension;
import l2s.gameserver.model.instances.NpcInstance;
import l2s.gameserver.templates.npc.NpcTemplate;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

public class FarmZoneGatekeeperWarpGateInstance extends NpcInstance
{
    private static final Logger _log = LoggerFactory.getLogger(FarmZoneGatekeeperWarpGateInstance.class);

    private final int locationId;

    public FarmZoneGatekeeperWarpGateInstance(int objectId, NpcTemplate template, MultiValueSet<String> set)
    {
        super(objectId, template, set);
        locationId = set.getInteger("location_id", -1);
    }

    @Override
    public void showChatWindow(Player player, int val, boolean firstTalk, Object... replace)
    {
        String html = HtmCache.getInstance().getHtml("custom/warpgate/40011.htm", player);
        showChatWindow(player, html, firstTalk, "%name%", buildName(), "%desc%", buildDescription());
    }

    private String buildName()
    {
        final AltDimension dimension = AltDimensionHolder.getInstance().getDimension(locationId);
        if (dimension == null)
        {
            return "";
        }
        return dimension.getName();
    }

    private String buildDescription()
    {
        final AltDimension dimension = AltDimensionHolder.getInstance().getDimension(locationId);
        if (dimension == null)
        {
            return "";
        }

        final StringBuilder sb = new StringBuilder("<table width=\"270\">");
        for (String desc : dimension.getDescription())
        {
            sb.append("<tr>").append("<td align=\"CENTER\" width=\"270\"><font color=\"696969\">").append(desc).append("</font></td>");
        }

        sb.append("</tr></table>");
        return sb.toString();
    }

    public void onBypassFeedback(Player player, String command) {
        if (command.startsWith("alt_dimension")) {
            String[] args = command.split(" ");
            if (args.length > 1) {
                int locationId = -1;
                try {
                    locationId = Integer.parseInt(args[1]);
                } catch (NumberFormatException e) {
                    _log.warn("Error happened while parsing location id for dimension. Error:", e);
                }

                if (locationId > 0) {
                    AltDimension dimension = AltDimensionHolder.getInstance().getDimension(locationId);
                    if (dimension == null) {
                        _log.info("Not found dimension location with id = " + locationId);
                        super.onBypassFeedback(player, command);
                        return;
                    }
                    if (player.getRebirthCount() < dimension.getRebirths()) {
                        if (player.isLangRus()) {
                            player.sendScreenMessage("Недостаточно перерождений. Необходимо " + dimension.getRebirths() + " перерождений.");
                        } else {
                            player.sendScreenMessage("Not enough rebirths. " + dimension.getRebirths() + " is required to teleport.");
                        }
                        return;
                    }
                    if (!dimension.getNeed4Prof() && !player.getClassId().isOfLevel(ClassLevel.AWAKED))
                    {

                        if (player.isLangRus()) {
                            player.sendScreenMessage("Ваша профессия не соответствует требованиям.");
                        } else {
                            player.sendScreenMessage("Your profession does not meet the requirements.");
                        }
                        return;
                    }
                    player.teleToLocation(dimension.getRandomLocation(), ReflectionManager.ALT_DIMENSION);
                }
            }
        }
    }
}
