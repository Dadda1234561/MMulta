package l2s.gameserver.network.l2.s2c.homunculus;

import l2s.gameserver.network.l2.s2c.L2GameServerPacket;
import l2s.gameserver.network.l2.s2c.SystemMessage;

/**
 * @author nexvill
 */
public class ExHomunculusCreateStartResult extends L2GameServerPacket
{
	
	public ExHomunculusCreateStartResult()
	{
	}

	@Override
	protected final void writeImpl()
	{
		writeD(1); // 1 - success
		writeD(SystemMessage.YOUVE_SEALED_A_HOMUNCULUS_HEART_IN_ORDER_TO_CREATE_IT_YOUR_BLOOD_SPIRIT_AND_TEARS_ARE_REQUIRED); // SystemMessageId
	}
}