package l2s.gameserver.network.l2.c2s;

import l2s.gameserver.model.Player;
import l2s.gameserver.network.l2.s2c.HennaEquipListPacket;

public class RequestHennaList extends L2GameClientPacket
{
	private int unk;

	@Override
	protected boolean readImpl()
	{
		unk = readD();
		return true;
	}

	@Override
	protected void runImpl()
	{
		Player player = getClient().getActiveChar();
		if (player == null)
			return;

		player.sendPacket(new HennaEquipListPacket(player));
	}
}