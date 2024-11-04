package l2s.gameserver.skills.effects.instant;

import l2s.gameserver.handler.voicecommands.IVoicedCommandHandler;
import l2s.gameserver.handler.voicecommands.VoicedCommandHandler;
import l2s.gameserver.model.Creature;
import l2s.gameserver.model.Player;
import l2s.gameserver.templates.skill.EffectTemplate;

public class i_voice_command extends i_abstract_effect {

    private final String _voiceCommand;

    public i_voice_command(EffectTemplate template) {
        super(template);

        _voiceCommand = template.getParams().getString("command");
    }

    @Override
    protected boolean checkCondition(Creature effector, Creature effected) {
        return true;
    }

    @Override
    public void instantUse(Creature effector, Creature effected, boolean reflected) {
        if (_voiceCommand == null) {
            return;
        }

        if (effected.isPlayer()) {
            Player player = effected.getPlayer();
            if (player != null) {
                IVoicedCommandHandler handler = VoicedCommandHandler.getInstance().getVoicedCommandHandler(_voiceCommand);
                if (handler != null) {
                    handler.useVoicedCommand(_voiceCommand, player, "");
                }
            }
        }
    }
}
