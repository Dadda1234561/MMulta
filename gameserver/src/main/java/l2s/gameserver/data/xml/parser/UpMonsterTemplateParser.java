package l2s.gameserver.data.xml.parser;

import l2s.gameserver.data.xml.holder.UpMonsterTemplateHolder;
import l2s.gameserver.model.ChampionTemplate;
import l2s.gameserver.model.reward.RewardList;
import l2s.gameserver.stats.Stats;
import l2s.gameserver.stats.funcs.FuncTemplate;
import l2s.gameserver.templates.StatsSet;
import l2s.gameserver.Config;
import l2s.gameserver.templates.item.data.ChampionAdditionalDropData;
import org.apache.commons.lang3.StringUtils;
import org.dom4j.Attribute;
import org.dom4j.Element;

import java.io.File;
import java.util.Set;
import java.util.concurrent.ConcurrentHashMap;

public class UpMonsterTemplateParser extends StatParser<UpMonsterTemplateHolder> {


    protected UpMonsterTemplateParser(UpMonsterTemplateHolder holder)
    {
        super(holder);
    }

    @Override
    protected Object getTableValue(String name, Number... arg) {
        return null;
    }

    @Override
    public File getXMLPath() {
        return new File(Config.DATAPACK_ROOT, "data/up_monster_stats.xml");
    }

    @Override
    public String getDTDFileName() {
        return "up_monster_stats.dtd";
    }


    @Override
    protected void readData(Element rootElement) throws Exception {
        for (Element championElement : rootElement.elements("up_monster")) {
            int level = parseInt(championElement, "level");
            ChampionTemplate template = new ChampionTemplate(level);
            for (Element funcElement : championElement.elements()) {
                StatsSet funcInfo = new StatsSet();
                funcInfo.set("stat", Stats.valueOfXml(funcElement.attributeValue("stat")));
                String capitalizedFunc = StringUtils.capitalize(funcElement.getName());
                funcInfo.set("function", capitalizedFunc);
                funcInfo.set("order", funcElement.attributeValue("order", capitalizedFunc.equals("Mul") ? "48" : "64"));
                funcInfo.set("value", funcElement.attributeValue("value", "0.0"));
                template.attachFunc(FuncTemplate.makeTemplate(funcInfo));
            }
           getHolder().addTemplate(template);
        }

        Element additionalDrop = rootElement.element("additional_drop");
        if (additionalDrop == null) {
            return;
        }
        for (Element championElement : additionalDrop.elements("up_monster")) {
            int level = parseInt(championElement, "level", -1);
            ChampionTemplate championTemplate = getHolder().getTemplate(level);
            if (championTemplate == null) {
                continue;
            }
            for (Element itemElement : championElement.elements("item")) {
                Set<Integer> npcWhiteList = ConcurrentHashMap.newKeySet();
                int itemId = parseInt(itemElement, "id");
                long minCount = parseLong(itemElement, "min_cnt", 1);
                long maxCount = parseLong(itemElement, "max_cnt", 1);
                double chance = parseDouble(itemElement, "chance", RewardList.MAX_CHANCE);
                int minLevel = parseInt(itemElement, "min_level", 1);
                int maxLevel = parseInt(itemElement, "max_level", 99);
                // if list exists
                Attribute npcList = itemElement.attribute("npc_list");
                if (npcList != null) {
                    // parse npcIds
                    for (String npcIdString : npcList.getValue().split(";")) {
                        npcWhiteList.add(Integer.parseInt(npcIdString));
                    }
                }
                championTemplate.addAdditionalDrop(new ChampionAdditionalDropData(itemId, minCount, maxCount, chance, minLevel, maxLevel, npcWhiteList));
            }
            getHolder().addTemplate(championTemplate);
        }
    }

    public static UpMonsterTemplateParser getInstance() {
        return SingletonHolder.INSTANCE;
    }

    private static class SingletonHolder {
        final protected static UpMonsterTemplateParser INSTANCE = new UpMonsterTemplateParser(UpMonsterTemplateHolder.getInstance());
    }
}
