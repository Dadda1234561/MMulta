package l2s.gameserver.network.l2.s2c.herobook;

import l2s.gameserver.model.herobook.HeroBookInfoHolder;
import l2s.gameserver.model.herobook.HeroBookManager;
import l2s.gameserver.network.l2.s2c.L2GameServerPacket;

public class ExHeroBookInfo extends L2GameServerPacket
{
    private final int _level;
    private final int _points;

    public ExHeroBookInfo(HeroBookInfoHolder holder)
    {
        _level = holder.getCurrentLevel();
        _points = Math.min(HeroBookManager.getExpForNextLevel(_level), holder.getCurrentExp());
    }

    @Override
    public void writeImpl()
    {
        writeD(_points);
        writeD(_level);
    }
}
