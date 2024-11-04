package handler.pledgemissions;

/**
 * @author Bonux (bonuxq@gmail.com)
 * @date 29.09.2019
 * Рейд в поле 95-99
 * Убейте любого из следующих рейдовых боссов в поле 4 раза:
  * Мегалопрепис, Элигос Возмездия, Зетал, Посланник Карамора Гариос, Посланец Тьмы Ахучак, Падший Ангел Тиела
 **/
public class _1012_DailyMission extends DailyHunting {
	private static final int[] MONSTER_IDS = {
		25945, //Мегалопрепис
		25956, //Элигос Возмездия
		25967, //Зетал
		25978, //Посланник Карамора Гариос
		26022, //Посланец Тьмы Ахучак
		26033 //Падший Ангел Тиела
	};

	@Override
	protected int[] getMonsterIds() {
		return MONSTER_IDS;
	}
}
