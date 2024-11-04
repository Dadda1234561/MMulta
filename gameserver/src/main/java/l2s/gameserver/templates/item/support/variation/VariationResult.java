package l2s.gameserver.templates.item.support.variation;

import l2s.gameserver.model.items.ItemInstance;
import org.apache.commons.lang3.tuple.ImmutablePair;
import org.apache.commons.lang3.tuple.Pair;

import java.util.ArrayList;
import java.util.Collections;
import java.util.List;

/**
 * @author sharp on 08.01.2023
 * t.me/sharp1que
 */
public class VariationResult
{
    public static final VariationResult FAILED = new VariationResult(false, 0, 0, 0);

    private boolean _isSuccess;
    private int _itemObjectId, _option1ID, _option2ID;
    private ItemInstance _item;
    private List<Pair<Integer, Long>> _removableItems = Collections.emptyList();

    public VariationResult(boolean isSuccess, int itemObjectId, int option1ID, int option2ID)
    {
        this._isSuccess = isSuccess;
        this._itemObjectId = itemObjectId;
        this._option1ID = option1ID;
        this._option2ID = option2ID;
    }

    public VariationResult(boolean isSuccess, ItemInstance item)
    {
        this._isSuccess = isSuccess;
        if (item != null)
        {
            this._item = item;
            this._itemObjectId = item.getObjectId();
            this._option1ID = item.getVariation1Id();
            this._option2ID = item.getVariation2Id();
        }
    }

    public boolean isSuccess()
    {
        return _isSuccess;
    }

    public int itemObjectId()
    {
        return _itemObjectId;
    }

    public int option1ID()
    {
        return _option1ID;
    }

    public int option2ID()
    {
        return _option2ID;
    }

    public ItemInstance getItem()
    {
        return _item;
    }

    public void assignRemovableItems(int materialId, long materialCount, int feeId, long feeCount, int adenaId, long adenaCount)
    {
        _removableItems = new ArrayList<>(3);
        _removableItems.add(new ImmutablePair<>(materialId, materialCount));
        _removableItems.add(new ImmutablePair<>(feeId, feeCount));
        _removableItems.add(new ImmutablePair<>(adenaId, adenaCount));
    }

    public List<Pair<Integer, Long>> getRemovableItems()
    {
        return _removableItems;
    }
}
