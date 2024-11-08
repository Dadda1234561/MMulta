package ai.hellbound;

import l2s.gameserver.ai.Fighter;
import l2s.gameserver.data.xml.holder.NpcHolder;
import l2s.gameserver.geometry.Location;
import l2s.gameserver.model.Creature;
import l2s.gameserver.model.SimpleSpawner;
import l2s.gameserver.model.Skill;
import l2s.gameserver.model.instances.NpcInstance;
import l2s.gameserver.utils.Functions;
import l2s.gameserver.utils.NpcUtils;

/**
 * @author pchayka
 */
public class NaiaLock extends Fighter
{
	private static boolean _attacked = false;
	private static boolean _entranceactive = false;

	public NaiaLock(NpcInstance actor)
	{
		super(actor);
		actor.getFlags().getImmobilized().start();
	}

	@Override
	protected void onEvtDead(Creature killer)
	{
		NpcInstance actor = getActor();
		_entranceactive = true;
		Functions.npcShout(actor, "The lock has been removed from the Controller device");
		super.onEvtDead(killer);
	}

	@Override
	protected void onEvtSpawn()
	{
		super.onEvtSpawn();
		NpcInstance actor = getActor();
		_entranceactive = false;
		Functions.npcShout(actor, "The lock has been put on the Controller device");
	}

	@Override
	public boolean checkAggression(Creature target)
	{
		return false;
	}

	@Override
	protected void onEvtAttacked(Creature attacker, Skill skill, int damage)
	{
		NpcInstance actor = getActor();

		if (!_attacked) {
			for (int i = 0; i < 4; i++) {
				try {
					NpcUtils.spawnSingle(18493, Location.findPointToStay(actor, 150, 250), actor.getReflection());
				} catch (Exception e) {
					e.printStackTrace();
				}
			}
			_attacked = true;
		}
	}

	public static boolean isEntranceActive()
	{
		return _entranceactive;
	}
}