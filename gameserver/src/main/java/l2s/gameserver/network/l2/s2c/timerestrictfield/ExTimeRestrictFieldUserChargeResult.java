package l2s.gameserver.network.l2.s2c.timerestrictfield;

import l2s.gameserver.network.l2.s2c.L2GameServerPacket;

/**
 * @author nexvill
 */
public class ExTimeRestrictFieldUserChargeResult extends L2GameServerPacket
{
	private final int _fieldId;
	private final int _remainTime;
	private final int _resultRefillTime;
	private final int _resultChargeTime;

	public ExTimeRestrictFieldUserChargeResult(int fieldId, int remainTime, int resultRefillTime, int resultChargeTime)
	{
		_fieldId = fieldId;
		_remainTime = remainTime;
		_resultRefillTime = resultRefillTime;
		_resultChargeTime = resultChargeTime;
	}

	@Override
	protected final void writeImpl()
	{
		writeD(_fieldId);
		writeD(_remainTime);
		writeD(_resultRefillTime);
		writeD(_resultChargeTime);
	}
}