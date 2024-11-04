package quests;

import l2s.gameserver.model.instances.NpcInstance;
import l2s.gameserver.model.quest.Quest;
import l2s.gameserver.model.quest.QuestState;
import l2s.gameserver.network.l2.components.NpcString;
import l2s.gameserver.network.l2.s2c.ExShowScreenMessage;

/**
 * @author Edoo
 */
public class _10454_FinalEmbryoApostle extends Quest
{
	// NPCs
	private static final int ERDA = 34319;
	// Boss
	private static final int CAMILLE = 26236; // Camille - Inner Messiahs Castle
	
	private static final int GOAL_ID = 1026236;

	private static final String A_LIST = "A_LIST";
	// Item
	private static final int SCROLL_ENCHANT_R_GRADE_WEAPON = 19447;
	private static final int SCROLL_ENCHANT_R_GRADE_ARMOR = 19448;
	// Misc
	private static final int MIN_LEVEL = 100;
	
	public _10454_FinalEmbryoApostle()
	{
		super(PARTY_ONE, DAILY);
		addStartNpc(ERDA);
		addTalkId(ERDA);
		addKillNpcWithLog(1, GOAL_ID, A_LIST, 1, CAMILLE);
		addLevelCheck("no_level.htm", MIN_LEVEL);
	}
	
	@Override
	public String onEvent(String event, QuestState st, NpcInstance npc)
	{
		switch (event)
		{
			case "erda_q10454_02.htm":
			case "erda_q10454_03.htm":
			case "erda_q10454_07.htm":
			{
				break;
			}
			case "erda_q10454_04.htm":
			{
				st.setCond(1);
				break;
			}
			case "erda_q10454_08.htm":
			{
				if (st.getCond() == 2)
				{
					st.giveItems(SCROLL_ENCHANT_R_GRADE_WEAPON, 1);
					st.giveItems(SCROLL_ENCHANT_R_GRADE_ARMOR, 1);
					st.addExpAndSp(36255499714L, 87013199);
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
			case ERDA:
			{
				switch (cond)
				{
					case 0:
						return "erda_q10454_01.htm";
					case 1:
						return "erda_q10454_05.htm";
					case 2:
						return "erda_q10454_06.htm";
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
			qs.getPlayer().sendPacket(new ExShowScreenMessage(NpcString.TALK_WITH_ERDA, 5000, ExShowScreenMessage.ScreenMessageAlign.TOP_CENTER, false));
		}
		else
			{
				qs.playSound(SOUND_ITEMGET);
			}
		return null;
	}
}