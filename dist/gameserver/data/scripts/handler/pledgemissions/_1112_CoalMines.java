package handler.pledgemissions;

/**
 * @author Edoo
 * @date 16.05.2020
 * уровень игрока 99+
 * Охота на всех монстов в Заброшеных Рудниках
 **/
public class _1112_CoalMines extends DailyHunting {
	private static final int[] MONSTER_IDS = {
		24470,
		24471,
		24472,
		24473,
		24474,
		24475
	};

	@Override
	protected int[] getMonsterIds() {
		return MONSTER_IDS;
	}
}
