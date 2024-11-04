package handler.pledgemissions;

/**
 * @author Edoo
 * @date 16.05.2020
 * Уровень игрока 100+
 * Охота на всех монстов на острове бурь
 **/
public class _1109_StormIsle extends DailyHunting {
	private static final int[] MONSTER_IDS = {
		24427,
		24428,
		24429,
		24430,
		24431,
		24432
	};

	@Override
	protected int[] getMonsterIds() {
		return MONSTER_IDS;
	}
}
