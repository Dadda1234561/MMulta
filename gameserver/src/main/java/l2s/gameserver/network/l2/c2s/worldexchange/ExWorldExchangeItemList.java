package l2s.gameserver.network.l2.c2s.worldexchange;

import l2s.gameserver.Config;
import l2s.gameserver.dao.WorldExchangeManager;
import l2s.gameserver.data.xml.holder.WorldExchangeHolder;
import l2s.gameserver.model.Player;
import l2s.gameserver.model.base.WorldExchangeItemSubType;
import l2s.gameserver.model.base.WorldExchangeSortType;
import l2s.gameserver.network.l2.c2s.L2GameClientPacket;

import java.util.ArrayList;
import java.util.List;


public class ExWorldExchangeItemList extends L2GameClientPacket {
    private int _category;
    private int _sortType;
    private int _page;
    private final List<Integer> itemIDList = new ArrayList<>();
    private int _sortCurrencyType; // 0 - ALL, 1 - LCoins (4037), else - ADENA

    @Override
    public boolean readImpl() {
        _category = readH();
        _sortType = readC();
        _page = readD();
        int size = readD();
        for (int i = 0; i < size; i++)
        {
            itemIDList.add(readD());
        }
        _sortCurrencyType = WorldExchangeManager.EXTENDED_WORLD_TRADE ? readD() : 0; // 0 - all, 1 - Adena, 2 - ADENA
        return true;
    }

    @Override
    public void runImpl() {
        if (!Config.ENABLE_WORLD_EXCHANGE)
        {
            return;
        }
        Player player = getClient().getActiveChar();
        if (player == null) {
            return;
        }

        final String lang = player.getLanguage() != null ? String.valueOf(player.getLanguage()) : "ru";
        final WorldExchangeItemSubType itemSubType = WorldExchangeItemSubType.getWorldExchangeItemSubType(_category);
        final WorldExchangeSortType sortType = WorldExchangeSortType.getWorldExchangeSortType(_sortType);
        final List<WorldExchangeHolder> holders = WorldExchangeManager.getInstance().getBidItems(player.getObjectId(), itemIDList, itemSubType, sortType, _page, lang, _sortCurrencyType);

        WorldExchangeManager.getInstance().addCategoryType(itemIDList, _category);
        player.sendPacket(new l2s.gameserver.network.l2.s2c.worldexchange.ExWorldExchangeItemList(player, holders, itemSubType, sortType, _page));
    }
}
