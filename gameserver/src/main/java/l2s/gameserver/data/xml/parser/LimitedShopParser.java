package l2s.gameserver.data.xml.parser;

import java.io.File;
import java.util.Iterator;

import org.dom4j.Element;

import l2s.commons.data.xml.AbstractParser;
import l2s.gameserver.Config;
import l2s.gameserver.data.xml.holder.ItemHolder;
import l2s.gameserver.data.xml.holder.LimitedShopHolder;
import l2s.gameserver.model.LimitedShopContainer;
import l2s.gameserver.model.base.LimitedShopEntry;
import l2s.gameserver.model.base.LimitedShopIngredient;
import l2s.gameserver.model.base.LimitedShopProduction;
import l2s.gameserver.templates.StatsSet;
import l2s.gameserver.templates.item.ItemTemplate;
import l2s.gameserver.utils.Language;

/**
 * @author nexvill
 */
public class LimitedShopParser extends AbstractParser<LimitedShopHolder>
{
	private static final LimitedShopParser _instance = new LimitedShopParser();

	public static LimitedShopParser getInstance()
	{
		return _instance;
	}

	protected LimitedShopParser()
	{
		super(LimitedShopHolder.getInstance());
	}

	@Override
	public File getXMLPath()
	{
		return new File(Config.DATAPACK_ROOT, "data/limitedShop");
	}

	@Override
	public String getDTDFileName()
	{
		return "limitedShop.dtd";
	}

	@Override
	protected void readData(Element rootElement) throws Exception
	{
		final int listId = Integer.parseInt(_currentFile.replace(".xml", ""));

		LimitedShopContainer list = new LimitedShopContainer();

		int entryId = 0;
		for (Iterator<Element> iterator = rootElement.elementIterator(); iterator.hasNext();)
		{
			Element element = iterator.next();
			if ("item".equalsIgnoreCase(element.getName()))
			{
				LimitedShopEntry e = parseEntry(element, listId);
				if (e != null)
				{
					e.setEntryId(entryId++);
					list.addEntry(e);
				}
			}
		}
		getHolder().addLimitedShopContainer(listId, list);
	}

	protected LimitedShopEntry parseEntry(Element n, int limitedShopId)
	{
		LimitedShopEntry entry = new LimitedShopEntry();

		StatsSet info = new StatsSet();

		for (Iterator<Element> iterator = n.elementIterator(); iterator.hasNext();)
		{
			info.put("product1Id", parseInt(n, "product1Id"));
			info.put("product1Count", parseLong(n, "product1Count", 1L));
			info.put("product1Chance", parseFloat(n, "product1Chance", 100.0f));
			info.put("product2Id", parseInt(n, "product2Id", 0));
			info.put("product2Count", parseLong(n, "product2Count", 0L));
			info.put("product2Chance", parseFloat(n, "product2Chance", 0.0f));
			info.put("product3Id", parseInt(n, "product3Id", 0));
			info.put("product3Count", parseLong(n, "product3Count", 0L));
			info.put("product3Chance", parseFloat(n, "product3Chance", 0.0f));
			info.put("product4Id", parseInt(n, "product4Id", 0));
			info.put("product4Count", parseLong(n, "product4Count", 0L));
			info.put("product4Chance", parseFloat(n, "product4Chance", 0.0f));
			info.put("product5Id", parseInt(n, "product5Id", 0));
			info.put("product5Count", parseLong(n, "product5Count", 0L));
			info.put("product5Chance", parseFloat(n, "product5Chance", 0.0f));
			info.put("dailyLimit", parseInt(n, "dailyLimit", 0));
			info.put("index", parseLong(n, "index"));

			entry.addProduct(new LimitedShopProduction(info));
			Element d = iterator.next();
			if ("ingredient".equalsIgnoreCase(d.getName()))
			{
				int id = Integer.parseInt(d.attributeValue("id"));
				long count = Long.parseLong(d.attributeValue("count"));
				int enchantLevel = parseInt(d, "enchantLevel", 0);
				entry.addIngredient(new LimitedShopIngredient(id, count, enchantLevel));
			}
		}

		if (entry.getIngredients().isEmpty() || entry.getProduction().isEmpty())
		{
			_log.warn("Limited Shop [" + limitedShopId + "] is empty!");
			return null;
		}

		for (LimitedShopIngredient ingredient : entry.getIngredients())
		{
			if (ingredient.getItemId() == ItemTemplate.ITEM_ID_ADENA && ingredient.getItemCount() == -1)
			{
				long price = 0;
				for (LimitedShopProduction product : entry.getProduction())
				{
					ItemTemplate item = ItemHolder.getInstance()
							.getTemplate(product.getInfo().getInteger("product1Id"));
					if (item == null)
						continue;

					price += item.getReferencePrice();
				}

				if (price <= 0)
					return null;

				ingredient.setItemCount(price);
			}

			if (ingredient.getItemCount() <= 0)
			{
				_log.warn("LimitedShop [" + limitedShopId + "] ingredient ID[" + ingredient.getItemId()
						+ "] has negative item count!");
				return null;
			}
		}

		if (entry.getIngredients().size() == 1 && entry.getProduction().size() == 1
				&& entry.getIngredients().get(0).getItemId() == 57)
		{
			ItemTemplate item = ItemHolder.getInstance().getTemplate(entry.getProduction().get(0).getInfo().getInteger("product1Id"));
			if (item == null)
			{
				_log.warn("LimitedShop [" + limitedShopId + "] Production ["
						+ entry.getProduction().get(0).getInfo().getInteger("product1Id") + "] not found!");
				return null;
			}
		}

		return entry;
	}
}