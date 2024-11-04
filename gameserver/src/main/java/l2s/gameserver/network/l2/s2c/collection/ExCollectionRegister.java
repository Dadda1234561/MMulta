package l2s.gameserver.network.l2.s2c.collection;

import l2s.gameserver.data.xml.holder.CollectionsHolder;
import l2s.gameserver.model.Player;
import l2s.gameserver.model.items.ItemInstance;
import l2s.gameserver.network.l2.s2c.L2GameServerPacket;
import l2s.gameserver.templates.CollectionTemplate;
import l2s.gameserver.templates.item.data.CollectionItemData;

/**
 * @author nexvill
 */
public class ExCollectionRegister extends L2GameServerPacket
{
	private Player _player;
	private int _collectionId, _slotId;
	private ItemInstance _item;
	
	public ExCollectionRegister(Player player, int collectionId, int slotId, ItemInstance item)
	{
		_player = player;
		_collectionId = collectionId;
		_slotId = slotId;
		_item = item;
	}

	@Override
	protected final void writeImpl()
	{
		CollectionTemplate collection = CollectionsHolder.getInstance().getCollection(_collectionId);
		CollectionTemplate newCollection = new CollectionTemplate(_collectionId, collection.getTabId(), 0);
		long itemCount = 0;
		for (CollectionItemData temp : collection.getItems())
		{
			if ((temp.getId() == _item.getItemId()) || (temp.getAlternativeId() == _item.getItemId()))
			{
				if ((temp.getEnchantLevel() == _item.getEnchantLevel()) && (temp.getCount() <= _item.getCount()))
				{
					CollectionItemData itemData = new CollectionItemData(_item.getItemId(), temp.getCount(), temp.getEnchantLevel(), 0, _slotId);
					newCollection.addItem(itemData);
					_player.getCollectionList().add(newCollection);
					itemCount = temp.getCount();
					_player.getInventory().destroyItem(_item, itemCount);
					break;
				}
				else
					return;
			}
		}
		
		writeH(_collectionId); // collection id
		writeC(1); // activate?
		writeC(0); // bRecursiveReward

		writeH(_item == null ? 0x00 : 0x0F); //FIXME: find exact value, packet checks only if diff from (curr buff pos - buff pos at start < this val)

		writeC(_slotId); // cSlotIndex // 1
		writeD(_item.getItemId()); // nItemClassID // 4
		writeC(_item.getEnchantLevel()); // cEnchant - заточка шмотки // 1
		writeC(_item.isBlessed() ? 1 : 0); // bBless - блеснута ли // 1
		writeC(0);  // cBlessCondition - нужен ли предмет блеснутым // 1
		writeD((int) itemCount); // nAmount // 4
	}
}