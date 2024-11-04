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
import l2s.gameserver.model.entity.Reflection;
import l2s.gameserver.model.instances.NpcInstance;
import l2s.gameserver.model.quest.Quest;
import l2s.gameserver.model.quest.QuestState;
import l2s.gameserver.network.l2.components.NpcString;
import l2s.gameserver.network.l2.components.UsmVideo;
import l2s.gameserver.network.l2.s2c.ExShowScreenMessage;
import l2s.gameserver.network.l2.s2c.ExShowScreenMessage.ScreenMessageAlign;
import l2s.gameserver.utils.Functions;
import l2s.gameserver.utils.ReflectionUtils;

import instances.ChamberOfProphecies;

*/
/**
 * @author nexvill
 *//*

public class _11030_WindofDestinyChoice extends Quest
{
	private static class PlayerEnterListener implements OnPlayerEnterListener
	{
		@Override
		public void onPlayerEnter(Player player)
		{
			QuestState questState = player.getQuestState(11030);
			if((questState == null) && (player.getLevel() >= MIN_LEVEL)//
					&& (player.getClassLevel() == ClassLevel.SECOND)//
					&& (player.getRace() == Race.ERTHEIA))
				player.sendPacket(new ExShowScreenMessage(NpcString.TALK_TO_TARTI, 10000, ExShowScreenMessage.ScreenMessageAlign.TOP_CENTER, false));
		}
	}
	
	private static class ClassChangeListener implements OnClassChangeListener
	{
		@Override
		public void onClassChange(Player player, ClassId oldClass, ClassId newClass)
		{
			final QuestState qs = player.getQuestState(11030);
			if ((qs != null) && qs.isCompleted() && (player.getClassLevel() == ClassLevel.THIRD)//
					&& (player.getVarBoolean(AWAKE_POWER_REWARDED_VAR, false) == false)//
					&& (player.getRace() == Race.ERTHEIA))
			{
				player.setVar(AWAKE_POWER_REWARDED_VAR, true);
				
				switch (player.getClassId().getId())
				{
					case 188: // Eviscerator
					{
						qs.giveItems(EVISCERATOR_BOX, 1);
						break;
					}
					case 189: // Sayha's Seer
					{
						qs.giveItems(SAYHA_SEER_BOX, 1);
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
	private static final int RECLOUS = 30648;
	private static final int RAYMOND = 30289;
	private static final int GERETH = 33932;
	private static final int KAIN_VAN_HALTER = 33979;
	private static final int FERIN = 34001;
	private static final int GRAIL = 33996;
	private static final int MYSTERIOUS_WIZARD = 33980;
	
	private static final int MAKKUM = 19571;
	
	private static final int[] TIER1_KILLS =
	{
		24403, // Turek War Hound
		24404 // Turek Orc Footman
	};
	private static final int[] TIER2_KILLS =
	{
		24405, // Turek Orc Archer
		24406 // Turek Orc Skirmisher
	};
	private static final int[] TIER3_KILLS =
	{
		24407, // Turek Orc Prefect
		24408 // Turek Orc Priest
	};
	private static final int[] TIER4_KILLS =
	{
		24409, // Ketra Orc Raider
		24410 // Ketra Orc Warrior
	};
	private static final int[] TIER5_KILLS =
	{
		24411, // Ketra Orc Scout
		24412 // Ketra Orc Priest
	};
	private static final int[] TIER6_KILLS =
	{
		24413, // Ketra Orc Officer
		24414 // Ketra Orc Captain
	};
	
	// Items
	private static final int SOE_RECLOUS = 80682;
	private static final int SOE_TARTI = 80677;
	private static final int PROPHECY_MACHINE = 39540;
	private static final int ATELIA = 39542;
	private static final int ORC_EMPOWERING_POTION = 80675;
	private static final int KETRA_ORDER = 80676;
	private static final int CHAOS_POMANDER = 37374;
	private static final int EVISCERATOR_BOX = 40268;
	private static final int SAYHA_SEER_BOX = 40269;
	private static final int VITALITY_MAINTAINING_RUNE = 81206;
	
	// Location
	private static final Location TRAINING_GROUNDS_TELEPORT1 = new Location(-88074, 112194, -3144);
	private static final Location TRAINING_GROUNDS_TELEPORT2 = new Location(-92290, 116512, -3472);
	private static final Location TRAINING_GROUNDS_TELEPORT3 = new Location(-92680, 112394, -3696);
	private static final Location TRAINING_GROUNDS_TELEPORT4 = new Location(-94271, 109153, -3856);
	private static final Location TRAINING_GROUNDS_TELEPORT5 = new Location(-94258, 102141, -3472);
	private static final Location TRAINING_GROUNDS_TELEPORT6 = new Location(-87089, 103524, -3360);
	private static final Location TELEPORT_1 = new Location(-78670, 251026, -2960);
	private static final Location TELEPORT_2 = new Location(-14180, 123840, -3120);
	
	// Misc
	private static final String A_LIST = "A_LIST";
	private static final String AWAKE_POWER_REWARDED_VAR = "AWAKE_POWER_REWARDED";
	private static final int MIN_LEVEL = 76;
	private static final String WIZARD_MSG_TIMER_ID_VAR = "wizard_msg_timer_id";
	private static final String DESPAWN_WIZARD_TIMER_ID_VAR = "despawn_wizard_timer_id";
	private static final String END_INSTANCE_TIMER_ID_VAR = "end_instance_timer_id";
	private static final String WIZARD_TALKED_VAR = "wizard_talked";
	private static final String GRAIL_SPAWN_GROUP = "cop_grail";
	private static final String WIZARD_SPAWN_GROUP = "cop_wizard";
	private static final String HALTER_SPAWN_GROUP_1 = "cop_halter_1";
	private static final String HALTER_SPAWN_GROUP_2 = "cop_halter_2";
	private static final int INSTANCE_ZONE_ID = 255;
	private long _wait_timeout = 0;
	
	public _11030_WindofDestinyChoice()
	{
		super(PARTY_NONE, ONETIME);
		addStartNpc(TARTI);
		addTalkId(TARTI, RECLOUS, GERETH, RAYMOND, KAIN_VAN_HALTER, GRAIL, MYSTERIOUS_WIZARD);
		addFirstTalkId(FERIN, MYSTERIOUS_WIZARD);
		addAttackId(MAKKUM);
		addKillId(TIER3_KILLS);
		addKillId(TIER5_KILLS);
		addQuestItem(ORC_EMPOWERING_POTION, KETRA_ORDER, ATELIA, PROPHECY_MACHINE);
		addKillNpcWithLog(1, NpcString.DEFEAT_TUREK_WAR_HOUNDS_AND_FOOTMEN.getId(), A_LIST, 30, TIER1_KILLS);
		addKillNpcWithLog(4, NpcString.DEFEAT_TUREK_ARCHERS_AND_SKIRMISHERS.getId(), A_LIST, 30, TIER2_KILLS);
		addKillNpcWithLog(10, NpcString.DEFEAT_KETRA_RAIDERS_AND_WARRIORS.getId(), A_LIST, 30, TIER4_KILLS);
		addKillNpcWithLog(16, NpcString.DEFEAT_KETRA_OFFICERS_AND_CAPTAIN.getId(), A_LIST, 30, TIER6_KILLS);
		addLevelCheck("low_level.htm", MIN_LEVEL);
		addRaceCheck("only_ertheia.htm", Race.ERTHEIA);
		addClassLevelCheck("bad_class.htm", true, ClassLevel.SECOND);
		addQuestCompletedCheck("low_level.htm", 11029);
	}
	
	@Override
	public String onAttack(NpcInstance npc, QuestState st)
	{
		Player player = st.getPlayer();
		int npcId = npc.getNpcId();
		ChamberOfProphecies cop = (ChamberOfProphecies) player.getActiveReflection();

		if(npcId == MAKKUM && System.currentTimeMillis() > _wait_timeout)
		{
			_wait_timeout = System.currentTimeMillis() + 8000;
			player.sendPacket(new ExShowScreenMessage(NpcString.LEAVE_THIS_PLACE_TO_KAINNGO_TO_THE_NEXT_ROOM, 7000, ScreenMessageAlign.TOP_CENTER, true));
			if(cop != null)
			{
				if(cop.getVanHalter() != null && Rnd.chance(30))
					Functions.npcSay(cop.getVanHalter(), NpcString.LEAVE_THIS_TO_ME_GO);
				if(cop.getFerrin() != null && Rnd.chance(30))
					Functions.npcSay(cop.getFerrin(), NpcString.GO_NOW_KAIN_CAN_HANDLE_THIS);
			}
		}
		return null;
	}
	
	@Override
	public String onEvent(String event, QuestState st, NpcInstance npc)
	{
		final Player player = st.getPlayer();
		final Reflection reflection = player.getReflection();
		
		switch (event)
		{
			case "tarti_q11030_03.htm":
			{
				st.setCond(1);
				giveStoryBuff(npc, player);
				break;
			}
			case "teleport1":
			{
				player.teleToLocation(TRAINING_GROUNDS_TELEPORT1);
				return null;
			}
			case "reclous_q11030_02.htm":
			{
				st.addExpAndSp(392_513_005, 353_261);
				st.setCond(3);
				break;
			}
			case "reclous_q11030_03.htm":
			{
				st.setCond(4);
				giveStoryBuff(npc, player);
				break;
			}
			case "teleport2":
			{
				player.teleToLocation(TRAINING_GROUNDS_TELEPORT2);
				return null;
			}
			case "reclous_q11030_07.htm":
			{
				st.addExpAndSp(581_704_958, 523_534);
				st.setCond(6);
				break;
			}
			case "reclous_q11030_08.htm":
			{
				st.setCond(7);
				giveStoryBuff(npc, player);
				break;
			}
			case "teleport3":
			{
				player.teleToLocation(TRAINING_GROUNDS_TELEPORT3);
				return null;
			}
			case "reclous_q11030_12.htm":
			{
				st.takeAllItems(ORC_EMPOWERING_POTION);
				st.addExpAndSp(750_392_145, 675_352);
				st.setCond(9);
				break;
			}
			case "reclous_q11030_13.htm":
			{
				st.setCond(10);
				giveStoryBuff(npc, player);
				break;
			}
			case "teleport4":
			{
				player.teleToLocation(TRAINING_GROUNDS_TELEPORT4);
				return null;
			}
			case "reclous_q11030_17.htm":
			{
				st.addExpAndSp(452_984_693, 407_684);
				st.setCond(12);
				break;
			}
			case "reclous_q11030_18.htm":
			{
				st.setCond(13);
				giveStoryBuff(npc, player);
				break;
			}
			case "teleport5":
			{
				player.teleToLocation(TRAINING_GROUNDS_TELEPORT5);
				return null;
			}
			case "reclous_q11030_22.htm":
			{
				st.takeAllItems(KETRA_ORDER);
				st.addExpAndSp(514_892_511, 463_403);
				st.setCond(15);
				break;
			}
			case "reclous_q11030_23.htm":
			{
				st.setCond(16);
				giveStoryBuff(npc, player);
				break;
			}
			case "teleport6":
			{
				player.teleToLocation(TRAINING_GROUNDS_TELEPORT6);
				return null;
			}
			case "tarti_q11030_06.htm":
			{
				st.addExpAndSp(1_176_372_111L, 527_586);
				st.giveItems(ADENA_ID, 420_000);
				st.setCond(18);
				giveStoryBuff(npc, player);
				player.sendPacket(new ExShowScreenMessage(NpcString.THIRD_LIBERATION_IS_AVAILABLENGO_SEE_TARTI_IN_THE_TOWN_OF_GLUDIO_TO_START_THE_CLASS_TRANSFER, 5000, ExShowScreenMessage.ScreenMessageAlign.TOP_CENTER, false));
				break;
			}
			case "tarti_q11030_07.htm":
			{
				st.setCond(19);
				break;
			}
			case "tarti_q11030_08.htm":
			{
				if (player.getLevel() >= 85)
				{
					st.setCond(20);
					return "tarti_q11030_09.htm";
				}
				break;
			}
			case "raymond_q11030_02.htm":
			{
				st.setCond(21);
				st.giveItems(PROPHECY_MACHINE, 1);
				break;
			}
			case "teleport":
			{
				player.teleToLocation(TELEPORT_1);
				return null;
			}
			case "enterInstance":
			{
				if(st.getCond() == 21)
				{
					if(!enterInstance(st.getPlayer()))
						return "you cannot enter this instance";
				}
				return null;
			}
			case "continueInstance":
			{
				if(st.getCond() == 22)
				{
					if(checkReflection(reflection))
					{
						ChamberOfProphecies cop = (ChamberOfProphecies) player.getActiveReflection();
						if(cop != null)
							cop.initFriend(player);
						player.teleToLocation(-88504, 184680, -10476, player.getReflection());
						return null;
					}
				}
				return null;
			}
			case "grail_q11030_02.htm":
			{
				if(st.getCond() == 22)
				{
					if(checkReflection(reflection))
					{
						st.giveItems(ATELIA, 1);
						player.sendPacket(UsmVideo.Q015.packet(player));
						reflection.despawnByGroup(GRAIL_SPAWN_GROUP);
						reflection.spawnByGroup(WIZARD_SPAWN_GROUP);
						player.sendPacket(new ExShowScreenMessage(NpcString.TALK_TO_THE_MYSTERIOUS_WIZARD, 10000, ScreenMessageAlign.TOP_CENTER));
						st.startQuestTimer(WIZARD_MSG_TIMER_ID_VAR, 12000);
					}
				}
				break;
			}
			case WIZARD_MSG_TIMER_ID_VAR:
			{
				if(st.getCond() == 22)
				{
					if(checkReflection(reflection) && st.getInt(WIZARD_TALKED_VAR) == 0)
					{
						st.getPlayer().sendPacket(new ExShowScreenMessage(NpcString.TALK_TO_THE_MYSTERIOUS_WIZARD, 5000, ScreenMessageAlign.TOP_CENTER));
						st.startQuestTimer(WIZARD_MSG_TIMER_ID_VAR, 7000);
					}
				}
				return null;
			}
			case "mysterious_wizard_q11030_04.htm":
			{
				if(st.getCond() == 22)
				{
					if(checkReflection(reflection))
						player.sendPacket(new ExShowScreenMessage(NpcString.THIS_CHOICE_CANNOT_BE_REVERSED, 10000, ScreenMessageAlign.TOP_CENTER));
				}
				break;
			}
			case "mysterious_wizard_q11030_06.htm":
			{
				if(st.getCond() == 22)
				{
					if(checkReflection(reflection))
					{
						ChamberOfProphecies cop = (ChamberOfProphecies) player.getActiveReflection();
						if(cop != null)
							cop.clear();
						st.set(WIZARD_TALKED_VAR, 2, false);
						st.startQuestTimer(DESPAWN_WIZARD_TIMER_ID_VAR, 3000);
						reflection.despawnByGroup(HALTER_SPAWN_GROUP_1);
						reflection.spawnByGroup(HALTER_SPAWN_GROUP_2);
					}
				}
				break;
			}
			case DESPAWN_WIZARD_TIMER_ID_VAR:
			{
				if(st.getCond() == 22)
				{
					final Reflection activeReflection = player.getActiveReflection();
					if(checkReflection(activeReflection))
						activeReflection.despawnByGroup(WIZARD_SPAWN_GROUP);
				}
				return null;
			}
			case "finishInstance":
			{
				if(st.getCond() == 22)
				{
					if(checkReflection(reflection))
					{
						st.setCond(23);
						st.startQuestTimer(END_INSTANCE_TIMER_ID_VAR, 3000);
					}
				}
				return null;
			}
			case END_INSTANCE_TIMER_ID_VAR:
			{
				if(st.getCond() == 23)
				{
					final Reflection activeReflection = player.getActiveReflection();
					if(checkReflection(activeReflection))
						activeReflection.collapse();
				}
				return null;
			}
			case "teleport_k":
			{
				player.teleToLocation(TELEPORT_2);
				return null;
			}
			case "tarti_q11030_12.htm":
			{
				st.addExpAndSp(14_281_098, 12_852);
				st.giveItems(CHAOS_POMANDER, 2);
				st.giveItems(VITALITY_MAINTAINING_RUNE, 1);
				st.finishQuest();
				giveStoryBuff(npc, player);
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
		
		switch (npcId)
		{
			case TARTI:
			{
				switch (cond)
				{
					case 0:
						return "tarti_q11030_01.htm";
					case 1:
						return "tarti_q11030_03.htm";
					case 17:
						return "tarti_q11030_05.htm";
					case 18:
					case 19:
						return "tarti_q11030_07.htm";
					case 20:
						return "tarti_q11030_10.htm";
					case 24:
					{
						if (st.haveQuestItem(ATELIA))
						{
							return "tarti_q11030_11.htm";
						}
						break;
					}
				}
				break;
			}
			case RECLOUS:
			{
				switch (cond)
				{
					case 2:
						return "reclous_q11030_01.htm";
					case 3:
						return "reclous_q11030_02.htm";
					case 4:
						return "reclous_q11030_05.htm";
					case 5:
						return "reclous_q11030_06.htm";
					case 6:
						return "reclous_q11030_07.htm";
					case 7:
						return "reclous_q11030_10.htm";
					case 8:
						return "reclous_q11030_11.htm";
					case 9:
						return "reclous_q11030_12.htm";
					case 10:
						return "reclous_q11030_15.htm";
					case 11:
						return "reclous_q11030_16.htm";
					case 12:
						return "reclous_q11030_17.htm";
					case 13:
						return "reclous_q11030_20.htm";
					case 14:
						return "reclous_q11030_21.htm";
					case 15:
						return "reclous_q11030_22.htm";
					case 16:
						return "reclous_q11030_25.htm";
				}
				break;
			}
			case RAYMOND:
			{
				switch (cond)
				{
					case 20:
						return "raymond_q11030_01.htm";
					case 24:
						return "raymond_q11030_04.htm";
				}
				break;
			}
			case GERETH:
			{
				switch (cond)
				{
					case 21:
						return "gereth_q11030_01.htm";
					case 22:
						return "gereth_q11030_06.htm";
					case 23:
					{
						st.setCond(24);
						return "gereth_q11030_07.htm";
					}
					case 24:
						return "gereth_q11030_08.htm";
				}
				break;
			}
			case KAIN_VAN_HALTER:
			{
				if(cond == 22)
				{
					final int talk = st.getInt(WIZARD_TALKED_VAR);
					if(talk == 0 || talk == 1)
						return "kain_van_halter_q11030_01.htm";
					else if(talk == 2)
						return "kain_van_halter_q11030_02.htm";
				}
				else if(cond == 23)
					return "kain_van_halter_q11030_03.htm";
				break;
			}
			case GRAIL:
			{
				if(cond == 22)
					return "grail_q11030_01.htm";
				break;
			}
		}
		return NO_QUEST_DIALOG;
	}
	
	@Override
	public String onFirstTalk(NpcInstance npc, Player player)
	{
		final QuestState st = player.getQuestState(getId());
		if(st == null)
			return null;

		final int npcId = npc.getNpcId();
		final int cond = st.getCond();
		
		if(npcId == MYSTERIOUS_WIZARD)
		{
			if(cond == 22)
			{
				final int talk = st.getInt(WIZARD_TALKED_VAR);
				if(talk == 0 || talk == 1)
				{
					if(talk == 0)
						st.set(WIZARD_TALKED_VAR, 1, false);
					return "mysterious_wizard_q11030_01.htm";
				}
			}
		}
		return null;
	}
	
	@Override
	public String onKill(NpcInstance npc, QuestState qs)
	{
		if ((qs.getCond() == 1) && updateKill(npc, qs))
		{
			qs.unset(A_LIST);
			qs.setCond(2);
			qs.giveItems(SOE_RECLOUS, 1);
			qs.getPlayer().sendPacket(new ExShowScreenMessage(NpcString.USE_SCROLL_OF_ESCAPE_RECLOUS_IN_YOUR_INVENTORYNTALK_TO_RECLOUS_TO_COMPLETE_THE_QUEST, 5000, ExShowScreenMessage.ScreenMessageAlign.TOP_CENTER, false));
		}
		else if ((qs.getCond() == 4) && updateKill(npc, qs))
		{
			qs.unset(A_LIST);
			qs.setCond(5);
			qs.giveItems(SOE_RECLOUS, 1);
			qs.getPlayer().sendPacket(new ExShowScreenMessage(NpcString.USE_SCROLL_OF_ESCAPE_RECLOUS_IN_YOUR_INVENTORYNTALK_TO_RECLOUS_TO_COMPLETE_THE_QUEST, 5000, ExShowScreenMessage.ScreenMessageAlign.TOP_CENTER, false));
		}
		else if ((qs.getCond() == 7) && (Rnd.get(100) > 10) && ArrayUtils.contains(TIER3_KILLS, npc.getNpcId()))
		{
			qs.giveItems(ORC_EMPOWERING_POTION, 1);
			if (qs.getQuestItemsCount(ORC_EMPOWERING_POTION) >= 15)
			{
				qs.setCond(8);
				qs.giveItems(SOE_RECLOUS, 1);
				qs.getPlayer().sendPacket(new ExShowScreenMessage(NpcString.USE_SCROLL_OF_ESCAPE_RECLOUS_IN_YOUR_INVENTORYNTALK_TO_RECLOUS_TO_COMPLETE_THE_QUEST, 5000, ExShowScreenMessage.ScreenMessageAlign.TOP_CENTER, false));
			}
			else
				qs.playSound(SOUND_ITEMGET);
		}
		else if ((qs.getCond() == 10) && updateKill(npc, qs))
		{
			qs.unset(A_LIST);
			qs.setCond(11);
			qs.giveItems(SOE_RECLOUS, 1);
			qs.getPlayer().sendPacket(new ExShowScreenMessage(NpcString.USE_SCROLL_OF_ESCAPE_RECLOUS_IN_YOUR_INVENTORYNTALK_TO_RECLOUS_TO_COMPLETE_THE_QUEST, 5000, ExShowScreenMessage.ScreenMessageAlign.TOP_CENTER, false));
		}
		else if ((qs.getCond() == 13) && (Rnd.get(100) > 10) && ArrayUtils.contains(TIER5_KILLS, npc.getNpcId()))
		{
			qs.giveItems(KETRA_ORDER, 1);
			if (qs.getQuestItemsCount(KETRA_ORDER) >= 15)
			{
				qs.setCond(14);
				qs.giveItems(SOE_RECLOUS, 1);
				qs.getPlayer().sendPacket(new ExShowScreenMessage(NpcString.USE_SCROLL_OF_ESCAPE_RECLOUS_IN_YOUR_INVENTORYNTALK_TO_RECLOUS_TO_COMPLETE_THE_QUEST, 5000, ExShowScreenMessage.ScreenMessageAlign.TOP_CENTER, false));
			}
			else
				qs.playSound(SOUND_ITEMGET);
		}
		else if ((qs.getCond() == 16) && updateKill(npc, qs))
		{
			qs.unset(A_LIST);
			qs.setCond(17);
			qs.giveItems(SOE_TARTI, 1);
			qs.getPlayer().sendPacket(new ExShowScreenMessage(NpcString.USE_SCROLL_OF_ESCAPE_TARTI_IN_YOUR_INVENTORYNTALK_TO_TARTI_TO_COMPLETE_THE_QUEST, 5000, ExShowScreenMessage.ScreenMessageAlign.TOP_CENTER, false));
		}
		return null;
	}
	
	private boolean checkReflection(Reflection reflection)
	{
		return reflection != null && reflection.getInstancedZoneId() == INSTANCE_ZONE_ID;
	}

	private boolean enterInstance(Player player)
	{
		Reflection reflection = player.getActiveReflection();
		if(reflection != null)
		{
			if(player.canReenterInstance(INSTANCE_ZONE_ID))
				player.teleToLocation(reflection.getTeleportLoc(), reflection);
		}
		else if(player.canEnterInstance(INSTANCE_ZONE_ID))
		{
			ChamberOfProphecies ioe = (ChamberOfProphecies) ReflectionUtils.enterReflection(player, new ChamberOfProphecies(player), INSTANCE_ZONE_ID);
			if(ioe != null)
				ioe.stageStart(1);
		}
		else
			return false;
		player.getQuestState(getId()).setCond(22);
		return true;
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
