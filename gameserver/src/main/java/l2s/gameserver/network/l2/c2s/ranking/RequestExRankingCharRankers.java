package l2s.gameserver.network.l2.c2s.ranking;

import l2s.gameserver.model.Player;
import l2s.gameserver.network.l2.c2s.L2GameClientPacket;
import l2s.gameserver.network.l2.s2c.ranking.ExRankingCharRankers;

/**
 * @author nexvill
 */
public class RequestExRankingCharRankers extends L2GameClientPacket
{
	private int _group, _scope, _race, _class;
	@Override
	protected boolean readImpl()
	{
		_group = readC(); // tab Id
		_scope = readC(); // All or personal
		_race = readD();
		_class = readD();
		return true;
	}

	@Override
	protected void runImpl()
	{
		Player activeChar = getClient().getActiveChar();
		if(activeChar == null)
			return;
		
		activeChar.sendPacket(new ExRankingCharRankers(activeChar, _group, _scope, _race, _class));
	}
}