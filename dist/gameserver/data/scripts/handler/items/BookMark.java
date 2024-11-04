package handler.items;

import l2s.gameserver.model.Player;
import l2s.gameserver.model.items.ItemInstance;

public class BookMark extends SimpleItemHandler
{
	private static final int ADD_CAPACITY = 1;
	private static final int MAX_BOOKMARK_CAPACITY = 12;

	@Override
	protected boolean useItemImpl(Player player, ItemInstance item, boolean ctrl)
	{
		if (player == null)
			return false;

		int currentCapacity = player.getBookMarkList().getCapacity();
		if (currentCapacity >= MAX_BOOKMARK_CAPACITY) {
			player.sendMessage(String.format(player.isLangRus()
					? "Вы достигли максимального кол-ва слотов в Книге Свободного Телепорта." : "You have reached the maximum number of slots in the Free Teleport Book."));
			player.sendActionFailed();
			return false;
		}

		if (!reduceItem(player, item))
			return false;

		sendUseMessage(player, item);
		player.getBookMarkList().incCapacity(ADD_CAPACITY);

		return true;
	}

}