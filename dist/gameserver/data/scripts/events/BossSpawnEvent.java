package events;

import l2s.commons.time.cron.SchedulingPattern;
import l2s.gameserver.ThreadPoolManager;
import l2s.gameserver.geometry.Location;
import l2s.gameserver.listener.actor.player.OnAnswerListener;
import l2s.gameserver.listener.script.OnInitScriptListener;
import l2s.gameserver.model.GameObjectsStorage;
import l2s.gameserver.model.instances.NpcInstance;
import l2s.gameserver.network.l2.components.SystemMsg;
import l2s.gameserver.network.l2.s2c.ConfirmDlgPacket;
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
                    50010, // Закен PVP
                    50006, // Баюм PVP
                    50012, // Фринтеза PVP
                    50008, // Антарас PVP
                    50014, // Клакиес PVP
                    50016  // Чудовище PVP
            };

    private static final int[] PVE_BOSS_IDS =
            {
                    50003, // Ядро PVE
                    50001, // Королева Муравьев PVE
                    50005, // Орфен PVE
                    50011, // Закен PVE
                    50007, // Баюм PVE
                    50013, // Фринтеза PVE
                    50009, // Антарас PVE
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
        GameObjectsStorage.getPlayers(false, false).stream().filter(player -> player != null && !player.isDead() && !player.isInOlympiadMode() && !player.isInObserverMode()).forEach(player -> {
            ConfirmDlgPacket dlg = new ConfirmDlgPacket(SystemMsg.S1, 30000).addString((player.isLangRus() ? "Телепортироваться к "  : "Teleport to ") + getBossName(isPve ? PVE_BOSS_IDS[index] : PVP_BOSS_IDS[index], player.isLangRus()));
            player.ask(dlg, new OnAnswerListener() {
                @Override
                public void sayYes() {
                    player.teleToLocation(BOSS_LOCATIONS[index], 30, 300);
                }

                @Override
                public void sayNo() {}
            });
        });

        if (isPve) {
            _pveBossNpcs[index] = NpcUtils.spawnSingle(PVE_BOSS_IDS[index], BOSS_LOCATIONS[index], DESPAWN_TIME);

            return;
        }
        _pvpBossNpcs[index] = NpcUtils.spawnSingle(PVP_BOSS_IDS[index], BOSS_LOCATIONS[index], DESPAWN_TIME);
    }

    /*private void despawnBoss(int index, boolean isPve) {
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
    }*/

    private String getBossName(int bossId, boolean isLangRus) {
        switch (bossId) {
            case 50000:
                return isLangRus ? "Королева Муравьев [PVP]" : "Queen Ant [PVP]";
            case 50001:
                return isLangRus ? "Королева Муравьев [PVE]" : "Queen Ant [PVE]";
            case 50002:
                return isLangRus ? "Ядро [PVP]" : "Core [PVP]";
            case 50003:
                return isLangRus ? "Ядро [PVE]" : "Core [PVE]";
            case 50004:
                return isLangRus ? "Орфен [PVP]" : "Orphen [PVP]";
            case 50005:
                return isLangRus ? "Орфен [PVE]" : "Orphen [PVE]";
            case 50006:
                return isLangRus ? "Баюм [PVP]" : "Baium [PVP]";
            case 50007:
                return isLangRus ? "Баюм [PVE]" : "Baium [PVE]";
            case 50008:
                return isLangRus ? "Антарас [PVP]" : "Antharas [PVP]";
            case 50009:
                return isLangRus ? "Антарас [PVE]" : "Antharas [PVE]";
            case 50010:
                return isLangRus ? "Закен [PVP]" : "Zaken [PVP]";
            case 50011:
                return isLangRus ? "Закен [PVE]" : "Zaken [PVE]";
            case 50012:
                return isLangRus ? "Фринтеза [PVP]" : "Frintezza [PVP]";
            case 50013:
                return isLangRus ? "Фринтеза [PVE]" : "Frintezza [PVE]";
            case 50014:
                return isLangRus ? "Клакиес [PVP]" : "Glakias [PVP]";
            case 50015:
                return isLangRus ? "Клакиес [PVE]" : "Glakias [PVE]";
            case 50016:
                return isLangRus ? "Чудовище [PVP]" : "Monster [PVP]";
            case 50017:
                return isLangRus ? "Чудовище [PVE]" : "Monster [PVE]";
            default:
                return "Неизвестный босс";
        }
    }
}
