package l2s.gameserver.model;

import java.util.HashMap;
import java.util.Map;
import java.util.concurrent.*;

public class RaidBossManager {
    private static final int MAX_THREAD_POOL_SIZE = 1;
    private static Map<Integer, Integer> killedBossCountMap = new HashMap<>();
    private static ScheduledExecutorService scheduler = Executors.newScheduledThreadPool(1);
    private static ThreadPoolExecutor threadPoolExecutor;

    static {
        threadPoolExecutor = new ThreadPoolExecutor(
                MAX_THREAD_POOL_SIZE,
                MAX_THREAD_POOL_SIZE,
                60L, TimeUnit.SECONDS,
                new LinkedBlockingQueue<>()
        );
    }

    public static int getKilledBossCount(int bossId) {
        return killedBossCountMap.getOrDefault(bossId, 0);
    }

    public static void increaseKilledBossCount(int bossId) {
        int count = killedBossCountMap.getOrDefault(bossId, 0);
        killedBossCountMap.put(bossId, count + 1);
        scheduleResetTask(bossId);
    }

    private static void scheduleResetTask(int bossId) {
        scheduler.schedule(() -> {
            resetKilledBossCount(bossId);
        }, 2, TimeUnit.HOURS);
    }

    private static void resetKilledBossCount(int bossId) {
        killedBossCountMap.put(bossId, 0);
    }

    public static void shutdown() {
        scheduler.shutdown();
        threadPoolExecutor.shutdown();
    }
}



