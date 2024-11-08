package handler.pledgemissions;

/**
 * @author Bonux (bonuxq@gmail.com)
 * Задание фракции (ур. 99 и выше)
 * Выполните 2 любых ежедневных задания для персонажей 99 ур. и выше одной из следующих фракций:
 * "Клан Блэкберд"
 * "Хранители Древа Жизни"
 * "Истребители Гигантов"
 * "Пришельцы из Иного Измерения"
 * "Имперские Гвардейцы"
 **/
public class _1002_PledgeMission extends QuestComplete {
	protected static final int[] QUEST_IDS = {
			// Блэкберд
			775, // Число Осколков Хаоса
			783, // Крупицы Магии
			929, // Спасение Рядового Рейнджера
			930, // Избавление От Призраков

			// Хранители Древа Жизни
			841, // Борьба с распространением тьмы
			823, // Пропавший соплеменник, новая фея

			// Истребители Гигантов
			842, // Плененные Демоны
			843, // Контроль над Эволюцией Гигантов
			844, // Сокровище Гигантов
			923, // Извлечение Сияющей Пыли
			924, // Восстановившиеся Гиганты

			// Пришельцы из Иного Измерения
			931, // Память Ветра
			932, // Энергия Сайхи

			// Имперские Гвардейцы
			816, // План по ремонту базы
			845 // Удар по линиям снабжения Эмбрио
	};

	@Override
	protected int[] getQuestIds() {
		return QUEST_IDS;
	}
}
