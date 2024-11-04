package l2s.gameserver.data.xml.holder;

import l2s.commons.data.xml.AbstractHolder;
import l2s.gameserver.model.ChampionTemplate;

import java.util.HashMap;
import java.util.Map;

public class ChampionTemplateHolder extends AbstractHolder {

    private static final Map<Integer, ChampionTemplate> _championTemplates = new HashMap<>();

    @Override
    public int size() {
        return _championTemplates.size();
    }

    @Override
    public void clear() {
        _championTemplates.clear();
    }


    public void addTemplate(ChampionTemplate statTemplate) {
        _championTemplates.put(statTemplate.getChampLevel(), statTemplate);
    }

    public ChampionTemplate getTemplate(int level) {
        return _championTemplates.getOrDefault(level, null);
    }

    public static ChampionTemplateHolder getInstance() {
        return SingletonHolder.INSTANCE;
    }

    private static class SingletonHolder {
        protected static ChampionTemplateHolder INSTANCE = new ChampionTemplateHolder();
    }
}
