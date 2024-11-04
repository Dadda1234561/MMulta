package handler.pledgemissions;

/**
 * @author Bonux (bonuxq@gmail.com)
 * @date 29.09.2019
 * 3 уровень доверия Гильдии Путешественников
 * Выполните одно из заданий Гильдии Путешественников:
 * "К оружию!"
 * "Стремление к цели"
 **/
public class _3079_DailyMission extends QuestComplete {
	protected static final int[] QUEST_IDS = {
			10562, // К оружию!
			10898 // Стремление к цели
	};

	@Override
	protected int[] getQuestIds() {
		return QUEST_IDS;
	}
}
