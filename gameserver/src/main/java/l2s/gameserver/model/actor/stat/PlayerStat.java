package l2s.gameserver.model.actor.stat;

import l2s.gameserver.model.Player;

/**
 * @author Bonux
**/
public class PlayerStat extends CreatureStat
{
	public PlayerStat(Player owner)
	{
		super(owner);
	}

	@Override
	public Player getOwner()
	{
		return (Player) _owner;
	}
}