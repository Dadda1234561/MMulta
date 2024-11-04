package l2s.gameserver.network.l2.s2c;

import l2s.gameserver.model.Player;
import l2s.gameserver.model.items.ItemInfo;
import l2s.gameserver.model.items.ItemInstance;

import java.util.ArrayList;
import java.util.List;

/**
 * @author Bonux
 */
public class ExResponseCommissionItemList extends L2GameServerPacket {
	private final int _sendType;
	private final List<ItemInfo> _items = new ArrayList<ItemInfo>();

	public ExResponseCommissionItemList(int sendType, Player player) {
		_sendType = sendType;

		ItemInstance[] items = player.getInventory().getItems();
		for (ItemInstance item : items) {
			if (item.canBePrivateStore(player))
				_items.add(new ItemInfo(item, item.getTemplate().isBlocked(player, item)));
		}
	}

	protected void writeImpl() {
		writeC(_sendType);
		if (_sendType == 2) {
			writeD(_items.size());
			writeD(_items.size());
			for (ItemInfo item : _items) {
				writeItemInfo(item);
			}
		} else {
			writeD(0);
			writeD(0);
		}
	}
}