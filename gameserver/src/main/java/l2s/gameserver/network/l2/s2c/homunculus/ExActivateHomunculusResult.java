package l2s.gameserver.network.l2.s2c.homunculus;

import l2s.gameserver.network.l2.s2c.L2GameServerPacket;
import l2s.gameserver.network.l2.s2c.SystemMessage;

/**
 * @author nexvill
 */
public class ExActivateHomunculusResult extends L2GameServerPacket
{
	private final boolean _activate;

	public ExActivateHomunculusResult(boolean activate)
	{
		_activate = activate;
	}

	@Override
	protected final void writeImpl()
	{
		if (!_activate)
		{
			writeD(1); // success
			writeC(0); // activate
			writeD(SystemMessage.THE_RELATIONS_ARE_BROKEN);
		}
		else
		{
			writeD(1);
			writeC(1);
			writeD(SystemMessage.THE_RELATIONS_ARE_BEING_ESTABLISHED);
		}
	}
}