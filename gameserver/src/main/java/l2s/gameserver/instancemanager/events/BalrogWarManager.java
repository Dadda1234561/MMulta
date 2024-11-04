package l2s.gameserver.instancemanager.events;

import l2s.gameserver.Config;
import l2s.gameserver.common.DifferentMethods;
import l2s.gameserver.model.BalokState;
import l2s.gameserver.model.BossInfo;
import l2s.gameserver.model.BossState;
import l2s.gameserver.model.Player;
import l2s.gameserver.model.RewardState;
import l2s.gameserver.model.instances.NpcInstance;
import l2s.gameserver.model.items.ItemInstance;
import l2s.gameserver.model.mail.Mail;
import l2s.gameserver.network.l2.s2c.events.balrog.ExBalrogwarGetReward;
import l2s.gameserver.templates.item.data.ItemData;
import l2s.gameserver.utils.ItemFunctions;

import java.util.ArrayList;
import java.util.Comparator;
import java.util.LinkedHashMap;
import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;
import java.util.concurrent.CopyOnWriteArrayList;
import java.util.concurrent.TimeUnit;
import java.util.stream.Collectors;

public class BalrogWarManager {
    private final ItemData LORD_REWARD = new ItemData(70083, 1);
    private int _rewardItemId = 1;
    private long _rewardItemCount = 0;
    private int _finalBossId = 0;
    private boolean _isLordSpawn = false;

    private final Map<Integer, Integer> _playerPoints = new ConcurrentHashMap<>();
    private final CopyOnWriteArrayList<BossInfo> _bossInfos = new CopyOnWriteArrayList<>();
    private final CopyOnWriteArrayList<Integer> _rewardedPlayers = new CopyOnWriteArrayList<>();

    private BalokState _state = BalokState.NONE;
    private BossState _bossState = BossState.NONE;
    private RewardState _rewardState = RewardState.NONE;
    private NpcInstance _finalBoss = null;
    private int _progressStep = 0;
    private long _preparationStartedAt = 0L;
    private long _battleStartedAt = 0L;

    public BalrogWarManager() {

    }

    public BalokState getState() {
        return _state;
    }

    public CopyOnWriteArrayList<BossInfo> getBossInfos() {
        return _bossInfos;
    }

    public void clearBossInfos() {
        _bossInfos.clear();
    }

    public void addBossInfo(BossInfo bossInfo) {
        _bossInfos.add(bossInfo);
    }

    public void setRewardState(RewardState state) {
        _rewardState = state;
    }

    public void setProgressStep(int step) {
        _progressStep = step;
    }

    public int getProgressStep() {
        return _progressStep;
    }

    public int getRewardState(Player player) {
        return isAlreadyRewarded(player) ? RewardState.REWARD_RECEIVED.ordinal() : isRewardAvailable(player) ? RewardState.HAS_REWARD.ordinal() : _rewardState.ordinal();
    }

    public void setPreparationStartedAt(long preparationStatedAt) {
        _preparationStartedAt = preparationStatedAt;
    }

    public void setBattleStartedAt(long battleStartedAt) {
        _battleStartedAt = battleStartedAt;
    }

    public long getBattleStartedAt() {
        return _battleStartedAt;
    }

    public long getRequiredPointsToSpawnBoss() {
        final long _pointsToSpawn = 250_000L;
        switch (_progressStep) {
            default: {
                return 0;
            }
            case 1: {
                return _pointsToSpawn;
            }
            case 2: {
                return _pointsToSpawn * 2;
            }
            case 3: {
                return _pointsToSpawn * 4;
            }
            case 4:
            case 5: {
                return _pointsToSpawn * 6;
            }
        }
    }

    public void setFinalBossState(BossState state) {
        _bossState = state;
    }

    public BossState getFinalBossState() {
        return _bossState;
    }

    public void setFinalBoss(NpcInstance finalBoss) {
        _finalBoss = finalBoss;
    }

    public NpcInstance getFinalBoss() {
        return _finalBoss;
    }

    public int getRemainingTime() {
        final long now = System.currentTimeMillis();

        if (_state.equals(BalokState.PREPARE)) {
            final long preparationEnd = _preparationStartedAt + TimeUnit.MINUTES.toMillis(20);
            return (int) ((preparationEnd - now) / 1000);
        } else if (_state.equals(BalokState.PROGRESS) || _state.equals(BalokState.END) || _state.equals(BalokState.REWARD)) {
            final long battleEnd = _battleStartedAt + TimeUnit.HOURS.toMillis(1);
            return (int) ((battleEnd - now) / 1000);
        }

        return 0;
    }

    // The longer the Battle with Balok lasts,
    // the more personal points you can gain for killing common monsters.
    // Joining a party doesn't affect the number of points acquired:
    private int getMonsterPoints(boolean isScorpion) {
        final int minutesPassedFromStart = (int) TimeUnit.MILLISECONDS.toMinutes(System.currentTimeMillis() - _battleStartedAt);

        if (minutesPassedFromStart < 10) {
            return isScorpion ? 150 : 100;
        } else if (minutesPassedFromStart < 20) {
            return isScorpion ? 225 : 150;
        } else {
            return isScorpion ? 300 : 200;
        }
    }

    /**
     * The character rankings are based on the number of points earned.
     * The top-30 of ranked characters get Special HP Recovery Potion Sealed (100 pcs.) by mail.
     *
     * @param count
     * @return
     */
    public Map<Integer, Integer> getTopPlayers(int count) {
        return _playerPoints.entrySet().stream()
                .sorted(Map.Entry.comparingByValue(Comparator.reverseOrder()))
                .limit(count).collect(Collectors.toMap(Map.Entry::getKey, Map.Entry::getValue, (e1, e2) -> e1, LinkedHashMap::new));
    }

    public void addPointsForPlayer(Player player, boolean isScorpion) {
        final int pointsToAdd = (int) (getMonsterPoints(isScorpion) * Config.BALROG_WAR_POINT_REWARD_MOD);
        final int currentPoints = _playerPoints.computeIfAbsent(player.getObjectId(), pts -> 0);
        _playerPoints.put(player.getObjectId(), currentPoints + pointsToAdd);
    }

    //DBG:
    public void setPlayerPoints(Player player, int points) {
        _playerPoints.put(player.getObjectId(), points);
    }

    public boolean isAlreadyRewarded(Player player) {
        return _rewardedPlayers.contains(player.getObjectId());
    }

    public boolean isRewardAvailable(Player player) {
        return !isAlreadyRewarded(player) && (_state == BalokState.REWARD || _state.equals(BalokState.END)) && player.getLevel() >= 60 && getPlayerPoints(player) >= 1000;
    }

    public void rewardPlayer(Player player) {
        _rewardedPlayers.add(player.getObjectId());
        player.getInventory().addItem(70083, 1);
        player.sendPacket(new ExBalrogwarGetReward(true));
    }

    public int getPlayerRank(Player player) {
        if (!_playerPoints.containsKey(player.getObjectId())) {
            return 0;
        }

        final LinkedHashMap<Integer, Integer> sorted = _playerPoints.entrySet()
                .stream()
                .sorted(Map.Entry.comparingByValue(Comparator.reverseOrder()))
                .collect(Collectors.toMap(Map.Entry::getKey, Map.Entry::getValue, (e1, e2) -> e1, LinkedHashMap::new));

        return new ArrayList<>(sorted.keySet()).indexOf(player.getObjectId()) + 1;
    }

    public int getPlayerPoints(Player player) {
        return _playerPoints.getOrDefault(player.getObjectId(), 0);
    }

    public long getTotalPoints() {
        return _state.equals(BalokState.END) ? 0 : _playerPoints.values().stream().mapToInt(Integer::intValue).sum();
    }

    public void setState(BalokState state) {
        _state = state;
    }

    public void setRewardItemId(int itemId) {
        _rewardItemId = itemId;
    }

    public void setRewardItemCount(long count) {
        _rewardItemCount = count;
    }

    public void setFinalBossId(int npcId) {
        _finalBossId = npcId;
        _isLordSpawn = npcId == 29169;
    }

    public int getFinalBossId() {
        return _finalBossId;
    }

    public int getRewardItemId() {

        return LORD_REWARD.getId();
    }

    public long getRewardItemCount() {

        return _rewardItemCount;
    }

    //public void rewardTop30() {
    //    // Special HP Recovery Potion Sealed
    //    final ItemData holder = new ItemData(91690, 100);
//
    //    getTopPlayers(30).forEach((playerId, points) ->
    //    {
    //        final Mail message = new Mail();
    //        message.setSenderId(-1);
    //        message.setReceiverId(playerId);
    //        message.setTopic("Reward");
    //        message.setBody("Text");
    //        final ItemInstance rewardItem = ItemFunctions.createItem(holder.getId());
    //        rewardItem.setCount(holder.getCount());
    //        message.addAttachment(rewardItem);
    //    });
    //}

    public void clear() {
        _playerPoints.clear();
        _rewardedPlayers.clear();

        _isLordSpawn = false;
        _state = BalokState.NONE;
        _bossState = BossState.NONE;
        _rewardState = RewardState.NONE;
        _progressStep = 0;
        _finalBossId = 0;
        _rewardItemId = 0;
        _rewardItemCount = 1;
        _battleStartedAt = 0;
        _preparationStartedAt = 0;

        for (BossInfo bossInfo : _bossInfos) {
            if (bossInfo.getNpc() != null) {
                bossInfo.getNpc().deleteMe();
            }
        }

        _bossInfos.clear();
    }


    public static BalrogWarManager getInstance() {
        return SingletonHolder.INSTANCE;
    }

    private static class SingletonHolder {
        protected static BalrogWarManager INSTANCE = new BalrogWarManager();
    }
}
