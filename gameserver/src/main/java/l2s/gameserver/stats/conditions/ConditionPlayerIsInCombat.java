package l2s.gameserver.stats.conditions;

import l2s.gameserver.model.Player;
import l2s.gameserver.stats.Env;

/**
 * @author Bonux
**/
public class ConditionPlayerIsInCombat extends Condition
{
	private final boolean _isInCombat;

	public ConditionPlayerIsInCombat(boolean isInCombat)
	{
		_isInCombat = isInCombat;
	}

	@Override
	protected boolean testImpl(Env env)
	{
		Player player = env.character.getPlayer();
		if(player == null)
			return !_isInCombat;
		return player.isInCombat() == _isInCombat;
	}
}