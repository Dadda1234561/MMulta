package handler.pledgemissions;

/**
 * @author Bonux (bonuxq@gmail.com)
 * @date 29.09.2019
 * Трон Героев: Изгнание Голдберга
 * Уничтожьте указанного босса у Трона Героев 1 раз: Голдберг
 **/
public class _2018_DailyMission extends DailyHunting {
	private static final int[] MONSTER_IDS = {
		26250 //Голдберг
	};

	@Override
	protected int[] getMonsterIds() {
		return MONSTER_IDS;
	}
}
