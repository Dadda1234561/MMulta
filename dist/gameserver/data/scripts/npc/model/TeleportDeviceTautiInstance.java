package npc.model;

import l2s.commons.collections.MultiValueSet;
import l2s.gameserver.geometry.Location;
import l2s.gameserver.model.Player;
import l2s.gameserver.model.instances.NpcInstance;
import l2s.gameserver.network.l2.components.HtmlMessage;
import l2s.gameserver.network.l2.s2c.SystemMessage;
import l2s.gameserver.templates.npc.NpcTemplate;

/**
 * @author KilRoy
 */
public class TeleportDeviceTautiInstance extends NpcInstance
{
	private static final int KEY_OF_DARKNESS = 34899;
	private static final Location TAUTI_ROOM_HALL = new Location(-149244, 209882, -10199);

	private boolean _accepted = false;

	public TeleportDeviceTautiInstance(int objectId, NpcTemplate template, MultiValueSet<String> set)
	{
		super(objectId, template, set);
	}

	@Override
	public void onBypassFeedback(Player player, String command)
	{
		if(command.equalsIgnoreCase("request_accept_tauti"))
		{
			if(player.getInventory().getItemByItemId(KEY_OF_DARKNESS) != null && !_accepted)
			{
				player.getInventory().destroyItemByItemId(KEY_OF_DARKNESS, 1);
				setNpcState(1);
				_accepted = true;
				player.teleToLocation(TAUTI_ROOM_HALL, player.getReflection());
			}
			else
				showChatWindow(player, "default/33678-nokey.htm", false);
		}
		else if(command.equalsIgnoreCase("request_tauti"))
		{
			player.teleToLocation(TAUTI_ROOM_HALL, player.getReflection());
		}
		else
			super.onBypassFeedback(player, command);
	}

	@Override
	public void showChatWindow(Player player, int val, boolean firstTalk, Object... arg)
	{
		if(!_accepted)
		{
			player.sendPacket(new HtmlMessage(this, "default/33678.htm").setPlayVoice(firstTalk));
		}
		else
		{
			player.sendPacket(new HtmlMessage(this, "default/33678-1.htm").setPlayVoice(firstTalk));
		}
		return;
	}
}