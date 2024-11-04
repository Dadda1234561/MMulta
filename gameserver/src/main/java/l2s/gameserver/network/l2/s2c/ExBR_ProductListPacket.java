package l2s.gameserver.network.l2.s2c;

import java.util.List;

import l2s.gameserver.model.Player;
import l2s.gameserver.templates.item.product.ProductItem;
import l2s.gameserver.templates.item.product.ProductItemComponent;
import l2s.gameserver.utils.ItemFunctions;

/**
 * @author Bonux
**/
public class ExBR_ProductListPacket extends L2GameServerPacket
{
	private final long _adena, _freeCoins;
	private final int _type;
	private final List<ProductItem> _products;

	public ExBR_ProductListPacket(Player player, int type, List<ProductItem> products)
	{
		_adena = player.getAdena();
		_freeCoins = ItemFunctions.getItemCount(player, 23805);
		_products = products;
		_type = type;
	}

	@Override
	protected void writeImpl()
	{
		writeQ(_adena); // Player Adena Count
		writeQ(_freeCoins); // UNK
		writeC(_type); // 0x00 - Home, 0x01 - History, 0x02 - Favorites
		writeD(_products.size());
		for(ProductItem product : _products)
		{
			writeD(product.getId()); //product id
			writeC(product.getCategory()); //category 1 - enchant 2 - supplies  3 - decoration 4 - package 5 - other
			writeC(product.getPointsType().ordinal()); // Points Type: 1 - Points, 2 - Adena, 3 - Hero Coins
			writeD(product.getPoints(true)); //points
			writeC(product.getTabId()); // show tab 2-th group - 1 показывает окошко про итем
			writeD(product.getMainCategory()); // категория главной страницы (маска) (0 - не показывать на главное (дефолт), 1 - верхнее окно, 2 - рекомендуемый товар, 4 - популярные товары)  // Glory Days 488
			writeD((int) (product.getStartTimeSale() / 1000)); // start sale unix date in seconds
			writeD((int) (product.getEndTimeSale() / 1000)); // end sale unix date in seconds
			writeC(127); // day week (127 = not daily goods)
			writeC(product.getStartHour()); // start hour
			writeC(product.getStartMin()); // start min
			writeC(product.getEndHour()); // end hour
			writeC(product.getEndMin()); // end min
			writeD(0x00); // stock
			writeD(-1); // max stock
			writeC(product.getDiscount()); // % скидки
			writeC(0x00); // Level restriction
			writeC(0x00); // UNK
			writeD(0x00); // UNK
			writeD(0x00); // UNK
			writeD(0x00); // Repurchase interval (days)
			writeD(0x00); // Amount (per account)

			writeC(product.getComponents().size()); // Количество итемов в продукте.
			for(ProductItemComponent component : product.getComponents())
			{
				writeD(component.getId()); //item id
				writeD((int) component.getCount()); //quality
				writeD(component.getWeight()); //weight
				writeD(component.isDropable() ? 1 : 0); //0 - dont drop/trade
			}
		}
	}
}