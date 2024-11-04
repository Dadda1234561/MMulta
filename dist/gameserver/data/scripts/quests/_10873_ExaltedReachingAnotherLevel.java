package quests;

import org.apache.commons.lang3.ArrayUtils;

import l2s.gameserver.listener.actor.player.OnLevelChangeListener;
import l2s.gameserver.model.Player;
import l2s.gameserver.model.actor.listener.CharListenerList;
import l2s.gameserver.model.instances.NpcInstance;
import l2s.gameserver.model.quest.Quest;
import l2s.gameserver.model.quest.QuestState;

/**
 * @author Edoo
 */
public class _10873_ExaltedReachingAnotherLevel extends Quest
{
	private static class ChangeLevelListener implements OnLevelChangeListener
	{
		@Override
		public void onLevelChange(Player player, int was, int set)
		{
			QuestState qs = player.getQuestState(10873);
			if(qs == null)
				return;

			if ((qs.getCond() == 1) && (qs.getQuestItemsCount(PROOF_OF_REPUTATION) >= 80000) && (player.getLevel() >= 105))
				qs.setCond(2);
		}
	}
	
	private static final OnLevelChangeListener LEVEL_CHANGE_LISTENER = new ChangeLevelListener();
	
	// NPC
		private static final int LIONEL = 33907;
		// Items
		private static final int PROOF_OF_REPUTATION = 80826;
		// Rewards
		private static final int DIGNITY_OF_THE_EXALTED = 47852;
		private static final int VITALITY_OF_THE_EXALTED = 47854;
		// Mobs
		private static final int[] MONSTERS =
		{
			20936, // Tanor Silenos
			20937, // Tanor Silenos Soldier
			20938, // Tanor Silenos Scout
			20939, // Tanor Silenos Warrior
			20941, // Tanor Silenos Chieftain
			20942, // Nightmare Guide
			20943, // Nightmare Watchman
			23354, // Decay Hannibal
			23355, // Armor Beast
			23356, // Klein Soldier
			23357, // Disorder Warrior
			23360, // Bizuard
			23361, // Mutated Fly
			23566, // Nymph Rose
			23567, // Nymph Rose
			23568, // Nymph Lily
			23569, // Nymph Lily
			23570, // Nymph Tulip
			23571, // Nymph Tulip
			23572, // Nymph Cosmos
			23573, // Nymph Cosmos
			23587, // Nymph Guardian
			23581, // Apheros
			23811, // Cantera Tanya
			23812, // Cantera Deathmoz
			23813, // Cantera Floxis
			23814, // Cantera Belika
			23815, // Cantera Bridget
			24318, // Temple Guard Captain
			24321, // Temple Patrol Guard
			24322, // Temple Knight Recruit
			24323, // Temple Guard
			24324, // Temple Guardian Warrior
			24325, // Temple Wizard
			24326, // Temple Guardian Wizard
			24329, // Starving Water Dragon
			24373, // Dailaon Lad
			24376, // Nos Lad
			24377, // Swamp Tribe
			24378, // Swamp Alligator
			24379, // Swamp Warrior
			24415, // Breka Orc Scout
			24416, // Breka Orc Scout Captain
			24417, // Breka Orc Archer
			24418, // Breka Orc Shaman
			24419, // Breka Orc Slaughterer
			24420, // Breka Orc Prefect
			24421, // Stone Gargoyle
			24422, // Stone Golem
			24423, // Monster Eye
			24424, // Gargoyle Hunter
			24425, // Steel Golem
			24426, // Stone Cube
			24445, // Lizardman Rogue
			24446, // Island Guard
			24447, // Niasis
			24448, // Lizardman Archer
			24449, // Lizardman Warrior
			24450, // Lizardmen Wizard
			24451, // Lizardmen Defender
			24461, // Forest Ghost
			24462, // Bewildered Expedition Member
			24463, // Bewildered Patrol
			24464, // Bewildered Dwarf Adventurer
			24465, // Forest Evil Spirit
			24466, // Demonic Mirror
			24480, // Dragon Legionnaire
			24481, // Dragon Peltast
			24482, // Dragon Officer
			24483, // Dragon Centurion
			24484, // Dragon Elite Guard
			24485, // Behemoth Dragon
			24486, // Dismal Pole
			24487, // Graveyard Predator
			24488, // Doom Archer
			24489, // Doom Scout
			24490, // Doom Soldier
			24491, // Doom Knight
			24492, // Sel Mahum Soldier
			24493, // Sel Mahum Squad Leader
			24494, // Sel Mahum Warrior
			24495, // Keltron
			24496, // Tanta Lizardman Warrior
			24497, // Tanta Lizardman Archer
			24498, // Tanta Lizardman Wizard
			24499, // Priest Ugoros
			24500, // Sand Golem
			24501, // Centaur Fighter
			24502, // Centaur Marksman
			24503, // Centaur Wizard
			24504, // Centaur Warlord
			24505, // Earth Elemental Lord
			24506, // Silence Witch
			24507, // Silence Preacle
			24508, // Silence Warrior
			24509, // Silence Slave
			24510, // Silence Hannibal
			24511, // Lunatikan
			24512, // Garion Neti
			24513, // Desert Wendigo
			24514, // Koraza
			24515, // Kandiloth
			24517, // Kropiora
			24518, // Water Drake
			24519, // Spiz Water Drake
			24520, // Krotania
			24521, // Krophy
			24522, // Spiz Krophy
			24523 // Krotany
		};
		// Misc
		private static final int MIN_LEVEL = 103;
	
	public _10873_ExaltedReachingAnotherLevel()
	{
		super(PARTY_ONE, ONETIME);
		addStartNpc(LIONEL);
		addTalkId(LIONEL);
		addKillId(MONSTERS);
		addLevelCheck("no_level.htm", MIN_LEVEL);
		addQuestCompletedCheck("no_level.htm", 10823);
	}
	
	@Override
	public String onEvent(String event, QuestState st, NpcInstance npc)
	{
		switch (event)
		{
			case "lionel_hunter_q10873_03.htm":
			case "lionel_hunter_q10873_04.htm":
			{
				break;
			}
			case "lionel_hunter_q10873_05.htm":
			{
				st.setCond(1);
				break;
			}
			case "lionel_hunter_q10873_08.htm":
			{
				if (st.getCond() == 2)
				{
					st.takeAllItems(PROOF_OF_REPUTATION);
					st.giveItems(DIGNITY_OF_THE_EXALTED, 1);
					st.giveItems(VITALITY_OF_THE_EXALTED, 1);
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
			case LIONEL:
			{
				switch (cond)
				{
					case 0:
						return "lionel_hunter_q10873_01.htm";
					case 1:
						return "lionel_hunter_q10873_06.htm";
					case 2:
						return "lionel_hunter_q10873_07.htm";
				}
				break;
			}
		}
		return NO_QUEST_DIALOG;
	}
	
	@Override
	public String onKill(NpcInstance npc, QuestState qs)
	{
		if ((qs.getCond() == 1) && (qs.getQuestItemsCount(PROOF_OF_REPUTATION) < 80000) && ArrayUtils.contains(MONSTERS, npc.getNpcId()))
		{
			qs.giveItems(PROOF_OF_REPUTATION, 1);
			if ((qs.getQuestItemsCount(PROOF_OF_REPUTATION) >= 80000) && qs.getPlayer().getLevel() >= 105)
			{
				qs.setCond(2);	
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
