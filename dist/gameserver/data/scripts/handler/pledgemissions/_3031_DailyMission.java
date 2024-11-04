package handler.pledgemissions;

/**
 * @author Bonux (bonuxq@gmail.com)
 * @date 29.09.2019
 * Начинающий истребитель боссов
 * Убейте любого из следующих боссов 1 раз: 
 * Антарас, Валакас, Линдвиор, Фафурион, Хелиос, Этис ван Этина
 **/
public class _3031_DailyMission extends DailyHunting {
	private static final int[] MONSTER_IDS = {
			29068, //Антарас
			29028, //Валакас
			29240, //Линдвиор
			29361, //Фафурион
			29305, //Хелиос
			29319, //Этис ван Этина
			26328, //Этис ван Этина
			26400 //Этис ван Этина
	};

	@Override
	protected int[] getMonsterIds() {
		return MONSTER_IDS;
	}
}
