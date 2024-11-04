package l2s.gameserver.network.l2.s2c.pledge;

import l2s.gameserver.model.Player;
import l2s.gameserver.network.l2.s2c.L2GameServerPacket;

/**
 * @author Bonux (bonuxq@gmail.com)
 * @date 29.09.2019
 **/
public class ExPledgeMissionRewardCount extends L2GameServerPacket {
	private final int doneMissionsCount;
	private final int availableMissionsCount;

	public ExPledgeMissionRewardCount(Player player) {
		doneMissionsCount = player.getPledgeMissionList().getDoneMissionsCount();
		availableMissionsCount = player.getPledgeMissionList().getAvailableMissionsCount();
	}

	protected void writeImpl() {
		writeD(Math.min(availableMissionsCount, doneMissionsCount)); // Received missions rewards.
		writeD(availableMissionsCount); // Available missions rewards. 18 - for noble, 20 - for honnorable noble.
	}
}