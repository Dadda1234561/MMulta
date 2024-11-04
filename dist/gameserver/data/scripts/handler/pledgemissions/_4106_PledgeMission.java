package handler.pledgemissions;

import l2s.gameserver.model.Player;
import l2s.gameserver.model.actor.instances.player.PledgeMission;
import l2s.gameserver.templates.pledgemissions.PledgeMissionStatus;

/**
 * @author Edoo
 * @date 16.05.2020
 **/
public class _4106_PledgeMission extends UseItems {
	private static final int[] ITEM_IDS = {
			80061,80062,80063,80753,80754,80755,80817,80818,80819,80820,80832,81012
	};

	@Override
	public PledgeMissionStatus getStatus(Player player, PledgeMission mission) {
		if (true) // TODO: Добавить проверку на активность ивента после реализации самого ивента.
			return PledgeMissionStatus.NOT_AVAILABLE;
		return super.getStatus(player, mission);
	}

	@Override
	protected int[] getItemIds() {
		return ITEM_IDS;
	}
}
