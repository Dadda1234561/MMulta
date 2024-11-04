package l2s.gameserver.network.l2.s2c.pledge;

import l2s.gameserver.data.xml.holder.ClanShopHolder;
import l2s.gameserver.model.Player;
import l2s.gameserver.model.pledge.Clan;
import l2s.gameserver.network.l2.s2c.L2GameServerPacket;
import l2s.gameserver.templates.ClanShopProduct;

import java.util.Collection;

/**
 * @author Bonux (bonuxq@gmail.com)
 * @date 25.09.2019
 **/
public class ExPledgeItemList extends L2GameServerPacket {
	private final int clanLevel;

	public ExPledgeItemList(Player player) {
		Clan clan = player.getClan();
		clanLevel = clan == null ? 0 : clan.getLevel();
	}

	@Override
	protected void writeImpl() {
		Collection<ClanShopProduct> products = ClanShopHolder.getInstance().getClanShopProducts();
		writeH(products.size()); // Product count.
		for (ClanShopProduct product : products) {
			writeItemInfo(product.getItemInfo());
			writeC(clanLevel < product.getClanLevel() ? 0 : 2); // 0 locked, 1 need activation, 2 available
			writeQ(product.getAdena()); // Purchase price: adena
			writeD(product.getFame()); // Purchase price: fame
			writeC(product.getClanLevel()); // Required pledge level
			writeC(0); // Required pledge mastery
			writeQ(0); // Activation price: adena
			writeD(0); // Activation price: reputation
			writeD(0); // Time to deactivation
			writeD(0); // Time to restock
			writeH(0); // Current stock
			writeH(0); // Total stock
		}
	}
}
