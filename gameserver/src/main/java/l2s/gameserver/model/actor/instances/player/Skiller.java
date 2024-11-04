package l2s.gameserver.model.actor.instances.player;

import com.google.gson.internal.LinkedTreeMap;
import l2s.gameserver.Config;
import l2s.gameserver.ThreadPoolManager;
import l2s.gameserver.data.htm.HtmCache;
import l2s.gameserver.database.DatabaseFactory;
import l2s.gameserver.model.Creature;
import l2s.gameserver.model.Player;
import l2s.gameserver.model.Skill;
import l2s.gameserver.model.SkillProfile;
import l2s.gameserver.network.l2.components.HtmlMessage;
import l2s.gameserver.skills.SkillEntry;
import l2s.gameserver.skills.SkillEntryType;
import org.apache.commons.lang3.ArrayUtils;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.List;
import java.util.Objects;
import java.util.concurrent.CopyOnWriteArrayList;
import java.util.concurrent.ScheduledFuture;
import java.util.concurrent.atomic.AtomicInteger;

import static l2s.gameserver.model.Skill.SkillType.MDAM;

public class Skiller {
    private static final int MAX_SKILLS = 6;
    private static final int MAX_PROFILES = 3;
    private final LinkedTreeMap<Integer, SkillProfile> _profiles = new LinkedTreeMap<>();
    private final Player _owner;
    private final AtomicInteger _lastUsedIndex = new AtomicInteger(0);
    private final List<SkillEntry> _activeSkills = new CopyOnWriteArrayList<>();
    private SkillProfile _activeProfile;
    private boolean _enableForceAttack;
    private boolean _isEnabled;
    private ScheduledFuture<?> _skillUseTask;

    public Skiller(Player owner) {
        _owner = owner;
        restore();
    }

    private void restore() {
        try (Connection con = DatabaseFactory.getInstance().getConnection()) {
            PreparedStatement stm = con.prepareStatement("SELECT * FROM character_skiller_skills WHERE char_id = ?");
            stm.setInt(1, _owner.getObjectId());
            // if have any
            try (ResultSet rset = stm.executeQuery()) {
                while (rset.next()) {
                    int profileId = rset.getInt("profile_id");
                    String profileName = rset.getString("profile_name");
                    int skillId = rset.getInt("skill_id");
                    int skillLvl = rset.getInt("skill_lvl");

                    _profiles.computeIfAbsent(profileId, id -> new SkillProfile(profileId, profileName)).addSkill(SkillEntry.makeSkillEntry(SkillEntryType.NONE, skillId, skillLvl));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        int biggestId = 0;
        for (SkillProfile profile : _profiles.values()) {
            if (profile.getId() > biggestId) {
                biggestId = profile.getId();
            }
        }
    }

    public void store() {
        setEnabled(false);

        if (_profiles.isEmpty()) {
            return;
        }

        // clear old
        try (Connection con = DatabaseFactory.getInstance().getConnection();
             PreparedStatement stm = con.prepareStatement("DELETE FROM character_skiller_skills WHERE char_id = ?")) {
            stm.setInt(1, _owner.getObjectId());
            stm.execute();

            // store new
            try (Connection sCon = DatabaseFactory.getInstance().getConnection();
                 PreparedStatement sStm = sCon.prepareStatement("INSERT INTO character_skiller_skills(char_id, profile_id, profile_name, skill_id, skill_lvl) VALUES (?, ?, ?, ?, ?)")) {

                for (SkillProfile profile : _profiles.values()) {
                    for (SkillEntry entry : profile.getSkills()) {
                        sStm.setInt(1, _owner.getObjectId());
                        sStm.setInt(2, profile.getId());
                        sStm.setString(3, profile.getName());
                        sStm.setInt(4, entry.getId());
                        sStm.setInt(5, entry.getLevel());
                        sStm.addBatch();
                    }
                }

                sStm.executeBatch();
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    public boolean isActive(SkillEntry skill) {
        if (_profiles.isEmpty()) {
            return false;
        }

        return (_activeProfile != null && _activeProfile.getSkills().stream().anyMatch(skillEntry -> skillEntry.getId() == skill.getId()));
    }

    public SkillProfile getActiveProfile() {
        return _activeProfile;
    }

    public void addSkill(SkillEntry skill) {
        if (_activeProfile == null) {
            showSettings();
            return;
        }

        if (_activeProfile.getSkills().size() == MAX_SKILLS) {
            _owner.sendMessage("Limit reached!");
            showConfig();
            return;
        }

        _activeProfile.addSkill(skill);
        if (!_activeSkills.contains(skill)) {
            _activeSkills.add(skill);
        }
        _owner.sendMessage("You've added " + skill.getName(_owner));
        showConfig();
    }

    public void removeSkill(int skillId) {
        if (_activeProfile == null) {
            showSettings();
            return;
        }

        _activeProfile.removeSkill(skillId);
        _activeSkills.removeIf(skillEntry -> skillEntry.getId() == skillId);
    }

    public void removeSkill(SkillEntry skill) {
        removeSkill(skill.getId());
        _owner.sendMessage("You've removed " + skill.getName(_owner));
    }

    public void castSkills()
    {
        if (_activeProfile == null)
            restoreLastProfile();

        if ((_activeProfile != null) && (_owner.getTarget() != null) && !((Creature) _owner.getTarget()).isAlikeDead())
        {
            int skillIndex = _lastUsedIndex.get();

            for (int attempt = 0; attempt < _activeSkills.size(); attempt++)
            {
                int adjustedIndex = (skillIndex + attempt) % _activeSkills.size(); // Wrap around to the beginning if needed
                SkillEntry storedSkillEntry = _activeSkills.get(adjustedIndex);
                SkillEntry skillEntry = _owner.getKnownSkill(storedSkillEntry.getId());
                if (skillEntry == null) {
                    _activeSkills.remove(storedSkillEntry);
                    _activeProfile.removeSkill(storedSkillEntry);
                    showConfig();
                    continue; // Skip null entries
                }

                // skill is disabled - skip
                if (_owner.isActionsDisabled() || _owner.isMuted(skillEntry.getTemplate()) || _owner.isSkillDisabled(skillEntry.getTemplate())) {
                    _lastUsedIndex.getAndIncrement();
                    continue;
                }

                boolean isForceAttackEnabled = _enableForceAttack; // Добавлена переменная для контроля включения force атаки
                boolean isForceAttack = isForceAttackEnabled && _owner.getTarget() != null && (_owner.getObjectId() != _owner.getTargetId()) && (_owner.getTarget().isPlayer());
                boolean canCast = skillEntry.checkCondition(_owner, (Creature) _owner.getTarget(), isForceAttack, false, true, false, false);
                if (!canCast) {
                    _lastUsedIndex.getAndIncrement();
                    continue;
                }

                _lastUsedIndex.set(adjustedIndex + 1);
                boolean isAoESkill = skillEntry.getTemplate().getCastRange() == -1 && Skill.SkillTargetType.TARGET_AURA.equals(skillEntry.getTemplate().getTargetType()) && (_owner.getObjectId() != _owner.getTargetId());
                int skillCastRangeWithOffset = skillEntry.getTemplate().getCastRange() + 10;
                if (!_owner.isCastingNow() && (isAoESkill || (skillCastRangeWithOffset >= _owner.getDistance(_owner.getTarget())))) {
                    boolean casted = _owner.doCast(skillEntry, (Creature) _owner.getTarget(), isForceAttack);
                    if (casted) { // if casted successfully - increment index
                        break;
                    }
                } else {
                    if (skillEntry.getTemplate().getCastRange() != -1 && skillCastRangeWithOffset < _owner.getDistance(_owner.getTarget())) {
                        if (_owner.getTarget().isCreature() && !_owner.getMovement().isMoving()) {
                            _owner.getMovement().moveToLocation(_owner.getTarget().getLoc(), 0, true);
                            break;
                        }
                    }
                }
            }

        }
    }

    private void restoreLastProfile() {
        // restore last used profile
        if (!_profiles.isEmpty()) {
            int lastProfileId = _owner.getVarInt("LAST_SKILLER_PROFILE", -1);
            SkillProfile lastProfile = _profiles.get(lastProfileId);
            if (lastProfile != null) {
                _activeProfile = lastProfile;
                _activeSkills.clear();
                _activeSkills.addAll(_activeProfile.getSkills());
            }
        }
    }


    public void showConfig() {

        restoreLastProfile();

        String html = HtmCache.getInstance().getHtml("mods/skiller/index.htm", _owner);
        html = html.replace("%used%", String.valueOf(Objects.isNull(_activeProfile) ? 0 : _activeProfile.getSkills().size()));
        html = html.replace("%total%", String.valueOf(MAX_SKILLS));
        html = html.replace("%profile%", Objects.nonNull(_activeProfile) ? _activeProfile.getName() : "-");
        html = html.replace("%activeSkills%", buildActiveList());
        html = html.replace("%skillList%", buildSkillList());
        if (_owner.isLangRus()) {
            html = html.replace("%forceAttack%",isForceAttackEnabled() ? "Включено" : "Выключено");
        } else {
            html = html.replace("%forceAttack%", isForceAttackEnabled() ? "Enabled" : "Disabled");
        }


        _owner.sendPacket(new HtmlMessage(0).setHtml(html));
    }

    public void showSettings() {
        String html = HtmCache.getInstance().getHtml("mods/skiller/settings.htm", _owner);

        html = html.replace("%available%", buildProfilesAvailability());
        html = html.replace("%profileList%", buildProfileList());
        html = html.replace("%profile%", Objects.nonNull(_activeProfile) ? _activeProfile.getName() : "-");

        _owner.sendPacket(new HtmlMessage(0).setHtml(html));
    }

    private boolean isWhiteListed(SkillEntry entry) {
        return ArrayUtils.contains(Config.SKILLER_WHITELISTED_SKILLS, entry.getId());
    }

    private String buildSkillList() {
        final StringBuilder skillList = new StringBuilder("<table border=0 cellpadding=2 cellspacing=2 width=300 align=center>");
        skillList.append("<tr>");
        int i = 0;
        for (SkillEntry skill : _owner.getAllSkills()) {
            boolean validSkill = isWhiteListed(skill) || (skill.getSkillType().equals(MDAM) && skill.getTemplate().isMagic() && skill.getTemplate().getPower() > 0);
            if (isActive(skill) || !validSkill) {
                continue;
            }
            String iconPath = skill.getTemplate().getIcon();
            skillList.append("<td align=CENTER width=32>");
            if (isActive(skill)) {
                skillList.append("<button value=\" \" action=\"bypass -h user_removeskill ").append(skill.getId()).append("\" back=\"").append(iconPath).append("\" fore=\"").append(iconPath).append("\" width=32 height=32 />");
            } else {
                skillList.append("<button value=\" \" action=\"bypass -h user_addskill ").append(skill.getId()).append("\" back=\"").append(iconPath).append("\" fore=\"").append(iconPath).append("\" width=32 height=32 />");
            }
            skillList.append("</td>");
            i++;

            if (i % 6 == 0) {
                skillList.append("</tr><tr>");
            }
        }

        skillList.append("</tr>");
        return skillList.toString();
    }

    private String buildProfileList() {
        if (_profiles.isEmpty()) {
            return "<table width=300><tr><td width=300 align=CENTER><font color=\"FF0000\">No available profiles</font></td></tr></table>";
        }

        final StringBuilder sb = new StringBuilder();
        int i = 0;
        for (SkillProfile profile : _profiles.values()) {
            i++;
            sb.append("<table border=0 width=300 ");
            if (i % 2 != 0) {
                sb.append("bgcolor=a9a9a9");
            }
            sb.append("><tr>");
            sb.append("<td align=LEFT width=145>").append(i).append(". ").append(profile.getName()).append(" [").append(profile.getSkills().size()).append(" / ").append(MAX_SKILLS).append("]</td>");
            sb.append("<td><a action=\"bypass -h user_editprofiles select ").append(profile.getId()).append("\">Select<a></td>");
            sb.append("<td><a action=\"bypass -h user_editprofiles delete ").append(profile.getId()).append("\">Delete<a></td>");
            sb.append("</tr>");
            sb.append("</table>");
        }


        return sb.toString();
    }

    private String buildProfilesAvailability() {
        int remainingProfiles = 3 - _profiles.size();
        String color = "00FF00";
        if (remainingProfiles == 2) {
            color = "FFA500";
        } else if (remainingProfiles == 1) {
            color = "8b0000";
        } else if (remainingProfiles == 0) {
            color = "FF0000";
        }

        return String.format("<font color=\"%s\">%d / %d</font>", color, remainingProfiles, MAX_PROFILES);
    }

    private String buildActiveList() {
        final StringBuilder activeList = new StringBuilder("<table border=0 cellpadding=0 cellspacing=0 align=left>");
        activeList.append("<tr>");

        if (Objects.isNull(_activeProfile) || _activeProfile.getSkills().isEmpty()) {
            for (int i = 0; i < MAX_SKILLS; i++) {
                activeList.append("<td align=center width=48 height=36><img src=\"icon.immortal_weapon_bg0000\" width=32 height=32 /></td>");
            }
            activeList.append("</tr></table>");
            return activeList.toString();
        }

        for (SkillEntry skill : _activeProfile.getSkills()) {
            String iconPath = skill.getTemplate().getIcon();
            activeList.append("<td align=center width=48 height=32>");
            activeList.append("<button value=\" \" action=\"bypass -h user_removeskill ").append(skill.getId()).append("\" back=\"").append(iconPath).append("\" fore=\"").append(iconPath).append("\" width=32 height=32 />");
            activeList.append("</td>");
        }

        int skillSize = _activeProfile.getSkills().size();
        for (int i = 0; i < (MAX_SKILLS - skillSize); i++) {
            activeList.append("<td align=center width=48 height=36><img src=\"icon.immortal_weapon_bg0000\" width=32 height=32 /></td>");
        }


        activeList.append("</tr></table>");
        return activeList.toString();
    }

    public void createProfile(String name) {
        if (_profiles.size() >= MAX_PROFILES) {
            return;
        }

        SkillProfile newProfile = new SkillProfile(_profiles.size() + 1, name);
        _profiles.put(newProfile.getId(), newProfile);
        _owner.sendMessage("Created: > " + newProfile.getName());

        // store in db
        if (_activeProfile == null) {
            _activeProfile = newProfile;
            _owner.setVar("LAST_SKILLER_PROFILE", newProfile.getId());
        }
    }

    public void deleteProfile(Integer id) {
        SkillProfile remove = _profiles.remove(id);
        if (remove != null) {
            if (_activeProfile.getId() == id) {
                _activeProfile = null;
                _owner.unsetVar("LAST_SKILLER_PROFILE");
                _owner.sendMessage("Deleted: > " + remove.getName());
            }

            _activeSkills.clear();

            // find new available
            if (!_profiles.isEmpty()) {
                for (SkillProfile profile : _profiles.values()) {
                    _activeProfile = profile;
                    _activeSkills.addAll(_activeProfile.getSkills());
                    _owner.setVar("LAST_SKILLER_PROFILE", profile.getId());
                    _owner.sendMessage("Selected: > " + profile.getName());
                }
            }
        }
    }

    public void selectProfile(Integer profileId) {
        SkillProfile skillProfile = _profiles.get(profileId);
        if (skillProfile != null) {
            _activeProfile = skillProfile;
            _activeSkills.clear();
            _activeSkills.addAll(_activeProfile.getSkills());
            _owner.setVar("LAST_SKILLER_PROFILE", profileId);
            _owner.sendMessage("Selected: > " + skillProfile.getName());
        }
    }

    public boolean isEnabled() {
        return _isEnabled;
    }

    public void setEnabled(boolean enabled) {
        restoreLastProfile();
        _isEnabled = enabled;
        if (_skillUseTask != null) {
            _skillUseTask.cancel(false);
            _skillUseTask = null;
        }
        _lastUsedIndex.set(0); // always start from the beginning
        if (enabled) {
            _skillUseTask = ThreadPoolManager.getInstance().scheduleAtFixedRate(this::castSkills, 0L, 30L);
        }
    }

    public boolean isForceAttackEnabled() {
        return _enableForceAttack;
    }

    public void setForceAttackEnabled(boolean enableForceAttack) {
        _enableForceAttack = enableForceAttack;
    }
}
