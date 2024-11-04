package l2s.gameserver.network.l2.s2c.ranking;

import l2s.gameserver.instancemanager.RankManager;
import l2s.gameserver.model.Player;
import l2s.gameserver.model.entity.rank.RankInfo;
import l2s.gameserver.network.l2.s2c.L2GameServerPacket;

/**
 * @author nexvill
 */
public class ExRankingCharInfo extends L2GameServerPacket
{
	private final RankInfo _currentRank;
	private final RankInfo _prevRank;

	public ExRankingCharInfo(Player player)
	{
		_currentRank = RankManager.getInstance().getRankInfo(player,false);
		_prevRank = RankManager.getInstance().getRankInfo(player, true);
	}

	@Override
	protected final void writeImpl()
	{
		writeD(_currentRank.getServerRank()); // server rank
		writeD(_currentRank.getRaceRank()); // race rank

		writeD(_prevRank.getServerRank()); // server rank snapshot
		writeD(_prevRank.getRaceRank()); // race rank snapshot

		writeD(_currentRank.getClassRank()); // class rank
		writeD(_prevRank.getClassRank()); // class rank snapshot
	}
}