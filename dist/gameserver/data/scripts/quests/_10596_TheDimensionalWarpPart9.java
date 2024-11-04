package quests;

import l2s.gameserver.model.instances.NpcInstance;
import l2s.gameserver.model.quest.Quest;
import l2s.gameserver.model.quest.QuestState;

/**
 * @author nexvill, Edoo
 */
public class _10596_TheDimensionalWarpPart9 extends Quest
{
	// NPC
	private static final int RESED = 33974;
	
	private static final String A_LIST = "A_LIST";
	
	// Monsters
	private static final int EXTRATERRESTRIAL_BERSERKER = 24108;
	// Others
	private static final int MIN_LEVEL = 99;
	private static final int WARP_CRYSTAL = 39597;
	
	public _10596_TheDimensionalWarpPart9()
	{
		super(PARTY_ALL, ONETIME);
		addStartNpc(RESED);
		addTalkId(RESED);
		addKillNpcWithLog(1, 1024108, A_LIST, 100, EXTRATERRESTRIAL_BERSERKER);
		addLevelCheck("no_level.htm", MIN_LEVEL);
		addQuestCompletedCheck("no_level.htm", 10595);
	}
	
	@Override
	public String onEvent(String event, QuestState st, NpcInstance npc)
	{
		switch (event)
		{
		case "resed_q10596_02.htm":
		case "resed_q10596_03.htm":
			{
				break;
			}
		case "resed_q10596_04.htm":
			{
				st.setCond(1);
				break;
			}
		case "resed_q10596_07.htm":
			{
				if (st.getCond() == 2)
				{
					st.addExpAndSp(135_216_288_257L, 0);
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
						return "resed_q10596_01.htm";
					case 1:
						return "resed_q10596_05.htm";
					case 2:
						return "resed_q10596_06.htm";
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

