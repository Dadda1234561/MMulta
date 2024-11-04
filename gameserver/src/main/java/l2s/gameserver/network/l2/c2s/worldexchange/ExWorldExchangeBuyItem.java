package l2s.gameserver.network.l2.c2s.worldexchange;

import l2s.gameserver.Config;
import l2s.gameserver.dao.WorldExchangeManager;
import l2s.gameserver.model.Player;
import l2s.gameserver.network.l2.c2s.L2GameClientPacket;

public class ExWorldExchangeBuyItem extends L2GameClientPacket
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
		Player player = getClient().getActiveChar();
		if (player == null)
		{
			return;
		}
		WorldExchangeManager.getInstance().buyItem(player, _worldExchangeIndex);
	}
}
