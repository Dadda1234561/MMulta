package l2s.gameserver.network.l2.s2c.events;

import l2s.gameserver.network.l2.s2c.L2GameServerPacket;

public class ExLetterCollectorUiLauncher extends L2GameServerPacket
{
	private final boolean activate;
	private final int minLevel;

	public ExLetterCollectorUiLauncher(boolean activate, int minLevel)
	{
		this.activate = activate;
		this.minLevel = minLevel;
	}

	@Override
	protected void writeImpl()
	{
		writeC(activate);
		writeD(minLevel);
	}
}
