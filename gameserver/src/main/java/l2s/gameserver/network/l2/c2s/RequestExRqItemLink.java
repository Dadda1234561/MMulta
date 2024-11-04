package l2s.gameserver.network.l2.c2s;

import l2s.gameserver.cache.ItemInfoCache;
import l2s.gameserver.model.Player;
import l2s.gameserver.model.items.ItemInfo;
import l2s.gameserver.network.l2.s2c.ActionFailPacket;
import l2s.gameserver.network.l2.s2c.ExRpItemLink;
import l2s.gameserver.tables.GmListTable;

public class RequestExRqItemLink extends L2GameClientPacket
{
	private int _objectId;

	@Override
	protected boolean readImpl()
	{
		_objectId = readD();
		return true;
	}

	@Override
	protected void runImpl()
	{
		ItemInfo item;
		if((item = ItemInfoCache.getInstance().get(_objectId)) == null)
			sendPacket(ActionFailPacket.STATIC);
		else {
			Player activeChar = getClient().getActiveChar();
			if (activeChar != null && activeChar.getPlayerAccess().IsGM) {
				activeChar.sendMessage("ItemID=" + item.getItemId());
			}
			sendPacket(new ExRpItemLink(item));
		}
	}
}