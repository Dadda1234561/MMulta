package handler.pledgemissions;

import l2s.gameserver.listener.Acts;
import l2s.gameserver.listener.CharListener;
import l2s.gameserver.listener.actor.OnActorAct;
import l2s.gameserver.model.Creature;
import l2s.gameserver.templates.item.support.variation.VariationStone;
import org.apache.commons.lang3.ArrayUtils;

/**
 * @author Bonux
 **/
public class AugmentItems extends ProgressPledgeMissionHandler {
	protected static final int[] EMPTY_STONE_ITEM_IDS = new int[0];

	private class HandlerListeners implements OnActorAct {
		@Override
		public void onAct(Creature actor, String act, Object... args) {
			if (!actor.isPlayer())
				return;

			if (!act.equals(Acts.ADD_AUGMENTATION))
				return;

			VariationStone stone = args.length > 1 && (args[1] instanceof VariationStone) ? (VariationStone) args[1] : null;
			if (stone == null)
				return;

			if (getStoneItemIds().length == 0 || ArrayUtils.contains(getStoneItemIds(), stone.getId()))
				progressMission(actor.getPlayer(), 1, true, -1);
		}
	}

	private final HandlerListeners handlerListeners = new HandlerListeners();

	protected int[] getStoneItemIds() {
		return EMPTY_STONE_ITEM_IDS;
	}

	@Override
	public CharListener getListener() {
		return handlerListeners;
	}
}
