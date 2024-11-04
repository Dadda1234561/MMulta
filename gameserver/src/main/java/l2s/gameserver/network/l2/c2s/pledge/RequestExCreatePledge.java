package l2s.gameserver.network.l2.c2s.pledge;

import l2s.gameserver.Config;
import l2s.gameserver.model.Player;
import l2s.gameserver.model.actor.variables.PlayerVariables;
import l2s.gameserver.model.instances.NpcInstance;
import l2s.gameserver.model.pledge.Clan;
import l2s.gameserver.network.l2.c2s.L2GameClientPacket;
import l2s.gameserver.network.l2.components.SystemMsg;
import l2s.gameserver.network.l2.s2c.pledge.PledgeShowInfoUpdatePacket;
import l2s.gameserver.tables.ClanTable;
import l2s.gameserver.utils.NpcUtils;
import l2s.gameserver.utils.Util;
import org.apache.commons.lang3.StringUtils;

public class RequestExCreatePledge extends L2GameClientPacket {
	//Format: cS
	private String clanName;

	@Override
	protected boolean readImpl() {
		clanName = readS(64);
		return true;
	}

	@Override
	protected void runImpl() {
		Player activeChar = getClient().getActiveChar();
		if (activeChar == null)
			return;

		if(NpcUtils.canPassPacket(activeChar, this) == null)
		{
			activeChar.sendActionFailed();
			return;
		}

		if (activeChar.getLevel() < 10 || activeChar.getClan() != null) {
			activeChar.sendPacket(SystemMsg.YOU_DO_NOT_MEET_THE_CRITERIA_IN_ORDER_TO_CREATE_A_CLAN);
			return;
		}

		if (!activeChar.canCreateClan()) {
			activeChar.sendPacket(SystemMsg.YOU_MUST_WAIT_10_DAYS_BEFORE_CREATING_A_NEW_CLAN);
			return;
		}

		if (StringUtils.isEmpty(clanName)) {
			activeChar.sendPacket(SystemMsg.PLEASE_CREATE_YOUR_CLAN_NAME);
			return;
		}

		if (clanName.length() > 16) {
			activeChar.sendPacket(SystemMsg.CLAN_NAMES_LENGTH_IS_INCORRECT);
			return;
		}

		if (!Util.isMatchingRegexp(clanName, Config.CLAN_NAME_TEMPLATE)) {
			activeChar.sendPacket(SystemMsg.CLAN_NAME_IS_INVALID);
			return;
		}

		Clan clan = ClanTable.getInstance().createClan(activeChar, clanName);
		if (clan == null) {
			activeChar.sendPacket(SystemMsg.THIS_NAME_ALREADY_EXISTS);
			return;
		}

		activeChar.sendPacket(clan.listAll());
		activeChar.sendPacket(new PledgeShowInfoUpdatePacket(clan));
		activeChar.updatePledgeRank();
		activeChar.broadcastCharInfo();
		activeChar.setVar(PlayerVariables.PREVIOUS_REPUTATION, 0);
		activeChar.setVar(PlayerVariables.CURRENT_REPUTATION, 0);
		activeChar.setVar(PlayerVariables.TOTAL_REPUTATION, 0);
		activeChar.setVar(PlayerVariables.CONTRIBUTION_CLAIMED, 0);

		NpcInstance npc = activeChar.getLastNpc();
		if (npc != null)
			npc.showChatWindow(activeChar, "pledge/pl006.htm", false);
		else
			activeChar.sendPacket(SystemMsg.YOUR_CLAN_HAS_BEEN_CREATED);
	}
}