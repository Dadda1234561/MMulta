package npc.model;

import l2s.commons.collections.MultiValueSet;
import l2s.gameserver.geometry.Location;
import l2s.gameserver.model.Player;
import l2s.gameserver.model.instances.NpcInstance;
import l2s.gameserver.templates.npc.NpcTemplate;

/**
 * @author VAVAN
 */
public class TullyWorkShopTeleporterInstance extends NpcInstance
{
	public TullyWorkShopTeleporterInstance(int objectId, NpcTemplate template, MultiValueSet<String> set)
	{
		super(objectId, template,set);
	}

	@Override
	public void onBypassFeedback(Player player, String command)
	{
		if(!canBypassCheck(player))
			return;

		/*if(!player.isInParty())
		{
			showChatWindow(player, "default/32753-1.htm");
			return;
		}
		if(player.getParty().getPartyLeader() != player)
		{
			showChatWindow(player, "default/32753-2.htm");
			return;
		}
		if(!rangeCheck(player))
		{
			showChatWindow(player, "default/32753-2.htm", false);
			return;
		}*/

		if(command.equalsIgnoreCase("01_up"))
		{
			player.teleToLocation(new Location(-12700, 273340, -13600));
			return;
		}
		else if(command.equalsIgnoreCase("02_up"))
		{
			player.teleToLocation(new Location(-13246, 275740, -11936));
			return;
		}
		else if(command.equalsIgnoreCase("02_down"))
		{
			player.teleToLocation(new Location(-12894, 273900, -15296));
			return;
		}
		else if(command.equalsIgnoreCase("03_up"))
		{
			player.teleToLocation(new Location(-12798, 273458, -10496));
			return;
		}
		else if(command.equalsIgnoreCase("03_down"))
		{
			player.teleToLocation(new Location(-12718, 273490, -13600));
			return;
		}
		else if(command.equalsIgnoreCase("04_up"))
		{
			//player.teleToLocation(new Location(-13500, 275912, -9032));
			player.teleToLocation(new Location(-12312, 273272, -9032));
			return;
		}
		else if(command.equalsIgnoreCase("04_down"))
		{
			player.teleToLocation(new Location(-13246, 275740, -11936));
			return;
		}
		else
			super.onBypassFeedback(player, command);
	}

	private boolean rangeCheck(Player pl)
	{
		for(Player m : pl.getParty().getPartyMembers())
			if(!pl.isInRange(m, 400))
				return false;
		return true;
	}
}