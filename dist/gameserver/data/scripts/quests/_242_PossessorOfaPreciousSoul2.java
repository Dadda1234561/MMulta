package quests;

import l2s.gameserver.model.instances.NpcInstance;
import l2s.gameserver.model.quest.Quest;
import l2s.gameserver.model.quest.QuestState;

public class _242_PossessorOfaPreciousSoul2 extends Quest
{

	private static final int VIRGILS_LETTER_1_PART = 7677;
	private static final int BLONDE_STRAND = 7590;
	private static final int SORCERY_INGREDIENT = 7596;
	private static final int CARADINE_LETTER = 7678;
	private static final int ORB_OF_BINDING = 7595;

	private static final int PureWhiteUnicorn = 31747;
	private NpcInstance PureWhiteUnicornSpawn = null;

	public _242_PossessorOfaPreciousSoul2()
	{
		super(PARTY_NONE, ONETIME);

		addStartNpc(31742);

		addTalkId(31743);
		addTalkId(31751);
		addTalkId(31752);
		addTalkId(30759);
		addTalkId(30738);
		addTalkId(31744);
		addTalkId(31748);
		addTalkId(PureWhiteUnicorn);
		addTalkId(31746);

		addKillId(27317);

		addQuestItem(new int[]{
				ORB_OF_BINDING,
				SORCERY_INGREDIENT,
				BLONDE_STRAND
		});
	}

	@Override
	public String onEvent(String event, QuestState st, NpcInstance npc)
	{
		if(event.equalsIgnoreCase("31742-2.htm"))
		{
			st.setCond(1);
			st.set("CoRObjId", "0");
			st.takeItems(VIRGILS_LETTER_1_PART, 1);
		}
		else if(event.equalsIgnoreCase("31743-5.htm"))
		{
			st.setCond(2);
		}
		else if(event.equalsIgnoreCase("31744-2.htm"))
		{
			st.setCond(3);
		}
		else if(event.equalsIgnoreCase("31751-2.htm"))
		{
			st.setCond(4);
		}
		else if(event.equalsIgnoreCase("30759-2.htm"))
		{
			st.takeItems(BLONDE_STRAND, 1);
			st.setCond(7);
		}
		else if(event.equalsIgnoreCase("30759-4.htm"))
		{
			st.setCond(9);
		}
		else if(event.equalsIgnoreCase("30738-2.htm"))
		{
			st.setCond(8);
			st.giveItems(SORCERY_INGREDIENT, 1);
		}
		else if(event.equalsIgnoreCase("31748-2.htm"))
		{
			st.takeItems(ORB_OF_BINDING, 1);
			st.killNpcByObjectId(st.getInt("CoRObjId"));
			st.set("talk", "0");
			if(st.getInt("prog") < 4)
			{
				st.set("prog", str(st.getInt("prog") + 1));
				st.playSound(SOUND_MIDDLE);
			}
			if(st.getInt("prog") == 4)
			{
				st.setCond(10);
			}
		}
		return event;
	}

	@Override
	public String onTalk(NpcInstance npc, QuestState st)
	{
		if(!st.getPlayer().isDualClassActive())
			return "Subclass only!";

		String htmltext = NO_QUEST_DIALOG;
		int npcId = npc.getNpcId();
		int cond = st.getCond();
		if(npcId == 31742)
		{
			if(cond == 0)
			{
				if(st.getPlayer().isQuestCompleted(241) && st.getPlayer().getLevel() >= 60)
					htmltext = "31742-1.htm";
				else
					htmltext = "31742-0.htm";
			}
			else if(cond == 1)
				htmltext = "31742-2r.htm";
		}
		else if(npcId == 31743)
		{
			if(cond == 1)
				htmltext = "31743-1.htm";
			else if(cond == 2)
				htmltext = "31743-2r.htm";
			else if(cond == 11)
			{
				htmltext = "31743-6.htm";
				st.giveItems(CARADINE_LETTER, 1);
				st.addExpAndSp(455764, 0);
				st.unset("cond");
				st.unset("CoRObjId");
				st.unset("prog");
				st.unset("talk");
				st.finishQuest();
			}
		}
		else if(npcId == 31744)
		{
			if(cond == 2)
				htmltext = "31744-1.htm";
			else if(cond == 3)
				htmltext = "31744-2r.htm";
		}
		else if(npcId == 31751)
		{
			if(cond == 3)
				htmltext = "31751-1.htm";
			else if(cond == 4)
				htmltext = "31751-2r.htm";
			else if(cond == 5 && st.getQuestItemsCount(BLONDE_STRAND) >= 1)
			{
				st.setCond(6);
				htmltext = "31751-3.htm";
			}
			else if(cond == 6 && st.getQuestItemsCount(BLONDE_STRAND) >= 1)
				htmltext = "31751-3r.htm";
		}
		else if(npcId == 31752)
		{
			if(cond == 4)
			{
				st.giveItems(BLONDE_STRAND, 1);
				st.playSound(SOUND_ITEMGET);
				st.setCond(5);
				htmltext = "31752-2.htm";
			}
			else
				htmltext = "31752-n.htm";
		}
		else if(npcId == 30759)
		{
			if(cond == 6 && st.getQuestItemsCount(BLONDE_STRAND) >= 1)
				htmltext = "30759-1.htm";
			else if(cond == 7)
				htmltext = "30759-2r.htm";
			else if(cond == 8 && st.getQuestItemsCount(SORCERY_INGREDIENT) >= 1)
				htmltext = "30759-3.htm";
		}
		else if(npcId == 30738)
		{
			if(cond == 7)
				htmltext = "30738-1.htm";
			else if(cond == 8)
				htmltext = "30738-2r.htm";
		}
		else if(npcId == 31748)
		{
			if(cond == 9)
				if(st.getQuestItemsCount(ORB_OF_BINDING) >= 1)
				{
					if(npc.getObjectId() != st.getInt("CoRObjId"))
					{
						st.set("CoRObjId", str(npc.getObjectId()));
						st.set("talk", "1");
						htmltext = "31748-1.htm";
					}
					else if(st.getInt("talk") == 1)
						htmltext = "31748-1.htm";
					else
						htmltext = NO_QUEST_DIALOG;
				}
				else
					htmltext = "31748-0.htm";
		}
		else if(npcId == 31746)
		{
			if(st.getCond() == 9)
				htmltext = "31746-1.htm";
			else if(st.getCond() == 10)
			{
				htmltext = "31746-1.htm";
				npc.doDie(npc);
				if(PureWhiteUnicornSpawn == null || !st.getPlayer().knowsObject(PureWhiteUnicornSpawn) || !PureWhiteUnicornSpawn.isVisible())
					PureWhiteUnicornSpawn = st.addSpawn(PureWhiteUnicorn, npc.getX() + 10, npc.getY(), npc.getZ(), 120000);
			}
			else
				htmltext = NO_QUEST_DIALOG;
		}
		else if(npcId == PureWhiteUnicorn)
			if(st.getCond() == 10)
			{
				htmltext = "31747-1.htm";
				st.setCond(11);
			}
			else if(st.getCond() == 11)
				htmltext = "31747-2.htm";
		return htmltext;
	}

	@Override
	public String onKill(NpcInstance npc, QuestState st)
	{
		if(!st.getPlayer().isDualClassActive())
			return null;

		if(st.getCond() == 9 && st.getQuestItemsCount(ORB_OF_BINDING) < 4)
			st.giveItems(ORB_OF_BINDING, 1);
		if(st.getQuestItemsCount(ORB_OF_BINDING) < 4)
			st.playSound(SOUND_ITEMGET);
		else
			st.playSound(SOUND_MIDDLE);
		return null;
	}
}