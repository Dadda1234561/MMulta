package handler.pledgemissions;

/**
 * @author Edoo
 * @date 16.05.2020
 * уровень игрока 100+
 * Охота на боссов: Baium,Orfen,Lilith,Anakim,Ishka
 **/
public class _2101_FieldBossI extends DailyHunting {
	private static final int[] MONSTER_IDS = {
		29020,
		29325,
		29336,
		29348,
		29379
	};

	@Override
	protected int[] getMonsterIds() {
		return MONSTER_IDS;
	}
}
