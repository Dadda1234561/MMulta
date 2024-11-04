package l2s.gameserver.model;

import com.google.gson.internal.LinkedTreeMap;
import l2s.gameserver.skills.SkillEntry;

import java.util.Collection;

public class SkillProfile {
    private final int _id;
    private final String _name;
    private final LinkedTreeMap<Integer, SkillEntry> _skills =  new LinkedTreeMap<>();

    public SkillProfile(int id, String name) {
        this._id = id;
        this._name = name;
    }

    public int getId() {
        return _id;
    }

    public String getName() {
        return _name;
    }

    public Collection<SkillEntry> getSkills() {
        return _skills.values();
    }

    public void addSkill(SkillEntry skill) {
        _skills.put(skill.getId(), skill);
    }

    public void removeSkill(SkillEntry skill) {
        removeSkill(skill.getId());
    }

    public void removeSkill(int skillId) {
        _skills.remove(skillId);
    }
}
