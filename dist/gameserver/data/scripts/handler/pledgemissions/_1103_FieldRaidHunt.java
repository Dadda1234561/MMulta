package handler.pledgemissions;

/**
 * @author Edoo
 * @date 16.05.2020
 **/
public class _1103_FieldRaidHunt extends DailyHunting {
	private static final int[] MONSTER_IDS = {
		26431,26432,26433,26434,26435,26436,26437,26438,26439,26440,26441,26442,26443,26444
	};

	@Override
	protected int[] getMonsterIds() {
		return MONSTER_IDS;
	}
}
