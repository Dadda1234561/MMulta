package l2s.gameserver.model.entity.events.fightclubmanager;

import java.lang.reflect.Constructor;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import java.util.StringTokenizer;
import java.util.concurrent.ConcurrentHashMap;
import java.util.concurrent.CopyOnWriteArrayList;
import java.util.concurrent.atomic.AtomicInteger;

import l2s.gameserver.network.l2.components.CustomMessage;
import l2s.gameserver.network.l2.s2c.*;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import l2s.commons.collections.MultiValueSet;
import l2s.commons.util.Rnd;
import l2s.gameserver.ThreadPoolManager;
import l2s.gameserver.data.xml.holder.EventHolder;
import l2s.gameserver.geometry.Location;
import l2s.gameserver.listener.actor.player.OnAnswerListener;
import l2s.gameserver.model.GameObjectsStorage;
import l2s.gameserver.model.Player;
import l2s.gameserver.model.entity.events.EventType;
import l2s.gameserver.model.entity.events.impl.AbstractFightClub;
import l2s.gameserver.model.entity.olympiad.Olympiad;
import l2s.gameserver.network.l2.components.ChatType;
import l2s.gameserver.network.l2.components.SystemMsg;

public class FightClubEventManager
{
	private static final Logger _log = LoggerFactory.getLogger(FightClubEventManager.class);

	public static final Location RETURN_LOC = new Location(83208, 147672, -3494, 0);
	public static final String ENTER_LOC_VAR_NAME = "EVENT_ENTER_LOC";
	public static final int FIGHT_CLUB_BADGE_ID = 6673;
	public static final String BYPASS = "_fightclub";
	private Map<Integer, AbstractFightClub> _activeEvents = new ConcurrentHashMap<Integer, AbstractFightClub>();
	private List<FightClubGameRoom> _rooms = new CopyOnWriteArrayList<FightClubGameRoom>();
	private boolean _shutDown = false;
	private AbstractFightClub _nextEvent = null;
	private static Map<Integer, String> boxes = new LinkedHashMap<Integer, String>();

	public FightClubEventManager()
	{
		startAutoEventsTasks();
	}

	public boolean serverShuttingDown()
	{
		return _shutDown;
	}

	public void signForEvent(Player player, AbstractFightClub event)
	{
		FightClubGameRoom roomFound = null;
		for (FightClubGameRoom room : getEventRooms(event))
		{
			if (room.getSlotsLeft() > 0)
			{
				roomFound = room;
				break;
			}
		}

		if (roomFound == null)
		{
			AbstractFightClub duplicatedEvent = prepareNewEvent(event);
			roomFound = createRoom(duplicatedEvent);
		}

		roomFound.addAlonePlayer(player);
		player.setVar(FightClubEventManager.ENTER_LOC_VAR_NAME, player.getLoc().clone().toXYZString());
		player.sendMessage("You just participated to " + event.getName() + " Event!");
	}

	public void trySignForEvent(Player player, AbstractFightClub event, boolean checkConditions)
	{
		if (checkConditions && !canPlayerParticipate(player, true, false))
		{
			return;
		}

		if (!isRegistrationOpened(event))
		{
			player.sendMessage("You cannot participate in " + event.getName() + " right now!");
		}
		else if (isPlayerRegistered(player))
		{
			player.sendPacket(new SystemMessage(SystemMessage.YOU_HAVE_REGISTER_FOR_THE_CAPTURE_THE_FLAG_EVENT));
		}
		else
		{
			signForEvent(player, event);
		}
	}

	public void unsignFromEvent(Player player)
	{
		for (FightClubGameRoom room : _rooms)
		{
			if (room.containsPlayer(player))
			{
				room.leaveRoom(player);
			}
		}
		boxes.remove(Integer.valueOf(player.getObjectId()));
		player.unsetVar(ENTER_LOC_VAR_NAME);
		player.sendPacket(new SystemMessage(SystemMessage.YOU_HAVE_CANCELED_YOUR_REGISTRATION_FOR_THE_CAPTURE_THE_FLAG_EVENT));
	}

	public boolean isRegistrationOpened(AbstractFightClub event)
	{
		for (FightClubGameRoom room : _rooms)
		{
			if (room.getGame() != null && room.getGame().getEventId() == event.getEventId())
			{
				return true;
			}
		}
		return false;
	}

	public boolean isPlayerRegistered(Player player)
	{
		if (player.isInFightClub())
		{
			return true;
		}

		for (FightClubGameRoom room : _rooms)
		{
			for (Player iPlayer : room.getAllPlayers())
			{
				if (iPlayer.equals(player))
					return true;
			}
		}
		return false;
	}

	public void stopAllEvents(AbstractFightClub eventType)
	{
		for (AbstractFightClub event : _activeEvents.values()) {
			if (event.getClass().getSimpleName().equals(eventType.getClass().getSimpleName())) {
				event.stopEvent(true);
			}
		}
	}

	public void stopEventForce(AbstractFightClub event) {
		final int eventObjectId = event.getObjectId();
		FightClubLastStatsManager.getInstance().clearStats();
		if (getNextEvent() != null) {
			getNextEvent().stopEvent(true);
		}
	}

	public void startEventForce(AbstractFightClub event)
	{
		FightClubLastStatsManager.getInstance().clearStats();
		final AbstractFightClub duplicatedEvent = prepareNewEvent(event);
		_nextEvent = duplicatedEvent;

		createRoom(duplicatedEvent);
		FightClubEventManager.this.notifyConditions(duplicatedEvent);
		ThreadPoolManager.getInstance().schedule(() -> sendEventInvitations(duplicatedEvent), 5000L);
		sendToAllMsg(duplicatedEvent, duplicatedEvent.getName() + " Event Started!");
		// start event after 30 seconds (time to join)
		event.initEvent();
		ThreadPoolManager.getInstance().schedule(() -> FightClubEventManager.this.startEvent(duplicatedEvent), 5 * 60 * 1000L);
	}


	public void startEventCountdown(AbstractFightClub event)
	{
		FightClubLastStatsManager.getInstance().clearStats();
		_nextEvent = event;
		final AbstractFightClub duplicatedEvent = prepareNewEvent(event);

		createRoom(duplicatedEvent);
		sendToAllMsg(duplicatedEvent, new CustomMessage("l2s.gameserver.model.entity.events.impl.PvPEvent.registration.start").addString(event.getName())); // ДП.
		if (event.getRebirthCnt() > 0)
			sendToAllMsg(duplicatedEvent, new CustomMessage("l2s.gameserver.model.entity.events.impl.PvPEvent.registration.minRebirths").addNumber(event.getRebirthCnt()));
		sendEventInvitations(duplicatedEvent);
		duplicatedEvent.scheduleRegisterAnnounces();
	}

	private void notifyConditions(AbstractFightClub event)
	{
		for (FightClubGameRoom room : getEventRooms(event))
		{
			for (Player player : room.getAllPlayers())
			{
				canPlayerParticipate(player, true, false);
			}
		}
	}

	public void startEvent(AbstractFightClub event)
	{
		List<FightClubGameRoom> eventRooms = getEventRooms(event);
		equalizeRooms(eventRooms);
		for (FightClubGameRoom room : eventRooms)
		{
			_rooms.remove(room);
			if (room.getPlayersCount() < 2)
			{
				_log.info(event.getName() + ": Removing room because it doesnt have enough players");
				_log.info(event.getName() + ": Player Counts: " + room.getPlayersCount());
				continue;
			}
			room.getGame().prepareEvent(room);
		}
	}

	private void equalizeRooms(List<FightClubGameRoom> eventRooms)
	{
		double players = 0.0;
		for (FightClubGameRoom room : eventRooms)
		{
			players += room.getPlayersCount();
		}

		final double average = players / eventRooms.size();
		final List<Player> playersToChange = new ArrayList<Player>();

		for (FightClubGameRoom room : eventRooms)
		{
			final int before = room.getPlayersCount();
			final int toRemove = room.getPlayersCount() - (int) Math.ceil(average);
			for (int i = 0; i < toRemove; i++)
			{
				final Player player = room.getAllPlayers().iterator().next();
				room.leaveRoom(player);
				playersToChange.add(player);
			}
			_log.info("Equalizing FC Room, before:" + before + " toRemove:" + toRemove + " after:" + room.getPlayersCount() + " to Change:" + playersToChange.size());
		}

		for (FightClubGameRoom room : eventRooms)
		{
			final int before = room.getPlayersCount();
			final int toAdd = Math.min((int) Math.floor(average) - before, playersToChange.size());

			for (int i = 0; i < toAdd; i++)
			{
				final Player player = playersToChange.remove(0);
				room.addAlonePlayer(player);
			}
			_log.info("Equalizing FC Room, Before: " + before + " Final:" + room.getPlayersCount());
		}
	}

	private List<FightClubGameRoom> getEventRooms(AbstractFightClub event)
	{
		final List<FightClubGameRoom> eventRooms = new ArrayList<FightClubGameRoom>();
		for (FightClubGameRoom room : _rooms)
		{
			if (room.getGame() != null && room.getGame().getEventId() == event.getEventId())
			{
				eventRooms.add(room);
			}
		}
		return eventRooms;
	}

	private void sendEventInvitations(AbstractFightClub event)
	{
		// invites are disabled for this event
		if(!event.isSendInvites()) {
			return;
		}

		for (Player player : GameObjectsStorage.getPlayers(false, false)) {
			if (player.getFightClubGameRoom() != null || player.getFightClubEvent() != null) {
				continue;
			}
			if (player.getLevel() > event.getMaxLevel()) {
				continue;
			}
			if (player.getLevel() < event.getMinLevel()) {
				continue;
			}
			if (player.getRebirthCount() < event.getRebirthCnt()) {
				continue;
			}

			// individual message for each player
			String messageString = new CustomMessage("scripts.events.AskPlayer").addString(event.getName()).toString(player);
			// check if player can participate and if he is not already in event
			if (canPlayerParticipate(player, false, true) && player.getEvent(AbstractFightClub.class) == null) {
				// ask player to join event
				player.ask(new ConfirmDlgPacket(SystemMsg.S1, 300000).addString(messageString), new AnswerEventInvitation(player, event));
			}
		}
	}

	public FightClubGameRoom createRoom(AbstractFightClub event)
	{
		FightClubGameRoom newRoom = new FightClubGameRoom(event);
		_rooms.add(newRoom);
		return newRoom;
	}

	public AbstractFightClub getNextEvent()
	{
		return _nextEvent;
	}

	public AbstractFightClub getFirstActiveEventByType(AbstractFightClub eventType) {
		for (AbstractFightClub abstractFightClub : _activeEvents.values()) {
			if (abstractFightClub.getClass().getSimpleName().equals(eventType.getClass().getSimpleName())) {
				return abstractFightClub;
			}
		}

		return null;
	}

	private void sendErrorMessageToPlayer(Player player, String msg)
	{
		player.sendPacket(new SayPacket2(player.getObjectId(), ChatType.COMMANDCHANNEL_ALL, "Error", msg));
		player.sendMessage(msg);
	}

	public void sendToAllMsg(String msg, String eventName)
	{
		SayPacket2 packet = new SayPacket2(0, ChatType.ANNOUNCEMENT, eventName, msg);
		for (Player player : GameObjectsStorage.getAllPlayersForIterate())
		{
			player.sendPacket(packet);
		}
	}

	public void sendToAllMsg(AbstractFightClub event, String msg)
	{
		SayPacket2 packet = new SayPacket2(0, ChatType.ANNOUNCEMENT, event.getName(), msg);
		for (Player player : GameObjectsStorage.getAllPlayersForIterate())
		{
			player.sendPacket(packet);
		}
	}

	public void sendToAllRegisteredScreenMessage(AbstractFightClub event, CustomMessage msg)
	{
		for (FightClubPlayer fightClubPlayer : event.getPlayers(AbstractFightClub.REGISTERED_PLAYERS))
		{
			fightClubPlayer.getPlayer().sendPacket(new ExShowScreenMessage(msg.toString(fightClubPlayer.getPlayer()), 1000, ExShowScreenMessage.ScreenMessageAlign.TOP_CENTER, false));
		}
	}

	public void sendToAllMsg(AbstractFightClub event, CustomMessage msg)
	{
		for (Player player : GameObjectsStorage.getAllPlayersForIterate())
		{
			player.sendPacket(new SayPacket2(0, ChatType.ANNOUNCEMENT, event.getName(), msg.toString(player)));
		}
	}

	private AbstractFightClub prepareNewEvent(AbstractFightClub event)
	{
		MultiValueSet<String> set = event.getSet();
		AbstractFightClub duplicatedEvent = null;
		try
		{
			Class<?> eventClass = Class.forName(set.getString("eventClass"));
			Constructor<?> constructor = eventClass.getConstructor(MultiValueSet.class);
			duplicatedEvent = (AbstractFightClub) constructor.newInstance(set);

			duplicatedEvent.clearSet();

			_activeEvents.put(Integer.valueOf(duplicatedEvent.getObjectId()), duplicatedEvent);
		}
		catch (Exception e)
		{
			e.printStackTrace();
		}

		return duplicatedEvent;
	}


	public Map<Integer, AbstractFightClub> getActiveEvents()
	{
		return _activeEvents;
	}

	public void addActiveEvent(AbstractFightClub event) {
		if (!_activeEvents.containsKey(event.getObjectId())) {
			_activeEvents.put(event.getObjectId(), event);
		}
	}

	public void removeActiveEvent(AbstractFightClub event) {
		_activeEvents.remove(event.getObjectId());
		if (_nextEvent != null && _nextEvent.getObjectId() == event.getObjectId()) {
			_nextEvent = null;
		}
	}

	private void startAutoEventsTasks()
	{
		AbstractFightClub closestEvent = null;
		long closestEventTime = Long.MAX_VALUE;

		for (int i = 1; i <= EventHolder.FIGHT_CLUB_EVENTS; i++)
		{
			AbstractFightClub event = (AbstractFightClub) EventHolder.getInstance().getEvent(EventType.FIGHT_CLUB_EVENT, i);
			if (!event.isAutoTimed())
			{
				continue;
			}

			Calendar nextEventDate = getClosestEventDate(event.getAutoStartTimes());

			event.printScheduledTime(nextEventDate.getTimeInMillis());
			ThreadPoolManager.getInstance().schedule(new EventRunThread(event), nextEventDate.getTimeInMillis() - System.currentTimeMillis());

			if (closestEventTime > nextEventDate.getTimeInMillis())
			{
				closestEvent = event;
				closestEventTime = nextEventDate.getTimeInMillis();
			}
		}

		_nextEvent = closestEvent;
	}

	private Calendar getClosestEventDate(int[][] dates)
	{
		final Calendar currentTime = Calendar.getInstance();
		Calendar nextStartTime = null;
		Calendar testStartTime = null;

		for (final int[] hourMin : dates)
		{
			if (hourMin[0] == -1 && hourMin[1] == -1)
			{
				nextStartTime = Calendar.getInstance();
				nextStartTime.setLenient(true);
				nextStartTime.add(Calendar.MINUTE, Rnd.get(1, 5));
				return nextStartTime;
			}
			else
			{
				testStartTime = Calendar.getInstance();
				testStartTime.setLenient(true);
				testStartTime.set(Calendar.HOUR_OF_DAY, hourMin[0]);
				testStartTime.set(Calendar.MINUTE, hourMin[1]);

				if (testStartTime.getTimeInMillis() < currentTime.getTimeInMillis())
				{
					testStartTime.add(Calendar.DAY_OF_MONTH, 1);
				}

				if (nextStartTime == null || testStartTime.getTimeInMillis() < nextStartTime.getTimeInMillis())
				{
					nextStartTime = testStartTime;
				}
			}
		}
		return nextStartTime;
	}

	public boolean canPlayerParticipate(Player player, boolean sendMessage, boolean justMostImportant)
	{
		if (player == null)
		{
			return false;
		}

		// Если профа ниже 2-й, то не пускаем
		if (player.getClassId().getClassLevel().ordinal() < 2)
		{
			sendErrorMessageToPlayer(player, "Your class is too weak for the Fight Club!");
			return false;
		}

		if (Olympiad.isRegistered(player))
		{
			if (sendMessage)
				sendErrorMessageToPlayer(player, "Players registered to Olympiad Match may not participate in Fight Club!");
			return false;
		}

		if (player.isInOlympiadMode() || player.getOlympiadGame() != null)
		{
			if (sendMessage)
				sendErrorMessageToPlayer(player, "Players fighting in Olympiad Match may not participate in Fight Club!");
			return false;
		}

		if (player.isInObserverMode())
		{
			if (sendMessage)
				sendErrorMessageToPlayer(player, "Players in Observation mode may not participate in Fight Club!");
			return false;
		}

		if (!justMostImportant)
		{
			if (player.isDead() || player.isAlikeDead())
			{
				if (sendMessage)
					sendErrorMessageToPlayer(player, "Dead players may not participate in Fight Club!");
				return false;
			}

			if (player.isBlocked())
			{
				if (sendMessage)
					sendErrorMessageToPlayer(player, "Blocked players may not participate in Fight Club!");
				return false;
			}

			/*if (!player.isInPeaceZone() && player.getPvpFlag() > 0)
			{
				if (sendMessage)
					sendErrorMessageToPlayer(player, "Players in PvP Battle may not participate in Fight Club!");
				return false;
			}*/

			/*if (player.isInCombat())
			{
				if (sendMessage)
					sendErrorMessageToPlayer(player, "Players in Combat may not participate in Fight Club Battle!");
				return false;
			}*/

			/*if (player.getEvent(DuelEvent.class) != null)
			{
				if (sendMessage)
					sendErrorMessageToPlayer(player, "Players engaged in Duel may not participate in Fight Club Battle!");
				return false;
			}*/

			/*if (player.getKarma() > 0)
			{
				if (sendMessage)
					sendErrorMessageToPlayer(player, "Chaotic players may not participate in Fight Club!");
				return false;
			}*/

			if (player.isInOfflineMode())
			{
				if (sendMessage)
					sendErrorMessageToPlayer(player, "Players in Offline mode may not participate in Fight Club!");
				return false;
			}

			if (player.isInStoreMode())
			{
				if (sendMessage)
					sendErrorMessageToPlayer(player, "Players in Store mode may not participate in Fight Club!");
				return false;
			}
		}

		return true;
	}

	public void requestEventPlayerMenuBypass(Player player, String bypass)
	{
		player.sendPacket(TutorialCloseHtmlPacket.STATIC);
		
		final AbstractFightClub event = player.getFightClubEvent();		
		if (event == null)
		{
			return;
		}
		
		final FightClubPlayer fPlayer = event.getFightClubPlayer(player);
		if (fPlayer == null)
		{
			return;
		}

		fPlayer.setShowTutorial(false);
		if (!bypass.startsWith(BYPASS))
		{
			return;
		}
		StringTokenizer st = new StringTokenizer(bypass, " ");
		st.nextToken();

		String action = st.nextToken();
		String str1 = action;
		int i = -1;

		switch (str1.hashCode())
		{
			case 102846135:
				if (!str1.equals("leave"))
					break;
				i = 0;
				break;
		}

		switch (i)
		{
			case 0:
				askQuestion(player, "Are you sure You want to leave the event?"); // TODO: Вынести в ДП.
				break;
		}
	}

	public void sendEventPlayerMenu(Player player)
	{
		AbstractFightClub event = player.getFightClubEvent();
		if (event == null || event.getFightClubPlayer(player) == null)
		{
			return;
		}

		FightClubPlayer fPlayer = event.getFightClubPlayer(player);
		fPlayer.setShowTutorial(true);

		StringBuilder builder = new StringBuilder();
		builder.append("<html><head><title>").append(event.getName()).append("</title></head>");
		builder.append("<body>");
		builder.append("<br1><img src=\"L2UI.squaregray\" width=\"290\" height=\"1\">");
		builder.append("<table height=20 fixwidth=\"290\" bgcolor=29241d>");
		builder.append("\t<tr>");
		builder.append("\t\t<td height=20 width=290>");
		builder.append("\t\t\t<center><font name=\"hs12\" color=913d3d>").append(event.getName()).append("</font></center>");
		builder.append("\t\t</td>");
		builder.append("\t</tr>");
		builder.append("</table>");
		builder.append("<br1><img src=\"L2UI.squaregray\" width=\"290\" height=\"1\">");
		builder.append("<br>");
		builder.append("<table fixwidth=290 bgcolor=29241d>");
		builder.append("\t<tr>");
		builder.append("\t\t<td valign=top width=280>");
		builder.append("\t\t\t<font color=388344>").append(event.getDescription(player.getLanguage())).append("<br></font>");
		builder.append("\t\t</td>");
		builder.append("\t</tr>");
		builder.append("</table>");
		builder.append("<br1><img src=\"L2UI.squaregray\" width=\"290\" height=\"1\">");
		builder.append("<br>");

		builder.append("<table width=270>");
		builder.append("\t<tr>");
		builder.append("\t\t<td>");
		builder.append("\t\t\t<center><button value = \"Leave Event\" action=\"bypass -h ").append("_fightclub").append(" leave\" back=\"l2ui_ct1.button.OlympiadWnd_DF_Back_Down\" width=200 height=30 fore=\"l2ui_ct1.button.OlympiadWnd_DF_Back\"></center>");
		builder.append("\t\t</td>");
		builder.append("\t</tr>");
		builder.append("\t<tr>");
		builder.append("\t\t<td>");
		builder.append("\t\t\t<center><button value = \"Close\" action=\"bypass -h ").append("_fightclub").append(" close\" back=\"l2ui_ct1.button.OlympiadWnd_DF_Info_Down\" width=200 height=30 fore=\"l2ui_ct1.button.OlympiadWnd_DF_Info\"></center>");
		builder.append("\t\t</td>");
		builder.append("\t</tr>");
		builder.append("</table>");

		builder.append("</body></html>");

		player.sendPacket(new TutorialShowHtmlPacket(TutorialShowHtmlPacket.NORMAL_WINDOW, builder.toString()));
		player.sendPacket(new ShowTutorialMarkPacket(false, 100));
	}

	private void leaveEvent(Player player)
	{
		AbstractFightClub event = player.getFightClubEvent();
		if (event == null)
		{
			return;
		}

		if (event.leaveEvent(player, true))
		{
			if (boxes.containsKey(player.getObjectId()))
			{
				boxes.remove(player.getObjectId());
			}
			player.sendMessage("You have left the event!"); // TODO: Вынести в ДП.
		}
	}

	private void askQuestion(Player player, String question)
	{
		ConfirmDlgPacket packet = new ConfirmDlgPacket(SystemMsg.S1, 30_000).addString(question);
		player.ask(packet, new AskQuestionAnswerListener(player));
	}

	public AbstractFightClub getEventByObjId(int objId)
	{
		return _activeEvents.get(Integer.valueOf(objId));
	}

	private class AskQuestionAnswerListener implements OnAnswerListener
	{
		private final Player _player;

		private AskQuestionAnswerListener(Player player)
		{
			_player = player;
		}

		public void sayYes()
		{
			FightClubEventManager.this.leaveEvent(_player);
		}

		public void sayNo()
		{
			//
		}
	}

	private class EventRunThread implements Runnable
	{
		private AbstractFightClub _event;

		private EventRunThread(AbstractFightClub event)
		{
			_event = event;
		}

		@Override
		public void run()
		{
			startEventCountdown(_event);

			if (!_event.isAutoTimed())
			{
				return;
			}

			try
			{
				Thread.sleep(60000L);
			}
			catch (InterruptedException e)
			{
				e.printStackTrace();
			}

			final Calendar nextEventDate = FightClubEventManager.this.getClosestEventDate(_event.getAutoStartTimes());
			_event.printScheduledTime(nextEventDate.getTimeInMillis());
			ThreadPoolManager.getInstance().schedule(new EventRunThread(_event), nextEventDate.getTimeInMillis() - System.currentTimeMillis());
		}
	}

	private class AnswerEventInvitation implements OnAnswerListener
	{
		private Player _player;
		private AbstractFightClub _event;

		private AnswerEventInvitation(Player player, AbstractFightClub event)
		{
			_player = player;
			_event = event;
		}

		public void sayYes()
		{
			trySignForEvent(_player, _event, false);
		}

		public void sayNo()
		{
			//
		}
	}

	public static void clearBoxes()
	{
		boxes.clear();
	}

	private static FightClubEventManager _instance;

	public static FightClubEventManager getInstance()
	{
		if (_instance == null)
		{
			_instance = new FightClubEventManager();
		}
		return _instance;
	}
}