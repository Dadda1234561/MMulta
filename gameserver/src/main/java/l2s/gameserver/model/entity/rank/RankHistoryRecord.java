package l2s.gameserver.model.entity.rank;

public class RankHistoryRecord {

    private final int charId;
    private String charName;
    private int rebirths;
    private int serverRank = 0;
    private int raceRank = 0;
    private int classRank = 0;
    private int combatRank = 0;
    private int combatPower = 0;
    private int dateOfRecord = 0;

    public RankHistoryRecord(int charId, String charName, int rebirths, int serverRank, int raceRank, int classRank, int combatRank, int combatPower, int dateOfRecord) {
        this.charId = charId;
        this.charName = charName;
        this.rebirths = rebirths;
        this.serverRank = serverRank;
        this.raceRank = raceRank;
        this.classRank = classRank;
        this.dateOfRecord = dateOfRecord;
        this.combatRank = combatRank;
        this.combatPower = combatPower;
    }

    public int getCharId() {
        return charId;
    }

    public String getCharName() {
        return charName;
    }

    public int getRebirths() {
        return rebirths;
    }

    public int getServerRank() {
        return serverRank;
    }

    public int getDate() {
        return dateOfRecord;
    }
}
