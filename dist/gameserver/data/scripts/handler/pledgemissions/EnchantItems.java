package handler.pledgemissions;

import l2s.gameserver.listener.CharListener;
import l2s.gameserver.listener.actor.player.OnEnchantItemListener;
import l2s.gameserver.model.Player;
import l2s.gameserver.model.items.ItemInstance;
import org.apache.commons.lang3.ArrayUtils;

/**
 * @author Bonux
 **/
public class EnchantItems extends ProgressPledgeMissionHandler {
	protected static final int[] EMPTY_ENCHANTED_ITEM_IDS = new int[0];

	private class HandlerListeners implements OnEnchantItemListener {
		@Override
		public void onEnchantItem(Player player, ItemInstance item, boolean success) {
			if (!success) // TODO: Проверить на оффе.
				return;

			if(getEnchantLevel() > 0 && item.getEnchantLevel() != getEnchantLevel())
				return;

			if (getEnchantedItemIds().length == 0 || ArrayUtils.contains(getEnchantedItemIds(), item.getItemId()))
				progressMission(player, 1, true, -1);
		}
	}

	private final HandlerListeners handlerListeners = new HandlerListeners();

	protected int[] getEnchantedItemIds() {
		return EMPTY_ENCHANTED_ITEM_IDS;
	}

	protected int getEnchantLevel() {
		return -1;
	}

	@Override
	public CharListener getListener() {
		return handlerListeners;
	}
}
