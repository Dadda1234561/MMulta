package l2s.gameserver.network.l2.c2s.pledge;

import l2s.gameserver.model.Player;
import l2s.gameserver.model.pledge.Clan;
import l2s.gameserver.network.l2.c2s.L2GameClientPacket;
import l2s.gameserver.network.l2.s2c.pledge.ExPledgeSkillInfo;

/**
 * @author Mobius
 **/
public class RequestExPledgeSkillInfo extends L2GameClientPacket {
	private int skillId;
	private int skillLevel;

	@Override
	protected boolean readImpl() {
		skillId = readD();
		skillLevel = readD();
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

		int previous = 0;
		switch (skillId) {
			case 19538: {
				previous = 4;
				break;
			}
			case 19539: {
				previous = 9;
				break;
			}
			case 19540: {
				previous = 11;
				break;
			}
			case 19541: {
				previous = 14;
				break;
			}
			case 19542: {
				previous = 16;
				break;
			}
		}
		int time = -1;
		int available = 0;
		final int remainingTime = clan.getMasterySkillRemainingTime(skillId);
		if (remainingTime > 0) {
			time = remainingTime / 1000;
			available = 2;
		} else if (clan.hasMastery(previous)) {
			available = 1;
		}
		activeChar.sendPacket(new ExPledgeSkillInfo(skillId, skillLevel, time, available));
	}
}
