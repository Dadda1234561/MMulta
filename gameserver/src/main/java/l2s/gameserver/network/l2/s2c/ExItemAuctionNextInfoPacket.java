package l2s.gameserver.network.l2.s2c;

import l2s.gameserver.instancemanager.itemauction.ItemAuction;

/**
 * @author Bonux
 **/
public class ExItemAuctionNextInfoPacket extends L2GameServerPacket {
	private final ItemAuction nextAuction;
	private final int nextAuctionTime;

	public ExItemAuctionNextInfoPacket(ItemAuction nextAuction) {
		this.nextAuction = nextAuction;
		this.nextAuctionTime = (int) (nextAuction.getStartingTime() / 1000L);

	}

	public ExItemAuctionNextInfoPacket(long nextAuctionTimeMillis) {
		this.nextAuction = null;
		this.nextAuctionTime = (int) (nextAuctionTimeMillis / 1000);
	}

	@Override
	protected final void writeImpl() {
		if (nextAuction != null) {
			writeQ(nextAuction.getAuctionInitBid());
			writeD(nextAuctionTime); // unix time in seconds
			writeItemInfo(nextAuction.getAuctionItem());
		} else {
			writeQ(-1);
			writeD(nextAuctionTime); // unix time in seconds
		}
	}
}