package l2s.gameserver.model.actor.instances.player;

import l2s.gameserver.ThreadPoolManager;
import l2s.gameserver.database.DatabaseFactory;
import l2s.gameserver.model.Player;
import l2s.gameserver.model.items.Inventory;
import l2s.gameserver.network.l2.s2c.ExUserInfoEquipSlot;
import l2s.gameserver.network.l2.s2c.NpcHtmlMessagePacket;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.HashSet;
import java.util.Set;
import java.util.concurrent.Future;
import java.util.stream.Collectors;

public class VisualItemList {
    private static final Logger LOGGER = LoggerFactory.getLogger(VisualItemList.class);
    private static final String SKIP_WINDOW_ARG = "skip_window=1 \t";
    private static final String COSTUME_LIST_ARG = "CostumeList=";
    private static final String SELECT_QUERY = "SELECT item_id FROM character_visual_items WHERE char_obj_id = ?";
    private static final String INSERT_QUERY = "INSERT INTO character_visual_items (char_obj_id, item_id) VALUES (?,?)";
    private static final Long VISUAL_TASK_DELAY = 15L * 1000L;
    private final Future<?>[] _visualEndTasks = new Future[Inventory.PAPERDOLL_MAX];
    private final Set<Integer> _visualItems = new HashSet<>();
    private final Player _owner;

    public VisualItemList(Player owner) {
        _owner = owner;
    }

    public boolean contains(int itemId) {
        return _visualItems.contains(itemId);
    }

    public void addVisualItem(int itemId, boolean store) {
        _visualItems.add(itemId);
        if (store) {
            store(itemId);
        }
    }

    public void sendAvailableItems() {
        _owner.sendPacket(new NpcHtmlMessagePacket(0, 0, false, buildCostumeList()));
    }

    public void stopVisualTask(int slot) {
        if (_visualEndTasks[slot] != null) {
            _visualEndTasks[slot].cancel(false);
            _visualEndTasks[slot] = null;
        }
    }

    public void startVisualTask(int slot, int itemId) {
        stopVisualTask(slot);

        _owner.getInventory().setPaperdollVisualId(slot, itemId);
        _owner.sendPacket(new ExUserInfoEquipSlot(_owner, slot));

        _visualEndTasks[slot] = ThreadPoolManager.getInstance().schedule(new VisualEndTask(_owner, slot), VISUAL_TASK_DELAY);
    }

    private String buildCostumeList() {
        if (_visualItems.isEmpty()) {
            return SKIP_WINDOW_ARG;
        }
        return SKIP_WINDOW_ARG + COSTUME_LIST_ARG + _visualItems.stream().map(String::valueOf).collect(Collectors.joining(","));
    }

    public void restore() {
        _visualItems.clear();
        try (Connection con = DatabaseFactory.getInstance().getConnection(); PreparedStatement stm = con.prepareStatement(SELECT_QUERY);) {
            stm.setInt(1, _owner.getObjectId());
            try (ResultSet rs = stm.executeQuery()) {
                while (rs.next()) {
                    _visualItems.add(rs.getInt("item_id"));
                }
            }
        } catch (Exception e) {
            LOGGER.info("VisualItemList: Could not restore visual items for player: " + _owner.getName() + "!", e);
        }
    }

    public void store(int itemId) {
        try (Connection con = DatabaseFactory.getInstance().getConnection(); PreparedStatement stm = con.prepareStatement(INSERT_QUERY)) {
            stm.setInt(1, _owner.getObjectId());
            stm.setInt(2, itemId);
            stm.execute();
        } catch (Exception e) {
            LOGGER.info("VisualItemList: Could not store visual items for player: " + _owner.getName() + "!", e);
        }
    }

    private static class VisualEndTask implements Runnable {
        private final Player _owner;
        private final int _slot;

        public VisualEndTask(Player owner, int slot) {
            _owner = owner;
            _slot = slot;
        }

        @Override
        public void run() {
            _owner.getInventory().setPaperdollVisualId(_slot, 0);
            _owner.sendPacket(new ExUserInfoEquipSlot(_owner, _slot));
        }
    }

}
