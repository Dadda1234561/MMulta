package l2s.gameserver.network.l2.c2s.pledge;

import l2s.gameserver.model.Player;
import l2s.gameserver.model.pledge.Clan;
import l2s.gameserver.network.l2.c2s.L2GameClientPacket;

/**
 * @author Bonux (bonuxq@gmail.com)
 * @date 25.09.2019
 **/
public class RequestExPledgeLevelUp extends L2GameClientPacket {
	@Override
	protected boolean readImpl() {
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

		if(!clan.levelUpClan(player)) {
			player.sendActionFailed();
			return;
		}
	}
}