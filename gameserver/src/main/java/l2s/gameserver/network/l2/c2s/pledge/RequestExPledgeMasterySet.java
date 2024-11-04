package l2s.gameserver.network.l2.c2s.pledge;

import l2s.gameserver.data.xml.holder.ClanMasteryHolder;
import l2s.gameserver.model.Player;
import l2s.gameserver.model.pledge.Clan;
import l2s.gameserver.network.l2.c2s.L2GameClientPacket;
import l2s.gameserver.network.l2.s2c.pledge.ExPledgeMasteryInfo;
import l2s.gameserver.templates.ClanMastery;

/**
 * @author Mobius
 **/
public class RequestExPledgeMasterySet extends L2GameClientPacket {
	private int masteryId;

	@Override
	protected boolean readImpl() {
		masteryId = readD();
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

		// Check if already enabled.
		if (clan.hasMastery(masteryId)) {
			activeChar.sendMessage("This mastery is already available."); // TODO: Offlike msg.
			return;
		}

		// Check if it can be learned.
		if (clan.getTotalDevelopmentPoints() <= clan.getUsedDevelopmentPoints()) {
			activeChar.sendMessage("Your clan develpment points are not sufficient."); // TODO: Offlike msg.
			return;
		}

		ClanMastery mastery = ClanMasteryHolder.getInstance().getClanMastery(masteryId);
		if (clan.getLevel() < mastery.getClanLevel()) {
			activeChar.sendMessage("Your clan level is lower than the requirement."); // TODO: Offlike msg.
			return;
		}

		if (clan.getReputationScore() < mastery.getClanReputation()) {
			activeChar.sendMessage("Your clan reputation is lower than the requirement.");
			return;
		}

		int previous = mastery.getPreviousMastery();
		int previousAlt = mastery.getPreviousMasteryAlt();
		if (previousAlt > 0) {
			if (!clan.hasMastery(previous) && !clan.hasMastery(previousAlt)) {
				activeChar.sendMessage("You need to learn a previous mastery.");
				return;
			}
		} else if ((previous > 0) && !clan.hasMastery(previous)) {
			activeChar.sendMessage("You need to learn the previous mastery.");
			return;
		}

		// Learn.
		clan.incReputation(-mastery.getClanReputation(), false, "Pledge mastery set");
		clan.addMastery(mastery.getId());
		clan.setDevelopmentPoints(clan.getUsedDevelopmentPoints() + 1);
		mastery.getSkills().forEach((s) -> clan.addSkill(s, true));
		activeChar.sendPacket(new ExPledgeMasteryInfo(activeChar));
	}
}
