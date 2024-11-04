package l2s.gameserver.model.costume;

public class CostumeInfo {
    private final int costumeId;
    private final long amount;
    private final int lockState;
    private final int changedType;

    public CostumeInfo(int costumeId, long amount, int lockState, int changedType) {
        this.costumeId = costumeId;
        this.amount = amount;
        this.lockState = lockState;
        this.changedType = changedType;
    }


    public int getCostumeId() {
        return costumeId;
    }

    public long getAmount() {
        return amount;
    }

    public int getLockState() {
        return lockState;
    }

    public int getChangedType() {
        return changedType;
    }
}
