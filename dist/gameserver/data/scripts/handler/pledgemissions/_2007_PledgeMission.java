package handler.pledgemissions;

/**
 * @author Bonux (bonuxq@gmail.com)
 * @date 29.09.2019
 * Борьба за Трон Героев
 * Уничтожьте следующего босса у Трона Героев 1 раз:
 * Дарион
 **/
public class _2007_PledgeMission extends DailyHunting {
	private static final int[] MONSTER_IDS = {
		26249 //Дарион
	};

	@Override
	protected int[] getMonsterIds() {
		return MONSTER_IDS;
	}
}
