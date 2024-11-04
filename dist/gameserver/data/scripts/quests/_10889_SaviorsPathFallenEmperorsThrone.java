package quests;

import org.apache.commons.lang3.ArrayUtils;

import l2s.commons.util.Rnd;
import l2s.gameserver.model.instances.NpcInstance;
import l2s.gameserver.model.quest.Quest;
import l2s.gameserver.model.quest.QuestState;

/**
 * @author Edoo
 */
public class _10889_SaviorsPathFallenEmperorsThrone extends Quest
{
	// NPCs
	private static final int LEONA = 34425;
	// Monsters
	private static final int[] MONSTERS = 
		{26335};
	// Items
	private static final int ORIGIN_OF_GIANTS = 48548;
	// Misc
	private static final int REQUIRED_ITEMS = 5;
	private static final int MIN_LEVEL = 103;
	private static final long REWARD_EXP = 271_916_247_600L;
	private static final int REWARD_SP = 271_916_100;
	private static final int REWARD_ADENA = 30_773_010;
	
	public _10889_SaviorsPathFallenEmperorsThrone()
	{
		super(PARTY_ALL, ONETIME);
		addStartNpc(LEONA);
		addTalkId(LEONA);
		addKillId(MONSTERS);
		addLevelCheck("no_level.htm", MIN_LEVEL);
		addQuestCompletedCheck("no_level.htm", 10888);
	}
	
	@Override
	public String onEvent(String event, QuestState st, NpcInstance npc)
	{
		switch (event)
		{
			case "leona_q10889_02.htm":
			{
				st.setCond(1);
				break;
			}
			case "leona_q10889_04.htm":
			{
				if (st.getCond() == 2)
				{
					st.addExpAndSp(REWARD_EXP, REWARD_SP);
					st.giveItems(57, REWARD_ADENA);
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
			case LEONA:
			{
				switch (cond)
				{
					case 0:
						return "leona_q10889_01.htm";
					case 1:
						return "leona_q10889_02.htm";
					case 2:
						return "leona_q10889_03.htm";
				}
				break;
			}
		}
		return NO_QUEST_DIALOG;
	}
	
	@Override
	public String onKill(NpcInstance npc, QuestState qs)
	{
		if ((qs.getCond() == 1) && (Rnd.get(100) > 0.5) && ArrayUtils.contains(MONSTERS, npc.getNpcId()))
		{
			qs.giveItems(ORIGIN_OF_GIANTS, 1);
			if (qs.getQuestItemsCount(ORIGIN_OF_GIANTS) >= REQUIRED_ITEMS)
			{
				qs.setCond(2);
			}
			else
				qs.playSound(SOUND_ITEMGET);
		}
		return null;
	}
}