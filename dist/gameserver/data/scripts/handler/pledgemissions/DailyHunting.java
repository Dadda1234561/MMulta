package handler.pledgemissions;

import l2s.gameserver.listener.CharListener;
import l2s.gameserver.listener.actor.OnKillListener;
import l2s.gameserver.model.Creature;
import l2s.gameserver.model.Player;
import org.apache.commons.lang3.ArrayUtils;

/**
 * @author Bonux
 **/
public class DailyHunting extends ProgressPledgeMissionHandler {
	protected static final int[] EMPTY_MONSTER_IDS = new int[0];

	private class HandlerListeners implements OnKillListener {
		@Override
		public void onKill(Creature actor, Creature victim) {
			//TODO: Добавить проверку, получил ли чар опыт за убийство моба.
			Player player = actor.getPlayer();
			if (player != null && victim.isMonster()) {
				if (getMonsterIds().length == 0 || ArrayUtils.contains(getMonsterIds(), victim.getNpcId()))
					progressMission(player, 1, true, victim.getLevel());
			}
		}

		@Override
		public boolean ignorePetOrSummon() {
			return true;
		}
	}

	private final HandlerListeners _handlerListeners = new HandlerListeners();

	protected int[] getMonsterIds() {
		return EMPTY_MONSTER_IDS;
	}

	@Override
	public CharListener getListener() {
		return _handlerListeners;
	}
}
