package quests;

import l2s.gameserver.geometry.Location;
import l2s.gameserver.listener.actor.player.OnPlayerEnterListener;
import l2s.gameserver.model.Player;
import l2s.gameserver.model.actor.listener.CharListenerList;
import l2s.gameserver.model.base.ClassLevel;
import l2s.gameserver.model.base.Race;
import l2s.gameserver.model.instances.NpcInstance;
import l2s.gameserver.model.quest.Quest;
import l2s.gameserver.model.quest.QuestState;
import l2s.gameserver.network.l2.components.NpcString;
import l2s.gameserver.network.l2.s2c.ExShowScreenMessage;

public class _11024_PathofDestinyBeginning extends Quest
{
	private static class PlayerEnterListener implements OnPlayerEnterListener
	{
		@Override
		public void onPlayerEnter(Player player)
		{
			QuestState questState = player.getQuestState(11024);
			if((questState == null) && (player.getClassLevel() == ClassLevel.NONE))
				player.sendPacket(new ExShowScreenMessage(NpcString.TARTI_IS_WORRIED_ABOUT_S1, 40000, ExShowScreenMessage.ScreenMessageAlign.TOP_CENTER, false, player.getName()));
		}
	}
	
	// NPCs
	private static final int TARTI = 34505;
	private static final int SILVAN = 33178;
	
	// Items
	private static final int NOVICE_SOULSHOTS = 5789;
	private static final int NOVICE_SPIRITSHOTS = 5790;
	private static final int SHOTS_COUNT = 3000;
	private static final int SOE_SILVAN = 80678;
	private static final int SOE_TARTI = 80677;
	
	// Location
	private static final Location TRAINING_GROUNDS_TELEPORT = new Location(-17447, 145170, -3816);
	private static final Location TRAINING_GROUNDS_TELEPORT2 = new Location(-19204, 138941, -3896);
	
	// Vars
	private static final String A_LIST = "A_LIST";
	private static final String B_LIST = "B_LIST";
	private static final String NOVICE_SHOTS_REWARDED_VAR = "NOVICE_SHOTS_REWARDED";
	
	private static final int[] KILL_TIER1 =
	{
		24380, // Nasty Eye
		24381 // Nasty Buggle
	};
	private static final int[] KILL_TIER2 =
	{
		24382, // Nasty Zombie
		24383 // Nasty Zombie Lord
	};
	
	private static final OnPlayerEnterListener PLAYER_ENTER_LISTENER = new PlayerEnterListener();
	
	public _11024_PathofDestinyBeginning()
	{
		super(PARTY_NONE, ONETIME);
		addStartNpc(TARTI);
		addTalkId(TARTI, SILVAN);
		addKillNpcWithLog(3, NpcString.COMBAT_TRAINING_AT_THE_RUINS_OF_DESPAIR.getId(), A_LIST, 15, KILL_TIER1);
		addKillNpcWithLog(6, NpcString.DEFEAT_THE_SWARM_OF_ZOMBIES.getId(), B_LIST, 30, KILL_TIER2);
		//addRaceCheck("bad_class.htm", Race.HUMAN, Race.ELF, Race.DARKELF, Race.ORC, Race.DWARF, Race.KAMAEL, Race.ERTHEIA);
		addClassLevelCheck("bad_class.htm", false, ClassLevel.NONE);
	}
	
	@Override
	public String onEvent(String event, QuestState st, NpcInstance npc)
	{
		Player player = st.getPlayer();
		
		switch (event)
		{
			case "tarti_q11024_02.htm":
			{
				st.setCond(1);
				//player.sendPacket(new ExTutorialShowId(9));
				break;
			}
			case "tarti_q11024_03.htm":
			{
				st.setCond(2);
				if (player.getVarBoolean(NOVICE_SHOTS_REWARDED_VAR, true))
				{
					player.setVar(NOVICE_SHOTS_REWARDED_VAR, false);
					st.giveItems(player.isMageClass() ? NOVICE_SPIRITSHOTS : NOVICE_SOULSHOTS, SHOTS_COUNT);
					//player.sendPacket(new ExTutorialShowId(14));
				}
				player.sendPacket(new ExShowScreenMessage(NpcString.TALK_TO_TARTI, 5000, ExShowScreenMessage.ScreenMessageAlign.TOP_CENTER, false));
				break;
			}
			case "tarti_q11024_05.htm":
			{
				st.setCond(3);
				//player.sendPacket(new ExTutorialShowId(25));
				giveStoryBuff(npc, player);
				break;
			}
			case "teleport":
			{
				player.teleToLocation(TRAINING_GROUNDS_TELEPORT);
				return null;
			}
			case "silvan_q11024_02.htm":
			{
				if (st.getCond() == 4)
				{
					st.addExpAndSp(48229, 150000);
					st.giveItems(70015, 1000);
					st.giveItems(57, 150000);
					st.setCond(5);
					giveStoryBuff(npc, player);
				}
				break;
			}
			case "silvan_q11024_04.htm":
			{
				st.setCond(6);
				//player.sendPacket(new ExTutorialShowId(2));
				giveStoryBuff(npc, player);
				break;
			}
			case "teleport2":
			{
				player.teleToLocation(TRAINING_GROUNDS_TELEPORT2);
				return null;
			}
			case "tarti_q11024_07.htm":
			{
				st.setCond(8);
				break;
			}
			case "tarti_q11024_08.htm":
			{
				st.addExpAndSp(787633, 15000);
				st.giveItems(70015, 1000);
				st.giveItems(70067, 1);
				st.giveItems(57, 150000);
				//player.sendPacket(new ExTutorialShowId(118));
				player.sendPacket(new ExShowScreenMessage(NpcString.FIRST_CLASS_TRANSFER_IS_AVAILABLENGO_SEE_TARTI_IN_THE_TOWN_OF_GLUDIO_TO_START_THE_CLASS_TRANSFER, 5000, ExShowScreenMessage.ScreenMessageAlign.TOP_CENTER, false));
				st.setCond(9);
				break;
			}
			case "tarti_q11024_09.htm":
			{
				player.sendPacket(new ExShowScreenMessage(NpcString.CLASS_TRANSFER_IS_AVAILABLENCLICK_THE_CLASS_TRANSFER_ICON_IN_THE_NOTIFICATION_WINDOW_TO_TRANSFER_YOUR_CLASS, 5000, ExShowScreenMessage.ScreenMessageAlign.TOP_CENTER, false));
				giveStoryBuff(npc, player);
				st.finishQuest();
				player.sendClassChangeAlert();
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
		
		if (npcId == TARTI)
		{
			switch (cond)
			{
				case 0:
					return "tarti_q11024_01.htm";
				case 1:
					return "tarti_q11024_02.htm";
				case 2:
					return "tarti_q11024_04.htm";
				case 3:
					return "tarti_q11024_05.htm";
				case 7:
					return "tarti_q11024_06.htm";
				case 9:
				{
					//st.getPlayer().sendPacket(new ExTutorialShowId(118));
					return "tarti_q11024_08.htm";
				}
			}
		}
		else if (npcId == SILVAN)
		{
			if (cond == 4)
				return "silvan_q11024_01.htm";
			else if (cond == 5)
				return "silvan_q11024_03.htm";
			else if (cond == 6)
				return "silvan_q11024_04.htm";
		}
		
		return NO_QUEST_DIALOG;
	}
	
	@Override
	public String onKill(NpcInstance npc, QuestState qs)
	{
		if ((qs.getCond() != 3) && (qs.getCond() != 6))
		{
			return null;
		}
		
		if ((qs.getCond() == 3) && updateKill(npc, qs))
		{
			qs.unset(A_LIST);
			qs.setCond(4);
			qs.giveItems(SOE_SILVAN, 1);
			qs.getPlayer().sendPacket(new ExShowScreenMessage(NpcString.USE_SCROLL_OF_ESCAPE_SILVAN_IN_YOUR_INVENTORYNTALK_TO_SILVAN_TO_COMPLETE_THE_QUEST, 5000, ExShowScreenMessage.ScreenMessageAlign.TOP_CENTER, false));
		}
		else if ((qs.getCond() == 6) && updateKill(npc, qs))
		{
			qs.unset(B_LIST);
			qs.setCond(7);
			qs.giveItems(SOE_TARTI, 1);
			qs.getPlayer().sendPacket(new ExShowScreenMessage(NpcString.USE_SCROLL_OF_ESCAPE_TARTI_IN_YOUR_INVENTORYNTALK_TO_TARTI_TO_COMPLETE_THE_QUEST, 5000, ExShowScreenMessage.ScreenMessageAlign.TOP_CENTER, false));
		}		
		return null;
	}
	
	@Override
	public void onInit()
	{
		super.onInit();
		CharListenerList.addGlobal(PLAYER_ENTER_LISTENER);
	}
}
