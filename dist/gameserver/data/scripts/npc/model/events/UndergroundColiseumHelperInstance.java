package npc.model.events;

import l2s.commons.collections.MultiValueSet;
import l2s.commons.util.Rnd;
import l2s.gameserver.geometry.Location;
import l2s.gameserver.model.Player;
import l2s.gameserver.model.instances.NpcInstance;
import l2s.gameserver.templates.npc.NpcTemplate;

/**
 * @author VISTALL
 * @date 23:26/16.06.2011
 */
public class UndergroundColiseumHelperInstance extends NpcInstance
{
	private Location[][] LOCS = new Location[][]
	{
			{new Location(-84451,-45452,-10728), new Location(-84580,-45587,-10728)},
			{new Location(-86154,-50429,-10728), new Location(-86118,-50624,-10728)},
			{new Location(-82009,-53652,-10728), new Location(-81802,-53665,-10728)},
			{new Location(-77603,-50673,-10728), new Location(-77586,-50503,-10728)},
			{new Location(-79186,-45644,-10728), new Location(-79309,-45561,-10728)}
	};

	public UndergroundColiseumHelperInstance(int objectId, NpcTemplate template, MultiValueSet<String> set)
	{
		super(objectId, template, set);
	}

	@Override
	public void onBypassFeedback(Player player, String command)
	{
		if(command.startsWith("coliseum"))
		{
			int a = Integer.parseInt(String.valueOf(command.charAt(9)));
			Location[] locs = LOCS[a];

			player.teleToLocation(locs[Rnd.get(locs.length)]);
		}
		else
			super.onBypassFeedback(player, command);
	}

	@Override
	public void showChatWindow(Player player, int val, boolean firstTalk, Object... arg)
	{
		showChatWindow(player, "events/guide_gcol001.htm", firstTalk);
	}
}
