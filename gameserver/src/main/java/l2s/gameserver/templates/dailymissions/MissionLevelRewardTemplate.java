package l2s.gameserver.templates.dailymissions;

import java.util.ArrayList;
import java.util.List;

import l2s.gameserver.templates.item.data.ItemData;
import l2s.gameserver.templates.item.data.MissionLevelRewardData;

public class MissionLevelRewardTemplate
{
    private final int _month;
    private final int _year;
    private final int _maxRewardLvl;
    private final ItemData _finalReward;
    private List<MissionLevelRewardData> _rewardData = new ArrayList<>();

    public MissionLevelRewardTemplate(int month, int year, int maxRewardLvl, ItemData finalReward)
    {
        _month = month;
        _year = year;
        _maxRewardLvl = maxRewardLvl;
        _finalReward = finalReward;
    }

    public int getMonth()
    {
        return _month;
    }

    public int getYear()
    {
        return _year;
    }

    public int getMaxRewardLvl()
    {
        return _maxRewardLvl;
    }

    public ItemData getFinalReward()
    {
        return _finalReward;
    }

    public void addReward(MissionLevelRewardData data)
    {
        _rewardData.add(data);
    }

    public List<MissionLevelRewardData> getRewards()
    {
        return _rewardData;
    }

    public int additionalRewardsSize()
    {
        int size = 0;
        for (int i = 0; i < _rewardData.size(); i++)
        {
            if (_rewardData.get(i).getAdditionalReward().getId() != 0)
            {
                size++;
            }
        }
        return size;
    }
}
