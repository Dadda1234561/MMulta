package l2s.gameserver.network.l2.s2c.events.balrog;

import l2s.gameserver.instancemanager.events.BalrogWarManager;
import l2s.gameserver.network.l2.s2c.L2GameServerPacket;

public class ExBalrogwarHud extends L2GameServerPacket {

    private final int _state;
    private final int _step;
    private final int _timeLeft;

    public ExBalrogwarHud()
    {
        final BalrogWarManager _manager = BalrogWarManager.getInstance();

        _state = _manager.getState().ordinal();
        _step = _manager.getProgressStep();
        _timeLeft = _manager.getRemainingTime();
    }

    @Override
    protected void writeImpl() {
        writeD(_state); // nState 4 - close
        writeD(_step); // nProgressStep
        writeD(_timeLeft); // nLeftTime
    }
}
