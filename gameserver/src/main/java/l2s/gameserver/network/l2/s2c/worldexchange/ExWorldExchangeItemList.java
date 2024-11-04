package l2s.gameserver.network.l2.s2c.worldexchange;

import l2s.gameserver.dao.WorldExchangeManager;
import l2s.gameserver.data.xml.holder.WorldExchangeHolder;
import l2s.gameserver.model.Player;
import l2s.gameserver.model.base.WorldExchangeItemSubType;
import l2s.gameserver.model.base.WorldExchangeSortType;
import l2s.gameserver.model.items.ItemInstance;
import l2s.gameserver.network.l2.s2c.L2GameServerPacket;

import java.util.List;

public class ExWorldExchangeItemList extends L2GameServerPacket {
    public static final ExWorldExchangeItemList EMPTY_LIST = new ExWorldExchangeItemList(null, null, null, WorldExchangeSortType.NONE, 0);
    final Player _player;
    List<WorldExchangeHolder> _holders;
    WorldExchangeItemSubType _type;
    WorldExchangeSortType _sortType;
    final int _page;

    public ExWorldExchangeItemList(Player player, List<WorldExchangeHolder> holders, WorldExchangeItemSubType type, WorldExchangeSortType sortType, int page) {
        _player = player;
        _holders = holders;
        _type = type;
        _sortType = sortType;
        _page = page;
    }

    @Override
    public void writeImpl() {
        if (_holders == null) {
            writeH(0);    // nCategory
            writeC(0);    // cSortType
            writeD(0);    // nPage
            writeD(0); // vItemIDList
            return;
        }
        writeH(_type.getId());    // nCategory
        writeC(_sortType.getId());    // cSortType
        writeD(_page);    // nPage
        writeD(_holders.size()); // vItemIDList
        //array
        for (WorldExchangeHolder holder : _holders) {
            writeItemInfo(holder);
        }

    }

    private void writeItemInfo(WorldExchangeHolder holder) {
        writeQ(holder.getWorldExchangeID()); // nWEIndex (World Exchange)
        writeQ(holder.getPrice()); // nPrice
        writeD((int) (holder.getEndTime() / 1000L)); // nExpiredTime
        ItemInstance item = holder.getItemInstance();
        writeD(item.getItemId()); // nItemClassID
        writeQ(item.getCount()); // nAmount
        writeD(item.getEnchantLevel() < 1 ? 0 : item.getEnchantLevel()); // nEnchant
        writeD(item != null ? item.getVariation1Id() : 0); // nVariationOpt1
        writeD(item != null ? item.getVariation2Id() : 0); // nVariationOpt2
        writeD(-1); // nIntensiveItemClassID
        writeH(item.getAttackElement() != null ? item.getAttackElement().getId(): 0); // nBaseAttributeAttackType
        writeH(item.getAttackElementValue()); // nBaseAttributeAttackValue
        // ARRAY nBaseAttributeDefendValue
        writeH(item.getDefenceFire()); // nBaseAttributeDefendValue 1
        writeH(item.getDefenceWater()); // nBaseAttributeDefendValue 2
        writeH(item.getDefenceWind()); // nBaseAttributeDefendValue 3
        writeH(item.getDefenceEarth()); // nBaseAttributeDefendValue 4
        writeH(item.getDefenceHoly()); // nBaseAttributeDefendValue 5
        writeH(item.getDefenceUnholy()); // nBaseAttributeDefendValue 6
        // END OF ARRAY nBaseAttributeDefendValue
        writeD(item.getVisualId()); // nShapeShiftingClassId

        // ARRAY nEsoulOption
        try {
           writeD(item.getNormalEnsouls()[0] != null ? item.getNormalEnsouls()[0].getId() : 0); // nEsoulOption 1
        } catch (IndexOutOfBoundsException | NullPointerException e) {
            writeD(0);
        }
        try {
            writeD(item.getNormalEnsouls()[1] != null ? item.getNormalEnsouls()[1].getId() : 0); // nEsoulOption 2
        } catch (IndexOutOfBoundsException | NullPointerException e) {
            writeD(0);
        }
        try {
            writeD(item.getSpecialEnsouls()[0] != null ? item.getSpecialEnsouls()[0].getId() : 0); // nEsoulOption 3
        } catch (IndexOutOfBoundsException ignored) {
            writeD(0);
        }
        // END OF ARRAY nEsoulOption
        writeH(item.isBlessed() ? 1 : 0); // nBlessOption
        if (WorldExchangeManager.EXTENDED_WORLD_TRADE)
        {
            writeD(holder.getCurrency());
        }
    }
}
