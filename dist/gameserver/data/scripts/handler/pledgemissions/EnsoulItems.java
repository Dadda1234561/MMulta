package handler.pledgemissions;

import l2s.gameserver.listener.Acts;
import l2s.gameserver.listener.CharListener;
import l2s.gameserver.listener.actor.OnActorAct;
import l2s.gameserver.model.Creature;
import l2s.gameserver.model.items.ItemInstance;
import org.apache.commons.lang3.ArrayUtils;

import java.util.List;

/**
 * @author Bonux
 **/
public class EnsoulItems extends ProgressPledgeMissionHandler {
	protected static final int[] EMPTY_ENSOUL_ITEM_IDS = new int[0];

	private class HandlerListeners implements OnActorAct {
		@Override
		@SuppressWarnings("unchecked")
		public void onAct(Creature actor, String act, Object... args) {
			if (!actor.isPlayer())
				return;

			if (!act.equals(Acts.ADD_ENSOUL))
				return;

			List<ItemInstance> successEnsouls = args.length > 1 && (args[1] instanceof List) ? (List<ItemInstance>) args[1] : null;
			if (successEnsouls == null)
				return;

			for (ItemInstance ensoulItem : successEnsouls) {
				if (getEnsoulItemIds().length == 0 || ArrayUtils.contains(getEnsoulItemIds(), ensoulItem.getItemId()))
					progressMission(actor.getPlayer(), 1, true, -1);
			}
		}
	}

	private final HandlerListeners handlerListeners = new HandlerListeners();

	protected int[] getEnsoulItemIds() {
		return EMPTY_ENSOUL_ITEM_IDS;
	}

	@Override
	public CharListener getListener() {
		return handlerListeners;
	}
}
