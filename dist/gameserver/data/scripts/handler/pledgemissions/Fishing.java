package handler.pledgemissions;

import l2s.gameserver.listener.CharListener;
import l2s.gameserver.listener.actor.player.OnFishingListener;
import l2s.gameserver.model.Player;
import l2s.gameserver.templates.item.data.ItemData;

import java.util.List;

/**
 * @author Bonux
 **/
public class Fishing extends ProgressPledgeMissionHandler {
	private class HandlerListeners implements OnFishingListener {
		@Override
		public void onFishing(Player player, List<ItemData> fishRewards, boolean success) {
			if (!success) // TODO: Проверить на оффе.
				return;

			progressMission(player, 1, true, -1);
		}
	}

	private final HandlerListeners _handlerListeners = new HandlerListeners();

	@Override
	public CharListener getListener() {
		return _handlerListeners;
	}
}
