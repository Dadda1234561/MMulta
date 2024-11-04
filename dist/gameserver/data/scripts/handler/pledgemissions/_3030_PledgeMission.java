package handler.pledgemissions;

/**
 * @author Bonux (bonuxq@gmail.com)
 * @date 29.09.2019
 * Охота на редкого монстра в Таверне
 * 10 раз убейте любого из следующих монстров, изредка появляющихся в Таинственной Таверне:
 * Таинственная Таверна - Таути: Ифрит
 * Таинственная Таверна - Фрея: Рыцарь Ледяного Лабиринта
 * Таинственная Таверна - Кельбим: Домидан
 * Таинственная Таверна - Кайн: Айнхалдер фон Хельман
 **/
public class _3030_PledgeMission extends DailyHunting {
	private static final int[] MONSTER_IDS = {
			23704, //Ифрит
			23703, //Рыцарь Ледяного Лабиринта
			23696, //Домидан
			24068 //Айнхалдер фон Хельман
	};

	@Override
	protected int[] getMonsterIds() {
		return MONSTER_IDS;
	}
}
