package handler.admincommands;

import l2s.gameserver.data.htm.HtmCache;
import l2s.gameserver.data.htm.HtmTemplates;
import l2s.gameserver.data.xml.holder.EventHolder;
import l2s.gameserver.model.GameObject;
import l2s.gameserver.model.GameObjectsStorage;
import l2s.gameserver.model.Player;
import l2s.gameserver.model.entity.events.Event;
import l2s.gameserver.model.entity.events.EventType;
import l2s.gameserver.model.entity.events.fightclubmanager.FightClubEventManager;
import l2s.gameserver.model.entity.events.impl.AbstractFightClub;
import l2s.gameserver.network.l2.components.HtmlMessage;
import l2s.gameserver.network.l2.components.SystemMsg;

import java.util.List;

/**
 * @author VISTALL
 * @date 18:45/07.06.2011
 */
public class AdminEvent extends ScriptAdminCommand
{
	enum Commands
	{
		admin_events,
		admin_list_events,
		admin_start_event,
		admin_stop_event
	}
	@Override
	public boolean useAdminCommand(Enum<?> comm, String[] wordList, String fullString, Player activeChar)
	{
		Commands c = (Commands)comm;
		switch(c)
		{
			case admin_events:
				if(wordList.length == 1)
					showEventsList(activeChar);
				else
					activeChar.sendPacket(new HtmlMessage(5).setFile("admin/events/" + wordList[1].trim()));
				break;
			case admin_start_event:
			case admin_stop_event:
				if(wordList.length < 3)
				{
					activeChar.sendMessage("USAGE://" + wordList[0] + " TYPE[normal|pvp|fc] ID");
					return false;
				}
				try
				{
					boolean pvp = wordList[1].equalsIgnoreCase("pvp");
					boolean fc = wordList[1].equalsIgnoreCase("fc");
					int id = Integer.parseInt(wordList[2]);
					boolean isScheduled = wordList.length > 3;

					Event event = EventHolder.getInstance().getEvent(fc ? EventType.FIGHT_CLUB_EVENT : pvp ? EventType.CUSTOM_PVP_EVENT : EventType.MAIN_EVENT, id);
					if(comm == Commands.admin_start_event)
					{
						if (fc) {
							if (isScheduled) {
								FightClubEventManager.getInstance().startEventCountdown((AbstractFightClub) event);
							} else {
								FightClubEventManager.getInstance().startEventForce((AbstractFightClub) event);
							}
							for (Player player : GameObjectsStorage.getPlayers(false, false)) {
								FightClubEventManager.getInstance().trySignForEvent(player, (AbstractFightClub) event, true);
							}
						} else if(event.forceScheduleEvent())
							activeChar.sendMessage("Started event: " + event.getName());
						else
							activeChar.sendMessage("Cannot start event: " + event.getName());
					}
					else
					{
						if (fc)
							FightClubEventManager.getInstance().stopAllEvents((AbstractFightClub) event);
						else if(event.forceCancelEvent())
							activeChar.sendMessage("Stopped event: " + event.getName());
						else
							activeChar.sendMessage("Cannot stop event: " + event.getName());
					}
					showEventsList(activeChar);
				}
				catch(NumberFormatException e)
				{
					activeChar.sendMessage("USAGE://" + wordList[0] + " TYPE[normal|pvp|fc]  ID");
					return false;
				}
				break;
			case admin_list_events:
				GameObject object = activeChar.getTarget();
				if(object == null)
					activeChar.sendPacket(SystemMsg.INVALID_TARGET);
				else
				{
					for(Event e : object.getEvents())
						activeChar.sendMessage("- " + e.toString());
				}
				break;
		}
		return false;
	}

	@Override
	public Enum<?>[] getAdminCommandEnum()
	{
		return Commands.values();
	}

	private void showEventsList(Player activeChar)
	{
		final HtmTemplates tpls = HtmCache.getInstance().getTemplates("admin/events/events.htm", activeChar);

		String html = tpls.get(0);

		final String eventBlock = tpls.get(1);
		final String startButton = tpls.get(2);
		final String stopButton = tpls.get(3);

		StringBuilder eventsList =  new StringBuilder();
		List<AbstractFightClub> events = EventHolder.getInstance().getEvents(EventType.FIGHT_CLUB_EVENT);
		for(AbstractFightClub event : events) {
			AbstractFightClub activeEvent = FightClubEventManager.getInstance().getFirstActiveEventByType(event);
			boolean isScheduled = activeEvent != null;

			String block = eventBlock;
			block = block.replace("<?event_name?>", event.getName());
			String button = event.isForceScheduled() || event.isInProgress() || isScheduled ? stopButton : startButton;
			button = button.replace("<?event_id?>", String.valueOf(event.getId()));
			block = block.replace("<?button?>", button);
			eventsList.append(block);
		}
		html = html.replace("<?fc_events_list?>", eventsList.toString());

		final String startPvPButton = tpls.get(4);
		final String stopPvPButton = tpls.get(5);

		eventsList = new StringBuilder();
		events = EventHolder.getInstance().getEvents(EventType.CUSTOM_PVP_EVENT);
		for(Event event : events)
		{
			String block = eventBlock;
			block = block.replace("<?event_name?>", event.getName());

			String button = event.isForceScheduled() || event.isInProgress() ? stopPvPButton : startPvPButton;
			button = button.replace("<?event_id?>", String.valueOf(event.getId()));

			block = block.replace("<?button?>", button);

			eventsList.append(block);
		}

		html = html.replace("<?pvp_events_list?>", eventsList.toString());

		final String startMainButton = tpls.get(6);
		final String stopMainButton = tpls.get(7);

		eventsList = new StringBuilder();
		events = EventHolder.getInstance().getEvents(EventType.MAIN_EVENT);
		for(Event mainEvent : events)
		{
			String block = eventBlock;
			block = block.replace("<?event_name?>", mainEvent.getName());

			String button = mainEvent.isForceScheduled() || mainEvent.isInProgress() ? stopMainButton : startMainButton;
			button = button.replace("<?event_id?>", String.valueOf(mainEvent.getId()));

			block = block.replace("<?button?>", button);

			eventsList.append(block);
		}

		html = html.replace("<?main_events_list?>", eventsList.toString());
		activeChar.sendPacket(new HtmlMessage(5).setHtml(html));
	}
}
