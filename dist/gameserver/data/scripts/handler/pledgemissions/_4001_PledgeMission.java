package handler.pledgemissions;

import l2s.gameserver.model.Player;
import l2s.gameserver.model.actor.instances.player.PledgeMission;
import l2s.gameserver.templates.pledgemissions.PledgeMissionStatus;

/**
 * @author Bonux (bonuxq@gmail.com)
 * @date 28.10.2019
 * Использование Свитка Фреи
 * Используйте любой из следующих свитков 24 раза:
 * "Свиток Ветра Фреи"
 * "Свиток Шторма Фреи"
 **/
public class _4001_PledgeMission extends UseItems {
	private static final int[] ITEM_IDS = {
			40227, // Свиток Ветра Фреи
			40231, // Свиток Ветра Фреи
			47382, // Свиток Ветра Фреи
			27673, // Свиток Шторма Фреи
			47428 // Свиток Шторма Фреи
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
