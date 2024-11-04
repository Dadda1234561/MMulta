package l2s.gameserver.data.xml.holder;

import l2s.gameserver.dao.WorldExchangeManager;
import l2s.gameserver.model.base.WorldExchangeItemStatusType;
import l2s.gameserver.model.base.WorldExchangeItemSubType;
import l2s.gameserver.model.items.ItemInfo;
import l2s.gameserver.model.items.ItemInstance;
import l2s.gameserver.templates.item.ItemTemplate;

public class WorldExchangeHolder {
    private final long _worldExchangeID;
    private final ItemInstance _itemInstance;
    private final ItemInfo _itemInfo;
    private final long _price;
    private final int _oldOwnerId;
    private WorldExchangeItemStatusType _storeType;
    private final WorldExchangeItemSubType _category;
    private final long _startTime;
    private long _endTime;
    private boolean _hasChanges;
    private int _currency;


    public WorldExchangeHolder(long worldExchangeID, ItemInstance itemInstance, ItemInfo itemInfo, long price, int oldOwnerId, WorldExchangeItemStatusType storeType, WorldExchangeItemSubType category, long startTime, long endTime, boolean hasChanges, int currency) {
        _worldExchangeID = worldExchangeID;
        _itemInstance = itemInstance;
        _itemInfo = itemInfo;
        _price = price;
        _oldOwnerId = oldOwnerId;
        _storeType = storeType;
        _category = category;
        _startTime = startTime;
        _endTime = endTime;
        _hasChanges = hasChanges;
        _currency = currency;

    }

    public long getWorldExchangeID() {
        return _worldExchangeID;
    }

    public ItemInstance getItemInstance() {
        return _itemInstance;
    }

    public ItemInfo getItemInfo() {
        return _itemInfo;
    }

    public long getPrice() {
        return _price;
    }

    public int getOldOwnerId() {
        return _oldOwnerId;
    }

    public WorldExchangeItemStatusType getStoreType() {
        return _storeType;
    }

    public void setStoreType(WorldExchangeItemStatusType storeType) {
        _storeType = storeType;
    }

    public WorldExchangeItemSubType getCategory() {
        // check
        if (_itemInstance.getItemId() == ItemTemplate.ITEM_ID_ADENA) {
            return WorldExchangeItemSubType.Adena;
        }
        return WorldExchangeManager.getInstance().getCategoryById(this.getItemInfo().getItemId());
    }

    public long getCount() {
        return getItemInstance() == null ? 0L : getItemInstance().getCount();
    }

    public long getPricePerPiece() {
        return WorldExchangeManager.getInstance().getAverageItemPrice(getItemInstance().getItemId());
    }

    public int getItemEnchant() {
        return getItemInstance() == null ? 0 : getItemInstance().getEnchantLevel();
    }

    public long getStartTime() {
        return _startTime;
    }

    public long getEndTime() {
        return _endTime;
    }

    public void setEndTime(long endTime) {
        _endTime = endTime;
    }

    public boolean isHasChanges() {
        if (_hasChanges) {
            _hasChanges = false;
            return true;
        }
        return false;
    }
    public int getCurrency(){
        return _currency;
    }

    public void setHasChanges(boolean hasChanges) {
        _hasChanges = hasChanges;
    }

}
