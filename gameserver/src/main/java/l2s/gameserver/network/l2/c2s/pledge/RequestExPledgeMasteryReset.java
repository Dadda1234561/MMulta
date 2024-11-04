package l2s.gameserver.network.l2.c2s.pledge;

import l2s.gameserver.model.Player;
import l2s.gameserver.model.pledge.Clan;
import l2s.gameserver.network.l2.c2s.L2GameClientPacket;
import l2s.gameserver.network.l2.s2c.pledge.ExPledgeMasteryInfo;

/**
 * @author Mobius
 **/
public class RequestExPledgeMasteryReset extends L2GameClientPacket {
	private final static int REPUTATION_COST = 10000;

	@Override
	protected boolean readImpl() {
		return true;
	}

	@Override
	protected void runImpl() {
		Player activeChar = getClient().getActiveChar();
		if (activeChar == null)
			return;

		Clan clan = activeChar.getClan();
		if (clan == null) {
			activeChar.sendActionFailed();
			return;
		}

		if (activeChar.getObjectId() != clan.getLeaderId()) {
			activeChar.sendMessage("You do not have enough privileges to take this action."); // TODO: Offlike msg.
			return;
		}

		if (clan.getReputationScore() < REPUTATION_COST) {
			activeChar.sendMessage("You need " + REPUTATION_COST + " clan reputation."); // TODO: Offlike msg.
			return;
		}

		clan.incReputation(-REPUTATION_COST, false, "Pledge mastery reset");
		clan.removeAllMasteries();
		clan.setDevelopmentPoints(0);
		activeChar.sendPacket(new ExPledgeMasteryInfo(activeChar));
	}
}
