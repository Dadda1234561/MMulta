package quests;

import l2s.gameserver.model.Player;
import l2s.gameserver.model.instances.NpcInstance;
import l2s.gameserver.model.quest.Quest;
import l2s.gameserver.model.quest.QuestState;
import l2s.gameserver.network.l2.components.SceneMovie;

/**
 * @author Edoo
 */
public class _10885_SaviorsPathDiscovery extends Quest
{
	// NPCs
	private static final int ELIKIA = 34057;
	private static final int LEONA = 34425;
	// Misc
	private static final int MIN_LEVEL = 103;
	
	public _10885_SaviorsPathDiscovery()
	{
		super(PARTY_ONE, ONETIME);
		addStartNpc(ELIKIA);
		addTalkId(ELIKIA);
		addTalkId(LEONA);
		addLevelCheck("no_level.htm", MIN_LEVEL);
	}
	
	@Override
	public String onEvent(String event, QuestState st, NpcInstance npc)
	{
		Player player = st.getPlayer();
		
		switch (event)
		{
			case "leona_q10885_02.htm":
			{
				break;
			}
			case "elika_q10885_02.htm":
			{
				st.setCond(1);
				break;
			}
			case "elika_q10885_04.htm":
			{
				st.setCond(2);
				player.startScenePlayer(SceneMovie.EP5_ASTATINE_QST_START);
				break;
			}
			case "elika_q10885_06.htm":
			{
				st.setCond(3);
				break;
			}
			case "leona_q10885_03.htm":
			{
				if (st.getCond() == 3)
				{
					st.addExpAndSp(906_387_492, 906_387);
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
			case ELIKIA:
			{
				switch (cond)
				{
					case 0:
						return "elika_q10885_01.htm";
					case 1:
						return "elika_q10885_03.htm";
					case 2:
						return "elika_q10885_05.htm";
					case 3:
						return "elika_q10885_07.htm";
				}
				break;
			}
			case LEONA:
			{
				switch (cond)
				{
					case 3:
						return "leona_q10885_01.htm";
				}
				break;
			}
		}
		return NO_QUEST_DIALOG;
	}
}