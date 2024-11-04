package l2s.gameserver.network.l2.c2s.pledge;

import l2s.gameserver.model.Player;
import l2s.gameserver.model.pledge.Clan;
import l2s.gameserver.network.l2.c2s.L2GameClientPacket;
import l2s.gameserver.network.l2.s2c.pledge.ExPledgeSkillInfo;

/**
 * @author Mobius
 **/
public class RequestExPledgeSkillActivate extends L2GameClientPacket {
	private int _skillId;

	@Override
	protected boolean readImpl() {
		_skillId = readD();
		return true;
	}

	@Override
	protected void runImpl() {
		Player player = getClient().getActiveChar();
		if (player == null)
			return;

		Clan clan = player.getClan();
		if (clan == null) {
			player.sendActionFailed();
			return;
		}

		if (player.getObjectId() != clan.getLeaderId()) {
			player.sendMessage("You do not have enough privileges to take this action."); // TODO: Offlike msg.
			return;
		}

		// Check if it can be learned.
		int previous = 0;
		int cost = 0;
		switch (_skillId) {
			case 19538: {
				previous = 4;
				cost = 40000;
				break;
			}
			case 19539: {
				previous = 9;
				cost = 30000;
				break;
			}
			case 19540: {
				previous = 11;
				cost = 50000;
				break;
			}
			case 19541: {
				previous = 14;
				cost = 30000;
				break;
			}
			case 19542: {
				previous = 16;
				cost = 50000;
				break;
			}
		}
		if (clan.getReputationScore() < cost) {
			player.sendMessage("Your clan reputation is lower than the requirement."); // TODO: Offlike msg.
			return;
		}
		if (!clan.hasMastery(previous)) {
			player.sendMessage("You need to learn the previous mastery."); // TODO: Offlike msg.
			return;
		}

		// Check if already enabled.
		if (clan.getMasterySkillRemainingTime(_skillId) > 0) {
			clan.removeMasterySkill(_skillId);
			return;
		}

		// Learn.
		clan.incReputation(-cost, false, "Pledge skill activate");
		clan.addMasterySkill(_skillId);
		player.sendPacket(new ExPledgeSkillInfo(_skillId, 1, 1296000, 2));
	}
}
