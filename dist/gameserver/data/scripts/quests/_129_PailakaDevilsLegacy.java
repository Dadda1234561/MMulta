package quests;

import org.apache.commons.lang3.ArrayUtils;
import l2s.commons.util.Rnd;
import l2s.gameserver.Config;
import l2s.gameserver.model.Player;
import l2s.gameserver.model.instances.NpcInstance;
import l2s.gameserver.model.quest.Quest;
import l2s.gameserver.model.quest.QuestState;
import l2s.gameserver.geometry.Location;

public class _129_PailakaDevilsLegacy extends Quest
{
	// NPC
	private static int DISURVIVOR = 32498;
	private static int SUPPORTER = 32501;
	private static int DADVENTURER = 32508;
	private static int DADVENTURER2 = 32511;
	private static int CHEST = 32495;
	private static int[] Pailaka2nd = new int[]{
			18623,
			18624,
			18625,
			18626,
			18627
	};

	// BOSS
	private static int KAMS = 18629;
	private static int ALKASO = 18631;
	private static int LEMATAN = 18633;

	// ITEMS
	private static int ScrollOfEscape = 736;
	private static int SWORD = 13042;
	private static int ENCHSWORD = 13043;
	private static int LASTSWORD = 13044;
	private static int KDROP = 13046;
	private static int ADROP = 13047;
	private static int KEY = 13150;
	private static int[] HERBS = new int[]{
			8601,
			8602,
			8604,
			8605
	};
	private static int[] CHESTDROP = new int[]{
			13033,
			13048,
			13049
	}; // TODO нет скилла для бутылки: , 13059 };

	// REWARDS
	private static int PBRACELET = 13295;
	private static final int izId = 44;

	private static final int EXP_REWARD = 4010000;
	private static final int SP_REWARD = 962; 

	public _129_PailakaDevilsLegacy()
	{
		super(PARTY_NONE, ONETIME);

		addStartNpc(DISURVIVOR);
		addTalkId(SUPPORTER, DADVENTURER, DADVENTURER2);
		addKillId(KAMS, ALKASO, LEMATAN, CHEST);
		addKillId(Pailaka2nd);
		addQuestItem(SWORD, ENCHSWORD, LASTSWORD, KDROP, ADROP, KEY);
		addQuestItem(CHESTDROP);
		addLevelCheck("32498-no.htm", 61/*, 67*/);
	}

	@Override
	public String onEvent(String event, QuestState st, NpcInstance npc)
	{
		Player player = st.getPlayer();
		String htmltext = event;
		if(event.equalsIgnoreCase("Enter"))
		{
			enterInstance(st, izId);
			return null;
		}
		else if(event.equalsIgnoreCase("32498-02.htm"))
		{
			st.setCond(1);
		}
		else if(event.equalsIgnoreCase("32498-05.htm"))
		{
			st.setCond(2);
		}
		else if(event.equalsIgnoreCase("32501-03.htm"))
		{
			st.setCond(3);
			st.giveItems(SWORD, 1);
		}
		return htmltext;
	}

	@Override
	public String onTalk(NpcInstance npc, QuestState st)
	{
		String htmltext = NO_QUEST_DIALOG;
		int npcId = npc.getNpcId();
		int cond = st.getCond();
		Player player = st.getPlayer();
		if(npcId == DISURVIVOR)
		{
			if(cond == 0)
				htmltext = "32498-01.htm";
			else if(cond == 1 || cond == 2)
				htmltext = "32498-06.htm";
			else
				htmltext = "32498-07.htm";
		}
		else if(npcId == SUPPORTER)
		{
			if(cond == 1 || cond == 2)
				htmltext = "32501-01.htm";
			else
				htmltext = "32501-04.htm";
		}
		else if(npcId == DADVENTURER)
		{
			if(st.getQuestItemsCount(SWORD) > 0 && st.getQuestItemsCount(KDROP) == 0)
				htmltext = "32508-01.htm";
			if(st.getQuestItemsCount(ENCHSWORD) > 0 && st.getQuestItemsCount(ADROP) == 0)
				htmltext = "32508-01.htm";
			if(st.getQuestItemsCount(SWORD) == 0 && st.getQuestItemsCount(KDROP) > 0)
				htmltext = "32508-05.htm";
			if(st.getQuestItemsCount(ENCHSWORD) == 0 && st.getQuestItemsCount(ADROP) > 0)
				htmltext = "32508-05.htm";
			if(st.getQuestItemsCount(SWORD) == 0 && st.getQuestItemsCount(ENCHSWORD) == 0)
				htmltext = "32508-05.htm";
			if(st.getQuestItemsCount(KDROP) == 0 && st.getQuestItemsCount(ADROP) == 0)
				htmltext = "32508-01.htm";
			if(player.hasServitor())
				htmltext = "32508-04.htm";
			if(st.getQuestItemsCount(SWORD) > 0 && st.getQuestItemsCount(KDROP) > 0)
			{
				st.takeItems(SWORD, 1);
				st.takeItems(KDROP, 1);
				st.giveItems(ENCHSWORD, 1);
				htmltext = "32508-02.htm";
			}
			if(st.getQuestItemsCount(ENCHSWORD) > 0 && st.getQuestItemsCount(ADROP) > 0)
			{
				st.takeItems(ENCHSWORD, 1);
				st.takeItems(ADROP, 1);
				st.giveItems(LASTSWORD, 1);
				htmltext = "32508-03.htm";
			}
			if(st.getQuestItemsCount(LASTSWORD) > 0)
				htmltext = "32508-03.htm";
		}
		else if(npcId == DADVENTURER2)
			if(cond == 4)
			{
				if(player.hasServitor())
					htmltext = "32511-03.htm";
				else
				{
					st.giveItems(ScrollOfEscape, 1);
					st.giveItems(PBRACELET, 1);
					st.addExpAndSp(EXP_REWARD, SP_REWARD);
					st.giveItems(ADENA_ID, 411500);
					st.setCond(5);
					st.finishQuest();
					player.setVitality(Player.MAX_VITALITY_POINTS, true);
					player.sendUserInfo(true);
					player.getReflection().startCollapseTimer(60000, true);
					htmltext = "32511-01.htm";
				}
			}
		return htmltext;
	}

	@Override
	public String onCompleted(NpcInstance npc, QuestState st)
	{
		String htmltext = COMPLETED_DIALOG;
		if(npc.getNpcId() == DISURVIVOR)
			htmltext = "32498-no.htm";
		else if(npc.getNpcId() == DADVENTURER2)
			htmltext = "32511-02.htm";
		return htmltext;
	}

	@Override
	public String onKill(NpcInstance npc, QuestState st)
	{
		Player player = st.getPlayer();
		int npcId = npc.getNpcId();
		int refId = player.getReflectionId();
		if(npcId == KAMS && st.getQuestItemsCount(KDROP) == 0)
			st.giveItems(KDROP, 1);
		else if(npcId == ALKASO && st.getQuestItemsCount(ADROP) == 0)
			st.giveItems(ADROP, 1);
		else if(npcId == LEMATAN)
		{
			st.setCond(4);
			addSpawnToInstance(DADVENTURER2, new Location(84990, -208376, -3342, 55000), 0, refId);
		}
		else if(ArrayUtils.contains(Pailaka2nd, npcId))
		{
			if(Rnd.get(100) < 80)
				st.dropItem(npc, HERBS[Rnd.get(HERBS.length)], Rnd.get(1, 2));
		}
		else if(npcId == CHEST)
			if(Rnd.get(100) < 80)
				st.dropItem(npc, CHESTDROP[Rnd.get(CHESTDROP.length)], Rnd.get(1, 10));
		// TODO вернуть когда будут работать двери
		//else
		//	dropItem(npc, KEY, 1);
		return null;
	}
}