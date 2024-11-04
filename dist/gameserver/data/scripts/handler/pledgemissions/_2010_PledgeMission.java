package handler.pledgemissions;

import l2s.gameserver.listener.CharListener;
import l2s.gameserver.listener.actor.player.OnParticipateInCastleSiegeListener;
import l2s.gameserver.model.Player;
import l2s.gameserver.model.entity.events.impl.CastleSiegeEvent;
import l2s.gameserver.model.pledge.Clan;

/**
 * @author Bonux
 * Успешная осада
 * Примите участие в осаде и добейтесь 1 победы в атаке.
 **/
public class _2010_PledgeMission extends ProgressPledgeMissionHandler {
	private class HandlerListeners implements OnParticipateInCastleSiegeListener {
		@Override
		public void onParticipateInCastleSiege(Player player, CastleSiegeEvent siegeEvent) {
			Clan clan = player.getClan();
			if (clan == null)
				return;

			if (siegeEvent.getSiegeClan(CastleSiegeEvent.ATTACKERS, clan) == null)
				return;

			progressMission(player, 1, true, -1);
		}
	}

	private final HandlerListeners handlerListeners = new HandlerListeners();

	@Override
	public CharListener getListener() {
		return handlerListeners;
	}
}
