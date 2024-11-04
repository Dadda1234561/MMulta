package handler.voicecommands;

import l2s.gameserver.model.Player;
import l2s.gameserver.model.actor.instances.player.Healer;
import l2s.gameserver.skills.SkillEntry;

import java.util.StringTokenizer;

/**
 * @author sharp
 */
public class HealerCmd extends ScriptVoiceCommandHandler {
    private String[] COMMANDS = {"addhealerskill", "removehealerskill", "editheaelrsettings", "healersetpercent"};

    @Override
    public boolean useVoicedCommand(String command, Player player, String target) {
        Healer healer = player.getHealer();
        StringTokenizer st = new StringTokenizer(target, " ");
        if (command.startsWith("addhealerskill")) {
            if (st.hasMoreTokens()) {
                int skillId = Integer.parseInt(st.nextToken());
                SkillEntry knownSkill = player.getKnownSkill(skillId);
                if (knownSkill != null) {
                    healer.addSkill(knownSkill);
                    healer.showConfig();
                    return true;
                }
            }
        } else if (command.startsWith("removehealerskill")) {
            if (st.hasMoreTokens()) {
                int skillId = Integer.parseInt(st.nextToken());
                SkillEntry knownSkill = player.getKnownSkill(skillId);
                if (knownSkill != null) {
                    healer.removeSkill(knownSkill);
                    healer.showConfig();
                    return true;
                }
            }
        } else if (command.startsWith("editheaelrsettings")) {
            if (st.hasMoreTokens()) {
                player.getHealer().showConfig();
            } else {
                player.getHealer().showSettings();
            }
            return true;
        } else if (command.startsWith("healersetpercent")) {
            if (st.hasMoreTokens()) {
                int skillId = Integer.parseInt(st.nextToken());
                SkillEntry knownSkill = player.getKnownSkill(skillId);
                if (knownSkill != null) {
                    int percent = 100;
                    try {
                        if (!st.hasMoreTokens()) {
                            healer.showSettings();
                            return true;
                        }
                        percent = Integer.parseInt(st.nextToken());
                        percent = Math.min(Math.max(-1, percent), 100);
                    } catch (NumberFormatException e) {
                        e.printStackTrace();
                    }

                    healer.setPercent(knownSkill, percent);
                    healer.showSettings();
                    return true;
                }
            }
        }
        return false;
    }

    @Override
    public String[] getVoicedCommandList() {
        return COMMANDS;
    }
}
