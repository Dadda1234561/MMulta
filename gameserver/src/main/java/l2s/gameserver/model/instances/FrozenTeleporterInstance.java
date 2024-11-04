package l2s.gameserver.model.instances;

import l2s.commons.collections.MultiValueSet;
import l2s.gameserver.geometry.Location;
import l2s.gameserver.model.Player;
import l2s.gameserver.network.l2.components.SystemMsg;
import l2s.gameserver.templates.item.ItemTemplate;
import l2s.gameserver.templates.npc.NpcTemplate;
import l2s.gameserver.utils.ItemFunctions;

public class FrozenTeleporterInstance extends NpcInstance{
    public FrozenTeleporterInstance(int objectId, NpcTemplate template, MultiValueSet<String> set) {
        super(objectId, template, set);
    }

    @Override
    public void onMenuSelect(Player player, int ask, long reply, int state) {
        if (ask == -30012024){
            long count;
            Location loc;
            switch ((int)reply)
            {
                case 3:
//                    count = 100000L;
                    loc = new Location(108728, -114600, -2456);
                    break;
                case 2:
//                    count = 100000L;
                    loc = new Location(124328, -108440, -2760);
                    break;
                case 1:
//                    count = 100000L;
                    loc = new Location(108376, -100600, -3448);
                    break;
                default:
                    return;
            }
//            if (!ItemFunctions.haveItem(player, ItemTemplate.ITEM_ID_ADENA, count)) {
//                player.sendPacket(SystemMsg.YOU_DO_NOT_HAVE_ENOUGH_ADENA);
//                return;
//            }
//            ItemFunctions.deleteItem(player, ItemTemplate.ITEM_ID_ADENA, count, true);
            player.teleToLocation(loc, player.getReflection());

        } else {
            super.onMenuSelect(player, ask, reply, state);
        }
    }
}
