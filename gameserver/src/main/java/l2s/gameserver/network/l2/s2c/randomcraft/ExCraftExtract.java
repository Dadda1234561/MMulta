package l2s.gameserver.network.l2.s2c.randomcraft;

import l2s.gameserver.model.Player;
import l2s.gameserver.model.items.ItemInstance;
import l2s.gameserver.network.l2.s2c.L2GameServerPacket;

public class ExCraftExtract extends L2GameServerPacket
{
	private final Player _player;
	private final int _count;
	private final int[] _objectId, _itemCount;

	public ExCraftExtract(Player player, int count, int[] objectId, int[] itemCount)
	{
		_player = player;
		_count = count;
		_objectId = objectId;
		_itemCount = itemCount;
	}

	@Override
	protected final void writeImpl()
	{
		int points = 0;
		int fee = 0;
		for (int i = 0; i < _count; i++)
		{
			final ItemInstance item = _player.getInventory().getItemByObjectId(_objectId[i]);
			if (item != null)
			{
				points += item.getTemplate().getGrindPoint() * _itemCount[i];
				points *= (item.getTemplate().getAdditionalName().contains("Sealed")
						|| item.getTemplate().getAdditionalName().contains("Imprint")) ? 1 : 2.35;
				fee += item.getTemplate().getGrindCommission() * _itemCount[i];
			}
		}
		if (_player.getAdena() < fee)
			return;

		for (int i = 0; i < _count; i++)
		{
			final ItemInstance item = _player.getInventory().getItemByObjectId(_objectId[i]);
			if (item != null)
			{
				_player.getInventory().destroyItem(item, _itemCount[i]);
			}

		}
		_player.getInventory().destroyItemByItemId(57, fee);
		_player.setCraftGaugePoints(_player.getCraftGaugePoints() + points, null);
		writeC(0);
	}
}