package quests;

import org.apache.commons.lang3.ArrayUtils;

import l2s.commons.util.Rnd;
import l2s.gameserver.model.instances.NpcInstance;
import l2s.gameserver.model.quest.Quest;
import l2s.gameserver.model.quest.QuestState;

/**
 * @author Edoo
 */
public class _10888_SaviorsPathDefeatTheEmbryo extends Quest
{
	// NPCs
	private static final int DEVIANNE = 34427;
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
	// Items
	private static final int ATELIA_IN_EXTRACTION = 48547;
	// Misc
	private static final int REQUIRED_ITEMS = 200;
	private static final int MIN_LEVEL = 103;
	private static final long REWARD_EXP = 108_766_499_040L;
	private static final int REWARD_SP = 108_766_440;
	private static final int REWARD_ADENA = 12_309_205;
	
	public _10888_SaviorsPathDefeatTheEmbryo()
	{
		super(PARTY_ALL, ONETIME);
		addStartNpc(DEVIANNE);
		addTalkId(DEVIANNE);
		addKillId(MONSTERS);
		addLevelCheck("no_level.htm", MIN_LEVEL);
		addQuestCompletedCheck("no_level.htm", 10887);
	}
	
	@Override
	public String onEvent(String event, QuestState st, NpcInstance npc)
	{
		switch (event)
		{
			case "devianne_q10888_02.htm":
			{
				st.setCond(1);
				break;
			}
			case "devianne_q10888_04.htm":
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
						return "devianne_q10888_01.htm";
					case 1:
						return "devianne_q10888_02.htm";
					case 2:
						return "devianne_q10888_03.htm";
				}
				break;
			}
		}
		return NO_QUEST_DIALOG;
	}
	
	@Override
	public String onKill(NpcInstance npc, QuestState qs)
	{
		if ((qs.getCond() == 1) && (Rnd.get(100) > 0.5) && ArrayUtils.contains(MONSTERS, npc.getNpcId()))
		{
			qs.giveItems(ATELIA_IN_EXTRACTION, 1);
			if (qs.getQuestItemsCount(ATELIA_IN_EXTRACTION) >= REQUIRED_ITEMS)
			{
				qs.setCond(2);
			}
			else
				qs.playSound(SOUND_ITEMGET);
		}
		return null;
	}
}