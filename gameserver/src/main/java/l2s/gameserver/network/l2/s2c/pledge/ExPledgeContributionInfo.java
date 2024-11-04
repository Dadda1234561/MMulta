package l2s.gameserver.network.l2.s2c.pledge;

import l2s.gameserver.model.Player;
import l2s.gameserver.model.actor.variables.PlayerVariables;
import l2s.gameserver.network.l2.s2c.L2GameServerPacket;

/**
 * @author nexvill
 */
public class ExPledgeContributionInfo extends L2GameServerPacket
{
	private final Player _player;
	private final boolean _cycle;
	private int _previousRep;
	private int _currentRep;
	private int _totalRep;
	private int _lastClaimed;
	private final int[] _reputationRequiredTiers =
		{
			2000,
			7000,
			15000,
			30000,
			45000
		};
		private final int[] _fameRewardTiers =
		{
			1300,
			3300,
			5400,
			10300,
			10600
		};

	public ExPledgeContributionInfo(Player player, boolean cycle)
	{
		_player = player;
		_cycle = cycle;
		
		_previousRep = player.getVarInt(PlayerVariables.PREVIOUS_REPUTATION, 0);
		_currentRep = player.getVarInt(PlayerVariables.CURRENT_REPUTATION, 0);
		_totalRep = player.getVarInt(PlayerVariables.TOTAL_REPUTATION, 0);
		_lastClaimed = player.getVarInt(PlayerVariables.CONTRIBUTION_CLAIMED, 0);
	}

	@Override
	protected final void writeImpl()
	{
		if (_player.getClan() == null)
		{
			return;
		}
		
		if (_cycle)
		{
			writeD(_currentRep);
		}
		else
		{
			writeD(_previousRep);
		}
		writeD(_totalRep);
		
		if (_lastClaimed < 4)
		{
			writeD(_reputationRequiredTiers[_lastClaimed]);
			writeD(-1);
			writeD(0);
			writeD(_fameRewardTiers[_lastClaimed]);
		}
		else
		{
			int reputationRequired = 15000 * (_lastClaimed);
			int fameReward = 10600 + ((_lastClaimed - 4) * 200);
			writeD(reputationRequired);
			writeD(-1);
			writeD(0);
			writeD(fameReward);
		}
	}
}