package l2s.gameserver.network.l2.c2s.ranking;

import l2s.gameserver.model.Player;
import l2s.gameserver.network.l2.c2s.L2GameClientPacket;
import l2s.gameserver.network.l2.s2c.ranking.ExPvpRankingMyInfo;

public class RequestExPvPRankingMyInfo extends L2GameClientPacket {

    private int _type;

    @Override
    protected boolean readImpl() throws Exception {
        _type = (byte) readC();
        return true;
    }

    @Override
    protected void runImpl() throws Exception {
        Player player = getClient().getActiveChar();
        if (player == null) {
            return;
        }

        player.sendPacket(new ExPvpRankingMyInfo(_type == 1, player));
    }
}
