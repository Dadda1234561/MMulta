package l2s.gameserver.data.xml.holder;

import l2s.commons.data.xml.AbstractHolder;
import l2s.gameserver.model.ChampionTemplate;

import java.util.HashMap;
import java.util.Map;

public class UpMonsterTemplateHolder extends AbstractHolder {

    private static final Map<Integer, ChampionTemplate> _upMonsterTemplates = new HashMap<>();

    @Override
    public int size() {
        return _upMonsterTemplates.size();
    }

    @Override
    public void clear() {
        _upMonsterTemplates.clear();
    }


    public void addTemplate(ChampionTemplate statTemplate) {
        _upMonsterTemplates.put(statTemplate.getChampLevel(), statTemplate);
    }

    public ChampionTemplate getTemplate(int level) {
        return _upMonsterTemplates.getOrDefault(level, null);
    }

    public static UpMonsterTemplateHolder getInstance() {
        return SingletonHolder.INSTANCE;
    }

    private static class SingletonHolder {
        protected static UpMonsterTemplateHolder INSTANCE = new UpMonsterTemplateHolder();
    }
}
