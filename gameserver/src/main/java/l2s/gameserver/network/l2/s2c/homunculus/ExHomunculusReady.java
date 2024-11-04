package l2s.gameserver.network.l2.s2c.homunculus;

import l2s.gameserver.network.l2.s2c.L2GameServerPacket;

/**
 * @author nexvill
 */
public class ExHomunculusReady extends L2GameServerPacket
{
	private boolean _enabled;

	public ExHomunculusReady(boolean enabled)
	{
		_enabled = enabled;
	}

	@Override
	protected final void writeImpl()
	{
		writeC(_enabled);
	}
}