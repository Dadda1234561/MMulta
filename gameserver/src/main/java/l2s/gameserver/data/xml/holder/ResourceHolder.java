package l2s.gameserver.data.xml.holder;

import l2s.commons.data.xml.AbstractHolder;
import l2s.gameserver.model.Player;
import l2s.gameserver.templates.ResourceTemplate;
import l2s.gameserver.templates.item.data.ItemData;
import org.napile.primitive.maps.IntObjectMap;
import org.napile.primitive.maps.impl.TreeIntObjectMap;

import java.util.Collection;
import java.util.Collections;
import java.util.List;

public class ResourceHolder extends AbstractHolder {
    private final IntObjectMap<ResourceTemplate> resources = new TreeIntObjectMap<>();

    public static ResourceHolder getInstance() {
        return SingletonHolder.INSTANCE;
    }

    public ResourceTemplate getResource(int id) {
        return resources.get(id);
    }

    public ItemData getIngredient(int resourceId, int slot) {
        ResourceTemplate resource = getResource(resourceId);
        if (resource == null) {
            return null;
        }
        return resource.getIngredients().get(slot);
    }

    public void addResource(ResourceTemplate template) {
        resources.put(template.getId(), template);
    }

    public Collection<ResourceTemplate> getResources() {
        return resources.valueCollection();
    }

    @Override
    public int size() {
        return resources.size();
    }

    @Override
    public void clear() {
        resources.clear();
    }

    public List<ItemData> getUnlockPrice(Player player, int slot) {
        for (ResourceTemplate template : resources.valueCollection()) {
            if (template.getSlot() == slot) {
                return template.getUnlockItems(player);
            }
        }
        return Collections.emptyList();
    }

    public boolean isUnlocked(Player player, int slot) {
        return player.getVarInt("SMELTING_SLOTS", 1) >= slot;
    }

    private static class SingletonHolder {
        protected static ResourceHolder INSTANCE = new ResourceHolder();
    }
}
