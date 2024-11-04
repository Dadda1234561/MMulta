package l2s.gameserver.model.entity.rank;

import l2s.gameserver.Config;
import l2s.gameserver.model.Player;
import l2s.gameserver.model.entity.rank.enums.RankingGroup;
import l2s.gameserver.templates.StatsSet;

/**
 * @author sharp at 25.02.2023 / 9:58
 * t.me/sharp1que
 */
public class RankInfo
{
    private final int worldId = Config.REQUEST_ID;
    private final int charId;
    private int clanId = 0;
    private final String charName;
    private final String clanName;
    private final int rebirths;
    private final int classId;
    private final int race;
    private int serverRank = 0;
    private int raceRank = 0;
    private int classRank = 0;
    private int timeStamp = 0;

    private int combatRank = 0;
    private int combatPower = 0;
    private int prevCombatRank = 0;

    private final int pvpRank = 0;
    private final int prevPvpRank = 0;
    private final int pvpKills = 0;
    private final int pvpDeaths = 0;


    public RankInfo(int charId, String charName, String clanName, int rebirths, int classId, int race)
    {
        this.charId = charId;
        this.charName = charName;
        this.clanName = clanName;
        this.rebirths = rebirths;
        this.classId = classId;
        this.race = race;
        this.timeStamp = (int) (System.currentTimeMillis() / 1000);
    }

    public RankInfo(int charId, int clanId, String charName, String clanName, int rebirths, int classId, int race, int timeStamp, int serverRank, int raceRank, int classRank)
    {
        this.charId = charId;
        this.clanId = clanId;
        this.charName = charName;
        this.clanName = clanName;
        this.rebirths = rebirths;
        this.classId = classId;
        this.race = race;
        this.serverRank = serverRank;
        this.raceRank = raceRank;
        this.classRank = classRank;
        this.timeStamp = timeStamp;
        this.combatRank = 0;
        this.combatPower = 0;
        this.prevCombatRank = 0;
    }

    public RankInfo(Player player)
    {
        this(player.getObjectId(), player.getClanId(), player.getName(), player.getClanName(), player.getRebirthCount(), player.getActiveClassId(), player.getRace().ordinal(), (int) (System.currentTimeMillis() / 1000), 0, 0, 0);
    }

    public RankInfo(StatsSet set)
    {
        this.charId = set.getInteger("char_id");
        this.clanId = set.getInteger("clan_id");
        this.charName = set.getString("char_name");
        this.clanName = set.getString("clan_name");
        this.rebirths = set.getInteger("rebirths");
        this.classId = set.getInteger("class_id");
        this.race = set.getInteger("race");
        this.serverRank = set.getInteger("server_rank");
        this.raceRank = set.getInteger("race_rank");
        this.classRank = set.getInteger("class_rank");
        this.timeStamp = set.getInteger("time_stamp");
    }

    public int getCharId() {
        return charId;
    }

    public String getCharName() {
        return charName;
    }

    public String getClanName() {
        return clanName;
    }

    public int getWorldId() {
        return worldId;
    }

    public int getRebirths() {
        return rebirths;
    }

    public int getClassId() {
        return classId;
    }

    public int getRaceId() {
        return race;
    }

    /**
     * Depending on current group
     * display different rank
     * @param group
     * @return
     */
    public int getServerRank(RankingGroup group) {
        switch (group) {
            case Class: {
                return classRank;
            }
            case Race: {
                return raceRank;
            }
            default: {
                return serverRank;
            }
        }
    }

    public int getServerRank() {
        return serverRank;
    }

    public int getRaceRank() {
        return raceRank;
    }

    public int getClassRank() {
        return classRank;
    }

    public int getClanId() {
        return clanId;
    }

    public int getTimeStamp() {
        return timeStamp;
    }

    public void setClassRank(int i) {
        classRank = i;
    }

    public void setRaceRank(int i) {
        raceRank = i;
    }

    public int getGearScore() {
        return combatPower;
    }

    public int getGearScoreRank() {
        return combatRank;
    }

    public int getPrevGearScoreRank() {
        return prevCombatRank;
    }

    public int getPvPRank() {
        return pvpRank;
    }

    public int getPrevPvpRank() {
        return prevPvpRank;
    }

    public int getPvpKills() {
        return pvpKills;
    }

    public int getPvpDeaths() {
        return pvpDeaths;
    }

    public void setGearScoreRank(int rank) {
        combatRank = rank;
    }

    public void setGearScore(int power) {
        combatPower = power;
    }

    public void setPrevGearScoreRank(int prevRank) {
        prevCombatRank = prevRank;
    }

    public long getPvPPoints() {
        return 0;
    }

    @Override
    public String toString() {
        return "RankInfo{" +
                "worldId=" + worldId +
                ", charId=" + charId +
                ", clanId=" + clanId +
                ", charName='" + charName + '\'' +
                ", clanName='" + clanName + '\'' +
                ", rebirths=" + rebirths +
                ", classId=" + classId +
                ", race=" + race +
                ", serverRank=" + serverRank +
                ", raceRank=" + raceRank +
                ", classRank=" + classRank +
                ", timeStamp=" + timeStamp +
                '}';
    }
}
