package l2s.gameserver.network.l2.c2s.homunculus;

import l2s.gameserver.model.Player;
import l2s.gameserver.model.actor.instances.player.Homunculus;
import l2s.gameserver.network.l2.c2s.L2GameClientPacket;
import l2s.gameserver.network.l2.s2c.homunculus.ExDeleteHomunculusDataResult;
import l2s.gameserver.network.l2.s2c.homunculus.ExShowHomunculusList;

/**
 * @author nexvill
 */
public class RequestExDeleteHomunculusData extends L2GameClientPacket
{
	private int _slot;
	@Override
	protected boolean readImpl()
	{
		_slot = readD();
		return true;
	}

	@Override
	protected void runImpl()
	{
		Player activeChar = getClient().getActiveChar();
		if(activeChar == null)
			return;
		
		Homunculus homunculus = activeChar.getHomunculusList().get(_slot);
		if (activeChar.getHomunculusList().remove(homunculus))
		{
			activeChar.sendPacket(new ExDeleteHomunculusDataResult());
			activeChar.sendPacket(new ExShowHomunculusList(activeChar.getHomunculusList()));
		}
	}
}