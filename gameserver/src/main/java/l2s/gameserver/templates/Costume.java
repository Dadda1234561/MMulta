package l2s.gameserver.templates;

import gnu.trove.map.hash.TIntLongHashMap;
import l2s.gameserver.model.Skill;

import java.util.List;

public class Costume {
    private final int id;
    private final int itemId;
    private final Skill skill;

    public int getOriginType() {
        return originType;
    }

    public int getGrade() {
        return grade;
    }

    private final int originType;
    private final int grade;

    public List<TIntLongHashMap> needItems;

    public List<TIntLongHashMap> extractFee;

    public Costume(int id, int itemId, Skill skill, int originType, int grade, List<TIntLongHashMap> needItems, List<TIntLongHashMap> extractFee) {
        this.id = id;
        this.itemId = itemId;
        this.skill = skill;
        this.originType = originType;
        this.grade = grade;
        this.needItems = needItems;
        this.extractFee = extractFee;
    }

    public int getId() {
        return id;
    }

    public int getItemId() {
        return itemId;
    }

    public Skill getSkill() {
        return skill;
    }

    public List<TIntLongHashMap> getNeedItems() {
        return needItems;
    }

    public List<TIntLongHashMap> getExtractFee() {
        return extractFee;
    }
}
