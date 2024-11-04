package l2s.gameserver.data.xml.holder;

import gnu.trove.map.hash.TIntObjectHashMap;
import l2s.commons.data.xml.AbstractHolder;
import l2s.gameserver.model.entity.AltDimension;

public class AltDimensionHolder extends AbstractHolder {

    private final TIntObjectHashMap<AltDimension> _dimensions = new TIntObjectHashMap<>();

    public AltDimensionHolder() {

    }

    @Override
    public int size() {
        return _dimensions.size();
    }

    @Override
    public void clear() {
        _dimensions.clear();
    }

    public AltDimension getDimension(int locationId) {
        return _dimensions.get(locationId);
    }

    public void addDimension(int id, AltDimension location) {
        _dimensions.put(id, location);
    }

    public static AltDimensionHolder getInstance() {
        return SingletonHolder.INSTANCE;
    }

    private static class SingletonHolder {
        protected static final AltDimensionHolder INSTANCE = new AltDimensionHolder();
    }


}
