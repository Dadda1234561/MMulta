package l2s.gameserver.network.l2.s2c.pledge;

import l2s.gameserver.Config;
import l2s.gameserver.network.l2.s2c.L2GameServerPacket;

public class PledgeCrestPacket extends L2GameServerPacket
{
	private int _crestId;
	private int _crestSize;
	private byte[] _data;
	private int _clanId = 0;

	public PledgeCrestPacket(int crestId, byte[] data)
	{
		_crestId = crestId;
		_data = data;
		_crestSize = _data.length;
	}
	public PledgeCrestPacket(int crestId, byte[] data, int clanId)
	{
		_crestId = crestId;
		_data = data;
		_crestSize = _data.length;
		_clanId = clanId;
	}

	@Override
	protected final void writeImpl()
	{
//		writeD(Config.REQUEST_ID);  ???? )))
		writeD(_clanId);
		writeD(_crestId);
		writeD(_crestSize);
		writeD(_crestSize);
		writeB(_data);
	}
}