package l2s.gameserver.network.l2.c2s.worldexchange;

import l2s.gameserver.Config;
import l2s.gameserver.dao.WorldExchangeManager;
import l2s.gameserver.model.Player;
import l2s.gameserver.network.l2.c2s.L2GameClientPacket;
import l2s.gameserver.templates.item.ItemTemplate;

public class ExWorldExchangeRegisterItem extends L2GameClientPacket
{
	private long _price;
	private int _itemID;
	private long _amount;
	private int _currency;

	@Override
	public boolean readImpl()
	{
		_price = readQ();
		_itemID = readD();
		_amount = readQ();
		_currency = WorldExchangeManager.EXTENDED_WORLD_TRADE ? readD() : ItemTemplate.ITEM_ID_MONEY_L;
		return true;
	}
	@Override
	public void runImpl()
	{
		if (!Config.ENABLE_WORLD_EXCHANGE)
		{
			return;
		}
		Player player = getClient().getActiveChar();
		if (player != null)
		{
			WorldExchangeManager.getInstance().registerBidItem(player, _itemID, _amount, _price, _currency);
		}
	}
}
