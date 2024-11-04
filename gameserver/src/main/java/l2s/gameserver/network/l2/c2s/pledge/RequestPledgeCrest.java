package l2s.gameserver.network.l2.c2s.pledge;

import l2s.gameserver.cache.CrestCache;
import l2s.gameserver.model.Player;
import l2s.gameserver.network.l2.c2s.L2GameClientPacket;
import l2s.gameserver.network.l2.s2c.pledge.PledgeCrestPacket;

public class RequestPledgeCrest extends L2GameClientPacket
{
	// format: cd

	private int _clanId;
	private int _crestId;

	@Override
	protected boolean readImpl()
	{
		_clanId = readD();
		_crestId = readD();
		return true;
	}

	@Override
	protected void runImpl()
	{
		Player activeChar = getClient().getActiveChar();
		if(activeChar == null)
			return;
		if(_crestId == 0 || _clanId == 0)
			return;
		byte[] data = CrestCache.getInstance().getPledgeCrest(_crestId);
		if(data != null)
		{
			PledgeCrestPacket pc = new PledgeCrestPacket(_crestId, data, _clanId);
			sendPacket(pc);
		}
	}
}