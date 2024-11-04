package l2s.gameserver.network.l2.c2s.homunculus;

import l2s.gameserver.model.Player;
import l2s.gameserver.model.actor.variables.PlayerVariables;
import l2s.gameserver.network.l2.c2s.L2GameClientPacket;
import l2s.gameserver.network.l2.s2c.homunculus.ExHomunculusInitPointResult;

/**
 * @author nexvill
 */
public class RequestExHomunculusInitPoint extends L2GameClientPacket
{
	private static final int POWERFUL_FISH = 47552;
	private static final int FISH_COUNT = 5;
	private int _type;
	@Override
	protected boolean readImpl()
	{
		_type = readD();
		return true;
	}

	@Override
	protected void runImpl()
	{
		Player activeChar = getClient().getActiveChar();
		if(activeChar == null)
			return;
		if (activeChar.getInventory().getItemByItemId(POWERFUL_FISH).getCount() < FISH_COUNT)
		{
			activeChar.sendPacket(new ExHomunculusInitPointResult(false, _type));
			return;
		}
		
		boolean success = activeChar.getInventory().destroyItemByItemId(POWERFUL_FISH, FISH_COUNT);
		if (success)
		{
			if (_type == 0)
			{
				activeChar.setVar(PlayerVariables.HOMUNCULUS_USED_KILL_CONVERT, 0);
				int usedResetKills = activeChar.getVarInt(PlayerVariables.HOMUNCULUS_USED_RESET_KILLS, 0) + 1;
				activeChar.setVar(PlayerVariables.HOMUNCULUS_USED_RESET_KILLS, usedResetKills);
			}
			else
			{
				activeChar.setVar(PlayerVariables.HOMUNCULUS_USED_VP_CONVERT, 0);
				int usedResetVp = activeChar.getVarInt(PlayerVariables.HOMUNCULUS_USED_RESET_VP, 0) + 1;
				activeChar.setVar(PlayerVariables.HOMUNCULUS_USED_RESET_VP, usedResetVp);
			}
			
			activeChar.sendPacket(new ExHomunculusInitPointResult(success, _type));
		}
		
	}
}