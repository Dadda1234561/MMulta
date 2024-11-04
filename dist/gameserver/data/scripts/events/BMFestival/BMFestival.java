package events.BMFestival;

import l2s.commons.threading.RunnableImpl;
import l2s.commons.util.Rnd;
import l2s.gameserver.Config;
import l2s.gameserver.ThreadPoolManager;
import l2s.gameserver.common.DifferentMethods;
import l2s.gameserver.data.xml.holder.FestivalBMHolder;
import l2s.gameserver.database.DatabaseFactory;
import l2s.gameserver.listener.actor.player.OnBMFestivalRegister;
import l2s.gameserver.listener.actor.player.OnPlayerEnterListener;
import l2s.gameserver.listener.actor.player.OnPlayerExitListener;
import l2s.gameserver.listener.script.OnInitScriptListener;
import l2s.gameserver.model.GameObjectsStorage;
import l2s.gameserver.model.ItemAnnounceType;
import l2s.gameserver.model.Player;
import l2s.gameserver.model.actor.listener.CharListenerList;
import l2s.gameserver.model.entity.events.objects.RewardHolder;
import l2s.gameserver.network.l2.s2c.ExItemAnnounce;
import l2s.gameserver.network.l2.s2c.SystemMessage;
import l2s.gameserver.network.l2.s2c.events.ExFestivalBMAllItemInfo;
import l2s.gameserver.network.l2.s2c.events.ExFestivalBMGame;
import l2s.gameserver.network.l2.s2c.events.ExFestivalBMInfo;
import l2s.gameserver.network.l2.s2c.events.ExFestivalBMTopItemInfo;
import l2s.gameserver.templates.FestivalBMTemplate;
import l2s.gameserver.utils.Functions;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.time.LocalDateTime;
import java.time.ZoneId;
import java.time.format.DateTimeFormatter;
import java.util.LinkedHashSet;
import java.util.Map;
import java.util.Set;
import java.util.concurrent.ConcurrentHashMap;
import java.util.concurrent.Future;
import java.util.concurrent.TimeUnit;
import java.util.stream.Collectors;

public class BMFestival implements OnInitScriptListener
{
	private static final Set<Integer> _registeredPlayers = new LinkedHashSet<>();
	private static final Logger _log = LoggerFactory.getLogger(BMFestival.class);
	private static final String EVENT_NAME = "BMFestival";
	private static EventListeners EVENT_LISTENERS = new EventListeners();
	private static boolean _active = false;
	private static long _timeStart, _timeEnd;
	private static Future<?> _updateTask;
	private static Future<?> _rewardTask;
	private static Map<Integer, FestivalBMTemplate> _items = new ConcurrentHashMap<>();


	private static boolean isActive()
	{
		LocalDateTime localDateTime = LocalDateTime.parse(Config.BM_FESTIVAL_TIME_START, DateTimeFormatter.ofPattern("yyyy/MM/dd HH:mm:ss"));
		_timeStart = localDateTime.atZone(ZoneId.systemDefault()).toInstant().toEpochMilli();
		localDateTime = LocalDateTime.parse(Config.BM_FESTIVAL_TIME_END, DateTimeFormatter.ofPattern("yyyy/MM/dd HH:mm:ss"));
		_timeEnd = localDateTime.atZone(ZoneId.systemDefault()).toInstant().toEpochMilli();
		long currentTime = System.currentTimeMillis();
		if ((currentTime > _timeStart) && (currentTime < _timeEnd))
		{
			Functions.SetActive(EVENT_NAME, true);
		}
		else
		{
			Functions.SetActive(EVENT_NAME, false);
		}
		return Functions.IsActive(EVENT_NAME);
	}

	@Override
	public void onInit()
	{
		if (isActive())
		{
			_active = true;
			CharListenerList.addGlobal(EVENT_LISTENERS);
			_items = FestivalBMHolder.getInstance().getItems();
			ThreadPoolManager.getInstance().schedule(new UpdateEvent(), _timeEnd);
			cancelUpdateTask();
			cancelRewardTask();
			_updateTask = ThreadPoolManager.getInstance().scheduleAtFixedRate(new UpdateItems(), 0, TimeUnit.MINUTES.toMillis(Config.BM_FESTIVAL_UPDATE_INTERVAL));
			if (Config.BM_FESTIVAL_TYPE == 2) {
				_rewardTask = ThreadPoolManager.getInstance().scheduleAtFixedRate(new RewardTask(), TimeUnit.MINUTES.toMillis(Config.BM_FESTIVAL_REWARD_INTERVAL), TimeUnit.MINUTES.toMillis(Config.BM_FESTIVAL_REWARD_INTERVAL));
			}
			_log.info("Loaded Event: BM Festival [state: activated]");
		}
		else
		{
			cleanDatabase();
			ThreadPoolManager.getInstance().schedule(new UpdateEvent(), _timeStart);
			_log.info("Loaded Event: BM Festival [state: deactivated]");
		}
	}

	private static void cleanDatabase() {
		try (Connection con = DatabaseFactory.getInstance().getConnection();) {
			PreparedStatement statement = con.prepareStatement("DELETE FROM character_variables WHERE name=?");
			statement.setString(1, "%FESTIVAL_BM_%");
			statement.executeUpdate();
			statement.close();
			statement = con.prepareStatement("DELETE FROM server_variables WHERE name=?");
			statement.setString(1, "%FESTIVAL_BM_%");
			statement.executeUpdate();

		} catch (Exception e) {
			_log.error("Could not remove BM Festival data from db!", e);
		}
	}

	private static void cancelRewardTask() {
		if (_rewardTask != null) {
			_rewardTask.cancel(false);
			_rewardTask = null;
		}
	}

	private static void cancelUpdateTask() {
		if (_updateTask != null) {
			_updateTask.cancel(false);
			_updateTask = null;
		}
	}

	private static class EventListeners implements OnPlayerEnterListener, OnPlayerExitListener, OnBMFestivalRegister
	{
		@Override
		public void onPlayerEnter(Player player)
		{
			if (_active)
			{
				long time = (_timeEnd - System.currentTimeMillis()) / 1000;
				player.sendPacket(new ExFestivalBMTopItemInfo(true, (int) time));

				boolean isRegistered = player.getVarBoolean("FESTIVAL_BM_REGISTERED", false);
				if (isRegistered) {
					_registeredPlayers.add(player.getObjectId());
				}
			}
			else
			{
				player.sendPacket(new ExFestivalBMTopItemInfo(false, 0));
			}
		}

		@Override
		public void onPlayerExit(Player player) {
			if (player == null) {
				return;
			}

			boolean isRegistered = player.getVarBoolean("FESTIVAL_BM_REGISTERED", false);
			if (isRegistered) {
				_registeredPlayers.remove(player.getObjectId());
			}
		}

		@Override
		public void onBMFestivalRegister(Player player)
		{
			if (Config.BM_FESTIVAL_TYPE == 2) {
				SystemMessage sm = new SystemMessage(SystemMessage.SECRET_SHOP_S1);
				boolean isRegistered = player.getVarBoolean("FESTIVAL_BM_REGISTERED", false);
				if (isRegistered) {
					sm.addString(": Вы уже зарегистрированы!");
					player.sendPacket(sm);
				} else {
					final boolean success = DifferentMethods.getPay(player, Config.BM_FESTIVAL_ITEM_TO_PLAY, Config.BM_FESTIVAL_ITEM_TO_PLAY_COUNT, true);
					if (success) {
						_registeredPlayers.add(player.getObjectId());
						player.setVar("FESTIVAL_BM_REGISTERED", true);
						sm.addString(": Вы были зарегистрированы!");
						player.sendPacket(sm);
					} else {
						sm = new SystemMessage(SystemMessage.YOU_DO_NOT_HAVE_ENOUGH_REQUIRED_ITEMS);
						sm.addItemName(Config.BM_FESTIVAL_ITEM_TO_PLAY);
						sm.addNumber(Config.BM_FESTIVAL_ITEM_TO_PLAY_COUNT);
						player.sendPacket(sm);
					}
					player.sendPacket(new ExFestivalBMInfo(player));
					player.sendPacket(new ExFestivalBMAllItemInfo());
				}
			}
			else {
				final long remainingTickets = player.getInventory().getCountOf(Config.BM_FESTIVAL_ITEM_TO_PLAY);
				if (remainingTickets >= Config.BM_FESTIVAL_ITEM_TO_PLAY_COUNT) {
					if (DifferentMethods.getPay(player, Config.BM_FESTIVAL_ITEM_TO_PLAY, Config.BM_FESTIVAL_ITEM_TO_PLAY_COUNT, true)) {
						RewardHolder reward = tryGiveItem(player);
						player.sendPacket(new ExFestivalBMGame(player, reward));
					}
				}

				player.sendPacket(new ExFestivalBMInfo(player));
				player.sendPacket(new ExFestivalBMAllItemInfo());
			}
		}
	}

	/**
	 * Run this task for each registered player
	 * Check if player should be rewarded for something...
	 */
	private static class RewardTask extends RunnableImpl {
		@Override
		protected void runImpl() throws Exception {
			if (_registeredPlayers.isEmpty()) {
				if (Config.BM_FESTIVAL_DEBUG) {
					_log.info("[BMFestival]: Skip reward task");
				}
				return;
			}
			if (Config.BM_FESTIVAL_DEBUG) {
				_log.info("[BMFestival]: Running reward task...");
			}
			for (int objectID : _registeredPlayers) {
				Player player = GameObjectsStorage.getPlayer(objectID);
				if (player == null) {
					_registeredPlayers.remove(objectID);
					continue;
				}

				if (Config.BM_FESTIVAL_DEBUG) {
					_log.info(String.format("[BMFestival]: Running reward task for [%s]", player.getName()));
				}

				final RewardHolder result = tryGiveItem(player);
				if (result.getGrade() != 0) {
					if (Config.BM_FESTIVAL_DEBUG) {
						_log.info(String.format("[BMFestival]: Reward player [%s][%d] with GRADE=[%d] ItemID=[%d] ItemCnt=[%d]", player.getName(), player.getObjectId(), result.getGrade(), result.getItemId(), result.getItemCnt()));
					}
					player.sendPacket(new ExFestivalBMGame(player, result));
					player.sendPacket(new ExFestivalBMAllItemInfo());
				}
			}
		}
	}

	static private RewardHolder tryGiveItem(Player player)
	{
		FestivalBMTemplate itemReward = null;

		Set<FestivalBMTemplate> collect = _items.values().stream().filter(template -> template.getRemainingCount() > 0).collect(Collectors.toCollection(LinkedHashSet::new));

		for (FestivalBMTemplate template : collect) {
			if (Rnd.chance(template.getChance())) {
				itemReward = template;
				break;
			}
		}

		if (itemReward == null) {
			return new RewardHolder(0, 0, 0);
		} else {
			long endTime = (_timeEnd - System.currentTimeMillis()) / 1000;
			DifferentMethods.addItem(player, itemReward.getItemId(), itemReward.getItemCount());

			//Hl4p3x Announce item reward event.
			if (itemReward.getLocationId() == 1) {
				for (Player st : GameObjectsStorage.getPlayers(false, false)) {
					st.sendPacket(new ExItemAnnounce(ItemAnnounceType.FESTIVAL, player.getName(), itemReward.getItemId()));
					st.sendPacket(new ExFestivalBMTopItemInfo(_active, Long.valueOf(endTime).intValue()));
				}
			}

			if (Config.BM_FESTIVAL_PLAY_LIMIT != -1) {
				int existGames = player.getVarInt("FESTIVAL_BM_EXIST_GAMES", Config.BM_FESTIVAL_PLAY_LIMIT);
				player.setVar("FESTIVAL_BM_EXIST_GAMES", existGames - 1);
			}

			itemReward.decreaseRemainingCount();
			return new RewardHolder(itemReward.getItemId(), itemReward.getItemCount(), itemReward.getLocationId());
		}
	}

	/**
	 * Update all items periodically
	 */
	private static class UpdateItems extends RunnableImpl
	{
		@Override
		protected void runImpl() throws Exception
		{
			for (Player player : GameObjectsStorage.getPlayers(false, false))
			{
				long time = (_timeEnd - System.currentTimeMillis()) / 1000;
				player.sendPacket(new ExFestivalBMTopItemInfo(true, (int) time));
				player.sendPacket(new ExFestivalBMAllItemInfo());
			}
		}
	}

	private class UpdateEvent implements Runnable
	{
		@Override
		public void run()
		{
			long currentTime = System.currentTimeMillis();
			if ((currentTime > _timeStart) && (currentTime < _timeEnd))
			{
				cancelUpdateTask();
				cancelRewardTask();
				_updateTask = ThreadPoolManager.getInstance().scheduleAtFixedRate(new UpdateItems(),0, TimeUnit.MINUTES.toMillis(Config.BM_FESTIVAL_UPDATE_INTERVAL));
				if (Config.BM_FESTIVAL_TYPE == 2) {
					_rewardTask = ThreadPoolManager.getInstance().scheduleAtFixedRate(new RewardTask(), TimeUnit.MINUTES.toMillis(Config.BM_FESTIVAL_REWARD_INTERVAL), TimeUnit.MINUTES.toMillis(Config.BM_FESTIVAL_REWARD_INTERVAL));
				}
				Functions.SetActive(EVENT_NAME, true);
			}
			else
			{
				_registeredPlayers.clear();
				cancelUpdateTask();
				cancelRewardTask();
				cleanDatabase();
				Functions.SetActive(EVENT_NAME, false);
			}
		}
	}
}