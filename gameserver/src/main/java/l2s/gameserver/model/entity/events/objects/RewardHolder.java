package l2s.gameserver.model.entity.events.objects;

/**
 * @author sharp on 13.02.2023
 * t.me/sharp1que
 */
public class RewardHolder
{
    private final int itemId;
    private final int itemCnt;
    private final int grade;

    public RewardHolder(int itemId, int itemCnt, int grade)
    {
        this.itemId = itemId;
        this.itemCnt = itemCnt;
        this.grade = grade;
    }

    public int getItemId()
    {
        return itemId;
    }

    public int getItemCnt()
    {
        return itemCnt;
    }

    public int getGrade()
    {
        return grade;
    }
}
