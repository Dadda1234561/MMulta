package l2s.gameserver.model;

import l2s.gameserver.model.instances.MonsterInstance;
import l2s.gameserver.model.reward.RewardData;
import l2s.gameserver.stats.StatTemplate;
import l2s.gameserver.templates.item.data.ChampionAdditionalDropData;

import java.util.ArrayList;
import java.util.List;

/**
 * в конфиге должно быть хп,п деф,м деф,физ атака,дроп,спойл,адена
 */
public class ChampionTemplate extends StatTemplate {
    private final int _champLevel;
    private final List<ChampionAdditionalDropData> _additionalDrop;

    public ChampionTemplate(int champLevel) {
        _champLevel = champLevel;
        _additionalDrop = new ArrayList<>();
    }

    public void addAdditionalDrop(ChampionAdditionalDropData holder) {
        _additionalDrop.add(holder);
    }

    public List<ChampionAdditionalDropData> getAdditionalDrop() {
        return _additionalDrop;
    }

    public int getChampLevel() {
        return _champLevel;
    }

    public List<RewardData> filterAdditionalDrop(MonsterInstance monster) {
        final List<RewardData> validRewardData = new ArrayList<>();
        for (ChampionAdditionalDropData data : _additionalDrop) {
            // check white list
            boolean isInWhiteList = (data.getAllowedMonsterIds().isEmpty() || data.getAllowedMonsterIds().contains(monster.getNpcId()));
            // check lvl
            boolean isInLvlGroup = (monster.getLevel() >= data.getMinNpcLevel()) && (monster.getLevel() <= data.getMaxNpcLevel());
            // stop loop if is valid
            if (isInWhiteList && isInLvlGroup) {
                validRewardData.add(new RewardData(data.getId(), data.getMinCount(), data.getMaxCount(), data.getChance()));
            }
        }
        return validRewardData;
    }
}
