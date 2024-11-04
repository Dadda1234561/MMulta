package l2s.gameserver.model.actor.instances.player;

import com.google.gson.internal.LinkedHashTreeMap;
import l2s.gameserver.ThreadPoolManager;
import l2s.gameserver.data.htm.HtmCache;
import l2s.gameserver.database.DatabaseFactory;
import l2s.gameserver.model.Player;
import l2s.gameserver.network.l2.components.HtmlMessage;
import l2s.gameserver.skills.SkillEntry;
import l2s.gameserver.skills.SkillEntryType;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Map;
import java.util.concurrent.ScheduledFuture;
import java.util.concurrent.atomic.AtomicInteger;

public class Healer {
    private static final int[] AVAILABLE_SKILLS = new int[] {
            833, 834, 20006, 1561, 121, 1553, 181, 1258, 1311, 1506
    };

    private final AtomicInteger _lastUsedIndex = new AtomicInteger(0);
    private final LinkedHashTreeMap<Integer, SkillEntry> _activeSkills = new LinkedHashTreeMap<>();
    private final LinkedHashTreeMap<Integer, Integer> _healPercents = new LinkedHashTreeMap<>();
    private final Player _owner;
    private boolean _isEnabled;
    private ScheduledFuture<?> _skillUseTask;

    public Healer(Player owner) {
        _owner = owner;
        restore();
    }

    public void store() {
        setEnabled(false);

        if (_healPercents.isEmpty()) {
            return;
        }

        try (Connection con = DatabaseFactory.getInstance().getConnection()) {
            PreparedStatement stm = con.prepareStatement("REPLACE INTO character_healer_skills(`char_id`, `skill_id`, `skill_lvl` , `skill_percent`) VALUES (?, ?, ?, ?)");
            for (Map.Entry<Integer, SkillEntry> entry : _activeSkills.entrySet()) {
                stm.setInt(1, _owner.getObjectId());
                stm.setInt(2, entry.getKey());
                stm.setInt(3, entry.getValue().getLevel());
                stm.setInt(4, getHealPercent(entry.getKey()));
                stm.addBatch();
            }
            stm.executeBatch();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    public void restore() {
        try (Connection con = DatabaseFactory.getInstance().getConnection()) {
            PreparedStatement stm = con.prepareStatement("SELECT * FROM character_healer_skills WHERE char_id = ?");
            stm.setInt(1, _owner.getObjectId());

            // if have any
            try (ResultSet rset = stm.executeQuery()) {
                while (rset.next()) {
                    int skillId = rset.getInt("skill_id");
                    int skillLvl = rset.getInt("skill_lvl");
                    int skillPercent = rset.getInt("skill_percent");
                    _healPercents.put(skillId, skillPercent);
                    _activeSkills.putIfAbsent(skillId, SkillEntry.makeSkillEntry(SkillEntryType.NONE, skillId, skillLvl));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    public void showConfig() {

        String html = HtmCache.getInstance().getHtml("mods/skiller/heal/index.htm", _owner);
        html = html.replace("%used%", String.valueOf(_activeSkills.size()));
        html = html.replace("%total%", String.valueOf(AVAILABLE_SKILLS.length));
        html = html.replace("%activeSkills%", buildActiveList());
        html = html.replace("%skillList%", buildSkillList());
        html = html.replace("%status%", _isEnabled ? "<font color=\"00FF00\">Enabled</font>" : "<font color=\"FF0000\">Disabled</font>");
        _owner.sendPacket(new HtmlMessage(0).setHtml(html));
    }

    private String buildActiveSettings() {
        final StringBuilder sb = new StringBuilder("<table border=0 cellpadding=1 cellspacing=2 align=left>");

        for (SkillEntry skill : _activeSkills.values()) {
            sb.append("<tr>");
                sb.append("<td height=\"48\" align=\"LEFT\">").append("<table><tr><td>").append(getIcon(skill)).append("</td></tr></table>").append("</td>");
                sb.append("<td width=10></td>");
                sb.append("<td width=135>");
                    sb.append("<table border=0 cellpadding=0 cellspacing=0>");
                        sb.append("<tr>");
                            sb.append("<td valign=\"top\">").append(buildSkillName(skill)).append("</td>");
                        sb.append("</tr>");
                        sb.append("<tr>");
                            sb.append("<td>").append(buildEditVar(skill)).append("</td>");
                        sb.append("</tr>");
                    sb.append("</table>");
                sb.append("</td>");
                sb.append("<td width=50 valign=BOT align=LEFT>").append("<table><tr><td>").append(buildSetButton(skill)).append("</td></tr></table>").append("</td>");
                sb.append("<td width=35 align=LEFT valign=TOP>").append(getSkillPercent(skill)).append("</td>");
            sb.append("</tr>");
        }
        sb.append("</table>");

        return sb.toString();
    }

    private String buildSetButton(SkillEntry skill) {
        return String.format("<button value=\"Set\" action=\"bypass -h user_healersetpercent %d $percent_%d\" back=\"L2UI_ct1.button_df_down\" fore=\"L2UI_ct1.button_df\" width=50 height=28>", skill.getId(), skill.getId());
    }

    private String buildSkillName(SkillEntry skill) {
        return String.format("<font color=\"\">%s</font>", skill.getName(_owner));
    }

    private String buildEditVar(SkillEntry entry) {
        return String.format("<edit var=\"percent_%d\"type=\"number\" length=3 width=85 height=10 />", entry.getId());
    }

    private String getSkillPercent(SkillEntry entry) {
        int healPercent = getHealPercent(entry.getId());
        String color = healPercent == 0 ? "FF0000" : "LEVEL";
        return String.format("<font name=\"HtmlBody_nonshadow\" color=\"%s\">%d%%</font>", color, healPercent);
    }

    private String getIcon(SkillEntry skill) {
        return String.format("<img src=\"%s\" width=\"32\" height=\"32\" />", skill.getTemplate().getIcon());
    }

    private String buildActiveList() {
        final StringBuilder activeList = new StringBuilder("<table border=0 cellpadding=0 cellspacing=0 align=left>");
        activeList.append("<tr>");

        if (_activeSkills.isEmpty()) {
            for (int i = 0; i < AVAILABLE_SKILLS.length; i++) {
                activeList.append("<td align=center width=48 height=36><img src=\"L2UI.Squaregray\" width=32 height=32 /></td>");
            }
            activeList.append("</tr></table>");
            return activeList.toString();
        }

        for (SkillEntry skill : _activeSkills.values()) {
            String iconPath = skill.getTemplate().getIcon();
            activeList.append("<td align=center width=48 height=32>");
            activeList.append("<button value=\" \" action=\"bypass -h user_removehealerskill ").append(skill.getId()).append("\" back=\"").append(iconPath).append("\" fore=\"").append(iconPath).append("\" width=32 height=32 />");
            activeList.append("</td>");
        }

        int skillSize = _activeSkills.values().size();
        for (int i = 0; i < (AVAILABLE_SKILLS.length - skillSize); i++) {
            activeList.append("<td align=center width=48 height=36><img src=\"L2UI.Squaregray\" width=32 height=32 /></td>");
        }


        activeList.append("</tr></table>");
        return activeList.toString();
    }

    private boolean isActive(SkillEntry skill) {
        return _activeSkills.containsKey(skill.getId());
    }

    private String buildSkillList() {

        final StringBuilder skillList = new StringBuilder("<table border=0 cellpadding=2 cellspacing=2 width=300 align=center>");
        skillList.append("<tr>");
        int i = 0;
        if (_activeSkills.size() == AVAILABLE_SKILLS.length) {
            skillList.append("<td width=300 align=CENTER><font color=\"a9a9a9\">All skills added...</font></td></tr>");
            return skillList.toString();
        }
        for (int skillId : AVAILABLE_SKILLS) {
            SkillEntry skill = _owner.getKnownSkill(skillId);
            if (skill == null || isActive(skill)) {
                continue;
            }
            String iconPath = skill.getTemplate().getIcon();
            skillList.append("<td align=CENTER width=32>");
            if (isActive(skill)) {
                skillList.append("<button value=\" \" action=\"bypass -h user_removehealerskill ").append(skill.getId()).append("\" back=\"").append(iconPath).append("\" fore=\"").append(iconPath).append("\" width=32 height=32 />");
            } else {
                skillList.append("<button value=\" \" action=\"bypass -h user_addhealerskill ").append(skill.getId()).append("\" back=\"").append(iconPath).append("\" fore=\"").append(iconPath).append("\" width=32 height=32 />");
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

    public void showSettings() {
        String html = HtmCache.getInstance().getHtml("mods/skiller/heal/settings.htm", _owner);
        html = html.replace("%used%", String.valueOf(_activeSkills.size()));
        html = html.replace("%total%", String.valueOf(AVAILABLE_SKILLS.length));
        html = html.replace("%activeSkills%", buildActiveSettings());
        html = html.replace("%status%", _isEnabled ? "<font color=\"00FF00\">Enabled</font>" : "<font color=\"FF0000\">Disabled</font>");
        _owner.sendPacket(new HtmlMessage(0).setHtml(html));
    }

    public void addSkill(SkillEntry skill) {
        if (_activeSkills.size() == AVAILABLE_SKILLS.length) {
            _owner.sendMessage("Limit reached!");
            showConfig();
            return;
        }

        _activeSkills.put(skill.getId(), skill);
        _owner.sendMessage("You've added " + skill.getName(_owner));
        showConfig();
    }

    public void removeSkill(SkillEntry skill) {
        if (_activeSkills.isEmpty()) {
            return;
        }

        _activeSkills.remove(skill.getId());
        _owner.sendMessage("You've removed " + skill.getName(_owner));
    }

    public void setEnabled(boolean enable) {
        _isEnabled = enable;

        if (_skillUseTask != null) {
            _skillUseTask.cancel(false);
            _skillUseTask = null;
        }

        _lastUsedIndex.set(0);

        if (enable) {
            _skillUseTask = ThreadPoolManager.getInstance().scheduleAtFixedRate(this::castSkill, 0,100L);
        }

    }

    private void castSkill() {

        // is full hp
        if (_owner.getCurrentHpPercents() == 100) {
            return;
        }

        int skillIndex = _lastUsedIndex.get();
        int attempt = 1;
        for (Map.Entry<Integer, SkillEntry> entry : _activeSkills.entrySet()) {
            int adjustedIndex = (skillIndex + attempt) % _activeSkills.size(); // Wrap around to the beginning if needed

            if (entry.getValue() == null) {
                continue;
            }

            // skip if skill is disabled by percent
            int healPercent = getHealPercent(entry.getKey());
            if (healPercent <= 0) {
                continue;
            }

            // skip if skill does not exist anymore
            SkillEntry skill = _owner.getKnownSkill(entry.getKey());
            if (skill == null) {
                continue;
            }

            // skip if skill is disabled
            if (_owner.isActionsDisabled() || _owner.isMuted(entry.getValue().getTemplate()) || _owner.isSkillDisabled(entry.getValue().getTemplate())) {
                _lastUsedIndex.getAndIncrement();
                continue;
            }

            _lastUsedIndex.set(adjustedIndex + 1);

            // if curr hp percent is lower then set in skill
            if (_owner.getCurrentHpPercents() < healPercent) {
                boolean canCast = skill.checkCondition(_owner, _owner, true, false, true, false, false);
                if (!canCast) {
                    _lastUsedIndex.getAndIncrement();
                    continue;
                }

                if (!_owner.isCastingNow() && _owner.doCast(skill, _owner, true)) {
                    break;
                }
            }
        }
    }

    public boolean isEnabled() {
        return _isEnabled;
    }

    public void setPercent(SkillEntry knownSkill, int percent) {
        _healPercents.put(knownSkill.getId(), percent);
        _owner.sendMessage(String.format("%s: > %d%%", knownSkill.getName(_owner), percent));
    }

    public int getHealPercent(int skillId) {
        return _healPercents.getOrDefault(skillId, 0);
    }
}
