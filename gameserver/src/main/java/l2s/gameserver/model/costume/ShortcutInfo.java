package l2s.gameserver.model.costume;

public class ShortcutInfo {
    private final int page;
    private final int slotIndex;
    private final int costumeId;
    private final boolean isAutoUse;

    public ShortcutInfo(int page, int slotIndex, int costumeId, boolean isAutoUse) {
        this.page = page;
        this.slotIndex = slotIndex;
        this.costumeId = costumeId;
        this.isAutoUse = isAutoUse;
    }

    public int getPage() {
        return page;
    }

    public int getSlotIndex() {
        return slotIndex;
    }

    public int getCostumeId() {
        return costumeId;
    }

    public boolean isAutoUse() {
        return isAutoUse;
    }
}
