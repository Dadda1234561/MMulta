package quests;

import l2s.gameserver.model.Player;
import l2s.gameserver.model.instances.NpcInstance;
import l2s.gameserver.model.quest.Quest;
import l2s.gameserver.model.quest.QuestState;
import l2s.gameserver.utils.Functions;

public class _184_NikolasCooperationContract extends Quest
{
	private static final int Lorain = 30673;
	private static final int Nikola = 30621;
	private static final int Device = 32366;
	private static final int Alarm = 32367;

	private static final int Certificate = 10362;
	private static final int Metal = 10359;
	private static final int BrokenMetal = 10360;
	private static final int NicolasMap = 10361;

	public _184_NikolasCooperationContract()
	{
		super(PARTY_NONE, ONETIME);

		addStartNpc(Nikola);
		addTalkId(Lorain, Nikola, Device, Alarm);
		addQuestItem(NicolasMap, BrokenMetal, Metal);
	}

	@Override
	public boolean isVisible(Player player) {
		return player.getQuestState(this) != null;
	}

	@Override
	public String onEvent(String event, QuestState st, NpcInstance npc)
	{
		String htmltext = event;
		Player player = st.getPlayer();

		if(event.equalsIgnoreCase("30621-01.htm"))
		{
			if(player.getLevel() < 40)
				htmltext = "30621-00.htm";
		}
		else if(event.equalsIgnoreCase("30621-04.htm"))
		{
			st.setCond(1);
			st.giveItems(NicolasMap, 1);
		}
		else if(event.equalsIgnoreCase("30673-03.htm"))
		{
			st.setCond(2);
			st.takeItems(NicolasMap, -1);
		}
		else if(event.equalsIgnoreCase("30673-05.htm"))
		{
			st.setCond(3);
		}
		else if(event.equalsIgnoreCase("30673-09.htm"))
		{
			if(st.getQuestItemsCount(BrokenMetal) > 0)
				htmltext = "30673-10.htm";
			else if(st.getQuestItemsCount(Metal) > 0)
				st.giveItems(Certificate, 1);
			st.giveItems(ADENA_ID, 217581);
			st.addExpAndSp(203717, 14032);
			st.finishQuest();
		}
		else if(event.equalsIgnoreCase("32366-02.htm"))
		{
			NpcInstance alarm = st.addSpawn(Alarm, 16536, 113496, -9050);
			Functions.npcSay(alarm, "Intruder Alert! The alarm will self-destruct in 1 minutes.");
		}
		else if(event.equalsIgnoreCase("32366-05.htm"))
		{
			st.setCond(5);
			st.giveItems(BrokenMetal, 1);
		}
		else if(event.equalsIgnoreCase("32366-06.htm"))
		{
			st.setCond(4);
			st.giveItems(Metal, 1);
		}
		else if(event.equalsIgnoreCase("32367-02.htm"))
		{
			st.set("step", "3");
			if(npc != null)
				npc.deleteMe(); //TODO: check why he's null sometimes
		}

		return htmltext;
	}

	@Override
	public String onTalk(NpcInstance npc, QuestState st)
	{
		String htmltext = NO_QUEST_DIALOG;
		int npcId = npc.getNpcId();
		int cond = st.getCond();

		
			if(npcId == Nikola)
			{
				if(cond == 0)
					if(st.getPlayer().getLevel() < 40)
						htmltext = "30621-00.htm";
					else
						htmltext = "30621-01.htm";
				else if(cond == 1)
					htmltext = "30621-05.htm";
			}
			else if(npcId == Lorain)
			{
				if(cond == 1)
					htmltext = "30673-01.htm";
				else if(cond == 2)
					htmltext = "30673-04.htm";
				else if(cond == 3)
					htmltext = "30673-06.htm";
				else if(cond == 4 || cond == 5)
					htmltext = "30673-07.htm";
			}
			else if(npcId == Device)
			{
				int step = st.getInt("step");
				if(cond == 3)
					if(step == 0)
						htmltext = "32366-01.htm";
					else if(step == 1)
						htmltext = "32366-02.htm";
					else if(step == 2)
						htmltext = "32366-04.htm";
					else if(step == 3)
						htmltext = "32366-03.htm";
			}
			else if(npcId == Alarm)
				htmltext = "32367-01.htm";

		return htmltext;
	}
}