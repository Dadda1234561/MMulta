package l2s.gameserver.network.l2.s2c.pledge;

import l2s.gameserver.network.l2.s2c.L2GameServerPacket;

/**
 * @author Bonux
**/
public class ExPledgeCount extends L2GameServerPacket
{
	private final int _count;

	public ExPledgeCount(int count)
	{
		_count = count;
	}

	@Override
	protected void writeImpl()
	{
		writeD(_count);
	}
}