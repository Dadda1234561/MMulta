package l2s.gameserver.network.l2.c2s.worldexchange;

import l2s.gameserver.Config;
import l2s.gameserver.dao.WorldExchangeManager;
import l2s.gameserver.model.Player;
import l2s.gameserver.network.l2.c2s.L2GameClientPacket;

public class ExWorldExchangeSettleRecvResult extends L2GameClientPacket
{
	private long _worldExchangeIndex;

	@Override
	public boolean readImpl()
	{
		_worldExchangeIndex = readQ();
		return true;
	}

	@Override
	public void runImpl()
	{
		if (!Config.ENABLE_WORLD_EXCHANGE)
		{
			return;
		}

		Player PlayerInstance = getClient().getActiveChar();
		if (PlayerInstance != null)
		{
			WorldExchangeManager.getInstance().getItemStatusAndMakeAction(PlayerInstance, _worldExchangeIndex);
		}
	}
}
