package quests;

import l2s.gameserver.model.instances.NpcInstance;
import l2s.gameserver.model.quest.Quest;
import l2s.gameserver.model.quest.QuestState;

import java.util.StringTokenizer;

/**
 * @author pchayka
 */
public class _254_LegendaryTales extends Quest
{
	private static final int Gilmore = 30754;
	private static final int LargeBone = 17249;
	private static final int[] raids = {25718, 25719, 25720, 25721, 25722, 25723, 25724};

	public _254_LegendaryTales()
	{
		super(PARTY_ALL, ONETIME);
		addStartNpc(Gilmore);
		addKillId(raids);
		addQuestItem(LargeBone);
	}

	@Override
	public String onEvent(String event, QuestState st, NpcInstance npc)
	{
		String htmltext = event;
		if(event.equalsIgnoreCase("gilmore_q254_05.htm"))
		{
			st.setCond(1);
		}
		else if(event.startsWith("gilmore_q254_09.htm"))
		{
			st.takeAllItems(LargeBone);
			StringTokenizer tokenizer = new StringTokenizer(event);
			tokenizer.nextToken();
			if (Integer.parseInt(tokenizer.nextToken()) == 1) {
				st.giveItems(106416, 1, false);
			}
			st.finishQuest();
			htmltext = "gilmore_q254_09.htm";
		}

		return htmltext;
	}

	@Override
	public String onTalk(NpcInstance npc, QuestState st)
	{
		String htmltext = NO_QUEST_DIALOG;
		int cond = st.getCond();
		if(npc.getNpcId() == Gilmore)
		{
			if(cond == 0)
			{
				if(st.getPlayer().getLevel() >= 80)
					htmltext = "gilmore_q254_01.htm";
				else
					htmltext = "gilmore_q254_00.htm";
			}
			else if(cond == 1)
				htmltext = "gilmore_q254_06.htm";
			else if(cond == 2)
				htmltext = "gilmore_q254_07.htm";
		}

		return htmltext;
	}

	@Override
	public String onKill(NpcInstance npc, QuestState st)
	{
		int cond = st.getCond();
		if(cond == 1)
		{
			int mask = 1;
			int var = npc.getNpcId();
			for (int i = 0; i < raids.length; i++)
			{
				if (raids[i] == var)
					break;
				mask = mask << 1;
			}

			var = st.getInt("RaidsKilled");
			if ((var & mask) == 0) // этого босса еще не убивали
			{
				var |= mask;
				st.set("RaidsKilled", var);
				st.giveItems(LargeBone, 1, false);
				if(st.getQuestItemsCount(LargeBone) >= 7)
					st.setCond(2);
			}
		}
		return null;
	}
}