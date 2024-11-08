package npc.model;

import l2s.commons.collections.MultiValueSet;
import l2s.gameserver.geometry.Location;
import l2s.gameserver.model.Player;
import l2s.gameserver.model.instances.NpcInstance;
import l2s.gameserver.network.l2.components.SystemMsg;
import l2s.gameserver.network.l2.s2c.SystemMessage;
import l2s.gameserver.templates.npc.NpcTemplate;

/**
 * @author Kolobrodik
 * @date 17:27/16.06.13
 */
public class BergamoInstance extends NpcInstance
{
    public BergamoInstance(int objectId, NpcTemplate template, MultiValueSet<String> set)
    {
        super(objectId, template, set);
    }

    @Override
    public void onBypassFeedback(Player player, String command)
    {
        if ((command.equalsIgnoreCase("start")))
        {
            getReflection().addSpawnWithoutRespawn(33693, new Location(75063, -213640, -3738, 3242), 0);
            getReflection().addSpawnWithoutRespawn(33694, new Location(74888, -213512, -3738, 32767), 0);
            getReflection().addSpawnWithoutRespawn(33695, new Location(75000, -213352, -3738, 32767), 0);
            getReflection().startCollapseTimer(3, true);
			this.deleteMe(); //must
        }

    }
}
