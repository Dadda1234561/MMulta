package l2s.gameserver.network.l2.c2s.pledge;

import java.util.Arrays;

import gnu.trove.map.TIntObjectMap;

import l2s.gameserver.cache.CrestCache;
import l2s.gameserver.model.Player;
import l2s.gameserver.network.l2.c2s.L2GameClientPacket;
import l2s.gameserver.network.l2.s2c.pledge.ExPledgeEmblem;

/**
 * @author Bonux
**/
public class RequestPledgeCrestLarge extends L2GameClientPacket
{
	// format: chdd
	private int _crestId;
	private int _pledgeId;

	@Override
	protected boolean readImpl()
	{
		_crestId = readD();
		_pledgeId = readD();
		return true;
	}

	@Override
	protected void runImpl()
	{
		Player activeChar = getClient().getActiveChar();
		if(activeChar == null)
			return;

		if(_crestId == 0)
			return;

		if(_pledgeId == 0)
			return;

		TIntObjectMap<byte[]> data = CrestCache.getInstance().getPledgeCrestLarge(_crestId);
		if(data != null)
		{
			int totalSize = CrestCache.getByteMapSize(data);
			int[] keys = data.keys();
			Arrays.sort(keys);
			for(int key : keys)
				sendPacket(new ExPledgeEmblem(_pledgeId, _crestId, key, totalSize, data.get(key)));
		}
	}
}