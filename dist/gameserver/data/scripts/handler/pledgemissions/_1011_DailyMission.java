package handler.pledgemissions;

/**
 * @author Bonux (bonuxq@gmail.com)
 * @date 29.09.2019
 * Рейд в поле 85-94
 * Убейте любого из следующих рейдовых боссов в поле 4 раза:
 * Копия Хаффа,Орк Амден Турахот, Кровавый Дракон Земли Гагия, Статуя Ехидны Тарстан, Усиленный Махум Радиум, Монстр Раум
 **/
public class _1011_DailyMission extends DailyHunting {
	private static final int[] MONSTER_IDS = {
		25989, //Копия Хаффа
		26000, //Орк Амден Турахот
		26011, //Кровавый Дракон Земли Гагия
		26055, //Статуя Ехидны Тарстан
		26066, //Усиленный Махум Радиум
		26077 //Монстр Раум
	};

	@Override
	protected int[] getMonsterIds() {
		return MONSTER_IDS;
	}
}
