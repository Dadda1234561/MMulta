package npc.model.custom;

import l2s.commons.collections.MultiValueSet;
import l2s.gameserver.geometry.Location;
import l2s.gameserver.instancemanager.ReflectionManager;
import l2s.gameserver.model.Player;
import l2s.gameserver.model.entity.Reflection;
import l2s.gameserver.model.instances.NpcInstance;
import l2s.gameserver.templates.npc.NpcTemplate;

public class MainWorldTeleporterInstance extends NpcInstance {

    private static final Location GIRAN_TP_LOC = new Location(83480, 148952,-3402, 65197);

    public MainWorldTeleporterInstance(int objectId, NpcTemplate template, MultiValueSet<String> set) {
        super(objectId, template, set);
    }

    @Override
    public void onBypassFeedback(Player player, String command) {
        if (command.equals("goToMainWorld")) {
            Reflection reflection = player.getActiveReflection();
            // teleport player
            player.teleToLocation(82552, 148616,-3463, ReflectionManager.MAIN);
            // close ref
            if (reflection != null && !reflection.isMain() && !reflection.isDefault()) {
                reflection.collapse();
            }
        }
    }
}
