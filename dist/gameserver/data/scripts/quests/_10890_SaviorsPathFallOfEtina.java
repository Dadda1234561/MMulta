package quests;

import org.apache.commons.lang3.ArrayUtils;

import l2s.gameserver.geometry.Location;
import l2s.gameserver.model.Player;
import l2s.gameserver.model.instances.NpcInstance;
import l2s.gameserver.model.quest.Quest;
import l2s.gameserver.model.quest.QuestState;

/**
 * @author Edoo
 */
public class _10890_SaviorsPathFallOfEtina extends Quest
{
	// NPCs
	private static final int LEONA = 34425;
	
	// Monsters
	private static final int[] ETINA = {26322};
	
	// Misc
	private static final int MIN_LEVEL = 104;
	private static final Location OUTLET_LOC = new Location(-251721, 178366, -8928);
	private static final long REWARD_EXP = 376_172_418_240L;
	private static final int REWARD_SP = 345_208_219;
	private static final int REWARD_MASK_ID = 48584;
	private static final int REWARD_ENCHANT_ID = 48583;
	
	public _10890_SaviorsPathFallOfEtina()
	{
		super(PARTY_ALL, ONETIME);
		addStartNpc(LEONA);
		addTalkId(LEONA);
		addKillId(ETINA);
		addLevelCheck("no_level.htm", MIN_LEVEL);
		addQuestCompletedCheck("no_level.htm", 10889);
	}
	
	@Override
	public String onEvent(String event, QuestState st, NpcInstance npc)
	{
		Player player = st.getPlayer();
		
		switch (event)
		{
			case "leona_q10890_02.htm":
			{
				st.setCond(1);
				player.teleToLocation(OUTLET_LOC);
				break;
			}
			case "leona_q10890_04.htm":
			{
				st.setCond(2);
				break;
			}
			case "leona_q10890_06.htm":
			{
				if (st.getCond() == 3)
				{
					st.addExpAndSp(REWARD_EXP, REWARD_SP);
					st.giveItems(REWARD_MASK_ID, 1);
					st.giveItems(REWARD_ENCHANT_ID, 1);
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
						return "leona_q10890_01.htm";
					case 1:
						return "leona_q10890_01_1.htm";
					case 2:
						return "leona_q10890_03.htm";
					case 3:
						return "leona_q10890_05.htm";
				}
				break;
			}
		}
		return NO_QUEST_DIALOG;
	}
	
	@Override
	public String onKill(NpcInstance npc, QuestState qs)
	{
		if ((qs.getCond() == 2) && ArrayUtils.contains(ETINA, npc.getNpcId()))
		{
			qs.setCond(3);	
		}
		else
			{
				qs.playSound(SOUND_ITEMGET);
			}
		return null;
	}
}