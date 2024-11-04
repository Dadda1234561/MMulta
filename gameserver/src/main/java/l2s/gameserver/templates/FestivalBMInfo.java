package l2s.gameserver.templates;

/**
 * @author nexvill
 **/
public class FestivalBMInfo 
{
	private final int _itemId;
	private final int _itemCount;
	private final int _locationId;

	public FestivalBMInfo(int id, int count, int locId) 
	{
		_itemId = id;
		_itemCount = count;
		_locationId = locId;
	}

	public int getItemId() 
	{
		return _itemId;
	}

	public int getItemCount() 
	{
		return _itemCount;
	}

	public int getLocationId() 
	{
		return _locationId;
	}
}
