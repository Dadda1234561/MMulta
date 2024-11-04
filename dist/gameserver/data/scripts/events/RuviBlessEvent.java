package events;

import l2s.gameserver.Announcements;
import l2s.gameserver.ThreadPoolManager;
import l2s.gameserver.geometry.Location;
import l2s.gameserver.listener.script.OnInitScriptListener;
import l2s.gameserver.model.instances.NpcInstance;
import l2s.gameserver.utils.NpcUtils;
import l2s.commons.time.cron.SchedulingPattern;

import java.util.concurrent.TimeUnit;

public class RuviBlessEvent implements OnInitScriptListener {

    private static final Location RUVI_SPAWN_LOCATION = new Location(83288, 148632, -3408, 0);
    private static final int RUVI_NPC_ID = 40209;
    private static final SchedulingPattern RUVI_SPAWN_PATTERN = new SchedulingPattern("25 */2 * * *"); // Время начала ивента (Ивент начинается с отсылки сообщений в чат) сам спавн Npc происходит через 5 минут.
    private NpcInstance _ruviNpc = null;

    @Override
    public void onInit() {
        scheduleRuviAppearance();
    }

    private void scheduleRuviAppearance() {
        long initialDelay = RUVI_SPAWN_PATTERN.next(System.currentTimeMillis()) - System.currentTimeMillis();
        ThreadPoolManager.getInstance().scheduleAtFixedRate(this::announceAndSpawnRuvi, initialDelay, TimeUnit.HOURS.toMillis(2));
    }

    private void announceAndSpawnRuvi() {
        Announcements.announceToAll("[Через 5 минут в центре Гирана, появится путешественница Руви.]\n[У нее вы можете получить уникальный положительный эффект!]\n[Через 5 минут после появления Руви, она исчезает!]");
        for (int i = 4; i >= 1; i--) {
            final int finalI = i;
            ThreadPoolManager.getInstance().schedule(() ->
                            Announcements.announceToAll("[Через " + finalI + " минут" + (finalI == 1 ? "у" : "ы") + " в центре Гирана, появится путешественница Руви.]"),
                    (long) (5 - finalI) * 60 * 1000, TimeUnit.MILLISECONDS
            );
        }
        ThreadPoolManager.getInstance().schedule(this::spawnRuvi, 5 * 60 * 1000, TimeUnit.MILLISECONDS);
    }

    private void spawnRuvi() {
        despawnRuvi();
        _ruviNpc = NpcUtils.spawnSingle(RUVI_NPC_ID, RUVI_SPAWN_LOCATION);
        Announcements.announceToAll("[Путешественница Руви появилась в мир, и готова наделить каждого игрока своим уникальным эффектом, не пропустите!]");

        ThreadPoolManager.getInstance().schedule(this::despawnRuvi, 5 * 60 * 1000, TimeUnit.MILLISECONDS);
    }

    private void despawnRuvi() {
        if (_ruviNpc != null) {
            Announcements.announceToAll("[Путешественница Руви пропала! Но не стоит расстраиваться, через некоторое время она снова появится!]");
            _ruviNpc.deleteMe();
            _ruviNpc = null;
        }
    }
}
