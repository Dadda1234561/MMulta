package l2s.gameserver.network.l2.s2c.timerestrictfield;

import l2s.gameserver.network.l2.s2c.L2GameServerPacket;

public class ExTimeRestrictFieldHostUserLeave extends L2GameServerPacket
{
	private final boolean isSuccess;
	private final int fieldId;
	private final int nextFieldId;

	public ExTimeRestrictFieldHostUserLeave(boolean isSuccess, int fieldId, int nextFieldId)
	{
		this.isSuccess = isSuccess;
		this.fieldId = fieldId;
		this.nextFieldId = nextFieldId;
	}

	@Override
	protected void writeImpl()
	{
		writeD(isSuccess); // nResult
		writeD(fieldId); // nLeaveFieldID
		writeD(nextFieldId); // nNextEnterFieldID
	}
}
