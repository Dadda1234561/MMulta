package l2s.gameserver.model.actor.instances.player;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Collection;
import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;

import l2s.commons.dbutils.DbUtils;
import l2s.gameserver.database.DatabaseFactory;
import l2s.gameserver.model.Player;
import l2s.gameserver.network.l2.components.SystemMsg;
import l2s.gameserver.network.l2.s2c.ShortCutInitPacket;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

public class ShortCutList
{
	private static final Logger _log = LoggerFactory.getLogger(ShortCutList.class);
	public static final String INSERT_QUERY = "REPLACE INTO character_shortcuts (object_id, slot, page, type, shortcut_id, level, class_index, character_type, toggled) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)";

	private final Player player;
	private Map<Integer, ShortCut> _shortCuts = new ConcurrentHashMap<Integer, ShortCut>();

	public ShortCutList(Player owner)
	{
		player = owner;
	}

	public Collection<ShortCut> getAllShortCuts()
	{
		return _shortCuts.values();
	}

	public void validate()
	{
		// Проверка ярлыков
		for(ShortCut sc : _shortCuts.values())
			// Удаляем ярлыки на предметы, которых нету в инвентаре
			if(sc.getType() == ShortCut.ShortCutType.ITEM)
				if(player.getInventory().getItemByObjectId(sc.getId()) == null)
					deleteShortCut(sc.getSlot(), sc.getPage());
	}

	public ShortCut getShortCut(int slot, int page)
	{
		ShortCut sc = _shortCuts.get(slot + page * 12);
		// verify shortcut
		if(sc != null && sc.getType() == ShortCut.ShortCutType.ITEM)
			if(player.getInventory().getItemByObjectId(sc.getId()) == null)
			{
				player.sendPacket(SystemMsg.THERE_ARE_NO_MORE_ITEMS_IN_THE_SHORTCUT);
				deleteShortCut(sc.getSlot(), sc.getPage());
				sc = null;
			}
		return sc;
	}

	public boolean canBeToggled(ShortCut sc) {
		switch(sc.getType()) {
			case ITEM: {
				return player.getInventory().getItemByObjectId(sc.getId()) != null;
			}
			case SKILL: {
				return player.getKnownSkill(sc.getId()) != null;
			}
		}

		return true;
	}

	public void updateToggledState(ShortCut shortCut) {
		if (shortCut == null) {
			return;
		}

		Connection con = null;
		PreparedStatement statement = null;
		try
		{
			con = DatabaseFactory.getInstance().getConnection();
			statement = con.prepareStatement("UPDATE character_shortcuts SET toggled=? WHERE object_id=? AND slot=? AND page=? AND class_index=? ");
			statement.setBoolean(1, shortCut.isToggled());
			statement.setInt(2, player.getObjectId());
			statement.setInt(3, shortCut.getSlot());
			statement.setInt(4, shortCut.getPage());
			statement.setInt(5, player.getActiveClassId());
			statement.execute();
		}
		catch(Exception e)
		{
			_log.error("could not store shortcuts:", e);
		}
		finally
		{
			DbUtils.closeQuietly(con, statement);
		}
	}

	public void registerShortCut(ShortCut shortcut, boolean saveDb)
	{
		ShortCut oldShortCut = _shortCuts.put(shortcut.getSlot() + 12 * shortcut.getPage(), shortcut);
		if (saveDb) {
			registerShortCutInDb(shortcut, oldShortCut);
		}
	}

	private synchronized void registerShortCutInDb(ShortCut shortcut, ShortCut oldShortCut)
	{
		if(oldShortCut != null)
			deleteShortCutFromDb(oldShortCut);

		Connection con = null;
		PreparedStatement statement = null;
		try
		{
			con = DatabaseFactory.getInstance().getConnection();
			statement = con.prepareStatement("REPLACE INTO character_shortcuts SET object_id=?,slot=?,page=?,type=?,shortcut_id=?,level=?,character_type=?,toggled=?,class_index=?");
			statement.setInt(1, player.getObjectId());
			statement.setInt(2, shortcut.getSlot());
			statement.setInt(3, shortcut.getPage());
			statement.setInt(4, shortcut.getType().ordinal());
			statement.setInt(5, shortcut.getId());
			statement.setInt(6, shortcut.getLevel());
			statement.setInt(7, shortcut.getCharacterType());
			statement.setBoolean(8, shortcut.isToggled());
			statement.setInt(9, player.getActiveClassId());
			statement.execute();
		}
		catch(Exception e)
		{
			_log.error("could not store shortcuts:", e);
		}
		finally
		{
			DbUtils.closeQuietly(con, statement);
		}
	}

	/**
	 * @param shortcut
	 */
	private void deleteShortCutFromDb(ShortCut shortcut)
	{
		Connection con = null;
		PreparedStatement statement = null;
		try
		{
			con = DatabaseFactory.getInstance().getConnection();
			statement = con.prepareStatement("DELETE FROM character_shortcuts WHERE object_id=? AND slot=? AND page=? AND class_index=?");
			statement.setInt(1, player.getObjectId());
			statement.setInt(2, shortcut.getSlot());
			statement.setInt(3, shortcut.getPage());
			statement.setInt(4, player.getActiveClassId());
			statement.execute();
		}
		catch(Exception e)
		{
			_log.error("could not delete shortcuts:", e);
		}
		finally
		{
			DbUtils.closeQuietly(con, statement);
		}
	}

	/**
	 * Удаляет ярлык с пользовательской панели по номеру страницы и слота.
	 * @param slot
	 * @param page
	 */
	public void deleteShortCut(int slot, int page)
	{
		ShortCut old = _shortCuts.remove(slot + page * 12);
		if(old == null)
			return;
		deleteShortCutFromDb(old);
		// При удалении с панели скила, на оффе шлется полный инит ярлыков
		// Обработка удаления предметных ярлыков - клиент сайд.
		if(old.getType() == ShortCut.ShortCutType.SKILL)
		{
			player.sendPacket(new ShortCutInitPacket(player));
			player.sendActiveAutoShots();
		}
	}

	/**
	 * Удаляет ярлык предмета с пользовательской панели.
	 * @param objectId
	 */
	public void deleteShortCutByObjectId(int objectId)
	{
		for(ShortCut shortcut : _shortCuts.values())
			if(shortcut != null && shortcut.getType() == ShortCut.ShortCutType.ITEM && shortcut.getId() == objectId)
				deleteShortCut(shortcut.getSlot(), shortcut.getPage());
	}

	/**
	 * Удаляет ярлык предмета с пользовательской панели.
	 * @param slot
	 */
	public void deleteShortCutByBookmarkId(int slot)
	{
		for(ShortCut shortcut : _shortCuts.values())
			if(shortcut != null && shortcut.getType() == ShortCut.ShortCutType.TPBOOKMARK && shortcut.getId() == slot)
				deleteShortCut(shortcut.getSlot(), shortcut.getPage());
	}

	/**
	 * Удаляет ярлык скила с пользовательской панели.
	 * @param skillId
	 */
	public void deleteShortCutBySkillId(int skillId)
	{
		for(ShortCut shortcut : _shortCuts.values())
			if(shortcut != null && shortcut.getType() == ShortCut.ShortCutType.SKILL && shortcut.getId() == skillId)
				deleteShortCut(shortcut.getSlot(), shortcut.getPage());
	}

	public void restore()
	{
		_shortCuts.clear();
		Connection con = null;
		PreparedStatement statement = null;
		ResultSet rset = null;
		try
		{
			con = DatabaseFactory.getInstance().getConnection();
			statement = con.prepareStatement("SELECT character_type, slot, page, `type`, shortcut_id, `level`, toggled FROM character_shortcuts WHERE object_id=? AND class_index=?");
			statement.setInt(1, player.getObjectId());
			statement.setInt(2, player.getActiveClassId());
			rset = statement.executeQuery();
			while(rset.next())
			{
				ShortCut.ShortCutType type;
				try {
					type = ShortCut.ShortCutType.VALUES[rset.getInt("type")];
				} catch (Exception e) {
					continue;
				}

				int slot = rset.getInt("slot");
				int page = rset.getInt("page");
				int id = rset.getInt("shortcut_id");
				int level = rset.getInt("level");
				int character_type = rset.getInt("character_type");
				boolean isToggled = rset.getInt("toggled") == 1;

				_shortCuts.put(slot + page * 12, new ShortCut(slot, page, type, id, level, character_type, isToggled));
			}
		}
		catch(Exception e)
		{
			_log.error("could not store shortcuts:", e);
		}
		finally
		{
			DbUtils.closeQuietly(con, statement, rset);
		}
	}

	public void store()
	{
		Connection con = null;
		PreparedStatement stm = null;

		try
		{
			con = DatabaseFactory.getInstance().getConnection();
			stm = con.prepareStatement("DELETE FROM character_shortcuts WHERE object_id=? AND class_index=?");
			stm.setInt(1, player.getObjectId());
			stm.setInt(2, player.getActiveClassId());
			stm.execute();
		}
		catch (Exception e)
		{
			_log.error(String.format("could not delete shortcuts for %s:", player.getName()), e);
		}
		finally
		{
			DbUtils.closeQuietly(con, stm);
		}


		try
		{
			con = DatabaseFactory.getInstance().getConnection();
			stm = con.prepareStatement(INSERT_QUERY);

			stm.setInt(1, player.getObjectId());
			for (ShortCut shortCut : _shortCuts.values())
			{
				stm.setInt(2, shortCut.getSlot());
				stm.setInt(3, shortCut.getPage());
				stm.setInt(4, shortCut.getType().ordinal());
				stm.setInt(5, shortCut.getId());
				stm.setInt(6, shortCut.getLevel());
				stm.setInt(7, player.getActiveClassId());
				stm.setInt(8, shortCut.getCharacterType());
				stm.setBoolean(9, shortCut.isToggled());
				stm.addBatch();
			}
			stm.executeBatch();
		}
		catch (SQLException e)
		{
			_log.error(String.format("could not store shortcuts for %s:", player.getName()), e);
		}
		finally
		{
			DbUtils.closeQuietly(con, stm);
		}
	}
}