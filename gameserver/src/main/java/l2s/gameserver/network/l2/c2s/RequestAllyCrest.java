package l2s.gameserver.network.l2.c2s;

import l2s.gameserver.cache.CrestCache;
import l2s.gameserver.network.l2.s2c.AllianceCrestPacket;

public class RequestAllyCrest extends L2GameClientPacket
{
	// format: cd

	private int serverId, crestId, allyId, clanId;

	@Override
	protected boolean readImpl()
	{
		serverId = readD(); // Server ID
		crestId = readD();
		allyId = readD(); // Ally ID
		clanId = readD(); // Clan ID
		return true;
	}

	@Override
	protected void runImpl()
	{
		if (crestId == 0)
			return;
		byte[] data = CrestCache.getInstance().getAllyCrest(crestId);
		if (data != null) {
			sendPacket(new AllianceCrestPacket(clanId, crestId, data));
		}
	}
}