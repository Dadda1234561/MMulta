package l2s.gameserver.templates.item.data;

import java.util.Set;

public class ChampionAdditionalDropData extends RewardItemData {

    private final int _minNpcLevel;
    private final int _maxNpcLevel;
    private final Set<Integer> _allowedMonsterIds;

    public ChampionAdditionalDropData(int id, long minCount, long maxCount, double chance, int minNpcLevel, int maxNpcLevel, Set<Integer> whiteList) {
        super(id, minCount, maxCount, chance);
        _allowedMonsterIds = whiteList;
        _minNpcLevel = minNpcLevel;
        _maxNpcLevel = maxNpcLevel;
    }

    public int getMinNpcLevel() {
        return _minNpcLevel;
    }

    public int getMaxNpcLevel() {
        return _maxNpcLevel;
    }

    public Set<Integer> getAllowedMonsterIds() {
        return _allowedMonsterIds;
    }
}
