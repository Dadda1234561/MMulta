package bosses;

import l2s.commons.configuration.ExProperties;
import l2s.commons.string.StringArrayUtils;
import l2s.commons.time.cron.SchedulingPattern;
import l2s.gameserver.Config;
import l2s.gameserver.listener.script.OnLoadScriptListener;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

/**
 * @author Bonux
**/
public class BossesConfig implements OnLoadScriptListener
{
	private static final Logger _log = LoggerFactory.getLogger(BossesConfig.class);

	private static final String PROPERTIES_FILE = "config/bosses.properties";

	// Antharas
	public static SchedulingPattern ANTHARAS_RESPAWN_TIME_PATTERN;
	public static int ANTHARAS_SPAWN_DELAY;
	public static int ANTHARAS_SLEEP_TIME;
	public static int ANTHARAS_MIN_MEMBERS_COUNT;
	public static int ANTHARAS_MAX_MEMBERS_COUNT;
	public static int ANTHARAS_MEMBER_MIN_LEVEL;
	public static int[][] ANTHARAS_ENTERANCE_NECESSARY_ITEMS;
	public static boolean ANTHARAS_ENTERANCE_CAN_CONSUME_NECESSARY_ITEMS;

	// Valakas
	public static SchedulingPattern VALAKAS_RESPAWN_TIME_PATTERN;
	public static int VALAKAS_SPAWN_DELAY;
	public static int VALAKAS_SLEEP_TIME;
	public static int VALAKAS_MIN_MEMBERS_COUNT;
	public static int VALAKAS_MAX_MEMBERS_COUNT;
	public static int VALAKAS_MEMBER_MIN_LEVEL;
	public static int[][] VALAKAS_ENTERANCE_NECESSARY_ITEMS;
	public static boolean VALAKAS_ENTERANCE_CAN_CONSUME_NECESSARY_ITEMS;

	// Baium
	public static SchedulingPattern BAIUM_RESPAWN_TIME_PATTERN;
	public static int BAIUM_RAID_DURATION;
	public static int BAIUM_SLEEP_TIME;
	public static int[][] BAIUM_ENTERANCE_NECESSARY_ITEMS;
	public static boolean BAIUM_ENTERANCE_CAN_CONSUME_NECESSARY_ITEMS;

	// Sailren
	public static SchedulingPattern SAILREN_RESPAWN_TIME_PATTERN;
	public static int SAILREN_ACTIVITY_MONSTERS_SPAWN_DELAY;
	public static int SAILREN_ACTIVITY_MONSTERS_RESPAWN_DELAY;
	public static boolean SAILREN_SINGLE_ENTARANCE_AVAILABLE;

	// Baylor
	public static SchedulingPattern BAYLOR_RESPAWN_TIME_PATTERN;
	public static boolean BAYLOR_SINGLE_ENTARANCE_AVAILABLE;

	// Beleth
	public static SchedulingPattern BELETH_RESPAWN_TIME_PATTERN;
	public static int BELETH_INACTIVITY_CHECK_DELAY;

	// Helios
	public static SchedulingPattern HELIOS_RESPAWN_TIME_PATTERN;
	public static int HELIOS_SPAWN_DELAY;
	public static int HELIOS_SLEEP_TIME;
	public static int HELIOS_MIN_MEMBERS_COUNT;
	public static int HELIOS_MAX_MEMBERS_COUNT;
	public static int HELIOS_MEMBER_MIN_LEVEL;
	public static int[][] HELIOS_ENTERANCE_NECESSARY_ITEMS;
	public static boolean HELIOS_ENTERANCE_CAN_CONSUME_NECESSARY_ITEMS;

	@Override
	public void onLoad()
	{
		ExProperties properties = Config.load(PROPERTIES_FILE);

		// Antharas
		ANTHARAS_RESPAWN_TIME_PATTERN = new SchedulingPattern(properties.getProperty("ANTHARAS_RESPAWN_TIME_PATTERN", "40 20 * * 2,5"));
		ANTHARAS_SPAWN_DELAY = properties.getProperty("ANTHARAS_SPAWN_DELAY", 5);
		ANTHARAS_SLEEP_TIME = properties.getProperty("ANTHARAS_SLEEP_TIME", 15);
		ANTHARAS_MIN_MEMBERS_COUNT = properties.getProperty("ANTHARAS_MIN_MEMBERS_COUNT", 49);
		ANTHARAS_MAX_MEMBERS_COUNT = properties.getProperty("ANTHARAS_MAX_MEMBERS_COUNT", 200);
		ANTHARAS_MEMBER_MIN_LEVEL = properties.getProperty("ANTHARAS_MEMBER_MIN_LEVEL", 95);
		ANTHARAS_ENTERANCE_NECESSARY_ITEMS = StringArrayUtils.stringToIntArray2X(properties.getProperty("ANTHARAS_ENTERANCE_NECESSARY_ITEMS", "3865-1"), ";", "-");
		ANTHARAS_ENTERANCE_CAN_CONSUME_NECESSARY_ITEMS = properties.getProperty("ANTHARAS_ENTERANCE_CAN_CONSUME_NECESSARY_ITEMS", false);

		// Valakas
		VALAKAS_RESPAWN_TIME_PATTERN = new SchedulingPattern(properties.getProperty("VALAKAS_RESPAWN_TIME_PATTERN", "30 20 * * 3,6"));
		VALAKAS_SPAWN_DELAY = properties.getProperty("VALAKAS_SPAWN_DELAY", 10);
		VALAKAS_SLEEP_TIME = properties.getProperty("VALAKAS_SLEEP_TIME", 20);
		VALAKAS_MIN_MEMBERS_COUNT = properties.getProperty("VALAKAS_MIN_MEMBERS_COUNT", 49);
		VALAKAS_MAX_MEMBERS_COUNT = properties.getProperty("VALAKAS_MAX_MEMBERS_COUNT", 200);
		VALAKAS_MEMBER_MIN_LEVEL = properties.getProperty("VALAKAS_MEMBER_MIN_LEVEL", 95);
		VALAKAS_ENTERANCE_NECESSARY_ITEMS = StringArrayUtils.stringToIntArray2X(properties.getProperty("VALAKAS_ENTERANCE_NECESSARY_ITEMS", "7267-1"), ";", "-");
		VALAKAS_ENTERANCE_CAN_CONSUME_NECESSARY_ITEMS = properties.getProperty("VALAKAS_ENTERANCE_CAN_CONSUME_NECESSARY_ITEMS", true);

		// Baium
		BAIUM_RESPAWN_TIME_PATTERN = new SchedulingPattern(properties.getProperty("BAIUM_RESPAWN_TIME_PATTERN", "00 20 * * 4,7"));
		BAIUM_RAID_DURATION = properties.getProperty("BAIUM_RAID_DURATION", 60);
		BAIUM_SLEEP_TIME = properties.getProperty("BAIUM_SLEEP_TIME", 30);
		BAIUM_ENTERANCE_NECESSARY_ITEMS = StringArrayUtils.stringToIntArray2X(properties.getProperty("BAIUM_ENTERANCE_NECESSARY_ITEMS", "0-0"), ";", "-");
		BAIUM_ENTERANCE_CAN_CONSUME_NECESSARY_ITEMS = properties.getProperty("BAIUM_ENTERANCE_CAN_CONSUME_NECESSARY_ITEMS", false);

		// Sailren
		SAILREN_RESPAWN_TIME_PATTERN = new SchedulingPattern(properties.getProperty("SAILREN_RESPAWN_TIME_PATTERN", "~1440:* * +1:* * *"));
		SAILREN_ACTIVITY_MONSTERS_SPAWN_DELAY = properties.getProperty("SAILREN_ACTIVITY_MONSTERS_SPAWN_DELAY", 120);
		SAILREN_ACTIVITY_MONSTERS_RESPAWN_DELAY = properties.getProperty("SAILREN_ACTIVITY_MONSTERS_RESPAWN_DELAY", 1);
		SAILREN_SINGLE_ENTARANCE_AVAILABLE = properties.getProperty("SAILREN_SINGLE_ENTARANCE_AVAILABLE", true);

		// Baylor
		BAYLOR_RESPAWN_TIME_PATTERN = new SchedulingPattern(properties.getProperty("BAYLOR_RESPAWN_TIME_PATTERN", "~1440:* * +1:* * *"));
		BAYLOR_SINGLE_ENTARANCE_AVAILABLE = properties.getProperty("BAYLOR_SINGLE_ENTARANCE_AVAILABLE", false);

		// Beleth
		BELETH_RESPAWN_TIME_PATTERN = new SchedulingPattern(properties.getProperty("BELETH_RESPAWN_TIME_PATTERN", "~1440:* * +1:* * *"));
		BELETH_INACTIVITY_CHECK_DELAY = properties.getProperty("BELETH_INACTIVITY_CHECK_DELAY", 120);

		// Helios
		HELIOS_RESPAWN_TIME_PATTERN = new SchedulingPattern(properties.getProperty("HELIOS_RESPAWN_TIME_PATTERN", "~480:* * +14:* * *"));
		HELIOS_SPAWN_DELAY = properties.getProperty("HELIOS_SPAWN_DELAY", 0);
		HELIOS_SLEEP_TIME = properties.getProperty("HELIOS_SLEEP_TIME", 15);
		HELIOS_MIN_MEMBERS_COUNT = properties.getProperty("HELIOS_MIN_MEMBERS_COUNT", 70);
		HELIOS_MAX_MEMBERS_COUNT = properties.getProperty("HELIOS_MAX_MEMBERS_COUNT", 120);
		HELIOS_MEMBER_MIN_LEVEL = properties.getProperty("HELIOS_MEMBER_MIN_LEVEL", 103);
		HELIOS_ENTERANCE_NECESSARY_ITEMS = StringArrayUtils.stringToIntArray2X(properties.getProperty("HELIOS_ENTERANCE_NECESSARY_ITEMS", ""), ";", "-");
		HELIOS_ENTERANCE_CAN_CONSUME_NECESSARY_ITEMS = properties.getProperty("HELIOS_ENTERANCE_CAN_CONSUME_NECESSARY_ITEMS", false);
	}
}