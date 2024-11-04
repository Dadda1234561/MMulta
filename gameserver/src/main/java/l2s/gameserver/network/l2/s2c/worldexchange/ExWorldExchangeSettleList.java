package l2s.gameserver.network.l2.s2c.worldexchange;

import l2s.gameserver.dao.WorldExchangeManager;
import l2s.gameserver.data.xml.holder.WorldExchangeHolder;
import l2s.gameserver.model.Player;
import l2s.gameserver.model.base.WorldExchangeItemStatusType;
import l2s.gameserver.model.items.ItemInstance;
import l2s.gameserver.network.l2.s2c.L2GameServerPacket;

import java.util.EnumMap;
import java.util.List;

public class ExWorldExchangeSettleList extends L2GameServerPacket {
    Player _player;

    public ExWorldExchangeSettleList(Player player) {
        _player = player;
    }

    @Override
    public void writeImpl() {
        EnumMap<WorldExchangeItemStatusType, List<WorldExchangeHolder>> holders = WorldExchangeManager.getInstance().getPlayerBids(_player.getObjectId());
      
        if (holders == null) {
            writeD(0); // vRegiItemDataList
            writeD(0); // vRecvItemDataList
            writeD(0); // vTimeOutItemDataList
            return;
        }
        writeD(holders.get(WorldExchangeItemStatusType.WORLD_EXCHANGE_REGISTERED).size()); // vRegiItemDataList
        for (WorldExchangeHolder holder : holders.get(WorldExchangeItemStatusType.WORLD_EXCHANGE_REGISTERED)) {
            getItemInfo(holder);
        }
        writeD(holders.get(WorldExchangeItemStatusType.WORLD_EXCHANGE_SOLD).size()); // vRecvItemDataList
        for (WorldExchangeHolder holder : holders.get(WorldExchangeItemStatusType.WORLD_EXCHANGE_SOLD)) {
            getItemInfo(holder);
        }
        writeD(holders.get(WorldExchangeItemStatusType.WORLD_EXCHANGE_OUT_TIME).size()); // vTimeOutItemDataList
        for (WorldExchangeHolder holder : holders.get(WorldExchangeItemStatusType.WORLD_EXCHANGE_OUT_TIME)) {
            getItemInfo(holder);
        }

    }

    private void getItemInfo(WorldExchangeHolder holder) {
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
        writeH(item.getAttackElement().getId()); // nBaseAttributeAttackType
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
