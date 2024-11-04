package l2s.gameserver.network.l2.c2s.ranking;

import l2s.gameserver.network.l2.c2s.L2GameClientPacket;
import l2s.gameserver.network.l2.s2c.ranking.ExOlympiadHeroAndLegendInfo;

/**
 * @author nexvill
 */
public class RequestExOlympiadHeroAndLegendInfo extends L2GameClientPacket
{
	@Override
	protected boolean readImpl()
	{
		return true;
	}

	@Override
	protected void runImpl()
	{
		sendPacket(new ExOlympiadHeroAndLegendInfo());
	}
}
