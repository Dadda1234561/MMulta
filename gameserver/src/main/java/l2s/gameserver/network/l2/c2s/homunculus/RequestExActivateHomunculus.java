package l2s.gameserver.network.l2.c2s.homunculus;

import l2s.gameserver.model.Player;
import l2s.gameserver.model.actor.instances.player.Homunculus;
import l2s.gameserver.network.l2.c2s.L2GameClientPacket;
import l2s.gameserver.network.l2.s2c.homunculus.ExActivateHomunculusResult;
import l2s.gameserver.network.l2.s2c.homunculus.ExShowHomunculusList;

/**
 * @author nexvill
 */
public class RequestExActivateHomunculus extends L2GameClientPacket
{
	private int _slot;
	private boolean _activate;
	@Override
	protected boolean readImpl()
	{
		_slot = readD();
		_activate = readC() == 1;
		return true;
	}

	@Override
	protected void runImpl()
	{
		Player activeChar = getClient().getActiveChar();
		if(activeChar == null)
			return;
		
		Homunculus homunculus = activeChar.getHomunculusList().get(_slot);
		boolean anotherActive = false;
		int size = activeChar.getHomunculusList().size();
		if (size > 1)
		{
			if (_slot == 0)
			{
				if (activeChar.getHomunculusList().get(1).isActive() || activeChar.getHomunculusList().get(2).isActive())
				{
					anotherActive = true;
				}
			}
			else if (_slot == 1)
			{
				if (activeChar.getHomunculusList().get(0).isActive() || activeChar.getHomunculusList().get(2).isActive())
				{
					anotherActive = true;
				}
			}
			else
			{
				if (activeChar.getHomunculusList().get(0).isActive() || activeChar.getHomunculusList().get(1).isActive())
				{
					anotherActive = true;
				}
			}
		}
		
		if (anotherActive)
		{
			return;
		}
		else
		{
			if (!homunculus.isActive() && _activate)
			{
				homunculus.setActive(true);
				activeChar.getHomunculusList().update(homunculus);
				activeChar.getHomunculusList().refreshStats(true);
				activeChar.sendPacket(new ExShowHomunculusList(activeChar.getHomunculusList()));
				activeChar.sendPacket(new ExActivateHomunculusResult(true));
			}
			else if (homunculus.isActive() && !_activate)
			{
				homunculus.setActive(false);
				activeChar.getHomunculusList().update(homunculus);
				activeChar.getHomunculusList().refreshStats(true);
				activeChar.sendPacket(new ExShowHomunculusList(activeChar.getHomunculusList()));
				activeChar.sendPacket(new ExActivateHomunculusResult(false));
			}
		}
	}
}