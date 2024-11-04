package handler.pledgemissions;

/**
 * @author Bonux (bonuxq@gmail.com)
 * @date 29.09.2019
 * Временная зона - 2 этап
 * Убейте любого из следующих боссов объединенной временной зоны 2 раза:
 * Логово Октависа (экстремальный): Октавис
 * Логово Таути: Таути
 * Логово Таути (экстремальный): Таути
 * Внутри Твердыни Мессии: Камиль
 **/
public class _1017_DailyMission extends DailyHunting {
	private static final int[] MONSTER_IDS = {
		29212, //Октавис
		29236, // Таути обычная
		29237, // Таути экстрим
		26236 // Камиль
	};

	@Override
	protected int[] getMonsterIds() {
		return MONSTER_IDS;
	}
}
