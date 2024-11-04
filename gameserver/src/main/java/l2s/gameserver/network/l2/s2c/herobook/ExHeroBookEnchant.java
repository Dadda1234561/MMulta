package l2s.gameserver.network.l2.s2c.herobook;

import l2s.gameserver.network.l2.s2c.L2GameServerPacket;

public class ExHeroBookEnchant extends L2GameServerPacket
{
    private final int _result;

    public ExHeroBookEnchant(int result)
    {
        _result = result;
    }

    @Override
    public void writeImpl()
    {
        writeD(_result);
    }
}
