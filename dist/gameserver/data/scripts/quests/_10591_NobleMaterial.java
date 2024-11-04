package quests;

import org.apache.commons.lang3.ArrayUtils;

import l2s.gameserver.geometry.Location;
import l2s.gameserver.listener.actor.player.OnLevelChangeListener;
import l2s.gameserver.model.Player;
import l2s.gameserver.model.actor.listener.CharListenerList;
import l2s.gameserver.model.base.ClassType2;
import l2s.gameserver.model.base.NobleType;
import l2s.gameserver.model.instances.NpcInstance;
import l2s.gameserver.model.quest.Quest;
import l2s.gameserver.model.quest.QuestState;
import l2s.gameserver.network.l2.components.NpcString;
import l2s.gameserver.network.l2.s2c.ExShowScreenMessage;
import l2s.gameserver.skills.SkillEntry;
import l2s.gameserver.skills.SkillEntryType;

/**
 * @author nexvill
 */
public class _10591_NobleMaterial extends Quest
{
	private static class ChangeLevelListener implements OnLevelChangeListener
	{
		@Override
		public void onLevelChange(Player player, int was, int set)
		{
			QuestState qs = player.getQuestState(10591);
			if(qs == null)
				return;

			if ((qs.getCond() == 2) && (qs.getQuestItemsCount(FLAME_ENERGY) >= 1000) && (player.getLevel() >= 100))
				qs.setCond(3);
		}
	}
	
	private static final OnLevelChangeListener LEVEL_CHANGE_LISTENER = new ChangeLevelListener();
	
	// NPCs
	private static final int JOACHIM = 34513;
	private static final int HARP_ZU_HESTUI = 34014;
	private static final int EVAN_GRAHAM = 34523;
	private static final int HERPHAH = 34362;
	private static final int LIONEL_HUNTER = 33907;
	private static final int EVAS_AVATAR = 33686;
	private static final int[] MONSTERS =
	{
		23487, // Magma Ailith
		23489, // Lava Wyrm
		23490, // Lava Drake
		23491, // Lava Wendigo
		23492, // Lavastone Golem
		23493, // Lava Leviah
		23494, // Magma Salamander
		23495, // Magma Dre Vanul
		23499, // Flame Preta
		23500, // Flame Crow
		23501, // Flame Rael
		23502, // Flame Salamander
		23503, // Flame Drake
		23504, // Flame Votis
		24585, // Vanor Silenos Mercenary
		24586 // Vanor Silenos Guardian
	};
	// Item
	private static final int FLAME_ENERGY = 80856;
	// Skills
	private static final int NOBLESSE_PRESENTATION = 18176;
	// Rewards
	private static final long EXP = 1;
	private static final int SP = 1;
	private static final int ADENA_AMOUNT = 5050;
	private static final int ACHIEVEMENT_BOX_LV_100 = 80910;
	private static final int WARRIOR_CICLET_BOX_LV5 = 80911;
	private static final int WIZARD_CICLET_BOX_LV5 = 80912;
	private static final int KNIGHT_CICLET_BOX_LV5 = 80913;
	// Misc
	private static final int MIN_LEVEL = 99;
	public final static int INSTANCE_ZONE_ID = 217;
	// Location
	private static final Location BLAZING_SWAMP = new Location(152754, -15142, -4400);
	private static final Location WAR_TORN_PLAINS = new Location(159386, 21093, -3680);
	private static final Location HEINE = new Location(111257, 221071, -3550);
	
	public _10591_NobleMaterial()
	{
		super(PARTY_ONE, ONETIME);
		addStartNpc(JOACHIM);
		addTalkId(JOACHIM, HARP_ZU_HESTUI, EVAN_GRAHAM, HERPHAH, LIONEL_HUNTER, EVAS_AVATAR);
		addKillId(MONSTERS);
		addLevelCheck("low_level.htm", MIN_LEVEL);
		addQuestCompletedCheck("low_level.htm", 10590);
	}
	
	@Override
	public String onEvent(String event, QuestState st, NpcInstance npc)
	{
		Player player = st.getPlayer();
		
		switch (event)
		{
			case "joachim_q10591_03.htm":
			{
				st.setCond(1);
				break;
			}
			case "teleport":
			{
				if (player.getClassId().isOfType2(ClassType2.WIZARD)//
						|| player.getClassId().isOfType2(ClassType2.ARCHER)//
						|| player.getClassId().isOfType2(ClassType2.SUMMONER))
					player.teleToLocation(BLAZING_SWAMP);
				else
					player.teleToLocation(WAR_TORN_PLAINS);
				return null;
			}
			case "harp_zu_hestui_q10591_02.htm":
			{
				st.setCond(2);
				break;
			}
			case "evan_graham_q10591_02.htm":
			{
				st.setCond(2);
				break;
			}
			case "joachim_q10591_07.htm":
			{
				st.setCond(4, true);
				break;
			}
			case "herphah_q10591_02.htm":
			{
				st.setCond(5);
				break;
			}
			case "teleport_s":
			{
				player.teleToLocation(HEINE);
				return null;
			}
			case "lionel_hunter_q10591_02.htm":
			{
				st.setCond(6);
				break;
			}
			case "enterInstance":
			{
				enterInstance(st, INSTANCE_ZONE_ID);
				return null;
			}
			case "evas_avatar_q10591_02.htm":
			{
				st.setCond(7);
				break;
			}
			case "lionel_hunter_q10591_05.htm":
			{
				st.addExpAndSp(EXP, SP);
				st.takeAllItems(FLAME_ENERGY);
				st.giveItems(ADENA_ID, ADENA_AMOUNT);
				st.giveItems(ACHIEVEMENT_BOX_LV_100, 1);
				if (player.getNobleType() == NobleType.NONE)
				{
					player.setNobleType(NobleType.NORMAL);
				}
				player.broadcastUserInfo(true);
				st.giveItems(WARRIOR_CICLET_BOX_LV5, 1);
				player.doCast(SkillEntry.makeSkillEntry(SkillEntryType.NONE, NOBLESSE_PRESENTATION, 1), player, true);
				player.sendPacket(new ExShowScreenMessage(NpcString.CONGRATULATIONS_YOU_ARE_NOW_A_NOBLESSE, 10000, ExShowScreenMessage.ScreenMessageAlign.TOP_CENTER, false));
				st.finishQuest();
				break;
			}
			case "lionel_hunter_q10591_06.htm":
			{
				st.addExpAndSp(EXP, SP);
				st.takeAllItems(FLAME_ENERGY);
				st.giveItems(ADENA_ID, ADENA_AMOUNT);
				st.giveItems(ACHIEVEMENT_BOX_LV_100, 1);
				if (player.getNobleType() == NobleType.NONE)
				{
					player.setNobleType(NobleType.NORMAL);
				}
				player.broadcastUserInfo(true);
				st.giveItems(WIZARD_CICLET_BOX_LV5, 1);
				player.doCast(SkillEntry.makeSkillEntry(SkillEntryType.NONE, NOBLESSE_PRESENTATION, 1), player, true);
				player.sendPacket(new ExShowScreenMessage(NpcString.CONGRATULATIONS_YOU_ARE_NOW_A_NOBLESSE, 10000, ExShowScreenMessage.ScreenMessageAlign.TOP_CENTER, false));
				st.finishQuest();
				break;
			}
			case "lionel_hunter_q10591_07.htm":
			{
				st.addExpAndSp(EXP, SP);
				st.giveItems(ADENA_ID, ADENA_AMOUNT);
				st.giveItems(ACHIEVEMENT_BOX_LV_100, 1);
				if (player.getNobleType() == NobleType.NONE)
				{
					player.setNobleType(NobleType.NORMAL);
				}
				player.broadcastUserInfo(true);
				st.giveItems(KNIGHT_CICLET_BOX_LV5, 1);
				player.doCast(SkillEntry.makeSkillEntry(SkillEntryType.NONE, NOBLESSE_PRESENTATION, 1), player, true);
				player.sendPacket(new ExShowScreenMessage(NpcString.CONGRATULATIONS_YOU_ARE_NOW_A_NOBLESSE, 10000, ExShowScreenMessage.ScreenMessageAlign.TOP_CENTER, false));
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
						return "joachim_q10591_01.htm";
					case 1:
						return "joachim_q10591_04.htm";
					case 2:
						return "joachim_q10591_05.htm";
					case 3:
						return "joachim_q10591_06.htm";
					case 4:
						return "joachim_q10591_08.htm";
				}
				break;
			}
			case HARP_ZU_HESTUI:
			{
				switch (cond)
				{
					case 1:
						return "harp_zu_hestui_q10591_01.htm";
					case 2:
						return "harp_zu_hestui_q10591_03.htm";
				}
				break;
			}
			case EVAN_GRAHAM:
			{
				switch (cond)
				{
					case 1:
						return "evan_graham_q10591_01.htm";
					case 2:
						return "evan_graham_q10591_03.htm";
				}
				break;
			}
			case HERPHAH:
			{
				switch (cond)
				{
					case 4:
						return "herphah_q10591_01.htm";
					case 5:
						return "herphah_q10591_03.htm";
				}
				break;
			}
			case LIONEL_HUNTER:
			{
				switch (cond)
				{
					case 5:
						return "lionel_hunter_q10591_01.htm";
					case 6:
						return "lionel_hunter_q10591_03.htm";
					case 7:
						return "lionel_hunter_q10591_04.htm";
				}
				break;
			}
			case EVAS_AVATAR:
			{
				if (cond == 6)
					return "evas_avatar_q10591_01.htm";
				else if (cond == 7)
					return "evas_avatar_q10591_02.htm";
				break;
			}
		}
		return NO_QUEST_DIALOG;
	}
	
	@Override
	public String onKill(NpcInstance npc, QuestState qs)
	{
		if ((qs.getCond() == 2) && (qs.getQuestItemsCount(FLAME_ENERGY) < 1000) && ArrayUtils.contains(MONSTERS, npc.getNpcId()))
		{
			qs.giveItems(FLAME_ENERGY, 1);
			if ((qs.getQuestItemsCount(FLAME_ENERGY) >= 1000) && qs.getPlayer().getLevel() >= 100)
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
