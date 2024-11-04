package handler.pledgemissions;

/**
 * @author Bonux (bonuxq@gmail.com)
 * @date 29.09.2019
 * Временная зона - 3 этап
 * Убейте любого из следующих боссов объединенной временной зоны 2 раза:
 * Тюрьма Изгнанников Тьмы (экстремальный): Спасия
 * Гробница Последнего Императора (экстремальный): Скарлет Ван Халиша
 * Крепость Снежной Королевы (экстремальный) : Фрея
 **/
public class _1018_PledgeMission extends DailyHunting {
	private static final int[] MONSTER_IDS = {
		25867, //Спасия
		29047, // Скарлет Ван Халиша
		29180 // Фрея
	};

	@Override
	protected int[] getMonsterIds() {
		return MONSTER_IDS;
	}
}
