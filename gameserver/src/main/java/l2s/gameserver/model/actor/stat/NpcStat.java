package l2s.gameserver.model.actor.stat;

import l2s.gameserver.model.instances.NpcInstance;

/**
 * @author Bonux
**/
public class NpcStat extends CreatureStat
{
	public NpcStat(NpcInstance owner)
	{
		super(owner);
	}

	@Override
	public NpcInstance getOwner()
	{
		return (NpcInstance) _owner;
	}
}