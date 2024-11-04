package l2s.gameserver.network.l2.c2s.pledge;

import l2s.gameserver.model.Player;
import l2s.gameserver.model.pledge.Clan;
import l2s.gameserver.network.l2.c2s.L2GameClientPacket;
import l2s.gameserver.network.l2.s2c.pledge.ExPledgeShowInfoUpdate;

/**
 * @author Bonux (bonuxq@gmail.com)
 * @date 25.09.2019
 **/
public class RequestExPledgeAnnounce extends L2GameClientPacket {
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

		activeChar.sendPacket(new ExPledgeShowInfoUpdate(clan));
	}
}
