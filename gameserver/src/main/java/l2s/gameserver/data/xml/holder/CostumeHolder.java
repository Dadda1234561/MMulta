package l2s.gameserver.data.xml.holder;

import gnu.trove.map.hash.TIntObjectHashMap;
import l2s.commons.data.xml.AbstractHolder;
import l2s.gameserver.templates.Costume;

import java.util.Collection;


public class CostumeHolder extends AbstractHolder {

    private static final CostumeHolder INSTANCE = new CostumeHolder();
    private final TIntObjectHashMap<Costume> _costumeData = new TIntObjectHashMap<>();

    public static CostumeHolder getInstance() {
        return INSTANCE;
    }

    @Override
    public int size() {
        return _costumeData.size();
    }

    @Override
    public void clear() {
        _costumeData.clear();
    }

    public void addCostume(Costume costume) {
        _costumeData.put(costume.getId(), costume);
    }

    public Collection<Costume> getAllCostumes() {
        return _costumeData.valueCollection();
    }
}
