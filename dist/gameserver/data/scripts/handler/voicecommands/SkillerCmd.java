package handler.voicecommands;

import l2s.gameserver.model.Player;
import l2s.gameserver.model.actor.instances.player.Skiller;
import l2s.gameserver.skills.SkillEntry;
import l2s.gameserver.skills.SkillEntryType;

import java.util.StringTokenizer;

public class SkillerCmd extends ScriptVoiceCommandHandler {
    private String[] COMMANDS = {"addskill", "removeskill", "editprofiles", "forceAttackEnable"};

    @Override
    public boolean useVoicedCommand(String command, Player player, String target) {
        final Skiller skiller = player.getSkiller();
        if (command.startsWith("addskill")) {
            StringTokenizer st = new StringTokenizer(target, " ");
            if (st.hasMoreTokens()) {
                // skill id
                int skillId = Integer.parseInt(st.nextToken());
                SkillEntry knownSkill = player.getKnownSkill(skillId);
                if (knownSkill == null) {
                    return false;
                } else if (!skiller.isActive(knownSkill)) {
                    skiller.addSkill(knownSkill);
                    return true;
                }
            }
        } else if (command.startsWith("removeskill")) {
            StringTokenizer st = new StringTokenizer(target, " ");
            if (st.hasMoreTokens()) {
                // skill id
                int skillId = Integer.parseInt(st.nextToken());
                SkillEntry knownSkill = player.getKnownSkill(skillId);
                if (knownSkill == null) {
                    player.sendMessage("Removed not found skill.");
                    skiller.removeSkill(skillId);
                    skiller.showConfig();
                    return false;
                } else if (skiller.isActive(knownSkill)) {
                    skiller.removeSkill(knownSkill);
                    skiller.showConfig();
                    return true;
                }
            }
        } else if (command.startsWith("editprofiles")) {
            StringTokenizer st = new StringTokenizer(target, " ");
            if (st.hasMoreTokens()) {
                String action = st.nextToken();
                if (action.startsWith("create")) {
                    if (st.hasMoreTokens()) {
                        String name = st.nextToken();
                        if (name != null && !name.isEmpty()) {
                            skiller.createProfile(name);
                        }
                    }
                } else if (action.startsWith("delete")) {
                    if (st.hasMoreTokens()) {
                        try {
                            Integer profileId = Integer.parseInt(st.nextToken());
                            skiller.deleteProfile(profileId);
                        } catch (NumberFormatException e) {
                            e.printStackTrace();
                        }
                    }
                } else if (action.startsWith("select")) {
                    if (st.hasMoreTokens()) {
                        try {
                            Integer profileId = Integer.parseInt(st.nextToken());
                            skiller.selectProfile(profileId);
                        } catch (NumberFormatException e) {
                            e.printStackTrace();
                        }
                    }
                } else if (action.startsWith("back")) {
                    skiller.showConfig();
                    return true;
                }
            }
            player.getSkiller().showSettings();
        }
        else if (command.startsWith("forceAttackEnable")) {
            skiller.setForceAttackEnabled(!skiller.isForceAttackEnabled());
            if (player.isLangRus()) {
                player.sendMessage("Принудительная Атака " + (skiller.isForceAttackEnabled() ? "Включен" : "Выключен"));
            } else {
                player.sendMessage("Force Attack " + (skiller.isForceAttackEnabled() ? "Enabled" : "Disabled"));
            }
            skiller.showConfig();
        }
        return false;
    }

    @Override
    public String[] getVoicedCommandList() {
        return COMMANDS;
    }
}
