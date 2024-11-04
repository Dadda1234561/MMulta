package l2s.gameserver.network.l2.s2c;

import java.time.LocalDateTime;
import java.time.ZoneId;
import java.time.format.DateTimeFormatter;
import java.util.HashMap;
import java.util.Map;

import l2s.gameserver.data.xml.holder.ItemDeletionHolder;

/**
 * @author nexvill
 */
public class ExItemDeletionInfo extends L2GameServerPacket
{
	private Map<Integer, String> _items = new HashMap<>();

	public ExItemDeletionInfo()
	{
		_items = ItemDeletionHolder.getInstance().getItems();
	}


	@Override
	protected final void writeImpl()
	{
		if (_items.size() > 0)
		{
			writeD(_items.size());
			for (int itemId : _items.keySet())
			{
				LocalDateTime localDateTime = LocalDateTime.parse(_items.get(itemId), DateTimeFormatter.ofPattern("yyyy/MM/dd HH:mm:ss"));
				long millis = localDateTime.atZone(ZoneId.systemDefault()).toInstant().toEpochMilli();
				
				writeD(itemId);
				writeD((int) (millis / 1000));
			}
		}
		else
		{
			writeD(0);
		}
	}
}