package quests;

import l2s.gameserver.model.instances.NpcInstance;
import l2s.gameserver.model.quest.Quest;
import l2s.gameserver.model.quest.QuestState;
import l2s.gameserver.network.l2.components.NpcString;

/**
 * @author Edoo
 */
public class _10887_SaviorsPathDemonsAndAtelia extends Quest
{
	// NPCs
	private static final int DEVIANNE = 34427;
	
	private static final String A_LIST = "A_LIST";
	
	// Monsters
	private static final int[] MONSTERS = 
	{
		24144, // Death Rogue
		24145, // Death Shooter
		24146, // Death Warrior
		24147, // Death Sorcerer
		24148, // Death Pondus
		24149, // Devil Nightmare
		24150, // Devil Warrior
		24151, // Devil Guardian
		24152, // Devil Sinist
		24153, // Devil Varos
		24154, // Demonic Wizard
		24155, // Demonic Warrior
		24156, // Demonic Archer
		24157, // Demonic Keras
		24158 // Demonic Weiss
	};
	// Misc
	private static final int MIN_LEVEL = 103;
	private static final long REWARD_EXP = 108_766_499_040L;
	private static final int REWARD_SP = 108_766_440;
	private static final int REWARD_ADENA = 12_309_205;
	
	public _10887_SaviorsPathDemonsAndAtelia()
	{
		super(PARTY_ALL, ONETIME);
		addStartNpc(DEVIANNE);
		addTalkId(DEVIANNE);
		addKillNpcWithLog(1, NpcString.LV_103_SAVIOR_S_PATH_DEMONS_AND_ATELIA_2.getId(), A_LIST, 500, MONSTERS);
		addLevelCheck("no_level.htm", MIN_LEVEL);
		addQuestCompletedCheck("no_level.htm", 10886);
	}
	
	@Override
	public String onEvent(String event, QuestState st, NpcInstance npc)
	{
		switch (event)
		{
			case "devianne_q10887_02.htm":
			{
				st.setCond(1);
				break;
			}
			case "devianne_q10887_04.htm":
			{
				if (st.getCond() == 2)
				{
					st.addExpAndSp(REWARD_EXP, REWARD_SP);
					st.giveItems(57, REWARD_ADENA);
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
			case DEVIANNE:
			{
				switch (cond)
				{
					case 0:
						return "devianne_q10887_01.htm";
					case 1:
						return "devianne_q10887_02.htm";
					case 2:
						return "devianne_q10887_03.htm";
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
		}
		else
			{
				qs.playSound(SOUND_ITEMGET);
			}
		return null;
	}
}