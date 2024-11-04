package l2s.gameserver.network.l2.s2c.ranking;

import l2s.gameserver.instancemanager.RankManager;
import l2s.gameserver.model.Player;
import l2s.gameserver.model.entity.rank.RankInfo;
import l2s.gameserver.model.entity.rank.enums.RankingGroup;
import l2s.gameserver.model.entity.rank.enums.RankingScope;
import l2s.gameserver.model.entity.rank.enums.RankingType;
import l2s.gameserver.network.l2.s2c.L2GameServerPacket;

import java.util.List;

/**
 * @author nexvill
 */
public class ExRankingCharRankers extends L2GameServerPacket
{
	private final RankingGroup _group;
	private final RankingScope _scope;
	private final int _race;
	private final int _class;

	private final List<RankInfo> _playerList;

	public ExRankingCharRankers(Player player, int group, int scope, int raceId, int classId) {
		_group = RankingGroup.values()[group];
		_scope = RankingScope.values()[scope];
		_race = raceId;
		_class = classId;
		
		_playerList = RankManager.getInstance().getRankList(RankingType.Character, player, _group, _scope, raceId, classId);

		// System.out.println(String.format("[%d][%s][%s][%s][%d][%d]", _playerList.size(),getClass().getSimpleName(), _group.name(), _scope.name(), raceId, classId));
	}

	@Override
	protected final void writeImpl()
	{
		writeC(_group.ordinal()); // cRankingGroup
		writeC(_scope.ordinal()); // cRankingScope
		writeD(_race); // nRace
		writeD(_class); // nClass

		writeD(_playerList.size());
		for (RankInfo info : _playerList)
		{
			final RankInfo prevInfo = RankManager.getInstance().getRankInfo(info.getCharId(), true);
			writeString(info.getCharName());
			writeString(info.getClanName());

			writeD(info.getWorldId());

			writeD(info.getRebirths());
			writeD(info.getClassId());
			writeD(info.getRaceId());

			writeD(info.getServerRank(_group));

			writeD(prevInfo == null ? info.getServerRank() : prevInfo.getServerRank());
			writeD(prevInfo == null ? info.getRaceRank() : prevInfo.getRaceRank());
			writeD(prevInfo == null ? info.getClassRank() : prevInfo.getClassRank());
		}
	}
}