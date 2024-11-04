package l2s.gameserver.templates.dailymissions;

import java.util.ArrayList;
import java.util.List;

import l2s.gameserver.handler.dailymissions.DailyMissionHandlerHolder;
import l2s.gameserver.handler.dailymissions.IDailyMissionHandler;

public class DailyMissionTemplate
{
    private final int _id;
    private final IDailyMissionHandler _handler;
    private final int _value;
    private final int _minLevel;
    private final int _maxLevel;
    private final int _completedMission;
    private final int _minRebirth;
    private final int _clanReputationReward;
    private final int _fameReward;
    private final List<DailyRewardTemplate> _rewards = new ArrayList<DailyRewardTemplate>();

    public DailyMissionTemplate(int id, String handler, int value, int minLevel, int maxLevel, int completedMission, int minRebirth, int clanReputationReward, int fameReward)
    {
        _id = id;
        _handler = DailyMissionHandlerHolder.getInstance().getHandler(handler);
        _value = value;
        _minLevel = minLevel;
        _maxLevel = maxLevel;
        _completedMission = completedMission;
        _minRebirth = minRebirth;
        _clanReputationReward = clanReputationReward;
        _fameReward = fameReward;
    }

    public int getId()
    {
        return _id;
    }

    public IDailyMissionHandler getHandler()
    {
        return _handler;
    }

    public int getValue()
    {
        return _value;
    }

    public int getMinLevel()
    {
        return _minLevel;
    }

    public int getMaxLevel()
    {
        return _maxLevel;
    }

    public int getCompletedMission()
    {
        return _completedMission;
    }

    public int getMinRebirth() {
        return _minRebirth;
    }

    public int getClanReputationReward() {
        return _clanReputationReward;
    }

    public int getFameReward() {
        return _fameReward;
    }

    public void addReward(DailyRewardTemplate reward)
    {
        _rewards.add(reward);
    }

    public DailyRewardTemplate[] getRewards()
    {
        return _rewards.toArray(new DailyRewardTemplate[_rewards.size()]);
    }
}