package l2s.gameserver.data.xml.holder;

import l2s.commons.data.xml.AbstractHolder;
import l2s.gameserver.data.xml.parser.GearScoreParser;
import l2s.gameserver.model.Skill;
import l2s.gameserver.templates.item.ItemTemplate;

import java.util.HashSet;
import java.util.Set;
import java.util.logging.Logger;


public class GearScoreHolder extends AbstractHolder {
    private static final Logger LOG = Logger.getLogger(GearScoreHolder.class.getName());
    private final Set<Integer> _itemIds = new HashSet<>();
    private final Set<Integer> _skillIds = new HashSet<>();

    private static GearScoreHolder INSTANCE = new GearScoreHolder();

    public static GearScoreHolder getInstance() {
        if (INSTANCE == null) {
            INSTANCE = new GearScoreHolder();
        }
        return INSTANCE;
    }

    @Override
    public int size() {
        return _itemIds.size() + _skillIds.size();
    }

    @Override
    public void clear() {
        /*LOG.info("%s: clear %d items and skills.".formatted(getClass().getSimpleName(), size()))*/;
        for (Integer itemId : _itemIds) {
            ItemTemplate template = ItemHolder.getInstance().getTemplate(itemId);
            if (template != null) {
                template.resetGearScore();
            }
        }

        for (Integer skillId : _skillIds) {
            Skill skill = SkillHolder.getInstance().getSkill(skillId);
            if (skill != null) {
                skill.resetGearScore();
            }
        }

        _itemIds.clear();
        _skillIds.clear();

        /*LOG.info("%s: clear %d items and skills finished.".formatted(getClass().getSimpleName(), size()))*/;
    }

    public void reload() {
        clear();
        GearScoreParser.getInstance().load();
    }

    public void addItemId(int itemId) {
        _itemIds.add(itemId);
    }

    public void addSkillId(int skillId) {
        _skillIds.add(skillId);
    }
}
