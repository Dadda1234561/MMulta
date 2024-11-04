package ai.custom;

import l2s.gameserver.ai.Fighter;
import l2s.gameserver.model.Creature;
import l2s.gameserver.model.entity.Reflection;
import l2s.gameserver.model.instances.NpcInstance;

/**
 * @author sharp at 05.03.2023 / 18:15
 * t.me/sharp1que
 */
public class FrintezzaRebirth extends Fighter {

    public FrintezzaRebirth(NpcInstance actor) {
        super(actor);
    }

    @Override
    protected void onEvtDead(Creature killer) {
        Reflection ref = getActor().getReflection();
        if (ref != null) {
            ref.setReenterTime(System.currentTimeMillis(), true);
        }
        super.onEvtDead(killer);
    }
}
