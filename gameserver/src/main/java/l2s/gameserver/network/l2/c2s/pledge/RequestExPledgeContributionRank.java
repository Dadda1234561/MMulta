package l2s.gameserver.network.l2.c2s.pledge;

import l2s.gameserver.model.Player;
import l2s.gameserver.network.l2.c2s.L2GameClientPacket;
import l2s.gameserver.network.l2.s2c.pledge.ExPledgeContributionInfo;
import l2s.gameserver.network.l2.s2c.pledge.ExPledgeContributionRank;

/**
 * @author nexvill
 */
public class RequestExPledgeContributionRank extends L2GameClientPacket
{
	private boolean _cycle;
	
	@Override
	protected boolean readImpl()
	{
		_cycle = readC() == 1;
		return true;
	}

	@Override
	protected void runImpl()
	{
		Player activeChar = getClient().getActiveChar();
		if(activeChar == null)
			return;
		
		activeChar.sendPacket(new ExPledgeContributionRank(activeChar, _cycle));
		activeChar.sendPacket(new ExPledgeContributionInfo(activeChar, _cycle));
	}
}