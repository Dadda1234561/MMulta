package npc.model;

import l2s.commons.collections.MultiValueSet;
import l2s.gameserver.model.Player;
import l2s.gameserver.model.instances.NpcInstance;
import l2s.gameserver.skills.SkillEntry;
import l2s.gameserver.skills.SkillEntryType;
import l2s.gameserver.templates.npc.NpcTemplate;

/**
 * @author Bonux
 */
public class MovingPortalInstance extends NpcInstance
{
	private final SkillEntry _returnSkill;

	public MovingPortalInstance(int objectId, NpcTemplate template, MultiValueSet<String> set)
	{
		super(objectId, template, set);
		_returnSkill = SkillEntry.makeSkillEntry(SkillEntryType.NONE, getParameter("return_skill_id", 0), getParameter("return_skill_level", 1));
	}

	@Override
	public void showChatWindow(Player player, int val, boolean firstTalk, Object... replace)
	{
		forceUseSkill(_returnSkill, player);
	}
}