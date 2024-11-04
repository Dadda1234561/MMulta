/*
package quests;

import org.apache.commons.lang3.ArrayUtils;

import l2s.commons.util.Rnd;
import l2s.gameserver.geometry.Location;
import l2s.gameserver.listener.actor.player.OnPlayerEnterListener;
import l2s.gameserver.model.GameObjectsStorage;
import l2s.gameserver.model.Player;
import l2s.gameserver.model.actor.listener.CharListenerList;
import l2s.gameserver.model.base.ClassLevel;
import l2s.gameserver.model.base.Race;
import l2s.gameserver.model.entity.Reflection;
import l2s.gameserver.model.instances.NpcInstance;
import l2s.gameserver.model.quest.Quest;
import l2s.gameserver.model.quest.QuestState;
import l2s.gameserver.network.l2.components.NpcString;
import l2s.gameserver.network.l2.components.SceneMovie;
import l2s.gameserver.network.l2.s2c.ExShowScreenMessage;
import l2s.gameserver.network.l2.s2c.ExShowScreenMessage.ScreenMessageAlign;
import l2s.gameserver.utils.NpcUtils;

import instances.FortressOfTheDeadQuest;

*/
/**
 * @author nexvill
 *//*

public class _11029_WindofDestinyPromise extends Quest
{
	private static class PlayerEnterListener implements OnPlayerEnterListener
	{
		@Override
		public void onPlayerEnter(Player player)
		{
			QuestState questState = player.getQuestState(11029);
			if((questState == null) && (player.getLevel() >= MIN_LEVEL)//
					&& (player.getClassLevel() == ClassLevel.FIRST)//
					&& (player.getRace() == Race.ERTHEIA))
				player.sendPacket(new ExShowScreenMessage(NpcString.TALK_TO_TARTI, 10000, ExShowScreenMessage.ScreenMessageAlign.TOP_CENTER, false));
		}
	}
	
	private static final OnPlayerEnterListener PLAYER_ENTER_LISTENER = new PlayerEnterListener();
	// NPCs
	private static final int TARTI = 34505;
	private static final int PIO = 33963;
	private static final int RAYMOND = 30289;
	private static final int KAIN_VAN_HALTER = 33979;
	private static final int MYSTERIOUS_WIZARD = 33980;
	
	private static final int[] TIER1_KILLS =
	{
		24391, // Sobbing Windra
		24392, // Whispering Windra
		24393 // Giggling Windra
	};
	private static final int[] TIER2_KILLS =
	{
		24394, // Fear Ratel
		24395 // Fear Ratel Robust
	};
	private static final int[] TIER3_KILLS =
	{
		24396, // Fear Growler
		24397, // Fear Growler Evolved
		24398 // Fear Growler Robust
	};
	private static final int[] TIER4_KILLS =
	{
		24399, // Fussy Leaf
		24400 // Fussy Arbor
	};
	private static final int[] TIER5_KILLS =
	{
		24401, // Tiny Windima
		24402 // Giant Windima
	};
	// Items
	private static final int SOE_PHO = 80681;
	private static final int SOE_TARTI = 80677;
	private static final int CORRUPTED_ENERGY = 80673;
	private static final int EMBEDDED_SHARD = 80674;
	private static final int KAIN_PROPHECY_MACHINE_FRAGMENT = 39538;
	// Location
	private static final Location TRAINING_GROUNDS_TELEPORT1 = new Location(-74631, 94630, -3736);
	private static final Location TRAINING_GROUNDS_TELEPORT2 = new Location(-80777, 91995, -3720);
	private static final Location TRAINING_GROUNDS_TELEPORT3 = new Location(-84963, 80967, -3144);
	private static final Location TRAINING_GROUNDS_TELEPORT4 = new Location(-87808, 87292, -3424);
	private static final Location TRAINING_GROUNDS_TELEPORT5 = new Location(-91374, 92270, -3360);
	// Misc
	private static final String A_LIST = "A_LIST";
	private static final int MIN_LEVEL = 40;
	private static final int WIZARD_DESPAWN_DELAY = 30000;
	private static final int INSTANCE_ZONE_ID = 254;
	private static final String WIZARD_OBJECT_ID_VAR = "wizard_object_id";
	private static final String WIZARD_MSG_TIMER_ID_VAR = "wizard_msg_timer_id";
	private static final String END_INSTANCE_TIMER_ID_VAR = "end_instance_timer_id";
	
	public _11029_WindofDestinyPromise()
	{
		super(PARTY_NONE, ONETIME);
		addStartNpc(TARTI);
		addTalkId(TARTI, PIO, RAYMOND, KAIN_VAN_HALTER, MYSTERIOUS_WIZARD);
		addFirstTalkId(MYSTERIOUS_WIZARD);
		addKillId(TIER3_KILLS);
		addKillId(TIER4_KILLS);
		addQuestItem(CORRUPTED_ENERGY, EMBEDDED_SHARD, KAIN_PROPHECY_MACHINE_FRAGMENT);
		addKillNpcWithLog(1, NpcString.DEFEAT_THE_PACK_OF_WINDRA.getId(), A_LIST, 30, TIER1_KILLS);
		addKillNpcWithLog(4, NpcString.ERADICATE_THE_FEAR_RATEL.getId(), A_LIST, 30, TIER2_KILLS);
		addKillNpcWithLog(13, NpcString.DEFEAT_THE_PACK_OF_WINDIMA.getId(), A_LIST, 30, TIER5_KILLS);
		addLevelCheck("low_level.htm", MIN_LEVEL);
		addRaceCheck("only_ertheia.htm", Race.ERTHEIA);
		addClassLevelCheck("bad_class.htm", true, ClassLevel.FIRST);
		addQuestCompletedCheck("low_level.htm", 11028);
	}
	
	@Override
	public String onEvent(String event, QuestState st, NpcInstance npc)
	{
		Player player = st.getPlayer();
		switch (event)
		{
			case "tarti_q11029_03.htm":
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
			case "pio_q11029_03.htm":
			{
				st.setCond(3);
				st.addExpAndSp(14_281_098, 12_852);
				break;
			}
			case "pio_q11029_05.htm":
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
			case "pio_q11029_08.htm":
			{
				st.addExpAndSp(30_949_789, 27_854);
				st.setCond(6);
				break;
			}
			case "pio_q11029_10.htm":
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
			case "pio_q11029_13.htm":
			{
				st.takeAllItems(CORRUPTED_ENERGY);
				st.addExpAndSp(76_142_825, 68_528);
				st.setCond(9);
				break;
			}
			case "pio_q11029_15.htm":
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
			case "pio_q11029_17.htm":
			{
				st.takeAllItems(EMBEDDED_SHARD);
				st.addExpAndSp(174_520_303, 157_068);
				st.setCond(12);
				break;
			}
			case "pio_q11029_20.htm":
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
			case "tarti_q11029_06.htm":
			{
				st.addExpAndSp(834_929_477, 595_042);
				st.giveItems(ADENA_ID, 240_000);
				st.setCond(15);
				player.sendPacket(new ExShowScreenMessage(NpcString.SECOND_LIBERATION_IS_AVAILABLENGO_SEE_TARTI_IN_THE_TOWN_OF_GLUDIO_TO_START_THE_CLASS_TRANSFER, 5000, ExShowScreenMessage.ScreenMessageAlign.TOP_CENTER, false));
				break;
			}
			case "tarti_q11029_07.htm":
			{
				st.setCond(16);
				break;
			}
			case "tarti_q11029_08.htm":
			{
				if (player.getLevel() >= 76)
				{
					return "tarti_q11029_09.htm";
				}
				break;
			}
			case "tarti_q11029_10.htm":
			{
				st.setCond(17);
				break;
			}
			case "raymond_q11029_02.htm":
			{
				st.setCond(18);
				break;
			}
			case "enterInstance":
			{
				enterInstance(st, new FortressOfTheDeadQuest(), INSTANCE_ZONE_ID);
				return null;
			}
			case "kain_van_halter_q11029_11.htm":
			{
				if(GameObjectsStorage.getNpc(st.getInt(WIZARD_OBJECT_ID_VAR)) != null)
					return null;

				NpcInstance wizard = NpcUtils.spawnSingle(MYSTERIOUS_WIZARD, Location.findPointToStay(npc, 150), npc.getReflection(), WIZARD_DESPAWN_DELAY, st.getPlayer().getName());

				st.set(WIZARD_OBJECT_ID_VAR, wizard.getObjectId(), false);

				st.getPlayer().sendPacket(new ExShowScreenMessage(NpcString.TALK_TO_THE_MYSTERIOUS_WIZARD, 10000, ScreenMessageAlign.TOP_CENTER));
				st.startQuestTimer(WIZARD_MSG_TIMER_ID_VAR, 12000);
				break;
			}
			case WIZARD_MSG_TIMER_ID_VAR:
			{
				if(GameObjectsStorage.getNpc(st.getInt(WIZARD_OBJECT_ID_VAR)) != null)
				{
					st.getPlayer().sendPacket(new ExShowScreenMessage(NpcString.TALK_TO_THE_MYSTERIOUS_WIZARD, 5000, ScreenMessageAlign.TOP_CENTER));
					st.startQuestTimer(WIZARD_MSG_TIMER_ID_VAR, 7000);
				}
				return null;
			}
			case "endInstance":
			{
				Reflection reflection = npc.getReflection();
				if(reflection.getInstancedZoneId() == INSTANCE_ZONE_ID)
					reflection.despawnAll();

				SceneMovie scene = SceneMovie.ERTHEIA_QUEST_B;
				st.getPlayer().startScenePlayer(scene);

				st.startQuestTimer(END_INSTANCE_TIMER_ID_VAR, scene.getDuration());
				return null;
			}
			case END_INSTANCE_TIMER_ID_VAR:
			{
				if(st.getCond() == 18)
				{
					st.giveItems(KAIN_PROPHECY_MACHINE_FRAGMENT, 1);
					st.setCond(19);
				}

				Reflection reflection = st.getPlayer().getActiveReflection();
				if(reflection!= null && reflection.getInstancedZoneId() == INSTANCE_ZONE_ID)
					reflection.collapse();
				return null;
			}
			case "tarti_q11029_15.htm":
			{
				st.addExpAndSp(14_281_098, 12_852);
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
						return "tarti_q11029_01.htm";
					case 1:
						return "tarti_q11029_03.htm";
					case 14:
						return "tarti_q11029_05.htm";
					case 15:
						return "tarti_q11029_06.htm";
					case 16:
					{
						if (st.getPlayer().getLevel() >= 76)
							return "tarti_q11029_09.htm";
						else
							return "tarti_q11029_08.htm";
					}
					case 17:
						return "tarti_q11029_10.htm";
					case 19:
						return "tarti_q11029_11.htm";
				}
				break;
			}
			case PIO:
			{
				switch (cond)
				{
					case 2:
						return "pio_q11029_01.htm";
					case 3:
						return "pio_q11029_04.htm";
					case 4:
						return "pio_q11029_06.htm";
					case 5:
						return "pio_q11029_07.htm";
					case 6:
						return "pio_q11029_09.htm";
					case 7:
						return "pio_q11029_11.htm";
					case 8:
						return "pio_q11029_12.htm";
					case 9:
						return "pio_q11029_14.htm";
					case 10:
						return "pio_q11029_15.htm";
					case 11:
						return "pio_q11029_16.htm";
					case 12:
						return "pio_q11029_18.htm";
					case 13:
						return "pio_q11029_20.htm";
				}
				break;
			}
			case RAYMOND:
			{
				switch (cond)
				{
					case 17:
						return "raymond_q11029_01.htm";
					case 18:
						return "raymond_q11029_03.htm";
					case 19:
						return "raymond_q11029_04.htm";
				}
				break;
			}
			case KAIN_VAN_HALTER:
			{
				if(st.getCond() == 18)
					return "kain_van_halter_q11029_01.htm";
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
		if(npcId == MYSTERIOUS_WIZARD)
		{
			if(st.getInt(WIZARD_OBJECT_ID_VAR) != npc.getObjectId())
				return null;

			if(st.getCond() == 18)
				return "mysterious_wizard_q11029_01.htm";
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
			qs.giveItems(SOE_PHO, 1);
			qs.getPlayer().sendPacket(new ExShowScreenMessage(NpcString.USE_SCROLL_OF_ESCAPE_PIO_IN_YOUR_INVENTORYNTALK_TO_PIO_TO_COMPLETE_THE_QUEST, 5000, ExShowScreenMessage.ScreenMessageAlign.TOP_CENTER, false));
		}
		else if ((qs.getCond() == 4) && updateKill(npc, qs))
		{
			qs.unset(A_LIST);
			qs.setCond(5);
			qs.giveItems(SOE_PHO, 1);
			qs.getPlayer().sendPacket(new ExShowScreenMessage(NpcString.USE_SCROLL_OF_ESCAPE_PIO_IN_YOUR_INVENTORYNTALK_TO_PIO_TO_COMPLETE_THE_QUEST, 5000, ExShowScreenMessage.ScreenMessageAlign.TOP_CENTER, false));
		}
		else if ((qs.getCond() == 7) && (Rnd.get(100) > 10) && ArrayUtils.contains(TIER3_KILLS, npc.getNpcId()))
		{
			qs.giveItems(CORRUPTED_ENERGY, 1);
			if (qs.getQuestItemsCount(CORRUPTED_ENERGY) >= 15)
			{
				qs.setCond(8);
				qs.giveItems(SOE_PHO, 1);
				qs.getPlayer().sendPacket(new ExShowScreenMessage(NpcString.USE_SCROLL_OF_ESCAPE_PIO_IN_YOUR_INVENTORYNTALK_TO_PIO_TO_COMPLETE_THE_QUEST, 5000, ExShowScreenMessage.ScreenMessageAlign.TOP_CENTER, false));
			}
			else
				qs.playSound(SOUND_ITEMGET);
		}
		else if ((qs.getCond() == 10) && (Rnd.get(100) > 10) && ArrayUtils.contains(TIER4_KILLS, npc.getNpcId()))
		{
			qs.giveItems(EMBEDDED_SHARD, 1);
			if (qs.getQuestItemsCount(EMBEDDED_SHARD) >= 15)
			{
				qs.setCond(11);
				qs.giveItems(SOE_PHO, 1);
				qs.getPlayer().sendPacket(new ExShowScreenMessage(NpcString.USE_SCROLL_OF_ESCAPE_PIO_IN_YOUR_INVENTORYNTALK_TO_PIO_TO_COMPLETE_THE_QUEST, 5000, ExShowScreenMessage.ScreenMessageAlign.TOP_CENTER, false));
			}
			else
				qs.playSound(SOUND_ITEMGET);
		}
		else if ((qs.getCond() == 13) && updateKill(npc, qs))
		{
			qs.unset(A_LIST);
			qs.setCond(14);
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
*/
