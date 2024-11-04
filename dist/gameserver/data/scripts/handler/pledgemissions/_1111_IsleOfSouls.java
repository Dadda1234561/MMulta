package handler.pledgemissions;

/**
 * @author Edoo
 * @date 16.05.2020
 * уровень игрока 107+
 * Охота на всех монстов в Алтаре Золота
 **/
public class _1111_IsleOfSouls extends DailyHunting {
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
