package l2s.gameserver.network.l2.s2c;

public class ExItemScore extends L2GameServerPacket {

    private final int _gearScore;

    public ExItemScore(int gearScore) {
        _gearScore = gearScore;
    }

    @Override
    protected void writeImpl() {
        writeD(-_gearScore);
    }
}
