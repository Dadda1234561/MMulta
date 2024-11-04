package l2s.gameserver.templates;

import l2s.gameserver.model.items.ItemInfo;

/**
 * @author Bonux (bonuxq@gmail.com)
 * @date 23.09.2019
 **/
public class ClanShopProduct {
	private final int clanLevel;
	private final int itemId;
	private final long itemCount;
	private final long adena;
	private final int fame;
	private final ItemInfo itemInfo;

	public ClanShopProduct(int clanLevel, int itemId, long itemCount, long adena, int fame) {
		this.clanLevel = clanLevel;
		this.itemId = itemId;
		this.itemCount = itemCount;
		this.adena = adena;
		this.fame = fame;
		itemInfo = new ItemInfo();
		itemInfo.setItemId(itemId);
	}

	public int getClanLevel() {
		return clanLevel;
	}

	public int getItemId() {
		return itemId;
	}

	public long getItemCount() {
		return itemCount;
	}

	public long getAdena() {
		return adena;
	}

	public int getFame() {
		return fame;
	}

	public ItemInfo getItemInfo() {
		return itemInfo;
	}
}
