package l2s.gameserver.network.l2.s2c;

import l2s.gameserver.model.items.CommissionItem;

/**
 * @author Bonux
 */
public class ExResponseCommissionBuyInfo extends L2GameServerPacket
{
	private final CommissionItem _item;

	public ExResponseCommissionBuyInfo(CommissionItem item)
	{
		_item = item;
	}

	protected void writeImpl()
	{
		if(_item != null)
		{
			writeD(0x01); // Auction Exists
			writeQ(_item.getCommissionPrice()); //price
			writeQ(_item.getCommissionId()); //bid id
			writeD(_item.getItem().getExType().ordinal()); //unk
			writeItemInfo(_item);
		}
		else
			writeD(0x00); // Auction Exists
	}
}
