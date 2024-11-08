package ai.primeval_isle;

import l2s.gameserver.ai.Fighter;
import l2s.gameserver.model.Skill;
import l2s.gameserver.model.instances.NpcInstance;
import l2s.gameserver.network.l2.s2c.SocialActionPacket;
import l2s.gameserver.data.xml.holder.SkillHolder;
import l2s.gameserver.skills.SkillEntry;
import l2s.gameserver.skills.SkillEntryType;

/**
 * @author VISTALL
 * @date 4:57/16.06.2011
 */
public class SprigantPoison extends Fighter {
    
    private final SkillEntry SKILL = SkillEntry.makeSkillEntry(SkillEntryType.NONE,5086, 1);
    private long _waitTime;
    private static final int TICK_IN_MILISECONDS = 15000;

    public SprigantPoison(NpcInstance actor) {
        super(actor);
    }

    @Override
    protected boolean thinkActive() {
        NpcInstance actor = getActor();
        if (System.currentTimeMillis() > _waitTime) {
            actor.doCast(SKILL, actor, false);
            _waitTime = System.currentTimeMillis() + TICK_IN_MILISECONDS;
        }
        actor.broadcastPacket(new SocialActionPacket(actor.getObjectId(), 1));
        super.thinkActive();
        return true;
    }
}
