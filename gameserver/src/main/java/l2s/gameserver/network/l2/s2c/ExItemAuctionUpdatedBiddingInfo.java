package l2s.gameserver.network.l2.s2c;

/**
 * @author Bonux
**/
public class ExItemAuctionUpdatedBiddingInfo extends L2GameServerPacket
{
	private final long _newBid;

	public ExItemAuctionUpdatedBiddingInfo(long newBid)
	{
		_newBid = newBid;
	}

	@Override
	protected final void writeImpl()
	{
		writeQ(_newBid);	// New highest bid
	}
}