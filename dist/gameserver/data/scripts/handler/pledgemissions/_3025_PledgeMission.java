package handler.pledgemissions;

import l2s.gameserver.listener.Acts;
import l2s.gameserver.listener.CharListener;
import l2s.gameserver.listener.actor.OnActorAct;
import l2s.gameserver.model.Creature;

/**
 * @author Bonux
 * Получить статус дворянина
 * Получите статус дворянина в составе клана.
 **/
public class _3025_PledgeMission extends ProgressPledgeMissionHandler {
	private class HandlerListeners implements OnActorAct {
		@Override
		public void onAct(Creature actor, String act, Object... args) {
			if (!actor.isPlayer())
				return;

			if (!act.equals(Acts.NOBLE_RECEIVE_ACT))
				return;

			progressMission(actor.getPlayer(), 1, true, -1);
		}
	}

	private final HandlerListeners handlerListeners = new HandlerListeners();

	@Override
	public CharListener getListener() {
		return handlerListeners;
	}
}
