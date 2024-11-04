package l2s.gameserver.network.l2.s2c.items.autopeel;

import l2s.gameserver.network.l2.s2c.L2GameServerPacket;

public class ExStopItemAutoPeel extends L2GameServerPacket
{
    boolean bResult;

    public ExStopItemAutoPeel(boolean bResult)
    {
        this.bResult = bResult;
    }

    @Override
    protected final void writeImpl()
    {
        writeC(bResult ? 1 : 0);
    }
}
