package npc.model;

import l2s.commons.collections.MultiValueSet;
import l2s.gameserver.ThreadPoolManager;
import l2s.gameserver.geometry.Location;
import l2s.gameserver.model.Player;
import l2s.gameserver.model.instances.NpcInstance;

import l2s.gameserver.templates.npc.NpcTemplate;
import l2s.gameserver.utils.NpcUtils;


public class MonumentOldWorldInstance extends NpcInstance {

    public MonumentOldWorldInstance(int objectId, NpcTemplate template, MultiValueSet<String> set) {
        super(objectId, template, set);
    }

    public void onBypassFeedback(Player player, String command) {
        if (command.startsWith("request_give_4prof_item")) {
            player.getInventory().addItem(110394, 1);
            disappear();
        } else {
            super.onBypassFeedback(player, command);
        }
    }

    private void disappear() {
        decayMe();

        int delay = 1800000;
        ThreadPoolManager.getInstance().schedule(this::spawnMe, delay); // 1800000 миллисекунд = 30 минут
    }
}
