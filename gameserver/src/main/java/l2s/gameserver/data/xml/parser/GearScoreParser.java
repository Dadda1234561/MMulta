package l2s.gameserver.data.xml.parser;

import l2s.gameserver.data.xml.holder.GearScoreHolder;
import l2s.gameserver.data.xml.holder.ItemHolder;
import l2s.gameserver.data.xml.holder.SkillHolder;
import l2s.gameserver.model.Skill;
import l2s.gameserver.model.items.GearScoreType;
import l2s.gameserver.stats.StatTemplate;
import l2s.gameserver.templates.item.ItemGrade;
import l2s.gameserver.templates.item.ItemTemplate;
import org.dom4j.Element;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.io.File;
import java.util.Iterator;

public class GearScoreParser extends StatParser<GearScoreHolder> {

    private static final Logger LOG = LoggerFactory.getLogger(GearScoreParser.class);

    private static final GearScoreParser _instance = new GearScoreParser();

    protected GearScoreParser() {
        super(GearScoreHolder.getInstance());
    }

    public static GearScoreParser getInstance() {
        return _instance;
    }

    @Override
    public File getXMLPath() {
        return new File("data/combat_power.xml");
    }

    @Override
    public String getDTDFileName() {
        return "combat_power.dtd";
    }

    @Override
    protected void readData(Element rootElement) throws Exception {
        for (Iterator<Element> iterator = rootElement.elementIterator(); iterator.hasNext(); ) {
            Element element = iterator.next();
            switch (element.getName()) {
                case "itemGroup": {
                    ItemGrade grade = parseEnum(element.attribute("grade"), ItemGrade.class, ItemGrade.R110);
                    int baseGearScore = parseInt(element, "baseGearScore", 0);
                    for (ItemTemplate template : ItemHolder.getInstance().getAllTemplates()) {
                        if (template == null || template.getGrade() != grade) {
                            continue;
                        }
                        template.setGearScore(GearScoreType.GS_BASE, 0, baseGearScore);
                        getHolder().addItemId(template.getItemId());
                        info(String.format("[itemGroup] Setting GS(%s) for %s atlvl=%d value=%d", template, GearScoreType.GS_BASE.name(), 0, baseGearScore));
                        parseModifiers(element, template);
                        for (Iterator<Element> childIterator = element.elementIterator(); childIterator.hasNext(); ) {
                            Element child = childIterator.next();
                            if (child != null) {
                                parseModifiers(child, template);
                            }
                        }
                    }
                    break;
                }
                case "item": {
                    int itemId = parseInt(element, "id", 0);
                    int baseGearScore = parseInt(element, "baseGearScore", 0);

                    if (itemId == 0) {
                        LOG.warn("Error while parsing combat power data. ItemID={}", itemId);
                        continue;
                    }

                    ItemTemplate template = ItemHolder.getInstance().getTemplate(itemId);
                    if (template == null) {
                        LOG.warn("Error while parsing combat power data. ItemTemplate ID={} is not found!", itemId);
                        continue;
                    }
                    template.setGearScore(GearScoreType.GS_BASE, 0, baseGearScore);
                    /*info(String.format("[item] Setting GS(%s) for %s atlvl=%d value=%d", template.toString(), GearScoreType.GS_BASE.name(), 0, baseGearScore))*/;
                    parseModifiers(element, template);
                    for (Iterator<Element> childIterator = element.elementIterator(); childIterator.hasNext(); ) {
                        Element child = childIterator.next();
                        if (child != null) {
                            parseModifiers(child, template);
                        }
                    }
                    getHolder().addItemId(template.getItemId());
                    break;
                }
                case "skill": {
                    int skillId = parseInt(element, "id", 0);
                    int level = parseInt(element, "level", 0);
                    if (skillId == 0) {
                        LOG.warn("Error while parsing combat power data. SkillID={}", skillId);
                        continue;
                    }

                    Skill template = SkillHolder.getInstance().getSkill(skillId, level);
                    if (template == null) {
                        LOG.warn("Error while parsing combat power data. SkillTemplate ID={} is not found!", skillId);
                        continue;
                    }
                    parseModifiers(element, template);
                    for (Iterator<Element> childIterator = element.elementIterator(); childIterator.hasNext(); ) {
                        Element child = childIterator.next();
                        if (child != null) {
                            parseModifiers(child, template);
                        }
                    }
                    getHolder().addSkillId(template.getId());
                    break;
                }
            }
        }
    }

    private void parseModifiers(Element child, StatTemplate item) {
        switch (child.getName()) {
            case "enchantModifier": {
                parseEnchant(child, item);
                break;
            }
            case "variationModifier": {
                parseVariation(child, item);
                break;
            }
            case "ensoulModifier": {
                parseEnsoul(child, item);
                break;
            }
            case "skillModifier": {
                parseSkill(child, item);
                break;
            }
        }
    }

    private void parseSkill(Element child, StatTemplate item) {
        for (Iterator<Element> elementIterator = child.elementIterator("skill"); elementIterator.hasNext(); ) {
            Element element = elementIterator.next();
            if (element != null) {
                GearScoreType type = parseEnum(element.attribute("type"), GearScoreType.class, GearScoreType.GS_HAS_SKILL);
                int skillLevel = parseInt(element, "level", 0);
                int fromLevel = parseInt(element, "fromLevel", 0);
                int toLevel = parseInt(element, "toLevel", 0);
                int value = parseInt(element, "value", 0);

                for (int currentEnchantLvl = fromLevel; currentEnchantLvl <= toLevel; currentEnchantLvl++) {
                    item.setGearScore(type, currentEnchantLvl, value);
                    //info("Setting GS(%s) for %s atlvl=%d value=%d".formatted("parseSkill", type.name(), currentEnchantLvl, value));
                }

                // override if already exists
                if (skillLevel > 0 && fromLevel != 0) {
                    item.setGearScore(type, skillLevel, value);
                    //info("Setting GS(%s) for %s atlvl=%d value=%d".formatted("parseSkill", type.name(), skillLevel, value));
                }
            }
        }
    }

    private void parseEnsoul(Element child, StatTemplate item) {
        for (Iterator<Element> elementIterator = child.elementIterator("ensoul"); elementIterator.hasNext(); ) {
            Element element = elementIterator.next();
            if (element != null) {
                GearScoreType type = parseEnum(child.attribute("type"), GearScoreType.class, GearScoreType.GS_NONE);
                int optionId = parseInt(element, "optionId", 0);
                int value = parseInt(element, "value", 0);
                switch (type) {
                    case GS_ANY_ENSOUL:
                    case GS_ANY_ENSOUL_BY_OPTION_ID:
                    {
                        item.setGearScore(type, optionId, value);
                        break;
                    }
                    default:
                        warn("GearScoreType = " + type + " is NOT HANDLED!");
                        break;
                }
            }
        }
    }

    private void parseVariation(Element child, StatTemplate item) {
        for (Iterator<Element> elementIterator = child.elementIterator("variation"); elementIterator.hasNext(); ) {
            Element element = elementIterator.next();
            if (element != null) {
                int mineralId = parseInt(element, "mineralId", 0);
                int optionId = parseInt(element, "optionId", 0);

                int value = parseInt(element, "value", 0);

                if (mineralId > 0) {
                    item.setGearScore(GearScoreType.GS_VARIATION_BY_MINERAL_ID, mineralId, value);
                    //info("Setting GS(%s) for %s mineralId=%d value=%d".formatted("parseVariation", GearScoreType.GS_VARIATION_BY_MINERAL_ID.name(), mineralId, value));
                } else if (optionId > 0) {
                    item.setGearScore(GearScoreType.GS_VARIATION_BY_OPTION_ID, optionId, value);
                    //info("Setting GS(%s) for %s optionId=%d value=%d".formatted("parseVariation", GearScoreType.GS_VARIATION_BY_OPTION_ID.name(), optionId, value));
                }
            }
        }
    }

    private void parseEnchant(Element child, StatTemplate item) {
        for (Iterator<Element> elementIterator = child.elementIterator("enchant"); elementIterator.hasNext(); ) {
            Element element = elementIterator.next();
            if (element != null) {
                GearScoreType type = parseEnum(element.attribute("type"), GearScoreType.class, GearScoreType.GS_NONE);
                int fromLevel = parseInt(element, "fromLevel", 0);
                int toLevel = parseInt(element, "toLevel", 0);
                int value = parseInt(element, "value", 0);
                int level = parseInt(element, "level", -1);

                int lastLevel = 0;
                for (int currEnchantLvl = fromLevel; currEnchantLvl <= toLevel; currEnchantLvl++) {
                    lastLevel = Math.max(fromLevel, currEnchantLvl - 1);
                    int lastLvlGearScore = item.getGearScore(lastLevel);
                    item.setGearScore(type, currEnchantLvl, (lastLvlGearScore + value));
                    //info("Setting GS(%s) for %s atlvl=%d value=%d".formatted("parseEnchant", type.name(), currEnchantLvl, (lastLvlGearScore + value)));
                }
                if (GearScoreType.GS_BLESS.equals(type)) {
                    item.setGearScore(GearScoreType.GS_BLESS, 0, value);
                    //info("Setting GS(%s) for %s atlvl=%d value=%d".formatted("parseEnchant", GearScoreType.GS_BLESS, 0, value));
                }
                // default 'level' values
                if (level > 0) {
                    item.setGearScore(GearScoreType.GS_NORMAL, level, value);
                    //info("Setting GS(%s) for %s atlvl=%d value=%d".formatted("parseEnchant", type.name(), level, value));
                }
            }
        }
    }

    @Override
    public void load() {
        super.load();
    }

    @Override
    protected Object getTableValue(String name, Number... arg) {
        return null;
    }
}
