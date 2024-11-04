package l2s.gameserver.network.l2.c2s.homunculus;

import l2s.gameserver.model.Player;
import l2s.gameserver.model.actor.variables.PlayerVariables;
import l2s.gameserver.network.l2.c2s.L2GameClientPacket;
import l2s.gameserver.network.l2.s2c.SystemMessage;
import l2s.gameserver.network.l2.s2c.homunculus.ExEnchantHomunculusSkillResult;
import l2s.gameserver.network.l2.s2c.homunculus.ExHomunculusHPSPVP;
import l2s.gameserver.network.l2.s2c.homunculus.ExHomunculusPointInfo;
import l2s.gameserver.network.l2.s2c.homunculus.ExShowHomunculusList;

/**
 * @author nexvill
 */
public class RequestExEnchantHomunculusSkill extends L2GameClientPacket
{
	private static final int SP_COST = 1_000_000_000;
	private int _slot, _skillNumber;
	
	@Override
	protected boolean readImpl()
	{
		readD();
		_slot = readD();
		_skillNumber = readD();
		return true;
	}

	@Override
	protected void runImpl()
	{
		Player activeChar = getClient().getActiveChar();
		if(activeChar == null)
			return;
		
		if (activeChar.getSp() < SP_COST)
		{
			return;
		}
		
		int points = activeChar.getVarInt(PlayerVariables.HOMUNCULUS_UPGRADE_POINTS, 0);
		if (points < 1)
		{
			activeChar.sendPacket(new SystemMessage(SystemMessage.NOT_ENOUGH_UPGRADE_POINTS));
			return;
		}
		else
		{
			activeChar.setVar(PlayerVariables.HOMUNCULUS_UPGRADE_POINTS, points - 1);
			activeChar.sendPacket(new ExEnchantHomunculusSkillResult(activeChar, _slot, _skillNumber));
			activeChar.sendPacket(new ExHomunculusHPSPVP(activeChar));
			activeChar.sendPacket(new ExShowHomunculusList(activeChar.getHomunculusList()));
			activeChar.sendPacket(new ExHomunculusPointInfo(activeChar));
		}
	}
}