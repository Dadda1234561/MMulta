package l2s.gameserver.model.entity.events.impl;

import l2s.commons.collections.MultiValueSet;
import l2s.commons.time.cron.SchedulingPattern;
import l2s.commons.util.Rnd;
import l2s.gameserver.Announcements;
import l2s.gameserver.Config;
import l2s.gameserver.data.xml.holder.EventHolder;
import l2s.gameserver.geometry.Location;
import l2s.gameserver.listener.actor.player.impl.EventAnswerListner;
import l2s.gameserver.listener.hooks.ListenerHookType;
import l2s.gameserver.model.Creature;
import l2s.gameserver.model.GameObjectsStorage;
import l2s.gameserver.model.Player;
import l2s.gameserver.model.Skill;
import l2s.gameserver.model.base.RestartType;
import l2s.gameserver.model.base.TeamType;
import l2s.gameserver.model.entity.events.EventType;
import l2s.gameserver.model.entity.events.hooks.PvPEventHook;
import l2s.gameserver.model.entity.events.objects.PvPEventArenaObject;
import l2s.gameserver.model.entity.events.objects.PvPEventPlayerObject;
import l2s.gameserver.model.entity.olympiad.Olympiad;
import l2s.gameserver.network.l2.components.CustomMessage;
import l2s.gameserver.network.l2.components.SystemMsg;
import l2s.gameserver.network.l2.s2c.ConfirmDlgPacket;
import l2s.gameserver.network.l2.s2c.ExShowScreenMessage;
import l2s.gameserver.skills.AbnormalEffect;
import l2s.gameserver.stats.conditions.Condition;
import l2s.gameserver.stats.conditions.ConditionPlayerOlympiad;
import l2s.gameserver.utils.Functions;
import l2s.gameserver.utils.velocity.VelocityUtils;

import java.util.List;
import java.util.Map;
import java.util.StringTokenizer;
import java.util.concurrent.TimeUnit;
import java.util.concurrent.atomic.AtomicBoolean;
import java.util.concurrent.atomic.AtomicInteger;

/**
 LIO
 24.02.2016
 */
public class PvPEvent extends SingleMatchEvent
{
	private AtomicBoolean isEventActive = new AtomicBoolean(false);
	protected AtomicBoolean isRegActive = new AtomicBoolean(false);
	protected AtomicBoolean isBattleActive = new AtomicBoolean(false);

	private SchedulingPattern datePattern;

	private final CustomMessage _name;

	private final int _minLevel;
	private final int _maxLevel;
	private final int _minRebirths;
	private final int _minPlayers;
	private final int _teams;
	private final int _timerSeconds;
	private final int _countDieFromExit;
	private final int _minKillFromReward;
	private final int _minKillTeamFromReward;
	private final boolean _hideNick;
	private final boolean _incPvp;
	private final boolean _removeBuff;
	private final boolean _broadcastScore;
	private final int _modRewardForPremium;
	private final int[][] _buffs;
	private final boolean _disableHeroAndClanSkills;
	private final boolean _resetSkills;
	private final boolean _enableHeroCond;
	private final boolean _addHeroLastPlayer;
	private final boolean _applyInvulOnSpawn;

	private long _startTimeMillis = 0L;

	private boolean _isForceScheduled = false;

	private AtomicInteger _timer;

	public PvPEvent(MultiValueSet<String> set)
	{
		super(set);

		if(set.getBool("enabled", false))
		{
			String cron = set.getString("start_time", "");
			if(!cron.isEmpty())
				datePattern = new SchedulingPattern(cron);
		}

		_minLevel = Math.max(1, set.getInteger("min_level", 1));
		_maxLevel = Math.min(Config.ALT_MAX_LEVEL, set.getInteger("max_level", Config.ALT_MAX_LEVEL));

		_minRebirths = set.getInteger("min_rebirths", 0);

		VelocityUtils.GLOBAL_VARIABLES.put("PVP_EVENT_" + getId() + "_MIN_LEVEL", _minLevel);
		VelocityUtils.GLOBAL_VARIABLES.put("PVP_EVENT_" + getId() + "_MAX_LEVEL", _maxLevel);

		_name = new CustomMessage("l2s.gameserver.model.entity.events.impl.PvPEvent.eventname." + getId());
		_minPlayers = set.getInteger("min_players", 1);
		_teams = set.getInteger("teams");
		_countDieFromExit = set.getInteger("count_die_from_exit");
		_minKillFromReward = set.getInteger("min_kill_from_reward", 0);
		_minKillTeamFromReward = set.getInteger("min_kill_team_from_reward", 0);
		_hideNick = set.getBool("hide_nick", false);
		_incPvp = set.getBool("inc_pvp", false);
		_modRewardForPremium = set.getInteger("mod_reward_for_premium", 1);
		_buffs = parseBuffs(set.getString("buffs", ""));
		_disableHeroAndClanSkills = set.getBool("disable_hero_and_clan_skills", true);
		_resetSkills = set.getBool("reset_skills", true);
		_enableHeroCond = set.getBool("enable_hero_cond", true);
		_addHeroLastPlayer = set.getBool("add_hero_last_player", false);
		_timerSeconds =set.getInteger("timer_seconds", 0);
		_removeBuff = set.getBool("timer_seconds", true);
		_broadcastScore = set.getBool("broadcast_score", false);
		_applyInvulOnSpawn = set.getBool("invul_on_spawn", false);
		_timer = new AtomicInteger(_timerSeconds);
	}

	public boolean isApplyInvul()
	{
		return _applyInvulOnSpawn;
	}

	public CustomMessage getEventName()
	{
		return _name;
	}

	public int getMinLevel()
	{
		return _minLevel;
	}

	public int getMaxLevel()
	{
		return _maxLevel;
	}

	public int getMinRebirths()
	{
		return _minRebirths;
	}

	public int getTeams()
	{
		return _teams;
	}

	public int getCountDieFromExit()
	{
		return _countDieFromExit;
	}

	public int getMinKillFromReward()
	{
		return _minKillFromReward;
	}

	public int getMinKillTeamFromReward()
	{
		return _minKillTeamFromReward;
	}

	public boolean isHideNick()
	{
		return _hideNick;
	}

	public int getTimerSeconds()
	{
		return _timerSeconds;
	}

	public AtomicInteger getTimer()
	{
		return _timer;
	}

	public boolean isIncPvP()
	{
		return _incPvp;
	}
	public boolean isRemoveBuff()
	{
		return _removeBuff;
	}

	public boolean isBroadcastScore()
	{
		return _broadcastScore;
	}

	public int getModRewardForPremium()
	{
		return _modRewardForPremium;
	}

	public int[][] getBuffs()
	{
		return _buffs;
	}

	public boolean isDisableHeroAndClanSkills()
	{
		return _disableHeroAndClanSkills;
	}

	public boolean isResetSkills()
	{
		return _resetSkills;
	}

	public boolean isAddHeroLastPlayer()
	{
		return _addHeroLastPlayer;
	}

	public boolean isRegActive()
	{
		return isRegActive.get();
	}

	public boolean isBattleActive()
	{
		return isBattleActive.get();
	}

	@Override
	public void reCalcNextTime(boolean onInit)
	{
		if(datePattern != null)
		{
			clearActions();
			_startTimeMillis = datePattern.next(System.currentTimeMillis());
			registerActions();

			if(!onInit)
				printInfo();
		}
	}

	@Override
	public EventType getType()
	{
		return EventType.CUSTOM_PVP_EVENT;
	}

	@Override
	protected long startTimeMillis()
	{
		return _startTimeMillis;
	}

	//------------------------------------------------------------------------------------------------------------------

	@Override
	public boolean isInProgress()
	{
		return isEventActive.get();
	}

	@Override
	public void startEvent()
	{
		if(!isEventActive.compareAndSet(false, true))
			return;

		super.startEvent();
		clearActions();
		_startTimeMillis = System.currentTimeMillis() + 1000;
		registerActions();
	}

	@Override
	public void stopEvent(boolean force)
	{
		_isForceScheduled = false;

		if(force)
			action("battle", false);

		isEventActive.set(false);
		removeObjects("registered_players");

		if(!force)
			reCalcNextTime(false);
	}

	@Override
	public void announce(int id, String value, int time)
	{
		if (id == 1)
		{
			int val = Integer.parseInt(value);
			switch (val)
			{
				case 60:
				case 120:
				case 180:
					Announcements.announceToAllFromStringHolder("l2s.gameserver.model.entity.events.impl.PvPEvent.registration.announce", getEventName(), TimeUnit.SECONDS.toMinutes(300 - val));
					break;
				case 240:
					Announcements.announceToAllFromStringHolder("l2s.gameserver.model.entity.events.impl.PvPEvent.registration.announce.single", getEventName(), TimeUnit.SECONDS.toMinutes(300 - val));
					break;
			}
		}

		if (id == 2)
		{
			List<Player> registeredPlayers = getObjects("registered_players");
			int val = Integer.parseInt(value);
			if (val >= 290 && val < 300)
			{
				for (Player player : registeredPlayers)
				{
					if (player != null)
					{
						CustomMessage customMessage = new CustomMessage("l2s.gameserver.model.entity.events.impl.PvPEvent.registration.teleport").addCustomMessage(getEventName()).addNumber((300 - val));
						player.sendPacket(new ExShowScreenMessage(customMessage.toString(player), 1000, ExShowScreenMessage.ScreenMessageAlign.TOP_CENTER, false));
					}
				}
			}
		}
	}

	@Override
	public void action(String name, boolean start)
	{
		switch(name)
		{
			case "registration":
			{
				if(start)
				{
					isRegActive.set(true);
					Announcements.announceToAllFromStringHolder("l2s.gameserver.model.entity.events.impl.PvPEvent.registration.start", getEventName());
					if (_minRebirths > 0)
						Announcements.announceToAllFromStringHolder("l2s.gameserver.model.entity.events.impl.PvPEvent.registration.minRebirths", _minRebirths);

					CustomMessage askMessage = new CustomMessage("l2s.gameserver.model.entity.events.impl.PvPEvent.registration.ask").addCustomMessage(getEventName());

					for(Player player : GameObjectsStorage.getPlayers(true, false))
					{
						if(player.getRebirthCount() >= getMinRebirths() && player.getLevel() >= getMinLevel() && player.getLevel() <= getMaxLevel())
							player.ask(new ConfirmDlgPacket(SystemMsg.S1, 300000).addString(askMessage.toString(player)), new EventAnswerListner(player, getId()));
					}
				}
				else
				{
					isRegActive.set(false);

					List<Player> registeredPlayers = getObjects("registered_players");
					if(registeredPlayers.size() < _minPlayers)
					{
						Announcements.announceToAllFromStringHolder("l2s.gameserver.model.entity.events.impl.PvPEvent.registration.cancel", getEventName());
						stopEvent(true);
					}
					else
						Announcements.announceToAllFromStringHolder("l2s.gameserver.model.entity.events.impl.PvPEvent.registration.stop", getEventName());
				}
			}
			break;
			case "sort":
			{
				PvPEventArenaObject arena = new PvPEventArenaObject(this, _teams);
				addObject("arenas", arena);
				List<Player> registeredPlayers = getObjects("registered_players");
				arena.sortPlayers(registeredPlayers);
				removeObjects("registered_players");
			}
			break;
			case "teleport":
			{
				isBattleActive.set(true);
				List<PvPEventArenaObject> arenas = getObjects("arenas");
				for(PvPEventArenaObject arena : arenas)
				{
					arena.teleportPlayers();
				}
			}
			break;
			case "battle":
			{
				List<PvPEventArenaObject> arenas = getObjects("arenas");
				for(PvPEventArenaObject arena : arenas)
				{
					if(start)
						arena.startBattle();
					else
						arena.stopBattle();
				}
				if(!start)
				{
					isBattleActive.set(false);
					stopEvent(false);
				}
			}
			break;
			default:
				super.action(name, start);
		}
	}

	//------------------------------------------------------------------------------------------------------------------

	private boolean checkReg(Player player)
	{
		if (player.getRebirthCount() < getMinRebirths())
			return false;

		if(player.getLevel() > getMaxLevel() || player.getLevel() < getMinLevel())
			return false;

		if(player.isMounted() || player.isDead() || player.isInObserverMode())
			return false;

		final SingleMatchEvent evt = player.getEvent(SingleMatchEvent.class);
		if(evt != null && evt != this)
			return false;

		if(player.getTeam() != TeamType.NONE)
			return false;

		if(/*!player.isFakePlayer() && */player.getOlympiadGame() != null || Olympiad.isRegistered(player))
			return false;

		if(player.isTeleporting())
			return false;

		if(isRegistered(player))
			return false;

		for(PvPEvent events : EventHolder.getInstance().getEvents(PvPEvent.class))
		{
			if(events.isRegistered(player))
				return false;
		}
		return true;
	}

	public void showReg()
	{
		for(Player player : GameObjectsStorage.getPlayers(false, false))
		{
			if(isRegActive())
			{
				if(isRegistered(player))
					Functions.show("events/event_yesreg.htm", player);
				else if(checkReg(player))
					Functions.show("events/event_" + getId() + ".htm", player);
			}
			else
				Functions.show("events/event_noreg.htm", player);
		}
	}

	public void reg(Player player)
	{
		if(isRegActive.get() && (checkReg(player)/* || player.isFakePlayer()*/))
		{
			addObject("registered_players", player);
			player.addListenerHook(ListenerHookType.PLAYER_QUIT_GAME, PvPEventHook.getInstance());
			player.sendMessage(new CustomMessage("l2s.gameserver.model.entity.events.impl.PvPEvent.registration.success").addCustomMessage(getEventName()));
		}
	}

	public void regCustom(Player player, String command)
	{
		//
	}

	//------------------------------------------------------------------------------------------------------------------

	public Location getLocation(String teleportWho)
	{
		List<Location> teleportList = getObjects(teleportWho);
		return teleportList.get(Rnd.get(0, teleportList.size() - 1));
	}

	public void abnormals(Player player, boolean start)
	{
		PvPEventPlayerObject member = getParticipant(player);
		if(member == null)
			return;

		int teamId = member.getTeam();
		if(teamId == -1)
			teamId = 0;

		List<AbnormalEffect> abnormalEffects = getObjects("abnormal" + teamId);
		for(AbnormalEffect abnormalEffect : abnormalEffects)
		{
			if(start)
				player.startAbnormalEffect(abnormalEffect);
			else
				player.stopAbnormalEffect(abnormalEffect);
		}
	}

	//------------------------------------------------------------------------------------------------------------------

	@Override
	public SystemMsg checkForAttack(Creature target, Creature attacker, Skill skill, boolean force)
	{
		if(!isEnemy(target, attacker))
			return SystemMsg.INVALID_TARGET;
		return null;
	}

	@Override
	public boolean canAttack(Creature target, Creature attacker, Skill skill, boolean force, boolean nextAttackCheck)
	{
		return isEnemy(target, attacker);
	}

	private boolean isEnemy(Creature target, Creature attacker)
	{
		PvPEventPlayerObject attackerMember = getParticipant(attacker.getPlayer());
		if(attackerMember == null)
			return false;
		PvPEventPlayerObject targetMember = getParticipant(target.getPlayer());
		if(targetMember == null)
			return false;
		return attackerMember.getTeam() == -1 || attackerMember.getTeam() != targetMember.getTeam();
	}

	//------------------------------------------------------------------------------------------------------------------

	public boolean isRegistered(Player player)
	{
		List<Player> players = getObjects("registered_players");
		for(Player temp : players)
		{
			if(player.equals(temp))
				return true;
		}
		return false;
	}

	public PvPEventArenaObject getArena(Player player)
	{
		List<PvPEventArenaObject> arenas = getObjects("arenas");
		for(PvPEventArenaObject arena : arenas)
		{
			if(arena.getParticipant(player) != null)
				return arena;
		}
		return null;
	}

	public PvPEventPlayerObject getParticipant(Player player)
	{
		PvPEventArenaObject arena = getArena(player);
		if(arena != null)
			return arena.getParticipant(player);
		return null;
	}

	@Override
	public String getVisibleName(Player player, Player observer)
	{
		if(player != observer)
		{
			if(isBattleActive() && isHideNick())
				return new CustomMessage("l2s.gameserver.model.entity.events.impl.PvPEvent.playername").toString(observer);
		}
		return null;
	}

	@Override
	public String getVisibleTitle(Player player, Player observer)
	{
		if(isBattleActive() && isHideNick()) {
			return getTitleForPlayer(player);
		}
		return "null";
	}

	private String getTitleForPlayer(Player player)
	{
		PvPEventArenaObject arena = getArena(player);
		if (arena == null) {
			return null;
		}
		PvPEventPlayerObject participant = arena.getParticipant(player);
		if (participant == null) {
			return null;
		}
		return String.format("Kills: %d | Deaths: %d", participant.getPoints(), participant.getCountDie());
	}

	@Override
	public Integer getVisibleNameColor(Player player, Player observer)
	{
		if(isBattleActive() && isHideNick())
			return player.getTeam().equals(TeamType.BLUE) ? 11877953 : 1453793;
		return null;
	}

	@Override
	public Integer getVisibleTitleColor(Player player, Player observer)
	{
		if(isBattleActive() && isHideNick())
			return player.getTeam().equals(TeamType.BLUE) ? 11877953 : 1453793;;
		return null;
	}

	@Override
	public boolean isPledgeVisible(Player player, Player observer)
	{
		if(isBattleActive() && isHideNick())
			return false;
		return true;
	}

	@Override
	public boolean checkCondition(Creature creature, Class<? extends Condition> conditionClass)
	{
		if(isBattleActive() && _enableHeroCond)
		{
			if(conditionClass == ConditionPlayerOlympiad.class)
				return false;
			if(conditionClass.isAssignableFrom(ConditionPlayerOlympiad.class)) // TODO: Нужно ли?
				return false;
		}
		return true;
	}

	@Override
	public Boolean isInZoneBattle(Creature creature)
	{
		return isBattleActive();
	}

	public boolean checkStop()
	{
		return true;
	}

	@Override
	public boolean canJoinParty(Player inviter, Player target)
	{
		return false;
	}

	private int[][] parseBuffs(String buffs)
	{
		if(buffs == null || buffs.isEmpty())
			return new int[][] {};

		StringTokenizer st = new StringTokenizer(buffs, ";");
		int[][] realBuffs = new int[st.countTokens()][2];
		int index = 0;
		while(st.hasMoreTokens())
		{
			String[] skillLevel = st.nextToken().split(",");
			int[] realHourMin = { Integer.parseInt(skillLevel[0]), Integer.parseInt(skillLevel[1]) };
			realBuffs[index] = realHourMin;
			index++;
		}
		return realBuffs;
	}

	@Override
	public void checkRestartLocs(Player player, Map<RestartType, Boolean> r)
	{
		r.clear();
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
}