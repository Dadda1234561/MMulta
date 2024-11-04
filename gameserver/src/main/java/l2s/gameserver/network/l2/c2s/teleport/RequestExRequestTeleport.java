package l2s.gameserver.network.l2.c2s.teleport;

import l2s.gameserver.Config;
import l2s.gameserver.data.xml.holder.TeleportListHolder;
import l2s.gameserver.instancemanager.ReflectionManager;
import l2s.gameserver.model.Player;
import l2s.gameserver.model.actor.instances.player.BookMarkList;
import l2s.gameserver.network.l2.c2s.L2GameClientPacket;
import l2s.gameserver.network.l2.components.SystemMsg;
import l2s.gameserver.templates.TeleportInfo;
import l2s.gameserver.utils.ChatUtils;

/**
 * @author Bonux (bonuxq@gmail.com)
 **/
public class RequestExRequestTeleport extends L2GameClientPacket {
	private int teleportId;

	@Override
	protected boolean readImpl() {
		teleportId = readD();
		return true;
	}

	@Override
	protected void runImpl() {
		Player activeChar = getClient().getActiveChar();
		if (activeChar == null)
			return;

		if (activeChar.isPK())
			return;

		TeleportInfo teleportInfo = TeleportListHolder.getInstance().getTeleportInfo(teleportId);
		if (teleportInfo == null) {
			activeChar.sendActionFailed();
			if (activeChar.isGM())
				ChatUtils.sys(activeChar, "Not found teleport info for ID: " + teleportId);
			return;
		}
		
		if (activeChar.getReflection() != ReflectionManager.MAIN)
		{
			return;
		}

		if (!BookMarkList.checkFirstConditions(activeChar) || !BookMarkList.checkTeleportConditions(activeChar)) //TODO: Check conditions.
			return;

		if(activeChar.isGM())
			ChatUtils.sys(activeChar, "Teleport ID: " + teleportId);

		if (activeChar.getLevel() > Config.GATEKEEPER_FREE && !activeChar.reduceAdena(teleportInfo.getPrice(), true)) {
			activeChar.sendPacket(SystemMsg.YOU_DO_NOT_HAVE_ENOUGH_ADENA); //TODO: Check message.
			return;
		}

		activeChar.teleToLocation(teleportInfo.getLoc(), ReflectionManager.MAIN);
	}
}
