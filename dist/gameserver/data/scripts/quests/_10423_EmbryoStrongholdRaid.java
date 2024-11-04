package quests;

import l2s.gameserver.model.instances.NpcInstance;
import l2s.gameserver.model.quest.Quest;
import l2s.gameserver.model.quest.QuestState;
import l2s.gameserver.network.l2.components.NpcString;
import l2s.gameserver.network.l2.s2c.ExShowScreenMessage;

/**
 * @author Edoo
 */
public class _10423_EmbryoStrongholdRaid extends Quest
{
	// NPCs
	private static final int ERDA = 34319;
	
	private static final String A_LIST = "A_LIST";
	
	// Monsters
	private static final int[] MOBS =
	{
		26199, // Sampson
		26200, // Hanson
		26201, // Grom
		26202, // Medvez
		26203, // Zigatan
		26204, // Hunchback Kwai
		26205, // Cornix
		26206, // Caranix
		26207, // Jonadan
		26208, // Demien
		26209, // Berg
		26210, // Tarku
		26211, // Tarpin
		26212, // Embryo Safe Vault
		26213, // Embryo Secret Vault
		26214, // Sakum
		26215, // Crazy Typhoon
		26216, // Cursed Haren
		26217, // Flynt
		26218, // Harp
		26219, // Maliss
		26220, // Isadora
		26221, // Whitra
		26222, // Bletra
		26223, // Upgraded Siege Tank
		26224, // Vegima
		26225, // Varonia
		26226, // Aronia
		26227, // Odd
		26228, // Even
		26229 // Nemertess
	};
	// Rewards
	private static final int SUPERIOR_GIANTS_CODEX = 46151; // Superior Giant's Codex - Mastery Chapter 1
	// Misc
	private static final int MIN_LEVEL = 100;
	
	public _10423_EmbryoStrongholdRaid()
	{
		super(PARTY_ONE, DAILY);
		addStartNpc(ERDA);
		addTalkId(ERDA);
		// TODO: Нужна проверка на уровень фракции Blackbird!
		addKillNpcWithLog(1, NpcString.DEFEAT_EMBRYO_OFFICER.getId(), A_LIST, 30, MOBS);
		addLevelCheck("no_level.htm", MIN_LEVEL);
	}
	
	@Override
	public String onEvent(String event, QuestState st, NpcInstance npc)
	{
		switch (event)
		{
			case "erda_q10423_02.htm":
			case "erda_q10423_03.htm":
			case "erda_q10423_07.htm":
			{
				break;
			}
			case "erda_q10423_04.htm":
			{
				st.setCond(1);
				break;
			}
			case "erda_q10423_08.htm":
			{
				if (st.getCond() == 2)
				{
					st.giveItems(SUPERIOR_GIANTS_CODEX, 1);
					st.addExpAndSp(29682570651L, 71108570);
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
			case ERDA:
			{
				switch (cond)
				{
					case 0:
						return "erda_q10423_01.htm";
					case 1:
						return "erda_q10423_05.htm";
					case 2:
						return "erda_q10423_06.htm";
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
			qs.getPlayer().sendPacket(new ExShowScreenMessage(NpcString.TALK_WITH_ERDA, 5000, ExShowScreenMessage.ScreenMessageAlign.TOP_CENTER, false));
		}
		else
			{
				qs.playSound(SOUND_ITEMGET);
			}
		return null;
	}
}