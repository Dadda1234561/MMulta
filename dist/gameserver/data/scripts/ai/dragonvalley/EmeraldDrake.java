package ai.dragonvalley;

import l2s.commons.util.Rnd;
import l2s.gameserver.Config;
import l2s.gameserver.ai.CtrlEvent;
import l2s.gameserver.ai.Mystic;
import l2s.gameserver.model.Creature;
import l2s.gameserver.model.Skill;
import l2s.gameserver.model.instances.NpcInstance;
import l2s.gameserver.utils.NpcUtils;

/**
 * @author Aristo Emerald Drake(22829)
 * Спавнит пиявок(22860), когда атакован.
 */
public class EmeraldDrake extends Mystic {

    public EmeraldDrake(NpcInstance actor) {
        super(actor);
    }

    @Override
    protected void onEvtAttacked(Creature attacker, Skill skill, int damage)
	{
       /* if (Rnd.chance(Config.EDRAKE_MS_CHANCE)) {
            NpcInstance actor = getActor();
            NpcInstance n = NpcUtils.spawnSingle(22860, (actor.getX() + Rnd.get(-100, 100)), (actor.getY() + Rnd.get(-100, 100)), actor.getZ());
            n.getAI().notifyEvent(CtrlEvent.EVT_AGGRESSION, attacker, 2);
        }
		*/
        super.onEvtAttacked(attacker, skill, damage);
    }
}
