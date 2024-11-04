package l2s.gameserver.data.xml.holder;

import l2s.commons.data.xml.AbstractHolder;
import l2s.gameserver.templates.ClanShopProduct;

import java.util.Collection;
import java.util.HashMap;
import java.util.Map;

/**
 * @author Bonux (bonuxq@gmail.com)
 * @date 23.09.2019
 **/
public class ClanShopHolder extends AbstractHolder {
	private static final ClanShopHolder INSTANCE = new ClanShopHolder();

	public static ClanShopHolder getInstance() {
		return INSTANCE;
	}

	private final Map<Integer, ClanShopProduct> clanShopProductsMap = new HashMap<>();

	public void addClanShopProduct(ClanShopProduct clanShop) {
		clanShopProductsMap.put(clanShop.getItemId(), clanShop);
	}

	public ClanShopProduct getClanShopProduct(int itemId) {
		return clanShopProductsMap.get(itemId);
	}

	public Collection<ClanShopProduct> getClanShopProducts() {
		return clanShopProductsMap.values();
	}

	@Override
	public int size() {
		return clanShopProductsMap.size();
	}

	@Override
	public void clear() {
		clanShopProductsMap.clear();
	}
}
