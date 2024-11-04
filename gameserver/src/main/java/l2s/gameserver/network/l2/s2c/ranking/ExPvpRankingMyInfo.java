package l2s.gameserver.network.l2.s2c.ranking;

import l2s.gameserver.instancemanager.RankManager;
import l2s.gameserver.model.Player;
import l2s.gameserver.model.entity.rank.RankInfo;
import l2s.gameserver.model.entity.rank.enums.RankingType;
import l2s.gameserver.network.l2.s2c.L2GameServerPacket;

public class ExPvpRankingMyInfo extends L2GameServerPacket {

    private final boolean _bGearScore;
    private final int _points;
    private final int _currRank;
    private final int _prevRank;
    private final int _kills;
    private final int _deaths;

    public ExPvpRankingMyInfo(boolean isCombatPower, Player player) {
        _bGearScore = isCombatPower;
        RankInfo info = RankManager.getInstance().getRankInfo(_bGearScore ? RankingType.CombatPower : RankingType.Character, player.getObjectId(), false);

        if (info == null) {
            _points = 0;
            _currRank = 0;
            _prevRank = 0;
            _kills = 0;
            _deaths = 0;
        } else {
            _points = _bGearScore ? info.getGearScore() : (int) info.getPvPPoints();
            _currRank = _bGearScore ? info.getGearScoreRank() : info.getPvPRank();
            _prevRank = _bGearScore ? info.getPrevGearScoreRank() : info.getPrevPvpRank();
            _kills = _bGearScore ? 0 : info.getPvpKills();
            _deaths = _bGearScore ? 0 : info.getPvpDeaths();
        }
    }

    @Override
    protected void writeImpl() {
        writeC(_bGearScore ? 0x01 : 0x00); // Custom: 0x00 = PvP, 0x01 = Combat Power
        writeQ(_points); // PvP Point
        writeD(_currRank); // Rank
        writeD(_prevRank); // Prev Rank
        writeD(_kills); // Kill Count
        writeD(_deaths); // Die Count
    }

}
