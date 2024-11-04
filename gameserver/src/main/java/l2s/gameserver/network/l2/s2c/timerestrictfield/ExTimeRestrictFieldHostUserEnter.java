package l2s.gameserver.network.l2.s2c.timerestrictfield;

import l2s.gameserver.network.l2.s2c.L2GameServerPacket;

public class ExTimeRestrictFieldHostUserEnter extends L2GameServerPacket
{

	private final int nResult = 1;
	private final int nEnterFieldID;

	public ExTimeRestrictFieldHostUserEnter(int nEnterFieldID)
	{
		this.nEnterFieldID = nEnterFieldID;
	}

	@Override
	protected void writeImpl()
	{
		writeD(nResult); // nResult
		writeD(nEnterFieldID); // nEnterFieldID
	}
}
