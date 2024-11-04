package ai.hellbound;

import l2s.gameserver.ai.Fighter;
import l2s.gameserver.data.xml.holder.NpcHolder;
import l2s.gameserver.model.SimpleSpawner;
import l2s.gameserver.model.instances.NpcInstance;
import l2s.gameserver.geometry.Location;
import l2s.gameserver.utils.NpcUtils;

/**
 * @author pchayka
 */
public class Pylon extends Fighter
{
	public Pylon(NpcInstance actor)
	{
		super(actor);
		actor.getFlags().getImmobilized().start();
	}

	@Override
	protected void onEvtSpawn()
	{
		super.onEvtSpawn();

		NpcInstance actor = getActor();
		for (int i = 0; i < 7; i++) {
			NpcUtils.spawnSingle(22422, Location.findPointToStay(actor, 150, 550));
		}
	}
}