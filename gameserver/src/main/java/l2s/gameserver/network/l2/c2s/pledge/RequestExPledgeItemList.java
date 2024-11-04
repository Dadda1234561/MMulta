package l2s.gameserver.network.l2.c2s.pledge;

import l2s.gameserver.model.Player;
import l2s.gameserver.network.l2.c2s.L2GameClientPacket;
import l2s.gameserver.network.l2.s2c.pledge.ExPledgeItemList;

/**
 * @author Bonux (bonuxq@gmail.com)
 * @date 25.09.2019
 **/
public class RequestExPledgeItemList extends L2GameClientPacket {
	@Override
	protected boolean readImpl() {
		return true;
	}

	@Override
	protected void runImpl() {
		Player activeChar = getClient().getActiveChar();
		if (activeChar == null)
			return;

		if (activeChar.getClan() == null) {
			activeChar.sendActionFailed();
			return;
		}

		activeChar.sendPacket(new ExPledgeItemList(activeChar));
	}
}