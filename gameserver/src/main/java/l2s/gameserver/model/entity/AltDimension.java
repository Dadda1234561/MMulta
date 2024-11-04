package l2s.gameserver.model.entity;

import l2s.commons.util.Rnd;
import l2s.gameserver.geometry.ILocation;

import java.util.List;

public class AltDimension {
    private final int id;
    private final int rebirths;
    private final boolean need4Prof;
    private final String name;
    private final List<ILocation> locationList;
    private final List<String> description;

    public AltDimension(int id, int rebirths, boolean need4Prof, String name, List<ILocation> locationList, List<String> description) {
        this.id = id;
        this.rebirths = rebirths;
        this.need4Prof = need4Prof;
        this.name = name;
        this.locationList = locationList;
        this.description = description;
    }

    public String getName() {
        return name;
    }

    public int getId() {
        return id;
    }

    public int getRebirths() {
        return rebirths;
    }

    public boolean getNeed4Prof() {
        return need4Prof;
    }

    public List<ILocation> getLocationList() {
        return locationList;
    }

    public ILocation getRandomLocation() {
        return Rnd.get(locationList);
    }

    public List<String> getDescription() {
        return description;
    }
}
