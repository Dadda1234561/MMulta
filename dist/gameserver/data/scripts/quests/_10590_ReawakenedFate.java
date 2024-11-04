package quests;

import org.apache.commons.lang3.ArrayUtils;

import l2s.gameserver.geometry.Location;
import l2s.gameserver.listener.actor.player.OnLevelChangeListener;
import l2s.gameserver.model.Player;
import l2s.gameserver.model.actor.listener.CharListenerList;
import l2s.gameserver.model.instances.NpcInstance;
import l2s.gameserver.model.quest.Quest;
import l2s.gameserver.model.quest.QuestState;

/**
 * @author nexvill
 */
public class _10590_ReawakenedFate extends Quest
{
	private static class ChangeLevelListener implements OnLevelChangeListener
	{
		@Override
		public void onLevelChange(Player player, int was, int set)
		{
			QuestState qs = player.getQuestState(10590);
			if(qs == null)
				return;

			if ((qs.getCond() == 2) && (qs.getQuestItemsCount(VAMPIRE_ICHOR) >= 500) && (player.getLevel() >= 99))
				qs.setCond(3);
		}
	}
	
	private static final OnLevelChangeListener LEVEL_CHANGE_LISTENER = new ChangeLevelListener();
	
	// NPCs
	private static final int JOACHIM = 34513;
	private static final int LAPATHIA = 34414;
	private static final int HERPHAH = 34362;
	private static final int ORVEN = 30857;
	private static final int[] MONSTERS =
	{
		24457, // Marsh Vampire Rogue
		24458, // Marsh Vampire Warrior
		24459, // Marsh Vampire Wizard
		24460 // Marsh Vampire Shooter
	};
	// Item
	private static final int VAMPIRE_ICHOR = 80854;
	// Rewards
	private static final int REWARD_BOX_99 = 80909;
	private static final int RUBIN_LV2 = 38856;
	private static final int SAPPHIRE_LV2 = 38928;
	// Misc
	private static final int MIN_LEVEL = 95;
	// Location
	private static final Location BLOODY_SWAMPLAND = new Location(-14467, 44242, -3673);

	public _10590_ReawakenedFate()
	{
		super(PARTY_ONE, ONETIME);
		addStartNpc(JOACHIM);
		addTalkId(JOACHIM, LAPATHIA, HERPHAH, ORVEN);
		addKillId(MONSTERS);
		addLevelCheck("low_level.htm", MIN_LEVEL);
		addQuestCompletedCheck("low_level.htm", 10589);
	}
	
	@Override
	public String onEvent(String event, QuestState st, NpcInstance npc)
	{
		Player player = st.getPlayer();
		
		switch (event)
		{
			case "joachim_q10590_04.htm":
			{
				st.setCond(1);
				break;
			}
			case "teleport":
			{
				player.teleToLocation(BLOODY_SWAMPLAND);
				return null;
			}
			case "lapathia_q10590_03.htm":
			{
				st.setCond(2);
				break;
			}
			case "joachim_q10590_08.htm":
			{
				st.setCond(4);
				break;
			}
			case "herphah_q10590_03.htm":
			{
				st.setCond(5);
				break;
			}
			case "orven_q10590_03.htm":
			{
				st.setCond(6);
				break;
			}
			case "joachim_q10590_11.htm":
			{
				st.takeAllItems(VAMPIRE_ICHOR);
				st.giveItems(REWARD_BOX_99, 1);
				st.giveItems(RUBIN_LV2, 1);
				player.setVitality(140000);
				st.finishQuest();
				break;
			}
			case "joachim_q10590_12.htm":
			{
				st.takeAllItems(VAMPIRE_ICHOR);
				st.giveItems(REWARD_BOX_99, 1);
				st.giveItems(SAPPHIRE_LV2, 1);
				player.setVitality(140000);
				st.finishQuest();
				break;
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
			case JOACHIM:
			{
				switch (cond)
				{
					case 0:
						return "joachim_q10590_01.htm";
					case 1:
						return "joachim_q10590_03.htm";
					case 2:
						return "joachim_q10590_05.htm";
					case 3:
						return "joachim_q10590_06.htm";
					case 4:
						return "joachim_q10590_08.htm";
					case 7:
						return "joachim_q10590_09.htm";
				}
				break;
			}
			case LAPATHIA:
			{
				switch (cond)
				{
					case 1:
						return "lapathia_q10590_01.htm";
					case 2:
						return "lapathia_q10590_03.htm";
					case 3:
						return "lapathia_q10590_04.htm";
				}
				break;
			}
			case HERPHAH:
			{
				switch (cond)
				{
					case 4:
						return "herphah_q10590_01.htm";
					case 5:
						return "herphah_q10590_03.htm";
				}
				break;
			}
			case ORVEN:
			{
				switch (cond)
				{
					case 5:
						return "orven_q10590_01.htm";
					case 6:
					{
						st.setCond(7);
						return "orven_q10590_04.htm";
					}
					case 7:
						return "orven_q10590_05.htm";
				}
				break;
			}
		}
		return NO_QUEST_DIALOG;
	}
	
	@Override
	public String onKill(NpcInstance npc, QuestState qs)
	{
		if ((qs.getCond() == 2) && (qs.getQuestItemsCount(VAMPIRE_ICHOR) < 500) && ArrayUtils.contains(MONSTERS, npc.getNpcId()))
		{
			qs.giveItems(VAMPIRE_ICHOR, 1);
			if ((qs.getQuestItemsCount(VAMPIRE_ICHOR) >= 500) && qs.getPlayer().getLevel() >= 99)
			{
				qs.setCond(3);	
			}
			else
				qs.playSound(SOUND_ITEMGET);
		}
		return null;
	}
	
	@Override
	public void onInit()
	{
		super.onInit();
		CharListenerList.addGlobal(LEVEL_CHANGE_LISTENER);
	}
}
