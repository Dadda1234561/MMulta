package l2s.gameserver.network.l2.s2c.ranking;

import l2s.gameserver.instancemanager.RankManager;
import l2s.gameserver.model.Player;
import l2s.gameserver.model.entity.rank.RankHistoryRecord;
import l2s.gameserver.network.l2.s2c.L2GameServerPacket;

import java.util.List;

/**
 * @author nexvill
 */
public class ExRankingCharHistory extends L2GameServerPacket
{

	final List<RankHistoryRecord> _rankHistory;

	public ExRankingCharHistory(Player player)
	{
		_rankHistory = RankManager.getInstance().getRankHistory(player);
	}

	@Override
	protected final void writeImpl()
	{
		writeD(_rankHistory.size());
		for (RankHistoryRecord rankInfo : _rankHistory)
		{
			writeD(rankInfo.getDate());
			writeD(rankInfo.getServerRank());
			writeQ(rankInfo.getRebirths());
		}
	}
}