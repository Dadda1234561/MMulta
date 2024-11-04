package l2s.gameserver.skills.skillclasses;

import java.util.Set;

import l2s.gameserver.model.Creature;
import l2s.gameserver.model.Player;
import l2s.gameserver.model.Skill;
import l2s.gameserver.skills.SkillEntry;
import l2s.gameserver.templates.StatsSet;

/**
 * @author Bonux
**/
public class ChangeClass extends Skill
{
	private int _classIndex;

	public ChangeClass(StatsSet set)
	{
		super(set);
		_classIndex = set.getInteger("class_index");
	}

	@Override
	public boolean checkCondition(SkillEntry skillEntry, Creature activeChar, Creature target, boolean forceUse, boolean dontMove, boolean first, boolean sendMsg, boolean trigger)
	{
		if(!super.checkCondition(skillEntry, activeChar, target, forceUse, dontMove, first, sendMsg, trigger))
			return false;

		if(!activeChar.isPlayer())
			return false;

		return true;
	}

	@Override
	public void onEndCast(Creature activeChar, Set<Creature> targets)
	{
		super.onEndCast(activeChar, targets);

		Player player = activeChar.getPlayer();
		if(player == null)
			return;
		
		player.changeClass(_classIndex);
	}
}