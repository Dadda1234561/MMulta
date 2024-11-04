package l2s.gameserver.network.l2.c2s.homunculus;

import l2s.gameserver.model.Player;
import l2s.gameserver.model.actor.variables.PlayerVariables;
import l2s.gameserver.network.l2.c2s.L2GameClientPacket;
import l2s.gameserver.network.l2.s2c.homunculus.ExHomunculusGetEnchantPointResult;
import l2s.gameserver.network.l2.s2c.homunculus.ExHomunculusHPSPVP;
import l2s.gameserver.network.l2.s2c.homunculus.ExHomunculusPointInfo;

/**
 * @author nexvill
 */
public class RequestExHomunculusGetEnchantPoint extends L2GameClientPacket
{
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
		
		if (_type == 0) // mobs
		{
			int killedMobs = activeChar.getVarInt(PlayerVariables.HOMUNCULUS_KILLED_MOBS, 0);
			if (killedMobs < 500)
			{
				return;
			}
			int usedKillConverts = activeChar.getVarInt(PlayerVariables.HOMUNCULUS_USED_KILL_CONVERT, 0);
			if (usedKillConverts >= 5)
			{
				return;
			}
			
			int upgradePoints = activeChar.getVarInt(PlayerVariables.HOMUNCULUS_UPGRADE_POINTS, 0) + 1;
			activeChar.setVar(PlayerVariables.HOMUNCULUS_UPGRADE_POINTS, upgradePoints);
			activeChar.setVar(PlayerVariables.HOMUNCULUS_KILLED_MOBS, 0);
			activeChar.setVar(PlayerVariables.HOMUNCULUS_USED_KILL_CONVERT, usedKillConverts + 1);
		}
		else if (_type == 1) // vitality
		{
			int usedVpPoints = activeChar.getVarInt(PlayerVariables.HOMUNCULUS_USED_VP_POINTS, 0);
			if (usedVpPoints < 2)
			{
				return;
			}
			int usedVpConverts = activeChar.getVarInt(PlayerVariables.HOMUNCULUS_USED_VP_CONVERT, 0);
			if (usedVpConverts >= 5)
			{
				return;
			}
			
			int upgradePoints = activeChar.getVarInt(PlayerVariables.HOMUNCULUS_UPGRADE_POINTS, 0) + 1;
			activeChar.setVar(PlayerVariables.HOMUNCULUS_UPGRADE_POINTS, upgradePoints);
			activeChar.setVar(PlayerVariables.HOMUNCULUS_USED_VP_POINTS, 0);
			activeChar.setVar(PlayerVariables.HOMUNCULUS_USED_VP_CONVERT, usedVpConverts + 1);
		}
		else if (_type == 2) // vitality consume
		{
			int usedVpPoints = activeChar.getVarInt(PlayerVariables.HOMUNCULUS_USED_VP_POINTS, 0);
			if (usedVpPoints >= 2)
			{
				return;
			}
			
			if (activeChar.getVitality() >= (Player.MAX_VITALITY_POINTS / 4))
			{
				activeChar.setVitality(activeChar.getVitality() - (Player.MAX_VITALITY_POINTS / 4));
				activeChar.setVar(PlayerVariables.HOMUNCULUS_USED_VP_POINTS, usedVpPoints + 1);
			}
		}
		
		if (_type == 2)
		{
			activeChar.sendPacket(new ExHomunculusHPSPVP(activeChar));
		}
		activeChar.sendPacket(new ExHomunculusPointInfo(activeChar));
		activeChar.sendPacket(new ExHomunculusGetEnchantPointResult(_type));
	}
}