package l2s.gameserver.network.l2.s2c.pledge;

import l2s.gameserver.network.l2.s2c.L2GameServerPacket;

/**
 * @author GodWorld
 * @reworked by Bonux
**/
public class ExPledgeWaitingListAlarm extends L2GameServerPacket
{
	public static final L2GameServerPacket STATIC = new ExPledgeWaitingListAlarm();

	@Override
	protected void writeImpl()
	{
	}
}