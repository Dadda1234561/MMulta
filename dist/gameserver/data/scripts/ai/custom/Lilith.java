package ai.custom;

import l2s.gameserver.ai.Fighter;
import l2s.gameserver.model.Creature;
import l2s.gameserver.model.entity.Reflection;
import l2s.gameserver.model.instances.NpcInstance;

/**
 * @author sharp at 04.03.2023 / 4:18
 * t.me/sharp1que
 */
public class Lilith extends Fighter {
    public Lilith(NpcInstance actor) {
        super(actor);
    }

    @Override
    protected void onEvtDead(Creature killer) {
        Reflection r = getActor().getReflection();
        if (r != null) {
            r.setReenterTime(System.currentTimeMillis(), true);
        }
        super.onEvtDead(killer);
    }
}
