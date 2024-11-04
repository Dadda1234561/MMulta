package l2s.gameserver.instancemanager;

import l2s.commons.dbutils.DbUtils;
import l2s.gameserver.Config;
import l2s.gameserver.ThreadPoolManager;
import l2s.gameserver.dao.CharacterDAO;
import l2s.gameserver.database.DatabaseFactory;
import l2s.gameserver.model.Player;
import l2s.gameserver.model.base.ClassId;
import l2s.gameserver.model.base.ClassLevel;
import l2s.gameserver.model.base.Race;
import l2s.gameserver.model.entity.rank.RankHistoryRecord;
import l2s.gameserver.model.entity.rank.RankInfo;
import l2s.gameserver.model.entity.rank.enums.RankingGroup;
import l2s.gameserver.model.entity.rank.enums.RankingScope;
import l2s.gameserver.model.entity.rank.enums.RankingType;
import l2s.gameserver.model.pledge.Clan;
import l2s.gameserver.skills.SkillEntry;
import l2s.gameserver.skills.SkillEntryType;
import l2s.gameserver.tables.ClanTable;
import l2s.gameserver.templates.StatsSet;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.time.LocalDateTime;
import java.time.ZoneOffset;
import java.util.ArrayList;
import java.util.Collections;
import java.util.List;
import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;
import java.util.concurrent.CopyOnWriteArrayList;
import java.util.concurrent.Future;
import java.util.concurrent.atomic.AtomicInteger;
import java.util.stream.Collectors;
import java.util.stream.Stream;

public class RankManager {
    private static final Logger _log = LoggerFactory.getLogger(RankManager.class);

    private static final SkillEntry SERVER_RANKING_1 = SkillEntry.makeSkillEntry(SkillEntryType.NONE, 32874, 1);
    private static final SkillEntry SERVER_RANKING_2 = SkillEntry.makeSkillEntry(SkillEntryType.NONE, 32875, 1);
    private static final SkillEntry SERVER_RANKING_3 = SkillEntry.makeSkillEntry(SkillEntryType.NONE, 32876, 1);

    private static final SkillEntry HUMAN_RANKING = SkillEntry.makeSkillEntry(SkillEntryType.NONE, 32877, 1);
    private static final SkillEntry ELF_RANKING = SkillEntry.makeSkillEntry(SkillEntryType.NONE, 32878, 1);
    private static final SkillEntry DARK_ELF_RANKING = SkillEntry.makeSkillEntry(SkillEntryType.NONE, 32879, 1);
    private static final SkillEntry ORC_RANKING = SkillEntry.makeSkillEntry(SkillEntryType.NONE, 32880, 1);
    private static final SkillEntry DWARF_RANKING = SkillEntry.makeSkillEntry(SkillEntryType.NONE, 32881, 1);
    private static final SkillEntry KAMAEL_RANKING = SkillEntry.makeSkillEntry(SkillEntryType.NONE, 32882, 1);
    private static final SkillEntry ERTHEIA_RANKING = SkillEntry.makeSkillEntry(SkillEntryType.NONE, 32883, 1);

    private static final SkillEntry KNIGHT_RANKING = SkillEntry.makeSkillEntry(SkillEntryType.NONE, 33126, 1);
    private static final SkillEntry WARRIOR_RANKING = SkillEntry.makeSkillEntry(SkillEntryType.NONE, 33127, 1);
    private static final SkillEntry ROGUE_RANKING = SkillEntry.makeSkillEntry(SkillEntryType.NONE, 33128, 1);
    private static final SkillEntry ARCHER_RANKING = SkillEntry.makeSkillEntry(SkillEntryType.NONE, 33129, 1);
    private static final SkillEntry ENCHANTER_RANKING = SkillEntry.makeSkillEntry(SkillEntryType.NONE, 33130, 1);
    private static final SkillEntry MAGE_RANKING = SkillEntry.makeSkillEntry(SkillEntryType.NONE, 33131, 1);
    private static final SkillEntry SUMMONER_RANKING = SkillEntry.makeSkillEntry(SkillEntryType.NONE, 33132, 1);
    private static final SkillEntry HEALER_RANKING = SkillEntry.makeSkillEntry(SkillEntryType.NONE, 33133, 1);

    private static final SkillEntry SERVER_RANKING_1P = SkillEntry.makeSkillEntry(SkillEntryType.NONE, 32884, 1);
    private static final SkillEntry SERVER_RANKING_2P = SkillEntry.makeSkillEntry(SkillEntryType.NONE, 32885, 1);
    private static final SkillEntry SERVER_RANKING_3P = SkillEntry.makeSkillEntry(SkillEntryType.NONE, 32886, 1);
    private static final SkillEntry RACE_RANKING = SkillEntry.makeSkillEntry(SkillEntryType.NONE, 32887, 1);
    private static final SkillEntry CLASS_RANKING = SkillEntry.makeSkillEntry(SkillEntryType.NONE, 33134, 1);

    private static final String SELECT_COMBAT_POWER_DATA = "SELECT ROW_NUMBER() OVER (ORDER BY subquery.gear_score DESC) AS place, subquery.char_id, subquery.char_name, subquery.clan_id, subquery.rebirths, subquery.class_id, subquery.gear_score FROM (SELECT characters.obj_Id AS char_id, characters.char_name, characters.clanid AS clan_id, characters.rebirths, character_dualclasses.class_id, characters.gear_score FROM characters JOIN character_dualclasses ON characters.obj_Id = character_dualclasses.char_obj_id WHERE characters.accesslevel = 0 AND characters.gear_score > 0 AND character_dualclasses.type = 0 AND characters.last_login >= UNIX_TIMESTAMP() - 2592000 ORDER BY characters.gear_score DESC LIMIT 150) AS subquery;";
    private static final String SELECT_ELIGIBLE_CHARACTERS = "SELECT characters.obj_Id, characters.char_name, characters.clanid, characters.rebirths, characters.lastRebirthTime, character_dualclasses.class_id, character_dualclasses.default_class_id FROM characters JOIN character_dualclasses ON characters.obj_Id = character_dualclasses.char_obj_id WHERE characters.rebirths > 0 AND characters.accesslevel = 0 AND character_dualclasses.type = 0 AND characters.last_login >= UNIX_TIMESTAMP() - 2592000 ORDER BY characters.rebirths DESC, characters.lastRebirthTime ASC";
    private static final String SELECT_RANK_HISTORY_DATA = "SELECT * FROM character_ranking_snapshots ORDER by timestamp DESC";
    private static final String INSERT_RANK_HISTORY_DATA = "INSERT INTO character_ranking_snapshots(char_id, timestamp, clan_id, class_id, race, rebirths, server_rank, race_rank, class_rank, gear_score_rank, gear_score) VALUES(?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
    private static final String GET_PREVIOUS_OLY_DATA = "SELECT characters.sex, character_dualclasses.class_id, characters.rebirths, olympiad_participants_old.char_id, olympiad_participants_old.olympiad_points, olympiad_participants_old.competitions_win, olympiad_participants_old.competitions_loose FROM characters, character_dualclasses, olympiad_participants_old WHERE characters.obj_Id = character_dualclasses.char_obj_id AND character_dualclasses.char_obj_id = olympiad_participants_old.char_id ORDER BY olympiad_points DESC";

    private static final int MAX_RANKS_TO_DISPLAY_SERVER = 150;
    private static final int MAX_RANKS_TO_DISPLAY_RACE = 100;
    private static final int MAX_RANKS_TO_DISPLAY_OLY_SERVER = 100;
    private static final int MAX_RANKS_TO_DISPLAY_OLY_CLASS = 50;

    private static final long UPDATE_INTERVAL = 30 * 60 * 1000L;

    private final List<RankInfo> _rankList = new CopyOnWriteArrayList<>();
    private final List<RankInfo> _combatList = new CopyOnWriteArrayList<>();
    private final Map<Integer, RankInfo> _playerRanks = new ConcurrentHashMap<>();
    private final Map<Integer, RankInfo> _playerCombatRanks = new ConcurrentHashMap<>();
    private final Map<Integer, RankInfo> _playerPrevRanks = new ConcurrentHashMap<>();
    private final Map<Integer, RankInfo> _playerPrevCombatRanks = new ConcurrentHashMap<>();
    private final Map<Integer, List<RankHistoryRecord>> _playerRankHistory = new ConcurrentHashMap<>();
    private final Map<Integer, StatsSet> _previousOlyList = new ConcurrentHashMap<>();
    private Future<?> _updateTask = null;

    public RankManager() {
        loadRankHistory();
        loadRanks();
        checkRankUpdate();

        startUpdateTask();
    }

    public static RankManager getInstance() {
        return SingletonHolder.INSTANCE;
    }

    private void startUpdateTask() {
        if (_updateTask != null) {
            _updateTask.cancel(false);
            _updateTask = null;
        }

        _updateTask = ThreadPoolManager.getInstance().scheduleAtFixedRate(this::migrate, UPDATE_INTERVAL, UPDATE_INTERVAL);
    }

    public void migrate() {
        _log.info("[RankManager]: Migrating rebirth data...");
        for (RankInfo rankInfo : _rankList) {
            _playerPrevRanks.put(rankInfo.getCharId(), rankInfo);
        }
        _log.info("[RankManager]: Migrating gear score data...");
        for (RankInfo rankInfo : _combatList) {
            rankInfo.setPrevGearScoreRank(rankInfo.getGearScoreRank());
            _playerPrevCombatRanks.put(rankInfo.getCharId(), rankInfo);
        }

        loadRanks();
    }

    /**
     * Get rank info.
     * if isPrev is true = get snapshot info, add it to list if does not exist
     *
     * @param player
     * @param isPrev
     * @return
     */
    public RankInfo getRankInfo(Player player, boolean isPrev) {
        RankInfo rankInfo = getRankInfo(player.getObjectId(), isPrev);
        if (rankInfo == null) {
            rankInfo = new RankInfo(player);
        }
        return rankInfo;
    }

    public RankInfo getRankInfo(RankingType type, int playerId, boolean isPrev) {
        boolean isCombat = type.equals(RankingType.CombatPower);
        if (isPrev) {
            return isCombat ? _playerPrevCombatRanks.getOrDefault(playerId, null) : _playerPrevRanks.getOrDefault(playerId, null);
        }

        return isCombat ? _playerCombatRanks.getOrDefault(playerId, null) : _playerRanks.getOrDefault(playerId, null);
    }

    public RankInfo getRankInfo(int playerId, boolean isPrev) {
        return getRankInfo(RankingType.Character, playerId, isPrev);
    }

    // Rank history is stored every day at 6.30 AM
    // It contains approximately up to latest 7 days of info
    public List<RankHistoryRecord> getRankHistory(Player player) {
        return _playerRankHistory.getOrDefault(player.getObjectId(), Collections.emptyList());
    }

    private List<RankInfo> getListByType(RankingType type) {
        switch (type) {
            case Character:
                return _rankList;
            case CombatPower:
                return _combatList;
        }

        return Collections.emptyList();
    }

    public List<RankInfo> getRankList(RankingType type, Player player, RankingGroup rankingGroup, RankingScope rankingScope, int raceId, int classId) {
        // Create rank list stream
        Stream<RankInfo> rankInfoStream = getListByType(type).stream();

        if (rankingGroup.equals(RankingGroup.Class) && (classId > 0 || classId == -1)) {
            rankInfoStream = rankInfoStream.filter(info -> sameClassId(info, player, classId));
        } else if (rankingGroup.equals(RankingGroup.Race) && raceId >= 0) {
            rankInfoStream = rankInfoStream.filter(info -> sameRaceId(info, raceId));
        } else if (rankingGroup.equals(RankingGroup.Pledge)) {
            rankInfoStream = rankInfoStream.filter(info -> sameClanId(info, player));
        } else if (rankingGroup.equals(RankingGroup.Friends)) {
            rankInfoStream = rankInfoStream.filter(info -> isFriends(info, player));
        } else if (rankingGroup.equals(RankingGroup.Server)) {
            rankInfoStream = rankInfoStream.filter(info -> isSameWorldID(info, player));
        }

        // Sort by achieved date
        rankInfoStream = rankInfoStream.sorted((o1, o2) -> o2.getTimeStamp() - o1.getTimeStamp());

        // match ranking scope
        rankInfoStream = rankInfoStream.filter(info -> matchesRankingScope(player, type, info, rankingGroup, rankingScope));

        int totalLimit = 0;
        // match total limit
        switch (rankingGroup) {
            case Class:
            case Race:
            case Pledge:
            case Friends:
                totalLimit = 100;
                break;
            default: {
                totalLimit = 150;
                break;
            }
        }

        rankInfoStream = rankInfoStream.limit(totalLimit);

        // collect and return remaining
        return rankInfoStream.collect(Collectors.toList());
    }

    private boolean sameClassId(RankInfo info, Player player, int classId) {
        // Костыль для мульты
        // Не отображаются класы в списке классов..

        if (classId == -1) {
            classId = player.getActiveClassId();
        }
        if (classId < 0) {
            return true;
        }

        // 4 Профа чек
        ClassId classObject = ClassId.values()[classId];
        ClassId awakedClassObject = classObject.getBaseAwakeParent(null);

        if (classObject.isOfLevel(ClassLevel.THIRD) || classObject.isAwaked()) {
            if (classObject.getId() == awakedClassObject.getId()) {
                classId = awakedClassObject.getId();
            }
        }

        return info.getClassId() == classId;
    }

    private boolean isSameWorldID(RankInfo info, Player player) {
        return info.getWorldId() == Config.REQUEST_ID;
    }

    private boolean isFriends(RankInfo info, Player player) {
        return player.getFriendList().contains(info.getCharId());
    }

    private boolean sameClanId(RankInfo info, Player player) {
        if (player.getClanId() == 0) {
            return false;
        }

        return player.getClanId() == info.getClanId();
    }

    private boolean sameRaceId(RankInfo info, int raceId) {
        if (raceId < 0) {
            return true;
        }

        return info.getRaceId() == raceId;
    }

    private boolean matchesRankingScope(Player player, RankingType type, RankInfo info, RankingGroup rankingGroup, RankingScope rankingScope) {
        final RankInfo myRankInfo = getRankInfo(type, player.getObjectId(), false);
        int myRank = myRankInfo == null ? 0 : rankingGroup.equals(RankingGroup.Race) ? myRankInfo.getRaceRank() : rankingGroup.equals(RankingGroup.Class) ? myRankInfo.getClassRank() : myRankInfo.getServerRank();
        int otherRank = rankingGroup.equals(RankingGroup.Race) ? info.getRaceRank() : rankingGroup.equals(RankingGroup.Class) ? info.getClassRank() : info.getServerRank();

        int maxRankDiff = 20;
        if (rankingScope.equals(RankingScope.AroundMe)) {
            if (myRank == 0) {
                return false;
            }
            return ((myRank - maxRankDiff) <= otherRank && otherRank <= (myRank + maxRankDiff));
        }
        return true;
    }

    public Map<Integer, StatsSet> getPreviousOlyList() {
        return _previousOlyList;
    }

    public void refreshRankInfo() {
        _log.info("[RankManager]: Refreshing rank info...");
        storeRankHistory();
        loadRanks();

        ServerVariables.set("last_rank_update_time", System.currentTimeMillis());
    }

    public void onPlayerEnter(Player player) {

        removeRankEffects(player);

        if (isPlayerRankBetween(player, 1, 20, RankingGroup.Server)) {
            SERVER_RANKING_1.getEffects(player, player);
            player.addSkill(SERVER_RANKING_1P, false);
            player.addSkill(SERVER_RANKING_2P, false);
            player.addSkill(SERVER_RANKING_3P, false);
        } else if (isPlayerRankBetween(player, 21, 50, RankingGroup.Server)) {
            SERVER_RANKING_2.getEffects(player, player);
            player.addSkill(SERVER_RANKING_2P, false);
            player.addSkill(SERVER_RANKING_3P, false);
        } else if (isPlayerRankBetween(player, 51, 100, RankingGroup.Server)) {
            SERVER_RANKING_3.getEffects(player, player);
            player.addSkill(SERVER_RANKING_3P, false);
        }

        if (isPlayerRankBetween(player, 1, 1, RankingGroup.Race)) {
            applyRankingEffect(player, RankingGroup.Race);
            player.addSkill(RACE_RANKING, false);
        }


        if (isPlayerRankBetween(player, 1, 1, RankingGroup.Class)) {
            if (player.getClassId().getType2() == null) {
                return;
            }

            applyRankingEffect(player, RankingGroup.Class);
            player.addSkill(CLASS_RANKING, false);
        }
    }

    private void applyRankingEffect(Player player, RankingGroup group) {
        switch (group) {
            case Class: {
                switch (player.getClassId().getType2()) {
                    case KNIGHT: {
                        KNIGHT_RANKING.getEffects(player, player);
                        break;
                    }
                    case WARRIOR: {
                        WARRIOR_RANKING.getEffects(player, player);
                        break;
                    }
                    case ROGUE: {
                        ROGUE_RANKING.getEffects(player, player);
                        break;
                    }
                    case ARCHER: {
                        ARCHER_RANKING.getEffects(player, player);
                        break;
                    }
                    case WIZARD: {
                        MAGE_RANKING.getEffects(player, player);
                        break;
                    }
                    case ENCHANTER: {
                        ENCHANTER_RANKING.getEffects(player, player);
                        break;
                    }
                    case SUMMONER: {
                        SUMMONER_RANKING.getEffects(player, player);
                        break;
                    }
                    case HEALER: {
                        HEALER_RANKING.getEffects(player, player);
                        break;
                    }
                    default:
                        break;
                }
            }
            case Race: {
                switch (player.getRace()) {
                    case HUMAN: {
                        HUMAN_RANKING.getEffects(player, player);
                        break;
                    }
                    case ELF: {
                        ELF_RANKING.getEffects(player, player);
                        break;
                    }
                    case DARKELF: {
                        DARK_ELF_RANKING.getEffects(player, player);
                        break;
                    }
                    case ORC: {
                        ORC_RANKING.getEffects(player, player);
                        break;
                    }
                    case DWARF: {
                        DWARF_RANKING.getEffects(player, player);
                        break;
                    }
                    case KAMAEL: {
                        KAMAEL_RANKING.getEffects(player, player);
                        break;
                    }
                    case ERTHEIA: {
                        ERTHEIA_RANKING.getEffects(player, player);
                        break;
                    }
                    default:
                        break;
                }
                break;
            }
        }
    }

    /**
     * Check if player's rank is between min and max value..
     *
     * @param player
     * @param minRank
     * @param maxRank
     * @param group
     * @return
     */
    public boolean isPlayerRankBetween(Player player, int minRank, int maxRank, RankingGroup group) {
        int playerRank = -1;

        switch (group) {
            case Race: {
                playerRank = getRaceRank(player);
                break;
            }
            case Server: {
                playerRank = getServerRank(player);
                break;
            }
            case Class: {
                playerRank = getClassRank(player);
                break;
            }
        }

        return playerRank > -1 && (playerRank >= minRank && playerRank <= maxRank);
    }

    private void removeRankEffects(Player player) {
        player.getAbnormalList().stop(SERVER_RANKING_1, false);
        player.getAbnormalList().stop(SERVER_RANKING_2, false);
        player.getAbnormalList().stop(SERVER_RANKING_3, false);

        player.getAbnormalList().stop(HUMAN_RANKING, false);
        player.getAbnormalList().stop(ELF_RANKING, false);
        player.getAbnormalList().stop(DARK_ELF_RANKING, false);
        player.getAbnormalList().stop(ORC_RANKING, false);
        player.getAbnormalList().stop(DWARF_RANKING, false);
        player.getAbnormalList().stop(KAMAEL_RANKING, false);
        player.getAbnormalList().stop(ERTHEIA_RANKING, false);

        player.getAbnormalList().stop(KNIGHT_RANKING, false);
        player.getAbnormalList().stop(WARRIOR_RANKING, false);
        player.getAbnormalList().stop(ROGUE_RANKING, false);
        player.getAbnormalList().stop(ARCHER_RANKING, false);
        player.getAbnormalList().stop(ENCHANTER_RANKING, false);
        player.getAbnormalList().stop(MAGE_RANKING, false);
        player.getAbnormalList().stop(SUMMONER_RANKING, false);
        player.getAbnormalList().stop(HEALER_RANKING, false);

        player.removeSkill(SERVER_RANKING_1P, false);
        player.removeSkill(SERVER_RANKING_2P, false);
        player.removeSkill(SERVER_RANKING_3P, false);

        player.removeSkill(RACE_RANKING, false);
        player.removeSkill(CLASS_RANKING, false);
    }

    /**
     * Check if rank was updated earlier..
     * Update if not...
     */
    private void checkRankUpdate() {

        // get the timestamp of the last time the task was completed at 6:30 AM from configuration
        long lastTaskCompletionTime = ServerVariables.getLong("last_rank_update_time", 0);

        // get the current time
        LocalDateTime now = LocalDateTime.now();

        // calculate the time of today's 6:30 AM
        LocalDateTime targetTime = LocalDateTime.of(now.getYear(), now.getMonth(), now.getDayOfMonth(), 6, 30);

        // if the current time is past today's 6:30 AM and the task has not been completed today
        if (now.isAfter(targetTime) && lastTaskCompletionTime < targetTime.toEpochSecond(ZoneOffset.ofTotalSeconds(0))) {

            // run the task
            refreshRankInfo();
        }
    }

    private void loadRankHistory() {
        Connection con = null;
        PreparedStatement statement = null;
        ResultSet rset = null;

        try {
            con = DatabaseFactory.getInstance().getConnection();
            statement = con.prepareStatement(SELECT_RANK_HISTORY_DATA);
            rset = statement.executeQuery();

            while (rset.next()) {
                final int charId = rset.getInt("char_id");
                final int clanId = rset.getInt("clan_id");
                final int classId = rset.getInt("class_id");
                final int race = rset.getInt("race");
                final int rebirths = rset.getInt("rebirths");
                final int serverRank = rset.getInt("server_rank");
                final int raceRank = rset.getInt("race_rank");
                final int classRank = rset.getInt("class_rank");
                final int timeStamp = rset.getInt("timestamp");
                final int combatRank = rset.getInt("gear_score_rank");
                final int combatPower = rset.getInt("gear_score");

                final String charName = CharacterDAO.getInstance().getNameByObjectId(charId, false);
                final String clanName = ClanTable.getInstance().getClanName(clanId);

                _playerRankHistory.computeIfAbsent(charId, cId -> new ArrayList<>()).add(new RankHistoryRecord(charId, charName, rebirths, serverRank, raceRank, classRank, combatRank, combatPower, timeStamp));
                _playerPrevRanks.put(charId, new RankInfo(charId, clanId, charName, clanName, rebirths, classId, race, timeStamp, serverRank, raceRank, classRank));
            }

            _log.info("[RankManager]: Loaded " + _playerRankHistory.size() + " player snapshot rank info.");
        }
        catch (Exception e) {
            _log.warn("Could not load chars total rank data: " + this + " - " + e.getMessage(), e);
        }
        finally {
            DbUtils.closeQuietly(con, statement, rset);
        }
    }

    private void storeRankHistory() {
        Connection con = null;
        PreparedStatement statement = null;

        // Delete old history for example here...

        try {
            con = DatabaseFactory.getInstance().getConnection();
            statement = con.prepareStatement(INSERT_RANK_HISTORY_DATA);
            int currentTimeStamp = (int) (System.currentTimeMillis() / 1000);
            for (RankInfo combatRank : _combatList) {
                for (RankInfo info : _rankList) {
                    if (combatRank.getCharId() == info.getCharId()) {
                        info.setGearScore(combatRank.getGearScore());
                        info.setGearScoreRank(combatRank.getGearScoreRank());
                        break;
                    }
                }
            }
            for (RankInfo rankInfo : _rankList) {
                statement.setInt(1, rankInfo.getCharId());
                statement.setLong(2, currentTimeStamp);
                statement.setInt(3, rankInfo.getClanId());
                statement.setInt(4, rankInfo.getClassId());
                statement.setInt(5, rankInfo.getRaceId());
                statement.setInt(6, rankInfo.getRebirths());
                statement.setInt(7, rankInfo.getServerRank());
                statement.setInt(8, rankInfo.getRaceRank());
                statement.setInt(9, rankInfo.getClassRank());
                statement.setInt(10, rankInfo.getGearScore());
                statement.setInt(11, rankInfo.getGearScoreRank());
                statement.addBatch();

                _playerRankHistory.computeIfAbsent(rankInfo.getCharId(), cId -> new ArrayList<>()).add(new RankHistoryRecord(rankInfo.getCharId(), rankInfo.getCharName(), rankInfo.getRebirths(), rankInfo.getServerRank(), rankInfo.getRaceRank(), rankInfo.getClassRank(), rankInfo.getGearScoreRank(), rankInfo.getGearScore(), currentTimeStamp));
            }

            statement.executeBatch();

            _log.info("[RankManager]: Stored " + _rankList.size() + " rank infos to history...");
        }
        catch (Exception e) {
            _log.warn("Could not load chars total rank data: " + this + " - " + e.getMessage(), e);
        }
        finally {
            DbUtils.closeQuietly(con, statement);
        }
    }

    private void loadRanks() {
        Connection con = null;
        PreparedStatement statement = null;
        ResultSet rset = null;

        try {
            con = DatabaseFactory.getInstance().getConnection();
            statement = con.prepareStatement(SELECT_ELIGIBLE_CHARACTERS);
            rset = statement.executeQuery();

            _playerRanks.clear();
            _rankList.clear();

            int i = 0;
            while (rset.next()) // Fresh info from DB
            {
                final int charId = rset.getInt("characters.obj_Id");
                final String name = rset.getString("characters.char_name");
                final int rebirths = rset.getInt("characters.rebirths");
                final int classId = rset.getInt("character_dualclasses.class_id");
                final int defaultClassId = rset.getInt("character_dualclasses.default_class_id");
                final int clanId = rset.getInt("characters.clanid");
                final String clanName = ClanTable.getInstance().getClanName(clanId);

                ClassId playerClassId = ClassId.valueOf(defaultClassId);
                int race = Race.HUMAN.ordinal();
                if (playerClassId != null) {
                    race = playerClassId.getRace().ordinal();
                }

                RankInfo rankInfo = new RankInfo(charId, clanId, name, clanName, rebirths, classId, race, (int) (System.currentTimeMillis() / 1000), ++i, 0, 0);
                _rankList.add(rankInfo);
                _playerRanks.put(charId, rankInfo);
            }

            /* Set race rank */
            for (Race race : Race.values())
            {
                AtomicInteger raceCntr = new AtomicInteger(0);
                _rankList.stream().filter(info -> info.getRaceId() == race.ordinal()).sorted((o1, o2) -> o2.getRebirths() - o1.getRebirths()).sorted((o1, o2) -> o2.getTimeStamp() - o1.getTimeStamp()).forEach((rankInfo -> rankInfo.setRaceRank(raceCntr.incrementAndGet())));
            }

            /* Set class rank */
            for (ClassId classId : ClassId.values())
            {
                AtomicInteger classCntr = new AtomicInteger(0);
                if (classId.isOfLevel(ClassLevel.SECOND) || classId.isOfLevel(ClassLevel.THIRD) || classId.isOfLevel(ClassLevel.AWAKED))
                {
                    _rankList.stream().filter(info -> info.getClassId() == classId.getId()).sorted((o1, o2) -> o2.getRebirths() - o1.getRebirths()).sorted((o1, o2) -> o2.getTimeStamp() - o1.getTimeStamp()).forEach((rankInfo) -> rankInfo.setClassRank(classCntr.incrementAndGet()));
                }
            }

            _log.info("[RankManager]: Loaded " + _rankList.size() + " players.");
        }
        catch (Exception e) {
            _log.warn("Could not load chars total rank data: " + this + " - " + e.getMessage(), e);
        }
        finally {
            DbUtils.closeQuietly(con, statement, rset);
        }

        loadCombatPower();
    }

    private void loadCombatPower() {
        Connection con = null;
        PreparedStatement statement = null;
        ResultSet rset = null;
        _combatList.clear();
        try {
            con = DatabaseFactory.getInstance().getConnection();
            statement = con.prepareStatement(SELECT_COMBAT_POWER_DATA);
            rset = statement.executeQuery();
            while (rset.next()) {
                int place = rset.getInt("place");
                int charId = rset.getInt("char_id");
                int clanId = rset.getInt("clan_id");
                int classId = rset.getInt("class_id");
                String charName = rset.getString("char_name");
                String clanName = clanId == 0 ? "" : ClanTable.getInstance().getClanName(clanId);
                ClassId specificClassId = ClassId.valueOf(classId);
                int raceId = specificClassId == null ? 0 : specificClassId.getRace().ordinal();
                int gearScore = rset.getInt("gear_score");
                int rebirths = rset.getInt("rebirths");

                Clan clan = ClanTable.getInstance().getClanByCharId(charId);
                if (clan != null) {
                    clanName = clan.getName();
                }

                RankInfo info = new RankInfo(charId, charName, clanName, rebirths, classId, raceId);
                RankInfo oldInfo = getRankInfo(RankingType.CombatPower, charId, true);
                if (oldInfo != null) {
                    info.setPrevGearScoreRank(oldInfo.getGearScoreRank());
                }
                info.setGearScoreRank(place);
                info.setGearScore(gearScore);
                _combatList.add(info);
            }

            _log.info("[RankManager]: Loaded " + _combatList.size() + " gear score data.");
        } catch (Exception e) {
            _log.warn("Could not load chars total rank data: " + this + " - " + e.getMessage(), e);
        }
        finally {
            DbUtils.closeQuietly(con, statement, rset);
        }
    }

    // TODO: Implement OLY
    private void loadOlyRank() {
        Connection con = null;
        PreparedStatement statement = null;
        ResultSet rset = null;

        // load previous month oly data
        _previousOlyList.clear();
        try {
            con = DatabaseFactory.getInstance().getConnection();
            statement = con.prepareStatement(GET_PREVIOUS_OLY_DATA);
            rset = statement.executeQuery();
            int i = 1;
            while (rset.next()) {
                final StatsSet player = new StatsSet();
                player.set("objId", rset.getInt("olympiad_participants_old.char_id"));
                player.set("classId", rset.getInt("character_dualclasses.class_id"));
                player.set("sex", rset.getInt("characters.sex"));
                player.set("rebirths", rset.getInt("characters.rebirths"));
                player.set("olympiad_points", rset.getInt("olympiad_participants_old.olympiad_points"));
                player.set("competitions_win", rset.getInt("olympiad_participants_old.competitions_win"));
                player.set("competitions_lost", rset.getInt("olympiad_participants_old.competitions_loose"));
                _previousOlyList.put(i, player);
                i++;
            }
        }
        catch (Exception e) {
            _log.error("[RankManager]: Could not load previous month olympiad data: " + this + " - " + e.getMessage(), e);
        }
        finally {
            DbUtils.closeQuietly(con, statement, rset);
        }
    }

    public int getServerRank(Player player) {
        return _playerRanks.computeIfAbsent(player.getObjectId(), oId -> new RankInfo(player)).getServerRank();
    }

    public int getRaceRank(Player player) {
        return _playerRanks.computeIfAbsent(player.getObjectId(), oId -> new RankInfo(player)).getRaceRank();
    }

    public int getClassRank(Player player) {
        return _playerRanks.computeIfAbsent(player.getObjectId(), oId -> new RankInfo(player)).getClassRank();
    }

    public int getGearScoreRank(Player player) {
        return _playerCombatRanks.computeIfAbsent(player.getObjectId(), oId -> new RankInfo(player)).getGearScoreRank();
    }

    private static class SingletonHolder {
        protected static final RankManager INSTANCE = new RankManager();
    }
}