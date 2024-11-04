package handler.pledgemissions;

import l2s.gameserver.data.xml.holder.FishDataHolder;
import l2s.gameserver.listener.CharListener;
import l2s.gameserver.listener.actor.player.OnFishingListener;
import l2s.gameserver.model.Player;
import l2s.gameserver.templates.item.data.ItemData;

import java.util.List;

/**
 * @author Bonux
 **/
public class ReceiveFishOnFishing extends ProgressPledgeMissionHandler {
	private class HandlerListeners implements OnFishingListener {
		@Override
		public void onFishing(Player player, List<ItemData> fishRewards, boolean success) {
			if (!success) // TODO: Проверить на оффе.
				return;

			long fishesCount = 0;
			for (ItemData fishReward : fishRewards) {
				if (FishDataHolder.getInstance().isFish(fishReward.getId()))
					fishesCount += fishReward.getCount();
			}
			if (fishesCount > 0)
				progressMission(player, (int) fishesCount, true, -1);
		}
	}

	private final HandlerListeners handlerListeners = new HandlerListeners();

	@Override
	public CharListener getListener() {
		return handlerListeners;
	}
}
