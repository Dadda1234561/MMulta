package l2s.gameserver.network.l2.c2s.timerestrictfield;

import l2s.gameserver.model.Player;
import l2s.gameserver.network.l2.c2s.L2GameClientPacket;
import l2s.gameserver.network.l2.s2c.timerestrictfield.ExTimeRestrictFieldHostUserLeave;

public class RequestExTimeRestrictFieldHostUserLeave extends L2GameClientPacket
{
	private int nLeaveFieldID;
	private int nNextEnterFieldID;

	@Override
	protected boolean readImpl() throws Exception
	{
		nLeaveFieldID = readD();
		nNextEnterFieldID = readD();
		return true;
	}

	@Override
	protected void runImpl() throws Exception
	{
		Player player = getClient().getActiveChar();
		if(player == null)
		{
			return;
		}

		player.stopTimedHuntingZoneTask(true);
		player.sendPacket(new ExTimeRestrictFieldHostUserLeave(true, nLeaveFieldID, nNextEnterFieldID));
	}
}
