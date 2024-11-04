package l2s.gameserver.network.l2.c2s;

import l2s.gameserver.data.xml.holder.EventHolder;
import l2s.gameserver.model.Player;
import l2s.gameserver.model.entity.events.EventType;
import l2s.gameserver.model.entity.events.impl.ChaosFestivalEvent;

/**
 * @author Bonux
**/
public class RequestObservingCuriousHouse extends L2GameClientPacket
{
	private int _arenaId;

	@Override
	protected boolean readImpl()
	{
		_arenaId = readD();
		return true;
	}

	@Override
	protected void runImpl()
	{
		Player activeChar = getClient().getActiveChar();
		if(activeChar == null)
			return;

		ChaosFestivalEvent event = EventHolder.getInstance().getEvent(EventType.PVP_EVENT, 6);
		if(event == null)
			return;

		event.addObserver(_arenaId, activeChar);
	}
}

