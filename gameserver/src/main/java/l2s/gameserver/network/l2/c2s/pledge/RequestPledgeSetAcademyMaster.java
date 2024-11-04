package l2s.gameserver.network.l2.c2s.pledge;

import l2s.gameserver.model.Player;
import l2s.gameserver.network.l2.c2s.L2GameClientPacket;

public class RequestPledgeSetAcademyMaster extends L2GameClientPacket {

	@Override
	protected boolean readImpl() {
		readD();
		readS(16);
		readS(16);
		return true;
	}

	@Override
	protected void runImpl() {
		Player activeChar = getClient().getActiveChar();
		if (activeChar == null)
			return;

		// Deprecated
	}
}