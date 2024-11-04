package l2s.gameserver.model.instances;

import java.text.SimpleDateFormat;

import l2s.commons.collections.MultiValueSet;
import l2s.gameserver.instancemanager.itemauction.ItemAuction;
import l2s.gameserver.instancemanager.itemauction.ItemAuctionInstance;
import l2s.gameserver.instancemanager.itemauction.ItemAuctionManager;
import l2s.gameserver.model.Player;
import l2s.gameserver.network.l2.components.HtmlMessage;
import l2s.gameserver.network.l2.components.SystemMsg;
import l2s.gameserver.network.l2.s2c.ExItemAuctionInfoPacket;
import l2s.gameserver.network.l2.s2c.ExItemAuctionNextInfoPacket;
import l2s.gameserver.templates.npc.NpcTemplate;

/**
 * @author n0nam3
 */
public class ItemAuctionBrokerInstance extends NpcInstance
{
	private static final SimpleDateFormat fmt = new SimpleDateFormat("yyyy.MM.dd HH:mm:ss");

	protected ItemAuctionInstance _instance;

	public ItemAuctionBrokerInstance(int objectId, NpcTemplate template, MultiValueSet<String> set)
	{
		super(objectId, template, set);
	}

	@Override
	public String getHtmlDir(String filename, Player player) {
		return "itemauction/";
	}

	public int getAuctionInstanceId()
	{
		return getNpcId();
	}

	@Override
	public void onBypassFeedback(Player player, String command)
	{
		final String[] params = command.split(" ");
		if(params.length == 1)
			return;

		if(params[0].equals("auction"))
		{
			if(_instance == null)
			{
				_instance = ItemAuctionManager.getInstance().getManagerInstance(getAuctionInstanceId());
				if(_instance == null)
					//_log.error("L2ItemAuctionBrokerInstance: Missing instance for: " + getTemplate().npcId);
					return;
			}

			if(params[1].equals("cancel"))
			{
				if(params.length == 3)
				{
					int auctionId = 0;

					try
					{
						auctionId = Integer.parseInt(params[2]);
					}
					catch(NumberFormatException e)
					{
						e.printStackTrace();
						return;
					}

					final ItemAuction auction = _instance.getAuction(auctionId);
					if(auction != null)
						auction.cancelBid(player);
					else
						player.sendPacket(SystemMsg.THERE_ARE_NO_FUNDS_PRESENTLY_DUE_TO_YOU);
				}
				else
				{
					final ItemAuction[] auctions = _instance.getAuctionsByBidder(player.getObjectId());
					if(auctions.length == 0) {
						player.sendPacket(SystemMsg.THERE_ARE_NO_FUNDS_PRESENTLY_DUE_TO_YOU);
						return;
					}

					for(final ItemAuction auction : auctions)
						auction.cancelBid(player);
				}
			}
			else if(params[1].equals("show"))
			{
				ItemAuction currentAuction = _instance.getCurrentAuction();
				if(currentAuction == null)
					currentAuction = _instance.getNextAuction();

				if(currentAuction == null)
				{
					player.sendPacket(SystemMsg.IT_IS_NOT_AN_AUCTION_PERIOD);
					return;
				}

				if(!player.getAndSetLastItemAuctionRequest())
				{
					player.sendPacket(SystemMsg.THERE_ARE_NO_OFFERINGS_I_OWN_OR_I_MADE_A_BID_FOR);
					return;
				}

				player.sendPacket(new ExItemAuctionInfoPacket(false, currentAuction));
			}
			else if(params[1].equalsIgnoreCase("next")) {
				ItemAuction currentAuction = _instance.getCurrentAuction();
				ItemAuction nextAuction = _instance.getNextAuction();
				if(currentAuction != null && nextAuction != null)
					player.sendPacket(new ExItemAuctionNextInfoPacket(nextAuction));
				else
					player.sendPacket(new ExItemAuctionNextInfoPacket(_instance.getNextAuctionTime()));
			}
		}
		else
			super.onBypassFeedback(player, command);
	}
}