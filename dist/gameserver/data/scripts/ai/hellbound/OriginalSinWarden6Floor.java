package ai.hellbound;

import l2s.commons.util.Rnd;
import l2s.gameserver.ai.Fighter;
import l2s.gameserver.geometry.Location;
import l2s.gameserver.model.Creature;
import l2s.gameserver.model.instances.NpcInstance;
import l2s.gameserver.utils.NpcUtils;

/**
 * Original Sin Warden 8-го этажа Tully Workshop
 * @автор VAVAN
 */
public class OriginalSinWarden6Floor extends Fighter
{
	private static final int[] DarionsFaithfulServants = {22405, 22406, 22407};

	public OriginalSinWarden6Floor(NpcInstance actor) {
		super(actor);
	}

	@Override
	protected void onEvtDead(Creature killer) {
		NpcInstance actor = getActor();

		if(Rnd.chance(15))
			NpcUtils.spawnSingle(Rnd.get(DarionsFaithfulServants), Location.findPointToStay(actor, 150, 350));

		super.onEvtDead(killer);
	}

}