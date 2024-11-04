package events;

import l2s.commons.time.cron.SchedulingPattern;
import l2s.gameserver.Announcements;
import l2s.gameserver.ThreadPoolManager;
import l2s.gameserver.geometry.Location;
import l2s.gameserver.listener.script.OnInitScriptListener;
import l2s.gameserver.model.instances.NpcInstance;
import l2s.gameserver.utils.NpcUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.util.concurrent.TimeUnit;

public class BossSpawnEvent implements OnInitScriptListener {

    private static final Logger _log = LoggerFactory.getLogger(BossSpawnEvent.class);

    private static final Location[] BOSS_LOCATIONS = {
            new Location(17720, 110376, -6648),    // Ядро
            new Location(-6504, 183048, -3616),    // Королева Муравьев
            new Location(64328, 29128, -3808),     // Орфен
            new Location(52200, 216240, -3336),    // Закен
            new Location(114680, 16472, -5096),    // Баюм
            new Location(-87784, -153288, -9176),  // Фринтеза
            new Location(127912, 116312, -3712),   // Антарас
            new Location(114712, -114792, -11200), // Клакиес
            new Location(204168, -111896, 64)      // Чудовище
    };

    private static final int[] PVP_BOSS_IDS =
    {
            50002, // Ядро PVP
            50000, // Королева Муравьев PVP
            50004, // Орфен PVP
            50006, // Закен PVP
            50008, // Баюм PVP
            50010, // Фринтеза PVP
            50012, // Антарас PVP
            50014, // Клакиес PVP
            50016  // Чудовище PVP
    };

    private static final int[] PVE_BOSS_IDS =
    {
        50003, // Ядро PVE
        50001, // Королева Муравьев PVE
        50005, // Орфен PVE
        50007, // Закен PVE
        50009, // Баюм PVE
        50011, // Фринтеза PVE
        50013, // Антарас PVE
        50015, // Клакиес PVE
        50017  // Чудовище PVE
    };

    /**
     * PvP Боссы будут начинать ресаться в 00:30/ 4:30/ 8:30/ 12:30/ 16:30/20:30
     * PvE Боссы будут начинать ресаться в 02:30/ 6:30/ 10:30/ 14:30/18:30/22:30
     */
    private static final SchedulingPattern PVP_SPAWN_PATTERN = new SchedulingPattern("30 */4 * * *");
    private static final SchedulingPattern PVE_SPAWN_PATTERN = new SchedulingPattern("30 2-22/4 * * *");
    public static final long DESPAWN_TIME = 10 * 60 * 1000L;

    private final NpcInstance[] _pveBossNpcs = new NpcInstance[PVE_BOSS_IDS.length];
    private final NpcInstance[] _pvpBossNpcs = new NpcInstance[PVP_BOSS_IDS.length];

    @Override
    public void onInit() {
        scheduleBossSpawns(PVP_SPAWN_PATTERN, false);
        scheduleBossSpawns(PVE_SPAWN_PATTERN, true);
        _log.info("Loaded Event: BossSpawnEvent [state: activated]");

    }

    private void scheduleBossSpawns(SchedulingPattern pattern, boolean isPve) {
        long initialDelay = pattern.next(System.currentTimeMillis()) - System.currentTimeMillis();
        ThreadPoolManager.getInstance().scheduleAtFixedRate(() -> startBossSpawnSequence(isPve), initialDelay, TimeUnit.HOURS.toMillis(4));
    }

    private void startBossSpawnSequence(boolean isPve) {
        int[] bossIds = isPve ? PVE_BOSS_IDS : PVP_BOSS_IDS;
        for (int i = 0; i < bossIds.length; i++) {
            final int bossIndex = i;
            ThreadPoolManager.getInstance().schedule(() -> spawnBoss(bossIndex, isPve), i * (3 * 60 * 1000L));
        }
    }

    private void spawnBoss(int index, boolean isPve) {
        if (isPve) {
            _pveBossNpcs[index] = NpcUtils.spawnSingle(PVE_BOSS_IDS[index], BOSS_LOCATIONS[index], DESPAWN_TIME);
            return;
        }
        _pvpBossNpcs[index] = NpcUtils.spawnSingle(PVP_BOSS_IDS[index], BOSS_LOCATIONS[index], DESPAWN_TIME);
    }

    private void despawnBoss(int index, boolean isPve) {
        if (isPve) {
            if (_pveBossNpcs[index] != null) {
                _pveBossNpcs[index].deleteMe();
                _pveBossNpcs[index] = null;
            }
            return;
        }
        if (_pvpBossNpcs[index] != null) {
            _pvpBossNpcs[index].deleteMe();
            _pvpBossNpcs[index] = null;
        }
    }

    private String getBossName(int bossId) {
        switch (bossId) {
            case 50000:
                return "Королева Муравьев PVP";
            case 50001:
                return "Королева Муравьев PVE";
            case 50002:
                return "Ядро PVP";
            case 50003:
                return "Ядро PVE";
            case 50004:
                return "Орфен PVP";
            case 50005:
                return "Орфен PVE";
            case 50006:
                return "Закен PVP";
            case 50007:
                return "Закен PVE";
            case 50008:
                return "Баюм PVP";
            case 50009:
                return "Баюм PVE";
            case 50010:
                return "Фринтеза PVP";
            case 50011:
                return "Фринтеза PVE";
            case 50012:
                return "Антарас PVP";
            case 50013:
                return "Антарас PVE";
            case 50014:
                return "Клакиес PVP";
            case 50015:
                return "Клакиес PVE";
            case 50016:
                return "Чудовище PVP";
            case 50017:
                return "Чудовище PVE";
            default:
                return "Неизвестный босс";
        }
    }
}
