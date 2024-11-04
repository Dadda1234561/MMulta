package l2s.gameserver.network.l2.s2c.ranking;

import l2s.gameserver.instancemanager.RankManager;
import l2s.gameserver.model.Player;
import l2s.gameserver.model.entity.rank.RankInfo;
import l2s.gameserver.model.entity.rank.enums.RankingGroup;
import l2s.gameserver.model.entity.rank.enums.RankingScope;
import l2s.gameserver.model.entity.rank.enums.RankingType;
import l2s.gameserver.network.l2.s2c.L2GameServerPacket;

import java.util.List;

public class ExPvpRankingList extends L2GameServerPacket {

    private final boolean _isCombatPower;
    private final int _currSeason, _rankingGroup, _rankingScope, _race;
    private final List<RankInfo> _rankingEntries;

    public ExPvpRankingList(boolean isCombatPower, int group, int scope, int race, Player player) {
        _isCombatPower = isCombatPower;
        _currSeason = 0;
        _rankingGroup = group;
        _rankingScope = scope;
        _race = player.getRace().ordinal();
        RankingType type = isCombatPower ? RankingType.CombatPower : RankingType.PVP;
        RankingGroup rankGroup = RankingGroup.values()[_rankingGroup];
        RankingScope rankScope = RankingScope.values()[_rankingScope];
        int classId = player.getClassId().getId();
        _rankingEntries = RankManager.getInstance().getRankList(type, player, rankGroup, rankScope, race, classId);
    }

    @Override
    protected void writeImpl() {
        writeC(_isCombatPower ? 0x01 : 0x00);
        writeC(_currSeason); // current season
        writeC(_rankingGroup); // ranking group
        writeC(_rankingScope); // ranking scope
        writeD(_race); // race
        writeD(_rankingEntries.size()); // size
        for (RankInfo entry : _rankingEntries)
        {
            writeString(entry.getCharName());
            writeString(entry.getClanName());
            writeD(entry.getRebirths());
            writeD(entry.getRaceId());
            writeD(entry.getClassId());
            writeQ(_isCombatPower ? entry.getGearScore(): entry.getPvPPoints()); // points
            writeD(_isCombatPower ? entry.getGearScoreRank() : entry.getPvPRank()); // rank
            writeD(_isCombatPower ? entry.getPrevGearScoreRank() : entry.getPrevPvpRank()); // prev rank
            writeD(_isCombatPower ? 0 : entry.getPvpKills()); // kill count
            writeD(_isCombatPower ? 0 : entry.getPvpDeaths()); // death count
        }
    }
}
