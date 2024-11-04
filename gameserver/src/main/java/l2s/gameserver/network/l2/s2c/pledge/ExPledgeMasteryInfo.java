package l2s.gameserver.network.l2.s2c.pledge;

import l2s.gameserver.data.xml.holder.ClanMasteryHolder;
import l2s.gameserver.model.Player;
import l2s.gameserver.model.pledge.Clan;
import l2s.gameserver.network.l2.s2c.L2GameServerPacket;
import l2s.gameserver.templates.ClanMastery;

import java.util.Collection;

/**
 * @author Bonux (bonuxq@gmail.com)
 * @date 23.09.2019
 **/
public class ExPledgeMasteryInfo extends L2GameServerPacket {
	private final Clan clan;

	public ExPledgeMasteryInfo(Player player) {
		clan = player.getClan();
	}

	@Override
	protected void writeImpl() {
		if (clan == null) {
			writeD(0);
			writeD(0);
			writeD(0);
			return;
		}

		writeD(clan.getUsedDevelopmentPoints()); // Consumed development points
		writeD(clan.getTotalDevelopmentPoints()); // Total development points
		Collection<ClanMastery> clanMasteries = ClanMasteryHolder.getInstance().getClanMasteries();
		writeD(clanMasteries.size()); // Mastery count
		for (ClanMastery mastery : clanMasteries) {
			final int id = mastery.getId();
			writeD(id); // Mastery
			writeD(0x00); // ?

			boolean available = true;
			if (clan.getLevel() < mastery.getClanLevel()) {
				available = false;
			} else {
				final int previous = mastery.getPreviousMastery();
				final int previousAlt = mastery.getPreviousMasteryAlt();
				if (previousAlt > 0) {
					available = clan.hasMastery(previous) || clan.hasMastery(previousAlt);
				} else if (previous > 0) {
					available = clan.hasMastery(previous);
				}
			}

			writeC(clan.hasMastery(id) ? 0x02 : available ? 0x01 : 0x00); // Availability.
		}
	}
}
