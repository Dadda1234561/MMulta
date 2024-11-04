package handler.pledgemissions;

import l2s.gameserver.listener.CharListener;
import l2s.gameserver.listener.actor.player.OnOlympiadFinishBattleListener;
import l2s.gameserver.model.Player;
import l2s.gameserver.model.entity.olympiad.OlympiadGame;

/**
 * @author Bonux
 **/
public class OlympiadLoser extends ProgressPledgeMissionHandler {
	private class HandlerListeners implements OnOlympiadFinishBattleListener {
		@Override
		public void onOlympiadFinishBattle(Player player, OlympiadGame olympiadGame, boolean winner) {
			if (!winner)
				progressMission(player, 1, true, -1);
		}
	}

	private final HandlerListeners _handlerListeners = new HandlerListeners();

	@Override
	public CharListener getListener() {
		return _handlerListeners;
	}
}
