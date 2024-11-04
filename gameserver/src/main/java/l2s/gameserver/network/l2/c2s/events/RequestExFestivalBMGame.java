package l2s.gameserver.network.l2.c2s.events;

import l2s.gameserver.model.Player;
import l2s.gameserver.network.l2.c2s.L2GameClientPacket;

public class RequestExFestivalBMGame extends L2GameClientPacket
{
	private int _participate;

	@Override
	protected boolean readImpl()
	{
		_participate = readD();
		return true;
	}

	@Override
	protected void runImpl()
	{
		Player player = getClient().getActiveChar();
		if (player == null)
			return;

		if (_participate == 1) {
			player.getListeners().onBMFestivalRegister();
		}
	}
}