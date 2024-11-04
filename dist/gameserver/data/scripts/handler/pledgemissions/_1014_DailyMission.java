package handler.pledgemissions;

/**
 * @author Bonux (bonuxq@gmail.com)
 * @date 29.09.2019
 * Временная зона - 1 этап
 * Убейте любого из следующих боссов объединенной временной зоны 2 раза:
 * Кристальная Тюрьма: Валлок, Логово Октависа: Октавис
 **/
public class _1014_DailyMission extends DailyHunting {
	private static final int[] MONSTER_IDS = {
		29218, //Валлок
		29194, //Октавис
		29212 //Октавис
	};

	@Override
	protected int[] getMonsterIds() {
		return MONSTER_IDS;
	}
}
