package bosses;

import l2s.commons.time.cron.SchedulingPattern;
import l2s.gameserver.geometry.Location;
import l2s.gameserver.listener.script.OnInitScriptListener;
import l2s.gameserver.network.l2.components.SceneMovie;

/**
 * @author Bonux
 * TODO: Написано все наугад. По возможности переписать под офф.
**/
public class AnakimManager extends SevenSignsRaidManager implements OnInitScriptListener
{
	// Raid Properties
	private static final int MIN_LEVEL = 1;	// Минимальный уровень персонажа для входа в логово
	private static final int MAX_LEVEL = 94;	// Максимальный уровень персонажа для входа в логово
	private static final int MIN_MEMBERS_COUNT = 1;	// Минимальное количество участников для входа в комнату босса
	private static final int MAX_MEMBERS_COUNT = Integer.MAX_VALUE;	// Максимальное количество участников для входа в комнату босса
	private static final SchedulingPattern REUSE_PATTERN = new SchedulingPattern("0 21 * * 4|0 14 * * 6"); // Время отката рейда (Каждый четверг в 21:00 и каждую субботу в 14:00)

	// Dungeon Parameters
	private static final Location DUNGEON_ENTER_LOCATION = new Location(172488, -17608, -4924);	// Точка входа в логово
	private static final Location DUNGEON_EXIT_LOCATION = new Location(171768, -17608, -4926);	// Точка выхода из логова
	private static final Location DUNGEON_OUTSIDE_LOCATION = new Location(168504, -18008, -3198);	// Точка снаружи логова
	private static final Location RAID_ENTER_LOCATION = new Location(185080, -12008, -5518);	// Точка входа к рейду

	// Other
	private static final String DUNGEON_STATUS_VAR = "anakim_dungeon_status";
	private static final SceneMovie RAID_ENTER_SCENE_MOVIE = SceneMovie.SCENE_NECRO;	// Видео при входе к рейду

	// Zone's
	private static final String DUNGEON_RAID_ZONE_NAME = "[anakim_dungeon_raid]";

	// NPC's
	private static final int GATEKEEPER_ZIGGURAT = 31101;	//	Хранитель Портала Зиккурат

	// Monster's
	private static final int FALLEN_ANGEL_ANAKIM = 25286;	// Анаким - Падший Ангел

	// Spawn Group's
	private static final String DUNGEON_MONSTERS_SPAWN_GROUP = "anakim_dungeon_monsters";
	private static final String SEAL_REMNANTS_SPAWN_GROUP = "anakim_seal_remnants";
	private static final String RAID_SPAWN_GROUP = "anakim_dungeon_raid";
	private static final String RAID_ZIGGURAT_SPAWN_GROUP = "anakim_dungeon_raid_ziggurat";

	private static AnakimManager _instance;

	public static AnakimManager getInstance()
	{
		return _instance;
	}

	@Override
	public void onInit()
	{
		_instance = this;
		super.onInit();
	}

	@Override
	protected int getMinLevel()
	{
		return MIN_LEVEL;
	}

	@Override
	protected int getMaxLevel()
	{
		return MAX_LEVEL;
	}

	@Override
	protected int getMinMembersCount()
	{
		return MIN_MEMBERS_COUNT;
	}

	@Override
	protected int getMaxMembersCount()
	{
		return MAX_MEMBERS_COUNT;
	}

	@Override
	protected SchedulingPattern getReusePattern()
	{
		return REUSE_PATTERN;
	}

	@Override
	protected Location getEnterLocation()
	{
		return DUNGEON_ENTER_LOCATION;
	}

	@Override
	protected Location getExitLocation()
	{
		return DUNGEON_EXIT_LOCATION;
	}

	@Override
	protected Location getOutsideLocation()
	{
		return DUNGEON_OUTSIDE_LOCATION;
	}

	@Override
	protected Location getRaidEnterLocation()
	{
		return RAID_ENTER_LOCATION;
	}

	@Override
	protected String getDungeonStatusVar()
	{
		return DUNGEON_STATUS_VAR;
	}

	@Override
	protected String getDungeonZoneName() {
		return null;
	}

	@Override
	protected String getRaidZoneName()
	{
		return DUNGEON_RAID_ZONE_NAME;
	}

	@Override
	protected SceneMovie getRaidEnterSceneMovie()
	{
		return RAID_ENTER_SCENE_MOVIE;
	}

	@Override
	protected int getEnterGatekeeperId()
	{
		return GATEKEEPER_ZIGGURAT;
	}

	@Override
	protected int getRaidId()
	{
		return FALLEN_ANGEL_ANAKIM;
	}

	@Override
	protected String getDungeonMonstersSpawnGroup()
	{
		return DUNGEON_MONSTERS_SPAWN_GROUP;
	}

	@Override
	protected String getSealRemnantsSpawnGroup()
	{
		return SEAL_REMNANTS_SPAWN_GROUP;
	}

	@Override
	protected String getRaidSpawnGroup()
	{
		return RAID_SPAWN_GROUP;
	}

	@Override
	protected String getRaidZigguratSpawnGroup()
	{
		return RAID_ZIGGURAT_SPAWN_GROUP;
	}
}