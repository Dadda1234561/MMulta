package l2s.gameserver.network.l2.s2c.homunculus;

import l2s.gameserver.network.l2.s2c.L2GameServerPacket;
import l2s.gameserver.network.l2.s2c.SystemMessage;

/**
 * @author nexvill
 */
public class ExHomunculusInsertResult extends L2GameServerPacket
{
	private final int _type;
	private final boolean _success;

	public ExHomunculusInsertResult(int type)
	{
		_success = true;
		_type = type;
	}

	public ExHomunculusInsertResult(boolean success, int type)
	{
		_success = success;
		_type = type;
	}

	@Override
	protected final void writeImpl()
	{
		writeD(_success);
		switch (_type) {
			case 0:
				writeD(_success ? SystemMessage.THE_HOMUNCULUS_TAKES_YOUR_BLOOD_HP : SystemMessage.NOT_ENOUGH_HP);
				break;
			case 1:
				writeD(_success ? SystemMessage.THE_HOMUNCULUS_TAKES_YOUR_SPIRIT_SP : SystemMessage.YOU_DO_NOT_HAVE_ENOUGH_SP_FOR_THIS);
				break;
			case 2:
				writeD(_success ? SystemMessage.THE_HOMUNCULUS_TAKES_YOUR_TEARS_VP : SystemMessage.VITALITY_IS_FULLY_EXHAUSTED);
				break;
		}
	}
}