package l2s.gameserver.model;

/**
 * @author sharp on 08.01.2023
 * t.me/sharp1que
 */
public class EnchantFailInfo
{
    private final int itemId;
    private final int itemCount;


    public EnchantFailInfo(int itemId, int itemCount)
    {
        this.itemId = itemId;
        this.itemCount = itemCount;
    }

    public int itemId()
    {
        return itemId;
    }

    public int itemCount()
    {
        return itemCount;
    }
}
