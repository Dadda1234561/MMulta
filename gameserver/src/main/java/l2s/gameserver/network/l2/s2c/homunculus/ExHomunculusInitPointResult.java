package l2s.gameserver.network.l2.s2c.homunculus;

import l2s.gameserver.network.l2.s2c.L2GameServerPacket;
import l2s.gameserver.network.l2.s2c.SystemMessage;

/**
 * @author nexvill
 */
public class ExHomunculusInitPointResult extends L2GameServerPacket
{
	private final boolean _success;
	private final int _type;

	public ExHomunculusInitPointResult(boolean success, int type)
	{
		_success = success;
		_type = type;
	}

	@Override
	protected final void writeImpl()
	{
		writeD(_success); // success
		writeD(_type); // init type
		writeD(_success ? SystemMessage.THE_RECEIVED_UPGRADE_POINTS_ARE_RESET : SystemMessage.NOT_ENOUGH_ITEMS_FOR_RESETTING); // SystemMessageId
	}
}