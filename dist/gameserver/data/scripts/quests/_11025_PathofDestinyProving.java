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

public class _11025_PathofDestinyProving extends Quest
{
	private static class PlayerEnterListener implements OnPlayerEnterListener
	{
		@Override
		public void onPlayerEnter(Player player)
		{
			QuestState questState = player.getQuestState(11025);
			if((questState == null) && (player.getLevel() >= MIN_LEVEL)//
					&& (player.getClassLevel() == ClassLevel.FIRST)//
					&& (player.getRace() != Race.ERTHEIA))
				player.sendPacket(new ExShowScreenMessage(NpcString.TALK_TO_TARTI, 10000, ExShowScreenMessage.ScreenMessageAlign.TOP_CENTER, false));
		}
	}
	
	private static class ClassChangeListener implements OnClassChangeListener
	{
		@Override
		public void onClassChange(Player player, ClassId oldClass, ClassId newClass)
		{
			final QuestState qs = player.getQuestState(11025);
			if ((qs != null) && qs.isCompleted() && (player.getClassLevel() == ClassLevel.SECOND)//
					&& (player.getVarBoolean(R_GRADE_ITEMS_REWARDED_VAR, false) == false)//
					&& (player.getRace() != Race.ERTHEIA))
			{
				player.setVar(R_GRADE_ITEMS_REWARDED_VAR, true);
				
				qs.giveItems(SS_R, 5000);
				qs.giveItems(BSS_R, 5000);
				
				switch (player.getClassId())
				{
					case WARLORD:
					{
						qs.giveItems(BOX_R_HEAVY, 1);
						qs.giveItems(WEAPON_SPEAR_R, 1);
						break;
					}
					case GLADIATOR:
					case WARCRYER:
					case PROPHET:
					case BLADEDANCER:
					{
						qs.giveItems(BOX_R_HEAVY, 1);
						qs.giveItems(WEAPON_DUALSWORD_R, 1);
						break;
					}
					case PALADIN:
					case DARK_AVENGER:
					case TEMPLE_KNIGHT:
					case SWORDSINGER:
					case SHILLEN_KNIGHT:
					case OVERLORD:
					{
						qs.giveItems(BOX_R_HEAVY, 1);
						qs.giveItems(WEAPON_SWORD_R, 1);
						qs.giveItems(WEAPON_SHIELD_R, 1);
						break;
					}
					case TREASURE_HUNTER:
					case PLAIN_WALKER:
					case ABYSS_WALKER:
					case BOUNTY_HUNTER:
					{
						qs.giveItems(BOX_R_LIGHT, 1);
						qs.giveItems(WEAPON_DUALDAGGER_R, 1);
						break;
					}
					case HAWKEYE:
					case SILVER_RANGER:
					case PHANTOM_RANGER:
					{
						qs.giveItems(BOX_R_LIGHT, 1);
						qs.giveItems(WEAPON_BOW_R, 1);
						qs.giveItems(ORICHALCUM_ARROW_R, 20000);
						break;
					}
					case SORCERER:
					case NECROMANCER:
					case SPELLSINGER:
					case SPELLHOWLER:
					case M_SOUL_BREAKER:
					case F_SOUL_BREAKER:
					{
						qs.giveItems(BOX_R_ROBE, 1);
						qs.giveItems(WEAPON_BUSTER_R, 1);
						qs.giveItems(WEAPON_SIGIL_R, 1);
						break;
					}
					case WARLOCK:
					case ELEMENTAL_SUMMONER:
					case PHANTOM_SUMMONER:
					{
						qs.giveItems(BOX_R_LIGHT, 1);
						qs.giveItems(WEAPON_STAFF_R, 1);
						break;
					}
					case BISHOP:
					case ELDER:
					case SHILLEN_ELDER:
					{
						qs.giveItems(BOX_R_ROBE, 1);
						qs.giveItems(WEAPON_CASTER_R, 1);
						qs.giveItems(WEAPON_SIGIL_R, 1);
						break;
					}
					case WARSMITH:
					{
						qs.giveItems(BOX_R_HEAVY, 1);
						qs.giveItems(WEAPON_BLUNT_R, 1);
						qs.giveItems(WEAPON_SHIELD_R, 1);
						break;
					}
					case DESTROYER:
					case BERSERKER:
					{
						qs.giveItems(BOX_R_HEAVY, 1);
						qs.giveItems(WEAPON_GSWORD_R, 1);
						break;
					}
					case TYRANT:
					{
						qs.giveItems(BOX_R_HEAVY, 1);
						qs.giveItems(WEAPON_FIST_R, 1);
						break;
					}
					case ARBALESTER:
					{
						qs.giveItems(BOX_R_LIGHT, 1);
						qs.giveItems(ORICHALCUM_BOLT_R, 20000);
						qs.giveItems(WEAPON_CROSSBOW_R, 1);
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
	private static final int KALESIN = 33177;
	private static final int ZENATH = 33509;
	private static final int RAYMOND = 30289;
	private static final int TELESHA = 33981;
	private static final int MYSTERIOUS_WIZARD = 33980;
	
	private static final int[] TIER1_KILLS =
	{
		24384, // Carcass Bat
		24385 // Vampire
	};
	private static final int[] TIER2_KILLS =
	{
		24386, // Skeleton Scout
		24387, // Skeleton Archer
		24388 // Skeleton Warrior
	};
	private static final int[] TIER3_KILLS =
	{
		24389, // Spartoi Soldier
		24390 // Raging Spartoi
	};
	private static final int[] TIER4_KILLS =
	{
		27528, // Skeleton Warrior
		27529 // Skeleton Archer
	};
	
	// Items
	private static final int SECRET_MATERIAL = 80671;
	private static final int BREATH_OF_DEATH = 80672;
	private static final int SOE_KALESIN = 80679;
	private static final int SOE_ZENATH = 80680;
	private static final int SOE_TARTI = 80677;
	private static final int WIND_SPIRIT = 80673;
	
	// Class change rewards
	private static final int SS_R = 33780;
	private static final int BSS_R = 33794;
	private static final int BOX_R_HEAVY = 46924;
	private static final int BOX_R_LIGHT = 46925;
	private static final int BOX_R_ROBE = 46926;
	private static final int WEAPON_SWORD_R = 47008;
	private static final int WEAPON_SHIELD_R = 47026;
	private static final int WEAPON_GSWORD_R = 47009;
	private static final int WEAPON_BLUNT_R = 47010;
	private static final int WEAPON_FIST_R = 47011;
	private static final int WEAPON_SPEAR_R = 47012;
	private static final int WEAPON_BOW_R = 47013;
	private static final int WEAPON_DUALDAGGER_R = 47019;
	private static final int WEAPON_STAFF_R = 47017;
	private static final int WEAPON_DUALSWORD_R = 47018;
	private static final int WEAPON_CROSSBOW_R = 47014;
	private static final int WEAPON_BUSTER_R = 47015;
	private static final int WEAPON_CASTER_R = 47016;
	private static final int WEAPON_SIGIL_R = 47037;
	private static final int ORICHALCUM_BOLT_R = 19443;
	private static final int ORICHALCUM_ARROW_R = 18550;
	
	// Location
	private static final Location TRAINING_GROUNDS_TELEPORT = new Location(-44121, 115926, -3624);
	private static final Location TRAINING_GROUNDS_TELEPORT2 = new Location(-46169, 110937, -3808);
	private static final Location TRAINING_GROUNDS_TELEPORT3 = new Location(-51130, 110053, -3664);
	private static final Location TRAINING_GROUNDS_TELEPORT4 = new Location(-4983, 116607, -3344);
	private static final Location RETURN_TO_RAYMOND_TELEPORT = new Location(-12856, 121704, -2970);
	
	// Misc
	private static final String R_GRADE_ITEMS_REWARDED_VAR = "R_GRADE_ITEMS_REWARDED";
	private static final int MIN_LEVEL = 20;
	private static final String A_LIST = "A_LIST";

	public _11025_PathofDestinyProving()
	{
		super(PARTY_NONE, ONETIME);
		addStartNpc(TARTI);
		addTalkId(TARTI, KALESIN, ZENATH, RAYMOND, TELESHA, MYSTERIOUS_WIZARD);
		addFirstTalkId(TELESHA, MYSTERIOUS_WIZARD);
		addKillId(TIER1_KILLS);
		addKillId(TIER3_KILLS);
		addKillId(TIER4_KILLS);
		addQuestItem(SECRET_MATERIAL, BREATH_OF_DEATH, WIND_SPIRIT);
		addKillNpcWithLog(4, NpcString.DEFEAT_SKELETONS.getId(), A_LIST, 30, TIER2_KILLS);
		addLevelCheck("low_level.htm", MIN_LEVEL);
		addRaceCheck("not_ertheia.htm", Race.HUMAN, Race.ELF, Race.DARKELF, Race.ORC, Race.DWARF, Race.KAMAEL);
		addClassLevelCheck("bad_class.htm", false, ClassLevel.FIRST);
		addQuestCompletedCheck("low_level.htm", 11024);
	}
	
	@Override
	public String onEvent(String event, QuestState st, NpcInstance npc)
	{
		Player player = st.getPlayer();
		switch (event)
		{
			case "tarti_q11025_04.htm":
			{
				st.setCond(1);
				player.sendPacket(new ExTutorialShowId(18));
				st.getPlayer().sendPacket(new ExShowScreenMessage(NpcString.PRESS_ALTK_TO_OPEN_THE_LEARN_SKILL_TAB_AND_LEARN_NEW_SKILLSNTHE_SKILLS_IN_THE_ACTIVE_TAB_CAN_BE_ADDED_TO_THE_SHORTCUTS, 5000, ExShowScreenMessage.ScreenMessageAlign.TOP_CENTER, false));
				giveStoryBuff(npc, player);
				break;
			}
			case "teleport":
			{
				player.teleToLocation(TRAINING_GROUNDS_TELEPORT);
				return null;
			}
			case "kalesin_q11025_02.htm":
			{
				st.takeItems(SECRET_MATERIAL, 15);
				st.addExpAndSp(913551, 822);
				st.setCond(3);
				break;
			}
			case "kalesin_q11025_06.htm":
			{
				st.setCond(4);
				player.sendPacket(new ExTutorialShowId(19));
				giveStoryBuff(npc, player);
				break;
			}
			case "teleport2":
			{
				player.teleToLocation(TRAINING_GROUNDS_TELEPORT2);
				return null;
			}
			case "zenath_q11025_02.htm":
			{
				st.addExpAndSp(1_640_083, 1476);
				st.setCond(6);
				break;
			}
			case "zenath_q11025_06.htm":
			{
				st.setCond(7);
				player.sendPacket(new ExTutorialShowId(17));
				giveStoryBuff(npc, player);
				break;
			}
			case "teleport3":
			{
				player.teleToLocation(TRAINING_GROUNDS_TELEPORT3);
				return null;
			}
			case "tarti_q11025_07.htm":
			{
				st.takeItems(BREATH_OF_DEATH, 15);
				st.addExpAndSp(4_952_686, 4457);
				st.giveItems(ADENA_ID, 165_000);
				st.getPlayer().sendPacket(new ExShowScreenMessage(NpcString.SECOND_CLASS_TRANSFER_IS_AVAILABLENGO_SEE_TARTI_IN_THE_TOWN_OF_GLUDIO_TO_START_THE_CLASS_TRANSFER, 5000, ExShowScreenMessage.ScreenMessageAlign.TOP_CENTER, false));
				st.setCond(9);
				break;
			}
			case "tarti_q11025_09.htm":
			{
				if (player.getLevel() >= 40)
				{
					st.setCond(11);
					return "tarti_q11025_10.htm";
				}
				break;
			}
			case "raymond_q11025_03.htm":
			{
				st.setCond(12);
				st.giveItems(WIND_SPIRIT, 1);
				giveStoryBuff(npc, player);
				break;
			}
			case "teleport4":
			{
				player.teleToLocation(TRAINING_GROUNDS_TELEPORT4);
				return null;
			}
			case "wizard_spawn":
			{
				NpcInstance wizard = st.addSpawn(MYSTERIOUS_WIZARD, npc.getX(), npc.getY(), npc.getZ(), 0, 50, 360000);
				wizard.setTitle(st.getPlayer().getName());
				npc.deleteMe();
				st.getPlayer().sendPacket(new ExShowScreenMessage(NpcString.TALK_TO_THE_MYSTERIOUS_WIZARD, 5000, ExShowScreenMessage.ScreenMessageAlign.TOP_CENTER, false));
				st.setCond(13);
				return null;
			}
			case "raymond":
			{
				st.setCond(14);
				player.teleToLocation(RETURN_TO_RAYMOND_TELEPORT);
				st.giveItems(WIND_SPIRIT, 1);
				return null;
			}
			case "raymond_q11025_06.htm":
			{
				st.setCond(15);
				break;
			}
			case "tarti_q11025_17.htm":
			{
				st.giveItems(ADENA_ID, 5000);
				st.getPlayer().sendPacket(new ExShowScreenMessage(NpcString.CLASS_TRANSFER_IS_AVAILABLENCLICK_THE_CLASS_TRANSFER_ICON_IN_THE_NOTIFICATION_WINDOW_TO_TRANSFER_YOUR_CLASS, 5000, ExShowScreenMessage.ScreenMessageAlign.TOP_CENTER, false));
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
		
		switch (npcId)
		{
			case TARTI:
			{
				switch (cond)
				{
					case 0:
						return "tarti_q11025_01.htm";
					case 1:
						return "tarti_q11025_04.htm";
					case 8:
						return "tarti_q11025_06.htm";
					case 9:
						return "tarti_q11025_08.htm";
					case 10:
						return "tarti_q11025_10.htm";
					case 15:
						return "tarti_q11025_11.htm";
				}
				break;
			}
			case KALESIN:
			{
				switch (cond)
				{
					case 2:
						return "kalesin_q11025_01.htm";
					case 3:
						return "kalesin_q11025_03.htm";
					case 4:
						return "kalesin_q11025_06.htm";
				}
				break;
			}
			case ZENATH:
			{
				switch (cond)
				{
					case 5:
						return "zenath_q11025_01.htm";
					case 6:
						return "zenath_q11025_03.htm";
					case 7:
						return "zenath_q11025_06.htm";
				}
				break;
			}
			case RAYMOND:
			{
				switch (cond)
				{
					case 11:
						return "raymond_q11025_01.htm";
					case 12:
						return "raymond_q11025_03.htm";
					case 14:
						return "raymond_q11025_04.htm";
					case 15:
						return "raymond_q11025_06.htm";
				}
				break;
			}
		}
		return NO_QUEST_DIALOG;
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
			if (st.getCond() == 12)
				return "telesha_q11025_01.htm";
		}
		else if (npcId == MYSTERIOUS_WIZARD)
		{
			if (st.getCond() == 13)
			{
				st.getPlayer().sendPacket(new ExShowScreenMessage(NpcString.RETURN_TO_RAYMOND_OF_THE_TOWN_OF_GLUDIO, 5000, ExShowScreenMessage.ScreenMessageAlign.TOP_CENTER, false));
				return "mysterious_wizard_q11025_01.htm";
			}
			else if (st.getCond() == 14)
				return "mysterious_wizard_q11025_03.htm";
		}
		return null;
	}
	
	@Override
	public String onKill(NpcInstance npc, QuestState qs)
	{
		if ((qs.getCond() == 1) && (Rnd.get(100) > 10) && ArrayUtils.contains(TIER1_KILLS, npc.getNpcId()))
		{
			qs.giveItems(SECRET_MATERIAL, 1);
			if (qs.getQuestItemsCount(SECRET_MATERIAL) >= 15)
			{
				qs.setCond(2);
				qs.giveItems(SOE_KALESIN, 1);
				qs.getPlayer().sendPacket(new ExShowScreenMessage(NpcString.USE_SCROLL_OF_ESCAPE_KALLESIN_IN_YOUR_INVENTORYNTALK_TO_KALLESIN_TO_COMPLETE_THE_QUEST, 5000, ExShowScreenMessage.ScreenMessageAlign.TOP_CENTER, false));
			}
			else
				qs.playSound(SOUND_ITEMGET);
		}
		else if ((qs.getCond() == 4) && updateKill(npc, qs))
		{
			qs.unset(A_LIST);
			qs.setCond(5);
			qs.giveItems(SOE_ZENATH, 1);
			qs.getPlayer().sendPacket(new ExShowScreenMessage(NpcString.USE_SCROLL_OF_ESCAPE_ZENATH_IN_YOUR_INVENTORYNTALK_TO_ZENATH_TO_COMPLETE_THE_QUEST, 5000, ExShowScreenMessage.ScreenMessageAlign.TOP_CENTER, false));
		}
		else if ((qs.getCond() == 7) && (Rnd.get(100) > 10) && ArrayUtils.contains(TIER3_KILLS, npc.getNpcId()))
		{
			qs.giveItems(BREATH_OF_DEATH, 1);
			if (qs.getQuestItemsCount(BREATH_OF_DEATH) >= 15)
			{
				qs.setCond(8);
				qs.giveItems(SOE_TARTI, 1);
				qs.getPlayer().sendPacket(new ExShowScreenMessage(NpcString.USE_SCROLL_OF_ESCAPE_TARTI_IN_YOUR_INVENTORYNTALK_TO_TARTI_TO_COMPLETE_THE_QUEST, 5000, ExShowScreenMessage.ScreenMessageAlign.TOP_CENTER, false));
			}
			else
				qs.playSound(SOUND_ITEMGET);
		}
		else if (((qs.getCond() == 11) || (qs.getCond() == 12)) && ArrayUtils.contains(TIER4_KILLS, npc.getNpcId()))
		{
			NpcInstance telesha = qs.addSpawn(TELESHA, npc.getX(), npc.getY(), npc.getZ(), 0, 50, 360000);
			telesha.setTitle(qs.getPlayer().getName());
			qs.getPlayer().sendPacket(new ExShowScreenMessage(NpcString.CHECK_ON_TELESHA, 5000, ExShowScreenMessage.ScreenMessageAlign.TOP_CENTER, false));
			qs.setCond(12);
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
