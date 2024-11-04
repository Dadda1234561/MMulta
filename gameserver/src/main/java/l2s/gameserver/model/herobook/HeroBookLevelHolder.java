package l2s.gameserver.model.herobook;

import l2s.gameserver.model.Skill;
import l2s.gameserver.templates.item.data.ItemData;

import java.util.HashSet;
import java.util.Set;

public class HeroBookLevelHolder
{
    private final int _level;
    private final int _exp;
    private final Set<ItemData> _items;
    private final Set<Skill> _skills;
    private final long _commission;

    public HeroBookLevelHolder(int level, int exp, Set<ItemData> items, Set<Skill> skills, long commission)
    {
        _level = level;
        _exp = exp;
        _items = items == null ? new HashSet<>() : items;
        _skills = skills == null ? new HashSet<>() : skills;
        _commission = commission;
    }

    public HeroBookLevelHolder(int level, int exp, ItemData itemData, Skill skill, long commission, boolean t)
    {
        _level = level;
        _exp = exp;
        _items = new HashSet<>();
        _items.add(itemData);
        _skills = new HashSet<Skill>();
        _skills.add(skill);
        _commission = commission;
    }

    public int getLevel()
    {
        return _level;
    }

    public int getExp()
    {
        return _exp;
    }

    public Set<ItemData> getItems()
    {
        return _items;
    }

    public Set<Skill> getSkills()
    {
        return _skills;
    }

    public long getCommission()
    {
        return _commission;
    }
}
