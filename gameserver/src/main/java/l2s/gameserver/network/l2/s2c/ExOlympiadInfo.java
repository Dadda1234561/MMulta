package l2s.gameserver.network.l2.s2c;

import l2s.gameserver.model.entity.olympiad.Olympiad;

public class ExOlympiadInfo extends L2GameServerPacket {
    private final int _cGameRuleType;
    private final int _timeLeft;

    public ExOlympiadInfo() {
        _cGameRuleType = 0;
        _timeLeft = (int) Olympiad.getMillisToCompEnd() / 1000;
    }

    public ExOlympiadInfo(int cGameRuleType, int timeLeft) {
        _cGameRuleType = cGameRuleType;
        _timeLeft = timeLeft;
    }

    @Override
    protected final void writeImpl() {
        writeC(Olympiad._inCompPeriod ? 1 : 0);
        writeD(_timeLeft);
        writeC(_cGameRuleType);
    }
}