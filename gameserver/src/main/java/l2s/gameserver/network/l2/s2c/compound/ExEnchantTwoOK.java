package l2s.gameserver.network.l2.s2c.compound;

import l2s.gameserver.network.l2.s2c.L2GameServerPacket;

/**
 * @author Bonux
**/
public final class ExEnchantTwoOK extends L2GameServerPacket
{
	public static final L2GameServerPacket STATIC = new ExEnchantTwoOK();

	public ExEnchantTwoOK()
	{
		//
	}

	@Override
	protected void writeImpl()
	{
		writeD(0);	// success percent (if 0 - takes from dat, if 1 - will be 0.01)
		//
	}
}