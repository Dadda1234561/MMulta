package l2s.gameserver.network.l2.s2c.events.balrog;

import l2s.gameserver.dao.CharacterDAO;
import l2s.gameserver.instancemanager.events.BalrogWarManager;
import l2s.gameserver.network.l2.s2c.L2GameServerPacket;

import java.util.Map;

public class ExBalrogwarShowRanking extends L2GameServerPacket {

    private final Map<Integer, Integer> _rankingData;

    public ExBalrogwarShowRanking() {
        _rankingData = BalrogWarManager.getInstance().getTopPlayers(30);
    }


    @Override
    protected void writeImpl() {
        writeD(_rankingData.size()); // nSize
        int i = 1;
        for (Map.Entry<Integer, Integer> entry : _rankingData.entrySet()) {
            final int playerId = entry.getKey();
            final int score = entry.getValue();
            final String playerName = CharacterDAO.getInstance().getNameByObjectId(playerId, false);

            writeD(i); // nRank
            writeString(playerName); // sName
            writeD(score); // nScore
            i++;
        }
    }
}
