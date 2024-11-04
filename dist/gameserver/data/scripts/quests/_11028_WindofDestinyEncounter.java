/*
package quests;

import org.apache.commons.lang3.ArrayUtils;

import l2s.commons.util.Rnd;
import l2s.gameserver.geometry.Location;
import l2s.gameserver.listener.actor.player.OnClassChangeListener;
import l2s.gameserver.listener.actor.player.OnPlayerEnterListener;
import l2s.gameserver.model.Player;
import l2s.gameserver.model.actor.listener.CharListenerList;
import l2s.gameserver.model.base.ClassId;
import l2s.gameserver.model.base.ClassLevel;
import l2s.gameserver.model.base.Race;
import l2s.gameserver.model.instances.NpcInstance;
import l2s.gameserver.model.quest.Quest;
import l2s.gameserver.model.quest.QuestState;
import l2s.gameserver.network.l2.components.NpcString;
import l2s.gameserver.network.l2.s2c.ExShowScreenMessage;
import l2s.gameserver.network.l2.s2c.ExTutorialShowId;

*/
/**
 * @author nexvill
 *//*

public class _11028_WindofDestinyEncounter extends Quest
{
	private static class PlayerEnterListener implements OnPlayerEnterListener
	{
		@Override
		public void onPlayerEnter(Player player)
		{
			QuestState questState = player.getQuestState(11028);
			if((questState == null) && (player.getClassLevel() == ClassLevel.NONE)//
					&& (player.getRace() == Race.ERTHEIA))
				player.sendPacket(new ExShowScreenMessage(NpcString.TARTI_IS_WORRIED_ABOUT_S1, 40000, ExShowScreenMessage.ScreenMessageAlign.TOP_CENTER, false, player.getName()));
		}
	}
	
	private static class ClassChangeListener implements OnClassChangeListener
	{
		@Override
		public void onClassChange(Player player, ClassId oldClass, ClassId newClass)
		{
			final QuestState qs = player.getQuestState(11028);
			if ((qs != null) && qs.isCompleted() && (player.getClassLevel() == ClassLevel.FIRST)//
					&& (player.getVarBoolean(R_GRADE_ITEMS_REWARDED_VAR, false) == false)//
					&& (player.getRace() == Race.ERTHEIA))
			{
				player.setVar(R_GRADE_ITEMS_REWARDED_VAR, true);
				
				qs.giveItems(SS_R, 5000);
				qs.giveItems(BSS_R, 5000);
				
				switch (player.getClassId())
				{
					case MARAUDER:
					{
						qs.giveItems(BOX_R_LIGHT, 1);
						qs.giveItems(WEAPON_FIST_R, 1);
						break;
					}
					case CLOUD_BREAKER:
					{
						qs.giveItems(BOX_R_ROBE, 1);
						qs.giveItems(WEAPON_STAFF_R, 1);
						break;
					}
				}
			}
		}
	}
	
	private static final OnPlayerEnterListener PLAYER_ENTER_LISTENER = new PlayerEnterListener();
	private static final OnClassChangeListener CLASS_CHANGE_LISTENER = new ClassChangeListener();
	
	// NPCs
	private static final int TARTI = 34505;
	private static final int SILVAN = 33178;
	private static final int KALESIN = 33177;
	private static final int ZENATH = 33509;
	private static final int RAYMOND = 30289;
	private static final int TELESHA = 33981;
	private static final int MYSTERIOUS_WIZARD = 33980;
	
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
	private static final int[] TIER3_KILLS =
	{
		24384, // Carcass Bat
		24385 // Vampire
	};
	private static final int[] TIER4_KILLS =
	{
		24386, // Skeleton Scout
		24387, // Skeleton Archer
		24388 // Skeleton Warrior
	};
	private static final int[] TIER5_KILLS =
	{
		24389, // Spartoi Soldier
		24390 // Raging Spartoi
	};
	private static final int[] TIER6_KILLS =
	{
		27528, // Skeleton Warrior
		27529 // Skeleton Archer
	};
	
	// Items
	private static final int NOVICE_SOULSHOTS = 5789;
	private static final int NOVICE_SPIRITSHOTS = 5790;
	private static final int SOE_SILVAN = 80678;
	private static final int SOE_TARTI = 80677;
	private static final int SECRET_MATERIAL = 80950;
	private static final int BREATH_OF_DEATH = 80951;
	private static final int SOE_KALESIN = 80679;
	private static final int SOE_ZENATH = 80680;
	private static final int WIND_SPIRIT = 80952;
	// Class change rewards
	private static final int SS_R = 33780;
	private static final int BSS_R = 33794;
	private static final int BOX_R_LIGHT = 46925;
	private static final int BOX_R_ROBE = 46926;
	private static final int WEAPON_FIST_R = 47011;
	private static final int WEAPON_STAFF_R = 47017;
	// Location
	private static final Location TRAINING_GROUNDS_TELEPORT = new Location(-17447, 145170, -3816);
	private static final Location TRAINING_GROUNDS_TELEPORT2 = new Location(-19204, 138941, -3896);
	private static final Location TRAINING_GROUNDS_TELEPORT3 = new Location(-44121, 115926, -3624);
	private static final Location TRAINING_GROUNDS_TELEPORT4 = new Location(-46169, 110937, -3808);
	private static final Location TRAINING_GROUNDS_TELEPORT5 = new Location(-51130, 110053, -3664);
	private static final Location TRAINING_GROUNDS_TELEPORT6 = new Location(-4983, 116607, -3344);
	private static final Location RETURN_TO_RAYMOND_TELEPORT = new Location(-12856, 121704, -2970);
	// Misc
	private static final String NOVICE_SHOTS_REWARDED_VAR = "NOVICE_SHOTS_REWARDED";
	private static final String R_GRADE_ITEMS_REWARDED_VAR = "R_GRADE_ITEMS_REWARDED";
	private static final String A_LIST = "A_LIST";
	
	public _11028_WindofDestinyEncounter()
	{
		super(PARTY_NONE, ONETIME);
		addStartNpc(TARTI);
		addFirstTalkId(TELESHA, MYSTERIOUS_WIZARD);
		addTalkId(TARTI, SILVAN, KALESIN, ZENATH, RAYMOND, TELESHA, MYSTERIOUS_WIZARD);
		addKillId(TIER3_KILLS);
		addKillId(TIER5_KILLS);
		addKillId(TIER6_KILLS);
		addQuestItem(SECRET_MATERIAL, BREATH_OF_DEATH, WIND_SPIRIT);
		addKillNpcWithLog(3, NpcString.COMBAT_TRAINING_AT_THE_RUINS_OF_DESPAIR.getId(), A_LIST, 15, KILL_TIER1);
		addKillNpcWithLog(6, NpcString.DEFEAT_THE_SWARM_OF_ZOMBIES.getId(), A_LIST, 30, KILL_TIER2);
		addKillNpcWithLog(12, NpcString.DEFEAT_SKELETONS.getId(), A_LIST, 30, TIER4_KILLS);
		addRaceCheck("only_ertheia.htm", Race.ERTHEIA);
		addClassLevelCheck("bad_class.htm", true, ClassLevel.NONE);
	}
	
	@Override
	public String onEvent(String event, QuestState st, NpcInstance npc)
	{
		Player player = st.getPlayer();
		switch (event)
		{
			case "tarti_q11028_02.htm":
			{
				st.setCond(1);
				player.sendPacket(new ExTutorialShowId(9)); // Quest Progress
				break;
			}
			case "tarti_q11028_03.htm":
			{
				st.setCond(2);
				if (player.getVarBoolean(NOVICE_SHOTS_REWARDED_VAR, true))
				{
					player.setVar(NOVICE_SHOTS_REWARDED_VAR, false);
					st.giveItems(player.isMageClass() ? NOVICE_SPIRITSHOTS : NOVICE_SOULSHOTS, 3000);
					player.sendPacket(new ExTutorialShowId(14));
				}
				player.sendPacket(new ExShowScreenMessage(NpcString.TALK_TO_TARTI, 5000, ExShowScreenMessage.ScreenMessageAlign.TOP_CENTER, false));
				break;
			}
			case "tarti_q11028_05.htm":
			{
				st.setCond(3);
				player.sendPacket(new ExTutorialShowId(25)); // Adventurers Guide
				giveStoryBuff(npc, player);
				break;
			}
			case "teleport":
			{
				player.teleToLocation(TRAINING_GROUNDS_TELEPORT);
				return null;
			}
			case "silvan_q11028_02.htm":
			{
				st.addExpAndSp(48229, 43);
				st.setCond(5);
				giveStoryBuff(npc, player);
				break;
			}
			case "silvan_q11028_04.htm":
			{
				st.setCond(6);
				player.sendPacket(new ExTutorialShowId(2));
				giveStoryBuff(npc, player);
				break;
			}
			case "teleport2":
			{
				player.teleToLocation(TRAINING_GROUNDS_TELEPORT2);
				return null;
			}
			case "tarti_q11028_07.htm":
			{
				st.addExpAndSp(787633, 708);
				st.setCond(8);
				break;
			}
			case "tarti_q11028_11.htm":
			{
				st.setCond(9);
				giveStoryBuff(npc, player);
				player.sendPacket(new ExTutorialShowId(18)); // Quest Progress
				st.getPlayer().sendPacket(new ExShowScreenMessage(NpcString.PRESS_ALTK_TO_OPEN_THE_LEARN_SKILL_TAB_AND_LEARN_NEW_SKILLSNTHE_SKILLS_IN_THE_ACTIVE_TAB_CAN_BE_ADDED_TO_THE_SHORTCUTS, 5000, ExShowScreenMessage.ScreenMessageAlign.TOP_CENTER, false));
				break;
			}
			case "teleport3":
			{
				player.teleToLocation(TRAINING_GROUNDS_TELEPORT3);
				return null;
			}
			case "kalesin_q11028_02.htm":
			{
				st.takeAllItems(SECRET_MATERIAL);
				st.addExpAndSp(913551, 822);
				st.setCond(11);
				break;
			}
			case "kalesin_q11028_06.htm":
			{
				st.setCond(12);
				player.sendPacket(new ExTutorialShowId(19)); // Adventurers Guide
				giveStoryBuff(npc, player);
				break;
			}
			case "teleport4":
			{
				player.teleToLocation(TRAINING_GROUNDS_TELEPORT4);
				return null;
			}
			case "zenath_q11028_02.htm":
			{
				st.addExpAndSp(1_640_083, 1476);
				st.setCond(14);
				break;
			}
			case "zenath_q11028_06.htm":
			{
				st.setCond(15);
				player.sendPacket(new ExTutorialShowId(17)); // Adventurers Guide
				giveStoryBuff(npc, player);
				break;
			}
			case "teleport5":
			{
				player.teleToLocation(TRAINING_GROUNDS_TELEPORT5);
				return null;
			}
			case "tarti_q11028_14.htm":
			{
				st.takeAllItems(BREATH_OF_DEATH);
				st.addExpAndSp(4_952_686, 4457);
				st.giveItems(ADENA_ID, 165_000);
				st.getPlayer().sendPacket(new ExShowScreenMessage(NpcString.FIRST_LIBERATION_IS_AVAILABLENGO_SEE_TARTI_IN_THE_TOWN_OF_GLUDIO_TO_START_THE_CLASS_TRANSFER, 5000, ExShowScreenMessage.ScreenMessageAlign.TOP_CENTER, false));
				st.setCond(17);
				break;
			}
			case "tarti_q11028_16.htm":
			{
				if (st.getPlayer().getLevel() >= 40)
				{
					st.setCond(19);
					return "tarti_q11028_17.htm";
				}
				break;
			}
			case "raymond_q11028_03.htm":
			{
				st.setCond(20);
				st.giveItems(WIND_SPIRIT, 1);
				break;
			}
			case "teleport6":
			{
				player.teleToLocation(TRAINING_GROUNDS_TELEPORT6);
				return null;
			}
			case "wizard_spawn":
			{
				NpcInstance wizard = st.addSpawn(MYSTERIOUS_WIZARD, npc.getX(), npc.getY(), npc.getZ(), 0, 50, 360000);
				wizard.setTitle(st.getPlayer().getName());
				npc.deleteMe();
				st.getPlayer().sendPacket(new ExShowScreenMessage(NpcString.TALK_TO_THE_MYSTERIOUS_WIZARD, 5000, ExShowScreenMessage.ScreenMessageAlign.TOP_CENTER, false));
				st.setCond(21);
				return null;
			}
			case "raymond":
			{
				st.setCond(22);
				player.teleToLocation(RETURN_TO_RAYMOND_TELEPORT);
				st.giveItems(WIND_SPIRIT, 1);
				return null;
			}
			case "raymond_q11028_06.htm":
			{
				st.setCond(23);
				break;
			}
			case "tarti_q11028_24.htm":
			{
				st.giveItems(ADENA_ID, 5000);
				st.finishQuest();
				st.getPlayer().sendPacket(new ExShowScreenMessage(NpcString.CLASS_TRANSFER_IS_AVAILABLENCLICK_THE_CLASS_TRANSFER_ICON_IN_THE_NOTIFICATION_WINDOW_TO_TRANSFER_YOUR_CLASS, 5000, ExShowScreenMessage.ScreenMessageAlign.TOP_CENTER, false));
				giveStoryBuff(npc, player);
				player.sendClassChangeAlert();
				break;
			}
		}
		return event;
	}
	@Override
	public String onFirstTalk(NpcInstance npc, Player player)
	{
		final QuestState st = player.getQuestState(getId());
		if (st == null)
			return null;
		final int npcId = npc.getNpcId();
		if (npcId == TELESHA)
		{
			if (st.getCond() == 20)
				return "telesha_q11028_01.htm";
		}
		else if (npcId == MYSTERIOUS_WIZARD)
		{
			if (st.getCond() == 21)
			{
				st.getPlayer().sendPacket(new ExShowScreenMessage(NpcString.RETURN_TO_RAYMOND_OF_THE_TOWN_OF_GLUDIO, 5000, ExShowScreenMessage.ScreenMessageAlign.TOP_CENTER, false));
				return "mysterious_wizard_q11028_01.htm";
			}
			else if (st.getCond() == 22)
				return "mysterious_wizard_q11028_03.htm";
		}
		return null;
	}
	
	@Override
	public String onTalk(NpcInstance npc, QuestState st)
	{
		int npcId = npc.getNpcId();
		int cond = st.getCond();
		
		switch (npcId)
		{
			case TARTI:
			{
				switch (cond)
				{
					case 0:
						return "tarti_q11028_01.htm";
					case 1:
						return "tarti_q11028_03.htm";
					case 2:
						return "tarti_q11028_04.htm";
					case 3:
						return "tarti_q11028_05.htm";
					case 7:
						return "tarti_q11028_06.htm";
					case 8:
						return "tarti_q11028_08.htm";
					case 9:
					{
						st.getPlayer().sendPacket(new ExTutorialShowId(118));
						return "tarti_q11028_11.htm";
					}
					case 16:
						return "tarti_q11028_13.htm";
					case 17:
						return "tarti_q11028_15.htm";
					case 18:
					{
						if (st.getPlayer().getLevel() >= 40)
						{
							st.setCond(19);
							return "tarti_q11028_17.htm";
						}
						return "tarti_q11028_16.htm";
					}
					case 23:
						return "tarti_q11028_18.htm";
				}
				break;
			}
			case SILVAN:
			{
				switch (cond)
				{
					case 4:
						return "silvan_q11028_01.htm";
					case 5:
						return "silvan_q11028_03.htm";
				}
				break;
			}
			case KALESIN:
			{
				switch (cond)
				{
					case 10:
						return "kalesin_q11028_01.htm";
					case 11:
						return "kalesin_q11028_03.htm";
					case 12:
						return "kalesin_q11028_06.htm";
				}
				break;
			}
			case ZENATH:
			{
				switch (cond)
				{
					case 13:
						return "zenath_q11028_01.htm";
					case 14:
						return "zenath_q11028_03.htm";
					case 15:
						return "zenath_q11028_06.htm";
				}
				break;
			}
			case RAYMOND:
			{
				switch (cond)
				{
					case 19:
						return "raymond_q11028_01.htm";
					case 20:
						return "raymond_q11028_03.htm";
					case 22:
						return "raymond_q11028_04.htm";
					case 23:
						return "raymond_q11028_06.htm";
				}
				break;
			}
		}
		return NO_QUEST_DIALOG;
	}
	
	@Override
	public String onKill(NpcInstance npc, QuestState qs)
	{
		if ((qs.getCond() == 3) && updateKill(npc, qs))
		{
			qs.unset(A_LIST);
			qs.setCond(4);
			qs.giveItems(SOE_SILVAN, 1);
			qs.getPlayer().sendPacket(new ExShowScreenMessage(NpcString.USE_SCROLL_OF_ESCAPE_SILVAN_IN_YOUR_INVENTORYNTALK_TO_SILVAN_TO_COMPLETE_THE_QUEST, 5000, ExShowScreenMessage.ScreenMessageAlign.TOP_CENTER, false));
		}
		else if ((qs.getCond() == 6) && updateKill(npc, qs))
		{
			qs.unset(A_LIST);
			qs.setCond(7);
			qs.giveItems(SOE_TARTI, 1);
			qs.getPlayer().sendPacket(new ExShowScreenMessage(NpcString.USE_SCROLL_OF_ESCAPE_TARTI_IN_YOUR_INVENTORYNTALK_TO_TARTI_TO_COMPLETE_THE_QUEST, 5000, ExShowScreenMessage.ScreenMessageAlign.TOP_CENTER, false));
		}
		else if ((qs.getCond() == 9) && (Rnd.get(100) > 10) && ArrayUtils.contains(TIER3_KILLS, npc.getNpcId()))
		{
			qs.giveItems(SECRET_MATERIAL, 1);
			if (qs.getQuestItemsCount(SECRET_MATERIAL) >= 15)
			{
				qs.setCond(10);
				qs.giveItems(SOE_KALESIN, 1);
				qs.getPlayer().sendPacket(new ExShowScreenMessage(NpcString.USE_SCROLL_OF_ESCAPE_KALLESIN_IN_YOUR_INVENTORYNTALK_TO_KALLESIN_TO_COMPLETE_THE_QUEST, 5000, ExShowScreenMessage.ScreenMessageAlign.TOP_CENTER, false));
			}
			else
				qs.playSound(SOUND_ITEMGET);
		}
		else if ((qs.getCond() == 12) && updateKill(npc, qs))
		{
			qs.unset(A_LIST);
			qs.setCond(13);
			qs.giveItems(SOE_ZENATH, 1);
			qs.getPlayer().sendPacket(new ExShowScreenMessage(NpcString.USE_SCROLL_OF_ESCAPE_ZENATH_IN_YOUR_INVENTORYNTALK_TO_ZENATH_TO_COMPLETE_THE_QUEST, 5000, ExShowScreenMessage.ScreenMessageAlign.TOP_CENTER, false));
		}
		else if ((qs.getCond() == 15) && (Rnd.get(100) > 10) && ArrayUtils.contains(TIER5_KILLS, npc.getNpcId()))
		{
			qs.giveItems(BREATH_OF_DEATH, 1);
			if (qs.getQuestItemsCount(BREATH_OF_DEATH) >= 15)
			{
				qs.setCond(16);
				qs.giveItems(SOE_TARTI, 1);
				qs.getPlayer().sendPacket(new ExShowScreenMessage(NpcString.USE_SCROLL_OF_ESCAPE_TARTI_IN_YOUR_INVENTORYNTALK_TO_TARTI_TO_COMPLETE_THE_QUEST, 5000, ExShowScreenMessage.ScreenMessageAlign.TOP_CENTER, false));
			}
			else
				qs.playSound(SOUND_ITEMGET);
		}
		else if (((qs.getCond() == 19) || (qs.getCond() == 20)) && ArrayUtils.contains(TIER6_KILLS, npc.getNpcId()))
		{
			NpcInstance telesha = qs.addSpawn(TELESHA, npc.getX(), npc.getY(), npc.getZ(), 0, 50, 360000);
			telesha.setTitle(qs.getPlayer().getName());
			qs.getPlayer().sendPacket(new ExShowScreenMessage(NpcString.CHECK_ON_TELESHA, 5000, ExShowScreenMessage.ScreenMessageAlign.TOP_CENTER, false));
			qs.setCond(20);
		}
		return null;
	}
	
	@Override
	public void onInit()
	{
		super.onInit();
		CharListenerList.addGlobal(PLAYER_ENTER_LISTENER);
		CharListenerList.addGlobal(CLASS_CHANGE_LISTENER);
	}
}
*/
