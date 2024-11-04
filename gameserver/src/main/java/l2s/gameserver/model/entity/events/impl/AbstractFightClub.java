package l2s.gameserver.model.entity.events.impl;

import java.lang.reflect.InvocationTargetException;
import java.util.*;
import java.util.Map.Entry;
import java.util.concurrent.ConcurrentHashMap;
import java.util.concurrent.ScheduledFuture;
import java.util.concurrent.atomic.AtomicInteger;

import l2s.gameserver.Announcements;
import l2s.gameserver.Config;
import l2s.gameserver.data.string.ItemNameHolder;
import l2s.gameserver.model.*;
import l2s.gameserver.model.instances.SummonInstance;
import l2s.gameserver.model.items.PcInventory;
import l2s.gameserver.model.reward.RewardData;
import l2s.gameserver.network.l2.components.CustomMessage;
import l2s.gameserver.network.l2.s2c.ExUserInfoAbnormalVisualEffect;
import l2s.gameserver.skills.AbnormalEffect;
import l2s.gameserver.utils.Language;
import org.apache.commons.lang3.reflect.MethodUtils;
import org.napile.primitive.maps.IntObjectMap;
import org.napile.primitive.maps.impl.HashIntObjectMap;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import l2s.commons.collections.MultiValueSet;
import l2s.commons.util.Rnd;
import l2s.gameserver.ThreadPoolManager;
import l2s.gameserver.data.xml.holder.InstantZoneHolder;
import l2s.gameserver.data.xml.holder.SkillHolder;
import l2s.gameserver.geometry.Location;
import l2s.gameserver.listener.actor.player.OnPlayerExitListener;
import l2s.gameserver.listener.zone.OnZoneEnterLeaveListener;
import l2s.gameserver.model.actor.instances.creature.Abnormal;
import l2s.gameserver.model.base.RestartType;
import l2s.gameserver.model.entity.Reflection;
import l2s.gameserver.model.entity.events.Event;
import l2s.gameserver.model.entity.events.EventType;
import l2s.gameserver.model.entity.events.fightclubmanager.FightClubEventManager;
import l2s.gameserver.model.entity.events.fightclubmanager.FightClubGameRoom;
import l2s.gameserver.model.entity.events.fightclubmanager.FightClubLastStatsManager;
import l2s.gameserver.model.entity.events.fightclubmanager.FightClubLastStatsManager.FightClubStatType;
import l2s.gameserver.model.entity.events.fightclubmanager.FightClubMap;
import l2s.gameserver.model.entity.events.fightclubmanager.FightClubPlayer;
import l2s.gameserver.model.entity.events.fightclubmanager.FightClubTeam;
import l2s.gameserver.model.entity.events.fightclubmanager.enums.EventState;
import l2s.gameserver.model.entity.events.fightclubmanager.enums.MessageType;
import l2s.gameserver.model.entity.events.fightclubmanager.enums.PlayerClass;
import l2s.gameserver.model.instances.DoorInstance;
import l2s.gameserver.model.instances.NpcInstance;
import l2s.gameserver.network.l2.components.ChatType;
import l2s.gameserver.network.l2.components.SystemMsg;
import l2s.gameserver.network.l2.s2c.EarthQuakePacket;
import l2s.gameserver.network.l2.s2c.ExPVPMatchCCRecord;
import l2s.gameserver.network.l2.s2c.ExPVPMatchCCRetire;
import l2s.gameserver.network.l2.s2c.ExShowScreenMessage;
import l2s.gameserver.network.l2.s2c.RelationChangedPacket;
import l2s.gameserver.network.l2.s2c.RevivePacket;
import l2s.gameserver.network.l2.s2c.SayPacket2;
import l2s.gameserver.network.l2.s2c.ShowTutorialMarkPacket;
import l2s.gameserver.network.l2.s2c.SkillCoolTimePacket;
import l2s.gameserver.templates.DoorTemplate;
import l2s.gameserver.templates.InstantZone;
import l2s.gameserver.templates.ZoneTemplate;
import l2s.gameserver.utils.TimeUtils;
import l2s.gameserver.utils.Util;

public abstract class AbstractFightClub extends Event
{
	protected static final Logger _log = LoggerFactory.getLogger(AbstractFightClub.class);

	public static final String REGISTERED_PLAYERS = "registered_players";
	public static final String LOGGED_OFF_PLAYERS = "logged_off_players";
	public static final String FIGHTING_PLAYERS = "fighting_players";

	private final List<ScheduledFuture<?>> _tasks = new ArrayList<>();

	public static final int INSTANT_ZONE_ID = 400;
	private static int LAST_OBJECT_ID = 1;

	// TODO Make it configurable inside Config files.
	private static final int BADGES_FOR_MINUTE_OF_AFK = -1;
	private static final int CLOSE_LOCATIONS_VALUE = 80;

	private static final int TIME_FIRST_TELEPORT = 10;
	private static final int TIME_PLAYER_TELEPORTING = 5;
	private static final int TIME_PREPARATION_BEFORE_FIRST_ROUND = 30;
	private static final int TIME_PREPARATION_BETWEEN_NEXT_ROUNDS = 30;
	private static final int TIME_AFTER_ROUND_END_TO_RETURN_SPAWN = 15;
	private static final int TIME_TELEPORT_BACK_TOWN = 30;
	private static final int TIME_MAX_SECONDS_OUTSIDE_ZONE = 10;
	private static final int TIME_TO_BE_AFK = 30;

	private static final String[] ROUND_NUMBER_IN_STRING =
	{
		"",
		"1st", "2nd", "3rd", "4th", "5th", "6th", "7th", "8th", "9th", "10th",
		"11th", "12th", "13th", "14th", "15th", "16th", "17th", "18th", "19th", "20th",
		"21st", "22nd", "23rd", "24th", "25th", "26th", "27th", "28th", "29th", "30th",
		"31st", "32nd", "33rd", "34th", "35th", "36th", "37th", "38th", "39th", "40th",
		"41st", "42nd", "43rd", "44th", "45th", "46th", "47th", "48th", "49th", "50th"
	};

	private final int _objId;
	private final String _desc;
	private final String _descRu;
	private final String _icon;
	private final int _roundRunTime;
	private final boolean _isAutoTimed;
	private final boolean _sendInvites;
	private final int[][] _autoStartTimes;
	private final boolean _teamed;
	private final boolean _buffer;
	private final int[][] _fighterBuffs;
	private final int[][] _mageBuffs;
	private final boolean _rootBetweenRounds;
	private final PlayerClass[] _excludedClasses;
	private final RewardData[] _additionalRewards;
	private final int[] _excludedSkills;
	private final boolean _roundEvent;
	private final int _rounds;
	private final int _respawnTime;
	private final int _minLevel;
	private final int _maxLevel;
	private final int _rebirthCnt;
	private final boolean _ressAllowed;
	private final boolean _instanced;
	private final boolean _showPersonality;
	private final double _badgesKillPlayer;
	private final int _badgesIdWin;
	private final int _badgesIdLose;
	private final double _badgesKillPet;
	protected boolean _preparing = false;
	private final double _badgesDie;
	protected final double _badgeWin;
	protected final double _badgeLose;
	private final int topKillerReward;
	private EventState _state = EventState.NOT_ACTIVE;
	private ExitListener _exitListener = new ExitListener();
	private ZoneListener _zoneListener = new ZoneListener();
	private FightClubMap _map;
	private Reflection _reflection;
	private List<FightClubTeam> _teams = new ArrayList<FightClubTeam>();
	private Map<FightClubPlayer, Zone> _leftZone = new ConcurrentHashMap<FightClubPlayer, Zone>();
	private int _currentRound = 0;
	private boolean _dontLetAnyoneIn = false;
	private FightClubGameRoom _room;
	private MultiValueSet<String> _set;
	private Map<String, Integer> _scores = new ConcurrentHashMap<String, Integer>();
	private Map<String, Integer> _bestScores = new ConcurrentHashMap<String, Integer>();
	private boolean _scoredUpdated = true;
	private boolean _isForceScheduled = false;
	private long _startTimeMillis = 0;
	private ScheduledFuture<?> _timer;
	private List<ScheduledFuture<?>> _secondaryTimers;
	private List<ScheduledFuture<?>> _announceTasks;
	private boolean _applyInvulOnSpawn;

	public AbstractFightClub(MultiValueSet<String> set)
	{
		super(set);
		_objId = (LAST_OBJECT_ID++);
		_desc = set.getString("desc");
		_descRu = set.getString("descRu", _desc);
		_icon = set.getString("icon");
		_roundRunTime = set.getInteger("roundRunTime", -1);
		_teamed = set.getBool("teamed");
		_buffer = set.getBool("buffer");
		_fighterBuffs = parseBuffs(set.getString("fighterBuffs", null));
		_mageBuffs = parseBuffs(set.getString("mageBuffs", null));
		_rootBetweenRounds = set.getBool("rootBetweenRounds");
		_excludedClasses = parseExcludedClasses(set.getString("excludedClasses", ""));
		_excludedSkills = parseExcludedSkills(set.getString("excludedSkills", null));
		_isAutoTimed = set.getBool("isAutoTimed", false);
		_sendInvites = set.getBool("sendInvites", true);
		_autoStartTimes = parseAutoStartTimes(set.getString("autoTimes", ""));
		_roundEvent = set.getBool("roundEvent");
		_rounds = set.getInteger("rounds", -1);
		_respawnTime = set.getInteger("respawnTime");
		_ressAllowed = set.getBool("ressAllowed");
		_instanced = set.getBool("instanced", true);
		_showPersonality = set.getBool("showPersonality", true);
		_minLevel = set.getInteger("minLevel", 40);
		_maxLevel = set.getInteger("maxLevel", Config.ALT_MAX_LEVEL);
		_rebirthCnt = set.getInteger("rebirthCnt", 0);
		_applyInvulOnSpawn = set.getBool("applyInvul", true);
		_badgesKillPlayer = set.getDouble("badgesKillPlayer", 0.0D);
		_badgesIdWin = set.getInteger("badgeIDWin", 57);
		_badgesIdLose = set.getInteger("badgeIDLose", 57);
		_badgesKillPet = set.getDouble("badgesKillPet", 0.0D);
		_badgesDie = set.getDouble("badgesDie", 0.0D);
		_badgeWin = set.getDouble("badgesWin", 0.0D);
		_badgeLose = set.getDouble("badgesLose", 0.0D);
		topKillerReward = set.getInteger("topKillerReward", 0);
		_additionalRewards = parseAdditionalRewards(set.getString("additionalRewards", ""));
		_secondaryTimers = new ArrayList<>();
		_announceTasks = new ArrayList<>();
		_set = set;
	}

	public void scheduleRegisterAnnounces()
	{
		_announceTasks.add(ThreadPoolManager.getInstance().schedule(() -> Announcements.announceToAllFromStringHolder("l2s.gameserver.model.entity.events.impl.PvPEvent.registration.announce", getName(), 4), 60 * 1000));
		_announceTasks.add(ThreadPoolManager.getInstance().schedule(() -> Announcements.announceToAllFromStringHolder("l2s.gameserver.model.entity.events.impl.PvPEvent.registration.announce", getName(), 3), 2 * 60 * 1000));
		_announceTasks.add(ThreadPoolManager.getInstance().schedule(() -> Announcements.announceToAllFromStringHolder("l2s.gameserver.model.entity.events.impl.PvPEvent.registration.announce", getName(), 2), 3 * 60 * 1000));
		_announceTasks.add(ThreadPoolManager.getInstance().schedule(() -> Announcements.announceToAllFromStringHolder("l2s.gameserver.model.entity.events.impl.PvPEvent.registration.announce.single", getName(), 1), 4 * 60 * 1000));
		AtomicInteger seconds = new AtomicInteger(10);
		_announceTasks.add(ThreadPoolManager.getInstance().schedule(() ->
		{
			Announcements.announceToAllFromStringHolder("l2s.gameserver.model.entity.events.impl.PvPEvent.registration.stop", getName());
			for (int i = seconds.get(); i > 0; i--)
			{
				_announceTasks.add(ThreadPoolManager.getInstance().schedule(() -> sendMessageToRegistered(MessageType.REGISTER_ANNOUNCE, new CustomMessage("l2s.gameserver.model.entity.events.impl.PvPEvent.registration.teleport").addString(getName()).addNumber(seconds.get())), (10 - seconds.get()) * 1000L));
				seconds.getAndDecrement();
			}
		}, (5 * 60 * 1000) - (10 * 1000L)));
		// отделить
		initEvent();
		_announceTasks.add(ThreadPoolManager.getInstance().schedule(() -> FightClubEventManager.getInstance().startEvent(this), 5 * 60 * 1000));
	}

	public void prepareEvent(FightClubGameRoom room)
	{
		_map = room.getMap();
		_room = room;

		for (Player player : room.getAllPlayers())
		{
			addObject(REGISTERED_PLAYERS, new FightClubPlayer(player));
			player.addEvent(this);
		}

		startEvent();
	}

	@Override
	public void startEvent()
	{
		super.startEvent();

		_state = EventState.PREPARATION;

		IntObjectMap<DoorTemplate> doors = new HashIntObjectMap<DoorTemplate>(0);
		Map<String, ZoneTemplate> zones = new HashMap<String, ZoneTemplate>();
		for (Entry<Integer, Map<String, ZoneTemplate>> entry : getMap().getTerritories().entrySet())
		{
			zones.putAll(entry.getValue());
		}

		if (isInstanced())
		{
			createReflection(doors, zones);
		}

		final List<FightClubPlayer> playersToRemove = new ArrayList<FightClubPlayer>();
		for (final FightClubPlayer iFPlayer : getPlayers(REGISTERED_PLAYERS))
		{
			stopInvisibility(iFPlayer.getPlayer());
			if (!checkIfRegisteredPlayerMeetCriteria(iFPlayer))
			{
				playersToRemove.add(iFPlayer);
				continue;
			}

			if (isHidePersonality())
			{
				iFPlayer.getPlayer().setPolyId(FightClubGameRoom.getPlayerClassGroup(iFPlayer.getPlayer()).getTransformId());
			}
		}

		for (FightClubPlayer playerToRemove : playersToRemove)
		{
			unregister(playerToRemove.getPlayer());
		}

		if (isTeamed())
		{
			spreadIntoTeamsAndPartys();
		}

		teleportRegisteredPlayers();

		updateEveryScore();

		for (final FightClubPlayer iFPlayer : getPlayers(FIGHTING_PLAYERS, REGISTERED_PLAYERS))
		{
			iFPlayer.getPlayer().isntAfk();
			iFPlayer.getPlayer().setFightClubGameRoom(null);
		}

		startNewTimer(true, TIME_PLAYER_TELEPORTING * 1000, "startRoundTimer", TIME_PREPARATION_BEFORE_FIRST_ROUND);

		ThreadPoolManager.getInstance().schedule(new LeftZoneThread(), 5000L);

		FightClubEventManager.getInstance().addActiveEvent(this);
	}

	public void startRound()
	{
		_state = EventState.STARTED;

		_currentRound++;

		if (isRoundEvent())
		{
			if (_currentRound == _rounds)
			{
				sendMessageToFighting(MessageType.SCREEN_BIG, new CustomMessage("l2s.gameserver.model.entity.events.impl.fightclub.ctf.lastRoundStart"), true); // TODO: Вынести в ДП.
			}
			else
			{
				sendMessageToFighting(MessageType.SCREEN_BIG, new CustomMessage("l2s.gameserver.model.entity.events.impl.fightclub.ctf.roundStart").addNumber(_currentRound), true);
			}
		}
		else
		{
			sendMessageToFighting(MessageType.SCREEN_BIG, new CustomMessage("l2s.gameserver.model.entity.events.impl.fightclub.ctf.fight"), true);
		}

		unrootPlayers();

		if (getRoundRuntime() > 0)
		{
			startNewTimer(true, (int) ((double) getRoundRuntime() / 2 * 60000), "endRoundTimer", (int) ((double) getRoundRuntime() / 2 * 60));
		}

		if (_currentRound == 1)
		{
			ThreadPoolManager.getInstance().schedule(new TimeSpentOnEventThread(), 10000L);
			ThreadPoolManager.getInstance().schedule(new CheckAfkThread(), 1000L);
		}

		for (final FightClubPlayer iFPlayer : getPlayers(FIGHTING_PLAYERS))
		{
			hideScores(iFPlayer.getPlayer());
			iFPlayer.getPlayer().broadcastUserInfo(true);
		}
	}

	public void endRound()
	{
		_state = EventState.OVER;

		if (!isLastRound())
		{
			sendMessageToFighting(MessageType.SCREEN_BIG, new CustomMessage("l2s.gameserver.model.entity.events.impl.fightclub.ctf.roundEnd").addNumber(_currentRound), false);
		}
		else
		{
			sendMessageToFighting(MessageType.SCREEN_BIG, new CustomMessage("l2s.gameserver.model.entity.events.impl.fightclub.ctf.eventEnd"), false); // TODO: Вынести в ДП.
		}

		ressAndHealPlayers();

		for (final FightClubPlayer iFPlayer : getPlayers(FIGHTING_PLAYERS))
		{
			showScores(iFPlayer.getPlayer());
			handleAfk(iFPlayer, false);
		}

		if (!isLastRound())
		{
			if (isTeamed())
			{
				for (FightClubTeam team : getTeams())
				{
					team.setSpawnLoc(null);
				}
			}

			ThreadPoolManager.getInstance().schedule(() ->
			{
				for (final FightClubPlayer iFPlayer : getPlayers(FIGHTING_PLAYERS))
				{
					teleportSinglePlayer(iFPlayer, false, true);
				}

				startNewTimer(true, 0, "startRoundTimer", TIME_PREPARATION_BETWEEN_NEXT_ROUNDS);

			}, TIME_AFTER_ROUND_END_TO_RETURN_SPAWN * 1000);
		}
		else
		{
			ThreadPoolManager.getInstance().schedule(() -> stopEvent(false), 5 * 1000);

			if (isTeamed())
			{
				announceWinnerTeam(true, null);
			}
			else
			{
				announceWinnerPlayer(true, null);
			}
		}

		for (final FightClubPlayer iFPlayer : getPlayers(FIGHTING_PLAYERS))
		{
			iFPlayer.getPlayer().broadcastUserInfo(true);
		}
	}

	public void announceTopKillers(FightClubPlayer[] topKillers)
	{
		if (topKillers == null)
		{
			return;
		}
		for (FightClubPlayer fPlayer : topKillers)
		{
			if (fPlayer != null)
			{
				FightClubEventManager.getInstance().sendToAllMsg(this, new CustomMessage("l2s.gameserver.model.entity.events.impl.fightclub.ctf.mostKills").addString(fPlayer.getPlayer().getName()).addString(getName()));
			}
		}
	}

	@Override
	public boolean giveKarma() {
		return true;
	}



	@Override
	public void stopEvent(boolean force)
	{
		_state = EventState.NOT_ACTIVE;
		super.stopEvent(force);
		reCalcNextTime(false);
		_room = null;

		if (_timer != null) {
			_timer.cancel(false);
			_timer = null;
		}

		for (ScheduledFuture<?> announceTask : _announceTasks) {
			if (announceTask != null) {
				announceTask.cancel(false);
			}
		}

		for (ScheduledFuture<?> timer : _secondaryTimers) {
			if (timer != null) {
				timer.cancel(false);
			}
		}

		_secondaryTimers.clear();
		_announceTasks.clear();

		showLastAFkMessage();
		FightClubPlayer[] topKillers = getTopKillers();
		announceTopKillers(topKillers);
		giveRewards(topKillers);

		for (final FightClubPlayer iFPlayer : getPlayers(FIGHTING_PLAYERS)) {
			final Player player = iFPlayer.getPlayer();
			if (player != null) {
				player.broadcastCharInfo();
				for (SummonInstance summon : player.getSummons()) {
					summon.broadcastCharInfo();
				}
			}
		}

		for (Player player : getAllFightingPlayers())
		{
			showScores(player);
		}

		FightClubEventManager.clearBoxes();
		FightClubEventManager.getInstance().removeActiveEvent(this);

		ThreadPoolManager.getInstance().schedule(new Runnable()
		{
			@Override
			public void run()
			{
				for (Player player : getAllFightingPlayers())
				{
					leaveEvent(player, true);
					if (player.isImmobilized())
					{
						player.getFlags().getImmobilized().stop();
						player.stopAbnormalEffect(AbnormalEffect.ROOT);
						player.sendPacket(new SkillCoolTimePacket(player));
					}
				}
				ThreadPoolManager.getInstance().schedule(() ->
				{
					destroyMe();
				}, (15 + TIME_TELEPORT_BACK_TOWN) * 1000);
			}
		}, 10000L);
	}

	public void destroyMe()
	{
		if (getReflection() != null)
		{
			for (Zone zone : getReflection().getZones())
				zone.removeListener(_zoneListener);
			getReflection().collapse();
		}

		if (_timer != null)
		{
			_timer.cancel(false);
		}

		_timer = null;
		_bestScores.clear();
		_scores.clear();
		_leftZone.clear();
		getObjects().clear();
		_set = null;
		_room = null;
		_zoneListener = null;

		for (Player player : GameObjectsStorage.getAllPlayersForIterate())
		{
			player.removeListener(_exitListener);
		}

		_exitListener = null;
	}

	public void onKilled(Creature actor, Creature victim)
	{
		if (victim.isPlayer() && getRespawnTime() > 0)
		{
			showScores(victim);
		}
		if (actor != null && actor.isPlayer() && getFightClubPlayer(actor) != null)
		{
			FightClubLastStatsManager.getInstance().updateStat(actor.getPlayer(), FightClubLastStatsManager.FightClubStatType.KILL_PLAYER, getFightClubPlayer(actor).getKills(true));
		}
		if (victim.isPlayer() && getRespawnTime() > 0 && !_ressAllowed && getFightClubPlayer(victim.getPlayer()) != null)
		{
			startNewTimer(false, 0, "ressurectionTimer", getRespawnTime(), getFightClubPlayer(victim));
		}
	}

	public void requestRespawn(Player activeChar, RestartType restartType)
	{
		if (getRespawnTime() > 0)
		{
			startNewTimer(false, 0, "ressurectionTimer", getRespawnTime(), getFightClubPlayer(activeChar));
		}
	}

	@Override
	public boolean canAttack(Creature target, Creature attacker, Skill skill, boolean force, boolean nextAttackCheck) {
		if (_state != EventState.STARTED) {
			return false;
		}

		if (_preparing) {
			attacker.setTarget(attacker);
		}

		Player player = attacker.getPlayer();
		if (player == null || target == null) {
			return false;
		}
		if (player == target || player == target.getPlayer()) {
			return false;
		}

		final FightClubPlayer targetFPlayer = getFightClubPlayer(target);
		final FightClubPlayer attackerFPlayer = getFightClubPlayer(attacker);
		if (targetFPlayer == null && attackerFPlayer == null) {
			return false;
		}

		return !isTeamed() || (targetFPlayer != null && attackerFPlayer != null && !targetFPlayer.getTeam().equals(attackerFPlayer.getTeam()));
	}

	public boolean canAttack(Creature target, Creature attacker, Skill skill, boolean force)
	{
		if (_state != EventState.STARTED)
		{
			return false;
		}

		if (_preparing)
		{
			attacker.setTarget((GameObject) attacker);
		}

		Player player = attacker.getPlayer();
		if (player == null || target == null)
		{
			return false;
		}
		if (player == target || player == target.getPlayer())
		{
			return false;
		}

		final FightClubPlayer targetFPlayer = getFightClubPlayer(target);
		final FightClubPlayer attackerFPlayer = getFightClubPlayer(attacker);
		if (targetFPlayer == null && attackerFPlayer == null)
		{
			return false;
		}
		if (isTeamed() && (targetFPlayer == null || attackerFPlayer == null || targetFPlayer.getTeam().equals(attackerFPlayer.getTeam())))
		{
			return false;
		}

		return true;
	}

	@Override
	public boolean canUseSkill(Creature caster, Creature target, Skill skill)
	{
		if (_preparing)
		{
			caster.setTarget((GameObject) caster);
		}
		if (_excludedSkills != null)
		{
			for (int id : _excludedSkills)
			{
				if (skill.getId() == id)
				{
					return false;
				}
			}
		}
		return true;
	}

	@Override
	public boolean startFlagTask()
	{
		return true;
	}

	@Override
	public SystemMsg checkForAttack(Creature target, Creature attacker, Skill skill, boolean force)
	{
		if (_preparing)
		{
			attacker.setTarget((GameObject) attacker);
		}
		if (!canAttack(target, attacker, skill, force))
		{
			return SystemMsg.INVALID_TARGET;
		}
		return null;
	}

	public boolean canRessurect(Player player, Creature creature, boolean force)
	{
		return _ressAllowed;
	}

	public int getMySpeed(Player player)
	{
		return -1;
	}

	public int getPAtkSpd(Player player)
	{
		return -1;
	}

	public void checkRestartLocs(Player player, Map<RestartType, Boolean> r)
	{
		r.clear();
		if (isTeamed() && getRespawnTime() > 0 && getFightClubPlayer(player) != null && _ressAllowed)
		{
			r.put(RestartType.TO_FLAG, Boolean.valueOf(true));
		}
	}

	public boolean canUseBuffer(Player player, boolean heal)
	{
		FightClubPlayer fPlayer = getFightClubPlayer(player);
		if (!getBuffer())
			return false;
		if (player.isInCombat())
			return false;
		if (heal)
		{
			if (player.isDead())
				return false;
			if (_state != EventState.STARTED)
				return true;

			return fPlayer.isInvisible();
		}

		return true;
	}

	public boolean canUsePositiveMagic(Creature user, Creature target)
	{
		Player player = user.getPlayer();
		if (player == null)
			return true;
		if (!isFriend(user, target))
			return false;

		return !isInvisible(player, player);
	}

	@Override
	public long getRelation(Player thisPlayer, Player target, long oldRelation)
	{
		if (_state == EventState.STARTED) {
			return isFriend(thisPlayer, target) ? getFriendRelation() : getWarRelation();
		}
		return oldRelation;
	}

	public boolean canJoinParty(Player sender, Player receiver)
	{
		return isFriend(sender, receiver);
	}

	public boolean canReceiveInvitations(Player sender, Player receiver)
	{
		return true;
	}

	public boolean canOpenStore(Player player)
	{
		return false;
	}

	public boolean loseBuffsOnDeath(Player player)
	{
		return false;
	}

	protected boolean inScreenShowBeScoreNotKills()
	{
		return true;
	}

	protected boolean inScreenShowBeTeamNotInvidual()
	{
		return isTeamed();
	}

	public boolean isFriend(Creature c1, Creature c2)
	{
		if (c1.equals(c2))
			return true;
		if (!c1.isPlayable() || !c2.isPlayable())
			return true;

		if (c1.isSummon() && c2.isPlayer() && c2.getPlayer().getAnyServitor() != null && c2.getPlayer().getAnyServitor().equals(c1))
			return true;

		if (c2.isSummon() && c1.isPlayer() && c1.getPlayer().getAnyServitor() != null && c1.getPlayer().getAnyServitor().equals(c2))
			return true;

		FightClubPlayer fPlayer1 = getFightClubPlayer(c1.getPlayer());
		FightClubPlayer fPlayer2 = getFightClubPlayer(c2.getPlayer());

		if (isTeamed())
			return fPlayer1 != null && fPlayer2 != null && fPlayer1.getTeam() == fPlayer2.getTeam();

		return false;
	}

	public boolean isInvisible(Player actor, Player watcher)
	{
		return actor.getFlags().getInvisible().get();
	}

	public String getVisibleName(Player player, String currentName, boolean toMe)
	{
		if (isHidePersonality() && !toMe)
			return "Player";
		return currentName;
	}

	public String getVisibleTitle(Player player, String currentTitle, boolean toMe)
	{
		return currentTitle;
	}

	public int getVisibleTitleColor(Player player, int currentTitleColor, boolean toMe)
	{
		return currentTitleColor;
	}

	public int getVisibleNameColor(Player player, int currentNameColor, boolean toMe)
	{
		if (isTeamed())
		{
			FightClubPlayer fPlayer = getFightClubPlayer(player);
			return fPlayer.getTeam().getNickColor();
		}
		return currentNameColor;
	}

	protected int getBadgesEarned(FightClubPlayer fPlayer, int currentValue, boolean topKiller)
	{
		if (fPlayer == null)
			return 0;
		currentValue += addMultipleBadgeToPlayer(fPlayer.getKills(true), _badgesKillPlayer);

		currentValue += getRewardForWinningTeam(fPlayer, true);

		currentValue += getRewardForLosingTeam(fPlayer, true);

		int minutesAFK = (int) Math.round(fPlayer.getTotalAfkSeconds() / 60.0D);
		currentValue += minutesAFK * BADGES_FOR_MINUTE_OF_AFK;

		if (topKiller)
		{
			currentValue += topKillerReward;
		}

		return currentValue;
	}

	protected int addMultipleBadgeToPlayer(int score, double badgePerScore)
	{
		return (int) Math.floor(score * badgePerScore);
	}

	protected int addMultipleBadgeToPlayer(FightClubPlayer fPlayer, FightClubStatType whatFor, int score, double badgePerScore, int secondsSpent)
	{
		int badgesEarned = (int) Math.floor(score * badgePerScore);
		return badgesEarned;
	}

	private int getEndEventBadges(FightClubPlayer fPlayer)
	{
		return 0;
	}

	public void startTeleportTimer(FightClubGameRoom room)
	{
		setState(EventState.COUNT_DOWN);

		startNewTimer(true, 0, "teleportWholeRoomTimer", TIME_FIRST_TELEPORT);
	}

	protected void teleportRegisteredPlayers()
	{
		for (final FightClubPlayer player : getPlayers(REGISTERED_PLAYERS))
		{
			teleportSinglePlayer(player, true, true);
		}
	}

	protected void teleportSinglePlayer(FightClubPlayer fPlayer, boolean firstTime, boolean healAndRess)
	{
		Player player = fPlayer.getPlayer();
		if (healAndRess)
		{
			ressurectPlayer(player);
		}

		Location[] spawns = null;
		Location loc = null;

		if (!isTeamed())
			spawns = getMap().getPlayerSpawns();
		else
			loc = getTeamSpawn(fPlayer, true);

		if (!isTeamed())
			loc = getSafeLocation(spawns);

		loc = Location.findPointToStay(loc, 0, CLOSE_LOCATIONS_VALUE / 2, fPlayer.getPlayer().getGeoIndex());

		if (isInstanced())
			player.teleToLocation(loc, getReflection());
		else
			player.teleToLocation(loc);

		if (_state == EventState.PREPARATION || _state == EventState.OVER)
			rootPlayer(player);

		String teamName = getTeamName(fPlayer.getTeam());
		AbnormalEffect effect = Objects.equals(teamName, "Red") ? AbnormalEffect.RED_TEAM : AbnormalEffect.BLUE_TEAM;
		player.startAbnormalEffect(effect);

		cancelNegativeEffects(player);
		if (player.getPet() != null)
			cancelNegativeEffects(player.getPet());

		if (firstTime)
		{
			removeObject(REGISTERED_PLAYERS, fPlayer);
			addObject(FIGHTING_PLAYERS, fPlayer);

			if (removeBuffsOnEnter()) {
				player.getAbnormalList().stopAll();
				if (player.getAnyServitor() != null)
					player.getAnyServitor().getAbnormalList().stopAll();
			}

			player.store(true);
			player.sendPacket(new ShowTutorialMarkPacket(false, 100));

			player.sendPacket(new SayPacket2(0, ChatType.ALL, getName(), "Normal Chat is visible for every player in event."));
			if (isTeamed())
			{
				player.sendPacket(new SayPacket2(0, ChatType.ALL, getName(), "Battlefield(^) Chat is visible only to your team!"));
				player.sendPacket(new SayPacket2(0, ChatType.BATTLEFIELD, getName(), "Battlefield(^) Chat is visible only to your team!"));
			}
		}

		if (healAndRess)
			buffPlayer(fPlayer.getPlayer());

		if (player.hasServitor()) {
			for (Servitor servitor : player.getServitors())
				servitor.unSummon(false);
		}

		if (player.hasSummon() && player.getSummon() != null) {
			for (SummonInstance summonInstance : player.getSummons())
				summonInstance.unSummon(false);
		}
	}

	public boolean removeBuffsOnEnter() {
		return true;
	}

	public boolean removeBuffsOnDeath() {
		return true;
	}

	public void unregister(Player player)
	{
		final FightClubPlayer fPlayer = getFightClubPlayer(player, REGISTERED_PLAYERS);
		player.removeEvent(this);
		removeObject(REGISTERED_PLAYERS, fPlayer);
		player.sendMessage("You are no longer registered!"); // TODO: Вынести в ДП.
	}

	public boolean leaveEvent(Player player, boolean teleportTown)
	{
		FightClubPlayer fPlayer = getFightClubPlayer(player);
		if (fPlayer == null)
		{
			return true;
		}

		if (_state == EventState.NOT_ACTIVE)
		{
			if (fPlayer.isInvisible())
			{
				stopInvisibility(player);
			}
			removeObject(FIGHTING_PLAYERS, fPlayer);
			if (isTeamed())
			{
				fPlayer.getTeam().removePlayer(fPlayer);
			}
			player.removeEvent(this);

			if (teleportTown)
			{
				ThreadPoolManager.getInstance().schedule(() ->
				{
					ressurectPlayer(player);
					teleportBackToTown(player);
				}, 5000);
			}
			else
			{
				player.doRevive();
			}
		}
		else
		{
			rewardPlayer(fPlayer, false);

			//if (teleportTown)
			//{
			//	setInvisible(player, 30, false);
			//}
			//else
			//{
			//	setInvisible(player, -1, false);
			//}
			removeObject(FIGHTING_PLAYERS, fPlayer);

			// player.doDie(null);
			player.removeEvent(this);

			if (teleportTown)
			{
				startNewTimer(false, 0, "teleportBackSinglePlayerTimer", TIME_TELEPORT_BACK_TOWN, player);
			}
			else
			{
				player.doRevive();
			}
		}

		ThreadPoolManager.getInstance().schedule(() ->
		{
			player.setCurrentHpMp(player.getMaxHp(), player.getMaxMp());
			player.setCurrentCp(player.getMaxCp());
		}, 5000L);

		hideScores(player);
		updateScreenScores();

		if (getPlayers(FIGHTING_PLAYERS, REGISTERED_PLAYERS).isEmpty())
		{
			ThreadPoolManager.getInstance().schedule(this::destroyMe, (15 + TIME_TELEPORT_BACK_TOWN) * 1000);
		}

		if (player.getParty() != null)
		{
			player.getParty().removePartyMember(player, true, true);
		}

		return true;
	}

	protected void ressurectPlayer(Player player)
	{
		if (player.isDead())
		{
			player.doRevive(100.0D);
			ThreadPoolManager.getInstance().schedule(() ->
			{
				player.restoreExp();
				player.setCurrentCp(player.getMaxCp());
				player.setCurrentHp(player.getMaxHp(), true);
				player.setCurrentMp(player.getMaxMp());
				player.broadcastPacket(new RevivePacket(player));
				player.setCurrentCp(player.getMaxCp());
				player.setCurrentHpMp(player.getMaxHp(), player.getMaxMp());

				if (_applyInvulOnSpawn)
				{
					player.getFlags().getInvulnerable().start();
					player.getFlags().getDebuffImmunity().start();
					player.startAbnormalEffect(AbnormalEffect.INVINCIBILITY);
					ThreadPoolManager.getInstance().schedule(() ->
					{
						player.getFlags().getInvulnerable().stop();
						player.getFlags().getDebuffImmunity().stop();
						player.stopAbnormalEffect(AbnormalEffect.INVINCIBILITY);
					}, 2 * 1000L);
				}
			}, 5000L);
		}
	}

	public void loggedOut(Player player)
	{
		leaveEvent(player, true);
	}

	protected void teleportBackToTown(Player player)
	{
		if (isHidePersonality())
		{
			player.setPolyId(0);
		}

		if (player.isImmobilized())
		{
			player.stopRooted();
			player.stopAbnormalEffect(AbnormalEffect.ROOT);
		}
		if (!player.isDead())
		{
			player.setCurrentCp(player.getMaxCp());
			player.setCurrentHpMp(player.getMaxHp(), player.getMaxMp());
		}

		Location returnLocation = FightClubEventManager.RETURN_LOC;
		try {
			String returnLocStr = player.getVar(FightClubEventManager.ENTER_LOC_VAR_NAME, "");
			if (!returnLocStr.isEmpty()) {
				String[] coords = returnLocStr.split(" ");
				returnLocation = new Location(Integer.parseInt(coords[0]), Integer.parseInt(coords[1]), Integer.parseInt(coords[2]));
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		player.stopAbnormalEffect(AbnormalEffect.BLUE_TEAM);
		player.stopAbnormalEffect(AbnormalEffect.RED_TEAM);
		returnLocation = Location.findPointToStay(returnLocation, 0, 100, 0);
		player.sendPacket(new ExShowScreenMessage("Teleporting to town!", 10, ExShowScreenMessage.ScreenMessageAlign.TOP_LEFT, false));
		player.teleToLocation(returnLocation, true);
		player.unsetVar(FightClubEventManager.ENTER_LOC_VAR_NAME);
		ressurectPlayer(player);
		player.stopAbnormalEffect(AbnormalEffect.STEALTH);
		player.stopInvisible(this, true);
		player.broadcastUserInfo(true);
		player.broadcastCharInfo();
		player.sendPacket(new SkillCoolTimePacket(player));
	}

	protected void rewardPlayer(FightClubPlayer fPlayer, boolean isTopKiller)
	{
		int badgesToGive = getBadgesEarned(fPlayer, 0, isTopKiller);
		FightClubTeam winnerTeam = getWinnerTeam();


		if (getState() == EventState.NOT_ACTIVE)
		{
			badgesToGive += getEndEventBadges(fPlayer);
		}

		badgesToGive = Math.max(1, badgesToGive); //напряг
		if(winnerTeam != null && winnerTeam.getPlayers().contains(fPlayer)) {
			fPlayer.getPlayer().getInventory().addItem(_badgesIdWin, badgesToGive);
			if (getEventId() == 7) { // CatRoyal
				fPlayer.getPlayer().getListeners().onParticipateInEvent("CatRoyal", true);
			} else if (getEventId() == 4) {
				fPlayer.getPlayer().getListeners().onParticipateInEvent("CtF", true);
			}
		}
		else {
			fPlayer.getPlayer().getInventory().addItem(_badgesIdLose, badgesToGive);
		}

		giveAdditionalRewards(fPlayer, false);
	}

	protected FightClubTeam getWinnerTeam()
	{
		FightClubTeam bestTeam = null;
		int bestScore = -1;

		for (FightClubTeam team : getTeams()) {
			if (team.getScore() > bestScore) {
				bestScore = team.getScore();
				bestTeam = team;
			} else if (team.getScore() == bestScore) {
				return null;
			}
		}

		return bestTeam;
	}
	protected void announceWinnerTeam(boolean wholeEvent, FightClubTeam winnerOfTheRound)
	{
		int bestScore = -1;
		FightClubTeam bestTeam = null;
		boolean draw = false;
		if (wholeEvent)
		{
			for (FightClubTeam team : getTeams())
			{
				if (team.getScore() > bestScore)
				{
					draw = false;
					bestScore = team.getScore();
					bestTeam = team;
				}
				else if (team.getScore() == bestScore)
				{
					draw = true;
				}
			}
		}
		else
		{
			bestTeam = winnerOfTheRound;
		}

		SayPacket2 packet;
		if (!draw)
		{
			packet = new SayPacket2(0, ChatType.COMMANDCHANNEL_ALL, bestTeam.getName() + " Team", "We won " + (wholeEvent ? getName() : " Round") + "!");
			for (final FightClubPlayer iFPlayer : getPlayers(FIGHTING_PLAYERS))
			{
				iFPlayer.getPlayer().sendPacket(packet);
			}
		}
		updateScreenScores();
	}

	protected void announceWinnerPlayer(boolean wholeEvent, FightClubPlayer winnerOfTheRound)
	{
		int bestScore = -1;
		FightClubPlayer bestPlayer = null;
		boolean draw = false;
		if (wholeEvent)
		{
			for (final FightClubPlayer iFPlayer : getPlayers(FIGHTING_PLAYERS))
			{
				if (iFPlayer.getPlayer() != null && iFPlayer.getPlayer().isOnline())
				{
					if (iFPlayer.getScore() > bestScore)
					{
						bestScore = iFPlayer.getScore();
						bestPlayer = iFPlayer;
					}
					else if (iFPlayer.getScore() == bestScore)
					{
						draw = true;
					}
				}
			}
		}
		else
		{
			bestPlayer = winnerOfTheRound;
		}

		SayPacket2 packet;
		if (!draw && bestPlayer != null)
		{
			packet = new SayPacket2(0, ChatType.COMMANDCHANNEL_ALL, bestPlayer.getPlayer().getName(), "I Won " + (wholeEvent ? getName() : "Round") + "!");
			for (final FightClubPlayer iFPlayer : getPlayers(FIGHTING_PLAYERS))
			{
				iFPlayer.getPlayer().sendPacket(packet);
			}
		}
		updateScreenScores();
	}

	protected void updateScreenScores()
	{
		String msg = getScreenScores(inScreenShowBeScoreNotKills(), inScreenShowBeTeamNotInvidual());
		for (final FightClubPlayer iFPlayer : getPlayers(FIGHTING_PLAYERS))
		{
			sendMessageToPlayer(iFPlayer, MessageType.SCREEN_SMALL, msg);
		}
	}

	protected void updateScreenScores(Player player)
	{
		if (getFightClubPlayer(player) != null)
		{
			sendMessageToPlayer(getFightClubPlayer(player), MessageType.SCREEN_SMALL, getScreenScores(inScreenShowBeScoreNotKills(), inScreenShowBeTeamNotInvidual()));
		}
	}

	protected String getScorePlayerName(FightClubPlayer fPlayer)
	{
		return fPlayer.getPlayer().getName() + (isTeamed() ? " (" + fPlayer.getTeam().getName() + " Team)" : "");
	}

	protected void updatePlayerScore(FightClubPlayer fPlayer)
	{
		_scores.put(getScorePlayerName(fPlayer), Integer.valueOf(fPlayer.getKills(true)));
		_scoredUpdated = true;

		if (!isTeamed())
			updateScreenScores();
	}

	protected void showScores(Creature c)
	{
		Map<String, Integer> scores = getBestScores();
		FightClubPlayer fPlayer = getFightClubPlayer(c);

		if (fPlayer != null)
		{
			fPlayer.setShowRank(true);
		}
		c.sendPacket(new ExPVPMatchCCRecord(scores));
	}

	protected void hideScores(Creature c)
	{
		c.sendPacket(ExPVPMatchCCRetire.STATIC);
	}

	private void handleAfk(FightClubPlayer fPlayer, boolean setAsAfk)
	{
		Player player = fPlayer.getPlayer();

		if (setAsAfk)
		{
			fPlayer.setAfk(true);
			fPlayer.setAfkStartTime(player.getLastNotAfkTime());
			sendMessageToPlayer(player, MessageType.CRITICAL, new CustomMessage("l2s.gameserver.model.entity.events.impl.fightclub.ctf.youNowAfk").toString(player));
		}
		else if (fPlayer.isAfk())
		{
			int totalAfkTime = (int) ((System.currentTimeMillis() - fPlayer.getAfkStartTime()) / 1000L);
			totalAfkTime -= TIME_TO_BE_AFK;
			if (totalAfkTime > 5)
			{
				fPlayer.setAfk(false);
				fPlayer.addTotalAfkSeconds(totalAfkTime);
				sendMessageToPlayer(player, MessageType.CRITICAL, new CustomMessage("l2s.gameserver.model.entity.events.impl.fightclub.ctf.totalAfkTime").addNumber(totalAfkTime).toString(player));
			}
		}
	}

	protected void setInvisible(Player player, int seconds, boolean sendMessages)
	{
		FightClubPlayer fPlayer = getFightClubPlayer(player);
		//fPlayer.setInvisible(true);
		//player.startAbnormalEffect(AbnormalEffect.STEALTH);
		player.startInvisible(this, true);
		player.sendUserInfo(true);

		if (seconds > 0)
		{
			startNewTimer(false, 0, "setInvisible", seconds, fPlayer, sendMessages);
		}
	}

	protected void stopInvisibility(Player player)
	{
		FightClubPlayer fPlayer = getFightClubPlayer(player);
		if (fPlayer != null)
		{
			fPlayer.setInvisible(false);
		}

		player.stopAbnormalEffect(AbnormalEffect.STEALTH);
		player.stopInvisible(this, true);
	}

	protected void rootPlayer(Player player)
	{
		if (!isRootBetweenRounds())
		{
			return;
		}

		List<Playable> toRoot = new ArrayList<Playable>();
		toRoot.add(player);
		if (player.getAnyServitor() != null)
		{
			toRoot.add(player.getAnyServitor());
		}
		if (!player.isImmobilized())
		{
			player.startRooted();
		}
		player.getMovement().stopMove(true);
		player.startAbnormalEffect(AbnormalEffect.ROOT);
	}

	protected void unrootPlayers()
	{
		if (!isRootBetweenRounds())
		{
			return;
		}

		for (final FightClubPlayer iFPlayer : getPlayers(FIGHTING_PLAYERS))
		{
			final Player player = iFPlayer.getPlayer();
			if (player != null)
			{
				if (player.isImmobilized())
				{
					player.stopRooted();
					player.stopAbnormalEffect(AbnormalEffect.ROOT);
				}
				if (!player.isDead())
				{
					player.setCurrentCp(player.getMaxCp());
					player.setCurrentHpMp(player.getMaxHp(), player.getMaxMp());
				}
			}
		}
	}

	protected void ressAndHealPlayers()
	{
		for (final FightClubPlayer fPlayer : getPlayers(FIGHTING_PLAYERS))
		{
			Player player = fPlayer.getPlayer();

			ressurectPlayer(player);
			cancelNegativeEffects(player);
			if (player.getAnyServitor() != null)
			{
				cancelNegativeEffects((Playable) player.getAnyServitor());
			}
			buffPlayer(player);
		}
	}

	protected long getWarRelation()
	{
		long result = 0;

		result |= RelationChangedPacket.RelationChangedType.PLEDGE_MEMBER.getRelationState();
		result |= RelationChangedPacket.RelationChangedType.DECLARE_WAR_TO_MY_PLEDGE.getRelationState();
		result |= RelationChangedPacket.RelationChangedType.DECLARE_WAR_TO_YOUR_PLEDGE.getRelationState();

		return result;
	}

	protected int getFriendRelation()
	{
		int result = 0;

		return result;
	}

	protected NpcInstance chooseLocAndSpawnNpc(int id, Location[] locs, int respawnInSeconds)
	{
		return spawnNpc(id, getSafeLocation(locs), respawnInSeconds);
	}

	protected NpcInstance spawnNpc(int id, Location loc, int respawnInSeconds, boolean onlyCreate)
	{
		SimpleSpawner spawn = new SimpleSpawner(id);
		if (onlyCreate) {
			spawn.stopRespawn();
		}

		spawn.setRespawnDelay(respawnInSeconds);
		spawn.setSpawnRange((geoIndex, fly) -> new Location(loc));
		spawn.setAmount(1);
		spawn.setReflection(getReflection());
		return spawn.doSpawn(!onlyCreate);
	}

	protected NpcInstance spawnNpc(int id, Location loc, int respawnInSeconds)
	{
		SimpleSpawner spawn = new SimpleSpawner(id);
		spawn.setSpawnRange((geoIndex, fly) -> new Location(loc));
		spawn.setAmount(1);
		spawn.setRespawnDelay(Math.max(0, respawnInSeconds));
		spawn.setReflection(getReflection());
		if (respawnInSeconds <= 0)
		{
			spawn.stopRespawn();
		}
		List<NpcInstance> npcs = spawn.initAndReturn();
		return npcs.get(0);
	}

	protected static String getFixedTime(int seconds)
	{
		int minutes = seconds / 60;
		String result = "";
		if (seconds >= 60)
		{
			result = minutes + " minute" + (minutes > 1 ? "s" : "");
		}
		else
		{
			result = seconds + " second" + (seconds > 1 ? "s" : "");
		}
		return result;
	}

	private void buffPlayer(Player player)
	{
		if (getBuffer())
		{
			giveBuffs(player, player.isMageClass() ? _mageBuffs : _fighterBuffs);
			if (player.getAnyServitor() != null)
			{
				giveBuffs(player.getAnyServitor(), _fighterBuffs);
			}
		}
	}

	private static void giveBuffs(final Playable playable, int[][] buffs)
	{
		for (int i = 0; i < buffs.length; i++)
		{
			Skill buff = SkillHolder.getInstance().getSkill(buffs[i][0], buffs[i][1]);
			if (buff == null)
			{
				continue;
			}
			buff.getEffects(playable, playable);
		}

		ThreadPoolManager.getInstance().schedule(() ->
		{
			playable.setCurrentHp(playable.getMaxHp(), true);
			playable.setCurrentMp(playable.getMaxMp());
			playable.setCurrentCp(playable.getMaxCp());
		}, 1000L);
	}

	protected void sendMessageToFightingAndRegistered(MessageType type, String msg)
	{
		sendMessageToFighting(type, msg, false);
		sendMessageToRegistered(type, msg);
	}

	protected void sendMessageToTeam(FightClubTeam team, MessageType type, String msg)
	{
		for (FightClubPlayer iFPlayer : team.getPlayers())
		{
			sendMessageToPlayer(iFPlayer, type, msg);
		}
	}

	protected void sendMessageToTeam(FightClubTeam team, MessageType type, CustomMessage msg)
	{
		for (FightClubPlayer iFPlayer : team.getPlayers())
		{
			sendMessageToPlayer(iFPlayer, type, msg.toString(iFPlayer.getPlayer()));
		}
	}

	protected void sendMessageToFighting(MessageType type, String msg, boolean skipJustTeleported)
	{
		for (final FightClubPlayer iFPlayer : getPlayers(FIGHTING_PLAYERS))
		{
			if (!skipJustTeleported || !iFPlayer.isInvisible())
			{
				sendMessageToPlayer(iFPlayer, type, msg);
			}
		}
	}

	protected void sendMessageToFighting(MessageType type, CustomMessage msg, boolean skipJustTeleported)
	{
		for (final FightClubPlayer iFPlayer : getPlayers(FIGHTING_PLAYERS))
		{
			if (!skipJustTeleported || !iFPlayer.isInvisible())
			{
				sendMessageToPlayer(iFPlayer, type, msg);
			}
		}
	}

	protected void sendMessageToRegistered(MessageType type, String msg)
	{
		for (final FightClubPlayer iFPlayer : getPlayers(REGISTERED_PLAYERS))
		{
			sendMessageToPlayer(iFPlayer, type, msg);
		}
	}

	protected void sendMessageToRegistered(MessageType type, CustomMessage msg)
	{
		for (final FightClubPlayer iFPlayer : getPlayers(REGISTERED_PLAYERS))
		{
			sendMessageToPlayer(iFPlayer, type, msg.toString(iFPlayer.getPlayer()));
		}
	}

	public void sendMessageToPlayer(FightClubPlayer fPlayer, MessageType type, String msg)
	{
		sendMessageToPlayer(fPlayer.getPlayer(), type, msg);
	}

	public void sendMessageToPlayer(FightClubPlayer fPlayer, MessageType type, CustomMessage msg)
	{
		sendMessageToPlayer(fPlayer.getPlayer(), type, msg.toString(fPlayer.getPlayer()));
	}

	protected void sendMessageToPlayer(Player player, MessageType type, String msg)
	{
		switch (type)
		{
			case REGISTER_ANNOUNCE:
				player.sendPacket(new ExShowScreenMessage(msg, 1000, ExShowScreenMessage.ScreenMessageAlign.TOP_CENTER, false));
				break;
			case GM:
				updateScreenScores(player);
				player.sendPacket(new SayPacket2(0, ChatType.CRITICAL_ANNOUNCE, player.getName(), msg));
				break;
			case NORMAL_MESSAGE:
				player.sendMessage(msg);
				break;
			case SCREEN_BIG:
				updateScreenScores(player);
				player.sendScreenMessage(msg);
				break;
			case SCREEN_SMALL:
				player.sendPacket(new ExShowScreenMessage(msg, 600000, ExShowScreenMessage.ScreenMessageAlign.TOP_LEFT, false));
				break;
			case CRITICAL:
				updateScreenScores(player);
				player.sendPacket(new SayPacket2(0, ChatType.COMMANDCHANNEL_ALL, player.getName(), msg));
				break;
		}
	}

	public void setState(EventState state)
	{
		_state = state;
	}

	public EventState getState()
	{
		return _state;
	}

	public int getObjectId()
	{
		return _objId;
	}

	public int getEventId()
	{
		return getId();
	}

	public String getDescription()
	{
		return _desc;
	}

	public String getDescription(Language lang)
	{
		return lang.equals(Language.RUSSIAN) ? _descRu : _desc;
	}

	public String getIcon()
	{
		return _icon;
	}

	public boolean isSendInvites()
	{
		return _sendInvites;
	}
	public boolean isAutoTimed()
	{
		return _isAutoTimed;
	}

	public int[][] getAutoStartTimes()
	{
		return _autoStartTimes;
	}

	public FightClubMap getMap()
	{
		return _map;
	}

	public boolean isTeamed()
	{
		return _teamed;
	}

	protected boolean isInstanced()
	{
		return _instanced;
	}

	public Reflection getReflection()
	{
		return _reflection;
	}

	public int getRoundRuntime()
	{
		return _roundRunTime;
	}

	public int getRespawnTime()
	{
		return _respawnTime;
	}

	public int getMinLevel()
	{
		return _minLevel;
	}

	public int getMaxLevel()
	{
		return _maxLevel;
	}

	public int getRebirthCnt()
	{
		return _rebirthCnt;
	}

	public boolean isRoundEvent()
	{
		return _roundEvent;
	}

	public int getTotalRounds()
	{
		return _rounds;
	}

	public int getCurrentRound()
	{
		return _currentRound;
	}

	public boolean getBuffer()
	{
		return _buffer;
	}

	protected boolean isRootBetweenRounds()
	{
		return _rootBetweenRounds;
	}

	public boolean isLastRound()
	{
		return (!isRoundEvent()) || (getCurrentRound() == getTotalRounds());
	}

	protected List<FightClubTeam> getTeams()
	{
		return _teams;
	}

	public MultiValueSet<String> getSet()
	{
		return _set;
	}

	public void clearSet()
	{
		_set = null;
	}

	public PlayerClass[] getExcludedClasses()
	{
		return _excludedClasses;
	}

	public RewardData[] getAdditionalRewards()
	{
		return _additionalRewards;
	}

	public boolean isHidePersonality()
	{
		return !_showPersonality;
	}

	protected int getTeamTotalKills(FightClubTeam team)
	{
		if (!isTeamed())
			return 0;
		int totalKills = 0;
		for (FightClubPlayer iFPlayer : team.getPlayers())
		{
			totalKills += iFPlayer.getKills(true);
		}
		return totalKills;
	}

	public int getPlayersCount(String[] groups)
	{
		return getPlayers(groups).size();
	}

	public List<FightClubPlayer> getPlayers(String... groups)
	{
		if (groups.length == 1)
		{
			final List<FightClubPlayer> fPlayers = getObjects(groups[0]);
			return fPlayers;
		}
		else
		{
			final List<FightClubPlayer> newList = new ArrayList<>();
			for (final String group : groups)
			{
				final List<FightClubPlayer> fPlayers = getObjects(group);
				newList.addAll(fPlayers);
			}
			return newList;
		}
	}

	public List<Player> getAllFightingPlayers()
	{
		final List<FightClubPlayer> fPlayers = getPlayers(FIGHTING_PLAYERS);
		final List<Player> players = new ArrayList<>(fPlayers.size());
		for (FightClubPlayer fPlayer : fPlayers)
		{
			players.add(fPlayer.getPlayer());
		}
		return players;
	}

	public List<Player> getMyTeamFightingPlayers(Player player)
	{
		final FightClubTeam fTeam = getFightClubPlayer(player).getTeam();
		final List<FightClubPlayer> fPlayers = getPlayers(FIGHTING_PLAYERS);
		final List<Player> players = new ArrayList<Player>(fPlayers.size());

		if (!isTeamed())
		{
			player.sendPacket(new SayPacket2(0, ChatType.BATTLEFIELD, getName(), "(There are no teams, only you can see the message)"));
			players.add(player);
		}
		else
		{
			for (FightClubPlayer iFPlayer : fPlayers)
			{
				if (iFPlayer.getTeam().equals(fTeam))
				{
					players.add(iFPlayer.getPlayer());
				}
			}
		}
		return players;
	}

	public FightClubPlayer getFightClubPlayer(Creature creature)
	{
		return getFightClubPlayer(creature, FIGHTING_PLAYERS);
	}

	public FightClubPlayer getFightClubPlayer(Creature creature, String... groups)
	{
		if (creature == null || !creature.isPlayable())
		{
			return null;
		}

		final int lookedPlayerId = creature.getPlayer().getObjectId();

		for (FightClubPlayer iFPlayer : getPlayers(groups))
		{
			if (iFPlayer.getPlayer().getObjectId() == lookedPlayerId)
			{
				return iFPlayer;
			}
		}
		return null;
	}

	private void spreadIntoTeamsAndPartys()
	{
		for (int i = 0; i < _room.getTeamsCount(); i++)
		{
			_teams.add(new FightClubTeam(i + 1));
		}
		int index = 0;
		for (Player player : _room.getAllPlayers())
		{
			FightClubTeam team = _teams.get(index % _room.getTeamsCount());
			final FightClubPlayer fPlayer = getFightClubPlayer(player, REGISTERED_PLAYERS);

			if (fPlayer == null)
			{
				continue;
			}

			fPlayer.setTeam(team);
			team.addPlayer(fPlayer);
			index++;
		}

		for (FightClubTeam team : _teams)
		{
			List<List<Player>> partys = spreadTeamInPartys(team);
			for (List<Player> party : partys)
			{
				createParty(party);
			}
		}
	}

	private List<List<Player>> spreadTeamInPartys(FightClubTeam team)
	{
		Map<PlayerClass, List<Player>> classesMap = new HashMap<>();
		for (PlayerClass getPlayerClass : PlayerClass.values())
		{
			classesMap.put(getPlayerClass, new ArrayList<Player>());
		}

		for (FightClubPlayer iFPlayer : team.getPlayers())
		{
			Player player = iFPlayer.getPlayer();
			PlayerClass getClassGroup = FightClubGameRoom.getPlayerClassGroup(player);
			if (getClassGroup != null)
			{
				classesMap.get(getClassGroup).add(player);
			}
			else
			{
				_log.warn("AbstractFightEvent: Problem with add player - " + player.getName());
				_log.warn("AbstractFightEvent: Class - " + player.getClassId().name() + " null for event!");
			}
		}

		int partyCount = (int) Math.ceil(team.getPlayers().size() / Party.MAX_SIZE);

		List<List<Player>> partys = new ArrayList<List<Player>>();
		for (int i = 0; i < partyCount; i++)
		{
			partys.add(new ArrayList<Player>());
		}

		if (partyCount == 0)
		{
			return partys;
		}

		int finishedOnIndex = 0;
		for (Entry<PlayerClass, List<Player>> getClassEntry : classesMap.entrySet())
		{
			for (Player player : getClassEntry.getValue())
			{
				partys.get(finishedOnIndex).add(player);
				finishedOnIndex++;
				if (finishedOnIndex == partyCount)
				{
					finishedOnIndex = 0;
				}
			}
		}
		return partys;
	}

	private void createParty(List<Player> listOfPlayers)
	{
		if (listOfPlayers.size() <= 1)
		{
			return;
		}

		Party newParty = null;
		for (Player player : listOfPlayers)
		{
			if (player.getParty() != null)
			{
				player.getParty().removePartyMember(player, true, true);
			}

			if (newParty == null)
			{
				player.setParty(newParty = new Party(player, 4));
			}
			else
			{
				player.joinParty(newParty, true);
			}
		}
	}

	private synchronized void createReflection(IntObjectMap<DoorTemplate> doors, Map<String, ZoneTemplate> zones)
	{
		InstantZone iz = InstantZoneHolder.getInstance().getInstantZone(400);

		_reflection = new Reflection();
		_reflection.init(iz);
		_reflection.init(doors, zones);

		for (Zone zone : _reflection.getZones())
		{
			zone.addListener(_zoneListener);
		}
	}

	private Location getSafeLocation(Location[] locations)
	{
		Location safeLoc = null;
		int checkedCount = 0;
		boolean isOk = false;

		while (!isOk)
		{
			safeLoc = Rnd.get(locations);
			isOk = nobodyIsClose(safeLoc);
			checkedCount++;

			if (checkedCount > locations.length * 2)
			{
				isOk = true;
			}
		}
		return safeLoc;
	}

	protected Location getTeamSpawn(FightClubPlayer fPlayer, boolean randomNotClosestToPt)
	{
		FightClubTeam team = fPlayer.getTeam();
		Location[] spawnLocs = getMap().getTeamSpawns().get(team.getIndex());

		if (randomNotClosestToPt || _state != EventState.STARTED)
		{
			return Rnd.get(spawnLocs);
		}
		else
		{
			List<Player> playersToCheck = new ArrayList<Player>();
			if (fPlayer.getParty() != null)
			{
				playersToCheck = fPlayer.getParty().getPartyMembers();
			}
			else
			{
				for (FightClubPlayer iFPlayer : team.getPlayers())
				{
					playersToCheck.add(iFPlayer.getPlayer());
				}
			}

			final Map<Location, Integer> spawnLocations = new HashMap<>(spawnLocs.length);
			for (Location loc : spawnLocs)
			{
				spawnLocations.put(loc, 0);
			}

			for (Player player : playersToCheck)
			{
				if (player != null && player.isOnline() && !player.isDead())
				{
					Location winner = null;
					double winnerDist = -1;
					for (Location loc : spawnLocs)
					{
						if (winnerDist <= 0 || winnerDist < player.getDistance(loc))
						{
							winner = loc;
							winnerDist = player.getDistance(loc);
						}
					}

					if (winner != null)
					{
						spawnLocations.put(winner, spawnLocations.get(winner) + 1);
					}
				}
			}

			Location winner = null;
			double points = -1;
			for (Entry<Location, Integer> spawn : spawnLocations.entrySet())
			{
				if (points < spawn.getValue())
				{
					winner = spawn.getKey();
					points = spawn.getValue();
				}
			}

			if (points <= 0.0D)
			{
				return Rnd.get(spawnLocs);
			}
			return winner;
		}
	}

	public void giveAdditionalRewards(FightClubPlayer iFPlayer, boolean oneOf)
	{
		final PcInventory inventory = iFPlayer.getPlayer().getInventory();
		synchronized (inventory)
		{
			if (oneOf)
			{
				// calculate the total weight of all items
				double totalWeight = Arrays.stream(getAdditionalRewards()).mapToDouble(RewardData::getChance).sum();

				// randomly pick an item based on its probability
				double randomValue = Rnd.nextDouble() * totalWeight;
				double cumulativeWeight = 0.0;
				RewardData selectedItem = null;
				for (RewardData ci : getAdditionalRewards())
				{
					cumulativeWeight += ci.getChance();
					if (randomValue <= cumulativeWeight) {
						selectedItem = ci;
						break;
					}
				}

				if (selectedItem != null)
				{
					inventory.addItem(selectedItem.getItemId(), Rnd.get(selectedItem.getMinDrop(), selectedItem.getMaxDrop()));
				}
			}
			else
			{
				for (RewardData reward : getAdditionalRewards())
				{
					if (Rnd.chance(reward.getChance())) {
						long count = Rnd.get(reward.getMinDrop(), reward.getMaxDrop());
						inventory.addItem(reward.getItemId(), count);
						sendMessageToPlayer(iFPlayer, MessageType.NORMAL_MESSAGE, "You have earned " + count + " " + ItemNameHolder.getInstance().getItemName(iFPlayer.getPlayer(), reward.getItemId()));
					}
 				}
			}
		}


	}

	private void giveRewards(FightClubPlayer[] topKillers)
	{
		for (final FightClubPlayer iFPlayer : getPlayers(FIGHTING_PLAYERS))
		{
			if (iFPlayer != null)
			{
				rewardPlayer(iFPlayer, Util.arrayContains(topKillers, iFPlayer));
			}
		}
	}

	private void showLastAFkMessage()
	{
		for (final FightClubPlayer iFPlayer : getPlayers(FIGHTING_PLAYERS))
		{
			int minutesAFK = (int) Math.round(iFPlayer.getTotalAfkSeconds() / 60.0D);
			int badgesDecreased = -minutesAFK * BADGES_FOR_MINUTE_OF_AFK;
			if (badgesDecreased > 0)
			{
				sendMessageToPlayer(iFPlayer, MessageType.NORMAL_MESSAGE, "Reward decreased by " + badgesDecreased + " FA for AFK time!");
				sendMessageToPlayer(iFPlayer, MessageType.NORMAL_MESSAGE, "Reward decreased by " + badgesDecreased + " FA for AFK time!");
			}
		}
	}

	private Map<String, Integer> getBestScores()
	{
		List<Entry<String, Integer>> points = new ArrayList<>(_scores.entrySet());
		points.sort(Map.Entry.comparingByValue());
		Collections.reverse(points);

		Map<String, Integer> finalResult = new LinkedHashMap<>();
		for (Map.Entry<String, Integer> i : points)
		{
			finalResult.put(i.getKey(), i.getValue());
		}

		_bestScores = finalResult;
		_scoredUpdated = false;
		return finalResult;
	}

	private void updateEveryScore()
	{
		for (final FightClubPlayer iFPlayer : getPlayers(FIGHTING_PLAYERS))
		{
			iFPlayer.getPlayer().sendUserInfo(true);
			iFPlayer.getPlayer().broadcastCharInfo();
			_scores.put(getScorePlayerName(iFPlayer), iFPlayer.getKills(true));
			_scoredUpdated = true;
		}
	}

	protected String getTeamName(FightClubTeam team) {
		return team.getName();
	}

	private String getScreenScores(boolean showScoreNotKills, boolean teamPointsNotInvidual)
	{
		String msg = "";
		if (isTeamed() && teamPointsNotInvidual)
		{
			List<FightClubTeam> teams = getTeams();
			Collections.sort(teams, new BestTeamComparator(showScoreNotKills));
			for (FightClubTeam team : teams)
			{
				msg = msg + getTeamName(team) + ": " + (showScoreNotKills ? team.getScore() : getTeamTotalKills(team)) + " " + (showScoreNotKills ? "Points" : "Kills") + "\n";
			}
		}
		else
		{
			final List<FightClubPlayer> fPlayers = getPlayers(FIGHTING_PLAYERS);
			final List<FightClubPlayer> changedFPlayers = new ArrayList<FightClubPlayer>(fPlayers.size());
			changedFPlayers.addAll(fPlayers);

			Collections.sort(changedFPlayers, new BestPlayerComparator(showScoreNotKills));
			int max = Math.min(10, changedFPlayers.size());
			for (int i = 0; i < max; i++)
			{
				msg = msg + changedFPlayers.get(i).getPlayer().getName() + " " + (showScoreNotKills ? "Score" : "Kills") + ": " + (showScoreNotKills ? changedFPlayers.get(i).getScore() : changedFPlayers.get(i).getKills(true)) + "\n";
			}
		}
		return msg;
	}

	protected int getRewardForWinningTeam(FightClubPlayer fPlayer, boolean atLeast1Kill)
	{
		if ((!_teamed) || ((_state != EventState.OVER) && (_state != EventState.NOT_ACTIVE)))
		{
			return 0;
		}
		if ((atLeast1Kill) && (fPlayer.getKills(true) <= 0) && (FightClubGameRoom.getPlayerClassGroup(fPlayer.getPlayer()) != PlayerClass.HEALERS))
		{
			return 0;
		}
		FightClubTeam winner = null;
		int winnerPoints = -1;
		boolean sameAmount = false;
		for (FightClubTeam team : getTeams())
		{
			if (team.getScore() > winnerPoints)
			{
				winner = team;
				winnerPoints = team.getScore();
				sameAmount = false;
			}
			else if (team.getScore() == winnerPoints)
			{
				sameAmount = true;
			}
		}

		if ((!sameAmount) && (fPlayer.getTeam().equals(winner)))
		{
			return (int) _badgeWin;
		}

		return 0;
	}

	protected int getRewardForLosingTeam(FightClubPlayer fPlayer, boolean atLeast1Kill)
	{
		if ((!_teamed) || ((_state != EventState.OVER) && (_state != EventState.NOT_ACTIVE)))
		{
			return 0;
		}

		if ((atLeast1Kill) && (fPlayer.getKills(true) <= 0) && (FightClubGameRoom.getPlayerClassGroup(fPlayer.getPlayer()) != PlayerClass.HEALERS))
		{
			return 0;
		}

		FightClubTeam loser = null;
		int winnerPoints = -1;
		boolean sameAmount = false;
		for (FightClubTeam team : getTeams())
		{
			if (team.getScore() < winnerPoints)
			{
				loser = team;
				winnerPoints = team.getScore();
				sameAmount = false;
			}
			else if (team.getScore() == winnerPoints)
			{
				sameAmount = true;
			}
		}

		if ((!sameAmount) && (fPlayer.getTeam().equals(loser)))
		{
			return (int) _badgeLose;
		}

		return 0;
	}

	private boolean nobodyIsClose(Location loc)
	{
		for (final FightClubPlayer iFPlayer : getPlayers(FIGHTING_PLAYERS))
		{
			final Location playerLoc = iFPlayer.getPlayer().getLoc();
			if (Math.abs(playerLoc.getX() - loc.getX()) <= CLOSE_LOCATIONS_VALUE)
			{
				return false;
			}
			if (Math.abs(playerLoc.getY() - loc.getY()) <= CLOSE_LOCATIONS_VALUE)
			{
				return false;
			}
		}
		return true;
	}

	private void checkIfRegisteredMeetCriteria()
	{
		for (final FightClubPlayer iFPlayer : getPlayers(REGISTERED_PLAYERS))
		{
			if (iFPlayer != null)
			{
				checkIfRegisteredPlayerMeetCriteria(iFPlayer);
			}
		}
	}

	private boolean checkIfRegisteredPlayerMeetCriteria(FightClubPlayer fPlayer)
	{
		return FightClubEventManager.getInstance().canPlayerParticipate(fPlayer.getPlayer(), true, false);
	}

	private void cancelNegativeEffects(Playable playable)
	{
		List<Abnormal> _buffList = new ArrayList<>();

		for (Abnormal e : playable.getAbnormalList().values())
		{
			if (e.isOffensive() && e.isCancelable())
			{
				_buffList.add(e);
			}
		}

		for (Abnormal e : _buffList)
		{
			e.exit();
		}
	}

	private RewardData[] parseAdditionalRewards(String classes)
	{
		if (classes.isEmpty())
		{
			return new RewardData[0];
		}

		String[] rewardData = classes.split(";");
		RewardData[] additionalRewards = new RewardData[rewardData.length];

		for (int i = 0, rewardDataLength = rewardData.length; i < rewardDataLength; i++)
		{
			final String itemStr = rewardData[i];
			final String[] itemData = itemStr.split(",");
			int itemId = Integer.parseInt(itemData[0]);
			long minCnt = Long.parseLong(itemData[1]);
			long maxCnt = Long.parseLong(itemData[2]);
			double chance = Double.parseDouble(itemData[3]);

			additionalRewards[i] = new RewardData(itemId, minCnt, maxCnt, chance);
		}

		return additionalRewards;
	}

	private PlayerClass[] parseExcludedClasses(String classes)
	{
		if (classes.isEmpty())
		{
			return new PlayerClass[0];
		}

		String[] classType = classes.split(";");
		PlayerClass[] realTypes = new PlayerClass[classType.length];

		for (int i = 0; i < classType.length; i++)
		{
			realTypes[i] = PlayerClass.valueOf(classType[i]);
		}

		return realTypes;
	}

	protected int[] parseExcludedSkills(String ids)
	{
		if (ids == null || ids.isEmpty())
		{
			return null;
		}

		StringTokenizer st = new StringTokenizer(ids, ";");
		int[] realIds = new int[st.countTokens()];
		int index = 0;
		while (st.hasMoreTokens())
		{
			realIds[index] = Integer.parseInt(st.nextToken());
			index++;
		}
		return realIds;
	}

	private int[][] parseAutoStartTimes(String times)
	{
		if (times == null || times.isEmpty())
			return (int[][]) null;

		StringTokenizer st = new StringTokenizer(times, ",");
		int[][] realTimes = new int[st.countTokens()][2];
		int index = 0;
		while (st.hasMoreTokens())
		{
			String[] hourMin = st.nextToken().split(":");
			int[] realHourMin =
			{
				Integer.parseInt(hourMin[0]),
				Integer.parseInt(hourMin[1])
			};
			realTimes[index] = realHourMin;
			index++;
		}
		return realTimes;
	}

	private int[][] parseBuffs(String buffs)
	{
		if (buffs == null || buffs.isEmpty())
			return (int[][]) null;

		StringTokenizer st = new StringTokenizer(buffs, ";");
		int[][] realBuffs = new int[st.countTokens()][2];
		int index = 0;
		while (st.hasMoreTokens())
		{
			String[] skillLevel = st.nextToken().split(",");
			int[] realHourMin =
			{
				Integer.parseInt(skillLevel[0]),
				Integer.parseInt(skillLevel[1])
			};
			realBuffs[index] = realHourMin;
			index++;
		}
		return realBuffs;
	}

	public void onDamage(Creature actor, Creature victim, double damage)
	{
	}

	public boolean canAttackDoor(DoorInstance door, Creature attacker)
	{
		Player player;
		FightClubPlayer fPlayer;
		switch (door.getDoorType())
		{
			case WALL:
				return false;
			case DOOR:
				player = attacker.getPlayer();
				if (player == null)
					return false;
				fPlayer = getFightClubPlayer((Creature) player);
				if (fPlayer == null)
					return false;
				break;
		}
		return !door.isInvulnerable();
	}

	public synchronized boolean onTalkNpc(Player activeChar, NpcInstance npc)
	{
		return false;
	}

	private int getTimeToWait(int totalLeftTimeInSeconds)
	{
		int toWait = 1;

		int[] stops =
		{
			5,
			15,
			30,
			60,
			300,
			600,
			900
		};

		for (int stop : stops)
		{
			if (totalLeftTimeInSeconds > stop)
			{
				toWait = stop;
			}
		}
		return toWait;
	}

	public static boolean teleportWholeRoomTimer(int eventObjId, int secondsLeft)
	{
		final AbstractFightClub event = FightClubEventManager.getInstance().getEventByObjId(eventObjId);
		if (secondsLeft == 0)
		{
			event._dontLetAnyoneIn = true;
			event.startEvent();
		}
		else
		{
			event.checkIfRegisteredMeetCriteria();
			event.sendMessageToRegistered(MessageType.SCREEN_BIG, "You are going to be teleported in " + getFixedTime(secondsLeft) + "!");
		}
		return true;
	}

	public static boolean startRoundTimer(int eventObjId, int secondsLeft)
	{
		AbstractFightClub event = FightClubEventManager.getInstance().getEventByObjId(eventObjId);

		if (secondsLeft > 0)
		{
			String firstWord;
			if (event.isRoundEvent())
			{
				firstWord = (event.getCurrentRound() + 1 == event.getTotalRounds() ? "Last" : ROUND_NUMBER_IN_STRING[(event.getCurrentRound() + 1)]) + " Round";
			}
			else
			{
				firstWord = "Match";
			}
			String message = firstWord + " is going to start in " + getFixedTime(secondsLeft) + "!";
			event.sendMessageToFighting(MessageType.SCREEN_BIG, message, true);
		}
		else
		{
			event.startRound();
		}
		return true;
	}

	public static boolean endRoundTimer(int eventObjId, int secondsLeft)
	{
		final AbstractFightClub event = FightClubEventManager.getInstance().getEventByObjId(eventObjId);
		if (secondsLeft > 0)
		{
			event.sendMessageToFighting(MessageType.SCREEN_BIG, (!event.isLastRound() ? "Round" : "Match") + " is going to be Over in " + getFixedTime(secondsLeft) + "!", false);
		}
		else
		{
			event.endRound();
		}
		return true;
	}

	public static boolean shutDownTimer(int eventObjId, int secondsLeft)
	{
		final AbstractFightClub event = FightClubEventManager.getInstance().getEventByObjId(eventObjId);

		if (!FightClubEventManager.getInstance().serverShuttingDown())
		{
			event._dontLetAnyoneIn = false;
			return false;
		}

		if (secondsLeft < 180)
		{
			if (!event._dontLetAnyoneIn)
			{
				event.sendMessageToRegistered(MessageType.CRITICAL, "You are no longer registered because of Shutdown!");
				for (final FightClubPlayer player : event.getPlayers(REGISTERED_PLAYERS))
				{
					event.unregister(player.getPlayer());
				}
				event.getObjects(REGISTERED_PLAYERS).clear();
				event._dontLetAnyoneIn = true;
			}
		}

		if (secondsLeft < 60)
		{
			event._timer.cancel(false);
			event.sendMessageToFighting(MessageType.CRITICAL, "Event ended because of Shutdown!", false);
			event.setState(EventState.OVER);
			event.stopEvent(false);

			event._dontLetAnyoneIn = false;
			return false;
		}
		return true;
	}

	public static boolean teleportBackSinglePlayerTimer(int eventObjId, int secondsLeft, Player player)
	{
		final AbstractFightClub event = FightClubEventManager.getInstance().getEventByObjId(eventObjId);

		if (player == null || !player.isOnline())
		{
			return false;
		}

		if (secondsLeft > 0)
		{
			event.sendMessageToPlayer(player, MessageType.SCREEN_BIG, new CustomMessage("l2s.gameserver.model.entity.events.impl.fightclub.ctf.tbBackIn").toString(player));
		}
		else
		{
			event.teleportBackToTown(player);
		}
		return true;
	}

	public static boolean ressurectionTimer(int eventObjId, int secondsLeft, FightClubPlayer fPlayer)
	{
		final AbstractFightClub event = FightClubEventManager.getInstance().getEventByObjId(eventObjId);
		final Player player = fPlayer.getPlayer();

		if (player == null || !player.isOnline() || !player.isDead())
		{
			return false;
		}

		if (secondsLeft > 0)
		{
			player.sendMessage("Respawn in " + getFixedTime(secondsLeft) + "!");
		}
		else
		{
			event.hideScores(player);
			event.teleportSinglePlayer(fPlayer, false, true);
		}
		return true;
	}

	public static boolean setInvisible(int eventObjId, int secondsLeft, FightClubPlayer fPlayer, boolean sendMessages)
	{
		final AbstractFightClub event = FightClubEventManager.getInstance().getEventByObjId(eventObjId);
		if (fPlayer.getPlayer() == null || !fPlayer.getPlayer().isOnline())
		{
			return false;
		}

		if (secondsLeft > 0)
		{
			if (sendMessages)
			{
				event.sendMessageToPlayer(fPlayer, MessageType.SCREEN_BIG, "Visible in " + getFixedTime(secondsLeft) + "!");
			}
		}
		else
		{
			if (sendMessages && event.getState() == EventState.STARTED)
			{
				event.sendMessageToPlayer(fPlayer, MessageType.SCREEN_BIG, "Fight!");
			}
			event.stopInvisibility(fPlayer.getPlayer());
		}
		return true;
	}

	public void startNewTimer(boolean saveAsMainTimer, int firstWaitingTimeInMilis, String methodName, Object... args)
	{
		final ScheduledFuture<?> timer = ThreadPoolManager.getInstance().schedule(new SmartTimer(methodName, saveAsMainTimer, args), firstWaitingTimeInMilis);
		if (saveAsMainTimer)
		{
			_timer = timer;
		}
		else
		{
			_secondaryTimers.add(timer);
		}
	}

	@Override
	public void reCalcNextTime(boolean onInit)
	{
		clearActions();
		registerActions();
	}

	@Override
	public EventType getType()
	{
		return EventType.FIGHT_CLUB_EVENT;
	}

	@Override
	protected long startTimeMillis()
	{
		return 0L;
	}

	@Override
	public void onAddEvent(GameObject o)
	{
		if (o.isPlayer())
		{
			o.getPlayer().addListener(_exitListener);
		}
	}

	@Override
	public void onRemoveEvent(GameObject o)
	{
		if (o.isPlayer())
		{
			o.getPlayer().removeListener(_exitListener);
		}
	}

	@Override
	public void printInfo()
	{
		info(getName() + " inited");
	}

	public void printScheduledTime(long startTime)
	{
		info(getName() + " time - " + TimeUtils.toSimpleFormat(startTime));
	}

	@Override
	public boolean isInProgress()
	{
		return _state != EventState.NOT_ACTIVE;
	}

	private class SmartTimer implements Runnable
	{
		private final String _methodName;
		private final Object[] _args;
		private final boolean _saveAsMain;

		private SmartTimer(String methodName, boolean saveAsMainTimer, Object[] args)
		{
			_methodName = methodName;

			final Object[] changedArgs = new Object[args.length + 1];
			changedArgs[0] = Integer.valueOf(getObjectId());
			for (int i = 0; i < args.length; i++)
			{
				changedArgs[(i + 1)] = args[i];
			}
			_args = changedArgs;
			_saveAsMain = saveAsMainTimer;
		}

		@Override
		public void run()
		{
			final Class<?>[] parameterTypes = new Class<?>[_args.length];
			for (int i = 0; i < _args.length; i++)
			{
				parameterTypes[i] = _args[i] != null ? _args[i].getClass() : null;
			}

			int waitingTime = ((Integer) _args[1]).intValue();

			try
			{
				Object ret = MethodUtils.invokeMethod(AbstractFightClub.this, _methodName, _args, parameterTypes);
				if (!((boolean) ret))
				{
					return;
				}
			}
			catch (IllegalAccessException | NoSuchMethodException | InvocationTargetException e)
			{
				e.printStackTrace();
			}

			if (waitingTime > 0)
			{
				int toWait = AbstractFightClub.this.getTimeToWait(waitingTime);
				waitingTime -= toWait;
				_args[1] = Integer.valueOf(waitingTime);
				ScheduledFuture<?> timer = ThreadPoolManager.getInstance().schedule(this, toWait * 1000);
				if (_saveAsMain)
				{
					_timer = timer;
				}
			}
			else
			{
				return;
			}
		}
	}

	private class BestPlayerComparator implements Comparator<FightClubPlayer>
	{
		private boolean _scoreNotKills;

		private BestPlayerComparator(boolean scoreNotKills)
		{
			_scoreNotKills = scoreNotKills;
		}

		public int compare(FightClubPlayer arg0, FightClubPlayer arg1)
		{
			if (_scoreNotKills)
			{
				return Integer.compare(arg1.getScore(), arg0.getScore());
			}
			return Integer.compare(arg1.getKills(true), arg0.getKills(true));
		}
	}

	private class BestTeamComparator implements Comparator<FightClubTeam>
	{
		private boolean _scoreNotKills;

		private BestTeamComparator(boolean scoreNotKills)
		{
			_scoreNotKills = scoreNotKills;
		}

		@Override
		public int compare(FightClubTeam arg0, FightClubTeam arg1)
		{
			if (_scoreNotKills)
			{
				return Integer.compare(arg1.getScore(), arg0.getScore());
			}
			return Integer.compare(getTeamTotalKills(arg1), getTeamTotalKills(arg0));
		}
	}

	private class CheckAfkThread implements Runnable
	{
		@Override
		public void run()
		{
			long currentTime = System.currentTimeMillis();
			for (final FightClubPlayer iFPlayer : getPlayers(FIGHTING_PLAYERS))
			{
				final Player player = iFPlayer.getPlayer();
				boolean isAfk = player.getLastNotAfkTime() + 30000L < currentTime;

				if (player.isDead() && !_ressAllowed && getRespawnTime() <= 0)
				{
					isAfk = false;
				}

				if (iFPlayer.isAfk())
				{
					if (!isAfk)
					{
						handleAfk(iFPlayer, false);
					}
					else if (_state != EventState.OVER)
					{
						sendMessageToPlayer(player, MessageType.CRITICAL, new CustomMessage("l2s.gameserver.model.entity.events.impl.fightclub.ctf.afkMode").toString(player));
					}
				}
				else if (_state == EventState.NOT_ACTIVE)
				{
					handleAfk(iFPlayer, false);
				}
				else if (isAfk)
				{
					handleAfk(iFPlayer, true);
				}
			}

			if (getState() != EventState.NOT_ACTIVE)
			{
				ThreadPoolManager.getInstance().schedule(this, 1000L);
			}
			else
			{
				for (final FightClubPlayer iFPlayer : getPlayers(FIGHTING_PLAYERS))
				{
					if (iFPlayer.isAfk())
					{
						AbstractFightClub.this.handleAfk(iFPlayer, false);
					}
				}
			}
		}
	}

	private class LeftZoneThread implements Runnable
	{
		@Override
		public void run()
		{
			final List<FightClubPlayer> toDelete = new ArrayList<FightClubPlayer>();
			for (Entry<FightClubPlayer, Zone> entry : _leftZone.entrySet())
			{
				Player player = entry.getKey().getPlayer();
				if (player == null || !player.isOnline() || _state == EventState.NOT_ACTIVE || entry.getValue().checkIfInZone(player) || player.isDead() || player.isTeleporting())
				{
					toDelete.add(entry.getKey());
					continue;
				}

				int power = (int) Math.max(400, entry.getValue().findDistanceToZone(player, true) - 4000);

				player.sendPacket(new EarthQuakePacket(player.getLoc(), power, 5));
				player.sendPacket(new SayPacket2(0, ChatType.COMMANDCHANNEL_ALL, "Error", "Go Back To Event Zone!"));
				entry.getKey().increaseSecondsOutsideZone();

				if (entry.getKey().getSecondsOutsideZone() >= TIME_MAX_SECONDS_OUTSIDE_ZONE)
				{
					player.doDie(null);
					toDelete.add(entry.getKey());
					entry.getKey().clearSecondsOutsideZone();
				}
			}

			for (FightClubPlayer playerToDelete : toDelete)
			{
				if (playerToDelete != null)
				{
					_leftZone.remove(playerToDelete);
					playerToDelete.clearSecondsOutsideZone();
				}
			}

			if (_state != EventState.NOT_ACTIVE)
			{
				ThreadPoolManager.getInstance().schedule(this, 1000L);
			}
		}
	}

	private class TimeSpentOnEventThread implements Runnable
	{
		@Override
		public void run()
		{
			if (_state == EventState.STARTED)
			{
				for (final FightClubPlayer iFPlayer : getPlayers(FIGHTING_PLAYERS))
				{
					if (iFPlayer.getPlayer() == null || !iFPlayer.getPlayer().isOnline() || iFPlayer.isAfk())
					{
						continue;
					}
					iFPlayer.incSecondsSpentOnEvent(10);
				}
			}

			if (_state != EventState.NOT_ACTIVE)
			{
				ThreadPoolManager.getInstance().schedule(new TimeSpentOnEventThread(), 10000L);
			}
		}
	}

	private class ZoneListener implements OnZoneEnterLeaveListener
	{
		@Override
		public void onZoneEnter(Zone zone, Creature actor)
		{
			if (actor.isPlayer())
			{
				FightClubPlayer fPlayer = getFightClubPlayer(actor);
				if (fPlayer != null)
				{
					actor.sendPacket(new EarthQuakePacket(actor.getLoc(), 0, 1));
					_leftZone.remove(getFightClubPlayer(actor));
				}
			}
		}

		@Override
		public void onZoneLeave(Zone zone, Creature actor)
		{
			if (actor.isPlayer() && _state != EventState.NOT_ACTIVE)
			{
				FightClubPlayer fPlayer = getFightClubPlayer(actor);
				if (fPlayer != null)
				{
					_leftZone.put(getFightClubPlayer(actor), zone);
				}
			}
		}
	}

	private class ExitListener implements OnPlayerExitListener
	{
		@Override
		public void onPlayerExit(Player player)
		{
			loggedOut(player);
		}
	}

	protected boolean isPlayerActive(Player player)
	{
		if (player == null)
		{
			return false;
		}
		if (player.isDead())
		{
			return false;
		}
		if (!player.getReflection().equals(getReflection()))
		{
			return false;
		}
		if (System.currentTimeMillis() - player.getLastNotAfkTime() > 120000L)
		{
			return false;
		}
		boolean insideZone = false;
		for (Zone zone : getReflection().getZones())
		{
			if (zone.checkIfInZone(player.getX(), player.getY(), player.getZ(), player.getReflection()))
			{
				insideZone = true;
			}
		}
		if (!insideZone)
		{
			return false;
		}
		return true;
	}

	private FightClubPlayer[] getTopKillers()
	{
		if ((!_teamed) || (topKillerReward == 0))
		{
			return null;
		}
		FightClubPlayer[] topKillers = new FightClubPlayer[_teams.size()];
		int[] topKillersKills = new int[_teams.size()];

		int teamIndex = 0;
		for (FightClubTeam team : _teams)
		{
			for (FightClubPlayer fPlayer : team.getPlayers())
			{
				if (fPlayer != null)
				{
					if (fPlayer.getKills(true) == topKillersKills[teamIndex])
					{
						topKillers[teamIndex] = null;
					}
					else if (fPlayer.getKills(true) > topKillersKills[teamIndex])
					{
						topKillers[teamIndex] = fPlayer;
						topKillersKills[teamIndex] = fPlayer.getKills(true);
					}
				}
			}
			teamIndex++;
		}
		return topKillers;
	}

	@Override
	public boolean isForceScheduled()
	{
		return _isForceScheduled;
	}

	@Override
	public boolean forceScheduleEvent()
	{
		if(isForceScheduled())
			return false;

		if(isInProgress())
			return false;

		_isForceScheduled = true;
		clearActions();
		_startTimeMillis = getForceStartTime();
		registerActions();
		return true;
	}

	@Override
	public boolean forceCancelEvent()
	{
		if(!isForceScheduled())
			return false;

		_isForceScheduled = false;
		stopEvent(true);
		reCalcNextTime(false);
		return true;
	}

	protected boolean isAfkTimerStopped(Player player)
	{
		return (player.isDead()) && (!_ressAllowed) && (_respawnTime <= 0);
	}

	public boolean canStandUp(Player player)
	{
		return true;
	}
}