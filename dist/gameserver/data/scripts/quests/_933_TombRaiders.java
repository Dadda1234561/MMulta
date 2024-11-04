package quests;

import l2s.gameserver.model.instances.NpcInstance;
import l2s.gameserver.model.quest.Quest;
import l2s.gameserver.model.quest.QuestState;

/**
 * @author nexvill
 */
public class _933_TombRaiders extends Quest
{	
	// NPCS
	private static final int LEOPARD = 32594;
	// Monsters
	private static final int[] MOBS = 
	{
		24580, // Tomb Guardian
		24581, // Tomb Raider
		24582, // Tomb Patrol
		24583, // Tomb Soultaker
		24584 // Tomb Watcher
	};
	
	private static final String A_LIST = "A_LIST";
	
	//item
	private static final int REWARD_BOX = 81151;
	
	public _933_TombRaiders()
	{		
		super(PARTY_ALL, DAILY);
		addTalkId(LEOPARD);
		addKillNpcWithLog(1, 93311, A_LIST, 150, MOBS);
	}
	
	@Override
	public String onEvent(String event, QuestState st, NpcInstance npc)
	{
		if (event.equalsIgnoreCase("leopard_q933_02.htm"))
		{
			st.addExpAndSp(20_700_253_956_096L, 18_630_228_560L);
			st.giveItems(REWARD_BOX, 1);
			st.finishQuest();
		}
		return event;
	}
	
	@Override
	public String onTalk(NpcInstance npc, QuestState st)
	{
		int npcId = npc.getNpcId();
		if (npcId == LEOPARD)
		{
			if (st.getCond() == 2)
			{
				return "leopard_q933_01.htm";
			}
		}
		return NO_QUEST_DIALOG;
	}
	
	@Override
	public String onKill(NpcInstance npc, QuestState qs)
	{
		if (qs.getCond() == 1)
		{
			if (updateKill(npc, qs))
			{
				qs.unset(A_LIST);
				qs.setCond(2);
			}
		}
		return null;
	}
}
