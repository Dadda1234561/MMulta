package l2s.gameserver.network.l2.c2s.homunculus;

import l2s.gameserver.model.Player;
import l2s.gameserver.network.l2.c2s.L2GameClientPacket;
import l2s.gameserver.network.l2.s2c.homunculus.ExHomunculusPointInfo;
import l2s.gameserver.network.l2.s2c.homunculus.ExShowHomunculusBirthInfo;
import l2s.gameserver.network.l2.s2c.homunculus.ExShowHomunculusList;

/**
 * @author nexvill
 */
public class RequestExShowHomunculusInfo extends L2GameClientPacket
{
	private int _type; //0 - create tab, 1 - manage tab, 2 - get upgrade points menu
	
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
		
		switch (_type)
		{
			case 0:
			{
				activeChar.sendPacket(new ExShowHomunculusBirthInfo(activeChar));
				break;
			}
			case 1:
			{
				activeChar.sendPacket(new ExShowHomunculusList(activeChar.getHomunculusList()));
				break;
			}
			case 2:
			{
				activeChar.sendPacket(new ExHomunculusPointInfo(activeChar));
				break;
			}
		}
	}
}