package l2s.gameserver.skills.effects;

import l2s.gameserver.handler.effects.EffectHandler;
import l2s.gameserver.model.Creature;
import l2s.gameserver.model.Player;
import l2s.gameserver.model.actor.instances.creature.Abnormal;
import l2s.gameserver.templates.skill.EffectTemplate;

public class EffectHealerActive extends EffectHandler {
    public EffectHealerActive(EffectTemplate template) {
        super(template);
    }

    @Override
    public void onStart(Abnormal abnormal, Creature effector, Creature effected) {
        if (effected.isPlayer()) {
            Player player = effected.getPlayer();
            if (player != null) {
                player.getHealer().setEnabled(true);
            }
        }
        super.onStart(abnormal, effector, effected);
    }

    @Override
    public void onExit(Abnormal abnormal, Creature effector, Creature effected) {
        if (effected.isPlayer()) {
            Player player = effected.getPlayer();
            if (player != null) {
                player.getHealer().setEnabled(false);
            }
        }
        super.onExit(abnormal, effector, effected);
    }
}
