package ai.quests;

import l2s.gameserver.ai.DefaultAI;
import l2s.gameserver.model.instances.NpcInstance;
import l2s.gameserver.network.l2.components.NpcString;
import l2s.gameserver.skills.SkillEntry;
import l2s.gameserver.skills.SkillEntryType;
import l2s.gameserver.utils.Functions;

// By Evil_dnk

public class GnolNpc extends DefaultAI
{
	public GnolNpc(NpcInstance actor)
	{
		super(actor);
	}

	@Override
	protected void onEvtSpawn()
	{
		Functions.npcSay(getActor(), NpcString.THANK_YOU_DELIVER_THIS_MARK_OF_GRATITUDE_TO_LEO);
		addTaskBuff(getActor(), SkillEntry.makeSkillEntry(SkillEntryType.NONE, 16329, 1));

		super.onEvtSpawn();
	}
}

