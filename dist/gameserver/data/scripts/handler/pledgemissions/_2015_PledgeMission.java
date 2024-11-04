package handler.pledgemissions;

import l2s.gameserver.listener.CharListener;
import l2s.gameserver.listener.actor.player.OnOlympiadFinishBattleListener;
import l2s.gameserver.model.Player;
import l2s.gameserver.model.actor.instances.player.PledgeMission;
import l2s.gameserver.model.entity.olympiad.CompType;
import l2s.gameserver.model.entity.olympiad.OlympiadGame;

/**
 * @author Bonux
 **/
public class _2015_PledgeMission extends ProgressPledgeMissionHandler {
	private class HandlerListeners implements OnOlympiadFinishBattleListener {
		@Override
		public void onOlympiadFinishBattle(Player player, OlympiadGame olympiadGame, boolean winner) {
			if (winner) {
				player.setVar(String.format(OLY_WIN_MISSION_VAR, olympiadGame.getType().ordinal()), true);
			}
		}
	}

	private static final String OLY_WIN_MISSION_VAR = "2015_pm_oly_win_%d";

	private final HandlerListeners handlerListeners = new HandlerListeners();

	@Override
	public int getProgress(Player player, PledgeMission mission) {
		if (!player.getVarBoolean(String.format(OLY_WIN_MISSION_VAR, CompType.CLASSED.ordinal())))
			return 0;
		if (!player.getVarBoolean(String.format(OLY_WIN_MISSION_VAR, CompType.NON_CLASSED.ordinal())))
			return 0;
		return 1;
	}

	@Override
	public CharListener getListener() {
		return handlerListeners;
	}
}
