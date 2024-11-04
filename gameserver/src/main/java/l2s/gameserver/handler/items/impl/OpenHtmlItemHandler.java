package l2s.gameserver.handler.items.impl;

import l2s.gameserver.data.htm.HtmCache;
import l2s.gameserver.model.Playable;
import l2s.gameserver.model.Player;
import l2s.gameserver.model.items.ItemInstance;
import l2s.gameserver.network.l2.s2c.SystemMessage;
import l2s.gameserver.utils.Functions;

import java.util.StringTokenizer;

public class OpenHtmlItemHandler extends DefaultItemHandler {

    @Override
    public boolean useItem(Playable playable, ItemInstance item, boolean ctrl) {
        Player player = playable.getPlayer();
        if (player == null) {
            return false;
        }

        String htmlContent = HtmCache.getInstance().getHtml("mods/item/" + item.getItemId() + ".htm", player);
        String replacedHtml = htmlContent.replace("%objectId%", String.valueOf(item.getObjectId()));
        Functions.show(replacedHtml, player, item.getItemId());

        return true;
    }

    @Override
    public void onBypass(Playable playable, ItemInstance item, String command) {
        if (!playable.isPlayer()) {
            return;
        }

        switch (item.getItemId()) {
            case 110667: {
                 if (command.startsWith("teleport")) {
                     if (playable.getPlayer().isInCombat()
                             || playable.getPlayer().getPvpFlag() != 0
                             || playable.getPlayer().isPK()
                             || playable.getPlayer().isFlying()) {
                         playable.sendPacket(new SystemMessage(7175));
                         break;
                     }

                    StringTokenizer st = new StringTokenizer(command, " ");
                    st.nextToken(); // skip command
                    if (st.hasMoreTokens()) {
                        int x = Integer.parseInt(st.nextToken());
                        int y = Integer.parseInt(st.nextToken());
                        int z = Integer.parseInt(st.nextToken());

                        if (playable.isAttackingNow() || playable.isCastingNow()) {
                            playable.sendPacket(new SystemMessage(5242));
                        } else {
                            playable.teleToLocation(x, y, z);
                        }
                    }
                } else if (command.startsWith("nextPage")) {
                    String currentPage = command.split(" ")[1];
                    int nextPageNumber = Integer.parseInt(currentPage) + 1;

                    String htmlContent = HtmCache.getInstance().getHtml("mods/item/110667-" + nextPageNumber + ".htm", playable.getPlayer());
                    String replacedHtml = htmlContent.replace("%objectId%", String.valueOf(item.getObjectId()));
                    Functions.show(replacedHtml, playable.getPlayer(), item.getItemId());
                } else if (command.startsWith("mainPage")) {
                     String htmlContent = HtmCache.getInstance().getHtml("mods/item/" + item.getItemId() + ".htm", playable.getPlayer());
                     String replacedHtml = htmlContent.replace("%objectId%", String.valueOf(item.getObjectId()));
                     Functions.show(replacedHtml, playable.getPlayer(), item.getItemId());
                }
                break;
            }
        }
    }
}
