package l2s.gameserver.network.l2.s2c.pledge;

import l2s.gameserver.model.pledge.Clan;
import l2s.gameserver.network.l2.s2c.L2GameServerPacket;

/**
 * @author Bonux (bonuxq@gmail.com)
 * @date 25.09.2019
 **/
public class ExPledgeShowInfoUpdate extends L2GameServerPacket {
	private final int clanId;
	private final int nextLevelCost;
	private final int maxNormalMembers;
	private final int maxEliteMembers;

	public ExPledgeShowInfoUpdate(Clan clan) {
		clanId = clan.getClanId();
		nextLevelCost = clan.getLevelUpRepCost();
		maxNormalMembers = clan.getSubPledgeLimit(Clan.SUBUNIT_MAIN_CLAN);
		maxEliteMembers = clan.getSubPledgeLimit(Clan.SUBUNIT_ELITE_CLAN);
	}

	@Override
	protected void writeImpl() {
		writeD(clanId); // Clan ID
		writeD(nextLevelCost); // Next level cost
		writeD(maxNormalMembers); // Max pledge members
		writeD(maxEliteMembers); // Max elite members
	}
}