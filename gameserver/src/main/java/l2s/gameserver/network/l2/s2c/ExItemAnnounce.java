package l2s.gameserver.network.l2.s2c;

import l2s.gameserver.model.ItemAnnounceType;

/**
 * @author Bonux
**/
public class ExItemAnnounce extends L2GameServerPacket
{
	private final ItemAnnounceType _type;
	private final String _name;
	private final int _itemId;
	private final int _enchantLevel;
	private final int _fromItemId ;

	public ExItemAnnounce(ItemAnnounceType type, String name, int itemId)
	{
		_type = type;
		_name = name;
		_itemId = itemId;
		_enchantLevel = 0;
		_fromItemId = 0;
	}

	public ExItemAnnounce(String name, int itemId, int enchantLevel)
	{
		_type = null;
		_name = name;
		_itemId = itemId;
		_enchantLevel = enchantLevel;
		_fromItemId = 0;
	}

	@Override
	protected final void writeImpl()
	{
		writeC(_type == null ? 0x00 : _type.ordinal());	// cType
		writeString(_name);
		writeD(_itemId); // nItemClassID
		writeC(_enchantLevel); // cEnchantCount
		writeD(_fromItemId);	// nFromItemClassID
	}
}