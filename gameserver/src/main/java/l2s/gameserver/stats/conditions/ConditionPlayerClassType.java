package l2s.gameserver.stats.conditions;

import l2s.gameserver.model.Player;
import l2s.gameserver.model.base.DualClassType;
import l2s.gameserver.stats.Env;

public class ConditionPlayerClassType extends Condition
{
	private final DualClassType _type;

	public ConditionPlayerClassType(DualClassType type)
	{
		_type = type;
	}

	@Override
	protected boolean testImpl(Env env)
	{
		if(!env.character.isPlayer())
			return false;

		Player player = env.character.getPlayer();
		return player.getActiveDualClass().getType() == _type;
	}
}