package l2s.gameserver.network.l2.s2c;

import l2s.gameserver.Config;

public class AllianceCrestPacket extends L2GameServerPacket
{
	private final int clanId;
	private final int crestId;
	private final byte[] data;

	public AllianceCrestPacket(int clanId, int crestId, byte[] data) {
		this.clanId = clanId;
		this.crestId = crestId;
		this.data = data;
	}

	@Override
	protected final void writeImpl() {
		writeD(crestId);
		writeD(clanId);
		writeD(data.length);
		writeD(data.length);
		writeB(data);
	}
}