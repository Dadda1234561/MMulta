package l2s.gameserver.network.l2.c2s.homunculus;

import l2s.gameserver.model.Player;
import l2s.gameserver.model.actor.variables.PlayerVariables;
import l2s.gameserver.network.l2.c2s.L2GameClientPacket;
import l2s.gameserver.network.l2.s2c.homunculus.ExHomunculusHPSPVP;
import l2s.gameserver.network.l2.s2c.homunculus.ExHomunculusInsertResult;
import l2s.gameserver.network.l2.s2c.homunculus.ExShowHomunculusBirthInfo;

/**
 * @author nexvill
 */
public class RequestExHomunculusInsert extends L2GameClientPacket
{
	private static final short _hpCost = 10000;
	private static final long _spCost = 5_000_000_000L;
	private static final int _vpCost = Player.MAX_VITALITY_POINTS / 4;
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
		int hpPoints = activeChar.getVarInt(PlayerVariables.HOMUNCULUS_HP_POINTS, 0);
		int spPoints = activeChar.getVarInt(PlayerVariables.HOMUNCULUS_SP_POINTS, 0);
		int vpPoints = activeChar.getVarInt(PlayerVariables.HOMUNCULUS_VP_POINTS, 0);
		switch (_type)
		{
			case 0:
			{
				if ((activeChar.getCurrentHp() > _hpCost) && (hpPoints < 100))
				{
					int newHp = (int) (activeChar.getCurrentHp()) - _hpCost;
					activeChar.setCurrentHp(newHp, false, true);
					hpPoints += 1;
					activeChar.setVar(PlayerVariables.HOMUNCULUS_HP_POINTS, hpPoints);
				}
				else
					return;
				break;
			}
			case 1:
			{
				if ((activeChar.getSp() >= _spCost) && (spPoints < 10))
				{
					activeChar.addExpAndSp(0, -_spCost);
					spPoints += 1;
					activeChar.setVar(PlayerVariables.HOMUNCULUS_SP_POINTS, spPoints);
				}
				else {
					activeChar.sendPacket(new ExHomunculusInsertResult(false, _type));
					return;
				}
				break;
			}
			case 2:
			{
				if ((activeChar.getVitality() >= _vpCost) && (vpPoints < 5))
				{
					int newVitality = activeChar.getVitality() - _vpCost;
					activeChar.setVitality(newVitality, true);
					vpPoints += 1;
					activeChar.setVar(PlayerVariables.HOMUNCULUS_VP_POINTS, vpPoints);
				}
				else
					return;
				break;
			}
		}
		activeChar.sendPacket(new ExShowHomunculusBirthInfo(activeChar));
		activeChar.sendPacket(new ExHomunculusHPSPVP(activeChar));
		activeChar.sendPacket(new ExHomunculusInsertResult(_type));
	}
}