package quests;

import l2s.gameserver.model.instances.NpcInstance;
import l2s.gameserver.model.quest.Quest;
import l2s.gameserver.model.quest.QuestState;
import l2s.gameserver.network.l2.components.NpcString;
import l2s.gameserver.network.l2.s2c.ExShowScreenMessage;

/**
 * @author Edoo
 */
public class _1900_StormIsleSecretSpot extends Quest
{
	// NPC
	private static final int HORA = 34528;
	
	private static final String A_LIST = "A_LIST";
	
	// Mobs
	private static final int[] MONSTERS = 
	{
		24427, // Fury Tier Nero
		24428, // Fury Sulph Melan
		24429, // Fury Sulph Album
		24430, // Fury Harpy Schvar
		24431, // Fury Harpe
		24432 // Fury Harpy Queen
	};
	// Misc
	private static final int MIN_LEVEL = 99;
	
	public _1900_StormIsleSecretSpot()
	{
		super(PARTY_ONE, DAILY);
		addStartNpc(HORA);
		addTalkId(HORA);
		addKillNpcWithLog(1, NpcString.ERADICATE_MONSTERS_ON_STORM_ISLE.getId(), A_LIST, 200, MONSTERS);
		addLevelCheck("no_level.htm", MIN_LEVEL);
	}
	
	@Override
	public String onEvent(String event, QuestState st, NpcInstance npc)
	{
		switch (event)
		{
			case "hora_q1900_02.htm":
			case "hora_q1900_03.htm":
			{
				break;
			}
			case "hora_q1900_04.htm":
			{
				st.setCond(1);
				break;
			}
			case "hora_q1900_07.htm":
			{
				if (st.getCond() == 2)
				{
					st.addExpAndSp(44442855977L, 0);
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
			case HORA:
			{
				switch (cond)
				{
					case 0:
						return "hora_q1900_01.htm";
					case 1:
						return "hora_q1900_06.htm";
					case 2:
						return "hora_q1900_05.htm";
				}
				break;
			}
		}
		return NO_QUEST_DIALOG;
	}
	
	@Override
	public String onKill(NpcInstance npc, QuestState qs)
	{
		if ((qs.getCond() == 1) && updateKill(npc, qs))
		{
			qs.unset(A_LIST);
			qs.setCond(2);	
			qs.getPlayer().sendPacket(new ExShowScreenMessage(NpcString.TALK_TO_HORA, 5000, ExShowScreenMessage.ScreenMessageAlign.TOP_CENTER, false));
		}
		else
			{
				qs.playSound(SOUND_ITEMGET);
			}
		return null;
	}
}
