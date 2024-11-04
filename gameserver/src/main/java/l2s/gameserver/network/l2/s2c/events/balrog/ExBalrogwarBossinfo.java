package l2s.gameserver.network.l2.s2c.events.balrog;

import l2s.gameserver.instancemanager.events.BalrogWarManager;
import l2s.gameserver.model.BossInfo;
import l2s.gameserver.model.BossState;
import l2s.gameserver.network.l2.s2c.L2GameServerPacket;

import java.util.List;

public class ExBalrogwarBossinfo extends L2GameServerPacket {

    private final List<BossInfo> _bossInfos;
    private final int _finalBossId;
    private final BossState _finalBossState;

    public ExBalrogwarBossinfo() {
        final BalrogWarManager _manager = BalrogWarManager.getInstance();

        _bossInfos = _manager.getBossInfos();
        _finalBossId = _manager.getFinalBoss() == null ? _manager.getFinalBossId() : _manager.getFinalBoss().getNpcId();
        _finalBossState = _manager.getFinalBossState();
    }

    @Override
    protected void writeImpl() {

        for (int i = 0; i < 5; i++) {
            writeD(i >= _bossInfos.size() ? 0 : _bossInfos.get(i).getBossId());
        }

        for (int i = 0; i < 5; i++) {
            writeD(i >= _bossInfos.size() ? 0 : _bossInfos.get(i).getState());
        }

        writeD(1000000 + _finalBossId); // nFinalBossClassID
        writeD(_finalBossState == null ? 0 : _finalBossState.ordinal()); // nFinalBossState
    }
}
