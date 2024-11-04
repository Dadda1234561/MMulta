package handler.pledgemissions;

/**
 * @author Bonux (bonuxq@gmail.com)
 * @date 29.09.2019
 * Мировой босс (Ур. 100-105)-->
 * Убейте любого из следующих боссов в составе командного канала 2 раза:
 * Кельбим, Рамона
 **/
public class _2002_DailyMission extends DailyHunting {
	private static final int[] MONSTER_IDS = {
		26124, //Кельбим
		26143 //Рамона
	};

	@Override
	protected int[] getMonsterIds() {
		return MONSTER_IDS;
	}
}
