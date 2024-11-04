package handler.pledgemissions;

/**
 * @author Bonux (bonuxq@gmail.com)
 * @date 29.09.2019
 * Внешняя часть Твердыни Мессии
 * Уничтожьте любой из указанных механизмов во Внешней части Твердыни Мессии 10 раз:
 * Осадный Механизм Эмбрио,Магическая Пушка Твердыни Эмбрио
 **/
public class _2006_PledgeMission extends DailyHunting {
	private static final int[] MONSTER_IDS = {
		24023, //Осадный Механизм Эмбрио
		24037, //Осадный Механизм Эмбрио
		24042 //Магическая Пушка Твердыни Эмбрио
	};

	@Override
	protected int[] getMonsterIds() {
		return MONSTER_IDS;
	}
}
