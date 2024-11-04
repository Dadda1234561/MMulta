package handler.pledgemissions;

/**
 * @author Bonux (bonuxq@gmail.com)
 * @date 29.09.2019
 * Пространственный Барьер
 * Уничтожьте указанного монстра в Пространственном Барьере 100 раз:
 * Людоед Иного Измерения
 **/
public class _2005_PledgeMission extends DailyHunting {
	private static final int[] MONSTER_IDS = {
		23465 //Людоед Иного Измерения
	};

	@Override
	protected int[] getMonsterIds() {
		return MONSTER_IDS;
	}
}
