package handler.pledgemissions;

/**
 * @author Edoo
 * @date 16.05.2020
 * уровень игрока 105+
 * Охота на Элитных Монстров
 **/
public class _1102_EliteMonsters extends DailyHunting {
	private static final int[] MONSTER_IDS = {
		24377,24420,24426,24432,24441,24451,24466,24485,24491,24495,24499,24505,24510,24523
	};

	@Override
	protected int[] getMonsterIds() {
		return MONSTER_IDS;
	}
}
