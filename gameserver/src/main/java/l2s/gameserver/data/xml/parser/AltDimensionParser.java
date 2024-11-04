package l2s.gameserver.data.xml.parser;

import l2s.commons.data.xml.AbstractParser;
import l2s.gameserver.Config;
import l2s.gameserver.data.xml.holder.AltDimensionHolder;
import l2s.gameserver.geometry.ILocation;
import l2s.gameserver.geometry.Location;
import l2s.gameserver.model.entity.AltDimension;
import org.dom4j.Element;

import java.io.File;
import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;

public class AltDimensionParser extends AbstractParser<AltDimensionHolder> {
    protected AltDimensionParser() {
        super(AltDimensionHolder.getInstance());
    }

    @Override
    public File getXMLPath() {
        return new File(Config.DATAPACK_ROOT, "data/alt_dimension.xml");
    }

    @Override
    public String getDTDFileName() {
        return "alt_dimension.dtd";
    }

    @Override
    protected void readData(Element rootElement) throws Exception {
        for (Iterator<Element> iterator = rootElement.elementIterator(); iterator.hasNext(); ) {
            Element element = iterator.next();
            List<String> description = new ArrayList<>();
            List<ILocation> locations = new ArrayList<>();
            final int locationId = Integer.parseInt(element.attributeValue("id"));
            final int rebirths = Integer.parseInt(element.attributeValue("rebirths"));
            final boolean need4Prof = Boolean.getBoolean(element.attributeValue("need4Prof"));
            final String name = element.attributeValue("name");
            for (Iterator<Element> childIterator = element.elementIterator(); childIterator.hasNext();) {
                Element childElement = childIterator.next();
                switch (childElement.getName()) {
                    case "description": {
                        for (Iterator<Element> descIter = childElement.elementIterator(); descIter.hasNext();) {
                            Element desc = descIter.next();
                            description.add(desc.getStringValue());
                        }
                        break;
                    }
                    case "coordinates": {
                        for (Iterator<Element> locIterator = childElement.elementIterator(); locIterator.hasNext();) {
                            Element loc = locIterator.next();
                            int x = parseInt(loc, "x", 0);
                            int y = parseInt(loc, "y", 0);
                            int z = parseInt(loc, "z", 0);

                            locations.add(new Location(x, y, z));
                        }
                        break;
                    }
                }
            }

            getHolder().addDimension(locationId, new AltDimension(locationId, rebirths, need4Prof, name, locations, description));
        }
    }

    public static AltDimensionParser getInstance() {
        return SingletonHolder.INSTANCE;
    }

    private static class SingletonHolder {
        protected static final AltDimensionParser INSTANCE = new AltDimensionParser();
    }


}
