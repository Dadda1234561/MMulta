package l2s.gameserver.network.l2.s2c.worldexchange;

import l2s.gameserver.network.l2.s2c.L2GameServerPacket;

public class ExWorldExchangeBuyItem extends L2GameServerPacket
{
	public static ExWorldExchangeBuyItem FAIL = new ExWorldExchangeBuyItem(-1, -1L, (byte) 0);
	private final int _itemObjectID;
	private final long _itemAmount;
	private final byte _type;

	public ExWorldExchangeBuyItem(int itemObjectID, long itemAmount, byte type)
	{
		_itemObjectID = itemObjectID;
		_itemAmount = itemAmount;
		_type = type;
	}

	@Override
	public void writeImpl()
	{
		writeD(_itemObjectID); // nItemClassID
		writeQ(_itemAmount); // qAmount
		writeC(_type); // cSuccess
	}
}
