package handler.pledgemissions;

/**
 * @author Bonux (bonuxq@gmail.com)
 * @date 29.09.2019
 * Рейд в поле 106-110
 * Убейте любого из следующих полевых рейдовых боссов 4 раза:
 * Падшая Атропа, Падший Арбор, Дух Времени Арахина, Дух Времени Тизураки, Злой Магикус, Керпаус
 **/
public class _1019_DailyMission extends DailyHunting {
	private static final int[] MONSTER_IDS = {
		26372, // Падшая Атропа
		26373, // Падший Арбор
		26380, // Дух Времени Арахина
		26381, // Дух Времени Тизураки
		26044, // Злой Магикус
		26045 // Керпаус
	};

	@Override
	protected int[] getMonsterIds() {
		return MONSTER_IDS;
	}
}
