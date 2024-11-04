package handler.pledgemissions;

import l2s.gameserver.listener.CharListener;
import l2s.gameserver.listener.actor.player.OnQuestFinishListener;
import l2s.gameserver.model.Player;
import org.apache.commons.lang3.ArrayUtils;

/**
 * @author Bonux
 **/
public class QuestComplete extends ProgressPledgeMissionHandler {
	protected static final int[] EMPTY_QUEST_IDS = new int[0];

	private class HandlerListeners implements OnQuestFinishListener {
		@Override
		public void onQuestFinish(Player player, int questId) {
			if (getQuestIds().length == 0 || ArrayUtils.contains(getQuestIds(), questId))
				progressMission(player, 1, true, -1);
		}
	}

	private final HandlerListeners _handlerListeners = new HandlerListeners();

	protected int[] getQuestIds() {
		return EMPTY_QUEST_IDS;
	}

	@Override
	public CharListener getListener() {
		return _handlerListeners;
	}
}
