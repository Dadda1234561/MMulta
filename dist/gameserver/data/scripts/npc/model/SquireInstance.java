package npc.model;

import l2s.commons.collections.MultiValueSet;
import l2s.gameserver.model.Player;
import l2s.gameserver.model.Skill;
import l2s.gameserver.model.instances.NpcInstance;
import l2s.gameserver.skills.SkillEntry;
import l2s.gameserver.skills.SkillEntryType;
import l2s.gameserver.templates.npc.NpcTemplate;

public class SquireInstance extends NpcInstance
{
	public static final SkillEntry CUCURU_SKILL = SkillEntry.makeSkillEntry(SkillEntryType.NONE, 9204, 1);

	public SquireInstance(int objectId, NpcTemplate template, MultiValueSet<String> set)
	{
		super(objectId, template, set);
	}

	@Override
	public void onBypassFeedback(Player player, String command)
	{
		if(command.startsWith("try_kukura"))
		{
			//TODO: [Bonux] Проверить, наверно тут есть какие-то условия.
			CUCURU_SKILL.getEffects(player, player);
		}
		else
			super.onBypassFeedback(player, command);
	}
}