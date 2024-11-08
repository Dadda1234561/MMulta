package npc.model.octavis;

import l2s.commons.collections.MultiValueSet;
import l2s.gameserver.model.Creature;
import l2s.gameserver.model.entity.Reflection;
import l2s.gameserver.model.instances.RaidBossInstance;
import l2s.gameserver.templates.npc.NpcTemplate;

import instances.Octavis;

/**
 * @author Bonux
**/
public final class OctavisThirdInstance extends RaidBossInstance
{
	public OctavisThirdInstance(int objectId, NpcTemplate template, MultiValueSet<String> set)
	{
		super(objectId, template, set);
	}

	@Override
	protected void onDeath(Creature killer)
	{
		super.onDeath(killer);

		deleteMe();

		Reflection reflection = getReflection();
		if(reflection instanceof Octavis)
			((Octavis) reflection).nextState();
	}
}