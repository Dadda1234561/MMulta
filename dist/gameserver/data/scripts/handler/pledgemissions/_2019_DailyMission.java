package handler.pledgemissions;

/**
 * @author Bonux (bonuxq@gmail.com)
 * @date 29.09.2019
 * Полевой босс 106-110
 * Убейте следующего босса на объединенном поле 4 раза: Орфен, Лилит,Анаким
 **/
public class _2019_DailyMission extends DailyHunting {
	private static final int[] MONSTER_IDS = {
		29325, //Орфен
		29336, //Лилит
		29348 //Анаким
	};

	@Override
	protected int[] getMonsterIds() {
		return MONSTER_IDS;
	}
}
