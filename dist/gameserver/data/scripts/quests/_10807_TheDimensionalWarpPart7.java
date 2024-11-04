package quests;

import l2s.gameserver.model.instances.NpcInstance;
import l2s.gameserver.model.quest.Quest;
import l2s.gameserver.model.quest.QuestState;

/**
* @author Edoo
*/

public class _10807_TheDimensionalWarpPart7 extends Quest
{
	// NPC
	private static final int RESED = 33974;
	// Monsters
	private static final int ABYSSAL_BINDER = 23481;
	// Others
	private static final int MIN_LEVEL = 99;
	private static final int WARP_CRYSTAL = 39597;

	public static final String A_LIST = "A_LIST";
	public _10807_TheDimensionalWarpPart7()
	{
		super(PARTY_ALL, ONETIME);
		addStartNpc(RESED);
		addKillNpcWithLog(1, 1023481, A_LIST, 100, ABYSSAL_BINDER);
		addTalkId(RESED);
		addQuestCompletedCheck("no_level.htm", MIN_LEVEL);
		addQuestCompletedCheck(NO_QUEST_DIALOG, 10806);
	}

	@Override
	public String onEvent(String event, QuestState st, NpcInstance npc)
	{
		switch (event)
		{
		case "resed_q10807_02.htm":
		case "resed_q10807_03.htm":
			{
				break;
			}
		case "resed_q10807_04.htm":
			{
				st.setCond(1);
				break;
			}
		case "resed_q10807_07.htm":
			{
				if (st.getCond() == 2)
				{
					st.addExpAndSp(90422325000L, 0);
					st.giveItems(WARP_CRYSTAL, 300);
					st.finishQuest();
					break;
				}
			}
		}
		return event;
	}
	
	@Override
	public String onTalk(NpcInstance npc, QuestState st)
	{
	
		int npcId = npc.getNpcId();
		int cond = st.getCond();
		
		switch (npcId)
		{
			case RESED:
			{
				switch (cond)
				{
					case 0:
						return "resed_q10807_01.htm";
					case 1:
						return "resed_q10807_05.htm";
					case 2:
						return "resed_q10807_06.htm";
				}
				break;
			}
		}
		return NO_QUEST_DIALOG;
	}
	
	@Override
	public String onKill(NpcInstance npc, QuestState qs)
	{
		if ((qs.getCond() == 1) && updateKill(npc, qs))
		{
			qs.unset(A_LIST);
			qs.setCond(2);	
		}
		else
			{
				qs.playSound(SOUND_ITEMGET);
			}
		return null;
	}
}