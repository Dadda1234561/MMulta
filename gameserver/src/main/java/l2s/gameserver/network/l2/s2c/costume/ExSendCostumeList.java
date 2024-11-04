package l2s.gameserver.network.l2.s2c.costume;

import l2s.gameserver.network.l2.s2c.L2GameServerPacket;

import java.util.List;

public class ExSendCostumeList extends L2GameServerPacket
{

	private final List<Integer> costumeList;

	public ExSendCostumeList(List<Integer> costumeIds)
	{
		this.costumeList = costumeIds;
	}

	@Override
	protected void writeImpl()
	{
		writeD(costumeList.size());
		for(int costumeId : costumeList)
		{
			writeD(costumeId);
			writeQ(1L);
			writeC(-1);
			writeC(-1);
		}
	}
}
