package l2s.gameserver.data.xml.parser;

import gnu.trove.map.hash.TIntLongHashMap;
import l2s.commons.data.xml.AbstractParser;
import l2s.gameserver.Config;
import l2s.gameserver.data.xml.holder.CostumeHolder;
import l2s.gameserver.data.xml.holder.SkillHolder;
import l2s.gameserver.model.Skill;
import l2s.gameserver.templates.Costume;
import org.dom4j.Element;

import java.io.File;
import java.util.ArrayList;
import java.util.List;

public class CostumeParser extends AbstractParser<CostumeHolder> {

    private static final CostumeParser INSTANCE = new CostumeParser();

    protected CostumeParser() {
        super(CostumeHolder.getInstance());
    }

    public static CostumeParser getInstance() {
        return INSTANCE;
    }

    @Override
    public File getXMLPath() {
        return new File(Config.DATAPACK_ROOT, "data/costumes.xml");
    }

    @Override
    public String getDTDFileName() {
        return "costumes.dtd";
    }

    @Override
    protected void readData(Element rootElement) throws Exception {
        for (Element costumeElement : rootElement.elements("costume")) {
            int id = parseInt(costumeElement, "id");
            int visualItemId = parseInt(costumeElement, "visual_item_id");
            String[] costumeSkill = parseString(costumeElement, "costume_skill", "").split(";");
            int skillId = costumeSkill.length == 0 ? 0 : Integer.parseInt(costumeSkill[0]);
            int skillLvl = costumeSkill.length == 0 ? 0 : Integer.parseInt(costumeSkill[1]);

            Skill skill = SkillHolder.getInstance().getSkill(skillId, skillLvl);

            int originType = parseInt(costumeElement, "origin_type", 0);
            int grade = parseInt(costumeElement, "grade", 0);

            List<TIntLongHashMap> needItems = new ArrayList<>();
            List<TIntLongHashMap> extractFeeItems = new ArrayList<>();

            for (Element needItemEl : costumeElement.elements("need_item")) {
                TIntLongHashMap itemMap = new TIntLongHashMap();
                for (Element itemElement : needItemEl.elements("item")) {
                    int item = parseInt(itemElement, "id", 57);
                    int count = parseInt(itemElement, "count", 1);
                    itemMap.put(item, count);
                }
                needItems.add(itemMap);
            }

            for (Element extractFee : costumeElement.elements("extract_fee")) {
                TIntLongHashMap itemMap = new TIntLongHashMap();
                for (Element exItem : extractFee.elements("item")) {
                    int item = parseInt(exItem, "id", 57);
                    int count = parseInt(exItem, "count", 1);
                    itemMap.put(item, count);
                }
                extractFeeItems.add(itemMap);
            }

            getHolder().addCostume(new Costume(id, visualItemId, skill, originType, grade, needItems, extractFeeItems));
        }
    }
}
