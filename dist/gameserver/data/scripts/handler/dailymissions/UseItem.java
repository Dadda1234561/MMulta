package handler.dailymissions;

import l2s.gameserver.listener.CharListener;
import l2s.gameserver.listener.actor.playable.OnUseItemListener;
import l2s.gameserver.model.Playable;
import l2s.gameserver.model.items.ItemInstance;
import org.apache.commons.lang3.ArrayUtils;

public class UseItem extends ProgressDailyMissionHandler {
	protected static final int[] EMPTY_ITEM_IDS = new int[0];

	private class HandlerListeners implements OnUseItemListener {
		@Override
		public void onUseItem(Playable playable, ItemInstance item) {
			if (!playable.isPlayer())
				return;

			if (getItemIds().length == 0 || ArrayUtils.contains(getItemIds(), item.getItemId()))
				progressMission(playable.getPlayer(), 1, true, 1, 1);
		}
	}

	private final HandlerListeners handlerListeners = new HandlerListeners();

	protected int[] getItemIds() {
		return EMPTY_ITEM_IDS;
	}

	@Override
	public CharListener getListener() {
		return handlerListeners;
	}
}
