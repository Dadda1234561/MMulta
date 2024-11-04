package handler.pledgemissions;

import l2s.gameserver.listener.Acts;
import l2s.gameserver.listener.CharListener;
import l2s.gameserver.listener.actor.OnActorAct;
import l2s.gameserver.model.Creature;

/**
 * @author Bonux
 * Получить почетный статус
 * Получите почетный статус в составе клана.
 **/
public class _3026_PledgeMission extends ProgressPledgeMissionHandler {
	private class HandlerListeners implements OnActorAct {
		@Override
		public void onAct(Creature actor, String act, Object... args) {
			if (!actor.isPlayer())
				return;

			if (!act.equals(Acts.HONORABLE_NOBLE_RECEIVE_ACT))
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
