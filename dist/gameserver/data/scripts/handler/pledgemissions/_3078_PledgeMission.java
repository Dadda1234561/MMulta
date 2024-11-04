package handler.pledgemissions;

/**
 * @author Bonux (bonuxq@gmail.com)
 * @date 29.09.2019
 * 1 уровень доверия Гильдии Путешественников
 * Выполните одно из заданий Гильдии Путешественников:
 * "Путь странствующего рыцаря"
 * "Встреча с Гильдией Путешественников"
 **/
public class _3078_PledgeMission extends QuestComplete {
	protected static final int[] QUEST_IDS = {
			10560, // Путь странствующего рыцаря
			10896 // Встреча с Гильдией Путешественников
	};

	@Override
	protected int[] getQuestIds() {
		return QUEST_IDS;
	}
}
