package l2s.gameserver.network.l2.s2c.events.balrog;

import l2s.gameserver.instancemanager.events.BalrogWarManager;
import l2s.gameserver.model.Player;
import l2s.gameserver.network.l2.s2c.L2GameServerPacket;

public class ExBalrogwarShowUi extends L2GameServerPacket {

    private final int _playerRank;
    private final int _playerPoints;
    private final long _totalPoints;

    private final int _rewardState;
    private final int _rewardId;
    private final long _rewardAmount;

    public ExBalrogwarShowUi(Player player) {
        final BalrogWarManager _manager = BalrogWarManager.getInstance();

        _playerRank = _manager.getPlayerRank(player);
        _playerPoints = _manager.getPlayerPoints(player);
        _totalPoints = _manager.getTotalPoints();
        _rewardState = _manager.getRewardState(player);
        _rewardId = _manager.getRewardItemId();
        _rewardAmount = _manager.getRewardItemCount();
    }

    @Override
    protected void writeImpl() {
        // Rank Data
        writeD(_playerRank); // nRank
        writeD(_playerPoints); // nPersonalPoint

        // Point Data
        writeQ(_totalPoints); // nTotalPoint

        // Reward Data
        // 0 - NONE, 1 - Has Reward, 2 - Received already
        writeD(_rewardState); // nRewardState
        writeD(_rewardId); // nRewardItemID
        writeQ(_rewardAmount); // nRewardAmount
    }
}
