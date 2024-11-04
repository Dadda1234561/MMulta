package l2s.gameserver.dao;

import l2s.commons.dao.JdbcEntityState;
import l2s.gameserver.Config;
import l2s.gameserver.ThreadPoolManager;
import l2s.gameserver.data.xml.holder.EventHolder;
import l2s.gameserver.data.xml.holder.WorldExchangeHolder;
import l2s.gameserver.database.DatabaseFactory;
import l2s.gameserver.idfactory.IdFactory;
import l2s.gameserver.model.GameObjectsStorage;
import l2s.gameserver.model.Player;
import l2s.gameserver.model.base.WorldExchangeItemStatusType;
import l2s.gameserver.model.base.WorldExchangeItemSubType;
import l2s.gameserver.model.base.WorldExchangeSortType;
import l2s.gameserver.model.entity.events.Event;
import l2s.gameserver.model.entity.events.EventType;
import l2s.gameserver.model.items.ItemInfo;
import l2s.gameserver.model.items.ItemInstance;
import l2s.gameserver.model.items.ItemInstance.ItemLocation;
import l2s.gameserver.network.l2.s2c.ExBloodyCoinCount;
import l2s.gameserver.network.l2.s2c.InventoryUpdatePacket;
import l2s.gameserver.network.l2.s2c.SystemMessage;
import l2s.gameserver.network.l2.s2c.worldexchange.*;
import l2s.gameserver.templates.StatsSet;
import l2s.gameserver.templates.item.ItemTemplate;
import l2s.gameserver.templates.item.support.Ensoul;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.*;
import java.util.concurrent.ConcurrentHashMap;
import java.util.concurrent.ScheduledFuture;
import java.util.stream.Collectors;
import java.util.stream.LongStream;
import java.util.stream.Stream;

import static java.util.Comparator.reverseOrder;

public class WorldExchangeManager {

    // Usage alternate currency for trading
    // required client changes
    public static boolean EXTENDED_WORLD_TRADE = true;

    private static final Logger LOGGER = LoggerFactory.getLogger(WorldExchangeManager.class);

    private final Map<Long, WorldExchangeHolder> _bidItems = new ConcurrentHashMap<>();
    // private final Map<Integer, WorldExchangeItemSubType> _weItemCategory = new ConcurrentHashMap<>();
    private long _lastWorldExchangeID = 0;
    private final double lcoin_fee = Config.WORLD_EXCHANGE_LCOIN_TAX; // default 5%
    private final long max_lcoin_fee = Config.WORLD_EXCHANGE_MAX_LCOIN_TAX; // default 20 000
    private final double adena_fee = Config.WORLD_EXCHANGE_ADENA_FEE; // default 100%
    private final long max_adena_fee = Config.WORLD_EXCHANGE_MAX_ADENA_FEE; // default -1
    // ? private final int clientItemListLimit = 100;
    private final static long checkTime = Config.WORLD_EXCHANGE_SAVE_INTERVAL;

    private final Map<Integer, WorldExchangeItemSubType> _itemCategories = new ConcurrentHashMap<>();

    private final static String SELECT_ALL_ITEMS = "SELECT * FROM `items` WHERE `loc` = ?";
    private final static String RESTORE_INFO = "SELECT * FROM world_exchange_items";
    private static final String INSERT_WORLD_EXCHANGE = "REPLACE INTO world_exchange_items (`world_exchange_id`, `item_object_id`, `item_status`, `category_id`, `price`, `old_owner_id`, `start_time`, `end_time`, `currency`) VALUES (?, ?, ?, ?, ?, ?, ?, ?,?)";

    private ScheduledFuture<?> _checkStatus = null;

    public WorldExchangeManager() {
        if (!Config.ENABLE_WORLD_EXCHANGE) {
            return;
        }
        firstLoad();
        if (_checkStatus == null) {
            _checkStatus = ThreadPoolManager.getInstance().scheduleAtFixedRate(this::checkBIDsStatus, checkTime, checkTime);
        }
    }

    synchronized void firstLoad() {
        final Map<Integer, ItemInstance> itemInstances = loadItemInstances();
        loadBidItems(itemInstances);
    }

    /**
     * @implNote Little task which check and update bid items if it needs
     **/
    private void checkBIDsStatus() {
        if (!Config.ENABLE_WORLD_EXCHANGE) {
            return;
        }
        for (long key : _bidItems.keySet()) {
            if (_bidItems.get(key) == null) {
                _bidItems.remove(key);
                continue;
            }
            WorldExchangeHolder holder = _bidItems.get(key);
            long currentTime = System.currentTimeMillis();
            long endTime = holder.getEndTime();
            if (endTime > currentTime) {
                continue;
            }
            WorldExchangeItemStatusType currentBidType = holder.getStoreType();
            switch (currentBidType) {
                case WORLD_EXCHANGE_NONE:
                    _bidItems.remove(key);
                    break;
                case WORLD_EXCHANGE_REGISTERED:
                {
                    holder.setEndTime(calculateDate(Config.WORLD_EXCHANGE_ITEM_BACK_PERIOD));
                    holder.setStoreType(WorldExchangeItemStatusType.WORLD_EXCHANGE_OUT_TIME);
                    _bidItems.replace(key, holder);
                    storeMe(key, false);
                }
                break;
                case WORLD_EXCHANGE_OUT_TIME:
                case WORLD_EXCHANGE_SOLD: {
                    holder.setStoreType(WorldExchangeItemStatusType.WORLD_EXCHANGE_NONE);
                    storeMe(key, true);
                    ItemInstance instance = holder.getItemInstance();
                    instance.setLocation(ItemLocation.VOID);
                    instance.updated(true);
                }
                break;
            }
        }
    }

    /**
     * @implNote Load items from database for make proper holders
     **/
    synchronized Map<Integer, ItemInstance> loadItemInstances() {
        if (!Config.ENABLE_WORLD_EXCHANGE) {
            return null;
        }
        final Map<Integer, ItemInstance> itemInstances = new ConcurrentHashMap<>();
        try (Connection con = DatabaseFactory.getInstance().getConnection(); PreparedStatement ps = con.prepareStatement(SELECT_ALL_ITEMS))
        {
            ps.setString(1, ItemLocation.WORLD_EXCH.name());
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                final ItemInstance itemInstance = restoreItem(rs);
                itemInstances.put(itemInstance.getObjectId(), itemInstance);
            }
        } catch (SQLException e) {
            LOGGER.warn(getClass().getSimpleName() + ": Failed loading items instances.", e);
        }
        return itemInstances;
    }

    private ItemInstance restoreItem(ResultSet rs) throws SQLException
    {
        ItemInstance item = new ItemInstance(rs.getInt(1), rs.getInt(3));
        item.setOwnerId(rs.getInt(2));
        item.setItemId(rs.getInt(3));
        item.setCount(rs.getLong(4));
        item.setEnchantLevel(rs.getInt(5));
        item.setLocName(rs.getString(6));
        item.setLocData(rs.getInt(7));
        item.setCustomType1(rs.getInt(8));
        item.setCustomType2(rs.getInt(9));
        item.setLifeTime(rs.getInt(10));
        item.setCustomFlags(rs.getInt(11));
        item.setVariationStoneId(rs.getInt(12));
        item.setVariation1Id(rs.getInt(13));
        item.setVariation2Id(rs.getInt(14));
        item.getAttributes().setFire(rs.getInt(15));
        item.getAttributes().setWater(rs.getInt(16));
        item.getAttributes().setWind(rs.getInt(17));
        item.getAttributes().setEarth(rs.getInt(18));
        item.getAttributes().setHoly(rs.getInt(19));
        item.getAttributes().setUnholy(rs.getInt(20));
        item.setAgathionEnergy(rs.getInt(21));
        item.setAppearanceStoneId(rs.getInt(22));
        item.setVisualId(rs.getInt(23));
        item.restoreEnsoul();
        return item;
    }

    /**
     * @implNote Loading all items, which used or using in World Exchange
     **/
    synchronized void loadBidItems(Map<Integer, ItemInstance> itemInstances) {
        if (!Config.ENABLE_WORLD_EXCHANGE) {
            return;
        }
        try (Connection con = DatabaseFactory.getInstance().getConnection(); PreparedStatement ps = con.prepareStatement(RESTORE_INFO)) {
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                boolean needChange = false;
                final long worldExchangeId = rs.getLong("world_exchange_id");
                _lastWorldExchangeID = Math.max(worldExchangeId, _lastWorldExchangeID);
                final ItemInstance itemInstance = itemInstances.getOrDefault(rs.getInt("item_object_id"), null);
                WorldExchangeItemStatusType storeType = WorldExchangeItemStatusType.getWorldExchangeItemStatusType(rs.getInt("item_status"));
                if (storeType == WorldExchangeItemStatusType.WORLD_EXCHANGE_NONE) {
                    continue;
                }
                if (itemInstance == null) {
                    continue;
                }
                final WorldExchangeItemSubType categoryId = WorldExchangeItemSubType.getWorldExchangeItemSubType(rs.getInt("category_id"));
                final long price = rs.getLong("price");
                final int bidPlayerObjectID = rs.getInt("old_owner_id");
                final long startTime = rs.getLong("start_time");
                long endTime = rs.getLong("end_time");
                final int currency = rs.getInt("currency");
                if (endTime < System.currentTimeMillis()) {
                    if (storeType == WorldExchangeItemStatusType.WORLD_EXCHANGE_OUT_TIME || storeType == WorldExchangeItemStatusType.WORLD_EXCHANGE_SOLD) {
                        itemInstance.setLocation(ItemLocation.VOID);
                        itemInstance.updated(true);
                        continue;
                    }
                    endTime = calculateDate(Config.WORLD_EXCHANGE_ITEM_BACK_PERIOD);
                    storeType = WorldExchangeItemStatusType.WORLD_EXCHANGE_OUT_TIME;
                    needChange = true;
                }
                _bidItems.put(worldExchangeId, new WorldExchangeHolder(worldExchangeId, itemInstance, new ItemInfo(itemInstance), price, bidPlayerObjectID, storeType, categoryId, startTime, endTime, needChange, currency));
            }
        } catch (Exception e) {
            LOGGER.warn(getClass().getSimpleName() + ": Failed loading bid items.", e);
        }
    }

    /**
     * @implNote forwarded from client packet "ExWorldExchangeRegisterItem" for check ops and register ItemInstance if it can in World Exchange system
     **/
    public synchronized void registerBidItem(Player player, int itemObjectID, long amount, long priceForEach, int currency) {
        if (!Config.ENABLE_WORLD_EXCHANGE) {
            return;
        }

        final InventoryUpdatePacket iu = new InventoryUpdatePacket();
        final ItemInstance item = player.getInventory().getItemByObjectId(itemObjectID);

        if (item == null)
        {
            // System message = you cannot register item, which you don't have
            player.sendPacket(new SystemMessage(SystemMessage.THE_ITEM_IS_NOT_FOUND));
            player.sendPacket(ExWorldExchangeRegiItem.FAIL);
            return;
        }

        if(!item.isStackable() && amount > 1){
            player.sendPacket(new SystemMessage(SystemMessage.INCORRECT_ITEM_COUNT));
            player.sendPacket(ExWorldExchangeRegiItem.FAIL);
            return;
        }

        Map<WorldExchangeItemStatusType, List<WorldExchangeHolder>> playerBids = getPlayerBids(player.getObjectId());
        if (playerBids != null && playerBids.values().size() >= 10)
        {
            // System message = out of slots
            player.sendPacket(new SystemMessage(SystemMessage.YOU_HAVE_NO_OPEN_MY_TELEPORTS_SLOTS));
            player.sendPacket(ExWorldExchangeRegiItem.FAIL);
            return;
        }

        if ((amount < 1) || (priceForEach < 1) || ((amount * priceForEach) < 1))
        {
            player.sendPacket(new SystemMessage(SystemMessage.INCORRECT_ITEM_COUNT));
            player.sendPacket(ExWorldExchangeRegiItem.FAIL);
            return;
        }

        long amountModifier = amount;

        if (item.getItemId() == ItemTemplate.ITEM_ID_ADENA)
        {
            if (amount >= 10_000_000)
            {
                amountModifier = amount / 10_000_000;
            }
        }

        long totalPrice = priceForEach * amountModifier;
//        long feePrice = Math.round(totalPrice);
//        if (max_adena_fee != -1 && feePrice > max_adena_fee || feePrice < 20)
//        {
//            feePrice = max_adena_fee;
//        }
//
//        if (feePrice > player.getAdena() || feePrice < 20)
//        {
//            // System message = not enough adena
//            player.sendPacket(new SystemMessage(SystemMessage.NOT_ENOUGH_ADENA));
//            player.sendPacket(WorldExchangeRegisterItem.FAIL);
//            return;
//        }


//        int feeLCoint = (int) Math.round(feePrice * 0.05);
        ItemInstance playerLCoin = player.getInventory().getItemByItemId(ItemTemplate.ITEM_ID_MONEY_L);

//        if(playerLCoin == null || playerLCoin.getCount() < feeLCoint || feeLCoint < 1){
//            player.sendPacket(new SystemMessage(SystemMessage.INCORRECT_ITEM_COUNT_2));
//            player.sendPacket(WorldExchangeRegisterItem.FAIL);
//            return;
//        }

//        long adenaFee = totalPrice * 100;
        ItemInstance playerLAdena = player.getInventory().getItemByItemId(ItemTemplate.ITEM_ID_ADENA);

//        if(playerLAdena == null || playerLAdena.getCount() < adenaFee || adenaFee < 1){
//            player.sendPacket(new SystemMessage(SystemMessage.INCORRECT_ITEM_COUNT_2));
//            player.sendPacket(WorldExchangeRegisterItem.FAIL);
//            return;
//        }

        // Списываем налог адены
//        if(!player.getInventory().reduceAdena("World Exchange Registration", adenaFee, player, null)){
//            // System message = not enough adena
//            player.sendPacket(new SystemMessage(SystemMessage.NOT_ENOUGH_ADENA));
//            player.sendPacket(WorldExchangeRegisterItem.FAIL);
//            return;
//        }

//        // Списываем налог L coin
//        if(!player.getInventory().reduceLCoint("World Exchange Registration", feeLCoint, player, null)){
//            // System message = not enough l coin
//            player.sendPacket(new SystemMessage(SystemMessage.INCORRECT_ITEM_COUNT_2));
//            player.sendPacket(WorldExchangeRegisterItem.FAIL);
//            return;
//        }

        if (playerLAdena != null)
        iu.addModifiedItem(player, playerLAdena);

        if (playerLCoin != null)
        iu.addModifiedItem(player, playerLCoin);

        long freeID = getFreeID();

        final ItemInstance itemToRemove = player.getInventory().getItemByObjectId(itemObjectID);
        final ItemInstance removedItem = transferItemIntoWorldExchangeLocation(player, itemObjectID, amount);
        if (removedItem == null)
        {
            // System message = you cannot register item, which you don't have
            player.sendPacket(new SystemMessage(SystemMessage.THE_ITEM_IS_NOT_FOUND));
            player.sendPacket(ExWorldExchangeRegiItem.FAIL);
            return;
        }

//        final int itemSubType = PrivateStoreManager.getInstance().getItemSubType(removedItem.getItemId()).ordinal();
//        final WorldExchangeItemSubType category = WorldExchangeItemSubType.getWorldExchangeItemSubType(itemSubType);

        final WorldExchangeItemSubType category = _itemCategories.get(removedItem.getItemId());
        if (category == null)
        {
            // System message = you cannot register item, which you don't have
            player.sendPacket(new SystemMessage(SystemMessage.THE_ITEM_YOU_REGISTERED_HAS_BEEN_SOLD));
            player.sendPacket(ExWorldExchangeRegiItem.FAIL);
            return;
        }

        // Если весь предмет переместился в WORLD_EXCH (getCount() == amount)
        final boolean itemMoved = ItemLocation.WORLD_EXCH.equals(itemToRemove.getLocation());
        final boolean isStackable = itemToRemove.isStackable();
        if (!isStackable || itemMoved) {
            iu.addRemovedItem(player, itemToRemove);
        } else { // обновляем старый (имеющийся) предмет..
            iu.addModifiedItem(player, itemToRemove);
        }

        // send IU
        player.sendPacket(iu);


        long endTime = calculateDate(Config.WORLD_EXCHANGE_ITEM_SELL_PERIOD);
        _bidItems.put(freeID, new WorldExchangeHolder(freeID, removedItem, new ItemInfo(removedItem), priceForEach, player.getObjectId(), WorldExchangeItemStatusType.WORLD_EXCHANGE_REGISTERED, category, System.currentTimeMillis(), endTime, true, currency));
        player.sendPacket(new ExWorldExchangeRegiItem(removedItem.getItemId(), amount, (byte) 1));
        if (!Config.WORLD_EXCHANGE_LAZY_UPDATE) {
            storeMe(freeID, false);
        }

    }

    private long getFreeID() {
        _lastWorldExchangeID = _lastWorldExchangeID + 1;
        return _lastWorldExchangeID;
    }

    private long calculateDate(int Days) {
        Calendar returnTime = Calendar.getInstance();
        returnTime.add(Calendar.DATE, Days);
        return returnTime.getTimeInMillis();
    }

    /**
     * @implNote forwarded from ExWorldExchangeSettleRecvResult for make Action, because client send only WE Index without anu addition info
     **/
    public void getItemStatusAndMakeAction(Player player, long worldExchangeIndex) {
        if (!Config.ENABLE_WORLD_EXCHANGE) {
            return;
        }
        WorldExchangeHolder worldExchangeItem = _bidItems.getOrDefault(worldExchangeIndex, null);
        if (worldExchangeItem == null) {
            player.sendPacket(new SystemMessage(SystemMessage.THE_ITEM_IS_NOT_FOUND));
            player.sendPacket(ExWorldExchangeSettleRecvResult.FAIL);
            return;
        }
        WorldExchangeItemStatusType storeType = worldExchangeItem.getStoreType();
        switch (storeType) {
            case WORLD_EXCHANGE_REGISTERED:
                cancelBid(player, worldExchangeItem);
                break;
            case WORLD_EXCHANGE_SOLD:
                tookBidMoney(player, worldExchangeItem);
                break;
            case WORLD_EXCHANGE_OUT_TIME:
                tookOutItemBack(player, worldExchangeItem);
                break;
        }
    }

    /**
     * @param player
     * @param worldExchangeItem
     * @implNote forwarded from getItemStatusAndMakeAction / remove ItemInstance and holder from active bid and take it back to owner
     */
    private void cancelBid(Player player, WorldExchangeHolder worldExchangeItem) {
        if (!Config.ENABLE_WORLD_EXCHANGE) {
            return;
        }
        if (worldExchangeItem.getStoreType() == WorldExchangeItemStatusType.WORLD_EXCHANGE_NONE) {
            player.sendPacket(new ExWorldExchangeSettleList(player));
            player.sendPacket(new SystemMessage(SystemMessage.THE_ITEM_IS_NOT_FOUND));
            player.sendPacket(ExWorldExchangeSettleRecvResult.FAIL);
            return;
        }
        if (_bidItems.getOrDefault(worldExchangeItem.getWorldExchangeID(), null) == null) {
            player.sendPacket(new ExWorldExchangeSettleList(player));
            player.sendPacket(new SystemMessage(SystemMessage.THE_ITEM_IS_NOT_FOUND));
            player.sendPacket(ExWorldExchangeSettleRecvResult.FAIL);
            return;
        }
        if (_bidItems.get(worldExchangeItem.getWorldExchangeID()) != worldExchangeItem) {
            player.sendPacket(new ExWorldExchangeSettleList(player));
            player.sendPacket(new SystemMessage(SystemMessage.THE_ITEM_IS_NOT_FOUND));
            player.sendPacket(ExWorldExchangeSettleRecvResult.FAIL);
            return;
        }
        if (player.getObjectId() != worldExchangeItem.getOldOwnerId()) {
            player.sendPacket(new SystemMessage(SystemMessage.ITEM_OUT_OF_STOCK));
            player.sendPacket(ExWorldExchangeSettleRecvResult.FAIL);
            return;
        }
        if (worldExchangeItem.getStoreType() == WorldExchangeItemStatusType.WORLD_EXCHANGE_SOLD) {
            player.sendPacket(new ExWorldExchangeSettleList(player));
            player.sendPacket(new SystemMessage(SystemMessage.THE_ITEM_YOU_REGISTERED_HAS_BEEN_SOLD));
            player.sendPacket(ExWorldExchangeSettleRecvResult.FAIL);
            return;
        }
        final ItemInstance weItemInstance = worldExchangeItem.getItemInstance();
        player.sendPacket(new ExWorldExchangeSettleRecvResult(weItemInstance.getObjectId(), weItemInstance.getCount(), (byte) 1));
        worldExchangeItem.setStoreType(WorldExchangeItemStatusType.WORLD_EXCHANGE_NONE);
        worldExchangeItem.setHasChanges(true);
        _bidItems.replace(worldExchangeItem.getWorldExchangeID(), worldExchangeItem);
        synchronized (weItemInstance)
        {
            player.getInventory().addItem(weItemInstance);
        }
        if (!Config.WORLD_EXCHANGE_LAZY_UPDATE) {
            storeMe(worldExchangeItem.getWorldExchangeID(), true);
        }
    }

    /**
     * @param player
     * @param worldExchangeItem
     * @implNote forwarded from getItemStatusAndMakeAction / takes money from bid
     * @implSpec shown ItemInstance will delete? after claim money
     */
    private void tookBidMoney(Player player, WorldExchangeHolder worldExchangeItem) {
        if (!Config.ENABLE_WORLD_EXCHANGE) {
            return;
        }
        if (worldExchangeItem.getStoreType() == WorldExchangeItemStatusType.WORLD_EXCHANGE_NONE) {
            player.sendPacket(new ExWorldExchangeSettleList(player));
            player.sendPacket(new SystemMessage(SystemMessage.THE_ITEM_IS_NOT_FOUND));
            player.sendPacket(ExWorldExchangeSettleRecvResult.FAIL);
            return;
        }
        if (_bidItems.getOrDefault(worldExchangeItem.getWorldExchangeID(), null) == null) {
            player.sendPacket(new ExWorldExchangeSettleList(player));
            player.sendPacket(new SystemMessage(SystemMessage.THE_ITEM_IS_NOT_FOUND));
            player.sendPacket(ExWorldExchangeSettleRecvResult.FAIL);
            return;
        }
        if (_bidItems.get(worldExchangeItem.getWorldExchangeID()) != worldExchangeItem) {
            player.sendPacket(new ExWorldExchangeSettleList(player));
            player.sendPacket(new SystemMessage(SystemMessage.THE_ITEM_IS_NOT_FOUND));
            player.sendPacket(ExWorldExchangeSettleRecvResult.FAIL);
            return;
        }
        if (player.getObjectId() != worldExchangeItem.getOldOwnerId()) {
            player.sendPacket(new SystemMessage(SystemMessage.THE_ITEM_IS_NOT_FOUND));
            player.sendPacket(ExWorldExchangeSettleRecvResult.FAIL);
            return;
        }
        if (worldExchangeItem.getStoreType() != WorldExchangeItemStatusType.WORLD_EXCHANGE_SOLD) {
            player.sendPacket(new ExWorldExchangeSettleList(player));
            player.sendPacket(new SystemMessage(SystemMessage.THE_ITEM_YOU_REGISTERED_HAS_BEEN_SOLD));
            player.sendPacket(ExWorldExchangeSettleRecvResult.FAIL);
            return;
        }
        if (worldExchangeItem.getEndTime() < System.currentTimeMillis()) {
            player.sendPacket(new ExWorldExchangeSettleList(player));
            player.sendPacket(new SystemMessage(SystemMessage.THE_REGISTRATION_PERIOD_FOR_THE_ITEM_YOU_REGISTERED_HAS_EXPIRED));
            player.sendPacket(ExWorldExchangeSettleRecvResult.FAIL);
            return;
        }
        player.sendPacket(new ExWorldExchangeSettleRecvResult(worldExchangeItem.getItemInstance().getObjectId(), worldExchangeItem.getItemInstance().getCount(), (byte) 1));
        long return_price = worldExchangeItem.getPrice(); // floating-point accuracy workaround :D
//        if (worldExchangeItem.getCurrency() != 57 && max_lcoin_fee != -1 && return_price > max_lcoin_fee) {
//            return_price = max_lcoin_fee;
//        }
        ItemInstance returnItem = player.getInventory().addItem(worldExchangeItem.getCurrency(), (return_price), 0);
        worldExchangeItem.setStoreType(WorldExchangeItemStatusType.WORLD_EXCHANGE_NONE);
        ItemInstance item = worldExchangeItem.getItemInstance();
        item.setLocation(ItemLocation.VOID);
        item.updated(!Config.WORLD_EXCHANGE_LAZY_UPDATE);
        worldExchangeItem.setHasChanges(true);
        _bidItems.replace(worldExchangeItem.getWorldExchangeID(), worldExchangeItem);
        if (!Config.WORLD_EXCHANGE_LAZY_UPDATE) {
            storeMe(worldExchangeItem.getWorldExchangeID(), true);
        }
        InventoryUpdatePacket inventoryUpdatePacket = new InventoryUpdatePacket();
        if (returnItem.getCount() == (worldExchangeItem.getCount()))
        {
            inventoryUpdatePacket.addNewItem(player, returnItem);
        }
        else
        {
            inventoryUpdatePacket.addModifiedItem(player, returnItem);
        }
        player.sendPacket(inventoryUpdatePacket);
    }

    /**
     * @param player
     * @param worldExchangeItem
     * @implNote forwarded from getItemStatusAndMakeAction / take back ItemInstance which placed on World Exchange
     * @implSpec adena fee will not back!
     */
    private void tookOutItemBack(Player player, WorldExchangeHolder worldExchangeItem) {
        if (!Config.ENABLE_WORLD_EXCHANGE) {
            return;
        }
        if (worldExchangeItem.getStoreType() == WorldExchangeItemStatusType.WORLD_EXCHANGE_NONE) {
            player.sendPacket(new ExWorldExchangeSettleList(player));
            player.sendPacket(new SystemMessage(SystemMessage.THE_ITEM_IS_NOT_FOUND));
            player.sendPacket(ExWorldExchangeSettleRecvResult.FAIL);
            return;
        }
        if (_bidItems.getOrDefault(worldExchangeItem.getWorldExchangeID(), null) == null) {
            player.sendPacket(new ExWorldExchangeSettleList(player));
            player.sendPacket(new SystemMessage(SystemMessage.THE_ITEM_IS_NOT_FOUND));
            // System String "you cannot back item, which out date"
            player.sendPacket(ExWorldExchangeSettleRecvResult.FAIL);
            return;
        }
        if (_bidItems.get(worldExchangeItem.getWorldExchangeID()) != worldExchangeItem) {
            player.sendPacket(new ExWorldExchangeSettleList(player));
            player.sendPacket(new SystemMessage(SystemMessage.ITEM_OUT_OF_STOCK));
            // System String "you cannot back item, which out date"
            player.sendPacket(ExWorldExchangeSettleRecvResult.FAIL);
            return;
        }
        if (player.getObjectId() != worldExchangeItem.getOldOwnerId()) {
            player.sendPacket(new SystemMessage(SystemMessage.ITEM_TO_BE_TRADED_DOES_NOT_EXIST));
            player.sendPacket(ExWorldExchangeSettleRecvResult.FAIL);
            return;
        }
        if (worldExchangeItem.getStoreType() != WorldExchangeItemStatusType.WORLD_EXCHANGE_OUT_TIME) {
            player.sendPacket(new ExWorldExchangeSettleList(player));
            player.sendPacket(new SystemMessage(SystemMessage.ITEM_OUT_OF_STOCK));
            // System String "you cannot back item, which sold"
            player.sendPacket(ExWorldExchangeSettleRecvResult.FAIL);
            return;
        }
        if (worldExchangeItem.getEndTime() < System.currentTimeMillis()) {
            player.sendPacket(new ExWorldExchangeSettleList(player));
            player.sendPacket(new SystemMessage(SystemMessage.THE_REGISTRATION_PERIOD_FOR_THE_ITEM_YOU_REGISTERED_HAS_EXPIRED));
            // System String "you cannot back item, which not exist"
            player.sendPacket(ExWorldExchangeSettleRecvResult.FAIL);
            return;
        }
        player.sendPacket(new ExWorldExchangeSettleRecvResult(worldExchangeItem.getItemInstance().getObjectId(), worldExchangeItem.getItemInstance().getCount(), (byte) 1));
        ItemInstance lcoinInstance = transferItemToNewOwner(player, worldExchangeItem);
        worldExchangeItem.setStoreType(WorldExchangeItemStatusType.WORLD_EXCHANGE_NONE);
        worldExchangeItem.setHasChanges(true);
        long return_price = worldExchangeItem.getPrice(); // floating-point accuracy workaround :D
        _bidItems.replace(worldExchangeItem.getWorldExchangeID(), worldExchangeItem);
        if (!Config.WORLD_EXCHANGE_LAZY_UPDATE) {
            storeMe(worldExchangeItem.getWorldExchangeID(), true);
        }
        InventoryUpdatePacket inventoryUpdatePacket = new InventoryUpdatePacket();
        if (lcoinInstance.getCount() == (return_price))
        {
            inventoryUpdatePacket.addNewItem(player, lcoinInstance);
        }
        else
        {
            inventoryUpdatePacket.addModifiedItem(player, lcoinInstance);
        }
        player.sendPacket(inventoryUpdatePacket);
        player.sendPacket(new ExBloodyCoinCount(player));
    }

    /**
     * @implNote forwarded from ExWorldExchangeBuyItem / request for but ItemInstance and create a visible clone for old owner
     */
    public void buyItem(Player player, long worldExchangeID) {
        if (!Config.ENABLE_WORLD_EXCHANGE) {
            return;
        }
        if (_bidItems.getOrDefault(worldExchangeID, null) == null) {
            player.sendPacket(new SystemMessage(SystemMessage.THE_ITEM_IS_NOT_FOUND));
            player.sendPacket(ExWorldExchangeBuyItem.FAIL);
            return;
        }
        WorldExchangeHolder worldExchangeItem = _bidItems.get(worldExchangeID);
        if (worldExchangeItem.getOldOwnerId() == player.getObjectId())
        {
            player.sendPacket(new SystemMessage(SystemMessage.THE_ITEM_IS_NOT_FOUND));
            player.sendPacket(ExWorldExchangeBuyItem.FAIL);
            return;
        }
        if (worldExchangeItem.getStoreType() == WorldExchangeItemStatusType.WORLD_EXCHANGE_NONE) {
            player.sendPacket(new SystemMessage(SystemMessage.THE_ITEM_IS_NOT_FOUND));
            player.sendPacket(ExWorldExchangeBuyItem.FAIL);
            return;
        }
        if (worldExchangeItem.getStoreType() != WorldExchangeItemStatusType.WORLD_EXCHANGE_REGISTERED) {
            // System String "you cannot back item, which sold"
            player.sendPacket(new SystemMessage(SystemMessage.ITEM_OUT_OF_STOCK));
            player.sendPacket(ExWorldExchangeBuyItem.FAIL);
            return;
        }
        ItemInstance adena = player.getInventory().getItemByItemId(ItemTemplate.ITEM_ID_ADENA);
        ItemInstance lCoin = player.getInventory().getItemByItemId(ItemTemplate.ITEM_ID_MONEY_L);

        // проверяет валюты и списывает их
        if(worldExchangeItem.getCurrency() == 57){
            if (checkPlayerCurrency(player, worldExchangeItem, adena)) return;
        }
        else {
            if (checkPlayerCurrency(player, worldExchangeItem, lCoin)) return;
        }

        ItemInstance newItem = createNewItem(worldExchangeItem.getItemInstance(), player);
        long destroyTime = calculateDate(Config.WORLD_EXCHANGE_PAYMENT_TAKE_PERIOD);
        WorldExchangeHolder newHolder = new WorldExchangeHolder(worldExchangeID, newItem, new ItemInfo(newItem), worldExchangeItem.getPrice(), worldExchangeItem.getOldOwnerId(), WorldExchangeItemStatusType.WORLD_EXCHANGE_SOLD, worldExchangeItem.getCategory(), worldExchangeItem.getStartTime(), destroyTime, true, worldExchangeItem.getCurrency());
        _bidItems.replace(worldExchangeID, worldExchangeItem, newHolder);

        if (!Config.WORLD_EXCHANGE_LAZY_UPDATE) {
            storeMe(worldExchangeItem.getWorldExchangeID(), false);
        }

        // send updated L-Coin info after purchase
        final InventoryUpdatePacket iu = new InventoryUpdatePacket();
        if (lCoin.getCount() == 0) {
            iu.addRemovedItem(player, lCoin);
        } else {
            iu.addModifiedItem(player, lCoin);
        }
        player.sendPacket(iu);

        ItemInstance receivedItem = transferItemToNewOwner(player, worldExchangeItem);
        player.sendPacket(new ExWorldExchangeBuyItem(receivedItem.getObjectId(), receivedItem.getCount(), (byte) 1));

        // Send different system messages if item is enchanted
        if (receivedItem.getEnchantLevel() > 0) {
            player.sendPacket(new SystemMessage(SystemMessage.YOU_HAVE_OBTAINED__S1S2).addNumber(receivedItem.getEnchantLevel()).addItemName(receivedItem.getItemId()));
        } else {
            player.sendPacket(new SystemMessage(SystemMessage.YOU_HAVE_OBTAINED_S2_S1).addItemName(receivedItem.getItemId()).addNumber(worldExchangeItem.getItemInfo().getCount()));
        }

        Player oldOwner = GameObjectsStorage.getPlayer(newHolder.getOldOwnerId());
        if (oldOwner != null)
        {
            oldOwner.sendPacket(new ExWorldExchangeSellCompleteAlarm(newItem.getItemId(), newItem.getCount()));
        }

        InventoryUpdatePacket inventoryUpdatePacket = new InventoryUpdatePacket();
        if (receivedItem.getCount() == (worldExchangeItem.getCount()))
        {
            inventoryUpdatePacket.addNewItem(player, receivedItem);
        }
        else
        {
            inventoryUpdatePacket.addModifiedItem(player, receivedItem);
        }
        player.sendPacket(inventoryUpdatePacket);
    }

    private boolean checkPlayerCurrency(Player player, WorldExchangeHolder worldExchangeItem, ItemInstance coin) {
        if (coin == null || coin.getCount() < worldExchangeItem.getPrice()) {
            player.sendPacket(new SystemMessage(SystemMessage.YOU_DO_NOT_HAVE_ENOUGH_L2_COINS_ADD_MORE_L2_COINS_AND_TRY_AGAIN));
            player.sendPacket(ExWorldExchangeBuyItem.FAIL);
            return true;
        }
        player.getInventory().destroyItem(coin, worldExchangeItem.getPrice());
        return false;
    }

    /**
     * @param oldItem ItemInstance from holder which will be "cloned"
     * @return cloned ItemInstance
     * @implNote create a new ItemInstance for make it visible in UI for old owner
     */
    private ItemInstance createNewItem(ItemInstance oldItem, Player requestor) {

        ItemInstance newItem = new ItemInstance(IdFactory.getInstance().getNextId());
        newItem.setOwnerId(requestor.getObjectId());
        newItem.setItemId(oldItem.getItemId());
        newItem.setCount(oldItem.getCount());
        newItem.setEnchantLevel(oldItem.getEnchantLevel() < 1 ? 0 : oldItem.getEnchantLevel());
        newItem.setLocation(ItemLocation.WORLD_EXCH);
        newItem.setLocData(-1);
        newItem.setCustomType1(oldItem.getCustomType1());
        newItem.setCustomType2(oldItem.getCustomType2());
        newItem.setLifeTime(oldItem.getLifeTime());
        newItem.setCustomFlags(oldItem.getCustomFlags());
        newItem.setVariationStoneId(oldItem.getVariationStoneId());
        newItem.setVariation1Id(oldItem.getVariation1Id());
        newItem.setVariation2Id(oldItem.getVariation2Id());
        newItem.getAttributes().setFire(oldItem.getAttributes().getFire());
        newItem.getAttributes().setWater(oldItem.getAttributes().getWater());
        newItem.getAttributes().setWind(oldItem.getAttributes().getWind());
        newItem.getAttributes().setEarth(oldItem.getAttributes().getEarth());
        newItem.getAttributes().setHoly(oldItem.getAttributes().getHoly());
        newItem.getAttributes().setUnholy(oldItem.getAttributes().getUnholy());
        newItem.setAgathionEnergy(oldItem.getAgathionEnergy());
        newItem.setAppearanceStoneId(oldItem.getAppearanceStoneId());
        newItem.setVisualId(oldItem.getVisualId());
        if (oldItem.getNormalEnsouls() != null)
        {
            for (Ensoul ensoul : oldItem.getNormalEnsouls())
            {
                if (ensoul == null)
                {
                    continue;
                }
                newItem.addEnsoul(1, ensoul.getId(), ensoul, false);
            }
        }
        if (oldItem.getSpecialEnsouls() != null)
        {
            for (Ensoul ensoul : oldItem.getSpecialEnsouls())
            {
                if (ensoul == null)
                {
                    continue;
                }
                newItem.addEnsoul(2, ensoul.getId(), ensoul, false);
            }
        }
        newItem.updated(true); // in any case it will be store in database
        return newItem;
    }

    /**
     * @implNote return items, which PlayerInstance can buy
     */
    public List<WorldExchangeHolder> getBidItems(int playerId, List<Integer> IDS, WorldExchangeItemSubType type, WorldExchangeSortType sortType, int page, String lang, int curSorType) {

        if (!Config.ENABLE_WORLD_EXCHANGE) {
            return null;
        }

        List<WorldExchangeHolder> returnList = new ArrayList<>();
        for (WorldExchangeHolder holder : _bidItems.values()) {
            if (curSorType != 0) {
                if(holder.getCurrency() == 57 && (curSorType != 2)) {
                    continue;
                }
                if(holder.getCurrency() == 4037 && (curSorType != 1)) {
                    continue;
                }
            }
            if (!IDS.isEmpty() && !IDS.contains(holder.getItemInstance().getItemId())) {
                continue;
            }
            if (holder.getStoreType() == WorldExchangeItemStatusType.WORLD_EXCHANGE_NONE) {
                continue;
            }
            if (holder.getOldOwnerId() == playerId || holder.getCategory() != type) {
                continue;
            }
            if (holder.getStoreType() == WorldExchangeItemStatusType.WORLD_EXCHANGE_REGISTERED) {
                returnList.add(holder);
            }
        }

        final int total = returnList.size();
        final int perPage = 100;
        final int startFrom = Math.min(perPage * page, total);
        final int endAt = Math.min((page + 1) * perPage, total);

        return sortList(returnList.subList(startFrom, endAt), sortType, lang);
    }

    /**
     * @return items with the same id (used in registration, where shows similar items with price)
     */
    public List<WorldExchangeHolder> getBidItems(List<Integer> IDs, WorldExchangeSortType sortType, int page, String lang) {
        if (!Config.ENABLE_WORLD_EXCHANGE) {
            return null;
        }

        List<WorldExchangeHolder> returnList = new ArrayList<>();
        for (WorldExchangeHolder holder : _bidItems.values()) {
            if (holder.getStoreType() == WorldExchangeItemStatusType.WORLD_EXCHANGE_NONE) {
                continue;
            }
            if (IDs.contains(holder.getItemInstance().getItemId()) && holder.getStoreType() == WorldExchangeItemStatusType.WORLD_EXCHANGE_REGISTERED) {
                returnList.add(holder);
            }
        }

        final int total = returnList.size();
        final int perPage = 100;
        final int startFrom = Math.min(perPage * page, total);
        final int endAt = Math.min((page + 1) * perPage, total);

        return sortList(returnList.subList(startFrom, endAt), sortType, lang);
    }

    /**
     * @return sort items by type if it needs
     * 399 - that max value which can been in list
     * buffer size - 32768 - list has 11 + cycle of 82 bytes - 32768 / 82 = 399.6 = 32718 for item info + 50 reserved = 32729 item info and initial data + 39 reserved
     */
    private List<WorldExchangeHolder> sortList(List<WorldExchangeHolder> unsortedList, WorldExchangeSortType sortType, String lang) {
        List<WorldExchangeHolder> sortedList = new ArrayList<>(unsortedList);

        final Stream<WorldExchangeHolder> listStream = sortedList.stream();

        switch (sortType)
        {
            case NONE:
                break;
            case PRICE_ASCE:
                sortedList = listStream.sorted(Comparator.comparing(WorldExchangeHolder::getPrice)).collect(Collectors.toList());
                break;
            case PRICE_DESC:
                sortedList = listStream.sorted(Comparator.comparing(WorldExchangeHolder::getPrice, reverseOrder())).collect(Collectors.toList());
                break;
            case ITEM_NAME_ASCE:
                sortedList = listStream.sorted(Comparator.comparing(o -> ((o.getItemInstance().isBlessed() ? "Blessed " : "") + o.getItemInstance().getName()))).collect(Collectors.toList());
                break;
            case AMOUNT_ASCE:
                sortedList = listStream.sorted(Comparator.comparing(WorldExchangeHolder::getCount)).collect(Collectors.toList());
                break;
            case AMOUNT_DESC:
                sortedList = listStream.sorted(Comparator.comparing(WorldExchangeHolder::getCount, reverseOrder())).collect(Collectors.toList());
                break;
            case PRICE_PER_PIECE_ASCE:
                sortedList = listStream.sorted(Comparator.comparing(WorldExchangeHolder::getPricePerPiece)).collect(Collectors.toList());
                break;
            case PRICE_PER_PIECE_DESC:
                sortedList = listStream.sorted(Comparator.comparing(WorldExchangeHolder::getPricePerPiece, reverseOrder())).collect(Collectors.toList());
                break;
            case ENCHANT_ASCE:
                sortedList = listStream.sorted(Comparator.comparing(WorldExchangeHolder::getItemEnchant)).collect(Collectors.toList());
                break;
            case ENCHANT_DESC:
                sortedList = listStream.sorted(Comparator.comparing(WorldExchangeHolder::getItemEnchant, reverseOrder())).collect(Collectors.toList());
                break;
        }

        return sortedList;
    }

//    private String getItemName(String lang, int id, boolean isBlessed) {
//        String name = "";
//        if (isBlessed) {
//            // TODO: Hardcoded
//            if (lang.equals("ru")) {
//                name = "Благ. ";
//            } else if (lang.equals("en")) {
//                name = "Blessed ";
//            }
//        }
//        return name + ItemNameLocalisationData.getInstance().getItemName(lang, id);
//    }

    /**
     * @return items which will bid PlayerInstance
     */
    public EnumMap<WorldExchangeItemStatusType, List<WorldExchangeHolder>> getPlayerBids(int ownerID) {
        if (!Config.ENABLE_WORLD_EXCHANGE) {
            return null;
        }
        List<WorldExchangeHolder> registered = new ArrayList<>();
        List<WorldExchangeHolder> sold = new ArrayList<>();
        List<WorldExchangeHolder> outTime = new ArrayList<>();
        for (WorldExchangeHolder holder : _bidItems.values()) {

            if (holder.getStoreType() == WorldExchangeItemStatusType.WORLD_EXCHANGE_NONE) {
                continue;
            }

            if (holder.getOldOwnerId() != ownerID) {
                continue;
            }

            switch (holder.getStoreType()) {
                case WORLD_EXCHANGE_REGISTERED:
                    registered.add(holder);
                    break;
                case WORLD_EXCHANGE_SOLD:
                    sold.add(holder);
                    break;
                case WORLD_EXCHANGE_OUT_TIME:
                    outTime.add(holder);
                    break;
            }
        }
        EnumMap<WorldExchangeItemStatusType, List<WorldExchangeHolder>> returnMap = new EnumMap<>(WorldExchangeItemStatusType.class);
        returnMap.put(WorldExchangeItemStatusType.WORLD_EXCHANGE_REGISTERED, registered);
        returnMap.put(WorldExchangeItemStatusType.WORLD_EXCHANGE_SOLD, sold);
        returnMap.put(WorldExchangeItemStatusType.WORLD_EXCHANGE_OUT_TIME, outTime);
        return returnMap;
    }

    /**
     * Will send PlayerInstance alarm on WorldEnter if PlayerInstance has success sold items or items, if time is out
     */
    public void checkPlayerSellAlarm(Player player) {
        if (!Config.ENABLE_WORLD_EXCHANGE) {
            return;
        }
        for (WorldExchangeHolder holder : _bidItems.values()) {
            if (holder.getOldOwnerId() == player.getObjectId() && (holder.getStoreType() == WorldExchangeItemStatusType.WORLD_EXCHANGE_SOLD || holder.getStoreType() == WorldExchangeItemStatusType.WORLD_EXCHANGE_OUT_TIME)) {
                player.sendPacket(new ExWorldExchangeSellCompleteAlarm(holder.getItemInstance().getItemId(), holder.getItemInstance().getCount()));
                break;
            }
        }
    }

    public void storeMe() {
        if (!Config.WORLD_EXCHANGE_LAZY_UPDATE) {
            return;
        }
        try (Connection con = DatabaseFactory.getInstance().getConnection();
             PreparedStatement statement = con.prepareStatement(INSERT_WORLD_EXCHANGE)) {
            for (WorldExchangeHolder holder : _bidItems.values()) {
                if (!holder.isHasChanges()) {
                    continue;
                }
                statement.setLong(1, holder.getWorldExchangeID());
                statement.setLong(2, holder.getItemInstance().getObjectId());
                statement.setInt(3, holder.getStoreType().getId());
                statement.setInt(4, holder.getCategory().getId());
                statement.setLong(5, holder.getPrice());
                statement.setInt(6, holder.getOldOwnerId());
                statement.setString(7, String.valueOf(holder.getStartTime()));
                statement.setString(8, String.valueOf(holder.getEndTime()));
                statement.setInt(9, holder.getCurrency());
                statement.addBatch();
            }
            statement.executeBatch();
            statement.closeOnCompletion();
        } catch (SQLException e) {
            LOGGER.info("Error while saving World Exchange ItemInstance bids:\n", e);
        }
    }

    public void storeMe(long worldExchangeID, boolean remove) {
        if (Config.WORLD_EXCHANGE_LAZY_UPDATE) {
            return;
        }
        try (Connection con = DatabaseFactory.getInstance().getConnection();
             PreparedStatement statement = con.prepareStatement(INSERT_WORLD_EXCHANGE)) {
            WorldExchangeHolder holder = _bidItems.get(worldExchangeID);
            statement.setLong(1, holder.getWorldExchangeID());
            statement.setLong(2, holder.getItemInstance().getObjectId());
            statement.setInt(3, holder.getStoreType().getId());
            statement.setInt(4, holder.getCategory() == null ? 0 : holder.getCategory().getId());
            statement.setLong(5, holder.getPrice());
            statement.setInt(6, holder.getOldOwnerId());
            statement.setString(7, String.valueOf(holder.getStartTime()));
            statement.setString(8, String.valueOf(holder.getEndTime()));
            statement.setInt(9, holder.getCurrency());
            statement.execute();
            if (remove) {
                _bidItems.remove(worldExchangeID);
            }
        } catch (SQLException e) {
            LOGGER.info("Error while saving World Exchange ItemInstance bid " + worldExchangeID + "\n", e);
        }
    }

    public static WorldExchangeManager getInstance() {
        return SingletonHolder.INSTANCE;
    }

    public Set<StatsSet> getTotalInfo(Player player, Set<Integer> itemIds) {
        if (itemIds.isEmpty()) {
            return Collections.emptySet();
        }

        return _bidItems.values()
                .parallelStream()
                .filter(holder -> itemIds.contains(holder.getItemInfo().getItem().getItemId()))
                .map(this::getItemInfo)
                .collect(Collectors.toSet());
    }

    public long getMinPricePerPiece(WorldExchangeHolder holder) {
        final int itemId = holder.getItemInfo().getItem().getItemId();

        return _bidItems.values()
                .parallelStream().filter(itemHolder -> itemHolder.getItemInfo().getItem().getItemId() == itemId)
                .sorted((o1, o2) -> Math.toIntExact(o2.getPrice() - o1.getPrice()))
                .mapToLong(WorldExchangeHolder::getPrice).min().orElse(0L);
    }

    private StatsSet getItemInfo(WorldExchangeHolder holder) {
        final StatsSet itemInfo = new StatsSet();

        itemInfo.set("itemId", holder.getItemInfo().getItem().getItemId());
        itemInfo.set("minPricePerPiece", getMinPricePerPiece(holder));
        itemInfo.set("nPrice", holder.getPrice());
        itemInfo.set("nAmount", holder.getItemInfo().getCount());

        return itemInfo;
    }

    public long getAverageItemPrice(int itemId) {

        final LongStream priceStream = _bidItems.values()
                .stream()
                .filter(holder -> holder.getItemInfo().getItem().getItemId() == itemId)
                .mapToLong(WorldExchangeHolder::getPrice);

        final OptionalDouble average = priceStream.average();
        if (!average.isPresent()) {
            return 0L;
        }

        return (long) ((average.getAsDouble() * 100) / 100);
    }

    public void addCategoryType(List<Integer> itemIds, int category)
    {
        if (!Config.ENABLE_WORLD_EXCHANGE)
        {
            return;
        }

        for (int itemId : itemIds)
        {
            _itemCategories.putIfAbsent(itemId, WorldExchangeItemSubType.getWorldExchangeItemSubType(category));
        }
    }

    private static ItemInstance transferItemIntoWorldExchangeLocation(Player player, int itemObjectId, long requestCount)
    {
        if (player == null || itemObjectId <= 0 || requestCount <= 0)
        {
            return null;
        }
        ItemInstance requestItem = player.getInventory().getItemByObjectId(itemObjectId);
        if (requestItem == null
                || requestItem.getOwnerId() != player.getObjectId()
                || requestItem.getLocation() != ItemLocation.INVENTORY
                || requestItem.getTemplate() == null
                || (!requestItem.getTemplate().isStackable() && requestCount > 1)
                || (requestItem.getCount() < requestCount))
        {
            return null;
        }

        synchronized (requestItem)
        {
            ItemInstance returnItem = player.getInventory().removeItem(requestItem, requestCount);
            returnItem.setLocation(ItemLocation.WORLD_EXCH);
            returnItem.updated(true);
            return returnItem;
        }
    }

    private static ItemInstance transferItemToNewOwner(Player player, WorldExchangeHolder itemHolder)
    {
        if (player == null || itemHolder == null || itemHolder.getItemInstance() == null)
        {
            return null;
        }
        Player oldOwner = GameObjectsStorage.getPlayer(itemHolder.getOldOwnerId());
        ItemInstance cloneItem = cloneItem(itemHolder.getItemInstance());
        if (oldOwner != null)
        {
            oldOwner.getInventory().removeItemByObjectId(itemHolder.getItemInstance().getObjectId(), itemHolder.getCount());
        }
        removeListeners(itemHolder.getItemInstance());
        itemHolder.getItemInstance().delete();
        cloneItem.setCount(itemHolder.getCount());
        cloneItem.setOwnerId(player.getObjectId());
        cloneItem.setLocation(ItemLocation.INVENTORY);
        player.getInventory().addItem(cloneItem);
        cloneItem.updated(true);
        return cloneItem;
    }

    private static ItemInstance cloneItem(ItemInstance detachItem)
    {
        ItemInstance item = new ItemInstance(IdFactory.getInstance().getNextId());
        item.setItemId(detachItem.getItemId());
        item.setCount(detachItem.getCount());
        item.setEnchantLevel(detachItem.getEnchantLevel());
        item.setLocData(-1);
        item.setCustomType1(detachItem.getCustomType1());
        item.setCustomType2(detachItem.getCustomType2());
        item.setLifeTime(detachItem.getLifeTime());
        item.setCustomFlags(detachItem.getCustomFlags());
        item.setVariationStoneId(detachItem.getVariationStoneId());
        item.setVariation1Id(detachItem.getVariation1Id());
        item.setVariation2Id(detachItem.getVariation2Id());
        item.getAttributes().setFire(detachItem.getAttributes().getFire());
        item.getAttributes().setWater(detachItem.getAttributes().getWater());
        item.getAttributes().setWind(detachItem.getAttributes().getWind());
        item.getAttributes().setEarth(detachItem.getAttributes().getEarth());
        item.getAttributes().setHoly(detachItem.getAttributes().getHoly());
        item.getAttributes().setUnholy(detachItem.getAttributes().getUnholy());
        item.setAgathionEnergy(detachItem.getAgathionEnergy());
        item.setAppearanceStoneId(detachItem.getAppearanceStoneId());
        item.setVisualId(detachItem.getVisualId());
        if (detachItem.getNormalEnsouls() != null)
        {
            for (Ensoul ensoul : detachItem.getNormalEnsouls())
            {
                if (ensoul == null)
                {
                    continue;
                }
                item.addEnsoul(1, ensoul.getId(), ensoul, false);
            }
        }
        if (detachItem.getSpecialEnsouls() != null)
        {
            for (Ensoul ensoul : detachItem.getSpecialEnsouls())
            {
                if (ensoul == null)
                {
                    continue;
                }
                item.addEnsoul(2, ensoul.getId(), ensoul, false);
            }
        }
        return item;
    }

    private static void removeListeners(ItemInstance detachItem)
    {
        for (EventType eventType : EventType.VALUES)
        {
            for (Event event : EventHolder.getInstance().getEvents(eventType))
            {
                detachItem.removeEvent(event);
            }
        }
    }

    public WorldExchangeItemSubType getCategoryById(int itemId)
    {
        return _itemCategories.getOrDefault(itemId, null);
    }

    private static class SingletonHolder {
        protected static final WorldExchangeManager INSTANCE = new WorldExchangeManager();
    }
}
