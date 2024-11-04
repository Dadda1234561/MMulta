package l2s.gameserver.templates;

import l2s.gameserver.Config;
import l2s.gameserver.instancemanager.ServerVariables;

public class FestivalBMTemplate
{
	private final int _itemId;
	private final int _itemCount;
	private final long _totalCount;
	private final int _locationId;
	private final double _chance;

	public FestivalBMTemplate(int id, int count, long totalCount, double chance, int locId)
	{
		_itemId = id;
		_itemCount = count;
		_totalCount = totalCount;
		_chance = chance;
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

	public double getChance() {
		return _chance;
	}

	public long getTotalCount() {
		return _totalCount;
	}

	public long getRemainingCount() {
		return ServerVariables.getLong("FESTIVAL_BM_" + getItemId(), getTotalCount());
	}

	public void decreaseRemainingCount() {
		long prevAmount = ServerVariables.getLong("FESTIVAL_BM_" + getItemId(), getTotalCount());
		ServerVariables.set("FESTIVAL_BM_" + getItemId(), Math.max(0, (prevAmount - (Config.BM_FESTIVAL_REMOVE_SINGLE_ITEM ? 1 : getItemCount()))));
	}
}
