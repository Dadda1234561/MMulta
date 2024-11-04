package handler.pledgemissions;

/**
 * @author Bonux (bonuxq@gmail.com)
 * @date 29.09.2019
 * 6 уровень доверия Гильдии Путешественников
 * Выполните одно из заданий Гильдии Путешественников:
 * "Нет ничего невозможного"
 * "Приют выдающегося путешественника
 **/
public class _3080_PledgeMission extends QuestComplete {
	protected static final int[] QUEST_IDS = {
			10565, // Нет ничего невозможного!
			10901 // Приют выдающегося путешественника
	};

	@Override
	protected int[] getQuestIds() {
		return QUEST_IDS;
	}
}
