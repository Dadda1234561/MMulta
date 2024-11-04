package quests;

import org.apache.commons.lang3.ArrayUtils;

import l2s.commons.util.Rnd;
import l2s.gameserver.model.instances.NpcInstance;
import l2s.gameserver.model.quest.Quest;
import l2s.gameserver.model.quest.QuestState;

/**
 * @author Edoo
 */
public class _10886_SaviorsPathSearchTheRefinery extends Quest
{
	// NPCs
	private static final int LEONA = 34425;
	private static final int DEVIANNE = 34427;
	// Monsters
	private static final int[] MONSTERS = 
	{
		24159, // Atelia Yuyurina
		24160 // Atelia Popobena
	};
	
	// Items
	private static final int TOKEN_OF_ETINA = 48546;
	// Misc
	private static final int MIN_LEVEL = 103;
	private static final long REWARD_EXP = 27_191_624_760L;
	private static final int REWARD_SP = 27_191_610;
	private static final int REWARD_ADENA = 3_077_301;
	
	public _10886_SaviorsPathSearchTheRefinery()
	{
		super(PARTY_ALL, ONETIME);
		addStartNpc(LEONA);
		addTalkId(LEONA);
		addTalkId(DEVIANNE);
		addKillId(MONSTERS);
		addLevelCheck("no_level.htm", MIN_LEVEL);
		addQuestCompletedCheck("no_level.htm", 10885);
	}
	
	@Override
	public String onEvent(String event, QuestState st, NpcInstance npc)
	{
		switch (event)
		{
			case "leona_q10886_02.htm":
			{
				st.setCond(1);
				break;
			}
			case "leona_q10886_03.htm":
			{
				break;
			}
			case "devianne_q10886_02.htm":
			{
				st.setCond(2);
				break;
			}
			case "devianne_q10886_05.htm":
			{
				if (st.getCond() == 3)
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
						return "leona_q10886_01.htm";
					case 1:
						return "leona_q10886_02.htm";
				}
				break;
			}
			case DEVIANNE:
			{
				switch (cond)
				{
					case 1:
						return "devianne_q10886_01.htm";
					case 2:
						return "devianne_q10886_03.htm";
					case 3:
						return "devianne_q10886_04.htm";
				}
				break;
			}
		}
		return NO_QUEST_DIALOG;
	}
	
	@Override
	public String onKill(NpcInstance npc, QuestState qs)
	{
		if ((qs.getCond() == 2) && (Rnd.get(100) > 0.5) && ArrayUtils.contains(MONSTERS, npc.getNpcId()))
		{
			qs.giveItems(TOKEN_OF_ETINA, 1);
			if (qs.getQuestItemsCount(TOKEN_OF_ETINA) >= 20)
			{
				qs.setCond(3);
			}
			else
				qs.playSound(SOUND_ITEMGET);
		}
		return null;
	}
}
