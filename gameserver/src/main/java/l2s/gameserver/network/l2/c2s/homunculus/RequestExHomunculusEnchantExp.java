package l2s.gameserver.network.l2.c2s.homunculus;

import l2s.gameserver.model.Player;
import l2s.gameserver.model.actor.instances.player.Homunculus;
import l2s.gameserver.model.actor.variables.PlayerVariables;
import l2s.gameserver.network.l2.c2s.L2GameClientPacket;
import l2s.gameserver.network.l2.s2c.homunculus.ExHomunculusEnchantEXPResult;
import l2s.gameserver.network.l2.s2c.homunculus.ExHomunculusPointInfo;
import l2s.gameserver.network.l2.s2c.homunculus.ExShowHomunculusList;

/**
 * @author nexvill
 */
public class RequestExHomunculusEnchantExp extends L2GameClientPacket
{
	private static final int EXP_PER_POINT = 750;
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
		
		if (activeChar.getVarInt(PlayerVariables.HOMUNCULUS_UPGRADE_POINTS, 0) == 0)
		{
			activeChar.sendPacket(new ExHomunculusEnchantEXPResult(false, false));
		}
		else
		{
			int points = activeChar.getVarInt(PlayerVariables.HOMUNCULUS_UPGRADE_POINTS, 0) - 1;
			activeChar.setVar(PlayerVariables.HOMUNCULUS_UPGRADE_POINTS, points);
			Homunculus homunculus = activeChar.getHomunculusList().get(_slot);
			homunculus.setExp(homunculus.getExp() + EXP_PER_POINT);
			activeChar.sendPacket(new ExHomunculusPointInfo(activeChar));
			switch (homunculus.getLevel())
			{
				case 1:
				{
					if (homunculus.getExp() >= homunculus.getTemplate().getExpToLevel2())
					{
						homunculus.setLevel(2);
						activeChar.sendPacket(new ExHomunculusEnchantEXPResult(true, true));
					}
					else
					{
						activeChar.sendPacket(new ExHomunculusEnchantEXPResult(true, false));
					}
					break;
				}
				case 2:
				{
					if (homunculus.getExp() >= homunculus.getTemplate().getExpToLevel3())
					{
						homunculus.setLevel(3);
						activeChar.sendPacket(new ExHomunculusEnchantEXPResult(true, true));
					}
					else
					{
						activeChar.sendPacket(new ExHomunculusEnchantEXPResult(true, false));
					}
					break;
				}
				case 3:
				{
					if (homunculus.getExp() >= homunculus.getTemplate().getExpToLevel4())
					{
						homunculus.setLevel(4);
						activeChar.sendPacket(new ExHomunculusEnchantEXPResult(true, true));
					}
					else
					{
						activeChar.sendPacket(new ExHomunculusEnchantEXPResult(true, false));
					}
					break;
				}
				case 4:
				{
					if (homunculus.getExp() >= homunculus.getTemplate().getExpToLevel5())
					{
						homunculus.setLevel(5);
						activeChar.sendPacket(new ExHomunculusEnchantEXPResult(true, true));
					}
					else
					{
						activeChar.sendPacket(new ExHomunculusEnchantEXPResult(true, false));
					}
					break;
				}
			}
			activeChar.getHomunculusList().update(homunculus);
			activeChar.getHomunculusList().refreshStats(true);
			activeChar.sendPacket(new ExShowHomunculusList(activeChar.getHomunculusList()));
		}
	}
}