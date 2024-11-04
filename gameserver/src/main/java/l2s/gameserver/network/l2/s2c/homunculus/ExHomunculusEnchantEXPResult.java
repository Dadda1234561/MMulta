package l2s.gameserver.network.l2.s2c.homunculus;

import l2s.gameserver.network.l2.s2c.L2GameServerPacket;
import l2s.gameserver.network.l2.s2c.SystemMessage;

/**
 * @author nexvill
 */
public class ExHomunculusEnchantEXPResult extends L2GameServerPacket
{
	private final boolean _success, _newLevel;

	public ExHomunculusEnchantEXPResult(boolean success, boolean newLevel)
	{
		_success = success;
		_newLevel = newLevel;
	}

	@Override
	protected final void writeImpl()
	{
		if (!_success)
		{
			writeD(0);
			writeD(SystemMessage.NOT_ENOUGH_UPGRADE_POINTS);
		}
		else if (!_newLevel)
		{
			writeD(1); // success
			writeD(0); // SystemMessageId
		}
		else
		{
			writeD(1);
			writeD(SystemMessage.THE_HOMUNCULUS_LEVEL_IS_INCREASED);
		}
	}
}