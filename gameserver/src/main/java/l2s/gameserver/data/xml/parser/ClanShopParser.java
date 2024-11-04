package l2s.gameserver.data.xml.parser;

import l2s.commons.data.xml.AbstractParser;
import l2s.gameserver.Config;
import l2s.gameserver.data.xml.holder.ClanShopHolder;
import l2s.gameserver.templates.ClanShopProduct;
import org.dom4j.Element;

import java.io.File;

/**
 * @author Bonux (bonuxq@gmail.com)
 * @date 23.09.2019
 **/
public class ClanShopParser extends AbstractParser<ClanShopHolder> {
	private static final ClanShopParser INSTANCE = new ClanShopParser();

	public static ClanShopParser getInstance() {
		return INSTANCE;
	}

	protected ClanShopParser() {
		super(ClanShopHolder.getInstance());
	}

	@Override
	public File getXMLPath() {
		return new File(Config.DATAPACK_ROOT, "data/clan_shop.xml");
	}

	@Override
	public String getDTDFileName() {
		return "clan_shop.dtd";
	}

	@Override
	protected void readData(Element rootElement) throws Exception {
		for (Element productElement : rootElement.elements("product")) {
			int clanLevel = parseInt(productElement, "clan_level");
			int itemId = parseInt(productElement, "item_id");
			long itemCount = parseLong(productElement, "item_count");
			long adena = parseLong(productElement, "adena", 0);
			int fame = parseInt(productElement, "fame", 0);
			getHolder().addClanShopProduct(new ClanShopProduct(clanLevel, itemId, itemCount, adena, fame));
		}
	}
}
