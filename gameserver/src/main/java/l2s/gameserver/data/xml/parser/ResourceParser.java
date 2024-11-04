package l2s.gameserver.data.xml.parser;

import l2s.commons.data.xml.AbstractParser;
import l2s.gameserver.Config;
import l2s.gameserver.data.xml.holder.ResourceHolder;
import l2s.gameserver.model.ProductionType;
import l2s.gameserver.templates.ResourceTemplate;
import l2s.gameserver.templates.item.data.ItemData;
import org.dom4j.Element;

import java.io.File;
import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;


public class ResourceParser extends AbstractParser<ResourceHolder> {

    protected ResourceParser(ResourceHolder holder) {
        super(holder);
    }

    public static ResourceParser getInstance() {
        return SingletonHolder.INSTANCE;
    }

    @Override
    public File getXMLPath() {
        return new File(Config.DATAPACK_ROOT, "data/resources.xml");
    }

    @Override
    public String getDTDFileName() {
        return "resources.dtd";
    }

    @Override
    protected void readData(Element list) throws Exception {
        for (Iterator<Element> iterator = list.elementIterator("resource"); iterator.hasNext(); ) {
            Element resource = iterator.next();

            int id = Integer.parseInt(resource.attributeValue("id"));
            String name = resource.attributeValue("name");
            int slot = Integer.parseInt(resource.attributeValue("slot"));
            int duration = Integer.parseInt(resource.attributeValue("cook_time"));

            List<ItemData> unlockPrice = parseItemDataList(resource.element("unlock"));
            List<ItemData> ingredientList = parseItemDataList(resource.element("ingredients"));
            Element production = resource.element("production");
            ProductionType productionType = ProductionType.valueOf(production.attributeValue("type", "NORMAL"));
            List<ItemData> rewardList = parseItemDataList(production);

            ResourceHolder.getInstance().addResource(new ResourceTemplate(id, name, slot, duration, productionType, ingredientList, rewardList, unlockPrice));
        }

        _log.info(getClass().getSimpleName() + ": Loaded " + ResourceHolder.getInstance().size() + " resources.");
    }

    private List<ItemData> parseItemDataList(Element itemList) {
        List<ItemData> result = new ArrayList<>();
        if (itemList == null) {
            return result;
        }
        for (Iterator<Element> itemIterator = itemList.elementIterator("item"); itemIterator.hasNext(); ) {
            Element itemElement = itemIterator.next();
            int itemId = Integer.parseInt(itemElement.attributeValue("id"));
            int itemCount = Integer.parseInt(itemElement.attributeValue("count"));
            result.add(new ItemData(itemId, itemCount));
        }
        return result;
    }

    private static class SingletonHolder {
        protected static ResourceParser INSTANCE = new ResourceParser(ResourceHolder.getInstance());
    }
}
