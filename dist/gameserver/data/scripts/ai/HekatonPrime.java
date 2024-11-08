package ai;

import l2s.gameserver.ai.Fighter;
import l2s.gameserver.model.Creature;
import l2s.gameserver.model.Skill;
import l2s.gameserver.model.instances.NpcInstance;

public class HekatonPrime extends Fighter
{
	private long _lastTimeAttacked;

	public HekatonPrime(NpcInstance actor)
	{
		super(actor);
	}

	@Override
	protected void onEvtSpawn()
	{
		super.onEvtSpawn();
		_lastTimeAttacked = System.currentTimeMillis();
	}

	@Override
	protected boolean thinkActive()
	{
		if(_lastTimeAttacked + 600000 < System.currentTimeMillis())
		{
			if(getActor().hasMinions())
				getActor().getMinionList().despawnMinions();
			getActor().deleteMe();
			return true;
		}
		return false;
	}

	@Override
	protected void onEvtAttacked(Creature attacker, Skill skill, int damage)
	{
		_lastTimeAttacked = System.currentTimeMillis();
		super.onEvtAttacked(attacker, skill, damage);
	}
}