package l2s.gameserver.templates.agathion;

import l2s.gameserver.templates.cubic.CubicTargetType;
import l2s.gameserver.templates.cubic.CubicTemplate;
import l2s.gameserver.templates.cubic.CubicUseUpType;

/**
 * @author Bonux
 */
public class AgathionTemplate extends CubicTemplate
{
	private final int _npcId;
	private final int[] _itemIds;
	private final int _energy;
	private final int _maxEnergy;
	private final boolean _deleteOnDeath;

	public AgathionTemplate(int npcId, int id, int duration, int delay, int maxCount, CubicUseUpType useUp, double power, CubicTargetType targetType, int[] itemIds, int energy, int maxEnergy, boolean deleteOnDeath)
	{
		super(id, 1, 1, duration, delay, maxCount, useUp, power, targetType);

		_npcId = npcId;
		_itemIds = itemIds;
		_energy = energy;
		_maxEnergy = maxEnergy;
		_deleteOnDeath = deleteOnDeath;
	}

	public int getNpcId()
	{
		return _npcId;
	}

	public int[] getItemIds()
	{
		return _itemIds;
	}

	public int getEnergy()
	{
		return _energy;
	}

	public int getMaxEnergy()
	{
		return _maxEnergy;
	}

	public boolean deleteOnMastersDeath()
	{
		return _deleteOnDeath;
	}
}