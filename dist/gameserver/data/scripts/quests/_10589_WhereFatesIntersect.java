/*
package quests;

import org.apache.commons.lang3.ArrayUtils;

import l2s.gameserver.geometry.Location;
import l2s.gameserver.listener.actor.player.OnLevelChangeListener;
import l2s.gameserver.model.Player;
import l2s.gameserver.model.actor.listener.CharListenerList;
import l2s.gameserver.model.instances.NpcInstance;
import l2s.gameserver.model.quest.Quest;
import l2s.gameserver.model.quest.QuestState;
import l2s.gameserver.network.l2.s2c.ExTutorialShowId;

*/
/**
 * @author nexvill
 *//*

public class _10589_WhereFatesIntersect extends Quest
{
	private static class ChangeLevelListener implements OnLevelChangeListener
	{
		@Override
		public void onLevelChange(Player player, int was, int set)
		{
			QuestState qs = player.getQuestState(10589);
			if(qs == null)
				return;

			if ((qs.getCond() == 3) && (qs.getQuestItemsCount(UNDEAD_BLOOD) >= 200) && (player.getLevel() >= 95))
				qs.setCond(4);
		}
	}
	
	private static final OnLevelChangeListener LEVEL_CHANGE_LISTENER = new ChangeLevelListener();
	
	// NPCs
	private static final int TARTI = 34505;
	private static final int HERPHAH = 34362;
	private static final int VOLLODOS = 30137;
	private static final int JOACHIM = 34513;
	private static final int[] MONSTERS =
	{
		24452, // Doom Soldier
		24453, // Doom Servant
		24454, // Doom Berserker
		24455, // Doom Seer
	};
	// Item
	private static final int UNDEAD_BLOOD = 80853;
	private static final int REWARD_BOX_95 = 80908;
	private static final int RECIPE_R_GRADE_SOULSHOT = 81301;
	private static final int RECIPE_R_GRADE_BLESSED_SPIRITSHOT = 81303;
	// Location
	private static final Location TOWN_OF_ADEN = new Location(146568, 26808, -2208);
	private static final Location ALTAR_OF_EVIL = new Location(-14088, 22168, -3626);
	
	public _10589_WhereFatesIntersect()
	{
		super(PARTY_ONE, ONETIME);
		addStartNpc(TARTI);
		addTalkId(TARTI, HERPHAH, VOLLODOS, JOACHIM);
		addKillId(MONSTERS);
		addLevelCheck("low_level.htm", 85);
	}
	
	@Override
	public String onEvent(String event, QuestState st, NpcInstance npc)
	{
		Player player = st.getPlayer();
		
		switch (event)
		{
			case "tarti_q10589_04.htm":
			{
				player.sendPacket(new ExTutorialShowId(12));
				st.setCond(1);
				break;
			}
			case "herphah_q10589_03.htm":
			{
				player.sendPacket(new ExTutorialShowId(25));
				st.setCond(2);
				break;
			}
			case "herphah_q10589_07.htm":
			{
				st.setCond(5);
				break;
			}
			case "vollodos_q10589_03.htm":
			{
				st.setCond(3);
				break;
			}
			case "joachim_q10589_03.htm":
			{
				st.takeAllItems(UNDEAD_BLOOD);
				st.giveItems(REWARD_BOX_95, 1);
				st.giveItems(RECIPE_R_GRADE_SOULSHOT, 1);
				st.giveItems(RECIPE_R_GRADE_BLESSED_SPIRITSHOT, 1);
				player.setVitality(140000);
				st.finishQuest();
				break;
			}
			case "townofaden":
			{
				player.teleToLocation(TOWN_OF_ADEN);
				return null;
			}
			case "altarofevil":
			{
				player.teleToLocation(ALTAR_OF_EVIL);
				return null;
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
				if (cond == 0)
					return "tarti_q10589_01.htm";
				else if (cond == 1)
					return "tarti_q10589_05.htm";
				break;
			}
			case HERPHAH:
			{
				switch (cond)
				{
					case 1:
						return "herphah_q10589_01.htm";
					case 2:
						return "herphah_q10589_04.htm";
					case 4:
						return "herphah_q10589_05.htm";
					case 5:
						return "herphah_q01589_07.htm";
				}
				break;
			}
			case VOLLODOS:
			{
				if (cond == 2)
					return "vollodos_q10589_01.htm";
				else if (cond == 3)
					return "vollodos_q10589_04.htm";
				break;
			}
			case JOACHIM:
			{
				if (cond == 5)
					return "joachim_q10589_01.htm";
				break;
			}	
		}
		return NO_QUEST_DIALOG;
	}
	
	@Override
	public String onKill(NpcInstance npc, QuestState qs)
	{
		if ((qs.getCond() == 3) && (qs.getQuestItemsCount(UNDEAD_BLOOD) < 200) && ArrayUtils.contains(MONSTERS, npc.getNpcId()))
		{
			qs.giveItems(UNDEAD_BLOOD, 1);
			if ((qs.getQuestItemsCount(UNDEAD_BLOOD) >= 200) && qs.getPlayer().getLevel() >= 95)
			{
				qs.setCond(4);	
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
*/
