package l2s.gameserver.instancemanager;

import gnu.trove.map.hash.TIntObjectHashMap;
import l2s.gameserver.common.DifferentMethods;
import l2s.gameserver.data.xml.holder.ResourceHolder;
import l2s.gameserver.database.DatabaseFactory;
import l2s.gameserver.model.Player;
import l2s.gameserver.templates.ResourceTemplate;
import l2s.gameserver.templates.item.data.ItemData;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.HashMap;
import java.util.Map;
import java.util.concurrent.TimeUnit;

/**
 * Resource smelting manager
 */
public class SmeltingManager
{
	private final static Logger _log = LoggerFactory.getLogger(SmeltingManager.class);

	private static final String STORE_TASK_QUERY = "REPLACE INTO `smelting_tasks` (`player_id`, `slot`, `resource`, `end_time`) VALUES (?, ?, ?, ?)";
	private static final String DELETE_TASK_QUERY = "DELETE FROM `smelting_tasks` WHERE `player_id` = ? AND `slot` = ?";
	private static final String LOAD_TASK_QUERY = "SELECT * FROM `smelting_tasks`";

	private final Map<Integer, TIntObjectHashMap<Long>> activeTasks = new HashMap<>();
	private final Map<Integer, TIntObjectHashMap<ResourceTemplate>> selectedResources = new HashMap<>();

	public SmeltingManager()
	{
		restore();
	}

	public static SmeltingManager getInstance()
	{
		return SingletonHolder.INSTANCE;
	}

	private void restore()
	{
		try (Connection connection = DatabaseFactory.getInstance().getConnection(); PreparedStatement stm = connection.prepareStatement(LOAD_TASK_QUERY); ResultSet rs = stm.executeQuery())
		{
			while(rs.next())
			{
				int playerId = rs.getInt("player_id");
				int slot = rs.getInt("slot");
				int resourceId = rs.getInt("resource");
				long endTime = rs.getLong("end_time");
//				if(endTime < System.currentTimeMillis()) багулик
//				{
//					continue;
//				}

				ResourceTemplate resource = ResourceHolder.getInstance().getResource(resourceId);
				if(resource != null)
				{
					activeTasks.computeIfAbsent(playerId, i -> new TIntObjectHashMap<>()).put(slot, endTime);
					selectedResources.computeIfAbsent(playerId, i -> new TIntObjectHashMap<>()).put(slot, resource);
				}
			}

			_log.info(getClass().getSimpleName() + ": " + " Loaded " + activeTasks.size() + " active smelting tasks.");
			_log.info(getClass().getSimpleName() + ": " + " Loaded " + selectedResources.size() + " selected resources.");
		}
		catch(SQLException e)
		{
			e.printStackTrace();
		}

	}

	public void store()
	{
		for(Map.Entry<Integer, TIntObjectHashMap<Long>> playerTaskEntry : activeTasks.entrySet())
		{
			TIntObjectHashMap<Long> playerTasks = playerTaskEntry.getValue();
			// iterate over all slots
			for(int i = 1; i < 4; i++)
			{
				// skip if slot is not active
				if(!playerTasks.containsKey(i))
				{
					continue;
				}

				Long endTime = playerTasks.get(i);
				// save if end time is in the future
				if(endTime.longValue() > System.currentTimeMillis())
				{
					ResourceTemplate template = selectedResources.getOrDefault(playerTaskEntry.getKey(), new TIntObjectHashMap<>()).get(i);
					if(template == null) {
						continue;
					}
					try (Connection connection = DatabaseFactory.getInstance().getConnection(); PreparedStatement stm = connection.prepareStatement(STORE_TASK_QUERY))
					{
						stm.setInt(1, playerTaskEntry.getKey());
						stm.setInt(2, i);
						stm.setInt(3, template.getId());
						stm.setLong(4, endTime);
						stm.execute();
					}
					catch(SQLException e)
					{
						e.printStackTrace();
					}
				}
			}
		}

		_log.info(getClass().getSimpleName() + ": Stored " + activeTasks.size() + " tasks.");
	}
	public void store(int slot)
	{
		for(Map.Entry<Integer, TIntObjectHashMap<Long>> playerTaskEntry : activeTasks.entrySet())
		{
			TIntObjectHashMap<Long> playerTasks = playerTaskEntry.getValue();
			// Доп. проверка против багоюзеров
			if(!playerTasks.containsKey(slot))
			{
				continue;
			}

			Long endTime = playerTasks.get(slot);
			// Время окончания плавки
			if(endTime.longValue() >= System.currentTimeMillis())
			{
				ResourceTemplate template = selectedResources.getOrDefault(playerTaskEntry.getKey(),
						new TIntObjectHashMap<>()).get(slot);

				if(template == null) {
					continue;
				}
				try (Connection connection = DatabaseFactory.getInstance().getConnection();
					 PreparedStatement stm = connection.prepareStatement(STORE_TASK_QUERY))
				{
					stm.setInt(1, playerTaskEntry.getKey());
					stm.setInt(2, slot);
					stm.setInt(3, template.getId());
					stm.setLong(4, endTime);
					stm.execute();
				}
				catch(SQLException e)
				{
					e.printStackTrace();
				}
			}
		}

		_log.info(getClass().getSimpleName() + ": Stored " + activeTasks.size() + " tasks.");
	}

	public void deleteTask(Player player, int slot)
	{
			TIntObjectHashMap<Long> playerTasks = getPlayerTasks(player);// не включены уже завершённые таски!
			if(playerTasks.containsKey(slot)) {
				playerTasks.remove(slot);
				selectedResources.get(player.getObjectId()).remove(slot);
			}
			try (Connection connection = DatabaseFactory.getInstance().getConnection(); PreparedStatement stm = connection.prepareStatement(DELETE_TASK_QUERY))
			{
				stm.setInt(1, player.getObjectId());
				stm.setInt(2, slot);
				stm.execute();
			}
			catch(SQLException e)
			{
				e.printStackTrace();
			}
	}

	public TIntObjectHashMap<Long> getPlayerTasks(Player player)
	{
		return activeTasks.computeIfAbsent(player.getObjectId(), integer -> new TIntObjectHashMap<>());
	}

	public ResourceTemplate getSelectedResource(Player player, int slot)
	{
		return selectedResources.computeIfAbsent(player.getObjectId(), integer -> new TIntObjectHashMap<>()).get(slot);
	}

	public void setSelectedResource(Player player, int resourceId, int slot)
	{
		ResourceTemplate resource = ResourceHolder.getInstance().getResource(resourceId);
		if(resource != null)
		{
			selectedResources.computeIfAbsent(player.getObjectId(), integer -> new TIntObjectHashMap<>()).put(slot, resource);

			// start task
			long endTime = System.currentTimeMillis() + TimeUnit.SECONDS.toMillis(resource.getDuration());
			addTask(player, slot, endTime);
		}
	}

	public boolean checkIngredient(Player player, ItemData ingredient)
	{
		long countOf = player.getInventory().getCountOf(ingredient.getId());
		return countOf >= ingredient.getCount();
	}

	public boolean isCompleted(Player player, int slot)
	{
		ResourceTemplate selectedResource = getSelectedResource(player, slot);
		if(selectedResource == null)
		{
			return false;
		}
		TIntObjectHashMap<Long> playerTasks = getPlayerTasks(player);
		if(playerTasks.isEmpty())
		{
			return false;
		}

		Long endTime = playerTasks.get(slot);
		return endTime != null && System.currentTimeMillis() > endTime;
	}

	public void addTask(Player player, int slot, long endTime)
	{
		activeTasks.computeIfAbsent(player.getObjectId(), integer -> new TIntObjectHashMap<>()).put(slot, endTime);
	}

	public TaskState getTaskStateForSlot(Player player, int i)
	{
		boolean exists = selectedResources.computeIfAbsent(player.getObjectId(), integer -> new TIntObjectHashMap<>()).containsKey(i);
		boolean started = getPlayerTasks(player).containsKey(i);

		if(!exists)
		{
			return TaskState.NOT_EXISTS;
		}
		else if(!started)
		{
			return TaskState.NOT_STARTED;
		}
		else if(isCompleted(player, i))
		{
			return TaskState.COMPLETED;
		}
		else if(isActive(player, i))
		{
			return TaskState.ACTIVE;
		}

		return TaskState.NOT_STARTED;
	}

	public boolean isActive(Player player, int i)
	{
		return getPlayerTasks(player).containsKey(i);
	}

	public String getRemainingTime(Player player, int slot)
	{
		TIntObjectHashMap<Long> slotTimes = activeTasks.getOrDefault(player.getObjectId(), new TIntObjectHashMap<>());
		if(!slotTimes.containsKey(slot))
		{
			return "0ч";
		}

		Long endTime = slotTimes.get(slot);
		if(endTime == null)
		{
			return "0ч";
		}

		long remainingTime = endTime - System.currentTimeMillis();
		return formatTime(remainingTime / 1000);
	}

	public String formatTime(long time)
	{
		return DifferentMethods.convertTimeToString(time);
	}

	public void reset(Player player, int slot)
	{
		activeTasks.computeIfAbsent(player.getObjectId(), integer -> new TIntObjectHashMap<>()).remove(slot);
		selectedResources.computeIfAbsent(player.getObjectId(), integer -> new TIntObjectHashMap<>()).remove(slot);
		deleteTask(player, slot);
	}

	public boolean isAllIngredients(Player player, ResourceTemplate resource)
	{
		for(int i = 0; i < resource.getIngredients().size(); i++)
		{
			ItemData ingredient = resource.getIngredient(i);
			if(!checkIngredient(player, ingredient))
			{
				return false;
			}
		}
		return true;
	}

	public enum TaskState
	{
		NOT_EXISTS,
		NOT_STARTED,
		ACTIVE,
		COMPLETED
	}

	private static class SingletonHolder
	{
		protected static SmeltingManager INSTANCE = new SmeltingManager();
	}
}
