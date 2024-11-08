package l2s.gameserver.network.l2.s2c;

import l2s.gameserver.model.items.ItemInstance;
import l2s.gameserver.model.items.LockType;

/**
 * @author VISTALL
 * @date 1:02/23.02.2011
 */
public class ExQuestItemListPacket extends L2GameServerPacket
{
	private int _size;
	private ItemInstance[] _items;
	private final int _type;

	private LockType _lockType;
	private int[] _lockItems;

	public ExQuestItemListPacket(int type, int size, ItemInstance[] t, LockType lockType, int[] lockItems)
	{
		_type = type;
		_size = size;
		_items = t;
		_lockType = lockType;
		_lockItems = lockItems;
	}

	@Override
	protected void writeImpl()
	{
		writeC(_type);
		if(_type == 2) {
			writeD(_size);
		}
		else {
			writeH(0);
		}

		writeD(_size);
		for(ItemInstance temp : _items)
		{
			if(!temp.getTemplate().isQuest())
				continue;

			writeItemInfo(temp);
		}
		writeInventoryBlock(_lockType, _lockItems);
	}
}
