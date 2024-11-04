package ai.custom;

import l2s.gameserver.Announcements;
import l2s.gameserver.ai.CtrlIntention;
import l2s.gameserver.ai.Fighter;
import l2s.gameserver.common.DifferentMethods;
import l2s.gameserver.model.Creature;
import l2s.gameserver.model.Player;
import l2s.gameserver.model.Skill;
import l2s.gameserver.model.World;
import l2s.gameserver.model.instances.NpcInstance;
import l2s.gameserver.network.l2.components.ChatType;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.util.Map;
import java.util.Set;
import java.util.concurrent.ConcurrentHashMap;
import java.util.concurrent.atomic.AtomicInteger;
import java.util.stream.Collectors;

/**
 * @author sharp on 07.02.2023
 * t.me/sharp1que
 */
public class CustomRewardBoss extends Fighter
{
    private static final Logger LOGGER = LoggerFactory.getLogger(CustomRewardBoss.class);
    private static final int[][] REWARD_HOLDER = new int[][]
    {
            // itemId, itemCnt, itemId, itemCnt
            {70083, 10}, // Первый кто нанесет удар
            {70083, 10}, // 70% хп
            {70083, 10}, // 40% хп
            {70083, 10}, // 10% хп
            {70083, 20}, // Ласт хит
    };

    private final Map<RewardType, Set<String>> _rewardedHWIDS;
    private final AtomicInteger _rewardStage;

    public CustomRewardBoss(NpcInstance actor)
    {
        super(actor);

        _rewardedHWIDS = new ConcurrentHashMap<>();
        _rewardStage = new AtomicInteger(0);
    }

    @Override
    protected void onEvtSpawn()
    {
        _rewardStage.set(0);
        _rewardedHWIDS.clear();
        for (RewardType rewardType : RewardType.values()) {
            _rewardedHWIDS.computeIfAbsent(rewardType, (set) -> ConcurrentHashMap.newKeySet());
        }
        super.onEvtSpawn();
    }

    @Override
    protected void onEvtAttacked(Creature attacker, Skill skill, int damage)
    {
        if (attacker == null) {
            return;
        }

        if ((attacker.isPet() || attacker.isSummon())) {
            Player player = attacker.getPlayer();
            if (player == null) {
                return;
            }
        }

        // Первый кто нанесет удар по боссу (получает награду)
        if (_rewardStage.get() == 0 && attacker.isPlayer()) {
            _rewardStage.getAndIncrement();

            rewardPlayer(attacker.getPlayer(), RewardType.FIRST_HIT);
            return;
        }

        double currentHpPercent = getActor().getCurrentHpPercents();

        // 2. на 70% хп все получают кто бьет
        if (currentHpPercent <= 70 && _rewardStage.get() == 1) {
            _rewardStage.getAndIncrement();
            getAttackingPlayers().forEach(player -> rewardPlayer(player, RewardType.PERCENT_70));
        } else if (currentHpPercent <= 40 && _rewardStage.get() == 2) { // 3. на 40% хп все получают кто бьет
            _rewardStage.getAndIncrement();
            getAttackingPlayers().forEach(player -> rewardPlayer(player, RewardType.PERCENT_40));
        } else if (currentHpPercent <= 10 && _rewardStage.get() == 3) { // 4. на 10% хп все получают кто бьет
            _rewardStage.getAndIncrement();
            getAttackingPlayers().forEach(player -> rewardPlayer(player, RewardType.PERCENT_10));
        }


        super.onEvtAttacked(attacker, skill, damage);
    }

    private Player getTopDamager() {
        Creature topDamager = getActor().getAggroList().getTopDamager(null);
        return topDamager == null ? null : topDamager.getPlayer();
    }

    @Override
    protected void onEvtDead(Creature killer)
    {
        Player playerKiller = killer.getPlayer();
        // if no killer was assigned
        // get top damager
        if (playerKiller == null) {
            playerKiller = getTopDamager();
        }


        // 5. Получает 1 игрок добивший босса.
        if (playerKiller != null && _rewardStage.get() == 4 && !isRewarded(playerKiller, RewardType.LAST_HIT)) {
            announceDeath(playerKiller);
            rewardPlayer(playerKiller, RewardType.LAST_HIT);
            recordRewardStep(playerKiller, RewardType.LAST_HIT);
            // Set to 5, so nothing is triggered later
            _rewardStage.getAndIncrement();
        }
        super.onEvtDead(killer);
    }

    private Set<Player> getAttackingPlayers() {
        return World.getAroundPlayers(getActor(), 2500).stream().filter(this::validatePlayer).collect(Collectors.toSet());
    }

    /**
     * Проверяем кастует ли чар
     * и проверяет в таргете ли данный моб..
     * @param player
     * @return
     */
    private boolean validatePlayer(Player player) {
        final int actorObjectId = getActor() == null ? -1 : getActor().getObjectId();
        if (player != null) {
            boolean isCasting = player.getAI().getIntention().equals(CtrlIntention.AI_INTENTION_CAST);
            boolean isAttacking = player.getAI().getIntention().equals(CtrlIntention.AI_INTENTION_ATTACK);
            return (isAttacking || isCasting) && (actorObjectId > 0 && player.getTargetId() == actorObjectId);
        }
        return false;
    }

    private void announceDeath(Player killer) {
        Announcements.getInstance().announceByCustomMessage("custom.CustomRewardBoss.Died", new String[] {_actor.getName(), killer.getName()}, ChatType.ANNOUNCEMENT);
    }

    private void recordRewardStep(Player player, RewardType rewardType) {
        _rewardedHWIDS.getOrDefault(rewardType, ConcurrentHashMap.newKeySet()).add(player.getHWID());
    }

    private boolean isRewarded(Player player, RewardType rewardType) {
        return false; //_rewardedHWIDS.getOrDefault(rewardType, ConcurrentHashMap.newKeySet()).contains(player.getHWID());
    }


    private void rewardPlayer(Player player, RewardType rewardType) {
        // check if HWID already rewarded
        if (isRewarded(player, rewardType)) {
            LOGGER.info("[CustomRewardBoss]: Skipped reward for " + player.getName() + " and " + rewardType.name() + " reward type. HWID already rewarded.");
            return;
        }

        switch (rewardType) {
            case FIRST_HIT:
                for (int i = 0; i < REWARD_HOLDER[0].length; i+= 2) {
                    DifferentMethods.addItem(player, REWARD_HOLDER[0][i], REWARD_HOLDER[0][i + 1]);
                }
                recordRewardStep(player, RewardType.FIRST_HIT);
                break;
            case PERCENT_70:
                for (int i = 0; i < REWARD_HOLDER[1].length; i+= 2) {
                    DifferentMethods.addItem(player, REWARD_HOLDER[1][i], REWARD_HOLDER[1][i + 1]);
                }
                recordRewardStep(player, RewardType.PERCENT_70);
                break;
            case PERCENT_40:
                for (int i = 0; i < REWARD_HOLDER[2].length; i+= 2) {
                    DifferentMethods.addItem(player, REWARD_HOLDER[2][i], REWARD_HOLDER[2][i + 1]);
                }
                recordRewardStep(player, RewardType.PERCENT_40);
                break;
            case PERCENT_10:
                for (int i = 0; i < REWARD_HOLDER[3].length; i+= 2) {
                    DifferentMethods.addItem(player, REWARD_HOLDER[3][i], REWARD_HOLDER[3][i + 1]);
                }
                recordRewardStep(player, RewardType.PERCENT_10);
                break;
            case LAST_HIT:
                for (int i = 0; i < REWARD_HOLDER[4].length; i+= 2) {
                    DifferentMethods.addItem(player, REWARD_HOLDER[4][i], REWARD_HOLDER[4][i + 1]);
                }
                recordRewardStep(player, RewardType.LAST_HIT);
                break;
        }

        LOGGER.info("[CustomRewardBoss]: Rewarded " + player.getName() + " for " + rewardType.name() + " reward type.");
    }

    private enum RewardType
    {
        FIRST_HIT,
        PERCENT_70,
        PERCENT_40,
        PERCENT_10,
        LAST_HIT,
    }
}
