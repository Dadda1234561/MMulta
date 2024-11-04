package l2s.gameserver.network.l2.s2c;

public class ExOlympiadMatchMakingResult extends L2GameServerPacket
{
    int _result;
    public ExOlympiadMatchMakingResult(int result){
        _result = result;
    }
    @Override
    protected void writeImpl() {
        writeC(true);
        writeD(_result);
    }
}
