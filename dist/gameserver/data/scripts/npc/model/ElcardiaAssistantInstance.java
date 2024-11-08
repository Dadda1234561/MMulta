package npc.model;

import java.util.HashSet;
import java.util.Set;

import l2s.commons.collections.MultiValueSet;
import l2s.gameserver.ThreadPoolManager;
import l2s.gameserver.ai.CtrlIntention;
import l2s.gameserver.ai.DefaultAI;
import l2s.gameserver.ai.PlayableAI;
import l2s.gameserver.model.Creature;
import l2s.gameserver.model.Player;
import l2s.gameserver.model.Skill;
import l2s.gameserver.model.instances.NpcInstance;
import l2s.gameserver.model.quest.QuestState;
import l2s.gameserver.network.l2.s2c.ExStartScenePlayer;
import l2s.gameserver.network.l2.s2c.MagicSkillUse;
import l2s.gameserver.skills.SkillEntry;
import l2s.gameserver.skills.SkillEntryType;
import l2s.gameserver.templates.npc.NpcTemplate;
//import quests._10286_ReunionWithSirra;

/**
 * @author pchayka
 */

public final class ElcardiaAssistantInstance extends NpcInstance
{
	private final static int[][] _elcardiaBuff = new int[][]{
			// ID, warrior = 0, mage = 1, both = 2
			{6714, 2}, // Wind Walk of Elcadia
			//{6715, 0}, // Haste of Elcadia
			//{6716, 0}, // Might of Elcadia
			//{6717, 1}, // Berserker Spirit of Elcadia
			//{6718, 0}, // Death Whisper of Elcadia
			{6719, 1}, // Guidance of Elcadia
			{6720, 2}, // Focus of Elcadia
			{6721, 0}, // Empower of Elcadia
			{6722, 0}, // Acumen of Elcadia
			{6723, 0}, // Concentration of Elcadia
			//{6727, 2}, // Vampiric Rage of Elcadia
			//{6729, 2}, // Resist Holy of Elcadia

	};

	public ElcardiaAssistantInstance(int objectId, NpcTemplate template, MultiValueSet<String> set)
	{
		super(objectId, template, set);
	}

	@Override
	public void onBypassFeedback(Player player, String command)
	{
		if(command.equalsIgnoreCase("request_blessing"))
		{
			// temporary implementation
			Set<Creature> targets = new HashSet<Creature>();
			targets.add(player);
			for(int[] buff : _elcardiaBuff)
				callSkill(player, SkillEntry.makeSkillEntry(SkillEntryType.NONE, buff[0], 1), targets, true, false);
		}
		else
			super.onBypassFeedback(player, command);
	}
}
