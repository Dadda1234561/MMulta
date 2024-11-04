package l2s.gameserver.model.actor.stat;

import l2s.gameserver.model.Servitor;

/**
 * @author Bonux
**/
public class ServitorStat extends CreatureStat
{
	public ServitorStat(Servitor owner)
	{
		super(owner);
	}

	@Override
	public Servitor getOwner()
	{
		return (Servitor) _owner;
	}
}