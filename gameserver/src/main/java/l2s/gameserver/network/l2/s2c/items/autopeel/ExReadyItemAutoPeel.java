package l2s.gameserver.network.l2.s2c.items.autopeel;


import l2s.gameserver.network.l2.s2c.L2GameServerPacket;

public class ExReadyItemAutoPeel extends L2GameServerPacket
{
    boolean bResult;
    int nItemSid;

    public ExReadyItemAutoPeel(boolean bResult, int nItemSid)
    {
        this.bResult = bResult;
        this.nItemSid = nItemSid;
    }

    @Override
    protected void writeImpl()
    {
        writeC(bResult ? 1 : 0);
        writeD(nItemSid);
    }
}
