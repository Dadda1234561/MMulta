package events;

import l2s.commons.time.cron.SchedulingPattern;
import l2s.commons.util.Rnd;
import l2s.gameserver.Config;
import l2s.gameserver.ThreadPoolManager;
import l2s.gameserver.geometry.Location;
import l2s.gameserver.handler.admincommands.AdminCommandHandler;
import l2s.gameserver.handler.admincommands.IAdminCommandHandler;
import l2s.gameserver.instancemanager.SpawnManager;
import l2s.gameserver.instancemanager.events.BalrogWarManager;
import l2s.gameserver.listener.actor.OnKillListener;
import l2s.gameserver.listener.actor.player.OnPlayerEnterListener;
import l2s.gameserver.listener.script.OnInitScriptListener;
import l2s.gameserver.model.BalokState;
import l2s.gameserver.model.BossInfo;
import l2s.gameserver.model.BossState;
import l2s.gameserver.model.Creature;
import l2s.gameserver.model.GameObjectsStorage;
import l2s.gameserver.model.Player;
import l2s.gameserver.model.RewardState;
import l2s.gameserver.model.Spawner;
import l2s.gameserver.model.actor.listener.CharListenerList;
import l2s.gameserver.model.instances.NpcInstance;
import l2s.gameserver.network.l2.components.IBroadcastPacket;
import l2s.gameserver.network.l2.components.SystemMsg;
import l2s.gameserver.network.l2.s2c.SystemMessage;
import l2s.gameserver.network.l2.s2c.SystemMessagePacket;
import l2s.gameserver.network.l2.s2c.events.balrog.ExBalrogwarBossinfo;
import l2s.gameserver.network.l2.s2c.events.balrog.ExBalrogwarHud;
import l2s.gameserver.network.l2.s2c.events.balrog.ExBalrogwarShowUi;
import l2s.gameserver.utils.NpcUtils;
import org.apache.commons.lang3.ArrayUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.Collections;
import java.util.List;
import java.util.Set;
import java.util.concurrent.ConcurrentHashMap;
import java.util.concurrent.ScheduledFuture;
import java.util.concurrent.TimeUnit;

import static l2s.gameserver.model.BalokState.PREPARE;
import static l2s.gameserver.model.BalokState.PROGRESS;

public class BattleForBalokEvent implements OnInitScriptListener, IAdminCommandHandler {

    protected static final Logger LOGGER = LoggerFactory.getLogger(BattleForBalokEvent.class.getName());

    private final BalrogWarManager balokManager = BalrogWarManager.getInstance();
    private static final Location finalBossSpawnLocation = new Location(-22392, -222392, -3504);
    private static final SchedulingPattern startPattern = new SchedulingPattern("00 21 * * *");

    private static final int KESMA = 25956;
    private static final int PRAIS = 25957;
    private static final int VIRA = 25958;
    private static final int HEEDER = 25959;
    private static final int HEARAK = 25960;

    private final int[] intermediateBosses =
    {
            KESMA, PRAIS, VIRA, HEEDER, HEARAK
    };

    private static final Location[] midSpawnLocations =
    {
        new Location(-24104, -222904, -3504),
        new Location(-23704, -222760, -3504),
        new Location(-23304, -222728, -3504),
        new Location(-22760, -222584, -3504),
        new Location(-22392, -222392, -3504),
    };

    /**
     * Monsters
     **/
    private static final int DEMONIC_REAPER = 22413;
    private static final int DEMONIC_WARRIOR = 22414;
    private static final int DEMONIC_KNIGHT = 22415;
    private static final int EARTH_SKORPION = 22416;
    private static final int DEMONIC_SKELETON = 22417;

    /**
     * Balok
     **/
    private static final int LORD_BALOK = 29169;

    private final ConcurrentHashMap<Integer, Integer> bossLanterns = new ConcurrentHashMap<>();

    private boolean spawnRolled = false;
    private final List<Location> locationPool = new ArrayList<>();
    private final List<Integer> availableBosses = new ArrayList<>();

    private ScheduledFuture<?> _endTask = null;
    private ScheduledFuture<?> _resetTask = null;
    private ScheduledFuture<?> _preAnnounceTask = null;
    private ScheduledFuture<?> _monsterSpawnTask = null;
    private static final Set<Integer> ALL_NPC_IDS = ConcurrentHashMap.newKeySet();

    static {
        ALL_NPC_IDS.add(KESMA);
        ALL_NPC_IDS.add(PRAIS);
        ALL_NPC_IDS.add(VIRA);
        ALL_NPC_IDS.add(HEEDER);
        ALL_NPC_IDS.add(HEARAK);
        ALL_NPC_IDS.add(DEMONIC_REAPER);
        ALL_NPC_IDS.add(DEMONIC_WARRIOR);
        ALL_NPC_IDS.add(DEMONIC_KNIGHT);
        ALL_NPC_IDS.add(EARTH_SKORPION);
        ALL_NPC_IDS.add(DEMONIC_SKELETON);
        ALL_NPC_IDS.add(LORD_BALOK);
    }

    private final EventListeners LISTENERS = new EventListeners();

    @Override
    public void onInit() {
        CharListenerList.addGlobal(LISTENERS);
        AdminCommandHandler.getInstance().registerAdminCommandHandler(this);
        scheduleNextStart();
    }

    private static enum Commands
    {
        admin_balrog_start,
        admin_balrog_stop
    }

    @Override
    public boolean useAdminCommand(Enum<?> comm, String[] wordList, String fullString, Player activeChar) {
        Commands command = (Commands) comm;
        switch (command)
        {
            case admin_balrog_start:
            {
                clearEndTask();
                clearResetTask();

                end(true);
                reset();
                startMonsterSpawn();
                break;
            }
            case admin_balrog_stop:
            {
                clearEndTask();
                clearResetTask();

                end(true);
                reset();
                break;
            }
        }
        return false;
    }

    @Override
    public Enum<?>[] getAdminCommandEnum() {
        return Commands.values();
    }

    private class EventListeners implements OnPlayerEnterListener, OnKillListener {
        @Override
        public void onPlayerEnter(Player player) {
            if (balokManager.getState().equals(BalokState.PREPARE) || balokManager.getState().equals(PROGRESS)) {
                player.sendPacket(new ExBalrogwarHud());
            }
        }

        /**
         * Нахер этот говнокод, добавить зону и в ней слущать убийства мобов...
         * @param actor
         * @param victim
         */
        @Override
        public void onKill(Creature actor, Creature victim) {
            if (!balokManager.getState().equals(PROGRESS) && !balokManager.getState().equals(PREPARE))
            {
                return;
            }
            if (actor == null || !actor.isPlayer() || victim.isPlayer()) return;
            int npcId = victim.getNpcId();
            NpcInstance npc = (NpcInstance) victim;
            if (ALL_NPC_IDS.contains(npcId)) {

                final int progressStep = balokManager.getProgressStep();
                final long totalPoints = balokManager.getTotalPoints();
                final long requiredPoints = balokManager.getRequiredPointsToSpawnBoss();

                final boolean isLordBalok = (npc.getNpcId() == LORD_BALOK);
                final boolean isEnoughPoints = (totalPoints >= requiredPoints);
                final boolean isIntermediateBoss = ArrayUtils.contains(intermediateBosses, npc.getNpcId());

                // 1 -> 2 step
                if (progressStep == 1 && isEnoughPoints) {
                    // set step to 2
                    increaseProgressStep();
                    // spawn three bosses
                    checkAndSpawnBoss();
                    // update
                    broadcastUiUpdate();
                    return;
                } else if (progressStep == 3 && (balokManager.getBossInfos().size() == 5) && !haveToKillBosses() && isEnoughPoints) {
                    // Set progress step to 4
                    increaseProgressStep();
                    // prepare to spawn random balok
                    spawnBalokBoss();
                    return;
                } else if (progressStep == 4 && isEnoughPoints && balokManager.getFinalBoss() == null) {
                    spawnBalokBoss();
                    return;
                } else if (progressStep == 5 && isLordBalok) {
                    stopMonsterSpawn(true);

                    clearEndTask();

                    balokManager.setFinalBossState(BossState.SUCCESS);
                    balokManager.setState(BalokState.REWARD);
                    balokManager.setRewardState(RewardState.HAS_REWARD);

                    broadcastPacket(new SystemMessage(SystemMsg.YOU_VE_WON_THE_BATTLE_WITH_BALOK));
                    broadcastHudUpdate();
                    broadcastBossInfo();
                    broadcastUiUpdate();
                    return;
                } else if (isIntermediateBoss) {
                    for (BossInfo bossInfo : balokManager.getBossInfos()) {
                        if (bossInfo.getNpcId() == npc.getNpcId()) {
                            bossInfo.setState(BossState.SUCCESS);
                            break;
                        }
                    }

                    broadcastBossInfo();

                    if (balokManager.getBossInfos().size() == 3 && !haveToKillBosses()) {
                        // spawn two bosses
                        checkAndSpawnBoss();
                        return;
                    } else if (balokManager.getBossInfos().size() == 5 && !haveToKillBosses()) {
                        spawnBalokBoss();
                        return;
                    }
                    return;
                }

                if (checkKillerRequirements(actor.getPlayer(), npc)) {
                    balokManager.addPointsForPlayer(actor.getPlayer(), npc.getNpcId() == 22416);
                    checkAndSpawnBoss();
                }
            }

        }

        @Override
        public boolean ignorePetOrSummon() {
            return true;
        }
    }

    private void broadcastPacket(IBroadcastPacket... packets) {
        for (Player player : GameObjectsStorage.getAllPlayersForIterate()) {
            player.sendPacket(packets);
        }
    }

    /**
     * Lv. 60+
     * Monday - Saturday 20:30 - 21:30
     */
    private void scheduleNextStart() {
        if (_preAnnounceTask != null) {
            _preAnnounceTask.cancel(false);
            _preAnnounceTask = null;
        }

        if (_monsterSpawnTask != null) {
            _monsterSpawnTask.cancel(false);
            _monsterSpawnTask = null;
        }

        _preAnnounceTask = ThreadPoolManager.getInstance().schedule(this::preStartAnnounce, startPattern.getOffsettedDelayToNextFromNow(20));
        _monsterSpawnTask = ThreadPoolManager.getInstance().schedule(this::startMonsterSpawn, startPattern.getDelayToNextFromNow());

        LOGGER.info("[BattleWithBalok]: Scheduled next event start for " + startPattern.getNextAsFormattedDateString());
    }

    /**
     * 20 minutes prior the event the special 'Battle with Balok' UI will appear beside your minimap.
     * Use it to teleport to Balok Battleground Camp.
     */
    private void preStartAnnounce() {
        balokManager.setPreparationStartedAt(System.currentTimeMillis());

        // Update HUD, Send System Message
        broadcastPacket(new ExBalrogwarHud());
        broadcastPacket(new SystemMessagePacket(SystemMsg.BATTLE_WITH_BALOK_STARTS_IN_20_MIN));

        // Schedule next announce
        ThreadPoolManager.getInstance().schedule(() -> broadcastPacket(SystemMsg.BATTLE_WITH_BALOK_STARTS_IN_10_MIN), 10 * 60 * 1000);
    }

    /**
     * During the battle monsters are spawning on the Balok Battlefield.
     * Killing them grants you personal points.
     */
    private void startMonsterSpawn() {
        balokManager.setState(PROGRESS);
        balokManager.setProgressStep(1);
        balokManager.setBattleStartedAt(System.currentTimeMillis());

        SpawnManager.getInstance().spawn("balrog_event_monster_spawn");

        broadcastPacket(new ExBalrogwarHud());
        broadcastPacket(new SystemMessage(SystemMsg.MONSTERS_ARE_SPAWNING_ON_THE_BALOK_BATTLEGROUND));

        shuffleAndFillAvailableBosses();
        shuffleAndFillSpawnLocations();

        _endTask = ThreadPoolManager.getInstance().schedule(() -> end(false), TimeUnit.MINUTES.toMillis(30));
        _resetTask = ThreadPoolManager.getInstance().schedule(this::reset, TimeUnit.MINUTES.toMillis(60));
    }

    private void end(boolean isAdminCommand) {
        if (!isAdminCommand) {
            balokManager.setFinalBossState(BossState.FAIL);
            balokManager.setState(BalokState.END);
            balokManager.setProgressStep(4); // fail
        }

        final NpcInstance finalBoss = balokManager.getFinalBoss();
        if (finalBoss != null) {
            finalBoss.deleteMe();
            balokManager.setFinalBoss(null);
        }

        // Despawn monsters on fail
        for (BossInfo bossInfo : balokManager.getBossInfos()) {
            if (bossInfo.getNpc() != null) {
                bossInfo.getNpc().deleteMe();
            }
        }

        stopMonsterSpawn(true);
        broadcastHudUpdate();

        if (!isAdminCommand) {
            broadcastPacket(new SystemMessage(SystemMsg.YOU_VE_LOST_THE_BATTLE_WITH_BALOK));
        }
    }

    private void reset() {
        // Clear manager
        balokManager.clear();

        // Reset variables
        balokManager.setRewardState(RewardState.NONE);
        balokManager.setPreparationStartedAt(0);
        balokManager.setState(BalokState.NONE);
        balokManager.setProgressStep(0);
        balokManager.setBattleStartedAt(0);
        balokManager.setPreparationStartedAt(0);

        stopMonsterSpawn(true);

        if (balokManager.getFinalBoss() != null) {
            balokManager.getFinalBoss().deleteMe();
            balokManager.setFinalBoss(null);
        }

        bossLanterns.clear();
        balokManager.clearBossInfos();

        availableBosses.clear();
        availableBosses.addAll(Arrays.asList(intermediateBosses[0], intermediateBosses[1], intermediateBosses[2], intermediateBosses[3], intermediateBosses[4]));
        Collections.shuffle(availableBosses);

        locationPool.clear();
        locationPool.addAll(Arrays.asList(midSpawnLocations));
        Collections.shuffle(locationPool);

        // schedule next start after reset :/
        scheduleNextStart();
    }


    private boolean checkKillerRequirements(Player killer, NpcInstance npc) {
        if (killer.getLevel() < 60) {
            final SystemMessage sm = new SystemMessage(SystemMsg.REQUIRED_LEVEL_FOR_THE_BATTLE_WITH_BALOK_S1);
            sm.addNumber(60);
            killer.sendPacket(sm);
            return false;
        }

        boolean isMonster = npc.getNpcId() >= 22413 && npc.getNpcId() <= 22417;
        boolean isValidState = balokManager.getState().equals(PROGRESS);

        return isMonster && isValidState;
    }

    private void clearEndTask() {
        if (_endTask != null) {
            _endTask.cancel(false);
            _endTask = null;
        }
    }

    private void clearResetTask() {
        if (_resetTask != null) {
            _resetTask.cancel(false);
            _resetTask = null;
        }
    }

    private void increaseProgressStep() {
        // Increment
        balokManager.setProgressStep(balokManager.getProgressStep() + 1);
        // Broadcast
        broadcastHudUpdate();

        LOGGER.info(String.format("[%s]: PROGRESS_STEP SET TOO -> %d", getClass().getSimpleName(), balokManager.getProgressStep()));
    }

    private boolean haveToKillBosses() {
        boolean allDead = true;
        for (BossInfo bossInfo : balokManager.getBossInfos()) {
            if (bossInfo.getState() != BossState.SUCCESS.ordinal()) {
                allDead = false;
                break;
            }
        }

        return !allDead;
    }

    /**
     * Sometimes instead of an intermediate boss Lord Balok may appear right away.
     * The event is random.
     * If it happens, there will be no intermediate bosses in that session.
     *
     * @return true if Lord Balok should be spawned, false otherwise.
     */
    private boolean rollLordBalokSpawn() {
        spawnRolled = true;
        return Rnd.get(100) < 5;
    }

    private void checkAndSpawnBoss() {
        final int progressStep = balokManager.getProgressStep();
        if (progressStep > 4 || haveToKillBosses()) {
            return;
        }

        final boolean pointsReached = balokManager.getTotalPoints() >= balokManager.getRequiredPointsToSpawnBoss();
        final boolean canSpawn = (progressStep < 4) && (progressStep == 1 || (progressStep == 2 && balokManager.getBossInfos().isEmpty()) || (progressStep == 3) && balokManager.getBossInfos().size() == 3);

        if (progressStep == 2 && pointsReached && (Config.ENABLE_BALOK_RANDOM_BOSS_SKIP && !spawnRolled && rollLordBalokSpawn()) && balokManager.getFinalBoss() == null) {
            // Spawn Lord - Skip all intermediate bosses
            spawnBalokBoss();
            balokManager.setProgressStep(5);

            broadcastBossInfo();
            broadcastHudUpdate();
            broadcastUiUpdate();

            LOGGER.info(String.format("[%s]: Rolled lord balok spawn! Spawning!", getClass().getSimpleName()));
        } else if (pointsReached && canSpawn) {
            spawnNextIntermediateBoss();
        }
    }

    private void spawnNextIntermediateBoss() {
        synchronized (balokManager.getBossInfos()) {
            final int progressStep = balokManager.getProgressStep();
            if (progressStep < 2 || progressStep >= 4) {
                LOGGER.info(String.format("[%s]: No more steps to go!", getClass().getSimpleName()));
                return;
            }

            if (progressStep == 2) {
                while (balokManager.getBossInfos().size() < 3) {
                    Location spawnLocation = locationPool.remove(0);
                    NpcInstance boss = NpcUtils.spawnSingle(availableBosses.remove(0), spawnLocation);
                    balokManager.addBossInfo(new BossInfo(boss, BossState.SPAWN));
                }

                broadcastPacket(new SystemMessage(SystemMsg.THREE_BOSSES_HAVE_SPAWNED));

                broadcastBossInfo();
                increaseProgressStep();
                broadcastUiUpdate();

                LOGGER.info(String.format("[%s]: Spawned three bosses!", getClass().getSimpleName()));
            } else {
                while (balokManager.getBossInfos().size() >= 3 && balokManager.getBossInfos().size() < 5) {
                    Location spawnLocation = locationPool.remove(0);
                    NpcInstance boss = NpcUtils.spawnSingle(availableBosses.remove(0), spawnLocation);
                    balokManager.addBossInfo(new BossInfo(boss, BossState.SPAWN));
                }

                broadcastPacket(new SystemMessage(SystemMsg.TWO_BOSSES_HAVE_SPAWNED));
                broadcastBossInfo();
                broadcastUiUpdate();

                LOGGER.info(String.format("[%s]: Spawned two bosses!", getClass().getSimpleName()));
            }
        }
    }


    private void broadcastBossInfo() {
        for (Player player : GameObjectsStorage.getAllPlayersForIterate()) {
            player.sendPacket(new ExBalrogwarBossinfo());
        }
    }

    private void broadcastHudUpdate() {
        for (Player player : GameObjectsStorage.getAllPlayersForIterate()) {
            player.sendPacket(new ExBalrogwarHud());
        }
    }

    private void broadcastUiUpdate() {
        for (Player player : GameObjectsStorage.getAllPlayersForIterate()) {
            sendUiUpdate(player);
        }
    }

    private void sendUiUpdate(Player player) {
        player.sendPacket(new ExBalrogwarShowUi(player));
    }

    private void shuffleAndFillAvailableBosses() {
        availableBosses.clear();

        for (int intermediateBoss : intermediateBosses) {
            availableBosses.add(intermediateBoss);
        }

        Collections.shuffle(availableBosses);
    }

    private void shuffleAndFillSpawnLocations() {
        locationPool.clear();

        locationPool.addAll(Arrays.asList(midSpawnLocations));

        Collections.shuffle(locationPool);
    }

    /**
     * After Balok or Lord Balok appears,
     * no common monsters are spawned.
     */
    private void stopMonsterSpawn(boolean isDespawn) {
        if (isDespawn) {  // despawn
            SpawnManager.getInstance().getSpawners("balrog_event_monster_spawn").forEach(Spawner::deleteAll);
        } else { // stop respawn
            SpawnManager.getInstance().getSpawners("balrog_event_monster_spawn").forEach(Spawner::stopRespawn);
        }
    }

    // After Balok or Lord Balok appears, no common monsters are spawned.
    private void spawnBalokBoss()
    {
        stopMonsterSpawn(false);

        balokManager.setFinalBossId(LORD_BALOK);
        balokManager.setFinalBoss(NpcUtils.spawnSingle(LORD_BALOK, finalBossSpawnLocation));
        broadcastPacket(new SystemMessage(SystemMsg.LORD_BALOK_IS_HERE));

        broadcastBossInfo();
        broadcastHudUpdate();
        broadcastUiUpdate();

        balokManager.setFinalBossState(BossState.SPAWN);
        balokManager.setProgressStep(5);
    }

    public BattleForBalokEvent()
    {

    }
}
