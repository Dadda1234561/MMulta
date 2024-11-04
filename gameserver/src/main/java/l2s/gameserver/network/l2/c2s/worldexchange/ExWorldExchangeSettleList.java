package l2s.gameserver.network.l2.c2s.worldexchange;


import l2s.gameserver.Config;
import l2s.gameserver.model.Player;
import l2s.gameserver.network.l2.c2s.L2GameClientPacket;
import l2s.gameserver.network.l2.s2c.worldexchange.ExWorldExchangeItemList;

public class ExWorldExchangeSettleList extends L2GameClientPacket
{
	@Override
	public boolean readImpl()
	{
		int dummy = readC();
		return true;
	}
	@Override
	public void runImpl()
	{
		if (!Config.ENABLE_WORLD_EXCHANGE)
		{
			return;
		}

		final Player player = getClient().getActiveChar();
		if (player == null)
		{
		    return;
		}

		player.sendPacket(ExWorldExchangeItemList.EMPTY_LIST);
		player.sendPacket(new l2s.gameserver.network.l2.s2c.worldexchange.ExWorldExchangeSettleList(player));
	}
}
