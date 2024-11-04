package handler.pledgemissions;

/**
 * @author Edoo
 * @date 16.05.2020
 * уровень игрока 105+
 * Охота на всех монстов на первобытном острове
 **/
public class _1110_PrimevalIsle extends DailyHunting {
	private static final int[] MONSTER_IDS = {
		24436,
		24437,
		24438,
		24439,
		24440,
		24441
	};

	@Override
	protected int[] getMonsterIds() {
		return MONSTER_IDS;
	}
}
