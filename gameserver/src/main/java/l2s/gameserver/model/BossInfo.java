package l2s.gameserver.model;

import l2s.gameserver.model.instances.NpcInstance;

public class BossInfo
{
    private final NpcInstance _boss;
    private BossState _state;

    public BossInfo(NpcInstance boss, BossState state)
    {
        this._boss = boss;
        this._state = state;
    }

    public void setState(BossState state)
    {
        _state = state;
    }

    public int getState()
    {
        return _state.ordinal();
    }

    public NpcInstance getNpc()
    {
        return _boss;
    }

    public int getNpcId()
    {
        return _boss.getNpcId();
    }

    public int getBossId()
    {
        return 1000000 + _boss.getNpcId();
    }
}
