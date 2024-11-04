package l2s.gameserver.network.l2.c2s;

import l2s.gameserver.model.Player;
import l2s.gameserver.model.base.ClassId;
import l2s.gameserver.model.base.ClassLevel;
import l2s.gameserver.model.base.Race;
import l2s.gameserver.network.l2.components.NpcString;
import l2s.gameserver.network.l2.s2c.ExShowScreenMessage;

public class RequestCallToChangeClass extends L2GameClientPacket
{
	@Override
	protected boolean readImpl()
	{
		//Trigger
		return true;
	}

	@Override
	protected void runImpl()
	{
		Player activeChar = getClient().getActiveChar();
		if(activeChar == null)
			return;

		if(activeChar.getClassId().isOfRace(Race.ERTHEIA))
			return;

		if(activeChar.getVarBoolean("GermunkusUSM"))
			return;

		if(activeChar.isDead())
		{
			activeChar.sendPacket(new ExShowScreenMessage(NpcString.YOU_CANNOT_TELEPORT_WHILE_YOU_ARE_DEAD, 10000, ExShowScreenMessage.ScreenMessageAlign.TOP_CENTER, false));
			activeChar.processQuestEvent(10338, "hermunkus_call_repeat", null);
			return;
		}

		activeChar.processQuestEvent(10338, "hermunkus_call_process", null);
	}
}