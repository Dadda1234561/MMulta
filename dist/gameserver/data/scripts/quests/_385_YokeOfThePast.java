package quests;

import l2s.commons.util.Rnd;
import l2s.gameserver.model.base.Experience;
import l2s.gameserver.model.instances.NpcInstance;
import l2s.gameserver.model.quest.Quest;
import l2s.gameserver.model.quest.QuestState;

/**
 * Квест проверен и работает.
 * Рейты прописаны путем повышения шанса получения квестовых вещей.
 */
public class _385_YokeOfThePast extends Quest
{
	final int ANCIENT_SCROLL = 5902;
	final int BLANK_SCROLL = 5965;

	private final static int drop_chance = 60;

	public _385_YokeOfThePast()
	{
		super(PARTY_ONE, REPEATABLE);

		for(int npcId = 31095; npcId <= 31126; npcId++)
			if(npcId != 31111 && npcId != 31112 && npcId != 31113)
				addStartNpc(npcId);

		for(int mobs = 21208; mobs < 21256; mobs++)
			addKillId(mobs);

		addQuestItem(ANCIENT_SCROLL);
	}

	public boolean checkNPC(int npc)
	{
		if(npc >= 31095 && npc <= 31126)
			if(npc != 31100 && npc != 31111 && npc != 31112 && npc != 31113)
				return true;
		return false;
	}

	@Override
	public String onEvent(String event, QuestState st, NpcInstance npc)
	{
		String htmltext = event;
		if(event.equalsIgnoreCase("enter_necropolis1_q0385_05.htm"))
		{
			st.setCond(1);
		}
		else if(event.equalsIgnoreCase("enter_necropolis1_q0385_09.htm"))
		{
			htmltext = "enter_necropolis1_q0385_10.htm";
			st.finishQuest();
		}
		return htmltext;
	}

	@Override
	public String onKill(NpcInstance npc, QuestState st)
	{
		int count = Rnd.get(2);
/*
		double rand = 60 * Experience.penaltyModifier(st.calculateLevelDiffForDrop(npc.getLevel(), st.getPlayer().getLevel()), 9) * npc.getTemplate().rateHp / 4;
*/

		st.rollAndGive(ANCIENT_SCROLL, count, drop_chance);
		return null;
	}

	@Override
	public String onTalk(NpcInstance npc, QuestState st)
	{
		int npcId = npc.getNpcId();
		String htmltext = NO_QUEST_DIALOG;
		if(checkNPC(npcId) && st.getCond() == 0)
		{
			if(st.getPlayer().getLevel() < 20)
				htmltext = "enter_necropolis1_q0385_02.htm";
			else
				htmltext = "enter_necropolis1_q0385_01.htm";
		}
		else if(st.getCond() == 1 && st.getQuestItemsCount(ANCIENT_SCROLL) == 0)
			htmltext = "enter_necropolis1_q0385_11.htm";
		else if(st.getCond() == 1 && st.getQuestItemsCount(ANCIENT_SCROLL) > 0)
		{
			htmltext = "enter_necropolis1_q0385_09.htm";
			st.giveItems(BLANK_SCROLL, st.getQuestItemsCount(ANCIENT_SCROLL), false);
			st.takeItems(ANCIENT_SCROLL, -1);
		}
		return htmltext;
	}
}