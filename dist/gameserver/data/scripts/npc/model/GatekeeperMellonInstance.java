package npc.model;

import l2s.commons.collections.MultiValueSet;
import l2s.gameserver.geometry.Location;
import l2s.gameserver.model.Player;
import l2s.gameserver.model.instances.MerchantInstance;
import l2s.gameserver.templates.npc.NpcTemplate;

/**
 * @author Bonux
**/
public class GatekeeperMellonInstance extends MerchantInstance
{
	public GatekeeperMellonInstance(int objectId, NpcTemplate template, MultiValueSet<String> set)
	{
		super(objectId, template, set);
	}

	@Override
	public void onMenuSelect(Player player, int ask, long reply, int state)
	{
		if(ask == -31)
		{
			if(reply == 1)
			{
				if(player.getLevel() >= 20)
				{
					showChatWindow(player, "teleporter/" + getNpcId() + "-no_level.htm", false);
					return;
				}
				player.teleToLocation(new Location(1010648, -117251, 46771, 380));
			}
		}
		else
			super.onMenuSelect(player, ask, reply, state);
	}
}
