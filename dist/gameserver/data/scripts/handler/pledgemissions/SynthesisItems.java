package handler.pledgemissions;

import l2s.gameserver.listener.Acts;
import l2s.gameserver.listener.CharListener;
import l2s.gameserver.listener.actor.OnActorAct;
import l2s.gameserver.model.Creature;
import l2s.gameserver.templates.item.data.ItemData;
import org.apache.commons.lang3.ArrayUtils;

/**
 * @author Bonux
 **/
public class SynthesisItems extends ProgressPledgeMissionHandler {
	protected static final int[] EMPTY_RESULT_ITEM_IDS = new int[0];

	private class HandlerListeners implements OnActorAct {
		@Override
		public void onAct(Creature actor, String act, Object... args) {
			if (!actor.isPlayer())
				return;

			if (!act.equals(Acts.ITEM_SYNTHESIS_ACT))
				return;

			ItemData resultItem = args.length > 1 && (args[1] instanceof ItemData) ? (ItemData) args[1] : null;
			if (resultItem == null)
				return;

			boolean success = args.length > 2 && (args[2] instanceof Boolean) ? (Boolean) args[2] : false;
			if (!success) // TODO: Проверить на оффе.
				return;

			if (getResultItemIds().length == 0 || ArrayUtils.contains(getResultItemIds(), resultItem.getId()))
				progressMission(actor.getPlayer(), 1, true, -1);
		}
	}

	private final HandlerListeners handlerListeners = new HandlerListeners();

	protected int[] getResultItemIds() {
		return EMPTY_RESULT_ITEM_IDS;
	}

	@Override
	public CharListener getListener() {
		return handlerListeners;
	}
}
