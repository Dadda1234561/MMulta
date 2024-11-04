package l2s.gameserver.network.l2.s2c.herobook;

import l2s.gameserver.network.l2.s2c.L2GameServerPacket;

public class ExHeroBookCharge extends L2GameServerPacket
{
    private final boolean _success;

    public ExHeroBookCharge(boolean success)
    {
        _success = success;
    }

    @Override
    public void writeImpl()
    {
        writeD(_success);
    }
}