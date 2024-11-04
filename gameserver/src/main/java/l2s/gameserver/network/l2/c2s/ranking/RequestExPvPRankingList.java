package l2s.gameserver.network.l2.c2s.ranking;

import l2s.gameserver.model.Player;
import l2s.gameserver.network.l2.c2s.L2GameClientPacket;
import l2s.gameserver.network.l2.s2c.ranking.ExPvpRankingList;

public class RequestExPvPRankingList extends L2GameClientPacket {

    private int _type, _season;
    private int _group, _scope, _race;

    @Override
    protected boolean readImpl() throws Exception {
        _type = readC(); //
        _season = readC(); // season
        _group = readC(); // rankingGroup
        _scope = readC(); // cRankingScope
        _race = readD(); // nRace
        return true;
    }

    @Override
    protected void runImpl() throws Exception {
        Player player = getClient().getActiveChar();
        if (player == null) {
            return;
        }

        boolean bGearScore = _type == 1;
        player.sendPacket(new ExPvpRankingList(bGearScore, _group, _scope, _race, player));
    }
}
