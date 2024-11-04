package l2s.gameserver.network.l2.c2s.homunculus;

import l2s.commons.util.Rnd;
import l2s.gameserver.data.xml.holder.HomunculusHolder;
import l2s.gameserver.model.Player;
import l2s.gameserver.model.actor.instances.player.Homunculus;
import l2s.gameserver.model.actor.variables.PlayerVariables;
import l2s.gameserver.network.l2.c2s.L2GameClientPacket;
import l2s.gameserver.network.l2.s2c.homunculus.ExHomunculusSummonResult;
import l2s.gameserver.network.l2.s2c.homunculus.ExShowHomunculusBirthInfo;
import l2s.gameserver.network.l2.s2c.homunculus.ExShowHomunculusList;
import l2s.gameserver.templates.HomunculusTemplate;

/**
 * @author nexvill
 */
public class RequestExHomunculusSummon extends L2GameClientPacket
{
	private static int _hpPoints, _spPoints, _vpPoints, _homunculusCreateTime;
	@Override
	protected boolean readImpl()
	{
		//readC(); // useless.
		return true;
	}

	@Override
	protected void runImpl()
	{
		Player activeChar = getClient().getActiveChar();
		if(activeChar == null)
			return;
		
		_hpPoints = activeChar.getVarInt(PlayerVariables.HOMUNCULUS_HP_POINTS, 0);
		_spPoints = activeChar.getVarInt(PlayerVariables.HOMUNCULUS_SP_POINTS, 0);
		_vpPoints = activeChar.getVarInt(PlayerVariables.HOMUNCULUS_VP_POINTS, 0);
		_homunculusCreateTime = (int) (activeChar.getVarLong(PlayerVariables.HOMUNCULUS_CREATION_TIME, 0) / 1000);
		
		if (_homunculusCreateTime > 0)
		{
			if (((System.currentTimeMillis() / 1000) >= _homunculusCreateTime) && (_hpPoints == 100) && (_spPoints == 10) && (_vpPoints == 5))
			{				
				int homunculusId = 0;
				int chance = Rnd.get(100);
				if (chance >= 60) // Basic Homunculus
				{
					int chance2 = Rnd.get(100);
					if (chance2 >= 80)
					{
						homunculusId = 1;
					}
					else if (chance2 >= 60)
					{
						homunculusId = 4;
					}
					else if (chance2 >= 40)
					{
						homunculusId = 7;
					}
					else if (chance2 >= 20)
					{
						homunculusId = 10;
					}
					else
					{
						homunculusId = 13;
					}
				}
				else if (chance >= 10) // Water Homunculus
				{
					int chance2 = Rnd.get(100);
					if (chance2 >= 80)
					{
						homunculusId = 2;
					}
					else if (chance2 >= 60)
					{
						homunculusId = 5;
					}
					else if (chance2 >= 40)
					{
						homunculusId = 8;
					}
					else if (chance2 >= 20)
					{
						homunculusId = 11;
					}
					else
					{
						homunculusId = 14;
					}
				}
				else // Luminous Homunculus
				{
					int chance2 = Rnd.get(100);
					if (chance2 >= 80)
					{
						homunculusId = 3;
					}
					else if (chance2 >= 60)
					{
						homunculusId = 6;
					}
					else if (chance2 >= 40)
					{
						homunculusId = 9;
					}
					else if (chance2 >= 20)
					{
						homunculusId = 12;
					}
					else
					{
						homunculusId = 15;
					}
				}
				
				HomunculusTemplate template = HomunculusHolder.getInstance().getHomunculusInfo(homunculusId);
				Homunculus homunculus = new Homunculus(template, activeChar.getHomunculusList().size(), 1, 0, 0, 0, 0, 0, 0, false);
				if (activeChar.getHomunculusList().add(homunculus))
				{
					activeChar.setVar(PlayerVariables.HOMUNCULUS_CREATION_TIME, 0);
					activeChar.setVar(PlayerVariables.HOMUNCULUS_HP_POINTS, 0);
					activeChar.setVar(PlayerVariables.HOMUNCULUS_SP_POINTS, 0);
					activeChar.setVar(PlayerVariables.HOMUNCULUS_VP_POINTS, 0);
					
					activeChar.sendPacket(new ExShowHomunculusBirthInfo(activeChar));
					activeChar.sendPacket(new ExShowHomunculusList(activeChar.getHomunculusList()));
					activeChar.sendPacket(new ExHomunculusSummonResult());
				}
			}
		}
	}
}