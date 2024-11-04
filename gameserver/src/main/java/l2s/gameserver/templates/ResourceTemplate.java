package l2s.gameserver.templates;

import l2s.gameserver.model.Player;
import l2s.gameserver.model.ProductionType;
import l2s.gameserver.templates.item.data.ItemData;

import java.util.List;

public class ResourceTemplate {
    private final int id;
    private final String name;
    private final int slot;
    private final int duration;
    private final ProductionType productionType;
    private final List<ItemData> ingredientList;
    private final List<ItemData> productionList;
    private final List<ItemData> unlockPrice;

    public ResourceTemplate(int id, String name, int slot, int duration, ProductionType productionType, List<ItemData> ingredientList, List<ItemData> productionList, List<ItemData> unlockPrice) {
        this.id = id;
        this.slot = slot;
        this.duration = duration;
        this.productionType = productionType;
        this.ingredientList = ingredientList;
        this.productionList = productionList;
        this.unlockPrice = unlockPrice;
        this.name = name;
    }

    public int getId() {
        return id;
    }

    public int getSlot() {
        return slot;
    }

    public ItemData getIngredient(int subSlot) {
        return ingredientList.get(subSlot);
    }

    public List<ItemData> getIngredients() {
        return ingredientList;
    }

    public List<ItemData> getProduction() {
        return productionList;
    }

    public ProductionType getProductionType() {
        return productionType;
    }

    public int getDuration() {
        return duration;
    }

    public String getName() {
        return name;
    }

    public List<ItemData> getUnlockItems(Player player) {
        return unlockPrice;
    }
}
