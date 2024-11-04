package npc.model;

import l2s.commons.collections.MultiValueSet;
import l2s.gameserver.geometry.Location;
import l2s.gameserver.model.Player;
import l2s.gameserver.model.instances.NpcInstance;
import l2s.gameserver.network.l2.components.HtmlMessage;
import l2s.gameserver.network.l2.s2c.SystemMessage;
import l2s.gameserver.templates.npc.NpcTemplate;

/**
 * @author L2-scripts.com - (SanyaDC)
 */
public class TeleportDeviceAstatinFabricInstance extends NpcInstance
{
	private static final Location INSIDE = new Location(-59392, 52628, -8608);
	private static final Location OUTSIDE = new Location(-51664, 60200, -3347);

	public TeleportDeviceAstatinFabricInstance(int objectId, NpcTemplate template, MultiValueSet<String> set)
	{
		super(objectId, template, set);
	}

	@Override
	public void onBypassFeedback(Player player, String command)
	{
		if(command.equalsIgnoreCase("teleport_inside"))
		{
			player.teleToLocation(INSIDE, player.getReflection());

		}
		if(command.equalsIgnoreCase("teleport_outside"))
		{
			player.teleToLocation(OUTSIDE, player.getReflection());

		}
			super.onBypassFeedback(player, command);
	}

	@Override
	public void showChatWindow(Player player, int val, boolean firstTalk, Object... arg)
	{		
			player.sendPacket(new HtmlMessage(this, "teleporter/34441.htm").setPlayVoice(firstTalk));
			return;
	}
}