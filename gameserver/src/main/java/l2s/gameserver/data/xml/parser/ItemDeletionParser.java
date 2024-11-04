package l2s.gameserver.data.xml.parser;

import l2s.commons.data.xml.AbstractParser;
import l2s.gameserver.Config;
import l2s.gameserver.data.xml.holder.ItemDeletionHolder;
import org.dom4j.Element;

import java.io.File;
import java.util.Iterator;

/**
 * @author nexvill
 **/
public class ItemDeletionParser extends AbstractParser<ItemDeletionHolder>
{
	private static ItemDeletionParser _instance = new ItemDeletionParser();

	public static ItemDeletionParser getInstance()
	{
		return _instance;
	}

	private ItemDeletionParser()
	{
		super(ItemDeletionHolder.getInstance());
	}

	@Override
	public File getXMLPath()
	{
		return new File(Config.DATAPACK_ROOT, "data/item_deletion_data.xml");
	}

	@Override
	public String getDTDFileName()
	{
		return "item_deletion_data.dtd";
	}

	@Override
	protected void readData(Element rootElement) throws Exception
	{
		for (Iterator<Element> iterator = rootElement.elementIterator("item"); iterator.hasNext(); )
		{
			Element element = iterator.next();

			int itemId = parseInt(element, "id");
			String date = parseString(element, "date");

			getHolder().addItemDeletionInfo(itemId, date);
		}
	}
}
