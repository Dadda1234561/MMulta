package l2s.gameserver.network.l2.c2s.pledge;

import l2s.gameserver.network.l2.c2s.L2GameClientPacket;

/**
 * @author nexvill
 */
public class RequestExPledgeContributionInfo extends L2GameClientPacket
{
	@Override
	protected boolean readImpl()
	{
		return true;
	}

	@Override
	protected void runImpl()
	{
		// called by ExPledgeContribution rank for handle cycle.
	}
}