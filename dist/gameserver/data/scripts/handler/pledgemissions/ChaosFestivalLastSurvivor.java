package handler.pledgemissions;

import l2s.gameserver.listener.CharListener;
import l2s.gameserver.listener.actor.player.OnChaosFestivalFinishBattleListener;
import l2s.gameserver.model.Player;

/**
 * @author Bonux
 **/
public class ChaosFestivalLastSurvivor extends ProgressPledgeMissionHandler {
	private class HandlerListeners implements OnChaosFestivalFinishBattleListener {
		@Override
		public void onChaosFestivalFinishBattle(Player player, boolean winner, boolean lastSurvivor) {
			if (lastSurvivor)
				progressMission(player, 1, true, -1);
		}
	}

	private final HandlerListeners _handlerListeners = new HandlerListeners();

	@Override
	public CharListener getListener() {
		return _handlerListeners;
	}
}
