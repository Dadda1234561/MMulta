package l2s.gameserver.data.xml.holder;

import java.util.HashMap;
import java.util.Map;

import l2s.commons.data.xml.AbstractHolder;

/**
 * @author nexvill
**/
public class ItemDeletionHolder extends AbstractHolder
{
	private static final ItemDeletionHolder _instance = new ItemDeletionHolder();

	private final Map<Integer, String> _itemDeletionInfo = new HashMap<>();

	public static ItemDeletionHolder getInstance()
	{
		return _instance;
	}
	
	public void addItemDeletionInfo(int id, String date)
	{
		_itemDeletionInfo.put(id, date);
	}
	
	public Map<Integer, String> getItems()
	{
		return _itemDeletionInfo;
	}

	@Override
	public int size()
	{
		return _itemDeletionInfo.size();
	}

	@Override
	public void clear()
	{
		_itemDeletionInfo.clear();
	}
}
