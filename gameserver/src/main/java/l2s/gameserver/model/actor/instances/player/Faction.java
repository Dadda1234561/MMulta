package l2s.gameserver.model.actor.instances.player;

import l2s.gameserver.data.xml.holder.FactionDataHolder;
import l2s.gameserver.model.base.FactionType;

/**
 * @author Bonux
 */
public class Faction
{
	private final FactionType _type;
	private int _progress;

	public Faction(FactionType type, int progress)
	{
		_type = type;
		_progress = progress;
	}

	public FactionType getType()
	{
		return _type;
	}

	public int getProgress()
	{
		return _progress;
	}

	public void setProgress(int value)
	{
		_progress = value;
	}

	public void addProgress(int value)
	{
		_progress += value;
	}

	public int getLevel()
	{
		return FactionDataHolder.getInstance().getLevel(_type, _progress);
	}

	public double getPercentForNextLevel()
	{
		final int currentLevel = getLevel();
		final int pointsForCurrentLevel = FactionDataHolder.getInstance().getPoints(_type, currentLevel);
		final int pointsForNextLevel = FactionDataHolder.getInstance().getPoints(_type, currentLevel + 1);
		return (_progress - pointsForCurrentLevel) / ((pointsForNextLevel - pointsForCurrentLevel) / 100.0D) * 0.01D;
	}
}