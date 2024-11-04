package l2s.gameserver.network.l2.c2s.homunculus;

import l2s.gameserver.model.Player;
import l2s.gameserver.model.actor.variables.PlayerVariables;
import l2s.gameserver.network.l2.c2s.L2GameClientPacket;
import l2s.gameserver.network.l2.s2c.homunculus.ExHomunculusCreateStartResult;
import l2s.gameserver.network.l2.s2c.homunculus.ExShowHomunculusBirthInfo;

/**
 * @author nexvill
 */
public class RequestExHomunculusCreateStart extends L2GameClientPacket
{
	private static final int ADENA_COUNT = 1000000;
	
	@Override
	protected boolean readImpl()
	{
		//readC();
		return true;
	}

	@Override
	protected void runImpl()
	{
		Player activeChar = getClient().getActiveChar();
		if(activeChar == null)
			return;
		if (activeChar.getAdena() < ADENA_COUNT)
			return;
		
		boolean success = activeChar.getInventory().destroyItemByItemId(57, ADENA_COUNT);
		if (success)
		{
			activeChar.setVar(PlayerVariables.HOMUNCULUS_CREATION_TIME, System.currentTimeMillis() + 86400000L);
			activeChar.sendPacket(new ExShowHomunculusBirthInfo(activeChar));
			activeChar.sendPacket(new ExHomunculusCreateStartResult());
		}
	}
}