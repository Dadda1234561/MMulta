package handler.pledgemissions;

/**
 * @author Bonux (bonuxq@gmail.com)
 * @date 29.09.2019
 * Прорыв обороны Кецеруса
 * Примите участие в обороне Базы Альянса Кецеруса и выполните 1 из указанных заданий:
 *|Атака| Остановить Кайна
 * |Защита| Остановить Кайна
 * |Поддержка| Остановить Кайна
 **/
public class _2003_DailyMission extends QuestComplete {
	protected static final int[] QUEST_IDS = {
			729, // Атака| Остановить Кайна
			730, // Защита| Остановить Кайна
			731 // Поддержка| Остановить Кайна
	};

	@Override
	protected int[] getQuestIds() {
		return QUEST_IDS;
	}
}
