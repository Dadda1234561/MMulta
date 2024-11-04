package l2s.gameserver.network.l2.c2s.pledge;

import l2s.gameserver.model.Player;
import l2s.gameserver.network.l2.c2s.L2GameClientPacket;
import l2s.gameserver.network.l2.s2c.pledge.ExPledgeMissionInfo;
import l2s.gameserver.network.l2.s2c.pledge.ExPledgeMissionRewardCount;

/**
 * @author Bonux (bonuxq@gmail.com)
 * @date 29.09.2019
 **/
public class RequestPledgeMissionReward extends L2GameClientPacket {
	private int missionId;

	@Override
	protected boolean readImpl() {
		missionId = readD();
		return true;
	}

	@Override
	protected void runImpl() {
		Player activeChar = getClient().getActiveChar();
		if (activeChar == null)
			return;

		if (activeChar.getPledgeMissionList().complete(missionId)) {
			getClient().sendPacket(new ExPledgeMissionRewardCount(activeChar));
			getClient().sendPacket(new ExPledgeMissionInfo(activeChar));
		}
	}
}