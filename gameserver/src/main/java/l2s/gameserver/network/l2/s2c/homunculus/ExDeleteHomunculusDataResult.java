package l2s.gameserver.network.l2.s2c.homunculus;

import l2s.gameserver.network.l2.s2c.L2GameServerPacket;
import l2s.gameserver.network.l2.s2c.SystemMessage;

/**
 * @author nexvill
 */
public class ExDeleteHomunculusDataResult extends L2GameServerPacket
{

	public ExDeleteHomunculusDataResult()
	{
		
	}

	@Override
	protected final void writeImpl()
	{
		writeD(1); // 1 - success
		writeD(SystemMessage.THE_HOMUNCULUS_IS_DESTROYED); // SystemMessageId
	}
}