package l2s.gameserver.network.l2.c2s.events;

import l2s.gameserver.Config;
import l2s.gameserver.data.xml.holder.TeleportListHolder;
import l2s.gameserver.instancemanager.ReflectionManager;
import l2s.gameserver.model.Player;
import l2s.gameserver.model.actor.instances.player.BookMarkList;
import l2s.gameserver.network.l2.c2s.L2GameClientPacket;
import l2s.gameserver.network.l2.components.SystemMsg;
import l2s.gameserver.templates.TeleportInfo;

public class RequestExBalrogWarTeleport extends L2GameClientPacket {
    @Override
    protected boolean readImpl() throws Exception {
        readC(); // dummy
        return true;
    }

    @Override
    protected void runImpl() throws Exception {
        Player player = getClient().getActiveChar();
        if (player == null) {
            return;
        }

        TeleportInfo teleportInfo = TeleportListHolder.getInstance().getTeleportInfo(472);
        if (teleportInfo == null) {
            return;
        }

        if (player.getReflection() != ReflectionManager.MAIN) {
            return;
        }

        if (!BookMarkList.checkFirstConditions(player) || !BookMarkList.checkTeleportConditions(player)) //TODO: Check conditions.
            return;

        if (player.getLevel() > Config.GATEKEEPER_FREE && !player.reduceAdena(teleportInfo.getPrice(), true)) {
            player.sendPacket(SystemMsg.YOU_DO_NOT_HAVE_ENOUGH_ADENA); //TODO: Check message.
            return;
        }

        player.teleToLocation(teleportInfo.getLoc(), ReflectionManager.MAIN);
    }
}
