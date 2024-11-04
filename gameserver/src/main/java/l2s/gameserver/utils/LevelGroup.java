package l2s.gameserver.utils;

/**
 * @author sharp on 14.02.2023
 * t.me/sharp1que
 */
public class LevelGroup
{
    private int minLevel;
    private int maxLevel;

    public LevelGroup(int minLevel, int maxLevel)
    {
        this.minLevel = minLevel;
        this.maxLevel = maxLevel;
    }

    public int getMinLevel()
    {
        return minLevel;
    }

    public int getMaxLevel()
    {
        return maxLevel;
    }
}
