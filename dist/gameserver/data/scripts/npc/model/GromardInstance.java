package npc.model;

import instances.*;
import l2s.commons.collections.MultiValueSet;
import l2s.gameserver.model.Player;
import l2s.gameserver.model.instances.NpcInstance;
import l2s.gameserver.model.entity.Reflection;
import l2s.gameserver.templates.npc.NpcTemplate;
import l2s.gameserver.utils.ReflectionUtils;

//By Evil_dnk

public class GromardInstance extends NpcInstance
{

    private static final int Eternal = 308;
    private static final int Reborn = 307;

    public GromardInstance(int objectId, NpcTemplate template, MultiValueSet<String> set)
    {
        super(objectId, template, set);
    }

    public void onBypassFeedback(Player player, String command)
    {
        if (command.startsWith("request_enter_4_prof_inst"))
        {
            Reflection r = player.getActiveReflection();
            if (r != null)
            {
                if (player.canReenterInstance(Eternal))
                {
                    player.teleToLocation(r.getTeleportLoc(), r);
                }
            }
            else if (player.canEnterInstance(Eternal) && player.getRebirthCount() >= 100)
            {
                ReflectionUtils.enterReflection(player, new EternalRefuge(), Eternal);
            }
            else
            {
                showChatWindow(player, "default/40212-1.htm", false);
            }
        }
        else if (command.startsWith("request_enter_reborn_sign_inst"))
        {
            final Reflection r = player.getActiveReflection();
            if (r != null)
            {
                if (player.canReenterInstance(Reborn))
                {
                    player.teleToLocation(r.getTeleportLoc(), r);
                }

            }
            else if (player.canEnterInstance(Reborn) && player.getRebirthCount() >= 100)
            {
                ReflectionUtils.enterReflection(player, new RebornSign(), Reborn);
            }
            else
            {
                showChatWindow(player, "default/40212-1.htm", false);
            }
        }
        else
            super.onBypassFeedback(player, command);
    }

}