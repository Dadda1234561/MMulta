package l2s.gameserver.network.l2.s2c.homunculus;

import l2s.gameserver.network.l2.s2c.L2GameServerPacket;
import l2s.gameserver.network.l2.s2c.SystemMessage;

/**
 * @author nexvill
 */
public class ExHomunculusSummonResult extends L2GameServerPacket
{

	public ExHomunculusSummonResult()
	{
		
	}

	@Override
	protected final void writeImpl()
	{
		writeD(1); // 1 - success
		writeD(SystemMessage.A_NEW_HOMUNCULUS_IS_CREATED); // SystemMessageId
	}
}