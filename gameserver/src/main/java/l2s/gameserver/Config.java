package l2s.gameserver;

import gnu.trove.set.TIntSet;
import gnu.trove.set.hash.TIntHashSet;
import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.LineNumberReader;
import java.lang.reflect.Field;
import java.util.ArrayList;
import java.util.Collections;
import java.util.HashMap;
import java.util.HashSet;
import java.util.List;
import java.util.Map;
import java.util.Set;
import java.util.StringTokenizer;
import java.util.concurrent.CopyOnWriteArrayList;
import java.util.regex.Pattern;
import java.util.regex.Matcher;

import javax.xml.parsers.DocumentBuilderFactory;

import l2s.gameserver.model.reward.RewardData;
import l2s.gameserver.templates.item.data.ItemData;
import org.apache.commons.lang3.ArrayUtils;
import org.apache.commons.lang3.BooleanUtils;
import org.apache.commons.lang3.math.NumberUtils;
import org.apache.commons.lang3.reflect.FieldUtils;
import l2s.commons.configuration.ExProperties;
import l2s.commons.net.nio.impl.SelectorConfig;
import l2s.commons.string.StringArrayUtils;
import l2s.commons.time.cron.SchedulingPattern;
import l2s.gameserver.data.htm.HtmCache;
import l2s.gameserver.model.base.AcquireType;
import l2s.gameserver.model.base.PlayerAccess;
import l2s.gameserver.network.authcomm.ServerType;
import l2s.gameserver.skills.AbnormalEffect;
import l2s.gameserver.utils.Language;
import l2s.gameserver.utils.velocity.VelocityVariable;
 
import org.apache.commons.lang3.StringUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.w3c.dom.Document;
import org.w3c.dom.Node;

public class Config
{
	private static final Logger _log = LoggerFactory.getLogger(Config.class);

	public static final int NCPUS = Runtime.getRuntime().availableProcessors();

	/** Configuration files */
	public static final String CHAT_ANTIFLOOD_CONFIG_FILE = "config/chat_antiflood.properties";
	public static final String CUSTOM_CONFIG_FILE = "config/custom.properties";
	public static final String OTHER_CONFIG_FILE = "config/other.properties";
	public static final String RESIDENCE_CONFIG_FILE = "config/residence.properties";
	public static final String SPOIL_CONFIG_FILE = "config/spoil.properties";
	public static final String ALT_SETTINGS_FILE = "config/altsettings.properties";
	public static final String FORMULAS_CONFIGURATION_FILE = "config/formulas.properties";
	public static final String PVP_CONFIG_FILE = "config/pvp.properties";
	public static final String TELNET_CONFIGURATION_FILE = "config/telnet.properties";
	public static final String CONFIGURATION_FILE = "config/server.properties";
	public static final String MULTICLASS_CONFIG_FILE = "config/multiclass.properties";
	public static final String SKILL_LEARN = "config/skill.properties";
	public static final String AI_CONFIG_FILE = "config/ai.properties";
	public static final String GEODATA_CONFIG_FILE = "config/geodata.properties";
	public static final String EVENTS_CONFIG_FILE = "config/events.properties";
	public static final String SERVICES_FILE = "config/services.properties";
	public static final String BUFF_STORE_CONFIG_FILE = "config/offline_buffer.properties";
	/* Zone: Dragon Valley */
	public static final String ZONE_DRAGONVALLEY_FILE = "config/zones/DragonValley.properties";
	/* Zone: Lair of Antharas */
	public static final String ZONE_LAIROFANTHARAS_FILE = "config/zones/LairOfAntharas.properties";
	public static final String OLYMPIAD = "config/olympiad.properties";
	public static final String DEVELOP_FILE = "config/develop.properties";

	public static final String STATBONUS_FILE = "config/statbonus.properties";
	public static final String EXT_FILE = "config/ext.properties";
	public static final String BBS_FILE = "config/bbs.properties";
	public static final String FAKE_PLAYERS_LIST = "config/fake_players.list";
	public static final String PVP_MANAGER_FILE = "config/pvp_manager.properties";
	public static final String TRAINING_CAMP_CONFIG_FILE = "config/training_camp.properties";
	public static final String VOTE_REWARD_CONFIG_FILE = "config/vote_reward.properties";
	
	public static final String BOT_FILE = "config/anti_bot_system.properties";
	public static final String SCHEME_BUFFER_FILE = "config/npcbuffer.properties";
	public static final String ANUSEWORDS_CONFIG_FILE = "config/abusewords.txt";

	public static final String GM_PERSONAL_ACCESS_FILE = "config/GMAccess.xml";
	public static final String GM_ACCESS_FILES_DIR = "config/GMAccess.d/";

	public static final String FIGHT_CLUB_FILE = "config/fightclub_events.properties";

	public static final String WORLD_EXCHANGE = "config/worldExchange.properties";

	//Multiproff
	public static boolean ENABLE_MULTICLASS_SKILL_LEARN;
	public static String ENABLE_MULTICLASS_SKILL_LEARN_ITEM;
	public static List<Integer> ENABLE_MULTICLASS_SKILL_LEARN_BLACKLIST = new CopyOnWriteArrayList<>();
	public static int ENABLE_MULTICLASS_SKILL_LEARN_MAX = -1;
	@VelocityVariable
	public static boolean ENABLE_MULTICLASS_SKILL_REMOVE;
	public static String ENABLE_MULTICLASS_SKILL_REMOVE_ITEM;
	public static String ENABLE_MULTICLASS_SKILL_REMOVE_ITEM_S = "57:0";
	public static List<Integer> ENABLE_MULTICLASS_SKILL_REMOVE_BLACKLIST = new CopyOnWriteArrayList<>();
	public static boolean ENABLE_MULTICLASS_SKILL_TRANSFER = false;
	public static String ENABLE_MULTICLASS_SKILL_TRANSFER_REM_ITEM = "57:0";
	@VelocityVariable
	public static boolean ENABLE_MULTICLASS_SKILL_CUSTOM;

	public static boolean MULTICLASS_SKILL_LEVEL_MAX;
	public static boolean MULTICLASS_SKILL_LEVEL_MAX_CUSTOM;
	public static boolean MULTICLASS_ALL_TREANER;

	public static long[] FOURTH_CLASS_CHANGE_PRICE;

	public static int SKILL_LEARN_COST_SP;
	public static boolean ALT_DISABLE_SPELLBOOKS;
	public static boolean SAY_ITEM_ID;

	public static boolean RANDOM_CRAFT_SYSTEM_ENABLED;
	public static int RANDOM_CRAFT_TRY_COMMISSION;

	// World Exchange

	public static boolean ENABLE_WORLD_EXCHANGE;
	public static String WORLD_EXCHANGE_DEFAULT_LANG;
	public static long WORLD_EXCHANGE_SAVE_INTERVAL;
	public static double WORLD_EXCHANGE_LCOIN_TAX;
	public static long WORLD_EXCHANGE_MAX_LCOIN_TAX;
	public static double WORLD_EXCHANGE_ADENA_FEE;
	public static long WORLD_EXCHANGE_MAX_ADENA_FEE;
	public static boolean WORLD_EXCHANGE_LAZY_UPDATE;
	public static int WORLD_EXCHANGE_ITEM_SELL_PERIOD;
	public static int WORLD_EXCHANGE_ITEM_BACK_PERIOD;
	public static int WORLD_EXCHANGE_PAYMENT_TAKE_PERIOD;

	// Balthus Event
	public static boolean BALTHUS_EVENT_ENABLE;
	public static String BALTHUS_EVENT_TIME_START;
	public static String BALTHUS_EVENT_TIME_END;
	public static int BALTHUS_EVENT_PARTICIPATE_BUFF_ID;
	public static int BALTHUS_EVENT_BASIC_REWARD_ID;
	public static int BALTHUS_EVENT_BASIC_REWARD_COUNT;
	public static int BALTHUS_EVENT_JACKPOT_CHANCE;

	//=============================================================================
	public static int SHOW_SKILL_PAGE;
	public static int SKILL_LEARN_ITEM_ID;
	public static long SKILL_LEARN_ITEM_COUNT;
	public static long SKILL_LEARNC_ITEM_COUNT;
	public static int SKILL_DELETE_ITEM_ID;
	public static long SKILL_DELETE_ITEM_COUNT;
	public static int SKILL_LEARN_CUSTOM_ITEM_ID;
	public static long SKILL_LEARN_CUSTOM_ITEM_COUNT;
	public static int[] SKILL_LEARN_SKILL_ID;
	public static int SKILL_LEARN_INDIVID_ITEM_ID;
	public static int SKILL_LEARN_INDIVIDC_ITEM_ID;
	public static long SKILL_LEARN_INDIVID_ITEM_COUNT;
	public static long SKILL_LEARN_INDIVIDC_ITEM_COUNT;
	public static int[] SKILL_LEARN_CUSTOM_SKILL_ID;
	public static int SKILL_LEARN_INDIVID_CUSTOM_ITEM_ID;
	public static long SKILL_LEARN_INDIVID_CUSTOM_ITEM_COUNT;
	public static double SKILL_LEARN_SP_NORM;
	public static double SKILL_LEARN_SP_CUSTOM;
	public static double SKILL_LEARN_SP_CUSTOM1;
	//=============================================================================

	// Fight Club
	public static boolean FIGHT_CLUB_ENABLED;
	public static int MINIMUM_LEVEL_TO_PARRICIPATION;
	public static int MAXIMUM_LEVEL_TO_PARRICIPATION;
	public static int MAXIMUM_LEVEL_DIFFERENCE;
	public static String[] ALLOWED_RATE_ITEMS;
	public static int PLAYERS_PER_PAGE;
	public static int ARENA_TELEPORT_DELAY;
	public static boolean CANCEL_BUFF_BEFORE_FIGHT;
	public static boolean UNSUMMON_PETS;
	public static boolean UNSUMMON_SUMMONS;
	public static boolean REMOVE_CLAN_SKILLS;
	public static boolean REMOVE_HERO_SKILLS;
	public static int TIME_TO_PREPARATION;
	public static int FIGHT_TIME;
	public static boolean ALLOW_DRAW;
	public static int TIME_TELEPORT_BACK;
	public static boolean FIGHT_CLUB_ANNOUNCE_RATE;
	public static boolean FIGHT_CLUB_ANNOUNCE_RATE_TO_SCREEN;
	public static boolean FIGHT_CLUB_ANNOUNCE_START_TO_SCREEN;

	//anti bot stuff
	public static boolean ENABLE_ANTI_BOT_SYSTEM;
	public static int MINIMUM_TIME_QUESTION_ASK;
	public static int MAXIMUM_TIME_QUESTION_ASK;
	public static int MINIMUM_BOT_POINTS_TO_STOP_ASKING;
	public static int MAXIMUM_BOT_POINTS_TO_STOP_ASKING;
	public static int MAX_BOT_POINTS;
	public static int MINIMAL_BOT_RATING_TO_BAN;
	public static int AUTO_BOT_BAN_JAIL_TIME;
	public static boolean ANNOUNCE_AUTO_BOT_BAN;
	public static boolean ON_WRONG_QUESTION_KICK;
	
	public static int HTM_CACHE_MODE;
	public static boolean HTM_SHAPE_ARABIC;
	public static int SHUTDOWN_ANN_TYPE;

	public static String DATABASE_DRIVER;
	public static int DATABASE_MAX_CONNECTIONS;
	public static int DATABASE_MAX_IDLE_TIMEOUT;
	public static int DATABASE_IDLE_TEST_PERIOD;
	public static String DATABASE_URL;
	public static String DATABASE_LOGIN;
	public static String DATABASE_PASSWORD;
	public static boolean DATABASE_AUTOUPDATE;

	// Database additional options
	public static boolean AUTOSAVE;

	public static long USER_INFO_INTERVAL;
	public static long USER_INFO_EXP_SP_INTERVAL;
	public static boolean BROADCAST_STATS_INTERVAL;
	public static long BROADCAST_CHAR_INFO_INTERVAL;
	
	public static int MIN_HIT_TIME;
	public static double MAGIC_CRIT_DMG_MODIFIER;

	public static int START_CLAN_LEVEL;
	public static boolean NEW_CHAR_IS_NOBLE;
	public static boolean ENABLE_L2_TOP_OVERONLINE;
	public static int L2TOP_MAX_ONLINE;
	public static int MIN_ONLINE_0_5_AM;
	public static int MAX_ONLINE_0_5_AM;
	public static int MIN_ONLINE_6_11_AM;
	public static int MAX_ONLINE_6_11_AM;
	public static int MIN_ONLINE_12_6_PM;
	public static int MAX_ONLINE_12_6_PM;
	public static int MIN_ONLINE_7_11_PM;
	public static int MAX_ONLINE_7_11_PM;
	public static int ADD_ONLINE_ON_SIMPLE_DAY;
	public static int ADD_ONLINE_ON_WEEKEND;
	public static int L2TOP_MIN_TRADERS;
	public static int L2TOP_MAX_TRADERS;
	public static int ALT_OLY_BY_SAME_BOX_NUMBER;

	public static boolean OLYMPIAD_ENABLE_ENCHANT_LIMIT;
	public static int OLYMPIAD_WEAPON_ENCHANT_LIMIT;
	public static int OLYMPIAD_ARMOR_ENCHANT_LIMIT;
	public static int OLYMPIAD_JEWEL_ENCHANT_LIMIT;
	public static boolean OLYMPIAD_FOR_AWAKED_CLASS_ONLY;

	public static boolean ALLOW_WORLD_STATISTIC;
	
	public static boolean REFLECT_DAMAGE_CAPPED_BY_PDEF;
	
	public static int EFFECT_TASK_MANAGER_COUNT;

	public static int SKILLS_CAST_TIME_MIN_PHYSICAL;
	public static int SKILLS_CAST_TIME_MIN_MAGICAL;
	public static int PHYS_ATK_REUSE_MIN;
	public static boolean ENABLE_CRIT_HEIGHT_BONUS;
	
	public static int MAXIMUM_ONLINE_USERS;

	public static int CLAN_WAR_LIMIT;
	public static int CLAN_WAR_MINIMUM_CLAN_LEVEL;
	public static int CLAN_WAR_MINIMUM_PLAYERS_DECLARE;
	public static int CLAN_WAR_PREPARATION_DAYS_PERIOD;
	public static int CLAN_WAR_REPUTATION_SCORE_PER_KILL;
	public static int CLAN_WAR_INACTIVITY_DAYS_PERIOD;
	public static int CLAN_WAR_PEACE_DAYS_PERIOD;
	public static int CLAN_WAR_KILLS_COUNT_TO_CONFIRM_MUTUAL_WAR;
	public static int CLAN_WAR_CANCEL_REPUTATION_PENALTY;

	public static boolean DONTLOADSPAWN;
	public static boolean DONTLOADQUEST;
	public static int MAX_REFLECTIONS_COUNT;

	public static int SHIFT_BY;
	public static int SHIFT_BY_Z;
	public static int MAP_MIN_Z;
	public static int MAP_MAX_Z;
	
	public static boolean ENABLE_TAUTI_FREE_ENTRANCE;
	
	public static int AETHER_CHANCE;
	public static int AETHER_DOUBLE_CHANCE;

	/** ChatBan */
	public static int CHAT_MESSAGE_MAX_LEN;
	public static boolean ABUSEWORD_BANCHAT;
	public static int[] BAN_CHANNEL_LIST = new int[18];
	public static boolean ABUSEWORD_REPLACE;
	public static String ABUSEWORD_REPLACE_STRING;
	public static int ABUSEWORD_BANTIME;
	public static Pattern ABUSEWORD_PATTERN = null;
	public static boolean BANCHAT_ANNOUNCE;
	public static boolean BANCHAT_ANNOUNCE_FOR_ALL_WORLD;
	public static boolean BANCHAT_ANNOUNCE_NICK;
	public static boolean GVG_LANG;

	public static boolean ALLOW_REFFERAL_SYSTEM;

	public static int REF_SAVE_INTERVAL;

	public static int MAX_REFFERALS_PER_CHAR;

	public static int MIN_ONLINE_TIME;

	public static int MIN_REFF_LEVEL;

	public static double REF_PERCENT_GIVE;

	public static boolean PREMIUM_ACCOUNT_ENABLED;
	public static boolean PREMIUM_ACCOUNT_BASED_ON_GAMESERVER;
	public static int FREE_PA_TYPE;
	public static int FREE_PA_DELAY;
	public static boolean ENABLE_FREE_PA_NOTIFICATION;

	//catalyst chances
	public static int CATALYST_POWER_W_D;
	public static int CATALYST_POWER_W_C;
	public static int CATALYST_POWER_W_B;
	public static int CATALYST_POWER_W_A;
	public static int CATALYST_POWER_W_S;
	public static int CATALYST_POWER_A_D;
	public static int CATALYST_POWER_A_C;
	public static int CATALYST_POWER_A_B;
	public static int CATALYST_POWER_A_A;
	public static int CATALYST_POWER_A_S;
	
	public static boolean ALT_SELL_ITEM_ONE_ADENA;
	public static int SELL_ITEM_COUNT_PRICE;

	public static int MAX_SIEGE_CLANS;

	// skin service
	public static Map<Integer, ItemData> COSTUME_PRICES;

	public static List<Integer> ITEM_LIST = new ArrayList<Integer>();

	public static TIntSet DROP_ONLY_THIS = new TIntHashSet();
	public static boolean INCLUDE_RAID_DROP;

	public static boolean SAVING_SPS;
	public static boolean MANAHEAL_SPS_BONUS;

	public static int ALT_ADD_RECIPES;
	public static int ALT_MAX_ALLY_SIZE;

	public static int ALT_PARTY_DISTRIBUTION_RANGE;
	public static double[] ALT_PARTY_BONUS;
	public static double[] ALT_PARTY_CLAN_BONUS;
	public static int[] ALT_PARTY_LVL_DIFF_PENALTY;
	public static boolean ALT_ALL_PHYS_SKILLS_OVERHIT;

	public static double ALT_POLE_DAMAGE_MODIFIER;

	public static double LONG_RANGE_AUTO_ATTACK_P_ATK_MOD;
	public static double SHORT_RANGE_AUTO_ATTACK_P_ATK_MOD;

	public static double ALT_M_SIMPLE_DAMAGE_MOD;
	public static double ALT_M_SIMPLE_DAMAGE_MOD_SIGEL;
	public static double ALT_M_SIMPLE_DAMAGE_MOD_TIR_WARRIOR;
	public static double ALT_M_SIMPLE_DAMAGE_MOD_OTHEL_ROGUE;
	public static double ALT_M_SIMPLE_DAMAGE_MOD_YR_ARCHER;
	public static double ALT_M_SIMPLE_DAMAGE_MOD_FEO_WIZZARD;
	public static double ALT_M_SIMPLE_DAMAGE_MOD_ISS_ENCHANTER;
	public static double ALT_M_SIMPLE_DAMAGE_MOD_WYN_SUMMONER;
	public static double ALT_M_SIMPLE_DAMAGE_MOD_EOL_HEALER;
	//new
	public static double ALT_M_SIMPLE_DAMAGE_MOD_SIGEL_PHOENIX_KNIGHT;
	public static double ALT_M_SIMPLE_DAMAGE_MOD_SIGEL_HELL_KNIGHT;
	public static double ALT_M_SIMPLE_DAMAGE_MOD_SIGEL_EVAS_TEMPLAR;
	public static double ALT_M_SIMPLE_DAMAGE_MOD_SIGEL_SHILLIEN_TEMPLAR;
	public static double ALT_M_SIMPLE_DAMAGE_MOD_TYR_DUELIST;
	public static double ALT_M_SIMPLE_DAMAGE_MOD_TYR_DREADNOUGHT;
	public static double ALT_M_SIMPLE_DAMAGE_MOD_TYR_TITAN;
	public static double ALT_M_SIMPLE_DAMAGE_MOD_TYR_GRAND_KHAVATARI;
	public static double ALT_M_SIMPLE_DAMAGE_MOD_TYR_MAESTRO;
	public static double ALT_M_SIMPLE_DAMAGE_MOD_TYR_DOOMBRINGER;
	public static double ALT_M_SIMPLE_DAMAGE_MOD_OTHELL_ADVENTURER;
	public static double ALT_M_SIMPLE_DAMAGE_MOD_OTHELL_WIND_RIDER;
	public static double ALT_M_SIMPLE_DAMAGE_MOD_OTHELL_GHOST_HUNTER;
	public static double ALT_M_SIMPLE_DAMAGE_MOD_OTHELL_FORTUNE_SEEKER;
	public static double ALT_M_SIMPLE_DAMAGE_MOD_YR_SAGITTARIUS;
	public static double ALT_M_SIMPLE_DAMAGE_MOD_YR_MOONLIGHT_SENTINEL;
	public static double ALT_M_SIMPLE_DAMAGE_MOD_YR_GHOST_SENTINEL;
	public static double ALT_M_SIMPLE_DAMAGE_MOD_YR_TRICKSTER;
	public static double ALT_M_SIMPLE_DAMAGE_MOD_FEOH_ARCHMAGE;
	public static double ALT_M_SIMPLE_DAMAGE_MOD_FEOH_SOULTAKER;
	public static double ALT_M_SIMPLE_DAMAGE_MOD_FEOH_MYSTIC_MUSE;
	public static double ALT_M_SIMPLE_DAMAGE_MOD_FEOH_STORM_SCREAMER;
	public static double ALT_M_SIMPLE_DAMAGE_MOD_FEOH_SOUL_HOUND;
	public static double ALT_M_SIMPLE_DAMAGE_MOD_ISS_HIEROPHANT;
	public static double ALT_M_SIMPLE_DAMAGE_MOD_ISS_SWORD_MUSE;
	public static double ALT_M_SIMPLE_DAMAGE_MOD_ISS_SPECTRAL_DANCER;
	public static double ALT_M_SIMPLE_DAMAGE_MOD_ISS_DOMINATOR;
	public static double ALT_M_SIMPLE_DAMAGE_MOD_ISS_DOOMCRYER;
	public static double ALT_M_SIMPLE_DAMAGE_MOD_WYNN_ARCANA_LORD;
	public static double ALT_M_SIMPLE_DAMAGE_MOD_WYNN_ELEMENTAL_MASTER;
	public static double ALT_M_SIMPLE_DAMAGE_MOD_WYNN_SPECTRAL_MASTER;
	public static double ALT_M_SIMPLE_DAMAGE_MOD_AEORE_CARDINAL;
	public static double ALT_M_SIMPLE_DAMAGE_MOD_AEORE_EVAS_SAINT;
	public static double ALT_M_SIMPLE_DAMAGE_MOD_AEORE_SHILLIEN_SAINT;
	public static double ALT_M_SIMPLE_DAMAGE_MOD_EVISCERATOR;
	public static double ALT_M_SIMPLE_DAMAGE_MOD_SAHYAS_SEER;

	public static double ALT_P_DAMAGE_MOD;
	public static double ALT_P_DAMAGE_MOD_SIGEL;
	public static double ALT_P_DAMAGE_MOD_TIR_WARRIOR;
	public static double ALT_P_DAMAGE_MOD_OTHEL_ROGUE;
	public static double ALT_P_DAMAGE_MOD_YR_ARCHER;
	public static double ALT_P_DAMAGE_MOD_FEO_WIZZARD;
	public static double ALT_P_DAMAGE_MOD_ISS_ENCHANTER;
	public static double ALT_P_DAMAGE_MOD_WYN_SUMMONER;
	public static double ALT_P_DAMAGE_MOD_EOL_HEALER;
	//new
	public static double ALT_P_DAMAGE_MOD_SIGEL_PHOENIX_KNIGHT;
	public static double ALT_P_DAMAGE_MOD_SIGEL_HELL_KNIGHT;
	public static double ALT_P_DAMAGE_MOD_SIGEL_EVAS_TEMPLAR;
	public static double ALT_P_DAMAGE_MOD_SIGEL_SHILLIEN_TEMPLAR;
	public static double ALT_P_DAMAGE_MOD_TYR_DUELIST;
	public static double ALT_P_DAMAGE_MOD_TYR_DREADNOUGHT;
	public static double ALT_P_DAMAGE_MOD_TYR_TITAN;
	public static double ALT_P_DAMAGE_MOD_TYR_GRAND_KHAVATARI;
	public static double ALT_P_DAMAGE_MOD_TYR_MAESTRO;
	public static double ALT_P_DAMAGE_MOD_TYR_DOOMBRINGER;
	public static double ALT_P_DAMAGE_MOD_OTHELL_ADVENTURER;
	public static double ALT_P_DAMAGE_MOD_OTHELL_WIND_RIDER;
	public static double ALT_P_DAMAGE_MOD_OTHELL_GHOST_HUNTER;
	public static double ALT_P_DAMAGE_MOD_OTHELL_FORTUNE_SEEKER;
	public static double ALT_P_DAMAGE_MOD_YR_SAGITTARIUS;
	public static double ALT_P_DAMAGE_MOD_YR_MOONLIGHT_SENTINEL;
	public static double ALT_P_DAMAGE_MOD_YR_GHOST_SENTINEL;
	public static double ALT_P_DAMAGE_MOD_YR_TRICKSTER;
	public static double ALT_P_DAMAGE_MOD_FEOH_ARCHMAGE;
	public static double ALT_P_DAMAGE_MOD_FEOH_SOULTAKER;
	public static double ALT_P_DAMAGE_MOD_FEOH_MYSTIC_MUSE;
	public static double ALT_P_DAMAGE_MOD_FEOH_STORM_SCREAMER;
	public static double ALT_P_DAMAGE_MOD_FEOH_SOUL_HOUND;
	public static double ALT_P_DAMAGE_MOD_ISS_HIEROPHANT;
	public static double ALT_P_DAMAGE_MOD_ISS_SWORD_MUSE;
	public static double ALT_P_DAMAGE_MOD_ISS_SPECTRAL_DANCER;
	public static double ALT_P_DAMAGE_MOD_ISS_DOMINATOR;
	public static double ALT_P_DAMAGE_MOD_ISS_DOOMCRYER;
	public static double ALT_P_DAMAGE_MOD_WYNN_ARCANA_LORD;
	public static double ALT_P_DAMAGE_MOD_WYNN_ELEMENTAL_MASTER;
	public static double ALT_P_DAMAGE_MOD_WYNN_SPECTRAL_MASTER;
	public static double ALT_P_DAMAGE_MOD_AEORE_CARDINAL;
	public static double ALT_P_DAMAGE_MOD_AEORE_EVAS_SAINT;
	public static double ALT_P_DAMAGE_MOD_AEORE_SHILLIEN_SAINT;
	public static double ALT_P_DAMAGE_MOD_EVISCERATOR;
	public static double ALT_P_DAMAGE_MOD_SAHYAS_SEER;

	public static double ALT_M_CRIT_DAMAGE_MOD;
	public static double ALT_M_CRIT_DAMAGE_MOD_SIGEL;
	public static double ALT_M_CRIT_DAMAGE_MOD_TIR_WARRIOR;
	public static double ALT_M_CRIT_DAMAGE_MOD_OTHEL_ROGUE;
	public static double ALT_M_CRIT_DAMAGE_MOD_YR_ARCHER;
	public static double ALT_M_CRIT_DAMAGE_MOD_FEO_WIZZARD;
	public static double ALT_M_CRIT_DAMAGE_MOD_ISS_ENCHANTER;
	public static double ALT_M_CRIT_DAMAGE_MOD_WYN_SUMMONER;
	public static double ALT_M_CRIT_DAMAGE_MOD_EOL_HEALER;
	//new
	public static double ALT_M_CRIT_DAMAGE_MOD_SIGEL_PHOENIX_KNIGHT;
	public static double ALT_M_CRIT_DAMAGE_MOD_SIGEL_HELL_KNIGHT;
	public static double ALT_M_CRIT_DAMAGE_MOD_SIGEL_EVAS_TEMPLAR;
	public static double ALT_M_CRIT_DAMAGE_MOD_SIGEL_SHILLIEN_TEMPLAR;
	public static double ALT_M_CRIT_DAMAGE_MOD_TYR_DUELIST;
	public static double ALT_M_CRIT_DAMAGE_MOD_TYR_DREADNOUGHT;
	public static double ALT_M_CRIT_DAMAGE_MOD_TYR_TITAN;
	public static double ALT_M_CRIT_DAMAGE_MOD_TYR_GRAND_KHAVATARI;
	public static double ALT_M_CRIT_DAMAGE_MOD_TYR_MAESTRO;
	public static double ALT_M_CRIT_DAMAGE_MOD_TYR_DOOMBRINGER;
	public static double ALT_M_CRIT_DAMAGE_MOD_OTHELL_ADVENTURER;
	public static double ALT_M_CRIT_DAMAGE_MOD_OTHELL_WIND_RIDER;
	public static double ALT_M_CRIT_DAMAGE_MOD_OTHELL_GHOST_HUNTER;
	public static double ALT_M_CRIT_DAMAGE_MOD_OTHELL_FORTUNE_SEEKER;
	public static double ALT_M_CRIT_DAMAGE_MOD_YR_SAGITTARIUS;
	public static double ALT_M_CRIT_DAMAGE_MOD_YR_MOONLIGHT_SENTINEL;
	public static double ALT_M_CRIT_DAMAGE_MOD_YR_GHOST_SENTINEL;
	public static double ALT_M_CRIT_DAMAGE_MOD_YR_TRICKSTER;
	public static double ALT_M_CRIT_DAMAGE_MOD_FEOH_ARCHMAGE;
	public static double ALT_M_CRIT_DAMAGE_MOD_FEOH_SOULTAKER;
	public static double ALT_M_CRIT_DAMAGE_MOD_FEOH_MYSTIC_MUSE;
	public static double ALT_M_CRIT_DAMAGE_MOD_FEOH_STORM_SCREAMER;
	public static double ALT_M_CRIT_DAMAGE_MOD_FEOH_SOUL_HOUND;
	public static double ALT_M_CRIT_DAMAGE_MOD_ISS_HIEROPHANT;
	public static double ALT_M_CRIT_DAMAGE_MOD_ISS_SWORD_MUSE;
	public static double ALT_M_CRIT_DAMAGE_MOD_ISS_SPECTRAL_DANCER;
	public static double ALT_M_CRIT_DAMAGE_MOD_ISS_DOMINATOR;
	public static double ALT_M_CRIT_DAMAGE_MOD_ISS_DOOMCRYER;
	public static double ALT_M_CRIT_DAMAGE_MOD_WYNN_ARCANA_LORD;
	public static double ALT_M_CRIT_DAMAGE_MOD_WYNN_ELEMENTAL_MASTER;
	public static double ALT_M_CRIT_DAMAGE_MOD_WYNN_SPECTRAL_MASTER;
	public static double ALT_M_CRIT_DAMAGE_MOD_AEORE_CARDINAL;
	public static double ALT_M_CRIT_DAMAGE_MOD_AEORE_EVAS_SAINT;
	public static double ALT_M_CRIT_DAMAGE_MOD_AEORE_SHILLIEN_SAINT;
	public static double ALT_M_CRIT_DAMAGE_MOD_EVISCERATOR;
	public static double ALT_M_CRIT_DAMAGE_MOD_SAHYAS_SEER;

	public static double ALT_P_CRIT_DAMAGE_MOD;
	public static double ALT_P_CRIT_DAMAGE_MOD_SIGEL;
	public static double ALT_P_CRIT_DAMAGE_MOD_TIR_WARRIOR;
	public static double ALT_P_CRIT_DAMAGE_MOD_OTHEL_ROGUE;
	public static double ALT_P_CRIT_DAMAGE_MOD_YR_ARCHER;
	public static double ALT_P_CRIT_DAMAGE_MOD_FEO_WIZZARD;
	public static double ALT_P_CRIT_DAMAGE_MOD_ISS_ENCHANTER;
	public static double ALT_P_CRIT_DAMAGE_MOD_WYN_SUMMONER;
	public static double ALT_P_CRIT_DAMAGE_MOD_EOL_HEALER;
	//new
	public static double ALT_P_CRIT_DAMAGE_MOD_SIGEL_PHOENIX_KNIGHT;
	public static double ALT_P_CRIT_DAMAGE_MOD_SIGEL_HELL_KNIGHT;
	public static double ALT_P_CRIT_DAMAGE_MOD_SIGEL_EVAS_TEMPLAR;
	public static double ALT_P_CRIT_DAMAGE_MOD_SIGEL_SHILLIEN_TEMPLAR;
	public static double ALT_P_CRIT_DAMAGE_MOD_TYR_DUELIST;
	public static double ALT_P_CRIT_DAMAGE_MOD_TYR_DREADNOUGHT;
	public static double ALT_P_CRIT_DAMAGE_MOD_TYR_TITAN;
	public static double ALT_P_CRIT_DAMAGE_MOD_TYR_GRAND_KHAVATARI;
	public static double ALT_P_CRIT_DAMAGE_MOD_TYR_MAESTRO;
	public static double ALT_P_CRIT_DAMAGE_MOD_TYR_DOOMBRINGER;
	public static double ALT_P_CRIT_DAMAGE_MOD_OTHELL_ADVENTURER;
	public static double ALT_P_CRIT_DAMAGE_MOD_OTHELL_WIND_RIDER;
	public static double ALT_P_CRIT_DAMAGE_MOD_OTHELL_GHOST_HUNTER;
	public static double ALT_P_CRIT_DAMAGE_MOD_OTHELL_FORTUNE_SEEKER;
	public static double ALT_P_CRIT_DAMAGE_MOD_YR_SAGITTARIUS;
	public static double ALT_P_CRIT_DAMAGE_MOD_YR_MOONLIGHT_SENTINEL;
	public static double ALT_P_CRIT_DAMAGE_MOD_YR_GHOST_SENTINEL;
	public static double ALT_P_CRIT_DAMAGE_MOD_YR_TRICKSTER;
	public static double ALT_P_CRIT_DAMAGE_MOD_FEOH_ARCHMAGE;
	public static double ALT_P_CRIT_DAMAGE_MOD_FEOH_SOULTAKER;
	public static double ALT_P_CRIT_DAMAGE_MOD_FEOH_MYSTIC_MUSE;
	public static double ALT_P_CRIT_DAMAGE_MOD_FEOH_STORM_SCREAMER;
	public static double ALT_P_CRIT_DAMAGE_MOD_FEOH_SOUL_HOUND;
	public static double ALT_P_CRIT_DAMAGE_MOD_ISS_HIEROPHANT;
	public static double ALT_P_CRIT_DAMAGE_MOD_ISS_SWORD_MUSE;
	public static double ALT_P_CRIT_DAMAGE_MOD_ISS_SPECTRAL_DANCER;
	public static double ALT_P_CRIT_DAMAGE_MOD_ISS_DOMINATOR;
	public static double ALT_P_CRIT_DAMAGE_MOD_ISS_DOOMCRYER;
	public static double ALT_P_CRIT_DAMAGE_MOD_WYNN_ARCANA_LORD;
	public static double ALT_P_CRIT_DAMAGE_MOD_WYNN_ELEMENTAL_MASTER;
	public static double ALT_P_CRIT_DAMAGE_MOD_WYNN_SPECTRAL_MASTER;
	public static double ALT_P_CRIT_DAMAGE_MOD_AEORE_CARDINAL;
	public static double ALT_P_CRIT_DAMAGE_MOD_AEORE_EVAS_SAINT;
	public static double ALT_P_CRIT_DAMAGE_MOD_AEORE_SHILLIEN_SAINT;
	public static double ALT_P_CRIT_DAMAGE_MOD_EVISCERATOR;
	public static double ALT_P_CRIT_DAMAGE_MOD_SAHYAS_SEER;
	
	public static double ALT_P_CRIT_DAMAGE_MOD_SIGEL_FIZ;	
	public static double ALT_P_CRIT_DAMAGE_MOD_TIR_WARRIOR_FIZ;	
	public static double ALT_P_CRIT_DAMAGE_MOD_OTHEL_ROGUE_FIZ;	
	public static double ALT_P_CRIT_DAMAGE_MOD_YR_ARCHER_FIZ;	
	public static double ALT_P_CRIT_DAMAGE_MOD_SIGEL_PHOENIX_KNIGHT_FIZ;	
	public static double ALT_P_CRIT_DAMAGE_MOD_SIGEL_HELL_KNIGHT_FIZ;	
	public static double ALT_P_CRIT_DAMAGE_MOD_SIGEL_EVAS_TEMPLAR_FIZ;	
	public static double ALT_P_CRIT_DAMAGE_MOD_SIGEL_SHILLIEN_TEMPLAR_FIZ;	
	public static double ALT_P_CRIT_DAMAGE_MOD_TYR_DUELIST_FIZ;	
	public static double ALT_P_CRIT_DAMAGE_MOD_TYR_DREADNOUGHT_FIZ;	
	public static double ALT_P_CRIT_DAMAGE_MOD_TYR_TITAN_FIZ;	
	public static double ALT_P_CRIT_DAMAGE_MOD_TYR_GRAND_KHAVATARI_FIZ;	
	public static double ALT_P_CRIT_DAMAGE_MOD_TYR_MAESTRO_FIZ;	
	public static double ALT_P_CRIT_DAMAGE_MOD_TYR_DOOMBRINGER_FIZ;	
	public static double ALT_P_CRIT_DAMAGE_MOD_OTHELL_ADVENTURER_FIZ;	
	public static double ALT_P_CRIT_DAMAGE_MOD_OTHELL_WIND_RIDER_FIZ;	
	public static double ALT_P_CRIT_DAMAGE_MOD_OTHELL_GHOST_HUNTER_FIZ;	
	public static double ALT_P_CRIT_DAMAGE_MOD_OTHELL_FORTUNE_SEEKER_FIZ;	
	
	public static double ALT_P_CRIT_DAMAGE_MOD_YR_SAGITTARIUS_FIZ;	
	public static double ALT_P_CRIT_DAMAGE_MOD_YR_MOONLIGHT_SENTINEL_FIZ;	
	public static double ALT_P_CRIT_DAMAGE_MOD_YR_GHOST_SENTINEL_FIZ;	
	public static double ALT_P_CRIT_DAMAGE_MOD_YR_TRICKSTER_FIZ;	
	public static double ALT_P_CRIT_DAMAGE_MOD_FEOH_SOUL_HOUND_FIZ;	
	public static double ALT_P_CRIT_DAMAGE_MOD_ISS_DOMINATOR_FIZ;	
	public static double ALT_P_CRIT_DAMAGE_MOD_ISS_DOOMCRYER_FIZ;	
	public static double ALT_P_CRIT_DAMAGE_MOD_EVISCERATOR_FIZ;
	public static double ALT_P_CRIT_DAMAGE_MOD_SAHYAS_SEER_FIZ;
		
	public static double ALT_P_CRIT_CHANCE_MOD;
	public static double ALT_P_CRIT_CHANCE_MOD_SIGEL;
	public static double ALT_P_CRIT_CHANCE_MOD_TIR_WARRIOR;
	public static double ALT_P_CRIT_CHANCE_MOD_OTHEL_ROGUE;
	public static double ALT_P_CRIT_CHANCE_MOD_YR_ARCHER;
	public static double ALT_P_CRIT_CHANCE_MOD_FEO_WIZZARD;
	public static double ALT_P_CRIT_CHANCE_MOD_ISS_ENCHANTER;
	public static double ALT_P_CRIT_CHANCE_MOD_WYN_SUMMONER;
	public static double ALT_P_CRIT_CHANCE_MOD_EOL_HEALER;
	//new
	public static double ALT_P_CRIT_CHANCE_MOD_SIGEL_PHOENIX_KNIGHT;
	public static double ALT_P_CRIT_CHANCE_MOD_SIGEL_HELL_KNIGHT;
	public static double ALT_P_CRIT_CHANCE_MOD_SIGEL_EVAS_TEMPLAR;
	public static double ALT_P_CRIT_CHANCE_MOD_SIGEL_SHILLIEN_TEMPLAR;
	public static double ALT_P_CRIT_CHANCE_MOD_TYR_DUELIST;
	public static double ALT_P_CRIT_CHANCE_MOD_TYR_DREADNOUGHT;
	public static double ALT_P_CRIT_CHANCE_MOD_TYR_TITAN;
	public static double ALT_P_CRIT_CHANCE_MOD_TYR_GRAND_KHAVATARI;
	public static double ALT_P_CRIT_CHANCE_MOD_TYR_MAESTRO;
	public static double ALT_P_CRIT_CHANCE_MOD_TYR_DOOMBRINGER;
	public static double ALT_P_CRIT_CHANCE_MOD_OTHELL_ADVENTURER;
	public static double ALT_P_CRIT_CHANCE_MOD_OTHELL_WIND_RIDER;
	public static double ALT_P_CRIT_CHANCE_MOD_OTHELL_GHOST_HUNTER;
	public static double ALT_P_CRIT_CHANCE_MOD_OTHELL_FORTUNE_SEEKER;
	public static double ALT_P_CRIT_CHANCE_MOD_YR_SAGITTARIUS;
	public static double ALT_P_CRIT_CHANCE_MOD_YR_MOONLIGHT_SENTINEL;
	public static double ALT_P_CRIT_CHANCE_MOD_YR_GHOST_SENTINEL;
	public static double ALT_P_CRIT_CHANCE_MOD_YR_TRICKSTER;
	public static double ALT_P_CRIT_CHANCE_MOD_FEOH_ARCHMAGE;
	public static double ALT_P_CRIT_CHANCE_MOD_FEOH_SOULTAKER;
	public static double ALT_P_CRIT_CHANCE_MOD_FEOH_MYSTIC_MUSE;
	public static double ALT_P_CRIT_CHANCE_MOD_FEOH_STORM_SCREAMER;
	public static double ALT_P_CRIT_CHANCE_MOD_FEOH_SOUL_HOUND;
	public static double ALT_P_CRIT_CHANCE_MOD_ISS_HIEROPHANT;
	public static double ALT_P_CRIT_CHANCE_MOD_ISS_SWORD_MUSE;
	public static double ALT_P_CRIT_CHANCE_MOD_ISS_SPECTRAL_DANCER;
	public static double ALT_P_CRIT_CHANCE_MOD_ISS_DOMINATOR;
	public static double ALT_P_CRIT_CHANCE_MOD_ISS_DOOMCRYER;
	public static double ALT_P_CRIT_CHANCE_MOD_WYNN_ARCANA_LORD;
	public static double ALT_P_CRIT_CHANCE_MOD_WYNN_ELEMENTAL_MASTER;
	public static double ALT_P_CRIT_CHANCE_MOD_WYNN_SPECTRAL_MASTER;
	public static double ALT_P_CRIT_CHANCE_MOD_AEORE_CARDINAL;
	public static double ALT_P_CRIT_CHANCE_MOD_AEORE_EVAS_SAINT;
	public static double ALT_P_CRIT_CHANCE_MOD_AEORE_SHILLIEN_SAINT;
	public static double ALT_P_CRIT_CHANCE_MOD_EVISCERATOR;
	public static double ALT_P_CRIT_CHANCE_MOD_SAHYAS_SEER;
	
	public static double ALT_M_CRIT_CHANCE_MOD;
	public static double ALT_M_CRIT_CHANCE_MOD_SIGEL;
	public static double ALT_M_CRIT_CHANCE_MOD_TIR_WARRIOR;
	public static double ALT_M_CRIT_CHANCE_MOD_OTHEL_ROGUE;
	public static double ALT_M_CRIT_CHANCE_MOD_YR_ARCHER;
	public static double ALT_M_CRIT_CHANCE_MOD_FEO_WIZZARD;
	public static double ALT_M_CRIT_CHANCE_MOD_ISS_ENCHANTER;
	public static double ALT_M_CRIT_CHANCE_MOD_WYN_SUMMONER;
	public static double ALT_M_CRIT_CHANCE_MOD_EOL_HEALER;	
	//new
	public static double ALT_M_CRIT_CHANCE_MOD_SIGEL_PHOENIX_KNIGHT;
	public static double ALT_M_CRIT_CHANCE_MOD_SIGEL_HELL_KNIGHT;
	public static double ALT_M_CRIT_CHANCE_MOD_SIGEL_EVAS_TEMPLAR;
	public static double ALT_M_CRIT_CHANCE_MOD_SIGEL_SHILLIEN_TEMPLAR;
	public static double ALT_M_CRIT_CHANCE_MOD_TYR_DUELIST;
	public static double ALT_M_CRIT_CHANCE_MOD_TYR_DREADNOUGHT;
	public static double ALT_M_CRIT_CHANCE_MOD_TYR_TITAN;
	public static double ALT_M_CRIT_CHANCE_MOD_TYR_GRAND_KHAVATARI;
	public static double ALT_M_CRIT_CHANCE_MOD_TYR_MAESTRO;
	public static double ALT_M_CRIT_CHANCE_MOD_TYR_DOOMBRINGER;
	public static double ALT_M_CRIT_CHANCE_MOD_OTHELL_ADVENTURER;
	public static double ALT_M_CRIT_CHANCE_MOD_OTHELL_WIND_RIDER;
	public static double ALT_M_CRIT_CHANCE_MOD_OTHELL_GHOST_HUNTER;
	public static double ALT_M_CRIT_CHANCE_MOD_OTHELL_FORTUNE_SEEKER;
	public static double ALT_M_CRIT_CHANCE_MOD_YR_SAGITTARIUS;
	public static double ALT_M_CRIT_CHANCE_MOD_YR_MOONLIGHT_SENTINEL;
	public static double ALT_M_CRIT_CHANCE_MOD_YR_GHOST_SENTINEL;
	public static double ALT_M_CRIT_CHANCE_MOD_YR_TRICKSTER;
	public static double ALT_M_CRIT_CHANCE_MOD_FEOH_ARCHMAGE;
	public static double ALT_M_CRIT_CHANCE_MOD_FEOH_SOULTAKER;
	public static double ALT_M_CRIT_CHANCE_MOD_FEOH_MYSTIC_MUSE;
	public static double ALT_M_CRIT_CHANCE_MOD_FEOH_STORM_SCREAMER;
	public static double ALT_M_CRIT_CHANCE_MOD_FEOH_SOUL_HOUND;
	public static double ALT_M_CRIT_CHANCE_MOD_ISS_HIEROPHANT;
	public static double ALT_M_CRIT_CHANCE_MOD_ISS_SWORD_MUSE;
	public static double ALT_M_CRIT_CHANCE_MOD_ISS_SPECTRAL_DANCER;
	public static double ALT_M_CRIT_CHANCE_MOD_ISS_DOMINATOR;
	public static double ALT_M_CRIT_CHANCE_MOD_ISS_DOOMCRYER;
	public static double ALT_M_CRIT_CHANCE_MOD_WYNN_ARCANA_LORD;
	public static double ALT_M_CRIT_CHANCE_MOD_WYNN_ELEMENTAL_MASTER;
	public static double ALT_M_CRIT_CHANCE_MOD_WYNN_SPECTRAL_MASTER;
	public static double ALT_M_CRIT_CHANCE_MOD_AEORE_CARDINAL;
	public static double ALT_M_CRIT_CHANCE_MOD_AEORE_EVAS_SAINT;
	public static double ALT_M_CRIT_CHANCE_MOD_AEORE_SHILLIEN_SAINT;
	public static double ALT_M_CRIT_CHANCE_MOD_EVISCERATOR;
	public static double ALT_M_CRIT_CHANCE_MOD_SAHYAS_SEER;

	public static double SERVITOR_P_ATK_MODIFIER;
	public static double SERVITOR_M_ATK_MODIFIER;
	public static double SERVITOR_P_DEF_MODIFIER;
	public static double SERVITOR_M_DEF_MODIFIER;
	public static double SERVITOR_P_SKILL_POWER_MODIFIER;
	public static double SERVITOR_M_SKILL_POWER_MODIFIER;
		
	public static double ALT_BLOW_DAMAGE_MOD;
	public static double ALT_BLOW_CRIT_RATE_MODIFIER;
	public static double ALT_VAMPIRIC_CHANCE_MOD;

	public static boolean ALT_REMOVE_SKILLS_ON_DELEVEL;

	public static double ALT_VITALITY_RATE;
	public static double ALT_VITALITY_PA_RATE;
	public static double ALT_VITALITY_CONSUME_RATE;
	public static int ALT_VITALITY_POTIONS_LIMIT;
	public static int ALT_VITALITY_POTIONS_PA_LIMIT;
	
	public static int MAX_SYMBOL_SEAL_POINTS;
	public static float CONSUME_SYMBOL_SEAL_POINTS;

	public static int LIGHT_CASTLE_SELL_TAX_PERCENT;
	public static int DARK_CASTLE_SELL_TAX_PERCENT;
	public static int LIGHT_CASTLE_BUY_TAX_PERCENT;
	public static int DARK_CASTLE_BUY_TAX_PERCENT;

	@VelocityVariable
	public static boolean ALT_PCBANG_POINTS_ENABLED;
	public static boolean PC_BANG_POINTS_BY_ACCOUNT;
	public static boolean ALT_PCBANG_POINTS_ONLY_PREMIUM;
	public static double ALT_PCBANG_POINTS_BONUS_DOUBLE_CHANCE;
	public static int ALT_PCBANG_POINTS_BONUS;
	public static int ALT_PCBANG_POINTS_DELAY;
	public static int ALT_PCBANG_POINTS_MIN_LVL;
	public static TIntSet ALT_ALLOWED_MULTISELLS_IN_PCBANG = new TIntHashSet();

	public static int ALT_PCBANG_POINTS_MAX_CODE_ENTER_ATTEMPTS;
	public static int ALT_PCBANG_POINTS_BAN_TIME;

	public static boolean ALT_DEBUG_ENABLED;
	public static boolean ALT_DEBUG_PVP_ENABLED;
	public static boolean ALT_DEBUG_PVP_DUEL_ONLY;
	public static boolean ALT_DEBUG_PVE_ENABLED;

	/** Thread pools size */
	public static int SCHEDULED_THREAD_POOL_SIZE;
	public static int EXECUTOR_THREAD_POOL_SIZE;

	/** Network settings */
	public static SelectorConfig SELECTOR_CONFIG = new SelectorConfig();

	public static boolean AUTO_LOOT;
	public static boolean AUTO_LOOT_HERBS;
	public static boolean AUTO_LOOT_ONLY_ADENA;
	public static boolean AUTO_LOOT_INDIVIDUAL;
	public static boolean AUTO_LOOT_FROM_RAIDS;
	public static TIntSet AUTO_LOOT_ITEM_ID_LIST = new TIntHashSet();

	/** Auto-loot for/from players with karma also? */
	public static boolean AUTO_LOOT_PK;

	/** Character name template */
	public static String CNAME_TEMPLATE;

	public static int MAX_CHARACTERS_NUMBER_PER_ACCOUNT;

	public static int CNAME_MAXLEN = 32;

	/** Clan name template */
	public static String CLAN_NAME_TEMPLATE;
	public static String APASSWD_TEMPLATE;

	/** Clan title template */
	public static String CLAN_TITLE_TEMPLATE;

	/** Ally name template */
	public static String ALLY_NAME_TEMPLATE;

	/** Global chat state */
	public static boolean GLOBAL_SHOUT;
	public static boolean GLOBAL_TRADE_CHAT;
	public static int CHAT_RANGE;
	public static int SHOUT_SQUARE_OFFSET;

	public static boolean ALLOW_WORLD_CHAT;
	public static int WORLD_CHAT_POINTS_PER_DAY;
	public static int WORLD_CHAT_POINTS_PER_DAY_PA;
	
	public static boolean BAN_FOR_CFG_USAGE;
	
	public static boolean ALLOW_TOTAL_ONLINE;
	public static boolean ALLOW_ONLINE_PARSE;
	public static int FIRST_UPDATE;
	public static int DELAY_UPDATE;
	
	public static int EXCELLENT_SHIELD_BLOCK_CHANCE;
	public static int EXCELLENT_SHIELD_BLOCK_RECEIVED_DAMAGE;

	/** For test servers - evrybody has admin rights */
	public static boolean EVERYBODY_HAS_ADMIN_RIGHTS;

	public static double ALT_RAID_RESPAWN_MULTIPLIER;

	public static int DEFAULT_RAID_MINIONS_RESPAWN_DELAY;

	@VelocityVariable
	public static boolean ALLOW_AUGMENTATION;
	public static boolean ALT_ALLOW_DROP_AUGMENTED;

	public static boolean ALT_GAME_UNREGISTER_RECIPE;

	/** Delay for announce SS period (in minutes) */
	public static int SS_ANNOUNCE_PERIOD;

	/** Petition manager */
	public static boolean PETITIONING_ALLOWED;
	public static int MAX_PETITIONS_PER_PLAYER;
	public static int MAX_PETITIONS_PENDING;

	/** Show mob stats/droplist to players? */
	public static boolean ALT_GAME_SHOW_DROPLIST;
	public static boolean ALLOW_NPC_SHIFTCLICK;
	public static boolean SHOW_TARGET_PLAYER_INVENTORY_ON_SHIFT_CLICK;
	public static boolean ALLOW_VOICED_COMMANDS;
	public static boolean ALLOW_AUTOHEAL_COMMANDS;

	public static int[] ALT_DISABLED_MULTISELL;
	public static int[] ALT_SHOP_PRICE_LIMITS;
	public static int[] ALT_SHOP_UNALLOWED_ITEMS;

	public static int[] ALT_ALLOWED_PET_POTIONS;

	public static double MIN_ABNORMAL_SUCCESS_RATE;
	public static double MAX_ABNORMAL_SUCCESS_RATE;
	public static boolean ALT_SAVE_UNSAVEABLE;
	public static int ALT_SAVE_EFFECTS_REMAINING_TIME;
	public static boolean ALT_SHOW_REUSE_MSG;
	public static boolean ALT_DELETE_SA_BUFFS;
	public static int SKILLS_CAST_TIME_MIN;

	/** Титул при создании чара */
	public static boolean CHAR_TITLE;
	public static String ADD_CHAR_TITLE;

	/** Таймаут на использование social action */
	public static boolean ALT_SOCIAL_ACTION_REUSE;

	/** Отключение книг для изучения скилов */
	public static Set<AcquireType> DISABLED_SPELLBOOKS_FOR_ACQUIRE_TYPES;

	/** Alternative gameing - loss of XP on death */
	public static boolean ALT_GAME_DELEVEL;
	public static boolean ALLOW_DELEVEL_COMMAND;

	/** Разрешать ли на арене бои за опыт */
	public static boolean ALT_ARENA_EXP;

	public static int ALT_MAX_LEVEL;
	public static boolean ALT_NO_LASTHIT;
	public static boolean ALT_KAMALOKA_NIGHTMARES_PREMIUM_ONLY;
	public static boolean ALT_PET_HEAL_BATTLE_ONLY;

	public static int ALT_BUFF_LIMIT;

	public static int MULTISELL_SIZE;

	public static boolean SERVICES_CHANGE_NICK_ENABLED;
	public static int SERVICES_CHANGE_NICK_PRICE;
	public static int SERVICES_CHANGE_NICK_ITEM;
	public static boolean ALLOW_CHANGE_PASSWORD_COMMAND;
	public static boolean ALLOW_CHANGE_PHONE_NUMBER_COMMAND;
	public static boolean FORCIBLY_SPECIFY_PHONE_NUMBER;
	
	public static boolean SERVICES_CHANGE_CLAN_NAME_ENABLED;
	public static int SERVICES_CHANGE_CLAN_NAME_PRICE;
	public static int SERVICES_CHANGE_CLAN_NAME_ITEM;

	@VelocityVariable
	public static boolean SERVICES_CHANGE_PET_NAME_ENABLED;
	public static int SERVICES_CHANGE_PET_NAME_PRICE;
	public static int SERVICES_CHANGE_PET_NAME_ITEM;

	@VelocityVariable
	public static boolean SERVICES_EXCHANGE_BABY_PET_ENABLED;
	public static int SERVICES_EXCHANGE_BABY_PET_PRICE;
	public static int SERVICES_EXCHANGE_BABY_PET_ITEM;

	public static boolean SERVICES_CHANGE_SEX_ENABLED;
	public static int SERVICES_CHANGE_SEX_PRICE;
	public static int SERVICES_CHANGE_SEX_ITEM;

	public static boolean SERVICES_CHANGE_BASE_ENABLED;
	public static int SERVICES_CHANGE_BASE_PRICE;
	public static int SERVICES_CHANGE_BASE_ITEM;

	public static boolean SERVICES_SEPARATE_SUB_ENABLED;
	public static int SERVICES_SEPARATE_SUB_PRICE;
	public static int SERVICES_SEPARATE_SUB_ITEM;

	public static boolean SERVICES_CHANGE_NICK_COLOR_ENABLED;
	public static int SERVICES_CHANGE_NICK_COLOR_PRICE;
	public static int SERVICES_CHANGE_NICK_COLOR_ITEM;
	public static String[] SERVICES_CHANGE_NICK_COLOR_LIST;

	@VelocityVariable
	public static boolean SERVICES_BASH_ENABLED;
	public static boolean SERVICES_BASH_SKIP_DOWNLOAD;
	public static int SERVICES_BASH_RELOAD_TIME;

	public static boolean SERVICES_NOBLESS_SELL_ENABLED;
	public static int SERVICES_NOBLESS_SELL_PRICE;
	public static int SERVICES_NOBLESS_SELL_ITEM;

	public static boolean SERVICES_EXPAND_INVENTORY_ENABLED;
	public static int SERVICES_EXPAND_INVENTORY_PRICE;
	public static int SERVICES_EXPAND_INVENTORY_ITEM;
	public static int SERVICES_EXPAND_INVENTORY_MAX;

	public static boolean SERVICES_EXPAND_WAREHOUSE_ENABLED;
	public static int SERVICES_EXPAND_WAREHOUSE_PRICE;
	public static int SERVICES_EXPAND_WAREHOUSE_ITEM;

	public static boolean SERVICES_EXPAND_CWH_ENABLED;
	public static int SERVICES_EXPAND_CWH_PRICE;
	public static int SERVICES_EXPAND_CWH_ITEM;
	
	public static boolean OFFLIKE_MASTERY_SYSTEM;

	public static boolean SERVICES_OFFLINE_TRADE_ALLOW;
	public static int SERVICES_OFFLINE_TRADE_ALLOW_ZONE;
	public static int SERVICES_OFFLINE_TRADE_MIN_LEVEL;
	public static int SERVICES_OFFLINE_TRADE_NAME_COLOR;
	public static AbnormalEffect SERVICES_OFFLINE_TRADE_ABNORMAL_EFFECT;
	public static int SERVICES_OFFLINE_TRADE_PRICE;
	public static int SERVICES_OFFLINE_TRADE_PRICE_ITEM;
	public static int SERVICES_OFFLINE_TRADE_SECONDS_TO_KICK;
	public static boolean SERVICES_OFFLINE_TRADE_RESTORE_AFTER_RESTART;
	@VelocityVariable
	public static boolean SERVICES_GIRAN_HARBOR_ENABLED;
	@VelocityVariable
	public static boolean SERVICES_PARNASSUS_ENABLED;
	public static boolean SERVICES_PARNASSUS_NOTAX;
	@VelocityVariable
	public static long SERVICES_PARNASSUS_PRICE;

	@VelocityVariable
	public static boolean SERVICES_RIDE_HIRE_ENABLED;

	public static boolean SERVICES_ALLOW_LOTTERY;
	public static int SERVICES_LOTTERY_PRIZE;
	public static int SERVICES_ALT_LOTTERY_PRICE;
	public static int SERVICES_LOTTERY_TICKET_PRICE;
	public static double SERVICES_LOTTERY_5_NUMBER_RATE;
	public static double SERVICES_LOTTERY_4_NUMBER_RATE;
	public static double SERVICES_LOTTERY_3_NUMBER_RATE;
	public static int SERVICES_LOTTERY_2_AND_1_NUMBER_PRIZE;

	@VelocityVariable
	public static boolean SERVICES_ALLOW_ROULETTE;
	public static long SERVICES_ROULETTE_MIN_BET;
	public static long SERVICES_ROULETTE_MAX_BET;

	public static boolean ALT_ALLOW_OTHERS_WITHDRAW_FROM_CLAN_WAREHOUSE;
	public static boolean ALT_ALLOW_CLAN_COMMAND_ONLY_FOR_CLAN_LEADER;

	public static boolean ALLOW_IP_LOCK;
	public static boolean AUTO_LOCK_IP_ON_LOGIN;
	public static boolean ALLOW_HWID_LOCK;
	public static boolean AUTO_LOCK_HWID_ON_LOGIN;
	public static int HWID_LOCK_MASK;	
	/** Olympiad Compitition Starting time */
	public static int ALT_OLY_START_TIME;
	/** Olympiad Compition Min */
	public static int ALT_OLY_MIN;
	/** Olympaid Comptetition Period */
	public static long ALT_OLY_CPERIOD;
	/** Olympaid Weekly Period */
	public static long ALT_OLY_WPERIOD;
	/** Olympaid Validation Period */
	public static long ALT_OLY_VPERIOD;
	public static boolean CLASSED_GAMES_ENABLED;
	public static long OLYMPIAD_REGISTRATION_DELAY;

	public static boolean ENABLE_OLYMPIAD;
	public static boolean ENABLE_OLYMPIAD_SPECTATING;
	public static SchedulingPattern OLYMIAD_END_PERIOD_TIME;
	public static SchedulingPattern OLYMPIAD_START_TIME;

	public static int CLASS_GAME_MIN;
	public static int NONCLASS_GAME_MIN;


	public static int GAME_MAX_LIMIT;
	public static int GAME_CLASSES_COUNT_LIMIT;
	public static int GAME_NOCLASSES_COUNT_LIMIT;

	public static int ALT_OLY_REG_DISPLAY;
	public static int ALT_OLY_BATTLE_REWARD_ITEM;
	public static int OLYMPIAD_CLASSED_WINNER_REWARD_COUNT;
	public static int OLYMPIAD_NONCLASSED_WINNER_REWARD_COUNT;
	public static int OLYMPIAD_CLASSED_LOOSER_REWARD_COUNT;
	public static int OLYMPIAD_NONCLASSED_LOOSER_REWARD_COUNT;
	public static int ALT_OLY_COMP_RITEM;
	public static int ALT_OLY_GP_PER_POINT;
	public static int ALT_OLY_HERO_POINTS;
	public static int ALT_OLY_RANK1_POINTS;
	public static int ALT_OLY_RANK2_POINTS;
	public static int ALT_OLY_RANK3_POINTS;
	public static int ALT_OLY_RANK4_POINTS;
	public static int ALT_OLY_RANK5_POINTS;
	public static int OLYMPIAD_ALL_LOOSE_POINTS_BONUS;
	public static int OLYMPIAD_1_OR_MORE_WIN_POINTS_BONUS;
	public static int OLYMPIAD_STADIAS_COUNT;
	public static int OLYMPIAD_BATTLES_FOR_REWARD;
	public static int OLYMPIAD_POINTS_DEFAULT;
	public static int OLYMPIAD_POINTS_WEEKLY;
	public static boolean OLYMPIAD_OLDSTYLE_STAT;
	public static boolean OLYMPIAD_CANATTACK_BUFFER;
	public static int OLYMPIAD_BEGINIG_DELAY;

	public static long NONOWNER_ITEM_PICKUP_DELAY;

	/** Logging Chat Window */
	public static boolean LOG_CHAT;
	public static boolean TURN_LOG_SYSTEM;

	public static Map<Integer, PlayerAccess> gmlist = new HashMap<Integer, PlayerAccess>();

	/** Rate control */
	public static double[] RATE_XP_BY_LVL;
	public static double[] RATE_SP_BY_LVL;
	public static int MAX_DROP_ITEMS_FROM_ONE_GROUP;
	public static double[] RATE_DROP_ADENA_BY_LVL;
	public static double[] RATE_DROP_ITEMS_BY_LVL;
	public static double DROP_CHANCE_MODIFIER;
	public static double DROP_COUNT_MODIFIER;
	public static double[] RATE_DROP_SPOIL_BY_LVL;
	public static double SPOIL_CHANCE_MODIFIER;
	public static double SPOIL_COUNT_MODIFIER;
	public static double RATE_QUESTS_REWARD;
	public static boolean RATE_QUEST_REWARD_EXP_SP_ADENA_ONLY;
	public static double QUESTS_REWARD_LIMIT_MODIFIER;

	public static boolean EX_USE_QUEST_REWARD_PENALTY_PER;
	public static int EX_F2P_QUEST_REWARD_PENALTY_PER;
	public static TIntSet EX_F2P_QUEST_REWARD_PENALTY_QUESTS;

	public static double RATE_QUESTS_DROP;
	public static double RATE_CLAN_REP_SCORE;
	public static int RATE_CLAN_REP_SCORE_MAX_AFFECTED;
	public static double RATE_DROP_COMMON_ITEMS;
	public static double RATE_XP_RAIDBOSS_MODIFIER;
	public static double RATE_SP_RAIDBOSS_MODIFIER;
	public static double RATE_DROP_ITEMS_RAIDBOSS;
	public static double DROP_CHANCE_MODIFIER_RAIDBOSS;
	public static double DROP_COUNT_MODIFIER_RAIDBOSS;
	public static double RATE_DROP_ITEMS_BOSS;
	public static double DROP_CHANCE_MODIFIER_BOSS;
	public static double DROP_COUNT_MODIFIER_BOSS;
	public static TIntSet DISABLE_DROP_EXCEPT_ITEM_IDS;
	public static int[] NO_RATE_ITEMS;
	public static int[] DISABLE_DROP_SPOIL_ITEM_IDS_IMPERIA;
	public static boolean NO_RATE_EQUIPMENT;
	public static boolean NO_RATE_KEY_MATERIAL;
	public static boolean NO_RATE_RECIPES;
	public static double RATE_DROP_SIEGE_GUARD;
	public static double RATE_DROP_ENERGY_SEED;
	public static double RATE_MANOR;
	public static int RATE_FISH_DROP_COUNT;
	public static int PA_RATE_IN_PARTY_MODE;

	public static double RATE_MOB_SPAWN;
	public static int RATE_MOB_SPAWN_MIN_LEVEL;
	public static int RATE_MOB_SPAWN_MAX_LEVEL;

	/** Player Drop Rate control */
	public static boolean KARMA_DROP_GM;
	public static boolean KARMA_NEEDED_TO_DROP;
	
	public static int RATE_KARMA_LOST_STATIC;

	public static int KARMA_DROP_ITEM_LIMIT;

	public static int KARMA_RANDOM_DROP_LOCATION_LIMIT;

	public static double KARMA_DROPCHANCE_BASE;
	public static double KARMA_DROPCHANCE_MOD;
	public static double NORMAL_DROPCHANCE_BASE;
	public static int DROPCHANCE_EQUIPMENT;
	public static int DROPCHANCE_EQUIPPED_WEAPON;
	public static int DROPCHANCE_ITEM;

	public static int AUTODESTROY_ITEM_AFTER;
	public static int AUTODESTROY_PLAYER_ITEM_AFTER;

	public static int CHARACTER_DELETE_AFTER_HOURS;

	public static int PURGE_BYPASS_TASK_FREQUENCY;

	/** Datapack root directory */
	public static File DATAPACK_ROOT;
	public static boolean LOAD_DATAPACK_SCRIPTS;
	public static File GEODATA_ROOT;

	public static double BUFFTIME_MODIFIER;
	public static int[] BUFFTIME_MODIFIER_SKILLS;
	public static double CLANHALL_BUFFTIME_MODIFIER;
	public static double SONGDANCETIME_MODIFIER;

	public static double MAXLOAD_MODIFIER;
	public static double GATEKEEPER_MODIFIER;
	public static boolean ALT_IMPROVED_PETS_LIMITED_USE;
	@VelocityVariable
	public static int GATEKEEPER_FREE;
	public static int CRUMA_GATEKEEPER_LVL;

	//Champions
	public static double ALT_CHAMPION_CHANCE;
	public static int ALT_CHAMPION_DIFF_LVL;
	public static boolean ALT_CHAMPION_CAN_BE_AGGRO;
	public static boolean ALT_CHAMPION_CAN_BE_SOCIAL;
	public static int ALT_CHAMPION_MIN_LEVEL;
	public static int ALT_CHAMPION_TOP_LEVEL;
	public static long ALT_CHAMPION_DESPAWN;
	public static int SPECIAL_ITEM_ID;
	public static long SPECIAL_ITEM_COUNT;
	public static double SPECIAL_ITEM_DROP_CHANCE;

	public static double ALT_UP_MONSTER_CHANCE;
	public static int ALT_UP_MONSTER_DIFF_LVL;
	public static boolean ALT_UP_MONSTER_CAN_BE_AGGRO;
	public static boolean ALT_UP_MONSTER_CAN_BE_SOCIAL;
	public static int ALT_UP_MONSTER_MIN_LEVEL;
	public static int ALT_UP_MONSTER_TOP_LEVEL;
	public static long ALT_UP_MONSTER_DESPAWN;

	public static boolean ALLOW_DISCARDITEM;
	public static boolean ALLOW_MAIL;
	public static boolean ALLOW_WAREHOUSE;
	public static boolean ALLOW_WATER;
	public static boolean ALLOW_CURSED_WEAPONS;
	public static boolean DROP_CURSED_WEAPONS_ON_KICK;
	public static boolean DROP_CURSED_WEAPONS_ON_LOGOUT;
	public static boolean ALLOW_NOBLE_TP_TO_ALL;
	public static boolean ALLOW_ITEMS_REFUND;

	/** Pets */
	public static int SWIMING_SPEED;

	/** protocol revision */
	public static TIntSet AVAILABLE_PROTOCOL_REVISIONS;

	/** random animation interval */
	public static int MIN_NPC_ANIMATION;
	public static int MAX_NPC_ANIMATION;

	public static boolean USE_CLIENT_LANG;
	public static boolean CAN_SELECT_LANGUAGE;
	public static Language DEFAULT_LANG;

	/** Время запланированного на определенное время суток рестарта */
	public static String RESTART_AT_TIME;

	/** Титул Нпц */
	public static boolean SERVER_SIDE_NPC_NAME;
	public static boolean SERVER_SIDE_NPC_TITLE;
	public static boolean SERVER_SIDE_NPC_TITLE_LVL_AGR;
	public static int[] NO_TITLE_LVL_FOR_NPC;

	public static boolean RETAIL_MULTISELL_ENCHANT_TRANSFER;

	public static int REQUEST_ID;
	public static String EXTERNAL_HOSTNAME;
	public static int PORT_GAME;

	// Security
	public static boolean EX_SECOND_AUTH_ENABLED;
	public static int EX_SECOND_AUTH_MAX_ATTEMPTS;
	public static int EX_SECOND_AUTH_BAN_TIME;

	public static boolean EX_USE_AUTO_SOUL_SHOT;
	public static boolean ALLOW_CLASSIC_AUTO_SHOTS;
	public static int SOULSHOT_ID;
	public static int SPIRIT_SHOT_ID;
	public static int BLESS_SPIRIT_SHOT_ID;

	public static boolean EX_USE_PRIME_SHOP;

	public static boolean ALT_EASY_RECIPES;

	public static boolean ALT_USE_TRANSFORM_IN_EPIC_ZONE;

	public static boolean ALT_ANNONCE_RAID_BOSSES_REVIVAL;

	public static boolean SPAWN_VITAMIN_MANAGER;

	public static boolean ALLOW_EVENT_GATEKEEPER;

	/** Inventory slots limits */
	public static int INVENTORY_MAXIMUM_NO_DWARF;
	public static int INVENTORY_MAXIMUM_DWARF;
	public static int INVENTORY_MAXIMUM_GM;
	public static int QUEST_INVENTORY_MAXIMUM;

	/** Warehouse slots limits */
	public static int WAREHOUSE_SLOTS_NO_DWARF;
	public static int WAREHOUSE_SLOTS_DWARF;
	public static int WAREHOUSE_SLOTS_CLAN;

	public static int FREIGHT_SLOTS;

	/** Spoil Rates */
	public static double BASE_SPOIL_RATE;
	public static double MINIMUM_SPOIL_RATE;
	public static boolean SHOW_HTML_WELCOME;

	/** Manor Config */
	public static double MANOR_SOWING_BASIC_SUCCESS;
	public static double MANOR_SOWING_ALT_BASIC_SUCCESS;
	public static double MANOR_HARVESTING_BASIC_SUCCESS;
	public static int MANOR_DIFF_PLAYER_TARGET;
	public static double MANOR_DIFF_PLAYER_TARGET_PENALTY;
	public static int MANOR_DIFF_SEED_TARGET;
	public static double MANOR_DIFF_SEED_TARGET_PENALTY;

	/** Karma System Variables */
	public static int KARMA_MIN_KARMA;
	public static int KARMA_RATE_KARMA_LOST;
	public static int KARMA_LOST_BASE;
	public static int KARMA_PENALTY_START_KARMA;
	public static int KARMA_PENALTY_DURATION_DEFAULT;
	public static double KARMA_PENALTY_DURATION_INCREASE;
	public static int KARMA_DOWN_TIME_MULTIPLE;
	public static int KARMA_CRIMINAL_DURATION_MULTIPLE;

	public static int SET_PURE_KARMA;

	public static int MIN_PK_TO_ITEMS_DROP;
	public static boolean DROP_ITEMS_ON_DIE;
	public static boolean DROP_ITEMS_AUGMENTED;

	public static List<Integer> KARMA_LIST_NONDROPPABLE_ITEMS = new ArrayList<Integer>();
	public static Map<String, List<RewardData>> GLOBAL_DROP = new HashMap<>();

	public static boolean DROP_IMPROVED_ITEMS;
	public static Map<String, List<RewardData>> IMPROVED_DROP_1 = new HashMap<>();
	public static Map<String, List<RewardData>> IMPROVED_DROP_2 = new HashMap<>();
	public static Map<String, List<RewardData>> IMPROVED_DROP_3 = new HashMap<>();
	public static Map<String, List<RewardData>> IMPROVED_DROP_4 = new HashMap<>();
	public static Map<String, List<RewardData>> IMPROVED_DROP_5 = new HashMap<>();

	public static boolean DROP_IMPROVED_CHAMPION_ITEMS;
	public static Map<String, List<RewardData>> IMPROVED_DROP_CHAMPION_1 = new HashMap<>();
	public static Map<String, List<RewardData>> IMPROVED_DROP_CHAMPION_2 = new HashMap<>();
	public static Map<String, List<RewardData>> IMPROVED_DROP_CHAMPION_3 = new HashMap<>();
	public static Map<String, List<RewardData>> IMPROVED_DROP_CHAMPION_4 = new HashMap<>();
	public static Map<String, List<RewardData>> IMPROVED_DROP_CHAMPION_5 = new HashMap<>();


	public static boolean ALT_ENABLE_ADDITIONAL_DROP;
	public static List<RewardData> ADDITIONAL_DROP_1 = new ArrayList<>();
	public static List<Integer> ADDITIONAL_DROP_1_NPC_ID = new ArrayList<>();
	public static List<RewardData> ADDITIONAL_DROP_2 = new ArrayList<>();
	public static List<Integer> ADDITIONAL_DROP_2_NPC_ID = new ArrayList<>();
	public static List<RewardData> ADDITIONAL_DROP_3 = new ArrayList<>();
	public static List<Integer> ADDITIONAL_DROP_3_NPC_ID = new ArrayList<>();
	public static List<RewardData> ADDITIONAL_DROP_4 = new ArrayList<>();
	public static List<Integer> ADDITIONAL_DROP_4_NPC_ID = new ArrayList<>();
	public static List<RewardData> ADDITIONAL_DROP_5 = new ArrayList<>();
	public static List<Integer> ADDITIONAL_DROP_5_NPC_ID = new ArrayList<>();
	public static List<RewardData> ADDITIONAL_DROP_6 = new ArrayList<>();
	public static List<Integer> ADDITIONAL_DROP_6_NPC_ID = new ArrayList<>();
	public static List<RewardData> ADDITIONAL_DROP_7 = new ArrayList<>();
	public static List<Integer> ADDITIONAL_DROP_7_NPC_ID = new ArrayList<>();
	public static List<RewardData> ADDITIONAL_DROP_8 = new ArrayList<>();
	public static List<Integer> ADDITIONAL_DROP_8_NPC_ID = new ArrayList<>();
	public static List<RewardData> ADDITIONAL_DROP_9 = new ArrayList<>();
	public static List<Integer> ADDITIONAL_DROP_9_NPC_ID = new ArrayList<>();
	public static List<RewardData> ADDITIONAL_DROP_10 = new ArrayList<>();
	public static List<Integer> ADDITIONAL_DROP_10_NPC_ID = new ArrayList<>();
	public static List<RewardData> ADDITIONAL_DROP_11 = new ArrayList<>();
	public static List<Integer> ADDITIONAL_DROP_11_NPC_ID = new ArrayList<>();
	public static List<RewardData> ADDITIONAL_DROP_12 = new ArrayList<>();
	public static List<Integer> ADDITIONAL_DROP_12_NPC_ID = new ArrayList<>();
	public static List<RewardData> ADDITIONAL_DROP_13 = new ArrayList<>();
	public static List<Integer> ADDITIONAL_DROP_13_NPC_ID = new ArrayList<>();
	public static List<RewardData> ADDITIONAL_DROP_14 = new ArrayList<>();
	public static List<Integer> ADDITIONAL_DROP_14_NPC_ID = new ArrayList<>();
	public static List<RewardData> ADDITIONAL_DROP_15 = new ArrayList<>();
	public static List<Integer> ADDITIONAL_DROP_15_NPC_ID = new ArrayList<>();
	public static List<RewardData> ADDITIONAL_DROP_16 = new ArrayList<>();
	public static List<Integer> ADDITIONAL_DROP_16_NPC_ID = new ArrayList<>();


	public static List<Integer> LIST_OF_SELLABLE_ITEMS = new ArrayList<Integer>();
	public static List<Integer> LIST_OF_TRABLE_ITEMS = new ArrayList<Integer>();
	
	public static int PVP_TIME;

	public static Map<Integer, Double> BOSS_STATIC_DAMAGE_RECEIVED = new HashMap<>();
	
	/** Karma Punishment */
	public static boolean ALT_GAME_KARMA_PLAYER_CAN_SHOP;

	public static boolean REGEN_SIT_WAIT;

	public static double RATE_RAID_REGEN;
	public static double RATE_RAID_DEFENSE;
	public static double RATE_RAID_ATTACK;
	public static double RATE_EPIC_DEFENSE;
	public static double RATE_EPIC_ATTACK;
	public static int RAID_MAX_LEVEL_DIFF;
	public static boolean PARALIZE_ON_RAID_DIFF;

	public static int STARTING_LVL;
	public static long STARTING_SP;

	public static boolean ALLOW_ERTHEIA_CHAR_CREATION;
	public static boolean ALLOW_DEATH_KNIGHT_CHAR_CREATION;

	/** Deep Blue Mobs' Drop Rules Enabled */
	public static boolean DEEPBLUE_DROP_RULES;
	public static int DEEPBLUE_DROP_MAXDIFF;
	public static int DEEPBLUE_DROP_RAID_MAXDIFF;
	public static boolean UNSTUCK_SKILL;

	/** telnet enabled */
	public static boolean IS_TELNET_ENABLED;
	public static String TELNET_DEFAULT_ENCODING;
	public static String TELNET_PASSWORD;
	public static String TELNET_HOSTNAME;
	public static int TELNET_PORT;

	/** Percent CP is restore on respawn */
	public static double RESPAWN_RESTORE_CP;
	/** Percent HP is restore on respawn */
	public static double RESPAWN_RESTORE_HP;
	/** Percent MP is restore on respawn */
	public static double RESPAWN_RESTORE_MP;

	/** Maximum number of available slots for pvt stores (sell/buy) - Dwarves */
	public static int MAX_PVTSTORE_SLOTS_DWARF;
	/** Maximum number of available slots for pvt stores (sell/buy) - Others */
	public static int MAX_PVTSTORE_SLOTS_OTHER;
	public static int MAX_PVTCRAFT_SLOTS;

	public static boolean SENDSTATUS_TRADE_JUST_OFFLINE;
	public static double SENDSTATUS_TRADE_MOD;

	public static boolean ALLOW_CH_DOOR_OPEN_ON_CLICK;
	public static boolean ALT_CH_SIMPLE_DIALOG;
	public static boolean ALT_CH_UNLIM_MP;
	public static boolean ALT_NO_FAME_FOR_DEAD;

	public static int CH_BID_GRADE1_MINCLANLEVEL;
	public static int CH_BID_GRADE1_MINCLANMEMBERS;
	public static int CH_BID_GRADE1_MINCLANMEMBERSLEVEL;
	public static int CH_BID_GRADE2_MINCLANLEVEL;
	public static int CH_BID_GRADE2_MINCLANMEMBERS;
	public static int CH_BID_GRADE2_MINCLANMEMBERSLEVEL;
	public static int CH_BID_GRADE3_MINCLANLEVEL;
	public static int CH_BID_GRADE3_MINCLANMEMBERS;
	public static int CH_BID_GRADE3_MINCLANMEMBERSLEVEL;
	public static double RESIDENCE_LEASE_FUNC_MULTIPLIER;
	public static double RESIDENCE_LEASE_MULTIPLIER;

	public static boolean ANNOUNCE_MAMMON_SPAWN;

	public static int GM_NAME_COLOUR;
	public static boolean GM_HERO_AURA;
	public static int NORMAL_NAME_COLOUR;
	public static int CLANLEADER_NAME_COLOUR;

	/** AI */
	public static int AI_TASK_MANAGER_COUNT;
	public static long AI_TASK_ATTACK_DELAY;
	public static long AI_TASK_ACTIVE_DELAY;
	public static boolean BLOCK_ACTIVE_TASKS;
	public static boolean ALWAYS_TELEPORT_HOME;
	public static boolean ALWAYS_TELEPORT_HOME_RB;
	public static boolean RND_WALK;
	public static int RND_WALK_RATE;
	public static int RND_ANIMATION_RATE;
	public static boolean ALT_M_DMG_RANDOMISE;
	public static boolean ALT_AUTO_ATTACK_DMG_RANDOMISE;
	public static boolean ALT_P_DMG_RANDOMISE;

	public static int AGGRO_CHECK_INTERVAL;
	public static long NONAGGRO_TIME_ONTELEPORT;
	public static long NONPVP_TIME_ONTELEPORT;

	public static boolean AGGRO_IF_PLAYER_IS_ONLINE;
	public static int AGGRO_TIME_IF_PLAYER_IN_ONLINE;

	/** Maximum range mobs can randomly go from spawn point */
	public static int MAX_DRIFT_RANGE;

	/** Maximum range mobs can pursue agressor from spawn point */
	public static int MAX_PURSUE_RANGE;
	public static int MAX_PURSUE_UNDERGROUND_RANGE;
	public static int MAX_PURSUE_RANGE_RAID;

	public static boolean ALLOW_DEATH_PENALTY;
	public static int ALT_DEATH_PENALTY_CHANCE;
	public static int ALT_DEATH_PENALTY_EXPERIENCE_PENALTY;
	public static int ALT_DEATH_PENALTY_KARMA_PENALTY;

	public static boolean HIDE_GM_STATUS;
	public static boolean SHOW_GM_LOGIN;
	public static boolean SAVE_GM_EFFECTS; //Silence, gmspeed, etc...

	public static boolean AUTO_LEARN_SKILLS;
	public static boolean AUTO_LEARN_AWAKED_SKILLS;
	public static boolean ENABLE_PACKET_LOG;

	public static int MOVE_PACKET_DELAY;
	public static int ATTACK_PACKET_DELAY;

	public static boolean DAMAGE_FROM_FALLING;

	/** Community Board */
	public static boolean BBS_ENABLED;
	public static String BBS_DEFAULT_PAGE;
	public static String BBS_HOME_DIR;
	public static String BBS_COPYRIGHT;
	public static boolean BBS_WAREHOUSE_ENABLED;
	public static boolean BBS_SELL_ITEMS_ENABLED;
	public static boolean BBS_AUGMENTATION_ENABLED;

	/** Wedding Options */
	public static boolean ALLOW_WEDDING;
	public static int WEDDING_PRICE;
	public static boolean WEDDING_PUNISH_INFIDELITY;
	public static boolean WEDDING_TELEPORT;
	public static int WEDDING_TELEPORT_PRICE;
	public static int WEDDING_TELEPORT_INTERVAL;
	public static boolean WEDDING_SAMESEX;
	public static boolean WEDDING_FORMALWEAR;
	public static int WEDDING_DIVORCE_COSTS;

	public static int FOLLOW_RANGE;
	
	public static boolean ALT_ITEM_AUCTION_ENABLED;
	public static boolean ALT_CUSTOM_ITEM_AUCTION_ENABLED;
	public static boolean ALT_ITEM_AUCTION_CAN_REBID;
	public static boolean ALT_ITEM_AUCTION_START_ANNOUNCE;
	public static long ALT_ITEM_AUCTION_MAX_BID;
	public static int ALT_ITEM_AUCTION_MAX_CANCEL_TIME_IN_MILLIS;

	public static boolean ALT_ENABLE_BLOCK_CHECKER_EVENT;
	public static int ALT_MIN_BLOCK_CHECKER_TEAM_MEMBERS;
	public static double ALT_RATE_COINS_REWARD_BLOCK_CHECKER;
	public static boolean ALT_HBCE_FAIR_PLAY;
	public static int ALT_PET_INVENTORY_LIMIT;

	/**limits of stats **/
	public static int LIM_PATK;
	public static int LIM_MATK;
	public static int LIM_PDEF;
	public static int LIM_MDEF;
	public static int LIM_MATK_SPD;
	public static int LIM_PATK_SPD;
	public static int LIM_CRIT_DAM;
	public static int LIM_CRIT;
	public static int LIM_MCRIT;
	public static int LIM_ACCURACY;
	public static int LIM_EVASION;
	public static int LIM_MOVE;
	public static int LIM_FAME;
	public static int LIM_RAID_POINTS;
	public static int HP_LIMIT;
	public static int MP_LIMIT;
	public static int CP_LIMIT;
	public static int LIM_CRAFT_POINTS;

	public static double PLAYER_P_ATK_MODIFIER;
	public static double PLAYER_M_ATK_MODIFIER;

	public static double ALT_NPC_PATK_MODIFIER;
	public static double ALT_NPC_MATK_MODIFIER;
	public static double ALT_NPC_MAXHP_MODIFIER;
	public static double ALT_NPC_MAXMP_MODIFIER;

	public static int FESTIVAL_MIN_PARTY_SIZE;
	public static double FESTIVAL_RATE_PRICE;

	/** Dimensional Rift Config **/
	public static int RIFT_MIN_PARTY_SIZE;
	public static int RIFT_SPAWN_DELAY; // Time in ms the party has to wait until the mobs spawn
	public static int RIFT_MAX_JUMPS;
	public static int RIFT_AUTO_JUMPS_TIME;
	public static int RIFT_AUTO_JUMPS_TIME_RAND;
	public static int RIFT_ENTER_COST_RECRUIT;
	public static int RIFT_ENTER_COST_SOLDIER;
	public static int RIFT_ENTER_COST_OFFICER;
	public static int RIFT_ENTER_COST_CAPTAIN;
	public static int RIFT_ENTER_COST_COMMANDER;
	public static int RIFT_ENTER_COST_HERO;

	public static boolean ALLOW_TALK_WHILE_SITTING;

	public static int MAXIMUM_MEMBERS_IN_PARTY;
	public static boolean PARTY_LEADER_ONLY_CAN_INVITE;

	/** Разрешены ли клановые скилы? **/
	public static boolean ALLOW_CLANSKILLS;

	/** Разрешено ли изучение скилов трансформации и саб классов без наличия выполненного квеста */
	public static boolean ALLOW_LEARN_TRANS_SKILLS_WO_QUEST;

	/** Allow Manor system */
	public static boolean ALLOW_MANOR;

	/** Manor Refresh Starting time */
	public static int MANOR_REFRESH_TIME;

	/** Manor Refresh Min */
	public static int MANOR_REFRESH_MIN;

	/** Manor Next Period Approve Starting time */
	public static int MANOR_APPROVE_TIME;

	/** Manor Next Period Approve Min */
	public static int MANOR_APPROVE_MIN;

	/** Manor Maintenance Time */
	public static int MANOR_MAINTENANCE_PERIOD;

	public static double EVENT_CofferOfShadowsPriceRate;
	public static double EVENT_CofferOfShadowsRewardRate;

	/** Master Yogi event enchant config */
	public static int ENCHANT_CHANCE_MASTER_YOGI_STAFF;
	public static int ENCHANT_MAX_MASTER_YOGI_STAFF;
	public static int SAFE_ENCHANT_MASTER_YOGI_STAFF;
	
	public static boolean DISABLE_PARTY_ON_EVENT;

	/*public static int EVENT_CtfTime;
	public static boolean EVENT_CtFrate;
	public static String[] EVENT_CtFStartTime;
	public static boolean EVENT_CtFCategories;
	public static int EVENT_CtFMaxPlayerInTeam;
	public static int EVENT_CtFMinPlayerInTeam;
	public static boolean EVENT_CtFAllowSummons;
	public static boolean EVENT_CtFAllowBuffs;
	public static boolean EVENT_CtFAllowMultiReg;
	public static String EVENT_CtFCheckWindowMethod;
	public static String[] EVENT_CtFFighterBuffs;
	public static String[] EVENT_CtFMageBuffs;
	public static boolean EVENT_CtFBuffPlayers;
	public static String[] EVENT_CtFRewards;*/
	public static boolean ALLOW_PLAYER_INVIS_TAKE_FLAG_CTF;

	// BM Festival event
	// BM Festival
	public static boolean BM_FESTIVAL_ENABLE;
	public static boolean BM_FESTIVAL_DEBUG;
	public static String BM_FESTIVAL_TIME_START;
	public static String BM_FESTIVAL_TIME_END;
	public static int BM_FESTIVAL_TYPE;
	public static boolean BM_FESTIVAL_REMOVE_SINGLE_ITEM;
	public static int BM_FESTIVAL_ITEM_TO_PLAY;
	public static int BM_FESTIVAL_PLAY_LIMIT;
	public static int BM_FESTIVAL_ITEM_TO_PLAY_COUNT;
	public static int BM_FESTIVAL_REWARD_INTERVAL;
	public static int BM_FESTIVAL_UPDATE_INTERVAL;

	public static double BALROG_WAR_POINT_REWARD_MOD;

	//gvg

	public static boolean ENABLE_BALOK_RANDOM_BOSS_SKIP;

	//reflect configs
	public static int REFLECT_MIN_RANGE;
	public static double REFLECT_AND_BLOCK_DAMAGE_CHANCE_CAP;
	public static double REFLECT_AND_BLOCK_PSKILL_DAMAGE_CHANCE_CAP;
	public static double REFLECT_AND_BLOCK_MSKILL_DAMAGE_CHANCE_CAP;
	public static double REFLECT_DAMAGE_PERCENT_CAP;
	public static double REFLECT_BOW_DAMAGE_PERCENT_CAP;
	public static double REFLECT_PSKILL_DAMAGE_PERCENT_CAP;
	public static double REFLECT_MSKILL_DAMAGE_PERCENT_CAP;
	
	public static int GvG_POINTS_FOR_BOX;
	public static int GvG_POINTS_FOR_BOSS;
	public static int GvG_POINTS_FOR_KILL;
	public static int GvG_POINTS_FOR_DEATH;
	public static int GvG_EVENT_TIME;
	public static long GvG_BOSS_SPAWN_TIME;
	public static int GvG_FAME_REWARD;
	public static int GvG_REWARD;
	public static long GvG_REWARD_COUNT;
	public static int GvG_ADD_IF_WITHDRAW;
	public static int GvG_HOUR_START;
	public static int GvG_MINUTE_START;
	public static int GVG_MIN_LEVEL;
	public static int GVG_MAX_LEVEL;
	public static int GVG_MAX_GROUPS;
	public static int GVG_MIN_PARTY_MEMBERS;
	public static long GVG_TIME_TO_REGISTER;

	public static double EVENT_GLITTMEDAL_NORMAL_CHANCE;
	public static double EVENT_GLITTMEDAL_GLIT_CHANCE;
	public static double EVENT_L2DAY_LETTER_CHANCE;
	public static double EVENT_CHANGE_OF_HEART_CHANCE;

	public static double EVENT_TRICK_OF_TRANS_CHANCE;

	public static double EVENT_MARCH8_DROP_CHANCE;
	public static double EVENT_MARCH8_PRICE_RATE;

	public static boolean EVENT_BOUNTY_HUNTERS_ENABLED;

	public static long EVENT_SAVING_SNOWMAN_LOTERY_PRICE;
	public static int EVENT_SAVING_SNOWMAN_REWARDER_CHANCE;

	public static boolean SERVICES_NO_TRADE_ONLY_OFFLINE;
	public static double SERVICES_TRADE_TAX;
	public static double SERVICES_OFFSHORE_TRADE_TAX;
	public static boolean SERVICES_OFFSHORE_NO_CASTLE_TAX;
	public static boolean SERVICES_TRADE_TAX_ONLY_OFFLINE;
	public static boolean SERVICES_TRADE_ONLY_FAR;
	public static int SERVICES_TRADE_RADIUS;
	public static int SERVICES_TRADE_MIN_LEVEL;

	public static boolean SERVICES_ENABLE_NO_CARRIER;
	public static int SERVICES_NO_CARRIER_DEFAULT_TIME;
	public static int SERVICES_NO_CARRIER_MAX_TIME;
	public static int SERVICES_NO_CARRIER_MIN_TIME;

	public static boolean ALT_SHOW_SERVER_TIME;

	/** Geodata config */
	public static int GEO_X_FIRST, GEO_Y_FIRST, GEO_X_LAST, GEO_Y_LAST;
	public static boolean ALLOW_GEODATA;
	public static boolean ALLOW_FALL_FROM_WALLS;
	public static boolean ALLOW_KEYBOARD_MOVE;
	public static boolean COMPACT_GEO;
	public static int MAX_Z_DIFF;
	public static int MIN_LAYER_HEIGHT;
	public static int REGION_EDGE_MAX_Z_DIFF;

	/** Geodata (Pathfind) config */
	public static int PATHFIND_BOOST;
	public static int PATHFIND_MAP_MUL;
	public static boolean PATHFIND_DIAGONAL;
	public static boolean PATH_CLEAN;
	public static int PATHFIND_MAX_Z_DIFF;
	public static long PATHFIND_MAX_TIME;
	public static String PATHFIND_BUFFERS;
	public static int NPC_PATH_FIND_MAX_HEIGHT;
	public static int PLAYABLE_PATH_FIND_MAX_HEIGHT;

	public static boolean DEBUG;
	public static boolean DEBUG_TARGET;

	public static int WEAR_DELAY;
	public static boolean ALLOW_FAKE_PLAYERS;
	public static int FAKE_PLAYERS_PERCENT;

	public static boolean DISABLE_CRYSTALIZATION_ITEMS;
	
	public static int[] SERVICES_ENCHANT_VALUE;
	public static int[] SERVICES_ENCHANT_COAST;
	public static int[] SERVICES_ENCHANT_RAID_VALUE;
	public static int[] SERVICES_ENCHANT_RAID_COAST;

	public static boolean GOODS_INVENTORY_ENABLED = false;
	public static boolean EX_NEW_PETITION_SYSTEM;
	public static boolean EX_JAPAN_MINIGAME;
	public static boolean EX_LECTURE_MARK;

	public static boolean AUTH_SERVER_GM_ONLY;
	public static boolean AUTH_SERVER_BRACKETS;
	public static boolean AUTH_SERVER_IS_PVP;
	public static int AUTH_SERVER_AGE_LIMIT;
	public static int AUTH_SERVER_SERVER_TYPE;

	/** Custom properties **/
	public static boolean ONLINE_GENERATOR_ENABLED;
	public static int ONLINE_GENERATOR_DELAY;

	public static boolean ALLOW_MONSTER_RACE;
	public static boolean ONLY_ONE_SIEGE_PER_CLAN;
	public static double SPECIAL_CLASS_BOW_CROSS_BOW_PENALTY;
	public static boolean NEED_QUEST_FOR_PROOF;

	public static boolean ALLOW_USE_DOORMANS_IN_SIEGE_BY_OWNERS;
	
	public static boolean DISABLE_VAMPIRIC_VS_MOB_ON_PVP;

	public static boolean NPC_RANDOM_ENCHANT;
	
	public static boolean ENABLE_PARTY_SEARCH;
	public static boolean MENTOR_ENABLE;
	public static boolean MENTOR_ONLY_PA;

	//pvp manager
	public static boolean ALLOW_PVP_REWARD;
	public static boolean PVP_REWARD_SEND_SUCC_NOTIF;
	public static int[] PVP_REWARD_REWARD_IDS;
	public static long[] PVP_REWARD_COUNTS;
	public static boolean PVP_REWARD_RANDOM_ONE;	
	public static int PVP_REWARD_DELAY_ONE_KILL;
	public static int PVP_REWARD_MIN_PL_PROFF;
	public static int PVP_REWARD_MIN_PL_UPTIME_MINUTE;
	public static int PVP_REWARD_MIN_PL_LEVEL;
	public static boolean PVP_REWARD_PK_GIVE;
	public static boolean PVP_REWARD_ON_EVENT_GIVE;
	public static boolean PVP_REWARD_ONLY_BATTLE_ZONE;
	public static boolean PVP_REWARD_ONLY_NOBLE_GIVE;
	public static boolean PVP_REWARD_SAME_PARTY_GIVE;
	public static boolean PVP_REWARD_SAME_CLAN_GIVE;
	public static boolean PVP_REWARD_SAME_ALLY_GIVE;
	public static boolean PVP_REWARD_SAME_HWID_GIVE;
	public static boolean PVP_REWARD_SAME_IP_GIVE;
	public static boolean PVP_REWARD_SPECIAL_ANTI_TWINK_TIMER;
	public static int PVP_REWARD_HR_NEW_CHAR_BEFORE_GET_ITEM;
	public static boolean PVP_REWARD_CHECK_EQUIP;
	public static int PVP_REWARD_WEAPON_GRADE_TO_CHECK;
	public static boolean PVP_REWARD_LOG_KILLS;
	public static boolean DISALLOW_MSG_TO_PL;

	public static int ALL_CHAT_USE_MIN_LEVEL;
	public static int ALL_CHAT_USE_MIN_LEVEL_WITHOUT_PA;
	public static int ALL_CHAT_USE_DELAY;
	public static int SHOUT_CHAT_USE_MIN_LEVEL;
	public static int SHOUT_CHAT_USE_MIN_LEVEL_WITHOUT_PA;
	public static int SHOUT_CHAT_USE_DELAY;
	public static int WORLD_CHAT_USE_MIN_LEVEL;
	public static int WORLD_CHAT_USE_MIN_LEVEL_WITHOUT_PA;
	public static int WORLD_CHAT_USE_DELAY;
	public static int TRADE_CHAT_USE_MIN_LEVEL;
	public static int TRADE_CHAT_USE_MIN_LEVEL_WITHOUT_PA;
	public static int TRADE_CHAT_USE_DELAY;
	public static int HERO_CHAT_USE_MIN_LEVEL;
	public static int HERO_CHAT_USE_MIN_LEVEL_WITHOUT_PA;
	public static int HERO_CHAT_USE_DELAY;
	public static int PRIVATE_CHAT_USE_MIN_LEVEL;
	public static int PRIVATE_CHAT_USE_MIN_LEVEL_WITHOUT_PA;
	public static int PRIVATE_CHAT_USE_DELAY;
	public static int MAIL_USE_MIN_LEVEL;
	public static int MAIL_USE_MIN_LEVEL_WITHOUT_PA;
	public static int MAIL_USE_DELAY;
	
	public static int IM_PAYMENT_ITEM_ID;
	public static int IM_MAX_ITEMS_IN_RECENT_LIST;
	
	public static boolean ALT_SHOW_MONSTERS_LVL;
	public static boolean ALT_SHOW_MONSTERS_AGRESSION;	

	public static int BEAUTY_SHOP_COIN_ITEM_ID;

	public static boolean ALT_TELEPORT_TO_TOWN_DURING_SIEGE;

	public static int ALT_CLAN_LEAVE_PENALTY_TIME;
	public static int ALT_CLAN_CREATE_PENALTY_TIME;

	public static int ALT_EXPELLED_MEMBER_PENALTY_TIME;
	public static int ALT_LEAVED_ALLY_PENALTY_TIME;
	public static int ALT_DISSOLVED_ALLY_PENALTY_TIME;

	public static boolean DROP_GLOBAL_ITEMS;
	public static int MIN_RAID_LEVEL_TO_DROP;

	public static int NPC_DIALOG_PLAYER_DELAY;

	public static double PHYSICAL_MIN_CHANCE_TO_HIT;
	public static double PHYSICAL_MAX_CHANCE_TO_HIT;

	public static double MAGIC_MIN_CHANCE_TO_HIT;
	public static double MAGIC_MAX_CHANCE_TO_HIT;

	public static boolean ENABLE_CRIT_DMG_REDUCTION_ON_MAGIC;

	public static double MAX_BLOW_RATE_ON_BEHIND;
	public static double MAX_BLOW_RATE_ON_FRONT_AND_SIDE;

	public static double BLOW_SKILL_CHANCE_MOD_ON_BEHIND;
	public static double BLOW_SKILL_CHANCE_MOD_ON_FRONT;

	public static double BLOW_SKILL_DEX_CHANCE_MOD;
	public static double NORMAL_SKILL_DEX_CHANCE_MOD;
	
	public static double CRIT_STUN_BREAK_CHANCE;
	
	public static boolean ENABLE_STUN_BREAK_ON_ATTACK;
	public static double CRIT_STUN_BREAK_CHANCE_ON_MAGICAL_SKILL;
	public static double NORMAL_STUN_BREAK_CHANCE_ON_MAGICAL_SKILL;
	public static double CRIT_STUN_BREAK_CHANCE_ON_PHYSICAL_SKILL;
	public static double NORMAL_STUN_BREAK_CHANCE_ON_PHYSICAL_SKILL;
	public static double CRIT_STUN_BREAK_CHANCE_ON_REGULAR_HIT;
	public static double NORMAL_STUN_BREAK_CHANCE_ON_REGULAR_HIT;

	public static double LUC_BONUS_MODIFIER;
	
	public static double NORMAL_STUN_BREAK_CHANCE;

	public static String CLAN_DELETE_TIME;
	public static String CLAN_CHANGE_LEADER_TIME;
	public static int CLAN_MAX_LEVEL;
	public static int[] CLAN_LVL_UP_RP_COST;

	public static int ALT_MUSIC_LIMIT;
	public static int ALT_DEBUFF_LIMIT;
	public static int ALT_TRIGGER_LIMIT;
	
	// Buffer Scheme NPC
	public static boolean NpcBuffer_VIP;
	public static int NpcBuffer_VIP_ALV;
	public static boolean NpcBuffer_EnableBuff;
	public static boolean NpcBuffer_EnableScheme;
	public static boolean NpcBuffer_EnableHeal;
	public static boolean NpcBuffer_EnableBuffs;
	public static boolean NpcBuffer_EnableResist;
	public static boolean NpcBuffer_EnableSong;
	public static boolean NpcBuffer_EnableDance;
	public static boolean NpcBuffer_EnableChant;
	public static boolean NpcBuffer_EnableOther;
	public static boolean NpcBuffer_EnableSpecial;
	public static boolean NpcBuffer_EnableCubic;
	public static boolean NpcBuffer_EnableCancel;
	public static boolean NpcBuffer_EnableBuffSet;
	public static boolean NpcBuffer_EnableBuffPK;
	public static boolean NpcBuffer_EnableFreeBuffs;
	public static boolean NpcBuffer_EnableTimeOut;
	public static int NpcBuffer_TimeOutTime;
	public static int NpcBuffer_MinLevel;
	public static int NpcBuffer_PriceCancel;
	public static int NpcBuffer_PriceHeal;
	public static int NpcBuffer_PriceBuffs;
	public static int NpcBuffer_PriceResist;
	public static int NpcBuffer_PriceSong;
	public static int NpcBuffer_PriceDance;
	public static int NpcBuffer_PriceChant;
	public static int NpcBuffer_PriceOther;
	public static int NpcBuffer_PriceSpecial;
	public static int NpcBuffer_PriceCubic;
	public static int NpcBuffer_PriceSet;
	public static int NpcBuffer_PriceScheme;
	public static int NpcBuffer_MaxScheme;
	public static boolean SCHEME_ALLOW_FLAG;
	public static boolean IS_DISABLED_IN_REFLECTION;

	public static int ALT_DELEVEL_ON_DEATH_PENALTY_MIN_LEVEL;

	public static boolean ALT_PETS_NOT_STARVING;

	public static Set<Language> AVAILABLE_LANGUAGES;

	public static int MAX_ACTIVE_ACCOUNTS_ON_ONE_IP;
	public static String[] MAX_ACTIVE_ACCOUNTS_IGNORED_IP;
	public static int MAX_ACTIVE_ACCOUNTS_ON_ONE_HWID;

	public static boolean SHOW_TARGET_PLAYER_BUFF_EFFECTS;
	public static boolean SHOW_TARGET_PLAYER_DEBUFF_EFFECTS;
	public static boolean SHOW_TARGET_NPC_BUFF_EFFECTS;
	public static boolean SHOW_TARGET_NPC_DEBUFF_EFFECTS;

	public static int MIN_DIFF_LEVELS_FOR_EXP_SP_PENALTY;

	public static double ALCHEMY_MIX_CUBE_MODIFIER;

	public static int CANCEL_SKILLS_HIGH_CHANCE_CAP;
	public static int CANCEL_SKILLS_LOW_CHANCE_CAP;

	public static long SP_LIMIT;

	public static int ELEMENT_ATTACK_LIMIT;
	public static int ELEMENT_DEFENCE_LIMIT;

	public static boolean ALLOW_AWAY_STATUS;
	public static boolean AWAY_ONLY_FOR_PREMIUM;
	public static int AWAY_TIMER;
	public static int BACK_TIMER;
	public static int AWAY_TITLE_COLOR;
	public static boolean AWAY_PLAYER_TAKE_AGGRO;
	public static boolean AWAY_PEACE_ZONE;

	public static double[] PERCENT_LOST_ON_DEATH;
	public static double PERCENT_LOST_ON_DEATH_MOD_IN_PEACE_ZONE;
	public static double PERCENT_LOST_ON_DEATH_MOD_IN_PVP;
	public static double PERCENT_LOST_ON_DEATH_MOD_IN_WAR;
	public static double PERCENT_LOST_ON_DEATH_MOD_FOR_PK;

	public static boolean ALLOW_LUCKY_GAME_EVENT;
	public static int LUCKY_GAME_UNIQUE_REWARD_GAMES_COUNT;

	public static boolean FISHING_ENABLED;
	public static boolean FISHING_ONLY_PREMIUM_ACCOUNTS;
	public static int FISHING_MINIMUM_LEVEL;

	public static int FAKE_PLAYERS_COUNT;
	public static int FAKE_PLAYERS_SPAWN_TASK_DELAY;
	public static boolean SHOW_PRINT; //DM

	public static boolean BOTREPORT_ENABLED;
	public static int BOTREPORT_REPORT_DELAY;
	public static String BOTREPORT_REPORTS_RESET_TIME;
	public static boolean BOTREPORT_ALLOW_REPORTS_FROM_SAME_CLAN_MEMBERS;

	public static boolean VIP_ATTENDANCE_REWARDS_ENABLED;
	public static boolean VIP_ATTENDANCE_REWARDS_REWARD_BY_ACCOUNT = true;

	public static boolean ALT_SAVE_PRIVATE_STORE;

	public static boolean APPEARANCE_STONE_CHECK_ARMOR_TYPE = true;

	public static boolean MULTICLASS_SYSTEM_ENABLED;
	public static boolean MULTICLASS_SYSTEM_SHOW_LEARN_LIST_ON_OPEN_SKILL_LIST;
	public static double MULTICLASS_SYSTEM_NON_CLASS_SP_MODIFIER;
	public static double MULTICLASS_SYSTEM_1ST_CLASS_SP_MODIFIER;
	public static double MULTICLASS_SYSTEM_2ND_CLASS_SP_MODIFIER;
	public static double MULTICLASS_SYSTEM_3RD_CLASS_SP_MODIFIER;
	public static double MULTICLASS_SYSTEM_4TH_CLASS_SP_MODIFIER;
	public static int MULTICLASS_SYSTEM_NON_CLASS_COST_ITEM_ID_BASED_ON_SP;
	public static int MULTICLASS_SYSTEM_1ST_CLASS_COST_ITEM_ID_BASED_ON_SP;
	public static int MULTICLASS_SYSTEM_2ND_CLASS_COST_ITEM_ID_BASED_ON_SP;
	public static int MULTICLASS_SYSTEM_3RD_CLASS_COST_ITEM_ID_BASED_ON_SP;
	public static int MULTICLASS_SYSTEM_4TH_CLASS_COST_ITEM_ID_BASED_ON_SP;
	public static double MULTICLASS_SYSTEM_NON_CLASS_COST_ITEM_COUNT_MODIFIER_BASED_ON_SP;
	public static double MULTICLASS_SYSTEM_1ST_CLASS_COST_ITEM_COUNT_MODIFIER_BASED_ON_SP;
	public static double MULTICLASS_SYSTEM_2ND_CLASS_COST_ITEM_COUNT_MODIFIER_BASED_ON_SP;
	public static double MULTICLASS_SYSTEM_3RD_CLASS_COST_ITEM_COUNT_MODIFIER_BASED_ON_SP;
	public static double MULTICLASS_SYSTEM_4TH_CLASS_COST_ITEM_COUNT_MODIFIER_BASED_ON_SP;
	public static int MULTICLASS_SYSTEM_NON_CLASS_COST_ITEM_ID;
	public static int MULTICLASS_SYSTEM_1ST_CLASS_COST_ITEM_ID;
	public static int MULTICLASS_SYSTEM_2ND_CLASS_COST_ITEM_ID;
	public static int MULTICLASS_SYSTEM_3RD_CLASS_COST_ITEM_ID;
	public static int MULTICLASS_SYSTEM_4TH_CLASS_COST_ITEM_ID;
	public static long MULTICLASS_SYSTEM_NON_CLASS_COST_ITEM_COUNT;
	public static long MULTICLASS_SYSTEM_1ST_CLASS_COST_ITEM_COUNT;
	public static long MULTICLASS_SYSTEM_2ND_CLASS_COST_ITEM_COUNT;
	public static long MULTICLASS_SYSTEM_3RD_CLASS_COST_ITEM_COUNT;
	public static long MULTICLASS_SYSTEM_4TH_CLASS_COST_ITEM_COUNT;

	public static int BATTLE_ZONE_AROUND_RAID_BOSSES_RANGE;

	public static boolean BUFF_STORE_ENABLED;
	public static boolean BUFF_STORE_MP_ENABLED;
	public static double BUFF_STORE_MP_CONSUME_MULTIPLIER;
	public static boolean BUFF_STORE_ITEM_CONSUME_ENABLED;
	public static int BUFF_STORE_NAME_COLOR;
	public static int BUFF_STORE_TITLE_COLOR;
	public static int BUFF_STORE_OFFLINE_NAME_COLOR;
	public static TIntSet BUFF_STORE_ALLOWED_CLASS_LIST = new TIntHashSet();
	public static TIntSet BUFF_STORE_ALLOWED_SKILL_LIST = new TIntHashSet();
	public static long BUFF_STORE_MIN_PRICE;
	public static long BUFF_STORE_MAX_PRICE;

	public static boolean TRAINING_CAMP_ENABLE;
	public static boolean TRAINING_CAMP_PREMIUM_ONLY;
	public static int TRAINING_CAMP_MAX_DURATION;
	public static int TRAINING_CAMP_MIN_LEVEL;
	public static int TRAINING_CAMP_MAX_LEVEL;

	public static String[] ALLOWED_TRADE_ZONES;

	public static boolean USE_CUSTOM_ATTACK_TRAITS;
	public static boolean USE_CUSTOM_DEFENCE_TRAITS;
	public static double ATTACK_TRAIT_WEAPON_MOD;
	public static double DEFENCE_TRAIT_WEAPON_MOD;
	public static double ATTACK_TRAIT_POISON_MOD;
	public static double DEFENCE_TRAIT_POISON_MOD;
	public static double ATTACK_TRAIT_HOLD_MOD;
	public static double DEFENCE_TRAIT_HOLD_MOD;
	public static double ATTACK_TRAIT_BLEED_MOD;
	public static double DEFENCE_TRAIT_BLEED_MOD;
	public static double ATTACK_TRAIT_SLEEP_MOD;
	public static double DEFENCE_TRAIT_SLEEP_MOD;
	public static double ATTACK_TRAIT_SHOCK_MOD;
	public static double DEFENCE_TRAIT_SHOCK_MOD;
	public static double ATTACK_TRAIT_DERANGEMENT_MOD;
	public static double DEFENCE_TRAIT_DERANGEMENT_MOD;
	public static double ATTACK_TRAIT_PARALYZE_MOD;
	public static double DEFENCE_TRAIT_PARALYZE_MOD;
	public static double ATTACK_TRAIT_BOSS_MOD;
	public static double DEFENCE_TRAIT_BOSS_MOD;
	public static double ATTACK_TRAIT_DEATH_MOD;
	public static double DEFENCE_TRAIT_DEATH_MOD;
	public static double ATTACK_TRAIT_ROOT_PHYSICALLY_MOD;
	public static double DEFENCE_TRAIT_ROOT_PHYSICALLY_MOD;
	public static double ATTACK_TRAIT_TURN_STONE_MOD;
	public static double DEFENCE_TRAIT_TURN_STONE_MOD;
	public static double ATTACK_TRAIT_GUST_MOD;
	public static double DEFENCE_TRAIT_GUST_MOD;
	public static double ATTACK_TRAIT_PHYSICAL_BLOCKADE_MOD;
	public static double DEFENCE_TRAIT_PHYSICAL_BLOCKADE_MOD;
	public static double ATTACK_TRAIT_TARGET_MOD;
	public static double DEFENCE_TRAIT_TARGET_MOD;
	public static double ATTACK_TRAIT_PHYSICAL_WEAKNESS_MOD;
	public static double DEFENCE_TRAIT_PHYSICAL_WEAKNESS_MOD;
	public static double ATTACK_TRAIT_MAGICAL_WEAKNESS_MOD;
	public static double DEFENCE_TRAIT_MAGICAL_WEAKNESS_MOD;
	public static double ATTACK_TRAIT_KNOCKBACK_MOD;
	public static double DEFENCE_TRAIT_KNOCKBACK_MOD;
	public static double ATTACK_TRAIT_KNOCKDOWN_MOD;
	public static double DEFENCE_TRAIT_KNOCKDOWN_MOD;
	public static double ATTACK_TRAIT_PULL_MOD;
	public static double DEFENCE_TRAIT_PULL_MOD;
	public static double ATTACK_TRAIT_HATE_MOD;
	public static double DEFENCE_TRAIT_HATE_MOD;
	public static double ATTACK_TRAIT_AGGRESSION_MOD;
	public static double DEFENCE_TRAIT_AGGRESSION_MOD;
	public static double ATTACK_TRAIT_AIRBIND_MOD;
	public static double DEFENCE_TRAIT_AIRBIND_MOD;
	public static double ATTACK_TRAIT_DISARM_MOD;
	public static double DEFENCE_TRAIT_DISARM_MOD;
	public static double ATTACK_TRAIT_DEPORT_MOD;
	public static double DEFENCE_TRAIT_DEPORT_MOD;
	public static double ATTACK_TRAIT_CHANGEBODY_MOD;
	public static double DEFENCE_TRAIT_CHANGEBODY_MOD;

	public static int SKILLER_SKILL_ID;
	public static int[] SKILLER_WHITELISTED_SKILLS;
	public static int HEALER_SKILL_ID;

	public static int CHECK_BANS_INTERVAL;

	public static boolean ADDITIONAL_MONSTER_BOW_DEFENCE_TRAIT_MOD_ENABLED;
	public static double ADDITIONAL_MONSTER_BOW_DEFENCE_TRAIT_ADD;

	public static double ONLINE_PLAYER_COUNT_MULTIPLIER;

	public static double STAT_INT_MODIFIER;
	public static double STAT_STR_MODIFIER;
	public static double STAT_CON_MODIFIER;
	public static double STAT_DEX_MODIFIER;
	public static double STAT_WIT_MODIFIER;
	public static double STAT_MEN_MODIFIER;
//	public static double STAT_LUC_MODIFIER;
//	public static double STAT_CHA_MODIFIER;

	public static boolean HOMUNCULUS_INFO_ENABLE;
	public static boolean MAGIC_LAMP_ENABLED;
	public static boolean HERO_BOOK_INFO_ENABLE;
	public static boolean COSTUME_SERIVCE_ENABLE;

	/* Zone: Lair of Antharas */
	public static int BKARIK_D_M_CHANCE;
	/* Zone: Dragon Valley */
	public static int NECROMANCER_MS_CHANCE;
	public static double DWARRIOR_MS_CHANCE;
	public static double DHUNTER_MS_CHANCE;
	public static int BDRAKE_MS_CHANCE;
	public static int EDRAKE_MS_CHANCE;

	public static String MONSTER_LVL_GROUPS;
	public static String RAID_LVL_GROUPS;

	public static int MAX_RESETS_PER_INSTANCE;

	public static boolean REBIRTHS_TO_TAKE_DAMAGE_ENABLE;

	public static double[] MONSTER_XP_RATE_MODIFIER;
	public static double[] MONSTER_HP_MODIFIER;
	public static double[] MONSTER_PDEF_MODIFIER;
	public static double[] MONSTER_MDEF_MODIFIER;
	public static double[] MONSTER_ATTACK_MODIFIER;
	public static double[] MONSTER_MATTACK_MODIFIER;
	public static double[] MONSTER_ATKSPD_MODIFIER;
	public static double[] MONSTER_CASTSPD_MODIFIER;
	public static double[] MONSTER_SPD_MODIFIER;

	public static double PLAYER_P_HP_MODIFIER;
	public static double PLAYER_P_PVP_PDEF_MODIFIER;
	public static double PLAYER_P_PVP_MDEF_MODIFIER;
	public static double PLAYER_P_PVP_ATTACK_MODIFIER;
	public static double PLAYER_P_PVP_MATTACK_MODIFIER;

	public static double PLAYER_M_HP_MODIFIER;
	public static double PLAYER_M_PVP_PDEF_MODIFIER;
	public static double PLAYER_M_PVP_MDEF_MODIFIER;
	public static double PLAYER_M_PVP_ATTACK_MODIFIER;
	public static double PLAYER_M_PVP_MATTACK_MODIFIER;

	public static double[] RAID_XP_RATE_MODIFIER;
	public static double[] RAID_HP_MODIFIER;
	public static double[] RAID_PDEF_MODIFIER;
	public static double[] RAID_MDEF_MODIFIER;
	public static double[] RAID_ATTACK_MODIFIER;
	public static double[] RAID_MATTACK_MODIFIER;
	public static double[] RAID_ATKSPD_MODIFIER;
	public static double[] RAID_CASTSPD_MODIFIER;
	public static double[] RAID_SPD_MODIFIER;

	public static int[] AUTO_AGATHION_SUMMON_ITEM_IDS;
	public static int AUTO_AGATHION_SUMMON_AGATHION_ID;

	public static boolean M_SKILL_POWER_MUL_AS_ADD_MODE;
	public static boolean DROP_VIEW_USE_CLIENT_INTERFACE;
	public static boolean ENABLE_GUARANTEED_ITEM_ENCHANT;
	public static boolean SHOW_ITEM_ENCHANT_LIMITS;

	private static void  loadWorldExchange() {
		ExProperties worldExchangeSettings = load(WORLD_EXCHANGE);
		ENABLE_WORLD_EXCHANGE = worldExchangeSettings.getProperty("EnableWorldExchange", true);
		WORLD_EXCHANGE_DEFAULT_LANG = worldExchangeSettings.getProperty("WorldExchangeDefaultLanguage", "en");
		WORLD_EXCHANGE_SAVE_INTERVAL = worldExchangeSettings.getProperty("BidItemsIntervalStatusCheck", 30000);
		WORLD_EXCHANGE_LCOIN_TAX = worldExchangeSettings.getProperty("LCoinFee", 0.05);
		WORLD_EXCHANGE_MAX_LCOIN_TAX = worldExchangeSettings.getProperty("MaxLCoinFee", 20000);
		WORLD_EXCHANGE_ADENA_FEE = worldExchangeSettings.getProperty("AdenaFee", 100.0);
		WORLD_EXCHANGE_MAX_ADENA_FEE = worldExchangeSettings.getProperty("MaxAdenaFee", -1);
		WORLD_EXCHANGE_LAZY_UPDATE = worldExchangeSettings.getProperty("DBLazy", false);
		WORLD_EXCHANGE_ITEM_SELL_PERIOD = worldExchangeSettings.getProperty("ItemSellPeriod", 14);
		WORLD_EXCHANGE_ITEM_BACK_PERIOD = worldExchangeSettings.getProperty("ItemBackPeriod", 120);
		WORLD_EXCHANGE_PAYMENT_TAKE_PERIOD = worldExchangeSettings.getProperty("PaymentTakePeriod", 120);

	}

	public static void loadStatBonusConfig() {

		ExProperties statSettings = load(STATBONUS_FILE);
		MONSTER_LVL_GROUPS = statSettings.getProperty("MonsterLevelGroups", "1-10, 11-20, 21-30, 31-40, 41-50, 51-60, 61-70, 71-75, 76-77, 78-79, 80-80, 81-82, 83-85");
	 	RAID_LVL_GROUPS = statSettings.getProperty("RaidLevelGroups", "20-29, 30-39, 40-49, 50-59, 60-69, 70-75, 76-79, 80-84, 85-85");

		MONSTER_XP_RATE_MODIFIER = statSettings.getProperty("MonsterXpRateModifier", new double[] {1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0});
		MONSTER_HP_MODIFIER = statSettings.getProperty("MonsterHpModifier", new double[] {1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0});
		MONSTER_PDEF_MODIFIER = statSettings.getProperty("MonsterPDefModifier", new double[] {1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0});
		MONSTER_MDEF_MODIFIER = statSettings.getProperty("MonsterMDefModifier", new double[] {1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0});
		MONSTER_ATTACK_MODIFIER = statSettings.getProperty("MonsterPAtkModifier", new double[] {1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0});
		MONSTER_MATTACK_MODIFIER = statSettings.getProperty("MonsterMAtkModifier", new double[] {1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0});
		MONSTER_ATKSPD_MODIFIER = statSettings.getProperty("MonsterPAtkSpdModifier", new double[] {1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0});
		MONSTER_CASTSPD_MODIFIER = statSettings.getProperty("MonsterMAtkSpdModifier", new double[] {1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0});
		MONSTER_SPD_MODIFIER = statSettings.getProperty("MonsterSpdModifier", new double[] {1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0});

		RAID_XP_RATE_MODIFIER = statSettings.getProperty("RaidXpRateModifier", new double[] {1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0});

		RAID_HP_MODIFIER = statSettings.getProperty("RaidHpModifier", new double[] { 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0 });
		RAID_PDEF_MODIFIER = statSettings.getProperty("RaidPDefModifier", new double[] { 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0 });
		RAID_MDEF_MODIFIER = statSettings.getProperty("RaidMDefModifier", new double[] { 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0 });
		RAID_ATTACK_MODIFIER = statSettings.getProperty("RaidPAtkModifier", new double[] { 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0 });
		RAID_MATTACK_MODIFIER = statSettings.getProperty("RaidMAtkModifier", new double[] { 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0 });
		RAID_ATKSPD_MODIFIER = statSettings.getProperty("RaidPAtkSpdModifier", new double[] { 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0 });
		RAID_CASTSPD_MODIFIER = statSettings.getProperty("RaidMAtkSpdModifier", new double[] { 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0 });
		RAID_SPD_MODIFIER = statSettings.getProperty("RaidSpdModifier", new double[] { 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0 });

		PLAYER_P_HP_MODIFIER = statSettings.getProperty("PlayerPHpModifier", 1.0d);
		PLAYER_P_PVP_PDEF_MODIFIER = statSettings.getProperty("PlayerPPvPPDefModifier", 1.0d);
		PLAYER_P_PVP_MDEF_MODIFIER = statSettings.getProperty("PlayerPPvPMDefModifier", 1.0d);
		PLAYER_P_PVP_ATTACK_MODIFIER = statSettings.getProperty("PlayerPPvPPAktModifier", 1.0d);
		PLAYER_P_PVP_MATTACK_MODIFIER = statSettings.getProperty("PlayerPPvPMAtkModifier", 1.0d);

		PLAYER_M_HP_MODIFIER = statSettings.getProperty("PlayerMHpModifier", 1.0d);
		PLAYER_M_PVP_PDEF_MODIFIER = statSettings.getProperty("PlayerMPvPPDefModifier", 1.0d);
		PLAYER_M_PVP_MDEF_MODIFIER = statSettings.getProperty("PlayerMPvPMDefModifier", 1.0d);
		PLAYER_M_PVP_ATTACK_MODIFIER = statSettings.getProperty("PlayerMPvPPAktModifier", 1.0d);
		PLAYER_M_PVP_MATTACK_MODIFIER = statSettings.getProperty("PlayerMPvPMAtkModifier", 1.0d);
	}

	public static void loadMultiClassConfig() {
		ExProperties addSettings = load(MULTICLASS_CONFIG_FILE);
		ENABLE_MULTICLASS_SKILL_LEARN = addSettings.getProperty("EnableMulticlassSkillLearn", false);
		ENABLE_MULTICLASS_SKILL_LEARN_ITEM = addSettings.getProperty("EnableMulticlassSkillLearnItem", "4037:1");
		if (!addSettings.getProperty("EnableMulticlassSkillLearnBlacklist", "").isEmpty()) {
			ENABLE_MULTICLASS_SKILL_LEARN_BLACKLIST.clear();
			for (String string : addSettings.getProperty("EnableMulticlassSkillLearnBlacklist", "").split(",")) {
				ENABLE_MULTICLASS_SKILL_LEARN_BLACKLIST.add(Integer.parseInt(string));
			}
		}
		ENABLE_MULTICLASS_SKILL_LEARN_MAX = addSettings.getProperty("EnableMulticlassSkillLearnMax", 100);

		ENABLE_MULTICLASS_SKILL_REMOVE = addSettings.getProperty("EnableMulticlassSkillRemove", false);
		ENABLE_MULTICLASS_SKILL_CUSTOM = addSettings.getProperty("EnableMulticlassSkillCustom", false);
		ENABLE_MULTICLASS_SKILL_REMOVE_ITEM = addSettings.getProperty("EnableMulticlassSkillRemoveItem", "4037:1");
		ENABLE_MULTICLASS_SKILL_REMOVE_ITEM_S = addSettings.getProperty("EnableMulticlassSkillRemoveItemString", "1 CoL");
		if (!addSettings.getProperty("EnableMulticlassSkillRemoveBlacklist", "").isEmpty()) {
			ENABLE_MULTICLASS_SKILL_REMOVE_BLACKLIST.clear();
			for (String string : addSettings.getProperty("EnableMulticlassSkillRemoveBlacklist", "").split(",")) {
				ENABLE_MULTICLASS_SKILL_REMOVE_BLACKLIST.add(Integer.parseInt(string));
			}
		}
		ENABLE_MULTICLASS_SKILL_TRANSFER = addSettings.getProperty("EnableMulticlassSkillTransfer", false);
		ENABLE_MULTICLASS_SKILL_TRANSFER_REM_ITEM = addSettings.getProperty("MulticlassSkillRemTransferItem", "57:10000000");
		MULTICLASS_SKILL_LEVEL_MAX = addSettings.getProperty("SkillMaxLevel", false);
		MULTICLASS_SKILL_LEVEL_MAX_CUSTOM = addSettings.getProperty("SkillMaxLevelCustom", false);
		MULTICLASS_ALL_TREANER = addSettings.getProperty("AllTreaner", true);
		SKILL_LEARN_COST_SP = addSettings.getProperty("SkillLearnCostSp", 1);
		ALT_DISABLE_SPELLBOOKS = addSettings.getProperty("AltDisableSpellbooks", false);
		SAY_ITEM_ID = addSettings.getProperty("SayItemId", false);
	}

	public static void loadSkillLearnSetting() {
		ExProperties skill = load(SKILL_LEARN);
		SHOW_SKILL_PAGE = skill.getProperty("Page", 10);
		SKILL_LEARN_ITEM_ID = skill.getProperty("ItemId", 57);
		SKILL_LEARN_ITEM_COUNT = skill.getProperty("ItemCount", 1);
		SKILL_LEARNC_ITEM_COUNT = skill.getProperty("ItemCustomCount", 1);
		SKILL_DELETE_ITEM_ID = skill.getProperty("DeleteItemId", 57);
		SKILL_DELETE_ITEM_COUNT = skill.getProperty("DeleteItemCount", 1);
		SKILL_LEARN_CUSTOM_ITEM_ID = skill.getProperty("CustomItemId", 57);
		SKILL_LEARN_CUSTOM_ITEM_COUNT = skill.getProperty("CustomItemCount", 1);
		SKILL_LEARN_SKILL_ID = skill.getProperty("SkillId", new int[]{789});
		SKILL_LEARN_INDIVID_ITEM_ID = skill.getProperty("IndividItemId", 57);
		SKILL_LEARN_INDIVIDC_ITEM_ID = skill.getProperty("IndividCItemId", 57);
		SKILL_LEARN_INDIVID_ITEM_COUNT = skill.getProperty("IndividItemCount", 1);
		SKILL_LEARN_INDIVIDC_ITEM_COUNT = skill.getProperty("IndividCItemCount", 1);
		SKILL_LEARN_CUSTOM_SKILL_ID = skill.getProperty("CustomSkillId", new int[]{789});
		SKILL_LEARN_INDIVID_CUSTOM_ITEM_ID = skill.getProperty("IndividCustomItemId", 57);
		SKILL_LEARN_INDIVID_CUSTOM_ITEM_COUNT = skill.getProperty("IndividCustomItemCount", 1);
		SKILL_LEARN_SP_NORM = skill.getProperty("SpNormal", 1.0);
		SKILL_LEARN_SP_CUSTOM = skill.getProperty("SpCustom", 1.0);
		SKILL_LEARN_SP_CUSTOM1 = skill.getProperty("SpCustom1", 1.0);
	}

	public static void loadServerConfig()
	{
		ExProperties serverSettings = load(CONFIGURATION_FILE);

		SERVER_SIDE_NPC_NAME = serverSettings.getProperty("ServerSideNpcName", false);
		SERVER_SIDE_NPC_TITLE = serverSettings.getProperty("ServerSideNpcTitle", false);
		SERVER_SIDE_NPC_TITLE_LVL_AGR = serverSettings.getProperty("ServerSideNpcTitleLvlAgr", true);
		NO_TITLE_LVL_FOR_NPC = serverSettings.getProperty("NoTitleLvLForNPC", new int[]{100001, 100002});

		AUTH_SERVER_AGE_LIMIT = serverSettings.getProperty("ServerAgeLimit", 0);
		AUTH_SERVER_GM_ONLY = serverSettings.getProperty("ServerGMOnly", false);
		AUTH_SERVER_BRACKETS = serverSettings.getProperty("ServerBrackets", false);
		AUTH_SERVER_IS_PVP = serverSettings.getProperty("PvPServer", false);
		for(String a : serverSettings.getProperty("ServerType", ArrayUtils.EMPTY_STRING_ARRAY))
		{
			if(a.trim().isEmpty())
				continue;

			ServerType t = ServerType.valueOf(a.toUpperCase());
			AUTH_SERVER_SERVER_TYPE |= t.getMask();
		}

		EVERYBODY_HAS_ADMIN_RIGHTS = serverSettings.getProperty("EverybodyHasAdminRights", false);

		HIDE_GM_STATUS = serverSettings.getProperty("HideGMStatus", false);
		SHOW_GM_LOGIN = serverSettings.getProperty("ShowGMLogin", true);
		SAVE_GM_EFFECTS = serverSettings.getProperty("SaveGMEffects", false);

		CNAME_TEMPLATE = serverSettings.getProperty("CnameTemplate", "[A-Za-z0-9\u0410-\u042f\u0430-\u044f]{2,16}");
		CLAN_NAME_TEMPLATE = serverSettings.getProperty("ClanNameTemplate", "[A-Za-z0-9\u0410-\u042f\u0430-\u044f]{3,16}");
		CLAN_TITLE_TEMPLATE = serverSettings.getProperty("ClanTitleTemplate", "[A-Za-z0-9\u0410-\u042f\u0430-\u044f \\p{Punct}]{1,16}");
		ALLY_NAME_TEMPLATE = serverSettings.getProperty("AllyNameTemplate", "[A-Za-z0-9\u0410-\u042f\u0430-\u044f]{3,16}");

		MAX_CHARACTERS_NUMBER_PER_ACCOUNT = serverSettings.getProperty("MAX_CHARACTERS_NUMBER_PER_ACCOUNT", 7);
		CHECK_BANS_INTERVAL = serverSettings.getProperty("CHECK_BANS_INTERVAL", 5);

		GLOBAL_SHOUT = serverSettings.getProperty("GlobalShout", false);
		GLOBAL_TRADE_CHAT = serverSettings.getProperty("GlobalTradeChat", false);
		CHAT_RANGE = serverSettings.getProperty("ChatRange", 1250);
		SHOUT_SQUARE_OFFSET = serverSettings.getProperty("ShoutOffset", 0);
		SHOUT_SQUARE_OFFSET = SHOUT_SQUARE_OFFSET * SHOUT_SQUARE_OFFSET;

		ALLOW_WORLD_CHAT = serverSettings.getProperty("ALLOW_WORLD_CHAT", true);
		WORLD_CHAT_POINTS_PER_DAY = serverSettings.getProperty("WORLD_CHAT_POINTS_PER_DAY", 10);
		WORLD_CHAT_POINTS_PER_DAY_PA = serverSettings.getProperty("WORLD_CHAT_POINTS_PER_DAY_PA", 20);

		LOG_CHAT = serverSettings.getProperty("LogChat", false);
		TURN_LOG_SYSTEM = serverSettings.getProperty("GlobalLogging", true);

		double RATE_XP = serverSettings.getProperty("RateXp", 1.);
		RATE_XP_BY_LVL = new double[Short.MAX_VALUE];
		double prevRateXp = RATE_XP;
		for(int i = 1; i < RATE_XP_BY_LVL.length; i++)
		{
			double rate = serverSettings.getProperty("RateXpByLevel" + i, prevRateXp);
			RATE_XP_BY_LVL[i] = rate;
			if(rate != prevRateXp)
				prevRateXp = rate;
		}

		double RATE_SP = serverSettings.getProperty("RateSp", 1.);
		RATE_SP_BY_LVL = new double[Short.MAX_VALUE];
		double prevRateSp = RATE_SP;
		for(int i = 1; i < RATE_SP_BY_LVL.length; i++)
		{
			double rate = serverSettings.getProperty("RateSpByLevel" + i, prevRateSp);
			RATE_SP_BY_LVL[i] = rate;
			if(rate != prevRateSp)
				prevRateSp = rate;
		}

		MAX_DROP_ITEMS_FROM_ONE_GROUP = serverSettings.getProperty("MAX_DROP_ITEMS_FROM_ONE_GROUP", 1);

		double RATE_DROP_ADENA = serverSettings.getProperty("RateDropAdena", 1.);
		RATE_DROP_ADENA_BY_LVL = new double[Short.MAX_VALUE];
		double prevRateAdena = RATE_DROP_ADENA;
		for(int i = 1; i < RATE_DROP_ADENA_BY_LVL.length; i++)
		{
			double rate = serverSettings.getProperty("RateDropAdenaByLevel" + i, prevRateAdena);
			RATE_DROP_ADENA_BY_LVL[i] = rate;
			if(rate != prevRateAdena)
				prevRateAdena = rate;
		}

		double RATE_DROP_ITEMS = serverSettings.getProperty("RateDropItems", 1.);
		RATE_DROP_ITEMS_BY_LVL = new double[Short.MAX_VALUE];
		double prevRateItems = RATE_DROP_ITEMS;
		for(int i = 1; i < RATE_DROP_ITEMS_BY_LVL.length; i++)
		{
			double rate = serverSettings.getProperty("RateDropItemsByLevel" + i, prevRateItems);
			RATE_DROP_ITEMS_BY_LVL[i] = rate;
			if(rate != prevRateItems)
				prevRateItems = rate;
		}

		DROP_CHANCE_MODIFIER = serverSettings.getProperty("DROP_CHANCE_MODIFIER", 1.);
		DROP_COUNT_MODIFIER = serverSettings.getProperty("DROP_COUNT_MODIFIER", 1.);

		double RATE_DROP_SPOIL = serverSettings.getProperty("RateDropSpoil", 1.);
		RATE_DROP_SPOIL_BY_LVL = new double[Short.MAX_VALUE];
		double prevRateSpoil = RATE_DROP_SPOIL;
		for(int i = 1; i < RATE_DROP_SPOIL_BY_LVL.length; i++)
		{
			double rate = serverSettings.getProperty("RateDropSpoilByLevel" + i, prevRateSpoil);
			RATE_DROP_SPOIL_BY_LVL[i] = rate;
			if(rate != prevRateSpoil)
				prevRateSpoil = rate;
		}

		SPOIL_CHANCE_MODIFIER = serverSettings.getProperty("SPOIL_CHANCE_MODIFIER", 1.);
		SPOIL_COUNT_MODIFIER = serverSettings.getProperty("SPOIL_COUNT_MODIFIER", 1.);

		RATE_QUESTS_REWARD = serverSettings.getProperty("RateQuestsReward", 1.);
		RATE_QUEST_REWARD_EXP_SP_ADENA_ONLY = serverSettings.getProperty("RATE_QUEST_REWARD_EXP_SP_ADENA_ONLY", true);
		QUESTS_REWARD_LIMIT_MODIFIER = serverSettings.getProperty("QUESTS_REWARD_LIMIT_MODIFIER", RATE_QUESTS_REWARD);

		RATE_QUESTS_DROP = serverSettings.getProperty("RateQuestsDrop", 1.);
		RATE_CLAN_REP_SCORE = serverSettings.getProperty("RateClanRepScore", 1.);
		RATE_CLAN_REP_SCORE_MAX_AFFECTED = serverSettings.getProperty("RateClanRepScoreMaxAffected", 2);
		RATE_XP_RAIDBOSS_MODIFIER = serverSettings.getProperty("RATE_XP_RAIDBOSS_MODIFIER", 1.);
		RATE_SP_RAIDBOSS_MODIFIER = serverSettings.getProperty("RATE_SP_RAIDBOSS_MODIFIER", 1.);
		RATE_DROP_ITEMS_RAIDBOSS = serverSettings.getProperty("RATE_DROP_ITEMS_RAIDBOSS", 1.);
		DROP_CHANCE_MODIFIER_RAIDBOSS = serverSettings.getProperty("DROP_CHANCE_MODIFIER_RAIDBOSS", 1.);
		DROP_COUNT_MODIFIER_RAIDBOSS = serverSettings.getProperty("DROP_COUNT_MODIFIER_RAIDBOSS", 1.);
		RATE_DROP_ITEMS_BOSS = serverSettings.getProperty("RATE_DROP_ITEMS_BOSS", 1.);
		DROP_CHANCE_MODIFIER_BOSS = serverSettings.getProperty("DROP_CHANCE_MODIFIER_BOSS", 1.);
		DROP_COUNT_MODIFIER_BOSS = serverSettings.getProperty("DROP_COUNT_MODIFIER_BOSS", 1.);
		DISABLE_DROP_EXCEPT_ITEM_IDS = new TIntHashSet();
		DISABLE_DROP_EXCEPT_ITEM_IDS.addAll(serverSettings.getProperty("DISABLE_DROP_EXCEPT_ITEM_IDS", new int[0]));
		DISABLE_DROP_SPOIL_ITEM_IDS_IMPERIA = serverSettings.getProperty("DISABLE_DROP_SPOIL_ITEM_IDS_IMPERIA", new int[0]);
		NO_RATE_ITEMS = serverSettings.getProperty("NoRateItemIds", new int[] {
				6660,
				6662,
				6661,
				6659,
				6656,
				6658,
				8191,
				6657,
				10170,
				10314,
				16025,
				16026,
				9682,
				46409});
		NO_RATE_EQUIPMENT = serverSettings.getProperty("NoRateEquipment", false);
		NO_RATE_KEY_MATERIAL = serverSettings.getProperty("NoRateKeyMaterial", false);
		NO_RATE_RECIPES = serverSettings.getProperty("NoRateRecipes", false);
		RATE_DROP_SIEGE_GUARD = serverSettings.getProperty("RateSiegeGuard", 1.);
		RATE_DROP_ENERGY_SEED = serverSettings.getProperty("RateEnergySeed", 1.);
		RATE_MANOR = serverSettings.getProperty("RateManor", 1.);
		PA_RATE_IN_PARTY_MODE = serverSettings.getProperty("PA_RATE_IN_PARTY_MODE", 0);


		String[] ignoreAllDropButThis = serverSettings.getProperty("IgnoreAllDropButThis", "-1").split(";");
		for(String dropId : ignoreAllDropButThis)
		{
			if(dropId == null || dropId.isEmpty())
				continue;

			try
			{
				int itemId = Integer.parseInt(dropId);
				if(itemId > 0)
					DROP_ONLY_THIS.add(itemId);
			}
			catch(NumberFormatException e)
			{
				_log.error("", e);
			}
		}
		INCLUDE_RAID_DROP = serverSettings.getProperty("RemainRaidDropWithNoChanges", false);

		RATE_MOB_SPAWN = serverSettings.getProperty("RateMobSpawn", 1.);
		RATE_MOB_SPAWN_MIN_LEVEL = serverSettings.getProperty("RateMobMinLevel", 1);
		RATE_MOB_SPAWN_MAX_LEVEL = serverSettings.getProperty("RateMobMaxLevel", 100);

		RATE_RAID_REGEN = serverSettings.getProperty("RateRaidRegen", 1.);
		RATE_RAID_DEFENSE = serverSettings.getProperty("RateRaidDefense", 1.);
		RATE_RAID_ATTACK = serverSettings.getProperty("RateRaidAttack", 1.);
		RATE_EPIC_DEFENSE = serverSettings.getProperty("RateEpicDefense", RATE_RAID_DEFENSE);
		RATE_EPIC_ATTACK = serverSettings.getProperty("RateEpicAttack", RATE_RAID_ATTACK);
		RAID_MAX_LEVEL_DIFF = serverSettings.getProperty("RaidMaxLevelDiff", 8);
		PARALIZE_ON_RAID_DIFF = serverSettings.getProperty("ParalizeOnRaidLevelDiff", true);

		AUTODESTROY_ITEM_AFTER = serverSettings.getProperty("AutoDestroyDroppedItemAfter", 0);
		AUTODESTROY_PLAYER_ITEM_AFTER = serverSettings.getProperty("AutoDestroyPlayerDroppedItemAfter", 0);
		CHARACTER_DELETE_AFTER_HOURS = serverSettings.getProperty("DeleteCharAfterHours", 3);
		PURGE_BYPASS_TASK_FREQUENCY = serverSettings.getProperty("PurgeTaskFrequency", 60);
		LOAD_DATAPACK_SCRIPTS = serverSettings.getProperty("LoadDatapackScripts", false);

		try
		{
			DATAPACK_ROOT = new File(serverSettings.getProperty("DatapackRoot", ".")).getCanonicalFile();
		}
		catch(IOException e)
		{
			_log.error("", e);
		}

		ALLOW_DISCARDITEM = serverSettings.getProperty("AllowDiscardItem", true);
		ALLOW_MAIL = serverSettings.getProperty("AllowMail", true);
		ALLOW_WAREHOUSE = serverSettings.getProperty("AllowWarehouse", true);
		ALLOW_WATER = serverSettings.getProperty("AllowWater", true);
		ALLOW_ITEMS_REFUND = serverSettings.getProperty("ALLOW_ITEMS_REFUND", true);
		ALLOW_CURSED_WEAPONS = serverSettings.getProperty("ALLOW_CURSED_WEAPONS", true);
		DROP_CURSED_WEAPONS_ON_KICK = serverSettings.getProperty("DROP_CURSED_WEAPONS_ON_KICK", false);
		DROP_CURSED_WEAPONS_ON_LOGOUT = serverSettings.getProperty("DROP_CURSED_WEAPONS_ON_LOGOUT", false);

		AVAILABLE_PROTOCOL_REVISIONS = new TIntHashSet();
		AVAILABLE_PROTOCOL_REVISIONS.addAll(serverSettings.getProperty("AvailableProtocolRevisions", new int[]{306}));

		MIN_NPC_ANIMATION = serverSettings.getProperty("MinNPCAnimation", 5);
		MAX_NPC_ANIMATION = serverSettings.getProperty("MaxNPCAnimation", 90);

		AUTOSAVE = serverSettings.getProperty("Autosave", true);

		MAXIMUM_ONLINE_USERS = serverSettings.getProperty("MaximumOnlineUsers", 3000);

		DATABASE_DRIVER = serverSettings.getProperty("DATABASE_DRIVER", "com.mysql.cj.jdbc.Driver");

		String databaseHost = serverSettings.getProperty("DATABASE_HOST", "localhost");
		int databasePort = serverSettings.getProperty("DATABASE_PORT", 3306);
		String databaseName = serverSettings.getProperty("DATABASE_NAME", "l2game");

		DATABASE_URL = serverSettings.getProperty("DATABASE_URL", "jdbc:mysql://" + databaseHost + ":" + databasePort + "/" + databaseName + "?useUnicode=true&characterEncoding=utf-8&useSSL=false&serverTimezone=UTC");
		DATABASE_LOGIN = serverSettings.getProperty("DATABASE_LOGIN", "root");
		DATABASE_PASSWORD = serverSettings.getProperty("DATABASE_PASSWORD", "");

		DATABASE_AUTOUPDATE = serverSettings.getProperty("DATABASE_AUTOUPDATE", false);

		DATABASE_MAX_CONNECTIONS = serverSettings.getProperty("MaximumDbConnections", 100);
		DATABASE_MAX_IDLE_TIMEOUT = serverSettings.getProperty("MaxIdleConnectionTimeout", 600);
		DATABASE_IDLE_TEST_PERIOD = serverSettings.getProperty("IdleConnectionTestPeriod", 60);

		USER_INFO_INTERVAL = serverSettings.getProperty("UserInfoInterval", 100L);
		USER_INFO_EXP_SP_INTERVAL = serverSettings.getProperty("UserInfoExpSpInterval", 300L);
		BROADCAST_STATS_INTERVAL = serverSettings.getProperty("BroadcastStatsInterval", true);
		BROADCAST_CHAR_INFO_INTERVAL = serverSettings.getProperty("BroadcastCharInfoInterval", 100L);

		EFFECT_TASK_MANAGER_COUNT = serverSettings.getProperty("EffectTaskManagers", 2);

		SCHEDULED_THREAD_POOL_SIZE = serverSettings.getProperty("ScheduledThreadPoolSize", NCPUS * 4);
		EXECUTOR_THREAD_POOL_SIZE = serverSettings.getProperty("ExecutorThreadPoolSize", NCPUS * 2);

		SELECTOR_CONFIG.SLEEP_TIME = serverSettings.getProperty("SelectorSleepTime", 10L);
		SELECTOR_CONFIG.INTEREST_DELAY = serverSettings.getProperty("InterestDelay", 30L);
		SELECTOR_CONFIG.MAX_SEND_PER_PASS = serverSettings.getProperty("MaxSendPerPass", 32);
		SELECTOR_CONFIG.READ_BUFFER_SIZE = serverSettings.getProperty("ReadBufferSize", 65536);
		SELECTOR_CONFIG.WRITE_BUFFER_SIZE = serverSettings.getProperty("WriteBufferSize", 131072);
		SELECTOR_CONFIG.HELPER_BUFFER_COUNT = serverSettings.getProperty("BufferPoolSize", 64);

		CHAT_MESSAGE_MAX_LEN = serverSettings.getProperty("ChatMessageLimit", 1000);
		ABUSEWORD_BANCHAT = serverSettings.getProperty("ABUSEWORD_BANCHAT", false);
		int counter = 0;
		for(int id : serverSettings.getProperty("ABUSEWORD_BAN_CHANNEL", new int[] { 0 }))
		{
			BAN_CHANNEL_LIST[counter] = id;
			counter++;
		}
		ABUSEWORD_REPLACE = serverSettings.getProperty("ABUSEWORD_REPLACE", false);
		ABUSEWORD_REPLACE_STRING = serverSettings.getProperty("ABUSEWORD_REPLACE_STRING", "_-_");
		BANCHAT_ANNOUNCE = serverSettings.getProperty("BANCHAT_ANNOUNCE", true);
		BANCHAT_ANNOUNCE_FOR_ALL_WORLD = serverSettings.getProperty("BANCHAT_ANNOUNCE_FOR_ALL_WORLD", true);
		BANCHAT_ANNOUNCE_NICK = serverSettings.getProperty("BANCHAT_ANNOUNCE_NICK", true);
		ABUSEWORD_BANTIME = serverSettings.getProperty("ABUSEWORD_UNBAN_TIMER", 30);

		USE_CLIENT_LANG = serverSettings.getProperty("UseClientLang", false);
		CAN_SELECT_LANGUAGE = serverSettings.getProperty("CAN_SELECT_LANGUAGE", !USE_CLIENT_LANG);
		DEFAULT_LANG = Language.valueOf(serverSettings.getProperty("DefaultLang", "ENGLISH").toUpperCase());
		RESTART_AT_TIME = serverSettings.getProperty("AutoRestartAt", "0 5 * * *");

		RETAIL_MULTISELL_ENCHANT_TRANSFER = serverSettings.getProperty("RetailMultisellItemExchange", true);

		SHIFT_BY = serverSettings.getProperty("HShift", 12);
		SHIFT_BY_Z = serverSettings.getProperty("VShift", 11);
		MAP_MIN_Z = serverSettings.getProperty("MapMinZ", Short.MIN_VALUE);
		MAP_MAX_Z = serverSettings.getProperty("MapMaxZ", Short.MAX_VALUE);

		ENABLE_PACKET_LOG = serverSettings.getProperty("EnablePacketLog", false);
		MOVE_PACKET_DELAY = serverSettings.getProperty("MovePacketDelay", 200);
		ATTACK_PACKET_DELAY = serverSettings.getProperty("AttackPacketDelay", 500);

		DAMAGE_FROM_FALLING = serverSettings.getProperty("DamageFromFalling", true);

		ALLOW_WEDDING = serverSettings.getProperty("AllowWedding", false);
		WEDDING_PRICE = serverSettings.getProperty("WeddingPrice", 500000);
		WEDDING_PUNISH_INFIDELITY = serverSettings.getProperty("WeddingPunishInfidelity", true);
		WEDDING_TELEPORT = serverSettings.getProperty("WeddingTeleport", true);
		WEDDING_TELEPORT_PRICE = serverSettings.getProperty("WeddingTeleportPrice", 500000);
		WEDDING_TELEPORT_INTERVAL = serverSettings.getProperty("WeddingTeleportInterval", 120);
		WEDDING_SAMESEX = serverSettings.getProperty("WeddingAllowSameSex", true);
		WEDDING_FORMALWEAR = serverSettings.getProperty("WeddingFormalWear", true);
		WEDDING_DIVORCE_COSTS = serverSettings.getProperty("WeddingDivorceCosts", 20);

		DONTLOADSPAWN = serverSettings.getProperty("StartWithoutSpawn", false);
		DONTLOADQUEST = serverSettings.getProperty("StartWithoutQuest", false);

		MAX_REFLECTIONS_COUNT = serverSettings.getProperty("MaxReflectionsCount", 300);

		WEAR_DELAY = serverSettings.getProperty("WearDelay", 5);

		HTM_CACHE_MODE = serverSettings.getProperty("HtmCacheMode", HtmCache.LAZY);
		HTM_SHAPE_ARABIC = serverSettings.getProperty("HtmShapeArabic", false);
		SHUTDOWN_ANN_TYPE = serverSettings.getProperty("ShutdownAnnounceType", Shutdown.OFFLIKE_ANNOUNCES);
		APASSWD_TEMPLATE = serverSettings.getProperty("PasswordTemplate", "[A-Za-z0-9]{4,16}");

		ALLOW_MONSTER_RACE = serverSettings.getProperty("AllowMonsterRace", false);
		//ALT_SAVE_ADMIN_SPAWN = serverSettings.getProperty("SaveAdminSpawn", false);

		AVAILABLE_LANGUAGES = new HashSet<Language>();
		AVAILABLE_LANGUAGES.add(Language.ENGLISH);
		AVAILABLE_LANGUAGES.add(Language.RUSSIAN);
		AVAILABLE_LANGUAGES.add(DEFAULT_LANG);

		if(USE_CLIENT_LANG || CAN_SELECT_LANGUAGE) {
			String[] availableLanguages = serverSettings.getProperty("AVAILABLE_LANGUAGES", new String[0], ";");
			for(String availableLanguage : availableLanguages) {
				Language lang = Language.valueOf(availableLanguage.toUpperCase());
				if(!lang.isCustom() || CAN_SELECT_LANGUAGE)
					AVAILABLE_LANGUAGES.add(lang);
			}
		}

		MAX_ACTIVE_ACCOUNTS_ON_ONE_IP = serverSettings.getProperty("MAX_ACTIVE_ACCOUNTS_ON_ONE_IP", -1);
		MAX_ACTIVE_ACCOUNTS_IGNORED_IP = serverSettings.getProperty("MAX_ACTIVE_ACCOUNTS_IGNORED_IP", new String[0], ";");
		MAX_ACTIVE_ACCOUNTS_ON_ONE_HWID = serverSettings.getProperty("MAX_ACTIVE_ACCOUNTS_ON_ONE_HWID", -1);

		FAKE_PLAYERS_COUNT = serverSettings.getProperty("FAKE_PLAYERS_COUNT", 0);
		FAKE_PLAYERS_SPAWN_TASK_DELAY = Math.max(1, serverSettings.getProperty("FAKE_PLAYERS_SPAWN_TASK_DELAY", 10));

		SHOW_PRINT = serverSettings.getProperty("ShowPrint", false);
	}

	public static void loadTelnetConfig()
	{
		ExProperties telnetSettings = load(TELNET_CONFIGURATION_FILE);

		IS_TELNET_ENABLED = telnetSettings.getProperty("EnableTelnet", false);
		TELNET_DEFAULT_ENCODING = telnetSettings.getProperty("TelnetEncoding", "UTF-8");
		TELNET_PORT = telnetSettings.getProperty("Port", 7000);
		TELNET_HOSTNAME = telnetSettings.getProperty("BindAddress", "127.0.0.1");
		TELNET_PASSWORD = telnetSettings.getProperty("Password", "");
	}

	public static void loadResidenceConfig()
	{
		ExProperties residenceSettings = load(RESIDENCE_CONFIG_FILE);

		CH_BID_GRADE1_MINCLANLEVEL = residenceSettings.getProperty("ClanHallBid_Grade1_MinClanLevel", 2);
		CH_BID_GRADE1_MINCLANMEMBERS = residenceSettings.getProperty("ClanHallBid_Grade1_MinClanMembers", 1);
		CH_BID_GRADE1_MINCLANMEMBERSLEVEL = residenceSettings.getProperty("ClanHallBid_Grade1_MinClanMembersAvgLevel", 1);
		CH_BID_GRADE2_MINCLANLEVEL = residenceSettings.getProperty("ClanHallBid_Grade2_MinClanLevel", 2);
		CH_BID_GRADE2_MINCLANMEMBERS = residenceSettings.getProperty("ClanHallBid_Grade2_MinClanMembers", 1);
		CH_BID_GRADE2_MINCLANMEMBERSLEVEL = residenceSettings.getProperty("ClanHallBid_Grade2_MinClanMembersAvgLevel", 1);
		CH_BID_GRADE3_MINCLANLEVEL = residenceSettings.getProperty("ClanHallBid_Grade3_MinClanLevel", 2);
		CH_BID_GRADE3_MINCLANMEMBERS = residenceSettings.getProperty("ClanHallBid_Grade3_MinClanMembers", 1);
		CH_BID_GRADE3_MINCLANMEMBERSLEVEL = residenceSettings.getProperty("ClanHallBid_Grade3_MinClanMembersAvgLevel", 1);
		RESIDENCE_LEASE_FUNC_MULTIPLIER = residenceSettings.getProperty("ResidenceLeaseFuncMultiplier", 1.);
		RESIDENCE_LEASE_MULTIPLIER = residenceSettings.getProperty("ResidenceLeaseMultiplier", 1.);

		LIGHT_CASTLE_SELL_TAX_PERCENT = residenceSettings.getProperty("LIGHT_CASTLE_SELL_TAX_PERCENT", 0);
		DARK_CASTLE_SELL_TAX_PERCENT = residenceSettings.getProperty("DARK_CASTLE_SELL_TAX_PERCENT", 30);
		LIGHT_CASTLE_BUY_TAX_PERCENT = residenceSettings.getProperty("LIGHT_CASTLE_BUY_TAX_PERCENT", 0);
		DARK_CASTLE_BUY_TAX_PERCENT = residenceSettings.getProperty("DARK_CASTLE_BUY_TAX_PERCENT", 10);
	}

	public static void loadChatAntiFloodConfig()
	{
		ExProperties properties = load(CHAT_ANTIFLOOD_CONFIG_FILE);

		ALL_CHAT_USE_MIN_LEVEL = properties.getProperty("ALL_CHAT_USE_MIN_LEVEL", 1);
		ALL_CHAT_USE_MIN_LEVEL_WITHOUT_PA = properties.getProperty("ALL_CHAT_USE_MIN_LEVEL_WITHOUT_PA", 1);
		ALL_CHAT_USE_DELAY = properties.getProperty("ALL_CHAT_USE_DELAY", 0);

		SHOUT_CHAT_USE_MIN_LEVEL = properties.getProperty("SHOUT_CHAT_USE_MIN_LEVEL", 1);
		SHOUT_CHAT_USE_MIN_LEVEL_WITHOUT_PA = properties.getProperty("SHOUT_CHAT_USE_MIN_LEVEL_WITHOUT_PA", 1);
		SHOUT_CHAT_USE_DELAY = properties.getProperty("SHOUT_CHAT_USE_DELAY", 0);

		WORLD_CHAT_USE_MIN_LEVEL = properties.getProperty("WORLD_CHAT_USE_MIN_LEVEL", 95);
		WORLD_CHAT_USE_MIN_LEVEL_WITHOUT_PA = properties.getProperty("WORLD_CHAT_USE_MIN_LEVEL_WITHOUT_PA", 85);
		WORLD_CHAT_USE_DELAY = properties.getProperty("WORLD_CHAT_USE_DELAY", 0);

		TRADE_CHAT_USE_MIN_LEVEL = properties.getProperty("TRADE_CHAT_USE_MIN_LEVEL", 1);
		TRADE_CHAT_USE_MIN_LEVEL_WITHOUT_PA = properties.getProperty("TRADE_CHAT_USE_MIN_LEVEL_WITHOUT_PA", 1);
		TRADE_CHAT_USE_DELAY = properties.getProperty("TRADE_CHAT_USE_DELAY", 0);

		HERO_CHAT_USE_MIN_LEVEL = properties.getProperty("HERO_CHAT_USE_MIN_LEVEL", 1);
		HERO_CHAT_USE_MIN_LEVEL_WITHOUT_PA = properties.getProperty("HERO_CHAT_USE_MIN_LEVEL_WITHOUT_PA", 1);
		HERO_CHAT_USE_DELAY = properties.getProperty("HERO_CHAT_USE_DELAY", 0);

		PRIVATE_CHAT_USE_MIN_LEVEL = properties.getProperty("PRIVATE_CHAT_USE_MIN_LEVEL", 1);
		PRIVATE_CHAT_USE_MIN_LEVEL_WITHOUT_PA = properties.getProperty("PRIVATE_CHAT_USE_MIN_LEVEL_WITHOUT_PA", 1);
		PRIVATE_CHAT_USE_DELAY = properties.getProperty("PRIVATE_CHAT_USE_DELAY", 0);

		MAIL_USE_MIN_LEVEL = properties.getProperty("MAIL_USE_MIN_LEVEL", 1);
		MAIL_USE_MIN_LEVEL_WITHOUT_PA = properties.getProperty("MAIL_USE_MIN_LEVEL_WITHOUT_PA", 1);
		MAIL_USE_DELAY = properties.getProperty("MAIL_USE_DELAY", 0);
	}

	public static void loadCustomConfig()
	{
		ExProperties customSettings = load(CUSTOM_CONFIG_FILE);

		ONLINE_GENERATOR_ENABLED = customSettings.getProperty("OnlineGeneratorEnabled", false);
		ONLINE_GENERATOR_DELAY = customSettings.getProperty("OnlineGeneratorDelay", 1);

		FOURTH_CLASS_CHANGE_PRICE = customSettings.getProperty("FourthClassChangePrice", new long[] {57, 1000});

		final String[] bossEntries = customSettings.getProperty("BossStaticDamageReceived", "29169,1.0").split(";");
		for (String entry : bossEntries) {
			String[] info = entry.split(",");
			int bossId = Integer.parseInt(info[0]);
			double staticDamage = Double.parseDouble(info[1]);

			BOSS_STATIC_DAMAGE_RECEIVED.put(bossId, staticDamage);
		}

		COSTUME_PRICES = new HashMap<>();
		for (String costumeData : customSettings.getProperty("CostumeArmorList", "").split(","))
		{
			String[] split = costumeData.split(";");
			for (int i = 0; i < split.length; i+=3)
			{
				int costumeId = Integer.parseInt(split[i]);
				int paymentId = Integer.parseInt(split[i + 1]);
				long paymentCnt = Long.parseLong(split[i + 2]);

				COSTUME_PRICES.put(costumeId, new ItemData(paymentId, paymentCnt));
			}
		}
		for (String costumeData : customSettings.getProperty("CostumeWeaponList", "").split(","))
		{
			String[] split = costumeData.split(";");
			for (int i = 0; i < split.length; i+=3)
			{
				int costumeId = Integer.parseInt(split[i]);
				int paymentId = Integer.parseInt(split[i + 1]);
				long paymentCnt = Long.parseLong(split[i + 2]);

				COSTUME_PRICES.put(costumeId, new ItemData(paymentId, paymentCnt));
			}
		}
		for (String costumeData : customSettings.getProperty("CostumeShieldList", "").split(","))
		{
			String[] split = costumeData.split(";");
			for (int i = 0; i < split.length; i+=3)
			{
				int costumeId = Integer.parseInt(split[i]);
				int paymentId = Integer.parseInt(split[i + 1]);
				long paymentCnt = Long.parseLong(split[i + 2]);

				COSTUME_PRICES.put(costumeId, new ItemData(paymentId, paymentCnt));
			}
		}
		for (String costumeData : customSettings.getProperty("CostumeCloakList", "").split(","))
		{
			String[] split = costumeData.split(";");
			for (int i = 0; i < split.length; i+=3)
			{
				int costumeId = Integer.parseInt(split[i]);
				int paymentId = Integer.parseInt(split[i + 1]);
				long paymentCnt = Long.parseLong(split[i + 2]);

				COSTUME_PRICES.put(costumeId, new ItemData(paymentId, paymentCnt));
			}
		}

		MAX_RESETS_PER_INSTANCE = customSettings.getProperty("MaxResetsPerInstance", 10);

		REBIRTHS_TO_TAKE_DAMAGE_ENABLE = customSettings.getProperty("RebirthsToTakeDamageEnable", false);
		AUTO_AGATHION_SUMMON_ITEM_IDS = customSettings.getProperty("AutoSummonAgathionItemIds", ArrayUtils.EMPTY_INT_ARRAY);
		AUTO_AGATHION_SUMMON_AGATHION_ID = customSettings.getProperty("AutoSummonAgathionNpcId", 10000);

		M_SKILL_POWER_MUL_AS_ADD_MODE = customSettings.getProperty("MSkillPowerMulAsAddMode", false);
	}

	public static void loadFightClubSettings()
	{
		ExProperties eventFightClubSettings = load(FIGHT_CLUB_FILE);

		FIGHT_CLUB_ENABLED = eventFightClubSettings.getProperty("FightClubEnabled", false);
		MINIMUM_LEVEL_TO_PARRICIPATION = eventFightClubSettings.getProperty("MinimumLevel", 1);
		MAXIMUM_LEVEL_TO_PARRICIPATION = eventFightClubSettings.getProperty("MaximumLevel", 85);
		MAXIMUM_LEVEL_DIFFERENCE = eventFightClubSettings.getProperty("MaximumLevelDifference", 10);
		ALLOWED_RATE_ITEMS = eventFightClubSettings.getProperty("AllowedItems", "").trim().replaceAll(" ", "").split(",");
		PLAYERS_PER_PAGE = eventFightClubSettings.getProperty("RatesOnPage", 10);
		ARENA_TELEPORT_DELAY = eventFightClubSettings.getProperty("ArenaTeleportDelay", 5);
		CANCEL_BUFF_BEFORE_FIGHT = eventFightClubSettings.getProperty("CancelBuffs", true);
		UNSUMMON_PETS = eventFightClubSettings.getProperty("UnsummonPets", true);
		UNSUMMON_SUMMONS = eventFightClubSettings.getProperty("UnsummonSummons", true);
		REMOVE_CLAN_SKILLS = eventFightClubSettings.getProperty("RemoveClanSkills", false);
		REMOVE_HERO_SKILLS = eventFightClubSettings.getProperty("RemoveHeroSkills", false);
		TIME_TO_PREPARATION = eventFightClubSettings.getProperty("TimeToPreparation", 10);
		FIGHT_TIME = eventFightClubSettings.getProperty("TimeToDraw", 300);
		ALLOW_DRAW = eventFightClubSettings.getProperty("AllowDraw", true);
		TIME_TELEPORT_BACK = eventFightClubSettings.getProperty("TimeToBack", 10);
		FIGHT_CLUB_ANNOUNCE_RATE = eventFightClubSettings.getProperty("AnnounceRate", false);
		FIGHT_CLUB_ANNOUNCE_RATE_TO_SCREEN = eventFightClubSettings.getProperty("AnnounceRateToAllScreen", false);
		FIGHT_CLUB_ANNOUNCE_START_TO_SCREEN = eventFightClubSettings.getProperty("AnnounceStartBatleToAllScreen", false);
	}

	public static void loadOtherConfig()
	{
		ExProperties otherSettings = load(OTHER_CONFIG_FILE);

		DEEPBLUE_DROP_RULES = otherSettings.getProperty("UseDeepBlueDropRules", true);
		DEEPBLUE_DROP_MAXDIFF = otherSettings.getProperty("DeepBlueDropMaxDiff", 8);
		DEEPBLUE_DROP_RAID_MAXDIFF = otherSettings.getProperty("DeepBlueDropRaidMaxDiff", 2);

		SWIMING_SPEED = otherSettings.getProperty("SwimingSpeedTemplate", 50);

		/* Inventory slots limits */
		INVENTORY_MAXIMUM_NO_DWARF = otherSettings.getProperty("MaximumSlotsForNoDwarf", 80);
		INVENTORY_MAXIMUM_DWARF = otherSettings.getProperty("MaximumSlotsForDwarf", 100);
		INVENTORY_MAXIMUM_GM = otherSettings.getProperty("MaximumSlotsForGMPlayer", 250);
		QUEST_INVENTORY_MAXIMUM = otherSettings.getProperty("MaximumSlotsForQuests", 100);

		MULTISELL_SIZE = otherSettings.getProperty("MultisellPageSize", 40);

		/* Warehouse slots limits */
		WAREHOUSE_SLOTS_NO_DWARF = otherSettings.getProperty("BaseWarehouseSlotsForNoDwarf", 100);
		WAREHOUSE_SLOTS_DWARF = otherSettings.getProperty("BaseWarehouseSlotsForDwarf", 120);
		WAREHOUSE_SLOTS_CLAN = otherSettings.getProperty("MaximumWarehouseSlotsForClan", 200);
		FREIGHT_SLOTS = otherSettings.getProperty("MaximumFreightSlots", 10);

		REGEN_SIT_WAIT = otherSettings.getProperty("RegenSitWait", false);
		UNSTUCK_SKILL = otherSettings.getProperty("UnstuckSkill", true);

		/* Amount of HP, MP, and CP is restored */
		RESPAWN_RESTORE_CP = otherSettings.getProperty("RespawnRestoreCP", 0.) / 100;
		RESPAWN_RESTORE_HP = otherSettings.getProperty("RespawnRestoreHP", 65.) / 100;
		RESPAWN_RESTORE_MP = otherSettings.getProperty("RespawnRestoreMP", 0.) / 100;

		/* Maximum number of available slots for pvt stores */
		MAX_PVTSTORE_SLOTS_DWARF = otherSettings.getProperty("MaxPvtStoreSlotsDwarf", 5);
		MAX_PVTSTORE_SLOTS_OTHER = otherSettings.getProperty("MaxPvtStoreSlotsOther", 4);
		MAX_PVTCRAFT_SLOTS = otherSettings.getProperty("MaxPvtManufactureSlots", 20);

		SENDSTATUS_TRADE_JUST_OFFLINE = otherSettings.getProperty("SendStatusTradeJustOffline", false);
		SENDSTATUS_TRADE_MOD = otherSettings.getProperty("SendStatusTradeMod", 1.);

		ANNOUNCE_MAMMON_SPAWN = otherSettings.getProperty("AnnounceMammonSpawn", true);

		GM_NAME_COLOUR = Integer.decode("0x" + otherSettings.getProperty("GMNameColour", "FFFFFF"));
		GM_HERO_AURA = otherSettings.getProperty("GMHeroAura", false);
		NORMAL_NAME_COLOUR = Integer.decode("0x" + otherSettings.getProperty("NormalNameColour", "FFFFFF"));
		CLANLEADER_NAME_COLOUR = Integer.decode("0x" + otherSettings.getProperty("ClanleaderNameColour", "FFFFFF"));
		SHOW_HTML_WELCOME = otherSettings.getProperty("ShowHTMLWelcome", false);

		MIN_DIFF_LEVELS_FOR_EXP_SP_PENALTY = otherSettings.getProperty("MIN_DIFF_LEVELS_FOR_EXP_SP_PENALTY", 10);
	}

	public static void loadSpoilConfig()
	{
		ExProperties spoilSettings = load(SPOIL_CONFIG_FILE);

		BASE_SPOIL_RATE = spoilSettings.getProperty("BasePercentChanceOfSpoilSuccess", 78.);
		MINIMUM_SPOIL_RATE = spoilSettings.getProperty("MinimumPercentChanceOfSpoilSuccess", 1.);
		MANOR_SOWING_BASIC_SUCCESS = spoilSettings.getProperty("BasePercentChanceOfSowingSuccess", 100.);
		MANOR_SOWING_ALT_BASIC_SUCCESS = spoilSettings.getProperty("BasePercentChanceOfSowingAltSuccess", 10.);
		MANOR_HARVESTING_BASIC_SUCCESS = spoilSettings.getProperty("BasePercentChanceOfHarvestingSuccess", 90.);
		MANOR_DIFF_PLAYER_TARGET = spoilSettings.getProperty("MinDiffPlayerMob", 5);
		MANOR_DIFF_PLAYER_TARGET_PENALTY = spoilSettings.getProperty("DiffPlayerMobPenalty", 5.);
		MANOR_DIFF_SEED_TARGET = spoilSettings.getProperty("MinDiffSeedMob", 5);
		MANOR_DIFF_SEED_TARGET_PENALTY = spoilSettings.getProperty("DiffSeedMobPenalty", 5.);
		ALLOW_MANOR = spoilSettings.getProperty("AllowManor", true);
		MANOR_REFRESH_TIME = spoilSettings.getProperty("AltManorRefreshTime", 20);
		MANOR_REFRESH_MIN = spoilSettings.getProperty("AltManorRefreshMin", 00);
		MANOR_APPROVE_TIME = spoilSettings.getProperty("AltManorApproveTime", 6);
		MANOR_APPROVE_MIN = spoilSettings.getProperty("AltManorApproveMin", 00);
		MANOR_MAINTENANCE_PERIOD = spoilSettings.getProperty("AltManorMaintenancePeriod", 360000);
	}

	public static void loadFormulasConfig()
	{
		ExProperties formulasSettings = load(FORMULAS_CONFIGURATION_FILE);

		MIN_ABNORMAL_SUCCESS_RATE = formulasSettings.getProperty("MIN_ABNORMAL_SUCCESS_RATE", 10.);
		MAX_ABNORMAL_SUCCESS_RATE = formulasSettings.getProperty("MAX_ABNORMAL_SUCCESS_RATE", 90.);

		LIM_PATK = formulasSettings.getProperty("LimitPatk", -1);
		LIM_MATK = formulasSettings.getProperty("LimitMAtk", -1);
		LIM_PDEF = formulasSettings.getProperty("LimitPDef", 15000);
		LIM_MDEF = formulasSettings.getProperty("LimitMDef", 15000);
		LIM_PATK_SPD = formulasSettings.getProperty("LimitPatkSpd", 1500);
		LIM_MATK_SPD = formulasSettings.getProperty("LimitMatkSpd", 1999);
		LIM_CRIT_DAM = formulasSettings.getProperty("LimitCriticalDamage", 500);
		LIM_CRIT = formulasSettings.getProperty("LimitCritical", 500);
		LIM_MCRIT = formulasSettings.getProperty("LimitMCritical", 20);
		LIM_ACCURACY = formulasSettings.getProperty("LimitAccuracy", 200);
		LIM_EVASION = formulasSettings.getProperty("LimitEvasion", 200);
		LIM_MOVE = formulasSettings.getProperty("LimitMove", 250);
		HP_LIMIT = formulasSettings.getProperty("HP_LIMIT", 150000);
		MP_LIMIT = formulasSettings.getProperty("MP_LIMIT", -1);
		CP_LIMIT = formulasSettings.getProperty("CP_LIMIT", -1);

		LIM_FAME = formulasSettings.getProperty("LimitFame", 20000000);
		LIM_RAID_POINTS = formulasSettings.getProperty("LIM_RAID_POINTS", 2000);

		LIM_CRAFT_POINTS = formulasSettings.getProperty("LimitCraftPoints", 99);

		PLAYER_P_ATK_MODIFIER = formulasSettings.getProperty("PLAYER_P_ATK_MODIFIER", 1.0);
		PLAYER_M_ATK_MODIFIER = formulasSettings.getProperty("PLAYER_M_ATK_MODIFIER", 1.0);

		ALT_NPC_PATK_MODIFIER = formulasSettings.getProperty("NpcPAtkModifier", 1.0);
		ALT_NPC_MATK_MODIFIER = formulasSettings.getProperty("NpcMAtkModifier", 1.0);
		ALT_NPC_MAXHP_MODIFIER = formulasSettings.getProperty("NpcMaxHpModifier", 1.0);
		ALT_NPC_MAXMP_MODIFIER = formulasSettings.getProperty("NpcMapMpModifier", 1.0);

		ALT_POLE_DAMAGE_MODIFIER = formulasSettings.getProperty("PoleDamageModifier", 1.0);

		LONG_RANGE_AUTO_ATTACK_P_ATK_MOD = formulasSettings.getProperty("LONG_RANGE_AUTO_ATTACK_P_ATK_MOD", 2.0);
		SHORT_RANGE_AUTO_ATTACK_P_ATK_MOD = formulasSettings.getProperty("SHORT_RANGE_AUTO_ATTACK_P_ATK_MOD", 1.0);

		ALT_M_SIMPLE_DAMAGE_MOD = formulasSettings.getProperty("mDamSimpleModifier", 1.0);
		ALT_M_SIMPLE_DAMAGE_MOD_SIGEL = formulasSettings.getProperty("mDamSimpleModifierSigel", 1.0);
		ALT_M_SIMPLE_DAMAGE_MOD_TIR_WARRIOR = formulasSettings.getProperty("mDamSimpleModifierTyrWarrior", 1.0);
		ALT_M_SIMPLE_DAMAGE_MOD_OTHEL_ROGUE = formulasSettings.getProperty("mDamSimpleModifierOthelRogue", 1.0);
		ALT_M_SIMPLE_DAMAGE_MOD_YR_ARCHER = formulasSettings.getProperty("mDamSimpleModifierYrArcher", 1.0);
		ALT_M_SIMPLE_DAMAGE_MOD_FEO_WIZZARD = formulasSettings.getProperty("mDamSimpleModifierFeoWizzard", 1.0);
		ALT_M_SIMPLE_DAMAGE_MOD_ISS_ENCHANTER = formulasSettings.getProperty("mDamSimpleModifierIssEnchanter", 1.0);
		ALT_M_SIMPLE_DAMAGE_MOD_WYN_SUMMONER = formulasSettings.getProperty("mDamSimpleModifierWynSummoner", 1.0);
		ALT_M_SIMPLE_DAMAGE_MOD_EOL_HEALER = formulasSettings.getProperty("mDamSimpleModifierEolHealer", 1.0);
		//new
		ALT_M_SIMPLE_DAMAGE_MOD_SIGEL_PHOENIX_KNIGHT = formulasSettings.getProperty("mDamSimpleModifierSigelPhoenixKnight", 1.0);
		ALT_M_SIMPLE_DAMAGE_MOD_SIGEL_HELL_KNIGHT = formulasSettings.getProperty("mDamSimpleModifierSigetHellKnight", 1.0);
		ALT_M_SIMPLE_DAMAGE_MOD_SIGEL_EVAS_TEMPLAR = formulasSettings.getProperty("mDamSimpleModifierSigelEvasTemplar", 1.0);
		ALT_M_SIMPLE_DAMAGE_MOD_SIGEL_SHILLIEN_TEMPLAR = formulasSettings.getProperty("mDamSimpleModifierSigelShillienTemplar", 1.0);
		ALT_M_SIMPLE_DAMAGE_MOD_TYR_DUELIST = formulasSettings.getProperty("mDamSimpleModifierTyrDuelist", 1.0);
		ALT_M_SIMPLE_DAMAGE_MOD_TYR_DREADNOUGHT = formulasSettings.getProperty("mDamSimpleModifierTyrDreadnought", 1.0);
		ALT_M_SIMPLE_DAMAGE_MOD_TYR_TITAN = formulasSettings.getProperty("mDamSimpleModifierTyrTitan", 1.0);
		ALT_M_SIMPLE_DAMAGE_MOD_TYR_GRAND_KHAVATARI = formulasSettings.getProperty("mDamSimpleModifierTyrGrandKhavatari", 1.0);
		ALT_M_SIMPLE_DAMAGE_MOD_TYR_MAESTRO = formulasSettings.getProperty("mDamSimpleModifierTyrMaestro", 1.0);
		ALT_M_SIMPLE_DAMAGE_MOD_TYR_DOOMBRINGER = formulasSettings.getProperty("mDamSimpleModifierTyrDoomBringer", 1.0);
		ALT_M_SIMPLE_DAMAGE_MOD_OTHELL_ADVENTURER = formulasSettings.getProperty("mDamSimpleModifierOthellAdventurer", 1.0);
		ALT_M_SIMPLE_DAMAGE_MOD_OTHELL_WIND_RIDER = formulasSettings.getProperty("mDamSimpleModifierOthellWindRider", 1.0);
		ALT_M_SIMPLE_DAMAGE_MOD_OTHELL_GHOST_HUNTER = formulasSettings.getProperty("mDamSimpleModifierOthellGhostHunter", 1.0);
		ALT_M_SIMPLE_DAMAGE_MOD_OTHELL_FORTUNE_SEEKER = formulasSettings.getProperty("mDamSimpleModifierOthellFortuneSeeker", 1.0);
		ALT_M_SIMPLE_DAMAGE_MOD_YR_SAGITTARIUS = formulasSettings.getProperty("mDamSimpleModifierYurSagitarius", 1.0);
		ALT_M_SIMPLE_DAMAGE_MOD_YR_MOONLIGHT_SENTINEL = formulasSettings.getProperty("mDamSimpleModifierYurMoonLightSentinel", 1.0);
		ALT_M_SIMPLE_DAMAGE_MOD_YR_GHOST_SENTINEL = formulasSettings.getProperty("mDamSimpleModifierYurGhostSentinel", 1.0);
		ALT_M_SIMPLE_DAMAGE_MOD_YR_TRICKSTER = formulasSettings.getProperty("mDamSimpleModifierYurTrickster", 1.0);
		ALT_M_SIMPLE_DAMAGE_MOD_FEOH_ARCHMAGE = formulasSettings.getProperty("mDamSimpleModifierFeohArchMage", 1.0);
		ALT_M_SIMPLE_DAMAGE_MOD_FEOH_SOULTAKER = formulasSettings.getProperty("mDamSimpleModifierFeohSoultaker", 1.0);
		ALT_M_SIMPLE_DAMAGE_MOD_FEOH_MYSTIC_MUSE = formulasSettings.getProperty("mDamSimpleModifierFeohMysticMuse", 1.0);
		ALT_M_SIMPLE_DAMAGE_MOD_FEOH_STORM_SCREAMER = formulasSettings.getProperty("mDamSimpleModifierFeohStormScreamer", 1.0);
		ALT_M_SIMPLE_DAMAGE_MOD_FEOH_SOUL_HOUND = formulasSettings.getProperty("mDamSimpleModifierFeohSoulHound", 1.0);
		ALT_M_SIMPLE_DAMAGE_MOD_ISS_HIEROPHANT = formulasSettings.getProperty("mDamSimpleModifierIssHierophant", 1.0);
		ALT_M_SIMPLE_DAMAGE_MOD_ISS_SWORD_MUSE = formulasSettings.getProperty("mDamSimpleModifierIssSwordMuse", 1.0);
		ALT_M_SIMPLE_DAMAGE_MOD_ISS_SPECTRAL_DANCER = formulasSettings.getProperty("mDamSimpleModifierIssSpectralDancer", 1.0);
		ALT_M_SIMPLE_DAMAGE_MOD_ISS_DOMINATOR = formulasSettings.getProperty("mDamSimpleModifierIssDominator", 1.0);
		ALT_M_SIMPLE_DAMAGE_MOD_ISS_DOOMCRYER = formulasSettings.getProperty("mDamSimpleModifierIssDoomCryer", 1.0);
		ALT_M_SIMPLE_DAMAGE_MOD_WYNN_ARCANA_LORD = formulasSettings.getProperty("mDamSimpleModifierWynnArcanaLord", 1.0);
		ALT_M_SIMPLE_DAMAGE_MOD_WYNN_ELEMENTAL_MASTER = formulasSettings.getProperty("mDamSimpleModifierWynnElementalMaster", 1.0);
		ALT_M_SIMPLE_DAMAGE_MOD_WYNN_SPECTRAL_MASTER = formulasSettings.getProperty("mDamSimpleModifierWynnSpectralMaster", 1.0);
		ALT_M_SIMPLE_DAMAGE_MOD_AEORE_CARDINAL = formulasSettings.getProperty("mDamSimpleModifierAeoreCardinal", 1.0);
		ALT_M_SIMPLE_DAMAGE_MOD_AEORE_EVAS_SAINT = formulasSettings.getProperty("mDamSimpleModifierAeoreEvasSaint", 1.0);
		ALT_M_SIMPLE_DAMAGE_MOD_AEORE_SHILLIEN_SAINT = formulasSettings.getProperty("mDamSimpleModifierAeoreShillenSaint", 1.0);
		ALT_M_SIMPLE_DAMAGE_MOD_EVISCERATOR = formulasSettings.getProperty("mDamSimpleModifierEviscerator", 1.0);
		ALT_M_SIMPLE_DAMAGE_MOD_SAHYAS_SEER = formulasSettings.getProperty("mDamSimpleModifierSahyasSeer", 1.0);

		ALT_P_DAMAGE_MOD = formulasSettings.getProperty("pDamMod", 1.0);
		ALT_P_DAMAGE_MOD_SIGEL = formulasSettings.getProperty("pDamModSigel", 1.0);
		ALT_P_DAMAGE_MOD_TIR_WARRIOR = formulasSettings.getProperty("pDamModTyrWarrior", 1.0);
		ALT_P_DAMAGE_MOD_OTHEL_ROGUE = formulasSettings.getProperty("pDamModOthelRogue", 1.0);
		ALT_P_DAMAGE_MOD_YR_ARCHER = formulasSettings.getProperty("pDamModYrArcher", 1.0);
		ALT_P_DAMAGE_MOD_FEO_WIZZARD = formulasSettings.getProperty("pDamModFeoWizzard", 1.0);
		ALT_P_DAMAGE_MOD_ISS_ENCHANTER = formulasSettings.getProperty("pDamModIssEnchanter", 1.0);
		ALT_P_DAMAGE_MOD_WYN_SUMMONER = formulasSettings.getProperty("pDamModWynSummoner", 1.0);
		ALT_P_DAMAGE_MOD_EOL_HEALER = formulasSettings.getProperty("pDamModEolHealer", 1.0);
		//new
		ALT_P_DAMAGE_MOD_SIGEL_PHOENIX_KNIGHT = formulasSettings.getProperty("pDamModSigelPhoenixKnight", 1.0);
		ALT_P_DAMAGE_MOD_SIGEL_HELL_KNIGHT = formulasSettings.getProperty("pDamModSigetHellKnight", 1.0);
		ALT_P_DAMAGE_MOD_SIGEL_EVAS_TEMPLAR = formulasSettings.getProperty("pDamModSigelEvasTemplar", 1.0);
		ALT_P_DAMAGE_MOD_SIGEL_SHILLIEN_TEMPLAR = formulasSettings.getProperty("pDamModSigelShillienTemplar", 1.0);
		ALT_P_DAMAGE_MOD_TYR_DUELIST = formulasSettings.getProperty("pDamModTyrDuelist", 1.0);
		ALT_P_DAMAGE_MOD_TYR_DREADNOUGHT = formulasSettings.getProperty("pDamModTyrDreadnought", 1.0);
		ALT_P_DAMAGE_MOD_TYR_TITAN = formulasSettings.getProperty("pDamModTyrTitan", 1.0);
		ALT_P_DAMAGE_MOD_TYR_GRAND_KHAVATARI = formulasSettings.getProperty("pDamModTyrGrandKhavatari", 1.0);
		ALT_P_DAMAGE_MOD_TYR_MAESTRO = formulasSettings.getProperty("pDamModTyrMaestro", 1.0);
		ALT_P_DAMAGE_MOD_TYR_DOOMBRINGER = formulasSettings.getProperty("pDamModTyrDoomBringer", 1.0);
		ALT_P_DAMAGE_MOD_OTHELL_ADVENTURER = formulasSettings.getProperty("pDamModOthellAdventurer", 1.0);
		ALT_P_DAMAGE_MOD_OTHELL_WIND_RIDER = formulasSettings.getProperty("pDamModOthellWindRider", 1.0);
		ALT_P_DAMAGE_MOD_OTHELL_GHOST_HUNTER = formulasSettings.getProperty("pDamModOthellGhostHunter", 1.0);
		ALT_P_DAMAGE_MOD_OTHELL_FORTUNE_SEEKER = formulasSettings.getProperty("pDamModOthellFortuneSeeker", 1.0);
		ALT_P_DAMAGE_MOD_YR_SAGITTARIUS = formulasSettings.getProperty("pDamModYurSagitarius", 1.0);
		ALT_P_DAMAGE_MOD_YR_MOONLIGHT_SENTINEL = formulasSettings.getProperty("pDamModYurMoonLightSentinel", 1.0);
		ALT_P_DAMAGE_MOD_YR_GHOST_SENTINEL = formulasSettings.getProperty("pDamModYurGhostSentinel", 1.0);
		ALT_P_DAMAGE_MOD_YR_TRICKSTER = formulasSettings.getProperty("pDamModYurTrickster", 1.0);
		ALT_P_DAMAGE_MOD_FEOH_ARCHMAGE = formulasSettings.getProperty("pDamModFeohArchMage", 1.0);
		ALT_P_DAMAGE_MOD_FEOH_SOULTAKER = formulasSettings.getProperty("pDamModFeohSoultaker", 1.0);
		ALT_P_DAMAGE_MOD_FEOH_MYSTIC_MUSE = formulasSettings.getProperty("pDamModFeohMysticMuse", 1.0);
		ALT_P_DAMAGE_MOD_FEOH_STORM_SCREAMER = formulasSettings.getProperty("pDamModFeohStormScreamer", 1.0);
		ALT_P_DAMAGE_MOD_FEOH_SOUL_HOUND = formulasSettings.getProperty("pDamModFeohSoulHound", 1.0);
		ALT_P_DAMAGE_MOD_ISS_HIEROPHANT = formulasSettings.getProperty("pDamModIssHierophant", 1.0);
		ALT_P_DAMAGE_MOD_ISS_SWORD_MUSE = formulasSettings.getProperty("pDamModIssSwordMuse", 1.0);
		ALT_P_DAMAGE_MOD_ISS_SPECTRAL_DANCER = formulasSettings.getProperty("pDamModIssSpectralDancer", 1.0);
		ALT_P_DAMAGE_MOD_ISS_DOMINATOR = formulasSettings.getProperty("pDamModIssDominator", 1.0);
		ALT_P_DAMAGE_MOD_ISS_DOOMCRYER = formulasSettings.getProperty("pDamModIssDoomCryer", 1.0);
		ALT_P_DAMAGE_MOD_WYNN_ARCANA_LORD = formulasSettings.getProperty("pDamModWynnArcanaLord", 1.0);
		ALT_P_DAMAGE_MOD_WYNN_ELEMENTAL_MASTER = formulasSettings.getProperty("pDamModWynnElementalMaster", 1.0);
		ALT_P_DAMAGE_MOD_WYNN_SPECTRAL_MASTER = formulasSettings.getProperty("pDamModWynnSpectralMaster", 1.0);
		ALT_P_DAMAGE_MOD_AEORE_CARDINAL = formulasSettings.getProperty("pDamModAeoreCardinal", 1.0);
		ALT_P_DAMAGE_MOD_AEORE_EVAS_SAINT = formulasSettings.getProperty("pDamModAeoreEvasSaint", 1.0);
		ALT_P_DAMAGE_MOD_AEORE_SHILLIEN_SAINT = formulasSettings.getProperty("pDamModAeoreShillenSaint", 1.0);
		ALT_P_DAMAGE_MOD_EVISCERATOR = formulasSettings.getProperty("pDamModEviscerator", 1.0);
		ALT_P_DAMAGE_MOD_SAHYAS_SEER = formulasSettings.getProperty("pDamModSahyasSeer", 1.0);

		ALT_M_CRIT_DAMAGE_MOD = formulasSettings.getProperty("mCritModifier", 1.0);
		ALT_M_CRIT_DAMAGE_MOD_SIGEL = formulasSettings.getProperty("mCritModifierSigel", 1.0);
		ALT_M_CRIT_DAMAGE_MOD_TIR_WARRIOR = formulasSettings.getProperty("mCritModifierTyrWarrior", 1.0);
		ALT_M_CRIT_DAMAGE_MOD_OTHEL_ROGUE = formulasSettings.getProperty("mCritModifierOthelRogue", 1.0);
		ALT_M_CRIT_DAMAGE_MOD_YR_ARCHER = formulasSettings.getProperty("mCritModifierYrArcher", 1.0);
		ALT_M_CRIT_DAMAGE_MOD_FEO_WIZZARD = formulasSettings.getProperty("mCritModifierFeoWizzard", 1.0);
		ALT_M_CRIT_DAMAGE_MOD_ISS_ENCHANTER = formulasSettings.getProperty("mCritModifierIssEnchanter", 1.0);
		ALT_M_CRIT_DAMAGE_MOD_WYN_SUMMONER = formulasSettings.getProperty("mCritModifierWynSummoner", 1.0);
		ALT_M_CRIT_DAMAGE_MOD_EOL_HEALER = formulasSettings.getProperty("mCritModifierEolHealer", 1.0);
		//new
		ALT_M_CRIT_DAMAGE_MOD_SIGEL_PHOENIX_KNIGHT = formulasSettings.getProperty("mCritModifierSigelPhoenixKnight", 1.0);
		ALT_M_CRIT_DAMAGE_MOD_SIGEL_HELL_KNIGHT = formulasSettings.getProperty("mCritModifierSigetHellKnight", 1.0);
		ALT_M_CRIT_DAMAGE_MOD_SIGEL_EVAS_TEMPLAR = formulasSettings.getProperty("mCritModifierSigelEvasTemplar", 1.0);
		ALT_M_CRIT_DAMAGE_MOD_SIGEL_SHILLIEN_TEMPLAR = formulasSettings.getProperty("mCritModifierSigelShillienTemplar", 1.0);
		ALT_M_CRIT_DAMAGE_MOD_TYR_DUELIST = formulasSettings.getProperty("mCritModifierTyrDuelist", 1.0);
		ALT_M_CRIT_DAMAGE_MOD_TYR_DREADNOUGHT = formulasSettings.getProperty("mCritModifierTyrDreadnought", 1.0);
		ALT_M_CRIT_DAMAGE_MOD_TYR_TITAN = formulasSettings.getProperty("mCritModifierTyrTitan", 1.0);
		ALT_M_CRIT_DAMAGE_MOD_TYR_GRAND_KHAVATARI = formulasSettings.getProperty("mCritModifierTyrGrandKhavatari", 1.0);
		ALT_M_CRIT_DAMAGE_MOD_TYR_MAESTRO = formulasSettings.getProperty("mCritModifierTyrMaestro", 1.0);
		ALT_M_CRIT_DAMAGE_MOD_TYR_DOOMBRINGER = formulasSettings.getProperty("mCritModifierTyrDoomBringer", 1.0);
		ALT_M_CRIT_DAMAGE_MOD_OTHELL_ADVENTURER = formulasSettings.getProperty("mCritModifierOthellAdventurer", 1.0);
		ALT_M_CRIT_DAMAGE_MOD_OTHELL_WIND_RIDER = formulasSettings.getProperty("mCritModifierOthellWindRider", 1.0);
		ALT_M_CRIT_DAMAGE_MOD_OTHELL_GHOST_HUNTER = formulasSettings.getProperty("mCritModifierOthellGhostHunter", 1.0);
		ALT_M_CRIT_DAMAGE_MOD_OTHELL_FORTUNE_SEEKER = formulasSettings.getProperty("mCritModifierOthellFortuneSeeker", 1.0);
		ALT_M_CRIT_DAMAGE_MOD_YR_SAGITTARIUS = formulasSettings.getProperty("mCritModifierYurSagitarius", 1.0);
		ALT_M_CRIT_DAMAGE_MOD_YR_MOONLIGHT_SENTINEL = formulasSettings.getProperty("mCritModifierYurMoonLightSentinel", 1.0);
		ALT_M_CRIT_DAMAGE_MOD_YR_GHOST_SENTINEL = formulasSettings.getProperty("mCritModifierYurGhostSentinel", 1.0);
		ALT_M_CRIT_DAMAGE_MOD_YR_TRICKSTER = formulasSettings.getProperty("mCritModifierYurTrickster", 1.0);
		ALT_M_CRIT_DAMAGE_MOD_FEOH_ARCHMAGE = formulasSettings.getProperty("mCritModifierFeohArchMage", 1.0);
		ALT_M_CRIT_DAMAGE_MOD_FEOH_SOULTAKER = formulasSettings.getProperty("mCritModifierFeohSoultaker", 1.0);
		ALT_M_CRIT_DAMAGE_MOD_FEOH_MYSTIC_MUSE = formulasSettings.getProperty("mCritModifierFeohMysticMuse", 1.0);
		ALT_M_CRIT_DAMAGE_MOD_FEOH_STORM_SCREAMER = formulasSettings.getProperty("mCritModifierFeohStormScreamer", 1.0);
		ALT_M_CRIT_DAMAGE_MOD_FEOH_SOUL_HOUND = formulasSettings.getProperty("mCritModifierFeohSoulHound", 1.0);
		ALT_M_CRIT_DAMAGE_MOD_ISS_HIEROPHANT = formulasSettings.getProperty("mCritModifierIssHierophant", 1.0);
		ALT_M_CRIT_DAMAGE_MOD_ISS_SWORD_MUSE = formulasSettings.getProperty("mCritModifierIssSwordMuse", 1.0);
		ALT_M_CRIT_DAMAGE_MOD_ISS_SPECTRAL_DANCER = formulasSettings.getProperty("mCritModifierIssSpectralDancer", 1.0);
		ALT_M_CRIT_DAMAGE_MOD_ISS_DOMINATOR = formulasSettings.getProperty("mCritModifierIssDominator", 1.0);
		ALT_M_CRIT_DAMAGE_MOD_ISS_DOOMCRYER = formulasSettings.getProperty("mCritModifierIssDoomCryer", 1.0);
		ALT_M_CRIT_DAMAGE_MOD_WYNN_ARCANA_LORD = formulasSettings.getProperty("mCritModifierWynnArcanaLord", 1.0);
		ALT_M_CRIT_DAMAGE_MOD_WYNN_ELEMENTAL_MASTER = formulasSettings.getProperty("mCritModifierWynnElementalMaster", 1.0);
		ALT_M_CRIT_DAMAGE_MOD_WYNN_SPECTRAL_MASTER = formulasSettings.getProperty("mCritModifierWynnSpectralMaster", 1.0);
		ALT_M_CRIT_DAMAGE_MOD_AEORE_CARDINAL = formulasSettings.getProperty("mCritModifierAeoreCardinal", 1.0);
		ALT_M_CRIT_DAMAGE_MOD_AEORE_EVAS_SAINT = formulasSettings.getProperty("mCritModifierAeoreEvasSaint", 1.0);
		ALT_M_CRIT_DAMAGE_MOD_AEORE_SHILLIEN_SAINT = formulasSettings.getProperty("mCritModifierAeoreShillenSaint", 1.0);
		ALT_M_CRIT_DAMAGE_MOD_EVISCERATOR = formulasSettings.getProperty("mCritModifierEviscerator", 1.0);
		ALT_M_CRIT_DAMAGE_MOD_SAHYAS_SEER = formulasSettings.getProperty("mCritModifierSahyasSeer", 1.0);

		ALT_P_CRIT_DAMAGE_MOD = formulasSettings.getProperty("pCritModifier", 1.0);
		ALT_P_CRIT_DAMAGE_MOD_SIGEL = formulasSettings.getProperty("pCritModifierSigel", 1.0);
		ALT_P_CRIT_DAMAGE_MOD_TIR_WARRIOR = formulasSettings.getProperty("pCritModifierTyrWarrior", 1.0);
		ALT_P_CRIT_DAMAGE_MOD_OTHEL_ROGUE = formulasSettings.getProperty("pCritModifierOthelRogue", 1.0);
		ALT_P_CRIT_DAMAGE_MOD_YR_ARCHER = formulasSettings.getProperty("pCritModifierYrArcher", 1.0);
		ALT_P_CRIT_DAMAGE_MOD_FEO_WIZZARD = formulasSettings.getProperty("pCritModifierFeoWizzard", 1.0);
		ALT_P_CRIT_DAMAGE_MOD_ISS_ENCHANTER = formulasSettings.getProperty("pCritModifierIssEnchanter", 1.0);
		ALT_P_CRIT_DAMAGE_MOD_WYN_SUMMONER = formulasSettings.getProperty("pCritModifierWynSummoner", 1.0);
		ALT_P_CRIT_DAMAGE_MOD_EOL_HEALER = formulasSettings.getProperty("pCritModifierEolHealer", 1.0);
		//new
		ALT_P_CRIT_DAMAGE_MOD_SIGEL_PHOENIX_KNIGHT = formulasSettings.getProperty("pCritModifierSigelPhoenixKnight", 1.0);
		ALT_P_CRIT_DAMAGE_MOD_SIGEL_HELL_KNIGHT = formulasSettings.getProperty("pCritModifierSigetHellKnight", 1.0);
		ALT_P_CRIT_DAMAGE_MOD_SIGEL_EVAS_TEMPLAR = formulasSettings.getProperty("pCritModifierSigelEvasTemplar", 1.0);
		ALT_P_CRIT_DAMAGE_MOD_SIGEL_SHILLIEN_TEMPLAR = formulasSettings.getProperty("pCritModifierSigelShillienTemplar", 1.0);
		ALT_P_CRIT_DAMAGE_MOD_TYR_DUELIST = formulasSettings.getProperty("pCritModifierTyrDuelist", 1.0);
		ALT_P_CRIT_DAMAGE_MOD_TYR_DREADNOUGHT = formulasSettings.getProperty("pCritModifierTyrDreadnought", 1.0);
		ALT_P_CRIT_DAMAGE_MOD_TYR_TITAN = formulasSettings.getProperty("pCritModifierTyrTitan", 1.0);
		ALT_P_CRIT_DAMAGE_MOD_TYR_GRAND_KHAVATARI = formulasSettings.getProperty("pCritModifierTyrGrandKhavatari", 1.0);
		ALT_P_CRIT_DAMAGE_MOD_TYR_MAESTRO = formulasSettings.getProperty("pCritModifierTyrMaestro", 1.0);
		ALT_P_CRIT_DAMAGE_MOD_TYR_DOOMBRINGER = formulasSettings.getProperty("pCritModifierTyrDoomBringer", 1.0);
		ALT_P_CRIT_DAMAGE_MOD_OTHELL_ADVENTURER = formulasSettings.getProperty("pCritModifierOthellAdventurer", 1.0);
		ALT_P_CRIT_DAMAGE_MOD_OTHELL_WIND_RIDER = formulasSettings.getProperty("pCritModifierOthellWindRider", 1.0);
		ALT_P_CRIT_DAMAGE_MOD_OTHELL_GHOST_HUNTER = formulasSettings.getProperty("pCritModifierOthellGhostHunter", 1.0);
		ALT_P_CRIT_DAMAGE_MOD_OTHELL_FORTUNE_SEEKER = formulasSettings.getProperty("pCritModifierOthellFortuneSeeker", 1.0);
		ALT_P_CRIT_DAMAGE_MOD_YR_SAGITTARIUS = formulasSettings.getProperty("pCritModifierYurSagitarius", 1.0);
		ALT_P_CRIT_DAMAGE_MOD_YR_MOONLIGHT_SENTINEL = formulasSettings.getProperty("pCritModifierYurMoonLightSentinel", 1.0);
		ALT_P_CRIT_DAMAGE_MOD_YR_GHOST_SENTINEL = formulasSettings.getProperty("pCritModifierYurGhostSentinel", 1.0);
		ALT_P_CRIT_DAMAGE_MOD_YR_TRICKSTER = formulasSettings.getProperty("pCritModifierYurTrickster", 1.0);
		ALT_P_CRIT_DAMAGE_MOD_FEOH_ARCHMAGE = formulasSettings.getProperty("pCritModifierFeohArchMage", 1.0);
		ALT_P_CRIT_DAMAGE_MOD_FEOH_SOULTAKER = formulasSettings.getProperty("pCritModifierFeohSoultaker", 1.0);
		ALT_P_CRIT_DAMAGE_MOD_FEOH_MYSTIC_MUSE = formulasSettings.getProperty("pCritModifierFeohMysticMuse", 1.0);
		ALT_P_CRIT_DAMAGE_MOD_FEOH_STORM_SCREAMER = formulasSettings.getProperty("pCritModifierFeohStormScreamer", 1.0);
		ALT_P_CRIT_DAMAGE_MOD_FEOH_SOUL_HOUND = formulasSettings.getProperty("pCritModifierFeohSoulHound", 1.0);
		ALT_P_CRIT_DAMAGE_MOD_ISS_HIEROPHANT = formulasSettings.getProperty("pCritModifierIssHierophant", 1.0);
		ALT_P_CRIT_DAMAGE_MOD_ISS_SWORD_MUSE = formulasSettings.getProperty("pCritModifierIssSwordMuse", 1.0);
		ALT_P_CRIT_DAMAGE_MOD_ISS_SPECTRAL_DANCER = formulasSettings.getProperty("pCritModifierIssSpectralDancer", 1.0);
		ALT_P_CRIT_DAMAGE_MOD_ISS_DOMINATOR = formulasSettings.getProperty("pCritModifierIssDominator", 1.0);
		ALT_P_CRIT_DAMAGE_MOD_ISS_DOOMCRYER = formulasSettings.getProperty("pCritModifierIssDoomCryer", 1.0);
		ALT_P_CRIT_DAMAGE_MOD_WYNN_ARCANA_LORD = formulasSettings.getProperty("pCritModifierWynnArcanaLord", 1.0);
		ALT_P_CRIT_DAMAGE_MOD_WYNN_ELEMENTAL_MASTER = formulasSettings.getProperty("pCritModifierWynnElementalMaster", 1.0);
		ALT_P_CRIT_DAMAGE_MOD_WYNN_SPECTRAL_MASTER = formulasSettings.getProperty("pCritModifierWynnSpectralMaster", 1.0);
		ALT_P_CRIT_DAMAGE_MOD_AEORE_CARDINAL = formulasSettings.getProperty("pCritModifierAeoreCardinal", 1.0);
		ALT_P_CRIT_DAMAGE_MOD_AEORE_EVAS_SAINT = formulasSettings.getProperty("pCritModifierAeoreEvasSaint", 1.0);
		ALT_P_CRIT_DAMAGE_MOD_AEORE_SHILLIEN_SAINT = formulasSettings.getProperty("pCritModifierAeoreShillenSaint", 1.0);
		ALT_P_CRIT_DAMAGE_MOD_EVISCERATOR = formulasSettings.getProperty("pCritModifierEviscerator", 1.0);
		ALT_P_CRIT_DAMAGE_MOD_SAHYAS_SEER = formulasSettings.getProperty("pCritModifierSahyasSeer", 1.0);
		
		//fiz only
		ALT_P_CRIT_DAMAGE_MOD_SIGEL_FIZ = formulasSettings.getProperty("pCritModifierSigelFizOnly", 1.0);	
		ALT_P_CRIT_DAMAGE_MOD_TIR_WARRIOR_FIZ = formulasSettings.getProperty("pCritModifierTyrFizOnly", 1.0);	
		ALT_P_CRIT_DAMAGE_MOD_OTHEL_ROGUE_FIZ = formulasSettings.getProperty("pCritModifierOthelFizOnly", 1.0);	
		ALT_P_CRIT_DAMAGE_MOD_YR_ARCHER_FIZ = formulasSettings.getProperty("pCritModifierYrArcherFizOnly", 1.0);	
		ALT_P_CRIT_DAMAGE_MOD_SIGEL_PHOENIX_KNIGHT_FIZ = formulasSettings.getProperty("pCritModifierSigelPhoenixFizOnly", 1.0);	
		ALT_P_CRIT_DAMAGE_MOD_SIGEL_HELL_KNIGHT_FIZ = formulasSettings.getProperty("pCritModifierSigelHellKnightFizOnly", 1.0);	
		ALT_P_CRIT_DAMAGE_MOD_SIGEL_EVAS_TEMPLAR_FIZ = formulasSettings.getProperty("pCritModifierSigelEvasTemplarFizOnly", 1.0);	
		ALT_P_CRIT_DAMAGE_MOD_SIGEL_SHILLIEN_TEMPLAR_FIZ = formulasSettings.getProperty("pCritModifierSigelShillenTemplarFizOnly", 1.0);	
		ALT_P_CRIT_DAMAGE_MOD_TYR_DUELIST_FIZ = formulasSettings.getProperty("pCritModifierTyrDuelistFizOnly", 1.0);	
		ALT_P_CRIT_DAMAGE_MOD_TYR_DREADNOUGHT_FIZ = formulasSettings.getProperty("pCritModifierTyrDreadnoughtFizOnly", 1.0);	
		ALT_P_CRIT_DAMAGE_MOD_TYR_TITAN_FIZ = formulasSettings.getProperty("pCritModifierTyrTitanFizOnly", 1.0);	
		ALT_P_CRIT_DAMAGE_MOD_TYR_GRAND_KHAVATARI_FIZ = formulasSettings.getProperty("pCritModifierTyrGrandKhavatariFizOnly", 1.0);	
		ALT_P_CRIT_DAMAGE_MOD_TYR_MAESTRO_FIZ = formulasSettings.getProperty("pCritModifierTyrMaestroFizOnly", 1.0);	
		ALT_P_CRIT_DAMAGE_MOD_TYR_DOOMBRINGER_FIZ = formulasSettings.getProperty("pCritModifierTyrDoombridgerFizOnly", 1.0);	
		ALT_P_CRIT_DAMAGE_MOD_OTHELL_ADVENTURER_FIZ = formulasSettings.getProperty("pCritModifierOthelAdventurerFizOnly", 1.0);	
		ALT_P_CRIT_DAMAGE_MOD_OTHELL_WIND_RIDER_FIZ = formulasSettings.getProperty("pCritModifierOthelWindriderFizOnly", 1.0);	
		ALT_P_CRIT_DAMAGE_MOD_OTHELL_GHOST_HUNTER_FIZ = formulasSettings.getProperty("pCritModifierOthelGhostHunterFizOnly", 1.0);	
		ALT_P_CRIT_DAMAGE_MOD_OTHELL_FORTUNE_SEEKER_FIZ = formulasSettings.getProperty("pCritModifierOthelFortuneseekerFizOnly", 1.0);	
		ALT_P_CRIT_DAMAGE_MOD_YR_SAGITTARIUS_FIZ = formulasSettings.getProperty("pCritModifierYurSagitariusFizOnly", 1.0);	
		ALT_P_CRIT_DAMAGE_MOD_YR_MOONLIGHT_SENTINEL_FIZ = formulasSettings.getProperty("pCritModifierYurMoonLightSentinelFizOnly", 1.0);	
		ALT_P_CRIT_DAMAGE_MOD_YR_GHOST_SENTINEL_FIZ = formulasSettings.getProperty("pCritModifierYurGhostSentinelFizOnly", 1.0);	
		ALT_P_CRIT_DAMAGE_MOD_YR_TRICKSTER_FIZ = formulasSettings.getProperty("pCritModifierYurTricksterFizOnly", 1.0);	
		ALT_P_CRIT_DAMAGE_MOD_FEOH_SOUL_HOUND_FIZ = formulasSettings.getProperty("pCritModifierFeohSoulHoundFizOnly", 1.0);	
		ALT_P_CRIT_DAMAGE_MOD_ISS_DOMINATOR_FIZ = formulasSettings.getProperty("pCritModifierIssDominatorFizOnly", 1.0);
		ALT_P_CRIT_DAMAGE_MOD_ISS_DOOMCRYER_FIZ = formulasSettings.getProperty("pCritModifierIssDoomCryerFizOnly", 1.0);
		ALT_P_CRIT_DAMAGE_MOD_EVISCERATOR_FIZ = formulasSettings.getProperty("pCritModifierEvisceratorFizOnly", 1.0);
		ALT_P_CRIT_DAMAGE_MOD_SAHYAS_SEER_FIZ = formulasSettings.getProperty("pCritModifierSahyasSeerFizOnly", 1.0);
		
		ALT_P_CRIT_CHANCE_MOD = formulasSettings.getProperty("pCritModifierChance", 1.0);
		ALT_P_CRIT_CHANCE_MOD_SIGEL = formulasSettings.getProperty("pCritModifierSigelChance", 1.0);
		ALT_P_CRIT_CHANCE_MOD_TIR_WARRIOR = formulasSettings.getProperty("pCritModifierTyrWarriorChance", 1.0);
		ALT_P_CRIT_CHANCE_MOD_OTHEL_ROGUE = formulasSettings.getProperty("pCritModifierOthelRogueChance", 1.0);
		ALT_P_CRIT_CHANCE_MOD_YR_ARCHER = formulasSettings.getProperty("pCritModifierYrArcherChance", 1.0);
		ALT_P_CRIT_CHANCE_MOD_FEO_WIZZARD = formulasSettings.getProperty("pCritModifierFeoWizzardChance", 1.0);
		ALT_P_CRIT_CHANCE_MOD_ISS_ENCHANTER = formulasSettings.getProperty("pCritModifierIssEnchanterChance", 1.0);
		ALT_P_CRIT_CHANCE_MOD_WYN_SUMMONER = formulasSettings.getProperty("pCritModifierWynSummonerChance", 1.0);
		ALT_P_CRIT_CHANCE_MOD_EOL_HEALER = formulasSettings.getProperty("pCritModifierEolHealerChance", 1.0);		
		//new
		ALT_P_CRIT_CHANCE_MOD_SIGEL_PHOENIX_KNIGHT = formulasSettings.getProperty("pCritModifierSigelPhoenixKnightChance", 1.0);
		ALT_P_CRIT_CHANCE_MOD_SIGEL_HELL_KNIGHT = formulasSettings.getProperty("pCritModifierSigetHellKnightChance", 1.0);
		ALT_P_CRIT_CHANCE_MOD_SIGEL_EVAS_TEMPLAR = formulasSettings.getProperty("pCritModifierSigelEvasTemplarChance", 1.0);
		ALT_P_CRIT_CHANCE_MOD_SIGEL_SHILLIEN_TEMPLAR = formulasSettings.getProperty("pCritModifierSigelShillienTemplarChance", 1.0);
		ALT_P_CRIT_CHANCE_MOD_TYR_DUELIST = formulasSettings.getProperty("pCritModifierTyrDuelistChance", 1.0);
		ALT_P_CRIT_CHANCE_MOD_TYR_DREADNOUGHT = formulasSettings.getProperty("pCritModifierTyrDreadnoughtChance", 1.0);
		ALT_P_CRIT_CHANCE_MOD_TYR_TITAN = formulasSettings.getProperty("pCritModifierTyrTitanChance", 1.0);
		ALT_P_CRIT_CHANCE_MOD_TYR_GRAND_KHAVATARI = formulasSettings.getProperty("pCritModifierTyrGrandKhavatariChance", 1.0);
		ALT_P_CRIT_CHANCE_MOD_TYR_MAESTRO = formulasSettings.getProperty("pCritModifierTyrMaestroChance", 1.0);
		ALT_P_CRIT_CHANCE_MOD_TYR_DOOMBRINGER = formulasSettings.getProperty("pCritModifierTyrDoomBringerChance", 1.0);
		ALT_P_CRIT_CHANCE_MOD_OTHELL_ADVENTURER = formulasSettings.getProperty("pCritModifierOthellAdventurerChance", 1.0);
		ALT_P_CRIT_CHANCE_MOD_OTHELL_WIND_RIDER = formulasSettings.getProperty("pCritModifierOthellWindRiderChance", 1.0);
		ALT_P_CRIT_CHANCE_MOD_OTHELL_GHOST_HUNTER = formulasSettings.getProperty("pCritModifierOthellGhostHunterChance", 1.0);
		ALT_P_CRIT_CHANCE_MOD_OTHELL_FORTUNE_SEEKER = formulasSettings.getProperty("pCritModifierOthellFortuneSeekerChance", 1.0);
		ALT_P_CRIT_CHANCE_MOD_YR_SAGITTARIUS = formulasSettings.getProperty("pCritModifierYurSagitariusChance", 1.0);
		ALT_P_CRIT_CHANCE_MOD_YR_MOONLIGHT_SENTINEL = formulasSettings.getProperty("pCritModifierYurMoonLightSentinelChance", 1.0);
		ALT_P_CRIT_CHANCE_MOD_YR_GHOST_SENTINEL = formulasSettings.getProperty("pCritModifierYurGhostSentinelChance", 1.0);
		ALT_P_CRIT_CHANCE_MOD_YR_TRICKSTER = formulasSettings.getProperty("pCritModifierYurTricksterChance", 1.0);
		ALT_P_CRIT_CHANCE_MOD_FEOH_ARCHMAGE = formulasSettings.getProperty("pCritModifierFeohArchMageChance", 1.0);
		ALT_P_CRIT_CHANCE_MOD_FEOH_SOULTAKER = formulasSettings.getProperty("pCritModifierFeohSoultakerChance", 1.0);
		ALT_P_CRIT_CHANCE_MOD_FEOH_MYSTIC_MUSE = formulasSettings.getProperty("pCritModifierFeohMysticMuseChance", 1.0);
		ALT_P_CRIT_CHANCE_MOD_FEOH_STORM_SCREAMER = formulasSettings.getProperty("pCritModifierFeohStormScreamerChance", 1.0);
		ALT_P_CRIT_CHANCE_MOD_FEOH_SOUL_HOUND = formulasSettings.getProperty("pCritModifierFeohSoulHoundChance", 1.0);
		ALT_P_CRIT_CHANCE_MOD_ISS_HIEROPHANT = formulasSettings.getProperty("pCritModifierIssHierophantChance", 1.0);
		ALT_P_CRIT_CHANCE_MOD_ISS_SWORD_MUSE = formulasSettings.getProperty("pCritModifierIssSwordMuseChance", 1.0);
		ALT_P_CRIT_CHANCE_MOD_ISS_SPECTRAL_DANCER = formulasSettings.getProperty("pCritModifierIssSpectralDancerChance", 1.0);
		ALT_P_CRIT_CHANCE_MOD_ISS_DOMINATOR = formulasSettings.getProperty("pCritModifierIssDominatorChance", 1.0);
		ALT_P_CRIT_CHANCE_MOD_ISS_DOOMCRYER = formulasSettings.getProperty("pCritModifierIssDoomCryerChance", 1.0);
		ALT_P_CRIT_CHANCE_MOD_WYNN_ARCANA_LORD = formulasSettings.getProperty("pCritModifierWynnArcanaLordChance", 1.0);
		ALT_P_CRIT_CHANCE_MOD_WYNN_ELEMENTAL_MASTER = formulasSettings.getProperty("pCritModifierWynnElementalMasterChance", 1.0);
		ALT_P_CRIT_CHANCE_MOD_WYNN_SPECTRAL_MASTER = formulasSettings.getProperty("pCritModifierWynnSpectralMasterChance", 1.0);
		ALT_P_CRIT_CHANCE_MOD_AEORE_CARDINAL = formulasSettings.getProperty("pCritModifierAeoreCardinalChance", 1.0);
		ALT_P_CRIT_CHANCE_MOD_AEORE_EVAS_SAINT = formulasSettings.getProperty("pCritModifierAeoreEvasSaintChance", 1.0);
		ALT_P_CRIT_CHANCE_MOD_AEORE_SHILLIEN_SAINT = formulasSettings.getProperty("pCritModifierAeoreShillenSaintChance", 1.0);
		ALT_P_CRIT_CHANCE_MOD_EVISCERATOR = formulasSettings.getProperty("pCritModifierEvisceratorChance", 1.0);
		ALT_P_CRIT_CHANCE_MOD_SAHYAS_SEER = formulasSettings.getProperty("pCritModifierSahyasSeerChance", 1.0);
		
		ALT_M_CRIT_CHANCE_MOD = formulasSettings.getProperty("mCritModifierChance", 1.0);
		ALT_M_CRIT_CHANCE_MOD_SIGEL = formulasSettings.getProperty("mCritModifierSigelChance", 1.0);
		ALT_M_CRIT_CHANCE_MOD_TIR_WARRIOR = formulasSettings.getProperty("mCritModifierTyrWarriorChance", 1.0);
		ALT_M_CRIT_CHANCE_MOD_OTHEL_ROGUE = formulasSettings.getProperty("mCritModifierOthelRogueChance", 1.0);
		ALT_M_CRIT_CHANCE_MOD_YR_ARCHER = formulasSettings.getProperty("mCritModifierYrArcherChance", 1.0);
		ALT_M_CRIT_CHANCE_MOD_FEO_WIZZARD = formulasSettings.getProperty("mCritModifierFeoWizzardChance", 1.0);
		ALT_M_CRIT_CHANCE_MOD_ISS_ENCHANTER = formulasSettings.getProperty("mCritModifierIssEnchanterChance", 1.0);
		ALT_M_CRIT_CHANCE_MOD_WYN_SUMMONER = formulasSettings.getProperty("mCritModifierWynSummonerChance", 1.0);
		ALT_M_CRIT_CHANCE_MOD_EOL_HEALER = formulasSettings.getProperty("mCritModifierEolHealerChance", 1.0);	
		//new
		ALT_M_CRIT_CHANCE_MOD_SIGEL_PHOENIX_KNIGHT = formulasSettings.getProperty("mCritModifierSigelPhoenixKnightChance", 1.0);
		ALT_M_CRIT_CHANCE_MOD_SIGEL_HELL_KNIGHT = formulasSettings.getProperty("mCritModifierSigetHellKnightChance", 1.0);
		ALT_M_CRIT_CHANCE_MOD_SIGEL_EVAS_TEMPLAR = formulasSettings.getProperty("mCritModifierSigelEvasTemplarChance", 1.0);
		ALT_M_CRIT_CHANCE_MOD_SIGEL_SHILLIEN_TEMPLAR = formulasSettings.getProperty("mCritModifierSigelShillienTemplarChance", 1.0);
		ALT_M_CRIT_CHANCE_MOD_TYR_DUELIST = formulasSettings.getProperty("mCritModifierTyrDuelistChance", 1.0);
		ALT_M_CRIT_CHANCE_MOD_TYR_DREADNOUGHT = formulasSettings.getProperty("mCritModifierTyrDreadnoughtChance", 1.0);
		ALT_M_CRIT_CHANCE_MOD_TYR_TITAN = formulasSettings.getProperty("mCritModifierTyrTitanChance", 1.0);
		ALT_M_CRIT_CHANCE_MOD_TYR_GRAND_KHAVATARI = formulasSettings.getProperty("mCritModifierTyrGrandKhavatariChance", 1.0);
		ALT_M_CRIT_CHANCE_MOD_TYR_MAESTRO = formulasSettings.getProperty("mCritModifierTyrMaestroChance", 1.0);
		ALT_M_CRIT_CHANCE_MOD_TYR_DOOMBRINGER = formulasSettings.getProperty("mCritModifierTyrDoomBringerChance", 1.0);
		ALT_M_CRIT_CHANCE_MOD_OTHELL_ADVENTURER = formulasSettings.getProperty("mCritModifierOthellAdventurerChance", 1.0);
		ALT_M_CRIT_CHANCE_MOD_OTHELL_WIND_RIDER = formulasSettings.getProperty("mCritModifierOthellWindRiderChance", 1.0);
		ALT_M_CRIT_CHANCE_MOD_OTHELL_GHOST_HUNTER = formulasSettings.getProperty("mCritModifierOthellGhostHunterChance", 1.0);
		ALT_M_CRIT_CHANCE_MOD_OTHELL_FORTUNE_SEEKER = formulasSettings.getProperty("mCritModifierOthellFortuneSeekerChance", 1.0);
		ALT_M_CRIT_CHANCE_MOD_YR_SAGITTARIUS = formulasSettings.getProperty("mCritModifierYurSagitariusChance", 1.0);
		ALT_M_CRIT_CHANCE_MOD_YR_MOONLIGHT_SENTINEL = formulasSettings.getProperty("mCritModifierYurMoonLightSentinelChance", 1.0);
		ALT_M_CRIT_CHANCE_MOD_YR_GHOST_SENTINEL = formulasSettings.getProperty("mCritModifierYurGhostSentinelChance", 1.0);
		ALT_M_CRIT_CHANCE_MOD_YR_TRICKSTER = formulasSettings.getProperty("mCritModifierYurTricksterChance", 1.0);
		ALT_M_CRIT_CHANCE_MOD_FEOH_ARCHMAGE = formulasSettings.getProperty("mCritModifierFeohArchMageChance", 1.0);
		ALT_M_CRIT_CHANCE_MOD_FEOH_SOULTAKER = formulasSettings.getProperty("mCritModifierFeohSoultakerChance", 1.0);
		ALT_M_CRIT_CHANCE_MOD_FEOH_MYSTIC_MUSE = formulasSettings.getProperty("mCritModifierFeohMysticMuseChance", 1.0);
		ALT_M_CRIT_CHANCE_MOD_FEOH_STORM_SCREAMER = formulasSettings.getProperty("mCritModifierFeohStormScreamerChance", 1.0);
		ALT_M_CRIT_CHANCE_MOD_FEOH_SOUL_HOUND = formulasSettings.getProperty("mCritModifierFeohSoulHoundChance", 1.0);
		ALT_M_CRIT_CHANCE_MOD_ISS_HIEROPHANT = formulasSettings.getProperty("mCritModifierIssHierophantChance", 1.0);
		ALT_M_CRIT_CHANCE_MOD_ISS_SWORD_MUSE = formulasSettings.getProperty("mCritModifierIssSwordMuseChance", 1.0);
		ALT_M_CRIT_CHANCE_MOD_ISS_SPECTRAL_DANCER = formulasSettings.getProperty("mCritModifierIssSpectralDancerChance", 1.0);
		ALT_M_CRIT_CHANCE_MOD_ISS_DOMINATOR = formulasSettings.getProperty("mCritModifierIssDominatorChance", 1.0);
		ALT_M_CRIT_CHANCE_MOD_ISS_DOOMCRYER = formulasSettings.getProperty("mCritModifierIssDoomCryerChance", 1.0);
		ALT_M_CRIT_CHANCE_MOD_WYNN_ARCANA_LORD = formulasSettings.getProperty("mCritModifierWynnArcanaLordChance", 1.0);
		ALT_M_CRIT_CHANCE_MOD_WYNN_ELEMENTAL_MASTER = formulasSettings.getProperty("mCritModifierWynnElementalMasterChance", 1.0);
		ALT_M_CRIT_CHANCE_MOD_WYNN_SPECTRAL_MASTER = formulasSettings.getProperty("mCritModifierWynnSpectralMasterChance", 1.0);
		ALT_M_CRIT_CHANCE_MOD_AEORE_CARDINAL = formulasSettings.getProperty("mCritModifierAeoreCardinalChance", 1.0);
		ALT_M_CRIT_CHANCE_MOD_AEORE_EVAS_SAINT = formulasSettings.getProperty("mCritModifierAeoreEvasSaintChance", 1.0);
		ALT_M_CRIT_CHANCE_MOD_AEORE_SHILLIEN_SAINT = formulasSettings.getProperty("mCritModifierAeoreShillenSaintChance", 1.0);
		ALT_M_CRIT_CHANCE_MOD_EVISCERATOR = formulasSettings.getProperty("mCritModifierEvisceratorChance", 1.0);
		ALT_M_CRIT_CHANCE_MOD_SAHYAS_SEER = formulasSettings.getProperty("mCritModifierSahyasSeerChance", 1.0);

		SERVITOR_P_ATK_MODIFIER = formulasSettings.getProperty("SERVITOR_P_ATK_MODIFIER", 1.0);
		SERVITOR_M_ATK_MODIFIER = formulasSettings.getProperty("SERVITOR_M_ATK_MODIFIER", 1.0);
		SERVITOR_P_DEF_MODIFIER = formulasSettings.getProperty("SERVITOR_P_DEF_MODIFIER", 1.0);
		SERVITOR_M_DEF_MODIFIER = formulasSettings.getProperty("SERVITOR_M_DEF_MODIFIER", 1.0);
		SERVITOR_P_SKILL_POWER_MODIFIER = formulasSettings.getProperty("SERVITOR_P_SKILL_POWER_MODIFIER", 1.0);
		SERVITOR_M_SKILL_POWER_MODIFIER = formulasSettings.getProperty("SERVITOR_M_SKILL_POWER_MODIFIER", 1.0);

		ALT_BLOW_DAMAGE_MOD = formulasSettings.getProperty("blowDamageModifier", 1.0);
		ALT_BLOW_CRIT_RATE_MODIFIER = formulasSettings.getProperty("blowCritRateModifier", 1.0);
		ALT_VAMPIRIC_CHANCE_MOD = formulasSettings.getProperty("vampiricChanceMod", 1.0);
		
		REFLECT_MIN_RANGE = formulasSettings.getProperty("ReflectMinimumRange", 600);
		REFLECT_AND_BLOCK_DAMAGE_CHANCE_CAP = formulasSettings.getProperty("reflectAndBlockDamCap", 60.);
		REFLECT_AND_BLOCK_PSKILL_DAMAGE_CHANCE_CAP = formulasSettings.getProperty("reflectAndBlockPSkillDamCap", 60.);
		REFLECT_AND_BLOCK_MSKILL_DAMAGE_CHANCE_CAP = formulasSettings.getProperty("reflectAndBlockMSkillDamCap", 60.);
		REFLECT_DAMAGE_PERCENT_CAP = formulasSettings.getProperty("reflectDamCap", 60.);
		REFLECT_BOW_DAMAGE_PERCENT_CAP = formulasSettings.getProperty("reflectBowDamCap", 60.);
		REFLECT_PSKILL_DAMAGE_PERCENT_CAP = formulasSettings.getProperty("reflectPSkillDamCap", 60.);
		REFLECT_MSKILL_DAMAGE_PERCENT_CAP = formulasSettings.getProperty("reflectMSkillDamCap", 60.);
		SPECIAL_CLASS_BOW_CROSS_BOW_PENALTY = formulasSettings.getProperty("specialClassesWeaponMagicSpeedPenalty", 1.);
		DISABLE_VAMPIRIC_VS_MOB_ON_PVP = formulasSettings.getProperty("disableVampiricAndDrainPvEInPvp", false);
		MIN_HIT_TIME = formulasSettings.getProperty("MinimumHitTime", -1);

		MAGIC_CRIT_DMG_MODIFIER = formulasSettings.getProperty("MagicCritDmgModifier", 1.0d);

		PHYSICAL_MIN_CHANCE_TO_HIT = formulasSettings.getProperty("PHYSICAL_MIN_CHANCE_TO_HIT", 27.5);
		PHYSICAL_MAX_CHANCE_TO_HIT = formulasSettings.getProperty("PHYSICAL_MAX_CHANCE_TO_HIT", 98.0);

		MAGIC_MIN_CHANCE_TO_HIT = formulasSettings.getProperty("MAGIC_MIN_CHANCE_TO_HIT", 72.5);
		MAGIC_MAX_CHANCE_TO_HIT = formulasSettings.getProperty("MAGIC_MAX_CHANCE_TO_HIT", 98.0);

		ENABLE_CRIT_DMG_REDUCTION_ON_MAGIC = formulasSettings.getProperty("ENABLE_CRIT_DMG_REDUCTION_ON_MAGIC", true);

		MAX_BLOW_RATE_ON_BEHIND = formulasSettings.getProperty("MAX_BLOW_RATE_ON_BEHIND", 100.);
		MAX_BLOW_RATE_ON_FRONT_AND_SIDE = formulasSettings.getProperty("MAX_BLOW_RATE_ON_FRONT_AND_SIDE", 80.);

		BLOW_SKILL_CHANCE_MOD_ON_BEHIND = formulasSettings.getProperty("BLOW_SKILL_CHANCE_MOD_ON_BEHIND", 5.);
		BLOW_SKILL_CHANCE_MOD_ON_FRONT = formulasSettings.getProperty("BLOW_SKILL_CHANCE_MOD_ON_FRONT", 4.);

		BLOW_SKILL_DEX_CHANCE_MOD = formulasSettings.getProperty("BLOW_SKILL_DEX_CHANCE_MOD", 1.);
		NORMAL_SKILL_DEX_CHANCE_MOD = formulasSettings.getProperty("NORMAL_SKILL_DEX_CHANCE_MOD", 1.);
		CRIT_STUN_BREAK_CHANCE = formulasSettings.getProperty("CriticalStunBreakChance", 75);
		NORMAL_STUN_BREAK_CHANCE = formulasSettings.getProperty("NormalStunBreakChance", 10);	
		
		EXCELLENT_SHIELD_BLOCK_CHANCE = formulasSettings.getProperty("ExcellentShieldBlockChance", 5);
		EXCELLENT_SHIELD_BLOCK_RECEIVED_DAMAGE = formulasSettings.getProperty("ExcellentShieldBlockDamage", 1);
		
		SKILLS_CAST_TIME_MIN_PHYSICAL = formulasSettings.getProperty("MinCastTimePhysical", 396);
		SKILLS_CAST_TIME_MIN_MAGICAL = formulasSettings.getProperty("MinCastTimeMagical", 333);
		PHYS_ATK_REUSE_MIN = formulasSettings.getProperty("PhysAtkReuseMin", 111);
		ENABLE_CRIT_HEIGHT_BONUS = formulasSettings.getProperty("EnableCritHeightBonus", true);
		
		ENABLE_STUN_BREAK_ON_ATTACK = formulasSettings.getProperty("EnableStunBreakOnAttack", true);	
		CRIT_STUN_BREAK_CHANCE_ON_MAGICAL_SKILL = formulasSettings.getProperty("CritStunBreakChanceOnMagicSkill", 66.67);
		NORMAL_STUN_BREAK_CHANCE_ON_MAGICAL_SKILL = formulasSettings.getProperty("NormalStunBreakChanceOnMagicSkill", 33.33);
		CRIT_STUN_BREAK_CHANCE_ON_PHYSICAL_SKILL = formulasSettings.getProperty("CritStunBreakChanceOnPhysSkill", 66.67);
		NORMAL_STUN_BREAK_CHANCE_ON_PHYSICAL_SKILL = formulasSettings.getProperty("NormalStunBreakChanceOnPhysSkill", 33.33);
		CRIT_STUN_BREAK_CHANCE_ON_REGULAR_HIT = formulasSettings.getProperty("CritStunBreakOnRegularHit", 33.33);
		NORMAL_STUN_BREAK_CHANCE_ON_REGULAR_HIT = formulasSettings.getProperty("NormalStunBreakOnRegularHit", 16.67);

		LUC_BONUS_MODIFIER = formulasSettings.getProperty("LUC_BONUS_MODIFIER", 1.);

		ALCHEMY_MIX_CUBE_MODIFIER = formulasSettings.getProperty("ALCHEMY_MIX_CUBE_MODIFIER", 1.);

		CANCEL_SKILLS_HIGH_CHANCE_CAP = formulasSettings.getProperty("CANCEL_SKILLS_HIGH_CHANCE_CAP", 75);
		CANCEL_SKILLS_LOW_CHANCE_CAP = formulasSettings.getProperty("CANCEL_SKILLS_LOW_CHANCE_CAP", 25);

		SP_LIMIT = formulasSettings.getProperty("SP_LIMIT", 50000000000L);

		ELEMENT_ATTACK_LIMIT = formulasSettings.getProperty("ELEMENT_ATTACK_LIMIT", 9999);
		ELEMENT_DEFENCE_LIMIT = formulasSettings.getProperty("ELEMENT_DEFENCE_LIMIT", 9999);

		USE_CUSTOM_ATTACK_TRAITS = formulasSettings.getProperty("UseCustomAttackTraits", false);
		USE_CUSTOM_DEFENCE_TRAITS = formulasSettings.getProperty("UseCustomDefenceTraits", false);
		ATTACK_TRAIT_WEAPON_MOD = formulasSettings.getProperty("CustomAttackTraitWeaponMod", 1.);
		DEFENCE_TRAIT_WEAPON_MOD = formulasSettings.getProperty("CustomDefenceTraitWeaponMod", 1.);

		ATTACK_TRAIT_POISON_MOD = formulasSettings.getProperty("ATTACK_TRAIT_POISON_MOD", 1.);
		DEFENCE_TRAIT_POISON_MOD = formulasSettings.getProperty("DEFENCE_TRAIT_POISON_MOD", 1.);
		ATTACK_TRAIT_HOLD_MOD = formulasSettings.getProperty("ATTACK_TRAIT_HOLD_MOD", 1.);
		DEFENCE_TRAIT_HOLD_MOD = formulasSettings.getProperty("DEFENCE_TRAIT_HOLD_MOD", 1.);
		ATTACK_TRAIT_BLEED_MOD = formulasSettings.getProperty("ATTACK_TRAIT_BLEED_MOD", 1.);
		DEFENCE_TRAIT_BLEED_MOD = formulasSettings.getProperty("DEFENCE_TRAIT_BLEED_MOD", 1.);
		ATTACK_TRAIT_SLEEP_MOD = formulasSettings.getProperty("ATTACK_TRAIT_SLEEP_MOD", 1.);
		DEFENCE_TRAIT_SLEEP_MOD = formulasSettings.getProperty("DEFENCE_TRAIT_SLEEP_MOD", 1.);
		ATTACK_TRAIT_SHOCK_MOD = formulasSettings.getProperty("ATTACK_TRAIT_SHOCK_MOD", 1.);
		DEFENCE_TRAIT_SHOCK_MOD = formulasSettings.getProperty("DEFENCE_TRAIT_SHOCK_MOD", 1.);
		ATTACK_TRAIT_DERANGEMENT_MOD = formulasSettings.getProperty("ATTACK_TRAIT_DERANGEMENT_MOD", 1.);
		DEFENCE_TRAIT_DERANGEMENT_MOD = formulasSettings.getProperty("DEFENCE_TRAIT_DERANGEMENT_MOD", 1.);
		ATTACK_TRAIT_PARALYZE_MOD = formulasSettings.getProperty("ATTACK_TRAIT_PARALYZE_MOD", 1.);
		DEFENCE_TRAIT_PARALYZE_MOD = formulasSettings.getProperty("DEFENCE_TRAIT_PARALYZE_MOD", 1.);
		ATTACK_TRAIT_BOSS_MOD = formulasSettings.getProperty("ATTACK_TRAIT_BOSS_MOD", 1.);
		DEFENCE_TRAIT_BOSS_MOD = formulasSettings.getProperty("DEFENCE_TRAIT_BOSS_MOD", 1.);
		ATTACK_TRAIT_DEATH_MOD = formulasSettings.getProperty("ATTACK_TRAIT_DEATH_MOD", 1.);
		DEFENCE_TRAIT_DEATH_MOD = formulasSettings.getProperty("DEFENCE_TRAIT_DEATH_MOD", 1.);
		ATTACK_TRAIT_ROOT_PHYSICALLY_MOD = formulasSettings.getProperty("ATTACK_TRAIT_ROOT_PHYSICALLY_MOD", 1.);
		DEFENCE_TRAIT_ROOT_PHYSICALLY_MOD = formulasSettings.getProperty("DEFENCE_TRAIT_ROOT_PHYSICALLY_MOD", 1.);
		ATTACK_TRAIT_TURN_STONE_MOD = formulasSettings.getProperty("ATTACK_TRAIT_TURN_STONE_MOD", 1.);
		DEFENCE_TRAIT_TURN_STONE_MOD = formulasSettings.getProperty("DEFENCE_TRAIT_TURN_STONE_MOD", 1.);
		ATTACK_TRAIT_GUST_MOD = formulasSettings.getProperty("ATTACK_TRAIT_GUST_MOD", 1.);
		DEFENCE_TRAIT_GUST_MOD = formulasSettings.getProperty("DEFENCE_TRAIT_GUST_MOD", 1.);
		ATTACK_TRAIT_PHYSICAL_BLOCKADE_MOD = formulasSettings.getProperty("ATTACK_TRAIT_PHYSICAL_BLOCKADE_MOD", 1.);
		DEFENCE_TRAIT_PHYSICAL_BLOCKADE_MOD = formulasSettings.getProperty("DEFENCE_TRAIT_PHYSICAL_BLOCKADE_MOD", 1.);
		ATTACK_TRAIT_TARGET_MOD = formulasSettings.getProperty("ATTACK_TRAIT_TARGET_MOD", 1.);
		DEFENCE_TRAIT_TARGET_MOD = formulasSettings.getProperty("DEFENCE_TRAIT_TARGET_MOD", 1.);
		ATTACK_TRAIT_PHYSICAL_WEAKNESS_MOD = formulasSettings.getProperty("ATTACK_TRAIT_PHYSICAL_WEAKNESS_MOD", 1.);
		DEFENCE_TRAIT_PHYSICAL_WEAKNESS_MOD = formulasSettings.getProperty("DEFENCE_TRAIT_PHYSICAL_WEAKNESS_MOD", 1.);
		ATTACK_TRAIT_MAGICAL_WEAKNESS_MOD = formulasSettings.getProperty("ATTACK_TRAIT_MAGICAL_WEAKNESS_MOD", 1.);
		DEFENCE_TRAIT_MAGICAL_WEAKNESS_MOD = formulasSettings.getProperty("DEFENCE_TRAIT_MAGICAL_WEAKNESS_MOD", 1.);
		ATTACK_TRAIT_KNOCKBACK_MOD = formulasSettings.getProperty("ATTACK_TRAIT_KNOCKBACK_MOD", 1.);
		DEFENCE_TRAIT_KNOCKBACK_MOD = formulasSettings.getProperty("DEFENCE_TRAIT_KNOCKBACK_MOD", 1.);
		ATTACK_TRAIT_KNOCKDOWN_MOD = formulasSettings.getProperty("ATTACK_TRAIT_KNOCKDOWN_MOD", 1.);
		DEFENCE_TRAIT_KNOCKDOWN_MOD = formulasSettings.getProperty("DEFENCE_TRAIT_KNOCKDOWN_MOD", 1.);
		ATTACK_TRAIT_PULL_MOD = formulasSettings.getProperty("ATTACK_TRAIT_PULL_MOD", 1.);
		DEFENCE_TRAIT_PULL_MOD = formulasSettings.getProperty("DEFENCE_TRAIT_PULL_MOD", 1.);
		ATTACK_TRAIT_HATE_MOD = formulasSettings.getProperty("ATTACK_TRAIT_HATE_MOD", 1.);
		DEFENCE_TRAIT_HATE_MOD = formulasSettings.getProperty("DEFENCE_TRAIT_HATE_MOD", 1.);
		ATTACK_TRAIT_AGGRESSION_MOD = formulasSettings.getProperty("ATTACK_TRAIT_AGGRESSION_MOD", 1.);
		DEFENCE_TRAIT_AGGRESSION_MOD = formulasSettings.getProperty("DEFENCE_TRAIT_AGGRESSION_MOD", 1.);
		ATTACK_TRAIT_AIRBIND_MOD = formulasSettings.getProperty("ATTACK_TRAIT_AIRBIND_MOD", 1.);
		DEFENCE_TRAIT_AIRBIND_MOD = formulasSettings.getProperty("DEFENCE_TRAIT_AIRBIND_MOD", 1.);
		ATTACK_TRAIT_DISARM_MOD = formulasSettings.getProperty("ATTACK_TRAIT_DISARM_MOD", 1.);
		DEFENCE_TRAIT_DISARM_MOD = formulasSettings.getProperty("DEFENCE_TRAIT_DISARM_MOD", 1.);
		ATTACK_TRAIT_DEPORT_MOD = formulasSettings.getProperty("ATTACK_TRAIT_DEPORT_MOD", 1.);
		DEFENCE_TRAIT_DEPORT_MOD = formulasSettings.getProperty("DEFENCE_TRAIT_DEPORT_MOD", 1.);
		ATTACK_TRAIT_CHANGEBODY_MOD = formulasSettings.getProperty("ATTACK_TRAIT_CHANGEBODY_MOD", 1.);
		DEFENCE_TRAIT_CHANGEBODY_MOD = formulasSettings.getProperty("DEFENCE_TRAIT_CHANGEBODY_MOD", 1.);
	}

	public static void loadDevelopSettings()
	{
		ExProperties properties = load(DEVELOP_FILE);
	}

	public static void loadExtSettings()
	{
		ExProperties properties = load(EXT_FILE);

		EX_NEW_PETITION_SYSTEM = properties.getProperty("NewPetitionSystem", false);
		EX_JAPAN_MINIGAME = properties.getProperty("JapanMinigame", false);
		EX_LECTURE_MARK = properties.getProperty("LectureMark", false);

		EX_SECOND_AUTH_ENABLED = properties.getProperty("SecondAuthEnabled", false);
		EX_SECOND_AUTH_MAX_ATTEMPTS = properties.getProperty("SecondAuthMaxAttempts", 5);
		EX_SECOND_AUTH_BAN_TIME = properties.getProperty("SecondAuthBanTime", 480);

		EX_USE_QUEST_REWARD_PENALTY_PER = properties.getProperty("UseQuestRewardPenaltyPer", false);
		EX_F2P_QUEST_REWARD_PENALTY_PER = properties.getProperty("F2PQuestRewardPenaltyPer", 0);
		EX_F2P_QUEST_REWARD_PENALTY_QUESTS = new TIntHashSet();
		EX_F2P_QUEST_REWARD_PENALTY_QUESTS.addAll(properties.getProperty("F2PQuestRewardPenaltyQuests", new int[0]));

		VIP_ATTENDANCE_REWARDS_ENABLED = properties.getProperty("UseVIPAttendance", false);

		EX_USE_AUTO_SOUL_SHOT = properties.getProperty("UseAutoSoulShot", true);

		ALLOW_CLASSIC_AUTO_SHOTS = properties.getProperty("allowClassicAutoShots", true);
		SOULSHOT_ID = properties.getProperty("SoulShotId", 0);
		SPIRIT_SHOT_ID  = properties.getProperty("SpiritShotId", 0);
		BLESS_SPIRIT_SHOT_ID = properties.getProperty("BlessSpiritShotId", 0);

		EX_USE_PRIME_SHOP = properties.getProperty("UsePrimeShop", false);
	}

	public static void loadBBSSettings()
	{
		ExProperties properties = load(BBS_FILE);

		BBS_ENABLED = properties.getProperty("ENABLED", true);
		BBS_DEFAULT_PAGE = properties.getProperty("DEFAULT_PAGE", "_bbshome");
		BBS_HOME_DIR = properties.getProperty("HomeDir", "scripts/handler/bbs");
		BBS_COPYRIGHT = properties.getProperty("COPYRIGHT", "(c) L2-Scripts.ru 2016");
		BBS_WAREHOUSE_ENABLED = properties.getProperty("WAREHOUSE_ENABLED", false);
		BBS_SELL_ITEMS_ENABLED = properties.getProperty("SELL_ITEMS_ENABLED", false);
		BBS_AUGMENTATION_ENABLED = properties.getProperty("AUGMENTATION_ENABLED", false);
	}

	public static void loadAltSettings()
	{
		ExProperties altSettings = load(ALT_SETTINGS_FILE);

		STARTING_LVL = altSettings.getProperty("StartingLvl", 1);
		STARTING_SP = altSettings.getProperty("StartingSP", 0L);

		ALT_GAME_DELEVEL = altSettings.getProperty("Delevel", true);
		ALT_ARENA_EXP = altSettings.getProperty("ArenaExp", true);
		ALLOW_DELEVEL_COMMAND = altSettings.getProperty("AllowDelevelCommand", false);
		ALT_SAVE_UNSAVEABLE = altSettings.getProperty("AltSaveUnsaveable", false);
		ALT_SAVE_EFFECTS_REMAINING_TIME = altSettings.getProperty("AltSaveEffectsRemainingTime", 5);
		ALT_SHOW_REUSE_MSG = altSettings.getProperty("AltShowSkillReuseMessage", true);
		ALT_DELETE_SA_BUFFS = altSettings.getProperty("AltDeleteSABuffs", false);
		AUTO_LOOT = altSettings.getProperty("AutoLoot", false);
		AUTO_LOOT_HERBS = altSettings.getProperty("AutoLootHerbs", false);
		AUTO_LOOT_ONLY_ADENA = altSettings.getProperty("AutoLootOnlyAdena", false);
		AUTO_LOOT_INDIVIDUAL = altSettings.getProperty("AutoLootIndividual", false);
		AUTO_LOOT_FROM_RAIDS = altSettings.getProperty("AutoLootFromRaids", false);
		MAGIC_LAMP_ENABLED = altSettings.getProperty("EnableMagicLampGame", false);
		HOMUNCULUS_INFO_ENABLE = altSettings.getProperty("EnableHomunculusInfo", false);
		HERO_BOOK_INFO_ENABLE = altSettings.getProperty("EnableHeroBookInfo", false);
		COSTUME_SERIVCE_ENABLE = altSettings.getProperty("EnableCostumeService", false);
		ALLOW_ERTHEIA_CHAR_CREATION = altSettings.getProperty("AllowErtheiaCreation", false);
		ALLOW_DEATH_KNIGHT_CHAR_CREATION = altSettings.getProperty("AllowDeathKnightCreation", false);
		ALT_M_DMG_RANDOMISE = altSettings.getProperty("AltMagicDmgRandomise", true);
		ALT_AUTO_ATTACK_DMG_RANDOMISE = altSettings.getProperty("AltAutoAttackDmgRandomise", true);
		ALT_P_DMG_RANDOMISE = altSettings.getProperty("AltPhysDmgRandomise", true);
		STAT_INT_MODIFIER = altSettings.getProperty("StatIntModifier", 0.03d);
		STAT_STR_MODIFIER = altSettings.getProperty("StatStrModifier", 0.03d);
		STAT_CON_MODIFIER = altSettings.getProperty("StatConModifier", 0.03d);
		STAT_DEX_MODIFIER = altSettings.getProperty("StatDexModifier", 0.03d);
		STAT_WIT_MODIFIER = altSettings.getProperty("StatWitModifier", 0.03d);
		STAT_MEN_MODIFIER = altSettings.getProperty("StatMenModifier", 0.03d);
//		STAT_LUC_MODIFIER = altSettings.getProperty("StatLucModifier", 0.03);
//		STAT_CHA_MODIFIER = altSettings.getProperty("StatChaModifier", 0.03);

		SKILLER_SKILL_ID = Integer.parseInt(altSettings.getProperty("SkilledSkillId", "90002"));
		HEALER_SKILL_ID = Integer.parseInt(altSettings.getProperty("HealerSkillId", "90003"));
		SKILLER_WHITELISTED_SKILLS = altSettings.getProperty("SkillerWhitelistedSkills", new int[] {1554, 1234, 1245});
		String[] autoLootItemIdList = altSettings.getProperty("AutoLootItemIdList", "-1").split(";");
		for(String item : autoLootItemIdList)
		{
			if(item == null || item.isEmpty())
				continue;

			try
			{
				int itemId = Integer.parseInt(item);
				if(itemId > 0)
					AUTO_LOOT_ITEM_ID_LIST.add(itemId);
			}
			catch(NumberFormatException e)
			{
				_log.error("", e);
			}
		}

		AUTO_LOOT_PK = altSettings.getProperty("AutoLootPK", false);
		ALT_GAME_KARMA_PLAYER_CAN_SHOP = altSettings.getProperty("AltKarmaPlayerCanShop", false);
		SAVING_SPS = altSettings.getProperty("SavingSpS", false);
		MANAHEAL_SPS_BONUS = altSettings.getProperty("ManahealSpSBonus", false);
		ALT_RAID_RESPAWN_MULTIPLIER = altSettings.getProperty("AltRaidRespawnMultiplier", 1.0);
		DEFAULT_RAID_MINIONS_RESPAWN_DELAY = altSettings.getProperty("DEFAULT_RAID_MINIONS_RESPAWN_DELAY", 120);
		ALLOW_AUGMENTATION = altSettings.getProperty("ALLOW_AUGMENTATION", true);
		ALT_ALLOW_DROP_AUGMENTED = altSettings.getProperty("AlowDropAugmented", false);
		ALT_GAME_UNREGISTER_RECIPE = altSettings.getProperty("AltUnregisterRecipe", true);
		ALT_GAME_SHOW_DROPLIST = altSettings.getProperty("AltShowDroplist", true);
		ALLOW_NPC_SHIFTCLICK = altSettings.getProperty("AllowShiftClick", true);
		SHOW_TARGET_PLAYER_INVENTORY_ON_SHIFT_CLICK = altSettings.getProperty("SHOW_TARGET_PLAYER_INVENTORY_ON_SHIFT_CLICK", false);
		ALLOW_VOICED_COMMANDS = altSettings.getProperty("AllowVoicedCommands", true);
		ALLOW_AUTOHEAL_COMMANDS = altSettings.getProperty("ALLOW_AUTOHEAL_COMMANDS", false);
		ALT_MAX_LEVEL = altSettings.getProperty("AltMaxLevel", 130);
		ALT_ALLOW_OTHERS_WITHDRAW_FROM_CLAN_WAREHOUSE = altSettings.getProperty("AltAllowOthersWithdrawFromClanWarehouse", false);
		ALT_ALLOW_CLAN_COMMAND_ONLY_FOR_CLAN_LEADER = altSettings.getProperty("AltAllowClanCommandOnlyForClanLeader", true);
		
		BAN_FOR_CFG_USAGE = altSettings.getProperty("BanForCfgUsageAgainsBots", false);

		ALT_ADD_RECIPES = altSettings.getProperty("AltAddRecipes", 0);
		SS_ANNOUNCE_PERIOD = altSettings.getProperty("SSAnnouncePeriod", 0);
		PETITIONING_ALLOWED = altSettings.getProperty("PetitioningAllowed", true);
		MAX_PETITIONS_PER_PLAYER = altSettings.getProperty("MaxPetitionsPerPlayer", 5);
		MAX_PETITIONS_PENDING = altSettings.getProperty("MaxPetitionsPending", 25);
		AUTO_LEARN_SKILLS = altSettings.getProperty("AutoLearnSkills", false);
		AUTO_LEARN_AWAKED_SKILLS = altSettings.getProperty("AutoLearnAwakedSkills", false);
		ALT_SOCIAL_ACTION_REUSE = altSettings.getProperty("AltSocialActionReuse", false);

		DISABLED_SPELLBOOKS_FOR_ACQUIRE_TYPES = new HashSet<AcquireType>();
		for(String t : altSettings.getProperty("DISABLED_SPELLBOOKS_FOR_ACQUIRE_TYPES", ArrayUtils.EMPTY_STRING_ARRAY))
		{
			if(t.trim().isEmpty())
				continue;

			DISABLED_SPELLBOOKS_FOR_ACQUIRE_TYPES.add(AcquireType.valueOf(t.toUpperCase()));
		}

		ALT_BUFF_LIMIT = altSettings.getProperty("BuffLimit", 20);
		ALT_MUSIC_LIMIT = altSettings.getProperty("ALT_MUSIC_LIMIT", 20);
		ALT_DEBUFF_LIMIT = altSettings.getProperty("ALT_DEBUFF_LIMIT", 12);
		ALT_TRIGGER_LIMIT = altSettings.getProperty("ALT_TRIGGER_LIMIT", 12);
		ALLOW_DEATH_PENALTY = altSettings.getProperty("EnableDeathPenalty", true);
		ALT_DEATH_PENALTY_CHANCE = altSettings.getProperty("DeathPenaltyChance", 10);
		ALT_DEATH_PENALTY_EXPERIENCE_PENALTY = altSettings.getProperty("DeathPenaltyRateExpPenalty", 1);
		ALT_DEATH_PENALTY_KARMA_PENALTY = altSettings.getProperty("DeathPenaltyC5RateKarma", 1);
		NONOWNER_ITEM_PICKUP_DELAY = altSettings.getProperty("NonOwnerItemPickupDelay", 15L) * 1000L;
		ALT_NO_LASTHIT = altSettings.getProperty("NoLasthitOnRaid", false);
		ALT_KAMALOKA_NIGHTMARES_PREMIUM_ONLY = altSettings.getProperty("KamalokaNightmaresPremiumOnly", false);
		ALT_PET_HEAL_BATTLE_ONLY = altSettings.getProperty("PetsHealOnlyInBattle", true);
		CHAR_TITLE = altSettings.getProperty("CharTitle", false);
		ADD_CHAR_TITLE = altSettings.getProperty("CharAddTitle", "");

		ALT_DISABLED_MULTISELL = altSettings.getProperty("DisabledMultisells", ArrayUtils.EMPTY_INT_ARRAY);
		ALT_SHOP_PRICE_LIMITS = altSettings.getProperty("ShopPriceLimits", ArrayUtils.EMPTY_INT_ARRAY);
		ALT_SHOP_UNALLOWED_ITEMS = altSettings.getProperty("ShopUnallowedItems", ArrayUtils.EMPTY_INT_ARRAY);

		ALT_ALLOWED_PET_POTIONS = altSettings.getProperty("AllowedPetPotions", new int[] { 735, 1060, 1061, 1062, 1374, 1375, 1539, 1540, 6035, 6036 });

		FESTIVAL_MIN_PARTY_SIZE = altSettings.getProperty("FestivalMinPartySize", 5);
		FESTIVAL_RATE_PRICE = altSettings.getProperty("FestivalRatePrice", 1.0);

		RIFT_MIN_PARTY_SIZE = altSettings.getProperty("RiftMinPartySize", 5);
		RIFT_SPAWN_DELAY = altSettings.getProperty("RiftSpawnDelay", 10000);
		RIFT_MAX_JUMPS = altSettings.getProperty("MaxRiftJumps", 4);
		RIFT_AUTO_JUMPS_TIME = altSettings.getProperty("AutoJumpsDelay", 8);
		RIFT_AUTO_JUMPS_TIME_RAND = altSettings.getProperty("AutoJumpsDelayRandom", 120000);

		RIFT_ENTER_COST_RECRUIT = altSettings.getProperty("RecruitFC", 18);
		RIFT_ENTER_COST_SOLDIER = altSettings.getProperty("SoldierFC", 21);
		RIFT_ENTER_COST_OFFICER = altSettings.getProperty("OfficerFC", 24);
		RIFT_ENTER_COST_CAPTAIN = altSettings.getProperty("CaptainFC", 27);
		RIFT_ENTER_COST_COMMANDER = altSettings.getProperty("CommanderFC", 30);
		RIFT_ENTER_COST_HERO = altSettings.getProperty("HeroFC", 33);
		ALLOW_CLANSKILLS = altSettings.getProperty("AllowClanSkills", true);
		ALLOW_LEARN_TRANS_SKILLS_WO_QUEST = altSettings.getProperty("AllowLearnTransSkillsWOQuest", false);
		MAXIMUM_MEMBERS_IN_PARTY = altSettings.getProperty("MAXIMUM_MEMBERS_IN_PARTY", 7);
		PARTY_LEADER_ONLY_CAN_INVITE = altSettings.getProperty("PartyLeaderOnlyCanInvite", true);
		ALLOW_TALK_WHILE_SITTING = altSettings.getProperty("AllowTalkWhileSitting", true);
		ALLOW_NOBLE_TP_TO_ALL = altSettings.getProperty("AllowNobleTPToAll", false);

		BUFFTIME_MODIFIER = altSettings.getProperty("BuffTimeModifier", 1.0);
		BUFFTIME_MODIFIER_SKILLS = altSettings.getProperty("BuffTimeModifierSkills", new int[0]);
		CLANHALL_BUFFTIME_MODIFIER = altSettings.getProperty("ClanHallBuffTimeModifier", 1.0);
		SONGDANCETIME_MODIFIER = altSettings.getProperty("SongDanceTimeModifier", 1.0);
		MAXLOAD_MODIFIER = altSettings.getProperty("MaxLoadModifier", 1.0);
		GATEKEEPER_MODIFIER = altSettings.getProperty("GkCostMultiplier", 1.0);
		GATEKEEPER_FREE = altSettings.getProperty("GkFree", 76);
		CRUMA_GATEKEEPER_LVL = altSettings.getProperty("GkCruma", 65);
		ALT_IMPROVED_PETS_LIMITED_USE = altSettings.getProperty("ImprovedPetsLimitedUse", false);

		ALT_CHAMPION_CHANCE = altSettings.getProperty("AltChampionChance", 0.);
		ALT_CHAMPION_DIFF_LVL = altSettings.getProperty("AltChampionDiffLvl", 9);
		ALT_CHAMPION_CAN_BE_AGGRO = altSettings.getProperty("AltChampionAggro", false);
		ALT_CHAMPION_CAN_BE_SOCIAL = altSettings.getProperty("AltChampionSocial", false);
		ALT_CHAMPION_MIN_LEVEL = altSettings.getProperty("AltChampionMinLevel", 40);
		ALT_CHAMPION_TOP_LEVEL = altSettings.getProperty("AltChampionTopLevel", 75);
		ALT_CHAMPION_DESPAWN = altSettings.getProperty("AltChampionDeSpawn", 5);
		SPECIAL_ITEM_ID = altSettings.getProperty("ChampionSpecialItem", 0);
		SPECIAL_ITEM_COUNT = altSettings.getProperty("ChampionSpecialItemCount", 1);
		SPECIAL_ITEM_DROP_CHANCE = altSettings.getProperty("ChampionSpecialItemDropChance", 100.);

		ALT_UP_MONSTER_CHANCE = altSettings.getProperty("AltUpMonsterChance", 0.);
		ALT_UP_MONSTER_DIFF_LVL = altSettings.getProperty("AltUpMonsterDiffLvl", 9);
		ALT_UP_MONSTER_CAN_BE_AGGRO = altSettings.getProperty("AltUpMonsterAggro", false);
		ALT_UP_MONSTER_CAN_BE_SOCIAL = altSettings.getProperty("AltUpMonsterSocial", false);
		ALT_UP_MONSTER_MIN_LEVEL = altSettings.getProperty("AltUpMonsterMinLevel", 40);
		ALT_UP_MONSTER_TOP_LEVEL = altSettings.getProperty("AltUpMonsterTopLevel", 75);
		ALT_UP_MONSTER_DESPAWN = altSettings.getProperty("AltUpMonsterDeSpawn", 5);

		ALT_VITALITY_RATE = altSettings.getProperty("ALT_VITALITY_RATE", 200) / 100;
		ALT_VITALITY_PA_RATE = altSettings.getProperty("ALT_VITALITY_PA_RATE", 300) / 100;
		ALT_VITALITY_CONSUME_RATE = altSettings.getProperty("ALT_VITALITY_CONSUME_RATE", 1.);
		ALT_VITALITY_POTIONS_LIMIT = altSettings.getProperty("ALT_VITALITY_POTIONS_LIMIT", 5);
		ALT_VITALITY_POTIONS_PA_LIMIT = altSettings.getProperty("ALT_VITALITY_POTIONS_PA_LIMIT", 10);

		MAX_SYMBOL_SEAL_POINTS = altSettings.getProperty("MaxSymbolSealPoints", 7800);
		CONSUME_SYMBOL_SEAL_POINTS = altSettings.getProperty("ConsumeSymbolSealPoints", 1);

		ALT_PCBANG_POINTS_ENABLED = altSettings.getProperty("AltPcBangPointsEnabled", false);
		PC_BANG_POINTS_BY_ACCOUNT = altSettings.getProperty("PC_BANG_POINTS_BY_ACCOUNT", false);
		ALT_PCBANG_POINTS_ONLY_PREMIUM = altSettings.getProperty("AltPcBangPointsOnlyPA", false);
		ALT_PCBANG_POINTS_BONUS_DOUBLE_CHANCE = altSettings.getProperty("AltPcBangPointsDoubleChance", 10.);
		ALT_PCBANG_POINTS_BONUS = altSettings.getProperty("AltPcBangPointsBonus", 0);
		ALT_PCBANG_POINTS_DELAY = altSettings.getProperty("AltPcBangPointsDelay", 20);
		ALT_PCBANG_POINTS_MIN_LVL = altSettings.getProperty("AltPcBangPointsMinLvl", 1);
		ALT_ALLOWED_MULTISELLS_IN_PCBANG.addAll(altSettings.getProperty("ALT_ALLOWED_MULTISELLS_IN_PCBANG", new int[0]));

		ALT_PCBANG_POINTS_MAX_CODE_ENTER_ATTEMPTS = altSettings.getProperty("ALT_PCBANG_POINTS_MAX_CODE_ENTER_ATTEMPTS", 5);
		ALT_PCBANG_POINTS_BAN_TIME = altSettings.getProperty("ALT_PCBANG_POINTS_BAN_TIME", 480);

		ALT_DEBUG_ENABLED = altSettings.getProperty("AltDebugEnabled", false);
		DEBUG_TARGET = altSettings.getProperty("DebugTarget", false);

		ALT_MAX_ALLY_SIZE = altSettings.getProperty("AltMaxAllySize", 3);
		ALT_PARTY_DISTRIBUTION_RANGE = altSettings.getProperty("AltPartyDistributionRange", 1500);
		ALT_PARTY_BONUS = altSettings.getProperty("AltPartyBonus", new double[] { 1.00, 1.10, 1.20, 1.30, 1.40, 1.50, 2.00, 2.10, 2.20 });
		ALT_PARTY_CLAN_BONUS = altSettings.getProperty("ALT_PARTY_CLAN_BONUS", new double[] { 1.00 });
		ALT_PARTY_LVL_DIFF_PENALTY = altSettings.getProperty("ALT_PARTY_LVL_DIFF_PENALTY", new int[] { 100, 100, 100, 100, 100, 100, 30, 30, 30, 30, 0 });

		ALT_ALL_PHYS_SKILLS_OVERHIT = altSettings.getProperty("AltAllPhysSkillsOverhit", true);
		ALT_REMOVE_SKILLS_ON_DELEVEL = altSettings.getProperty("AltRemoveSkillsOnDelevel", true);
		ALLOW_CH_DOOR_OPEN_ON_CLICK = altSettings.getProperty("AllowChDoorOpenOnClick", true);
		ALT_CH_SIMPLE_DIALOG = altSettings.getProperty("AltChSimpleDialog", false);
		ALT_CH_UNLIM_MP = altSettings.getProperty("ALT_CH_UNLIM_MP", true);
		ALT_NO_FAME_FOR_DEAD = altSettings.getProperty("AltNoFameForDead", false);

		ALT_SHOW_SERVER_TIME = altSettings.getProperty("ShowServerTime", false);

		FOLLOW_RANGE = altSettings.getProperty("FollowRange", 100);

		ALT_ITEM_AUCTION_ENABLED = altSettings.getProperty("AltItemAuctionEnabled", true);
		ALT_CUSTOM_ITEM_AUCTION_ENABLED = ALT_ITEM_AUCTION_ENABLED && altSettings.getProperty("AltCustomItemAuctionEnabled", false);
		ALT_ITEM_AUCTION_CAN_REBID = altSettings.getProperty("AltItemAuctionCanRebid", false);
		ALT_ITEM_AUCTION_START_ANNOUNCE = altSettings.getProperty("AltItemAuctionAnnounce", true);
		ALT_ITEM_AUCTION_MAX_BID = altSettings.getProperty("AltItemAuctionMaxBid", 1000000L);
		ALT_ITEM_AUCTION_MAX_CANCEL_TIME_IN_MILLIS = altSettings.getProperty("AltItemAuctionMaxCancelTimeInMillis", 604800000);

		ALT_ENABLE_BLOCK_CHECKER_EVENT = altSettings.getProperty("EnableBlockCheckerEvent", true);
		ALT_MIN_BLOCK_CHECKER_TEAM_MEMBERS = Math.min(Math.max(altSettings.getProperty("BlockCheckerMinOlympiadMembers", 1), 1), 6);
		ALT_RATE_COINS_REWARD_BLOCK_CHECKER = altSettings.getProperty("BlockCheckerRateCoinReward", 1.);

		ALT_HBCE_FAIR_PLAY = altSettings.getProperty("HBCEFairPlay", false);

		ALT_PET_INVENTORY_LIMIT = altSettings.getProperty("AltPetInventoryLimit", 12);
		
		ALLOW_FAKE_PLAYERS = altSettings.getProperty("AllowFake", false);
		FAKE_PLAYERS_PERCENT = altSettings.getProperty("FakePercent", 0);

		DISABLE_CRYSTALIZATION_ITEMS = altSettings.getProperty("DisableCrystalizationItems", false);
		
		START_CLAN_LEVEL = altSettings.getProperty("ClanStartLevel", 0);
		NEW_CHAR_IS_NOBLE = altSettings.getProperty("IsNewCharNoble", false);
		ENABLE_L2_TOP_OVERONLINE = altSettings.getProperty("EnableL2TOPFakeOnline", false);
		L2TOP_MAX_ONLINE = altSettings.getProperty("L2TOPMaxOnline", 3000);
		MIN_ONLINE_0_5_AM = altSettings.getProperty("MinOnlineFrom00to05", 500);
		MAX_ONLINE_0_5_AM = altSettings.getProperty("MaxOnlineFrom00to05", 700);
		MIN_ONLINE_6_11_AM = altSettings.getProperty("MinOnlineFrom06to11", 700);
		MAX_ONLINE_6_11_AM = altSettings.getProperty("MaxOnlineFrom06to11", 1000);
		MIN_ONLINE_12_6_PM = altSettings.getProperty("MinOnlineFrom12to18", 1000);
		MAX_ONLINE_12_6_PM = altSettings.getProperty("MaxOnlineFrom12to18", 1500);
		MIN_ONLINE_7_11_PM = altSettings.getProperty("MinOnlineFrom19to23", 1500);
		MAX_ONLINE_7_11_PM = altSettings.getProperty("MaxOnlineFrom19to23", 2500);
		ADD_ONLINE_ON_SIMPLE_DAY = altSettings.getProperty("AddOnlineIfSimpleDay", 50);
		ADD_ONLINE_ON_WEEKEND = altSettings.getProperty("AddOnlineIfWeekend", 300);
		L2TOP_MIN_TRADERS = altSettings.getProperty("L2TOPMinTraders", 80);
		L2TOP_MAX_TRADERS = altSettings.getProperty("L2TOPMaxTraders", 190);
		AETHER_CHANCE = altSettings.getProperty("AetherDropChance", 2);
		AETHER_DOUBLE_CHANCE = altSettings.getProperty("AetherDropDoubleChance", 5);
		ALT_SELL_ITEM_ONE_ADENA = altSettings.getProperty("AltSellItemOneAdena", false);
		ENABLE_TAUTI_FREE_ENTRANCE = altSettings.getProperty("EnableTautiWithOutSOH", false);
		SELL_ITEM_COUNT_PRICE = altSettings.getProperty("SellItemCountPrice", 2);

		MAX_SIEGE_CLANS = altSettings.getProperty("MaxSiegeClans", 20);	
		ONLY_ONE_SIEGE_PER_CLAN = altSettings.getProperty("OneClanCanRegisterOnOneSiege", false);

		CLAN_WAR_LIMIT = altSettings.getProperty("CLAN_WAR_LIMIT", 30);
		CLAN_WAR_MINIMUM_CLAN_LEVEL = altSettings.getProperty("CLAN_WAR_MINIMUM_CLAN_LEVEL", 5);
		CLAN_WAR_MINIMUM_PLAYERS_DECLARE = altSettings.getProperty("CLAN_WAR_MINIMUM_PLAYERS_DECLARE", 15);
		CLAN_WAR_PREPARATION_DAYS_PERIOD = altSettings.getProperty("CLAN_WAR_PREPARATION_DAYS_PERIOD", 7);
		CLAN_WAR_REPUTATION_SCORE_PER_KILL = altSettings.getProperty("CLAN_WAR_REPUTATION_SCORE_PER_KILL", 1);
		CLAN_WAR_INACTIVITY_DAYS_PERIOD = altSettings.getProperty("CLAN_WAR_INACTIVITY_DAYS_PERIOD", 7);
		CLAN_WAR_PEACE_DAYS_PERIOD = altSettings.getProperty("CLAN_WAR_PEACE_DAYS_PERIOD", 5);
		CLAN_WAR_KILLS_COUNT_TO_CONFIRM_MUTUAL_WAR = altSettings.getProperty("CLAN_WAR_KILLS_COUNT_TO_CONFIRM_MUTUAL_WAR", 5);
		CLAN_WAR_CANCEL_REPUTATION_PENALTY = altSettings.getProperty("CLAN_WAR_CANCEL_REPUTATION_PENALTY", 5000);

		NEED_QUEST_FOR_PROOF = altSettings.getProperty("NeedQuestForProff", false);

		LIST_OF_SELLABLE_ITEMS = new ArrayList<Integer>();
		for(int id : altSettings.getProperty("ListOfAlwaysSellableItems", new int[] {57}))
			LIST_OF_SELLABLE_ITEMS.add(id);		
		LIST_OF_TRABLE_ITEMS = new ArrayList<Integer>();		
		for(int id : altSettings.getProperty("ListOfAlwaysTradableItems", new int[] {57}))
			LIST_OF_TRABLE_ITEMS.add(id);		

		ALLOW_USE_DOORMANS_IN_SIEGE_BY_OWNERS = altSettings.getProperty("AllowUseDoormansInSiegeByOwners", true);

		NPC_RANDOM_ENCHANT = altSettings.getProperty("NpcRandomEnchant", false);
		ENABLE_PARTY_SEARCH = altSettings.getProperty("AllowPartySearch", false);
		MENTOR_ENABLE = altSettings.getProperty("MentorServiceEnable", false);
		MENTOR_ONLY_PA = altSettings.getProperty("MentorServiceOnlyForPremium", false);

		ALT_SHOW_MONSTERS_AGRESSION = altSettings.getProperty("AltShowMonstersAgression", false);
		ALT_SHOW_MONSTERS_LVL = altSettings.getProperty("AltShowMonstersLvL", false);

		ALT_TELEPORT_TO_TOWN_DURING_SIEGE = altSettings.getProperty("ALT_TELEPORT_TO_TOWN_DURING_SIEGE", true);

		ALT_CLAN_LEAVE_PENALTY_TIME = altSettings.getProperty("ALT_CLAN_LEAVE_PENALTY_TIME", 24);
		ALT_CLAN_CREATE_PENALTY_TIME = altSettings.getProperty("ALT_CLAN_CREATE_PENALTY_TIME", 240);

		ALT_EXPELLED_MEMBER_PENALTY_TIME = altSettings.getProperty("ALT_EXPELLED_MEMBER_PENALTY_TIME", 24);
		ALT_LEAVED_ALLY_PENALTY_TIME = altSettings.getProperty("ALT_LEAVED_ALLY_PENALTY_TIME", 24);
		ALT_DISSOLVED_ALLY_PENALTY_TIME = altSettings.getProperty("ALT_DISSOLVED_ALLY_PENALTY_TIME", 24);

		MIN_RAID_LEVEL_TO_DROP = altSettings.getProperty("MinRaidLevelToDropItem", 0);

		DROP_GLOBAL_ITEMS = altSettings.getProperty("AltEnableGlobalDrop", false);
		DROP_IMPROVED_ITEMS = altSettings.getProperty("AltEnableImprovedDrop", true);
		DROP_IMPROVED_CHAMPION_ITEMS = altSettings.getProperty("AltEnableImprovedChampionDrop", true);
		ALT_ENABLE_ADDITIONAL_DROP = altSettings.getProperty("AltEnableAdditionalDrop", true);

		NPC_DIALOG_PLAYER_DELAY = altSettings.getProperty("NpcDialogPlayerDelay", 0);

		CLAN_DELETE_TIME = altSettings.getProperty("CLAN_DELETE_TIME", "0 5 * * 2");
		CLAN_CHANGE_LEADER_TIME = altSettings.getProperty("CLAN_CHANGE_LEADER_TIME", "0 5 * * 2");

		CLAN_MAX_LEVEL = altSettings.getProperty("CLAN_MAX_LEVEL", 15);

		CLAN_LVL_UP_RP_COST = new int[CLAN_MAX_LEVEL + 1];
		for(int i = 1; i < CLAN_LVL_UP_RP_COST.length; i++)
			CLAN_LVL_UP_RP_COST[i] = altSettings.getProperty("CLAN_LVL_UP_RP_COST_" + i, 0);
			
		OFFLIKE_MASTERY_SYSTEM = altSettings.getProperty("OffLikeMasterySystem", false);
		
		REFLECT_DAMAGE_CAPPED_BY_PDEF = altSettings.getProperty("ReflectDamageCappedByPDef", false);

		ALT_DELEVEL_ON_DEATH_PENALTY_MIN_LEVEL = altSettings.getProperty("ALT_DELEVEL_ON_DEATH_PENALTY_MIN_LEVEL", 105);

		ALT_PETS_NOT_STARVING = altSettings.getProperty("ALT_PETS_NOT_STARVING", false);

		SHOW_TARGET_PLAYER_BUFF_EFFECTS = altSettings.getProperty("SHOW_TARGET_PLAYER_BUFF_EFFECTS", true);
		SHOW_TARGET_PLAYER_DEBUFF_EFFECTS = altSettings.getProperty("SHOW_TARGET_PLAYER_DEBUFF_EFFECTS", true);
		SHOW_TARGET_NPC_BUFF_EFFECTS = altSettings.getProperty("SHOW_TARGET_NPC_BUFF_EFFECTS", true);
		SHOW_TARGET_NPC_DEBUFF_EFFECTS = altSettings.getProperty("SHOW_TARGET_NPC_DEBUFF_EFFECTS", true);

		PERCENT_LOST_ON_DEATH = new double[Short.MAX_VALUE];
		double prevPercentLost = 0.;
		for(int i = 1; i < PERCENT_LOST_ON_DEATH.length; i++)
		{
			double percent = altSettings.getProperty("PERCENT_LOST_ON_DEATH_LVL_" + i, prevPercentLost);
			PERCENT_LOST_ON_DEATH[i] = percent;
			if(percent != prevPercentLost)
				prevPercentLost = percent;
		}

		PERCENT_LOST_ON_DEATH_MOD_IN_PEACE_ZONE = altSettings.getProperty("PERCENT_LOST_ON_DEATH_MOD_IN_PEACE_ZONE", 1.);
		PERCENT_LOST_ON_DEATH_MOD_IN_PVP = altSettings.getProperty("PERCENT_LOST_ON_DEATH_MOD_IN_PVP", 1.);
		PERCENT_LOST_ON_DEATH_MOD_IN_WAR = altSettings.getProperty("PERCENT_LOST_ON_DEATH_MOD_IN_WAR", 0.25);
		PERCENT_LOST_ON_DEATH_MOD_FOR_PK = altSettings.getProperty("PERCENT_LOST_ON_DEATH_MOD_FOR_PK", 10.);

		ALT_EASY_RECIPES = altSettings.getProperty("EasyRecipiesExtraFeature", false);

		ALT_USE_TRANSFORM_IN_EPIC_ZONE = altSettings.getProperty("ALT_USE_TRANSFORM_IN_EPIC_ZONE", true);

		ALT_ANNONCE_RAID_BOSSES_REVIVAL = altSettings.getProperty("ALT_ANNONCE_RAID_BOSSES_REVIVAL", false);

		ALT_SAVE_PRIVATE_STORE = altSettings.getProperty("ALT_SAVE_PRIVATE_STORE", false);

		String allowedTradeZones = altSettings.getProperty("ALLOWED_TRADE_ZONES", "");
		if(StringUtils.isEmpty(allowedTradeZones))
			ALLOWED_TRADE_ZONES = new String[0];
		else
			ALLOWED_TRADE_ZONES = allowedTradeZones.split(";");

		MULTICLASS_SYSTEM_ENABLED = altSettings.getProperty("MULTICLASS_SYSTEM_ENABLED", false);
		MULTICLASS_SYSTEM_SHOW_LEARN_LIST_ON_OPEN_SKILL_LIST = altSettings.getProperty("MULTICLASS_SYSTEM_SHOW_LEARN_LIST_ON_OPEN_SKILL_LIST", false);
		MULTICLASS_SYSTEM_NON_CLASS_SP_MODIFIER = altSettings.getProperty("MULTICLASS_SYSTEM_NON_CLASS_SP_MODIFIER", 1.0);
		MULTICLASS_SYSTEM_1ST_CLASS_SP_MODIFIER = altSettings.getProperty("MULTICLASS_SYSTEM_1ST_CLASS_SP_MODIFIER", 1.0);
		MULTICLASS_SYSTEM_2ND_CLASS_SP_MODIFIER = altSettings.getProperty("MULTICLASS_SYSTEM_2ND_CLASS_SP_MODIFIER", 1.0);
		MULTICLASS_SYSTEM_3RD_CLASS_SP_MODIFIER = altSettings.getProperty("MULTICLASS_SYSTEM_3RD_CLASS_SP_MODIFIER", 1.0);
		MULTICLASS_SYSTEM_4TH_CLASS_SP_MODIFIER = altSettings.getProperty("MULTICLASS_SYSTEM_4TH_CLASS_SP_MODIFIER", 1.0);
		MULTICLASS_SYSTEM_NON_CLASS_COST_ITEM_ID_BASED_ON_SP = altSettings.getProperty("MULTICLASS_SYSTEM_NON_CLASS_COST_ITEM_ID_BASED_ON_SP", 0);
		MULTICLASS_SYSTEM_1ST_CLASS_COST_ITEM_ID_BASED_ON_SP = altSettings.getProperty("MULTICLASS_SYSTEM_1ST_CLASS_COST_ITEM_ID_BASED_ON_SP", 0);
		MULTICLASS_SYSTEM_2ND_CLASS_COST_ITEM_ID_BASED_ON_SP = altSettings.getProperty("MULTICLASS_SYSTEM_2ND_CLASS_COST_ITEM_ID_BASED_ON_SP", 0);
		MULTICLASS_SYSTEM_3RD_CLASS_COST_ITEM_ID_BASED_ON_SP = altSettings.getProperty("MULTICLASS_SYSTEM_3RD_CLASS_COST_ITEM_ID_BASED_ON_SP", 0);
		MULTICLASS_SYSTEM_4TH_CLASS_COST_ITEM_ID_BASED_ON_SP = altSettings.getProperty("MULTICLASS_SYSTEM_4TH_CLASS_COST_ITEM_ID_BASED_ON_SP", 0);
		MULTICLASS_SYSTEM_NON_CLASS_COST_ITEM_COUNT_MODIFIER_BASED_ON_SP = altSettings.getProperty("MULTICLASS_SYSTEM_NON_CLASS_COST_ITEM_COUNT_MODIFIER_BASED_ON_SP", 1.0);
		MULTICLASS_SYSTEM_1ST_CLASS_COST_ITEM_COUNT_MODIFIER_BASED_ON_SP = altSettings.getProperty("MULTICLASS_SYSTEM_1ST_CLASS_COST_ITEM_COUNT_MODIFIER_BASED_ON_SP", 1.0);
		MULTICLASS_SYSTEM_2ND_CLASS_COST_ITEM_COUNT_MODIFIER_BASED_ON_SP = altSettings.getProperty("MULTICLASS_SYSTEM_2ND_CLASS_COST_ITEM_COUNT_MODIFIER_BASED_ON_SP", 1.0);
		MULTICLASS_SYSTEM_3RD_CLASS_COST_ITEM_COUNT_MODIFIER_BASED_ON_SP = altSettings.getProperty("MULTICLASS_SYSTEM_3RD_CLASS_COST_ITEM_COUNT_MODIFIER_BASED_ON_SP", 1.0);
		MULTICLASS_SYSTEM_4TH_CLASS_COST_ITEM_COUNT_MODIFIER_BASED_ON_SP = altSettings.getProperty("MULTICLASS_SYSTEM_4TH_CLASS_COST_ITEM_COUNT_MODIFIER_BASED_ON_SP", 1.0);
		MULTICLASS_SYSTEM_NON_CLASS_COST_ITEM_ID = altSettings.getProperty("MULTICLASS_SYSTEM_NON_CLASS_COST_ITEM_ID", 0);
		MULTICLASS_SYSTEM_1ST_CLASS_COST_ITEM_ID = altSettings.getProperty("MULTICLASS_SYSTEM_1ST_CLASS_COST_ITEM_ID", 0);
		MULTICLASS_SYSTEM_2ND_CLASS_COST_ITEM_ID = altSettings.getProperty("MULTICLASS_SYSTEM_2ND_CLASS_COST_ITEM_ID", 0);
		MULTICLASS_SYSTEM_3RD_CLASS_COST_ITEM_ID = altSettings.getProperty("MULTICLASS_SYSTEM_3RD_CLASS_COST_ITEM_ID", 0);
		MULTICLASS_SYSTEM_4TH_CLASS_COST_ITEM_ID = altSettings.getProperty("MULTICLASS_SYSTEM_4TH_CLASS_COST_ITEM_ID", 0);
		MULTICLASS_SYSTEM_NON_CLASS_COST_ITEM_COUNT = altSettings.getProperty("MULTICLASS_SYSTEM_NON_CLASS_COST_ITEM_COUNT", 0L);
		MULTICLASS_SYSTEM_1ST_CLASS_COST_ITEM_COUNT = altSettings.getProperty("MULTICLASS_SYSTEM_1ST_CLASS_COST_ITEM_COUNT", 0L);
		MULTICLASS_SYSTEM_2ND_CLASS_COST_ITEM_COUNT = altSettings.getProperty("MULTICLASS_SYSTEM_2ND_CLASS_COST_ITEM_COUNT", 0L);
		MULTICLASS_SYSTEM_3RD_CLASS_COST_ITEM_COUNT = altSettings.getProperty("MULTICLASS_SYSTEM_3RD_CLASS_COST_ITEM_COUNT", 0L);
		MULTICLASS_SYSTEM_4TH_CLASS_COST_ITEM_COUNT = altSettings.getProperty("MULTICLASS_SYSTEM_4TH_CLASS_COST_ITEM_COUNT", 0L);

		BATTLE_ZONE_AROUND_RAID_BOSSES_RANGE = altSettings.getProperty("BATTLE_ZONE_AROUND_RAID_BOSSES_RANGE", 0);

		RANDOM_CRAFT_SYSTEM_ENABLED = altSettings.getProperty("EnableRandomCraftSystem", true);
		RANDOM_CRAFT_TRY_COMMISSION = altSettings.getProperty("RandomCraftTryCommission", 300000);


		ADDITIONAL_MONSTER_BOW_DEFENCE_TRAIT_MOD_ENABLED = altSettings.getProperty("AdditionalBowDefenceTraitModEnabled", false);
		ADDITIONAL_MONSTER_BOW_DEFENCE_TRAIT_ADD = altSettings.getProperty("AdditionalBowDefenceTraitAdd", 0);

		ONLINE_PLAYER_COUNT_MULTIPLIER = altSettings.getProperty("OnlinePlayerCountMultiplier", 1.0);
	}


	public static void parseGlobalDropInfo()
	{
		ExProperties altSettings = load(ALT_SETTINGS_FILE);
		String[] infos = altSettings.getProperty("GlobalDrop", new String[0], ";");
		try {
			for(String info : infos) {
				if(info.isEmpty()) {
					continue;
				}

				String[] data = info.split(",");
				String type = data[0];
				int minLevel = Integer.parseInt(data[1]);
				int maxLevel = Integer.parseInt(data[2]);
				int itemId = Integer.parseInt(data[3]);
				long minCnt = Long.parseLong(data[4]);
				long maxCnt = Long.parseLong(data[5]);
				double chance = Double.parseDouble(data[6]);

				GLOBAL_DROP.computeIfAbsent(type, t -> new ArrayList<>()).add(new RewardData(itemId, minCnt, maxCnt, chance, minLevel, maxLevel));
			}
		} catch (Exception e) {
			GLOBAL_DROP = Collections.emptyMap();
			e.printStackTrace();
		}
	}

	public static void parseImprovedDropInfo(int dropListLevelImproved)
	{
		ExProperties altSettings = load(ALT_SETTINGS_FILE);
		String[] infos = new String[0];
		switch (dropListLevelImproved){
			case 1:
				infos = altSettings.getProperty("ImprovedDrop1", new String[0], ";");
				break;
			case 2:
				infos = altSettings.getProperty("ImprovedDrop2", new String[0], ";");
				break;
			case 3:
				infos = altSettings.getProperty("ImprovedDrop3", new String[0], ";");
				break;
			case 4:
				infos = altSettings.getProperty("ImprovedDrop4", new String[0], ";");
				break;
			case 5:
				infos = altSettings.getProperty("ImprovedDrop5", new String[0], ";");
				break;
		}

		try {
			for(String info : infos) {
				if(info.isEmpty()) {
					continue;
				}

				String[] data = info.split(",");
				String type = data[0];
				int minLevel = Integer.parseInt(data[1]);
				int maxLevel = Integer.parseInt(data[2]);
				int itemId = Integer.parseInt(data[3]);
				long minCnt = Long.parseLong(data[4]);
				long maxCnt = Long.parseLong(data[5]);
				double chance = Double.parseDouble(data[6]);
				switch (dropListLevelImproved){
					case 1:
						IMPROVED_DROP_1.computeIfAbsent(type, t -> new ArrayList<>()).add(new RewardData(itemId, minCnt, maxCnt, chance, minLevel, maxLevel));
						break;
					case 2:
						IMPROVED_DROP_2.computeIfAbsent(type, t -> new ArrayList<>()).add(new RewardData(itemId, minCnt, maxCnt, chance, minLevel, maxLevel));
						break;
					case 3:
						IMPROVED_DROP_3.computeIfAbsent(type, t -> new ArrayList<>()).add(new RewardData(itemId, minCnt, maxCnt, chance, minLevel, maxLevel));
						break;
					case 4:
						IMPROVED_DROP_4.computeIfAbsent(type, t -> new ArrayList<>()).add(new RewardData(itemId, minCnt, maxCnt, chance, minLevel, maxLevel));
						break;
					case 5:
						IMPROVED_DROP_5.computeIfAbsent(type, t -> new ArrayList<>()).add(new RewardData(itemId, minCnt, maxCnt, chance, minLevel, maxLevel));
						break;
				}

			}
		} catch (Exception e) {
			IMPROVED_DROP_1 = Collections.emptyMap();
			IMPROVED_DROP_2 = Collections.emptyMap();
			IMPROVED_DROP_3 = Collections.emptyMap();
			IMPROVED_DROP_4 = Collections.emptyMap();
			IMPROVED_DROP_5 = Collections.emptyMap();
			e.printStackTrace();
		}
	}

	public static void parseImprovedChampionDropInfo(int dropListLevelImproved)
	{
		ExProperties altSettings = load(ALT_SETTINGS_FILE);
		String[] infos = new String[0];
		switch (dropListLevelImproved){
			case 1:
				infos = altSettings.getProperty("ImprovedChampionDrop1", new String[0], ";");
				break;
			case 2:
				infos = altSettings.getProperty("ImprovedChampionDrop2", new String[0], ";");
				break;
			case 3:
				infos = altSettings.getProperty("ImprovedChampionDrop3", new String[0], ";");
				break;
			case 4:
				infos = altSettings.getProperty("ImprovedChampionDrop4", new String[0], ";");
				break;
			case 5:
				infos = altSettings.getProperty("ImprovedChampionDrop5", new String[0], ";");
				break;
		}

		try {
			for(String info : infos) {
				if(info.isEmpty()) {
					continue;
				}

				String[] data = info.split(",");
				String type = data[0];
				int minLevel = Integer.parseInt(data[1]);
				int maxLevel = Integer.parseInt(data[2]);
				int itemId = Integer.parseInt(data[3]);
				long minCnt = Long.parseLong(data[4]);
				long maxCnt = Long.parseLong(data[5]);
				double chance = Double.parseDouble(data[6]);
				switch (dropListLevelImproved){
					case 1:
						IMPROVED_DROP_CHAMPION_1.computeIfAbsent(type, t -> new ArrayList<>()).add(new RewardData(itemId, minCnt, maxCnt, chance, minLevel, maxLevel));
						break;
					case 2:
						IMPROVED_DROP_CHAMPION_2.computeIfAbsent(type, t -> new ArrayList<>()).add(new RewardData(itemId, minCnt, maxCnt, chance, minLevel, maxLevel));
						break;
					case 3:
						IMPROVED_DROP_CHAMPION_3.computeIfAbsent(type, t -> new ArrayList<>()).add(new RewardData(itemId, minCnt, maxCnt, chance, minLevel, maxLevel));
						break;
					case 4:
						IMPROVED_DROP_CHAMPION_4.computeIfAbsent(type, t -> new ArrayList<>()).add(new RewardData(itemId, minCnt, maxCnt, chance, minLevel, maxLevel));
						break;
					case 5:
						IMPROVED_DROP_CHAMPION_5.computeIfAbsent(type, t -> new ArrayList<>()).add(new RewardData(itemId, minCnt, maxCnt, chance, minLevel, maxLevel));
						break;
				}

			}
		} catch (Exception e) {
			IMPROVED_DROP_CHAMPION_1 = Collections.emptyMap();
			IMPROVED_DROP_CHAMPION_2 = Collections.emptyMap();
			IMPROVED_DROP_CHAMPION_3 = Collections.emptyMap();
			IMPROVED_DROP_CHAMPION_4 = Collections.emptyMap();
			IMPROVED_DROP_CHAMPION_5 = Collections.emptyMap();
			e.printStackTrace();
		}
	}

	public static void loadServicesSettings()
	{
		ExProperties servicesSettings = load(SERVICES_FILE);

		SPAWN_VITAMIN_MANAGER = servicesSettings.getProperty("SPAWN_VITAMIN_MANAGER", true);

		SERVICES_CHANGE_NICK_ENABLED = servicesSettings.getProperty("NickChangeEnabled", false);
		SERVICES_CHANGE_NICK_PRICE = servicesSettings.getProperty("NickChangePrice", 100);
		SERVICES_CHANGE_NICK_ITEM = servicesSettings.getProperty("NickChangeItem", 4037);

		ALLOW_CHANGE_PASSWORD_COMMAND = servicesSettings.getProperty("ALLOW_CHANGE_PASSWORD_COMMAND", false);
		ALLOW_CHANGE_PHONE_NUMBER_COMMAND = servicesSettings.getProperty("ALLOW_CHANGE_PHONE_NUMBER_COMMAND", false);
		FORCIBLY_SPECIFY_PHONE_NUMBER = servicesSettings.getProperty("FORCIBLY_SPECIFY_PHONE_NUMBER", false);
		
		SERVICES_CHANGE_CLAN_NAME_ENABLED = servicesSettings.getProperty("ClanNameChangeEnabled", false);
		SERVICES_CHANGE_CLAN_NAME_PRICE = servicesSettings.getProperty("ClanNameChangePrice", 100);
		SERVICES_CHANGE_CLAN_NAME_ITEM = servicesSettings.getProperty("ClanNameChangeItem", 4037);
		ALLOW_TOTAL_ONLINE = servicesSettings.getProperty("AllowVoiceCommandOnline", false);
		ALLOW_ONLINE_PARSE = servicesSettings.getProperty("AllowParsTotalOnline", false);
		FIRST_UPDATE = servicesSettings.getProperty("FirstOnlineUpdate", 1);
		DELAY_UPDATE = servicesSettings.getProperty("OnlineUpdate", 5);

		SERVICES_CHANGE_PET_NAME_ENABLED = servicesSettings.getProperty("PetNameChangeEnabled", false);
		SERVICES_CHANGE_PET_NAME_PRICE = servicesSettings.getProperty("PetNameChangePrice", 100);
		SERVICES_CHANGE_PET_NAME_ITEM = servicesSettings.getProperty("PetNameChangeItem", 4037);

		SERVICES_EXCHANGE_BABY_PET_ENABLED = servicesSettings.getProperty("BabyPetExchangeEnabled", false);
		SERVICES_EXCHANGE_BABY_PET_PRICE = servicesSettings.getProperty("BabyPetExchangePrice", 100);
		SERVICES_EXCHANGE_BABY_PET_ITEM = servicesSettings.getProperty("BabyPetExchangeItem", 4037);

		SERVICES_CHANGE_SEX_ENABLED = servicesSettings.getProperty("SexChangeEnabled", false);
		SERVICES_CHANGE_SEX_PRICE = servicesSettings.getProperty("SexChangePrice", 100);
		SERVICES_CHANGE_SEX_ITEM = servicesSettings.getProperty("SexChangeItem", 4037);

		SERVICES_CHANGE_BASE_ENABLED = servicesSettings.getProperty("BaseChangeEnabled", false);
		SERVICES_CHANGE_BASE_PRICE = servicesSettings.getProperty("BaseChangePrice", 100);
		SERVICES_CHANGE_BASE_ITEM = servicesSettings.getProperty("BaseChangeItem", 4037);

		SERVICES_SEPARATE_SUB_ENABLED = servicesSettings.getProperty("SeparateSubEnabled", false);
		SERVICES_SEPARATE_SUB_PRICE = servicesSettings.getProperty("SeparateSubPrice", 100);
		SERVICES_SEPARATE_SUB_ITEM = servicesSettings.getProperty("SeparateSubItem", 4037);

		SERVICES_CHANGE_NICK_COLOR_ENABLED = servicesSettings.getProperty("NickColorChangeEnabled", false);
		SERVICES_CHANGE_NICK_COLOR_PRICE = servicesSettings.getProperty("NickColorChangePrice", 100);
		SERVICES_CHANGE_NICK_COLOR_ITEM = servicesSettings.getProperty("NickColorChangeItem", 4037);
		SERVICES_CHANGE_NICK_COLOR_LIST = servicesSettings.getProperty("NickColorChangeList", new String[] { "00FF00" });

		SERVICES_BASH_ENABLED = servicesSettings.getProperty("BashEnabled", false);
		SERVICES_BASH_SKIP_DOWNLOAD = servicesSettings.getProperty("BashSkipDownload", false);
		SERVICES_BASH_RELOAD_TIME = servicesSettings.getProperty("BashReloadTime", 24);

		SERVICES_NOBLESS_SELL_ENABLED = servicesSettings.getProperty("NoblessSellEnabled", false);
		SERVICES_NOBLESS_SELL_PRICE = servicesSettings.getProperty("NoblessSellPrice", 1000);
		SERVICES_NOBLESS_SELL_ITEM = servicesSettings.getProperty("NoblessSellItem", 4037);

		SERVICES_EXPAND_INVENTORY_ENABLED = servicesSettings.getProperty("ExpandInventoryEnabled", false);
		SERVICES_EXPAND_INVENTORY_PRICE = servicesSettings.getProperty("ExpandInventoryPrice", 1000);
		SERVICES_EXPAND_INVENTORY_ITEM = servicesSettings.getProperty("ExpandInventoryItem", 4037);
		SERVICES_EXPAND_INVENTORY_MAX = servicesSettings.getProperty("ExpandInventoryMax", 250);

		SERVICES_EXPAND_WAREHOUSE_ENABLED = servicesSettings.getProperty("ExpandWarehouseEnabled", false);
		SERVICES_EXPAND_WAREHOUSE_PRICE = servicesSettings.getProperty("ExpandWarehousePrice", 1000);
		SERVICES_EXPAND_WAREHOUSE_ITEM = servicesSettings.getProperty("ExpandWarehouseItem", 4037);

		SERVICES_EXPAND_CWH_ENABLED = servicesSettings.getProperty("ExpandCWHEnabled", false);
		SERVICES_EXPAND_CWH_PRICE = servicesSettings.getProperty("ExpandCWHPrice", 1000);
		SERVICES_EXPAND_CWH_ITEM = servicesSettings.getProperty("ExpandCWHItem", 4037);

		SERVICES_OFFLINE_TRADE_ALLOW = servicesSettings.getProperty("AllowOfflineTrade", false);
		SERVICES_OFFLINE_TRADE_ALLOW_ZONE = servicesSettings.getProperty("AllowOfflineTradeZone", 0);
		SERVICES_OFFLINE_TRADE_MIN_LEVEL = servicesSettings.getProperty("OfflineMinLevel", 0);
		SERVICES_OFFLINE_TRADE_NAME_COLOR = Integer.decode("0x" + servicesSettings.getProperty("OfflineTradeNameColor", "B0FFFF"));
		SERVICES_OFFLINE_TRADE_ABNORMAL_EFFECT = AbnormalEffect.valueOf(servicesSettings.getProperty("OfflineTradeAbnormalEffect", "NONE").toUpperCase());
		SERVICES_OFFLINE_TRADE_PRICE_ITEM = servicesSettings.getProperty("OfflineTradePriceItem", 0);
		SERVICES_OFFLINE_TRADE_PRICE = servicesSettings.getProperty("OfflineTradePrice", 0);
		SERVICES_OFFLINE_TRADE_SECONDS_TO_KICK = servicesSettings.getProperty("OfflineTradeDaysToKick", 14) * 86400;
		SERVICES_OFFLINE_TRADE_RESTORE_AFTER_RESTART = servicesSettings.getProperty("OfflineRestoreAfterRestart", true);

		SERVICES_NO_TRADE_ONLY_OFFLINE = servicesSettings.getProperty("NoTradeOnlyOffline", false);
		SERVICES_TRADE_TAX = servicesSettings.getProperty("TradeTax", 0.0);
		SERVICES_OFFSHORE_TRADE_TAX = servicesSettings.getProperty("OffshoreTradeTax", 0.0);
		SERVICES_TRADE_TAX_ONLY_OFFLINE = servicesSettings.getProperty("TradeTaxOnlyOffline", false);
		SERVICES_OFFSHORE_NO_CASTLE_TAX = servicesSettings.getProperty("NoCastleTaxInOffshore", false);
		SERVICES_TRADE_ONLY_FAR = servicesSettings.getProperty("TradeOnlyFar", false);
		SERVICES_TRADE_MIN_LEVEL = servicesSettings.getProperty("MinLevelForTrade", 0);
		SERVICES_TRADE_RADIUS = servicesSettings.getProperty("TradeRadius", 30);

		SERVICES_GIRAN_HARBOR_ENABLED = servicesSettings.getProperty("GiranHarborZone", false);
		SERVICES_PARNASSUS_ENABLED = servicesSettings.getProperty("ParnassusZone", false);
		SERVICES_PARNASSUS_NOTAX = servicesSettings.getProperty("ParnassusNoTax", false);
		SERVICES_PARNASSUS_PRICE = servicesSettings.getProperty("ParnassusPrice", 500000);

		SERVICES_ALLOW_LOTTERY = servicesSettings.getProperty("AllowLottery", false);
		SERVICES_LOTTERY_PRIZE = servicesSettings.getProperty("LotteryPrize", 50000);
		SERVICES_ALT_LOTTERY_PRICE = servicesSettings.getProperty("AltLotteryPrice", 2000);
		SERVICES_LOTTERY_TICKET_PRICE = servicesSettings.getProperty("LotteryTicketPrice", 2000);
		SERVICES_LOTTERY_5_NUMBER_RATE = servicesSettings.getProperty("Lottery5NumberRate", 0.6);
		SERVICES_LOTTERY_4_NUMBER_RATE = servicesSettings.getProperty("Lottery4NumberRate", 0.4);
		SERVICES_LOTTERY_3_NUMBER_RATE = servicesSettings.getProperty("Lottery3NumberRate", 0.2);
		SERVICES_LOTTERY_2_AND_1_NUMBER_PRIZE = servicesSettings.getProperty("Lottery2and1NumberPrize", 200);

		SERVICES_ALLOW_ROULETTE = servicesSettings.getProperty("AllowRoulette", false);
		SERVICES_ROULETTE_MIN_BET = servicesSettings.getProperty("RouletteMinBet", 1L);
		SERVICES_ROULETTE_MAX_BET = servicesSettings.getProperty("RouletteMaxBet", Long.MAX_VALUE);

		SERVICES_ENABLE_NO_CARRIER = servicesSettings.getProperty("EnableNoCarrier", false);
		SERVICES_NO_CARRIER_MIN_TIME = servicesSettings.getProperty("NoCarrierMinTime", 0);
		SERVICES_NO_CARRIER_MAX_TIME = servicesSettings.getProperty("NoCarrierMaxTime", 90);
		SERVICES_NO_CARRIER_DEFAULT_TIME = servicesSettings.getProperty("NoCarrierDefaultTime", 60);

		ALLOW_EVENT_GATEKEEPER = servicesSettings.getProperty("AllowEventGatekeeper", false);

		SERVICES_ENCHANT_VALUE = servicesSettings.getProperty("EnchantValue", new int[] { 0 });
		SERVICES_ENCHANT_COAST = servicesSettings.getProperty("EnchantCoast", new int[] { 0 });
		SERVICES_ENCHANT_RAID_VALUE = servicesSettings.getProperty("EnchantRaidValue", new int[] { 0 });
		SERVICES_ENCHANT_RAID_COAST = servicesSettings.getProperty("EnchantRaidCoast", new int[] { 0 });

		ALLOW_IP_LOCK = servicesSettings.getProperty("AllowLockIP", false);
		AUTO_LOCK_IP_ON_LOGIN = servicesSettings.getProperty("AUTO_LOCK_IP_ON_LOGIN", false);
		ALLOW_HWID_LOCK = servicesSettings.getProperty("AllowLockHwid", false);
		AUTO_LOCK_HWID_ON_LOGIN = servicesSettings.getProperty("AUTO_LOCK_HWID_ON_LOGIN", false);
		HWID_LOCK_MASK = servicesSettings.getProperty("HwidLockMask", 10);

		SERVICES_RIDE_HIRE_ENABLED = servicesSettings.getProperty("SERVICES_RIDE_HIRE_ENABLED", false);

		/** Away System **/
		ALLOW_AWAY_STATUS = servicesSettings.getProperty("AllowAwayStatus", false); // FIXME: скорее всего не корректно
		AWAY_ONLY_FOR_PREMIUM = servicesSettings.getProperty("AwayOnlyForPremium", true);
		AWAY_PLAYER_TAKE_AGGRO = servicesSettings.getProperty("AwayPlayerTakeAggro", false);
		AWAY_TITLE_COLOR = Integer.decode("0x" + servicesSettings.getProperty("AwayTitleColor", "0000FF"));
		AWAY_TIMER = servicesSettings.getProperty("AwayTimer", 30);
		BACK_TIMER = servicesSettings.getProperty("BackTimer", 30);
		AWAY_PEACE_ZONE = servicesSettings.getProperty("AwayOnlyInPeaceZone", false);		
	}

	public static void loadPvPSettings()
	{
		ExProperties pvpSettings = load(PVP_CONFIG_FILE);

		/* KARMA SYSTEM */
		KARMA_MIN_KARMA = pvpSettings.getProperty("MinKarma", 720);
		KARMA_RATE_KARMA_LOST = pvpSettings.getProperty("RateKarmaLost", -1);
		KARMA_LOST_BASE = pvpSettings.getProperty("BaseKarmaLost", 1200);

		SET_PURE_KARMA = pvpSettings.getProperty("SetPureKarma", 360);

		KARMA_DROP_GM = pvpSettings.getProperty("CanGMDropEquipment", false);
		KARMA_NEEDED_TO_DROP = pvpSettings.getProperty("KarmaNeededToDrop", true);
		DROP_ITEMS_ON_DIE = pvpSettings.getProperty("DropOnDie", false);
		DROP_ITEMS_AUGMENTED = pvpSettings.getProperty("DropAugmented", false);

		KARMA_DROP_ITEM_LIMIT = pvpSettings.getProperty("MaxItemsDroppable", 10);
		MIN_PK_TO_ITEMS_DROP = pvpSettings.getProperty("MinPKToDropItems", 31);

		KARMA_RANDOM_DROP_LOCATION_LIMIT = pvpSettings.getProperty("MaxDropThrowDistance", 70);

		KARMA_DROPCHANCE_BASE = pvpSettings.getProperty("ChanceOfPKDropBase", 20.);
		KARMA_DROPCHANCE_MOD = pvpSettings.getProperty("ChanceOfPKsDropMod", 1.);
		NORMAL_DROPCHANCE_BASE = pvpSettings.getProperty("ChanceOfNormalDropBase", 1.);
		DROPCHANCE_EQUIPPED_WEAPON = pvpSettings.getProperty("ChanceOfDropWeapon", 3);
		DROPCHANCE_EQUIPMENT = pvpSettings.getProperty("ChanceOfDropEquippment", 17);
		DROPCHANCE_ITEM = pvpSettings.getProperty("ChanceOfDropOther", 80);
			
		KARMA_LIST_NONDROPPABLE_ITEMS = new ArrayList<Integer>();
		for(int id : pvpSettings.getProperty("ListOfNonDroppableItems", new int[] {
				57,
				1147,
				425,
				1146,
				461,
				10,
				2368,
				7,
				6,
				2370,
				2369,
				3500,
				3501,
				3502,
				4422,
				4423,
				4424,
				2375,
				6648,
				6649,
				6650,
				6842,
				6834,
				6835,
				6836,
				6837,
				6838,
				6839,
				6840,
				5575,
				7694,
				6841,
				8181 }))
			KARMA_LIST_NONDROPPABLE_ITEMS.add(id);

		PVP_TIME = pvpSettings.getProperty("PvPTime", 40000);
		RATE_KARMA_LOST_STATIC = pvpSettings.getProperty("KarmaLostStaticValue", -1);
	}

	public static void loadAISettings()
	{
		ExProperties aiSettings = load(AI_CONFIG_FILE);

		AI_TASK_MANAGER_COUNT = aiSettings.getProperty("AiTaskManagers", 1);
		AI_TASK_ATTACK_DELAY = aiSettings.getProperty("AiTaskDelay", 1000);
		AI_TASK_ACTIVE_DELAY = aiSettings.getProperty("AiTaskActiveDelay", 1000);
		BLOCK_ACTIVE_TASKS = aiSettings.getProperty("BlockActiveTasks", false);
		ALWAYS_TELEPORT_HOME = aiSettings.getProperty("AlwaysTeleportHome", false);
		ALWAYS_TELEPORT_HOME_RB = aiSettings.getProperty("ALWAYS_TELEPORT_HOME_RB", true);

		RND_WALK = aiSettings.getProperty("RndWalk", true);
		RND_WALK_RATE = aiSettings.getProperty("RndWalkRate", 1);
		RND_ANIMATION_RATE = aiSettings.getProperty("RndAnimationRate", 2);

		AGGRO_CHECK_INTERVAL = aiSettings.getProperty("AggroCheckInterval", 250);
		NONAGGRO_TIME_ONTELEPORT = aiSettings.getProperty("NonAggroTimeOnTeleport", 15000);
		NONPVP_TIME_ONTELEPORT = aiSettings.getProperty("NonPvPTimeOnTeleport", 0);
		MAX_DRIFT_RANGE = aiSettings.getProperty("MaxDriftRange", 100);
		MAX_PURSUE_RANGE = aiSettings.getProperty("MaxPursueRange", 10000);
		MAX_PURSUE_UNDERGROUND_RANGE = aiSettings.getProperty("MaxPursueUndergoundRange", 5000);
		MAX_PURSUE_RANGE_RAID = aiSettings.getProperty("MaxPursueRangeRaid", 5000);

		AGGRO_IF_PLAYER_IS_ONLINE = aiSettings.getProperty("AggroIfPlayerIsOnline", false);
		AGGRO_TIME_IF_PLAYER_IN_ONLINE = aiSettings.getProperty("AggroTimeIfPlayerIsOnline", 10);
	}

	public static void loadGeodataSettings()
	{
		ExProperties geodataSettings = load(GEODATA_CONFIG_FILE);

		GEO_X_FIRST = geodataSettings.getProperty("GeoFirstX", 11);
		GEO_Y_FIRST = geodataSettings.getProperty("GeoFirstY", 10);
		GEO_X_LAST = geodataSettings.getProperty("GeoLastX", 26);
		GEO_Y_LAST = geodataSettings.getProperty("GeoLastY", 26);

		ALLOW_GEODATA = geodataSettings.getProperty("AllowGeodata", true);

		try
		{
			GEODATA_ROOT = new File(geodataSettings.getProperty("GeodataRoot", "./geodata/")).getCanonicalFile();
		}
		catch(IOException e)
		{
			_log.error("", e);
		}

		ALLOW_FALL_FROM_WALLS = geodataSettings.getProperty("AllowFallFromWalls", false);
		ALLOW_KEYBOARD_MOVE = geodataSettings.getProperty("AllowMoveWithKeyboard", true);
		COMPACT_GEO = geodataSettings.getProperty("CompactGeoData", false);
		PATHFIND_BOOST = geodataSettings.getProperty("PathFindBoost", 2);
		PATHFIND_DIAGONAL = geodataSettings.getProperty("PathFindDiagonal", true);
		PATHFIND_MAP_MUL = geodataSettings.getProperty("PathFindMapMul", 2);
		PATH_CLEAN = geodataSettings.getProperty("PathClean", true);
		PATHFIND_MAX_Z_DIFF = geodataSettings.getProperty("PathFindMaxZDiff", 32);
		MAX_Z_DIFF = geodataSettings.getProperty("MaxZDiff", 64);
		MIN_LAYER_HEIGHT = geodataSettings.getProperty("MinLayerHeight", 64);
		REGION_EDGE_MAX_Z_DIFF = geodataSettings.getProperty("RegionEdgeMaxZDiff", 128);
		PATHFIND_MAX_TIME = geodataSettings.getProperty("PathFindMaxTime", 10000000);
		PATHFIND_BUFFERS = geodataSettings.getProperty("PathFindBuffers", "8x96;8x128;8x160;8x192;4x224;4x256;4x288;2x320;2x384;2x352;1x512");
		NPC_PATH_FIND_MAX_HEIGHT = geodataSettings.getProperty("NPC_PATH_FIND_MAX_HEIGHT", 1024);
		PLAYABLE_PATH_FIND_MAX_HEIGHT = geodataSettings.getProperty("PLAYABLE_PATH_FIND_MAX_HEIGHT", 256);
	}

	public static void pvpManagerSettings()
	{
		ExProperties pvp_manager = load(PVP_MANAGER_FILE);

		ALLOW_PVP_REWARD = pvp_manager.getProperty("AllowPvPManager", true);
		PVP_REWARD_SEND_SUCC_NOTIF = pvp_manager.getProperty("SendNotification", true);

		PVP_REWARD_REWARD_IDS = pvp_manager.getProperty("PvPRewardsIDs", new int[]{57, 6673});
		PVP_REWARD_COUNTS = pvp_manager.getProperty("PvPRewardsCounts", new long[]{1, 2});
		if(PVP_REWARD_REWARD_IDS.length != PVP_REWARD_COUNTS.length)
			_log.warn("pvp_manager.properties: PvPRewardsIDs array length != PvPRewardsCounts array length");

		PVP_REWARD_RANDOM_ONE = pvp_manager.getProperty("GiveJustOneRandom", true);
		PVP_REWARD_DELAY_ONE_KILL = pvp_manager.getProperty("DelayBetweenKillsOneCharSec", 60);
		PVP_REWARD_MIN_PL_PROFF = pvp_manager.getProperty("ToRewardMinProff", 0);
		PVP_REWARD_MIN_PL_UPTIME_MINUTE = pvp_manager.getProperty("ToRewardMinPlayerUptimeMinutes", 60);
		PVP_REWARD_MIN_PL_LEVEL = pvp_manager.getProperty("ToRewardMinPlayerLevel", 75);
		PVP_REWARD_PK_GIVE = pvp_manager.getProperty("RewardPK", false);
		PVP_REWARD_ON_EVENT_GIVE = pvp_manager.getProperty("ToRewardIfInEvent", false);
		PVP_REWARD_ONLY_BATTLE_ZONE = pvp_manager.getProperty("ToRewardOnlyIfInBattleZone", false);
		PVP_REWARD_ONLY_NOBLE_GIVE = pvp_manager.getProperty("ToRewardOnlyIfNoble", false);
		PVP_REWARD_SAME_PARTY_GIVE = pvp_manager.getProperty("ToRewardIfInSameParty", false);
		PVP_REWARD_SAME_CLAN_GIVE = pvp_manager.getProperty("ToRewardIfInSameClan", false);
		PVP_REWARD_SAME_ALLY_GIVE = pvp_manager.getProperty("ToRewardIfInSameAlly", false);
		PVP_REWARD_SAME_HWID_GIVE = pvp_manager.getProperty("ToRewardIfInSameHWID", false);
		PVP_REWARD_SAME_IP_GIVE = pvp_manager.getProperty("ToRewardIfInSameIP", false);
		PVP_REWARD_SPECIAL_ANTI_TWINK_TIMER = pvp_manager.getProperty("SpecialAntiTwinkCharCreateDelay", false);
		PVP_REWARD_HR_NEW_CHAR_BEFORE_GET_ITEM = pvp_manager.getProperty("SpecialAntiTwinkDelayInHours", 24);
		PVP_REWARD_CHECK_EQUIP = pvp_manager.getProperty("EquipCheck", false);
		PVP_REWARD_WEAPON_GRADE_TO_CHECK = pvp_manager.getProperty("MinimumGradeToCheck", 0);
		PVP_REWARD_LOG_KILLS = pvp_manager.getProperty("LogKillsToDB", false);
		DISALLOW_MSG_TO_PL = pvp_manager.getProperty("DoNotShowMessagesToPlayers", false);
	}
	
	public static void loadEventsSettings()
	{
		ExProperties eventSettings = load(EVENTS_CONFIG_FILE);

		EVENT_CofferOfShadowsPriceRate = eventSettings.getProperty("CofferOfShadowsPriceRate", 1.);
		EVENT_CofferOfShadowsRewardRate = eventSettings.getProperty("CofferOfShadowsRewardRate", 1.);
		
		/*EVENT_CtFRewards = eventSettings.getProperty("CtF_Rewards", "").trim().replaceAll(" ", "").split(";");
		EVENT_CtfTime = eventSettings.getProperty("CtF_time", 3);
		EVENT_CtFrate = eventSettings.getProperty("CtF_rate", true);
		EVENT_CtFStartTime = eventSettings.getProperty("CtF_StartTime", "20:00").trim().replaceAll(" ", "").split(",");
		EVENT_CtFCategories = eventSettings.getProperty("CtF_Categories", false);
		EVENT_CtFMaxPlayerInTeam = eventSettings.getProperty("CtF_MaxPlayerInTeam", 20);
		EVENT_CtFMinPlayerInTeam = eventSettings.getProperty("CtF_MinPlayerInTeam", 2);
		EVENT_CtFAllowSummons = eventSettings.getProperty("CtF_AllowSummons", false);
		EVENT_CtFAllowBuffs = eventSettings.getProperty("CtF_AllowBuffs", false);
		EVENT_CtFAllowMultiReg = eventSettings.getProperty("CtF_AllowMultiReg", false);
		EVENT_CtFCheckWindowMethod = eventSettings.getProperty("CtF_CheckWindowMethod", "IP");
		EVENT_CtFFighterBuffs = eventSettings.getProperty("CtF_FighterBuffs", "").trim().replaceAll(" ", "").split(";");
		EVENT_CtFMageBuffs = eventSettings.getProperty("CtF_MageBuffs", "").trim().replaceAll(" ", "").split(";");
		EVENT_CtFBuffPlayers = eventSettings.getProperty("CtF_BuffPlayers", false);*/
		ALLOW_PLAYER_INVIS_TAKE_FLAG_CTF = eventSettings.getProperty("CtF_AllowTakingFlagWhileInvisible", true);

		BALROG_WAR_POINT_REWARD_MOD = eventSettings.getProperty("BalrogWarPointRewardMod", 1.0d);

		EVENT_GLITTMEDAL_NORMAL_CHANCE = eventSettings.getProperty("MEDAL_CHANCE", 10.);
		EVENT_GLITTMEDAL_GLIT_CHANCE = eventSettings.getProperty("GLITTMEDAL_CHANCE", 0.1);

		EVENT_L2DAY_LETTER_CHANCE = eventSettings.getProperty("L2DAY_LETTER_CHANCE", 1.);
		EVENT_CHANGE_OF_HEART_CHANCE = eventSettings.getProperty("EVENT_CHANGE_OF_HEART_CHANCE", 5.);

		EVENT_BOUNTY_HUNTERS_ENABLED = eventSettings.getProperty("BountyHuntersEnabled", true);

		EVENT_SAVING_SNOWMAN_LOTERY_PRICE = eventSettings.getProperty("SavingSnowmanLoteryPrice", 50000);
		EVENT_SAVING_SNOWMAN_REWARDER_CHANCE = eventSettings.getProperty("SavingSnowmanRewarderChance", 2);

		EVENT_TRICK_OF_TRANS_CHANCE = eventSettings.getProperty("TRICK_OF_TRANS_CHANCE", 10.);

		EVENT_MARCH8_DROP_CHANCE = eventSettings.getProperty("March8DropChance", 10.);
		EVENT_MARCH8_PRICE_RATE = eventSettings.getProperty("March8PriceRate", 1.);
		GVG_LANG = eventSettings.getProperty("GvGLangRus", true);
		GvG_POINTS_FOR_BOX = eventSettings.getProperty("GvGPointsKillBox", 20); //test only
		GvG_POINTS_FOR_BOSS = eventSettings.getProperty("GvGPointsKillBoss", 50); //test only
		GvG_POINTS_FOR_KILL = eventSettings.getProperty("GvGPointsKillPlayer", 5); //test only
		GvG_POINTS_FOR_DEATH = eventSettings.getProperty("GvGPointsIfDead", 3); //test only
		GvG_EVENT_TIME = eventSettings.getProperty("GvGEventTime", 10); //test only
		GvG_BOSS_SPAWN_TIME = eventSettings.getProperty("GvGBossSpawnTime", 10); //test only
		GvG_FAME_REWARD = eventSettings.getProperty("GvGRewardFame", 200); //test only
		GvG_REWARD = eventSettings.getProperty("GvGRewardStatic", 57); //test only
		GvG_REWARD_COUNT = eventSettings.getProperty("GvGRewardCountStatic", 10000); //test only
		GvG_ADD_IF_WITHDRAW = eventSettings.getProperty("GvGAddPointsIfPartyWithdraw", 200); //test only
		GvG_HOUR_START = eventSettings.getProperty("GvGHourStart", 20); //test only
		GvG_MINUTE_START = eventSettings.getProperty("GvGMinuteStart", 00); //test only
		GVG_MIN_LEVEL = eventSettings.getProperty("GvGMinLevel", 1); //test only
		GVG_MAX_LEVEL = eventSettings.getProperty("GvGMaxLevel", 85); //test only
		GVG_MAX_GROUPS = eventSettings.getProperty("GvGMaxGroupsInEvent", 100); //test only
		GVG_MIN_PARTY_MEMBERS = eventSettings.getProperty("GvGMinPlayersInParty", 6); //test only
		GVG_TIME_TO_REGISTER = eventSettings.getProperty("GvGTimeToRegister", 10); //test only
		DISABLE_PARTY_ON_EVENT = eventSettings.getProperty("DisablePartyOnEvents", false);

		BALTHUS_EVENT_ENABLE = eventSettings.getProperty("BalthusEventEnabled", false);
		BALTHUS_EVENT_TIME_START = eventSettings.getProperty("BalthusEventTimeStart", "2014/10/29 18:00:00");
		BALTHUS_EVENT_TIME_END = eventSettings.getProperty("BalthusEventTimeEnd", "2014/11/25 18:00:00");
		BALTHUS_EVENT_PARTICIPATE_BUFF_ID = eventSettings.getProperty("BalthusEventParticipateBuffId", 39171);
		BALTHUS_EVENT_BASIC_REWARD_ID = eventSettings.getProperty("BalthusEventBasicRewardId", 94783);
		BALTHUS_EVENT_BASIC_REWARD_COUNT = eventSettings.getProperty("BalthusEventBasicRewardCount", 10);
		BALTHUS_EVENT_JACKPOT_CHANCE = eventSettings.getProperty("BalthusEventJackpotChance", 15);

		BM_FESTIVAL_ENABLE = eventSettings.getProperty("BMFestivalEventEnabled", false);
		BM_FESTIVAL_DEBUG = eventSettings.getProperty("BMFestivalEventDebug", false);
		BM_FESTIVAL_TIME_START = eventSettings.getProperty("BMFestivalTimeStart", "2014/10/29 18:00:00");
		BM_FESTIVAL_TIME_END = eventSettings.getProperty("BMFestivalTimeEnd", "2023/02/25 18:00:00");
		BM_FESTIVAL_TYPE = eventSettings.getProperty("BMFestivalType", 2);
		BM_FESTIVAL_REMOVE_SINGLE_ITEM = eventSettings.getProperty("BMFestivalRemoveSingleItem", false);
		BM_FESTIVAL_ITEM_TO_PLAY = eventSettings.getProperty("BMFestivalItemToPlay", 94441);
		BM_FESTIVAL_PLAY_LIMIT = eventSettings.getProperty("BMFestivalPlayLimit", -1);
		BM_FESTIVAL_ITEM_TO_PLAY_COUNT = eventSettings.getProperty("BMFestivalItemToPlayCount", 1);
		BM_FESTIVAL_REWARD_INTERVAL = eventSettings.getProperty("BMFestivalRewardInterval", 5);
		BM_FESTIVAL_UPDATE_INTERVAL = eventSettings.getProperty("BMFestivalUpdateInterval", 60);

		ENABLE_BALOK_RANDOM_BOSS_SKIP = eventSettings.getProperty("EnableBalokRandomBossSkip", false);
	}

	public static void loadOlympiadSettings()
	{
		ExProperties olympSettings = load(OLYMPIAD);

		ENABLE_OLYMPIAD = olympSettings.getProperty("EnableOlympiad", true);
		ENABLE_OLYMPIAD_SPECTATING = olympSettings.getProperty("EnableOlympiadSpectating", true);
		OLYMIAD_END_PERIOD_TIME = new SchedulingPattern(olympSettings.getProperty("OLYMIAD_END_PERIOD_TIME", "00 00 01 * *"));
		OLYMPIAD_START_TIME = new SchedulingPattern(olympSettings.getProperty("OLYMPIAD_START_TIME", "00 20 * * 5,6"));
		ALT_OLY_CPERIOD = olympSettings.getProperty("AltOlyCPeriod", 14400000);
		ALT_OLY_WPERIOD = olympSettings.getProperty("AltOlyWPeriod", 604800000);
		ALT_OLY_VPERIOD = olympSettings.getProperty("AltOlyVPeriod", 43200000);
		CLASSED_GAMES_ENABLED = olympSettings.getProperty("CLASSED_GAMES_ENABLED", true);
		OLYMPIAD_REGISTRATION_DELAY = olympSettings.getProperty("OLYMPIAD_REGISTRATION_DELAY", 1200000);
		CLASS_GAME_MIN = olympSettings.getProperty("ClassGameMin", 10);
		NONCLASS_GAME_MIN = olympSettings.getProperty("NonClassGameMin", 20);

		GAME_MAX_LIMIT = olympSettings.getProperty("GameMaxLimit", 30);
		GAME_CLASSES_COUNT_LIMIT = olympSettings.getProperty("GameClassesCountLimit", 30);
		GAME_NOCLASSES_COUNT_LIMIT = olympSettings.getProperty("GameNoClassesCountLimit", 30);

		ALT_OLY_REG_DISPLAY = olympSettings.getProperty("AltOlyRegistrationDisplayNumber", 100);
		ALT_OLY_BATTLE_REWARD_ITEM = olympSettings.getProperty("AltOlyBattleRewItem", 45584);
		OLYMPIAD_CLASSED_WINNER_REWARD_COUNT = olympSettings.getProperty("OLYMPIAD_CLASSED_WINNER_REWARD_COUNT", 12);
		OLYMPIAD_NONCLASSED_WINNER_REWARD_COUNT = olympSettings.getProperty("OLYMPIAD_NONCLASSED_WINNER_REWARD_COUNT", 12);
		OLYMPIAD_CLASSED_LOOSER_REWARD_COUNT = olympSettings.getProperty("OLYMPIAD_CLASSED_LOOSER_REWARD_COUNT", 7);
		OLYMPIAD_NONCLASSED_LOOSER_REWARD_COUNT = olympSettings.getProperty("OLYMPIAD_NONCLASSED_LOOSER_REWARD_COUNT", 7);
		ALT_OLY_COMP_RITEM = olympSettings.getProperty("AltOlyCompRewItem", 45584);
		ALT_OLY_GP_PER_POINT = olympSettings.getProperty("AltOlyGPPerPoint", 20);
		ALT_OLY_HERO_POINTS = olympSettings.getProperty("AltOlyHeroPoints", 30);
		ALT_OLY_RANK1_POINTS = olympSettings.getProperty("AltOlyRank1Points", 60);
		ALT_OLY_RANK2_POINTS = olympSettings.getProperty("AltOlyRank2Points", 50);
		ALT_OLY_RANK3_POINTS = olympSettings.getProperty("AltOlyRank3Points", 45);
		ALT_OLY_RANK4_POINTS = olympSettings.getProperty("AltOlyRank4Points", 40);
		ALT_OLY_RANK5_POINTS = olympSettings.getProperty("AltOlyRank5Points", 30);
		OLYMPIAD_ALL_LOOSE_POINTS_BONUS = olympSettings.getProperty("OLYMPIAD_ALL_LOOSE_POINTS_BONUS", 5);
		OLYMPIAD_1_OR_MORE_WIN_POINTS_BONUS = olympSettings.getProperty("OLYMPIAD_1_OR_MORE_WIN_POINTS_BONUS", 10);
		OLYMPIAD_STADIAS_COUNT = olympSettings.getProperty("OlympiadStadiasCount", 160);
		OLYMPIAD_BATTLES_FOR_REWARD = olympSettings.getProperty("OlympiadBattlesForReward", 10);
		OLYMPIAD_POINTS_DEFAULT = olympSettings.getProperty("OlympiadPointsDefault", 10);
		OLYMPIAD_POINTS_WEEKLY = olympSettings.getProperty("OlympiadPointsWeekly", 10);
		OLYMPIAD_OLDSTYLE_STAT = olympSettings.getProperty("OlympiadOldStyleStat", false);
		OLYMPIAD_CANATTACK_BUFFER = olympSettings.getProperty("OlympiadCanAttackBuffer", true);

		OLYMPIAD_BEGINIG_DELAY = olympSettings.getProperty("OlympiadBeginingDelay", 120);

		ALT_OLY_BY_SAME_BOX_NUMBER = olympSettings.getProperty("OlympiadSameBoxesNumberLimitation", 0);

		OLYMPIAD_ENABLE_ENCHANT_LIMIT = olympSettings.getProperty("ENABLE_ENCHANT_LIMIT", false);
		OLYMPIAD_WEAPON_ENCHANT_LIMIT = olympSettings.getProperty("WEAPON_ENCHANT_LIMIT", 0);
		OLYMPIAD_ARMOR_ENCHANT_LIMIT = olympSettings.getProperty("ARMOR_ENCHANT_LIMIT", 0);
		OLYMPIAD_JEWEL_ENCHANT_LIMIT = olympSettings.getProperty("JEWEL_ENCHANT_LIMIT", 0);
		OLYMPIAD_FOR_AWAKED_CLASS_ONLY = olympSettings.getProperty("OLYMPIAD_FOR_AWAKED_CLASS_ONLY", false);
	}

	public static void load()
	{
		loadServerConfig();
		loadSkillLearnSetting();// DM
		loadMultiClassConfig(); // DM
		loadTelnetConfig();
		loadResidenceConfig();
		loadChatAntiFloodConfig();
		loadCustomConfig();
		loadOtherConfig();
		loadSpoilConfig();
		loadFormulasConfig();
		loadAltSettings();
		loadServicesSettings();
		loadPvPSettings();
		loadAISettings();
		loadGeodataSettings();
		loadEventsSettings();
		loadFightClubSettings();
		loadOlympiadSettings();
		loadDevelopSettings();
		loadExtSettings();
		loadBBSSettings();
		loadSchemeBuffer();
		loadBuffStoreConfig();
		loadTrainingCampConfig();

		abuseLoad();
		loadGMAccess();
		pvpManagerSettings();
		loadAntiBotSettings();
		loadStatBonusConfig();
		loadWorldExchange();
	}

	private Config()
	{}

	public static void abuseLoad()
	{
		LineNumberReader lnr = null;
		try
		{
			StringBuilder abuses = new StringBuilder();

			String line;

			lnr = new LineNumberReader(new InputStreamReader(new FileInputStream(ANUSEWORDS_CONFIG_FILE), "UTF-8"));

			int count = 0;
			while((line = lnr.readLine()) != null)
			{
				StringTokenizer st = new StringTokenizer(line, "\n\r");
				if(st.hasMoreTokens())
				{
					abuses.append(st.nextToken());
					abuses.append("|");
					count++;
				}
			}

			if(count > 0)
			{
				String abusesGroup = abuses.toString();
				abusesGroup = abusesGroup.substring(0, abusesGroup.length() - 1);
				ABUSEWORD_PATTERN = Pattern.compile(".*(" + abusesGroup + ").*", Pattern.DOTALL | Pattern.CASE_INSENSITIVE | Pattern.UNICODE_CASE);
			}

			_log.info("Abuse: Loaded " + count + " abuse words.");
		}
		catch(IOException e1)
		{
			_log.warn("Error reading abuse: " + e1);
		}
		finally
		{
			try
			{
				if(lnr != null)
					lnr.close();
			}
			catch(Exception e2)
			{
				// nothing
			}
		}
	}

	public static void loadAntiBotSettings()
	{
		ExProperties botSettings = load(BOT_FILE);
		
		ENABLE_ANTI_BOT_SYSTEM = botSettings.getProperty("EnableAntiBotSystem", false);
		MINIMUM_TIME_QUESTION_ASK = botSettings.getProperty("MinimumTimeQuestionAsk", 60);
		MAXIMUM_TIME_QUESTION_ASK = botSettings.getProperty("MaximumTimeQuestionAsk", 120);
		MINIMUM_BOT_POINTS_TO_STOP_ASKING = botSettings.getProperty("MinimumBotPointsToStopAsking", 10);
		MAXIMUM_BOT_POINTS_TO_STOP_ASKING = botSettings.getProperty("MaximumBotPointsToStopAsking", 15);
		MAX_BOT_POINTS = botSettings.getProperty("MaxBotPoints", 15);
		MINIMAL_BOT_RATING_TO_BAN = botSettings.getProperty("MinimalBotPointsToBan", -5);
		AUTO_BOT_BAN_JAIL_TIME = botSettings.getProperty("AutoBanJailTime", 24);
		ANNOUNCE_AUTO_BOT_BAN = botSettings.getProperty("AnounceAutoBan", true);
		ON_WRONG_QUESTION_KICK = botSettings.getProperty("IfWrongKick", true);
	}
	
	public static void loadSchemeBuffer()
	{
		ExProperties npcbuffer = load(SCHEME_BUFFER_FILE);

		NpcBuffer_VIP = npcbuffer.getProperty("EnableVIP", false);
		NpcBuffer_VIP_ALV = npcbuffer.getProperty("VipAccesLevel", 1);
		NpcBuffer_EnableBuff = npcbuffer.getProperty("EnableBuffSection", true);
		NpcBuffer_EnableScheme = npcbuffer.getProperty("EnableScheme", true);
		NpcBuffer_EnableHeal = npcbuffer.getProperty("EnableHeal", true);
		NpcBuffer_EnableBuffs = npcbuffer.getProperty("EnableBuffs", true);
		NpcBuffer_EnableResist = npcbuffer.getProperty("EnableResist", true);
		NpcBuffer_EnableSong = npcbuffer.getProperty("EnableSongs", true);
		NpcBuffer_EnableDance = npcbuffer.getProperty("EnableDances", true);
		NpcBuffer_EnableChant = npcbuffer.getProperty("EnableChants", true);
		NpcBuffer_EnableOther = npcbuffer.getProperty("EnableOther", true);
		NpcBuffer_EnableSpecial = npcbuffer.getProperty("EnableSpecial", true);
		NpcBuffer_EnableCubic = npcbuffer.getProperty("EnableCubic", true);
		NpcBuffer_EnableCancel = npcbuffer.getProperty("EnableRemoveBuffs", true);
		NpcBuffer_EnableBuffSet = npcbuffer.getProperty("EnableBuffSet", true);
		NpcBuffer_EnableBuffPK = npcbuffer.getProperty("EnableBuffForPK", false);
		NpcBuffer_EnableFreeBuffs = npcbuffer.getProperty("EnableFreeBuffs", true);
		NpcBuffer_EnableTimeOut = npcbuffer.getProperty("EnableTimeOut", true);
		SCHEME_ALLOW_FLAG = npcbuffer.getProperty("EnableBuffforFlag", false);
		NpcBuffer_TimeOutTime = npcbuffer.getProperty("TimeoutTime", 10);
		NpcBuffer_MinLevel = npcbuffer.getProperty("MinimumLevel", 20);
		NpcBuffer_PriceCancel = npcbuffer.getProperty("RemoveBuffsPrice", 100000);
		NpcBuffer_PriceHeal = npcbuffer.getProperty("HealPrice", 100000);
		NpcBuffer_PriceBuffs = npcbuffer.getProperty("BuffsPrice", 100000);
		NpcBuffer_PriceResist = npcbuffer.getProperty("ResistPrice", 100000);
		NpcBuffer_PriceSong = npcbuffer.getProperty("SongPrice", 100000);
		NpcBuffer_PriceDance = npcbuffer.getProperty("DancePrice", 100000);
		NpcBuffer_PriceChant = npcbuffer.getProperty("ChantsPrice", 100000);
		NpcBuffer_PriceOther = npcbuffer.getProperty("OtherPrice", 100000);
		NpcBuffer_PriceSpecial = npcbuffer.getProperty("SpecialPrice", 100000);
		NpcBuffer_PriceCubic = npcbuffer.getProperty("CubicPrice", 100000);
		NpcBuffer_PriceSet = npcbuffer.getProperty("SetPrice", 100000);
		NpcBuffer_PriceScheme = npcbuffer.getProperty("SchemePrice", 100000);
		NpcBuffer_MaxScheme = npcbuffer.getProperty("MaxScheme", 4);
		IS_DISABLED_IN_REFLECTION = npcbuffer.getProperty("DisableBufferInReflection", true);
	}

	public static void loadBuffStoreConfig()
	{
		ExProperties buffStoreConfig = load(BUFF_STORE_CONFIG_FILE);

		// Buff Store
		BUFF_STORE_ENABLED = buffStoreConfig.getProperty("BuffStoreEnabled", false);
		BUFF_STORE_MP_ENABLED = buffStoreConfig.getProperty("BuffStoreMpEnabled", true);
		BUFF_STORE_MP_CONSUME_MULTIPLIER = buffStoreConfig.getProperty("BuffStoreMpConsumeMultiplier", 1.0f);
		BUFF_STORE_ITEM_CONSUME_ENABLED = buffStoreConfig.getProperty("BuffStoreItemConsumeEnabled", true);

		BUFF_STORE_NAME_COLOR = Integer.decode("0x" + buffStoreConfig.getProperty("BuffStoreNameColor", "808080"));
		BUFF_STORE_TITLE_COLOR = Integer.decode("0x" + buffStoreConfig.getProperty("BuffStoreTitleColor", "808080"));
		BUFF_STORE_OFFLINE_NAME_COLOR = Integer.decode("0x" + buffStoreConfig.getProperty("BuffStoreOfflineNameColor", "808080"));

		BUFF_STORE_ALLOWED_CLASS_LIST.addAll(StringArrayUtils.stringToIntArray(buffStoreConfig.getProperty("BuffStoreAllowedClassList", ""), ","));
		BUFF_STORE_ALLOWED_SKILL_LIST.addAll(StringArrayUtils.stringToIntArray(buffStoreConfig.getProperty("BUFF_STORE_ALLOWED_SKILL_LIST", ""), ","));

		BUFF_STORE_MIN_PRICE = buffStoreConfig.getProperty("BuffStoreMinPrice", 1);
		BUFF_STORE_MAX_PRICE = buffStoreConfig.getProperty("BuffStoreMaxPrice", Long.MAX_VALUE);
	}

	public static void loadDragonValleyZoneSettings()
	{
		ExProperties properties = load(ZONE_DRAGONVALLEY_FILE);
		NECROMANCER_MS_CHANCE = properties.getProperty("NecromancerMSChance", 0);
		DWARRIOR_MS_CHANCE = properties.getProperty("DWarriorMSChance", 0.0);
		DHUNTER_MS_CHANCE = properties.getProperty("DHunterMSChance", 0.0);
		BDRAKE_MS_CHANCE = properties.getProperty("BDrakeMSChance", 0);
		EDRAKE_MS_CHANCE = properties.getProperty("EDrakeMSChance", 0);
	}

	public static void loadLairOfAntharasZoneSettings()
	{
		ExProperties properties = load(ZONE_LAIROFANTHARAS_FILE);
		BKARIK_D_M_CHANCE = properties.getProperty("BKarikDMSChance", 0);
	}

	public static void loadTrainingCampConfig()
	{
		ExProperties properties = load(TRAINING_CAMP_CONFIG_FILE);

		TRAINING_CAMP_ENABLE = properties.getProperty("ENABLE", false);
		TRAINING_CAMP_PREMIUM_ONLY = properties.getProperty("PREMIUM_ONLY", true);
		TRAINING_CAMP_MAX_DURATION = properties.getProperty("MAX_DURATION", 18000);
		TRAINING_CAMP_MIN_LEVEL = properties.getProperty("MIN_LEVEL", 18);
		TRAINING_CAMP_MAX_LEVEL = properties.getProperty("MAX_LEVEL", 127);
	}
	
	public static void loadGMAccess()
	{
		gmlist.clear();
		loadGMAccess(new File(GM_PERSONAL_ACCESS_FILE));
		File dir = new File(GM_ACCESS_FILES_DIR);
		if(!dir.exists() || !dir.isDirectory())
		{
			_log.info("Dir " + dir.getAbsolutePath() + " not exists.");
			return;
		}
		for(File f : dir.listFiles())
			// hidden файлы НЕ игнорируем
			if(!f.isDirectory() && f.getName().endsWith(".xml"))
				loadGMAccess(f);
	}

	public static void loadGMAccess(File file)
	{
		try
		{
			Field fld;
			//File file = new File(filename);
			DocumentBuilderFactory factory = DocumentBuilderFactory.newInstance();
			factory.setValidating(false);
			factory.setIgnoringComments(true);
			Document doc = factory.newDocumentBuilder().parse(file);

			for(Node z = doc.getFirstChild(); z != null; z = z.getNextSibling())
				for(Node n = z.getFirstChild(); n != null; n = n.getNextSibling())
				{
					if(!n.getNodeName().equalsIgnoreCase("char"))
						continue;

					PlayerAccess pa = new PlayerAccess();
					for(Node d = n.getFirstChild(); d != null; d = d.getNextSibling())
					{
						Class<?> cls = pa.getClass();
						String node = d.getNodeName();

						if(node.equalsIgnoreCase("#text"))
							continue;
						try
						{
							fld = cls.getField(node);
						}
						catch(NoSuchFieldException e)
						{
							_log.info("Not found desclarate ACCESS name: " + node + " in XML Player access Object");
							continue;
						}

						if(fld.getType().getName().equalsIgnoreCase("boolean"))
							fld.setBoolean(pa, Boolean.parseBoolean(d.getAttributes().getNamedItem("set").getNodeValue()));
						else if(fld.getType().getName().equalsIgnoreCase("int"))
							fld.setInt(pa, Integer.valueOf(d.getAttributes().getNamedItem("set").getNodeValue()));
					}
					gmlist.put(pa.PlayerID, pa);
				}
		}
		catch(Exception e)
		{
			e.printStackTrace();
		}
	}

	public static String getField(String fieldName)
	{
		Field field = FieldUtils.getField(Config.class, fieldName);

		if(field == null)
			return null;

		try
		{
			return String.valueOf(field.get(null));
		}
		catch(IllegalArgumentException e)
		{

		}
		catch(IllegalAccessException e)
		{

		}

		return null;
	}

	public static boolean setField(String fieldName, String value)
	{
		Field field = FieldUtils.getField(Config.class, fieldName);

		if(field == null)
			return false;

		try
		{
			if(field.getType() == boolean.class)
				field.setBoolean(null, BooleanUtils.toBoolean(value));
			else if(field.getType() == int.class)
				field.setInt(null, NumberUtils.toInt(value));
			else if(field.getType() == long.class)
				field.setLong(null, NumberUtils.toLong(value));
			else if(field.getType() == double.class)
				field.setDouble(null, NumberUtils.toDouble(value));
			else if(field.getType() == String.class)
				field.set(null, value);
			else
				return false;
		}
		catch(IllegalArgumentException e)
		{
			return false;
		}
		catch(IllegalAccessException e)
		{
			return false;
		}

		return true;
	}

	public static ExProperties load(String filename)
	{
		return load(new File(filename));
	}

	public static ExProperties load(File file)
	{
		ExProperties result = new ExProperties();

		try
		{
			result.load(file);
		}
		catch(IOException e)
		{
			_log.error("Error loading config : " + file.getName() + "!");
		}

		return result;
	}

	public static boolean containsAbuseWord(String s)
	{
		if(ABUSEWORD_PATTERN == null)
			return false;
		return ABUSEWORD_PATTERN.matcher(s).matches();
	}

	public static String replaceAbuseWords(String text, String censore)
	{
		if(ABUSEWORD_PATTERN == null)
			return text;
		Matcher m = ABUSEWORD_PATTERN.matcher(text);
		while(m.find())
			text = text.replace(m.group(1), censore);
		return text;
	}

}