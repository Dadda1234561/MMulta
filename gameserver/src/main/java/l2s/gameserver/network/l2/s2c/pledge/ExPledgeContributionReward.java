package l2s.gameserver.network.l2.s2c.pledge;

import l2s.gameserver.model.Player;
import l2s.gameserver.model.actor.variables.PlayerVariables;
import l2s.gameserver.network.l2.s2c.L2GameServerPacket;

/**
 * @author nexvill
 */
public class ExPledgeContributionReward extends L2GameServerPacket
{
	private final Player _player;
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

	public ExPledgeContributionReward(Player player)
	{
		_player = player;
		
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
		
		if ((_lastClaimed < 4) && (_totalRep >= _reputationRequiredTiers[_lastClaimed]))
		{
			_player.setFame(_player.getFame() + _fameRewardTiers[_lastClaimed], null, true);
		}
		else if (_totalRep >= (15000 * _lastClaimed))
		{
			int fameReward = 10600 + ((_lastClaimed - 4) * 200);
			_player.setFame(_player.getFame() + fameReward, null, true);
		}
		_player.setVar(PlayerVariables.CONTRIBUTION_CLAIMED, _lastClaimed + 1);
		_player.broadcastUserInfo(true);
		
		writeD(0);
	}
}