package npc.model;

import l2s.commons.collections.MultiValueSet;
import l2s.gameserver.model.Player;
import l2s.gameserver.model.instances.NpcInstance;
import l2s.gameserver.network.l2.s2c.SystemMessage;
import l2s.gameserver.templates.npc.NpcTemplate;
import l2s.gameserver.geometry.Location;

/**
 * @author L2-scripts.com - (SanyaDC)
 */

public final class TsunamiInstance extends NpcInstance
{
	private static final Location TELEPORT = new Location(182152,212712,-14816);

	public TsunamiInstance(int objectId, NpcTemplate template, MultiValueSet<String> set)
	{
		super(objectId, template, set);
	}

	@Override
	public void onBypassFeedback(Player player, String command)
	{
		if(command.equalsIgnoreCase("enter"))
		{
			if(player.getParty() == null)
			{
				player.sendPacket(new SystemMessage(SystemMessage.ONLY_A_PARTY_LEADER_CAN_TRY_TO_ENTER));
				return;
			}
			if(player.getParty().getCommandChannel() == null)
			{
				showChatWindow(player, "default/34488 — nocc.htm", false);
				return;
			}
			if(player.getParty()!= null && player.getParty().getCommandChannel()!=null)

				if(player.getParty().getCommandChannel().getChannelLeader().getInventory().getItemByItemId(80322)==null) {
				showChatWindow(player, "default/34488 — noitem.htm", false);
				return;
			}
			if(!player.getParty().getCommandChannel().isLeaderCommandChannel(player))
			{
				showChatWindow(player, "default/34488 — noleader.htm", false);
				return;
			}
			int channelMemberCount = player.getParty().getCommandChannel().getMemberCount();
			if(channelMemberCount > 200)
			{
				showChatWindow(player, "default/34488 — ccmax.htm", false);
				return;
			}
			if(channelMemberCount < 49)
			{
				showChatWindow(player, "default/34488 — cclowmemb.htm", false);
				return;
			}

			for(Player commandChannel : player.getParty().getCommandChannel().getMembers())
			{
				if(commandChannel.getLevel() <105)
				{
					showChatWindow(player, "default/34488 — lvl.htm", false);
					return;
				}

			}

			for(Player commandChannel : player.getParty().getCommandChannel().getMembers())
			{
				commandChannel.teleToLocation(TELEPORT);
			}

		}
		else
			super.onBypassFeedback(player, command);
	}
}