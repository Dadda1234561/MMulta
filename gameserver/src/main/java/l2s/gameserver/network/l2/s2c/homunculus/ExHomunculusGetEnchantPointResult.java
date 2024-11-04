package l2s.gameserver.network.l2.s2c.homunculus;

import l2s.gameserver.network.l2.s2c.L2GameServerPacket;
import l2s.gameserver.network.l2.s2c.SystemMessage;

/**
 * @author nexvill
 */
public class ExHomunculusGetEnchantPointResult extends L2GameServerPacket
{
	private final int _enchantType;

	public ExHomunculusGetEnchantPointResult(int enchantType)
	{
		_enchantType = enchantType;
	}

	@Override
	protected final void writeImpl()
	{
		if (_enchantType != 2)
		{
			writeD(1); // success
			writeD(_enchantType);
			writeD(SystemMessage.YOUVE_OBTAINED_UPGRADE_POINTS);
		}
		else
		{
			writeD(1);
			writeD(_enchantType);
			writeD(SystemMessage.VP_ADDED);
		}
	}
}