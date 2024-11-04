package quests;

import l2s.gameserver.model.instances.NpcInstance;
import l2s.gameserver.model.quest.Quest;
import l2s.gameserver.model.quest.QuestState;

public class _834_AgainstDragonclaw extends Quest {
	private static final int Сетлен = 34180;

	public _834_AgainstDragonclaw() {
		super(PARTY_NONE, REPEATABLE);
		addTalkId(Сетлен);
	}

	@Override
	public String onTalk(NpcInstance npc, QuestState st) {
		int npcId = npc.getNpcId();
		int cond = st.getCond();
		switch(npcId) {
			case Сетлен: {
				if(cond == 3) {
					st.addExpAndSp(6362541900L, 15270101);
					st.giveItems(57, 1186000);
					st.finishQuest();
				}
			}
			break;
		}
		return NO_QUEST_DIALOG;
	}
}