package l2s.gameserver.model.entity.olympiad;

import java.util.ArrayList;
import java.util.List;
import java.util.concurrent.ScheduledFuture;

import l2s.gameserver.network.l2.s2c.*;
import org.apache.commons.lang3.StringUtils;
import l2s.commons.util.Rnd;
import l2s.gameserver.Config;
import l2s.gameserver.data.xml.holder.InstantZoneHolder;
import l2s.gameserver.geometry.Location;
import l2s.gameserver.instancemanager.OlympiadHistoryManager;
import l2s.gameserver.model.ObservableArena;
import l2s.gameserver.model.ObservePoint;
import l2s.gameserver.model.Player;
import l2s.gameserver.model.base.TeamType;
import l2s.gameserver.model.entity.Reflection;
import l2s.gameserver.model.instances.DoorInstance;
import l2s.gameserver.model.instances.NpcInstance;
import l2s.gameserver.model.quest.QuestState;
import l2s.gameserver.network.l2.components.IBroadcastPacket;
import l2s.gameserver.network.l2.components.NpcString;
import l2s.gameserver.network.l2.components.SystemMsg;
import l2s.gameserver.templates.InstantZone;
import l2s.gameserver.utils.Functions;
import l2s.gameserver.utils.ItemFunctions;
import l2s.gameserver.utils.Log;
import l2s.gameserver.utils.PlayerUtils;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

public class OlympiadGame extends ObservableArena
{
	private static final Logger _log = LoggerFactory.getLogger(OlympiadGame.class);

	public static final int MAX_POINTS_LOOSE = 10;

	public boolean validated = false;

	private int _winner = 0;
	private int _state = 0;
	private int _winCountTeam1 = 0;
	private int _winCountTeam2 = 0;
	private int _id;
	private Reflection _reflection;
	private CompType _type;

	private int _round = 1;

	private OlympiadMember _member1;
	private OlympiadMember _member2;

	private long _startTime;

	public OlympiadGame(int id, CompType type, int member1, int member2)
	{
		_type = type;
		_id = id;
		_reflection = new Reflection();
		InstantZone instantZone = InstantZoneHolder.getInstance().getInstantZone(Rnd.get(new int[]{ 147, 149, 150 }));
		_reflection.init(instantZone);

		_member1 = new OlympiadMember(member1, this, 1);
		_member2 = new OlympiadMember(member2, this, 2);

		Log.add("Olympiad System: Game - " + id + ": " + _member1.getName() + " vs " + _member2.getName(), "olympiad");
	}

	public void addBuffers()
	{
		_reflection.spawnByGroup("olympiad_" + _reflection.getInstancedZoneId() + "_buffers");
	}

	public void deleteBuffers()
	{
		_reflection.despawnByGroup("olympiad_" + _reflection.getInstancedZoneId() + "_buffers");
	}

	public void managerShout()
	{
		for(NpcInstance npc : Olympiad.getNpcs())
		{
			NpcString npcString;
			switch(_type)
			{
				case CLASSED:
					npcString = NpcString.OLYMPIAD_CLASS_INDIVIDUAL_MATCH_IS_GOING_TO_BEGIN_IN_ARENA_S1_IN_A_MOMENT;
					break;
				case NON_CLASSED:
					npcString = NpcString.OLYMPIAD_CLASSFREE_INDIVIDUAL_MATCH_IS_GOING_TO_BEGIN_IN_ARENA_S1_IN_A_MOMENT;
					break;
				default:
					continue;
			}
			Functions.npcShout(npc, npcString, String.valueOf(_id + 1));
		}
	}

	public void portPlayersToArena()
	{
		if (_member1.getPlayer() != null)
			_member1.getPlayer().setTarget(null);
		if (_member2.getPlayer() != null)
			_member2.getPlayer().setTarget(null);
		_member1.portPlayerToArena();
		_member2.portPlayerToArena();
	}

	public void preparePlayers1()
	{
		_member1.preparePlayer1();
		_member2.preparePlayer1();
	}

	public void preparePlayers2()
	{
		_member1.preparePlayer2();
		_member2.preparePlayer2();
	}

	public void portPlayersBack()
	{
		if (_member1.getPlayer() != null) {
			_member1.getPlayer().setTarget(null);
		}
		if (_member2.getPlayer() != null) {
			_member2.getPlayer().setTarget(null);
		}
		_member1.portPlayerBack();
		_member2.portPlayerBack();
	}

	public boolean validatePlayers()
	{
		Player player1 = _member1.getPlayer();
		Player player2 = _member2.getPlayer();

		if(!Olympiad.validPlayer(player1, player2, _type, true))
			return false;

		if(!Olympiad.validPlayer(player2, player1, _type, true))
			return false;

		return true;
	}

	public void collapse()
	{
		onExitObserverArena(_member1.getPlayer());
		onExitObserverArena(_member2.getPlayer());

		portPlayersBack();
		clearObservers();
		_reflection.collapse();
	}

	// Someone is 100% missing as it's getting called after logout...
	public void sendMatchInfo(int time) 
	{
		if (_member1 != null && _member1.getPlayer() != null)
			_member1.getPlayer().sendPacket(new ExOlympiadMatchInfo(_member1.getName(), _member2.getName(), _winCountTeam1, _winCountTeam2, _round, time));
		if (_member2 != null && _member2.getPlayer() != null)
			_member2.getPlayer().sendPacket(new ExOlympiadMatchInfo(_member1.getName(), _member2.getName(), _winCountTeam1, _winCountTeam2, _round, time));
	}

	public boolean chekTieMatch(){
		_member1.getPlayer().sendPacket(SystemMsg.OLYMPIAD_TIME_OUT);
		_member2.getPlayer().sendPacket(SystemMsg.OLYMPIAD_TIME_OUT);
		if(_round < 4) {
			if (_member1.getDamage() == 0 && _member2.getDamage() == 0) {
				_winCountTeam1++;
				_winCountTeam2++;
				sendMatchInfo(20);
			}
			if (_winCountTeam1 == 2 && _winCountTeam2 == 2){
				tie();
				return false;
			}

			if (_winCountTeam1 == 2) {
				_member1.getPlayer().sendPacket(SystemMsg.OLYMPIAD_VICTORY);
				_member2.getPlayer().sendPacket(SystemMsg.OLYMPIAD_DEFEAT);
				winGame(_member1, _member2);// Выиграла первая команда
				return false;
			} else if (_winCountTeam2 == 2) {
				_member2.getPlayer().sendPacket(SystemMsg.OLYMPIAD_VICTORY);
				_member1.getPlayer().sendPacket(SystemMsg.OLYMPIAD_DEFEAT);
				winGame(_member2, _member1); // Выиграла вторая команда
				return false;
			}
			else {
				_member1.getPlayer().sendPacket(SystemMsg.OLYMPIAD_TIE);
				_member2.getPlayer().sendPacket(SystemMsg.OLYMPIAD_TIE);
				_round++;
				if (getRound() == 3)
					preparePlayers1();
				else preparePlayers2();
			}
			return true;
		}
		return false;
	}

	public void validateWinner(boolean aborted) throws Exception {
		int state = _state;
		sendMatchInfo(20);

		if (validated) {
			if (!aborted)
				Log.add("Olympiad Result: " + _member1.getName() + " vs " + _member2.getName() + " ... double validate check!!!", "olympiad");
			return;
		}

		// Если игра закончилась до телепортации на стадион, то забираем очки у вышедших из игры, не засчитывая никому победу
		if (state < 1 && aborted) {
			_member1.onGameAbortBeforeTeleport();
			_member2.onGameAbortBeforeTeleport();
			broadcastPacket(SystemMsg.YOUR_OPPONENT_MADE_HASTE_WITH_THEIR_TAIL_BETWEEN_THEIR_LEGS_THE_MATCH_HAS_BEEN_CANCELLED, true, false);
			return;
		}

		boolean member1Check = _member1.checkPlayer();
		boolean member2Check = _member2.checkPlayer();

		if (_winner <= 0) {
			if (!member1Check && !member2Check) // both missing
				_winner = 0;
			else if (member1Check && !member2Check) // team 2 missing, so team 1 win
				_winner = 1;
			else if (!member1Check && member2Check) // team 1 missing, so team 2 win
				_winner = 2;
			if(!aborted) {
				if (_member1.getDamage() < _member2.getDamage()) { // Вторая команда нанесла вреда меньше, чем первая
					_winCountTeam1++;
				} else if (_member1.getDamage() > _member2.getDamage()) { // Вторая команда нанесла вреда больше, чем первая
					_winCountTeam2++;
				}
			}

			_member1.resetDamage();
			_member2.resetDamage();

			if (_winCountTeam1 == 2) {
				_winner = 1; // Выиграла первая команда
			} else if (_winCountTeam2 == 2) {
				_winner = 2; // Выиграла вторая команда
			}

		}

		if (_winner == 1) // Выиграла первая команда
			winGame(_member1, _member2);
		else if (_winner == 2) // Выиграла вторая команда
			winGame(_member2, _member1);

		if(_winner > 0){
			validated = true;
			_state = 0;

			sheduleTask(new OlympiadGameTask(this, BattleStatus.Ending, 0, 20000));

			_member1.saveParticipantData();
			_member2.saveParticipantData();

			broadcastRelation();
			broadcastPacket(new SystemMessagePacket(SystemMsg.YOU_WILL_BE_MOVED_BACK_TO_TOWN_IN_S1_SECONDS).addInteger(20), true, true);
		}
		else _round++;

		if(_round == 4 || _winner > 0) {
			if (validated && _state == 0) {
				return;
			}
			endGame(20000, true);
		}
		else{
			if(getRound() == 3)
				preparePlayers1();
			else preparePlayers2();

			sheduleTask(new OlympiadGameTask(this, BattleStatus.RoundInteval, 0, 5000));
		}
	}

	public int getRound(){
		return _round;
	}

	public void sendStartMatch() {
		SystemMsg msg = null;

		if(_round == 1) {
			msg = SystemMsg.OLYMPIAD_ROUND_1;
		}
		if(_round == 2) {
			msg = SystemMsg.OLYMPIAD_ROUND_2;
		}
		if(_round == 3) {
			msg = SystemMsg.OLYMPIAD_ROUND_3;
		}
		if (_member1 != null && _member1.getPlayer() != null) {
			_member1.getPlayer().sendPacket(msg, SystemMsg.OLYMPIAD_START);
		}
		if (_member2 != null && _member2.getPlayer() != null) {
			_member2.getPlayer().sendPacket(msg, SystemMsg.OLYMPIAD_START);
		}
	}

	private void winGame(OlympiadMember winnerMember, OlympiadMember looseMember)
	{
		ExReceiveOlympiadPacket.MatchResult packet = new ExReceiveOlympiadPacket.MatchResult(false, winnerMember.getName());

		int pointDiff = 0;
		if(looseMember != null && winnerMember != null)
		{
			winnerMember.incGameCount();
			looseMember.incGameCount();

			int gamePoints = transferPoints(looseMember.getStat(), winnerMember.getStat());

			packet.addPlayer(winnerMember == _member1 ? TeamType.RED : TeamType.BLUE, winnerMember, gamePoints, (int) looseMember.getSumDamage());
			packet.addPlayer(looseMember == _member1 ? TeamType.RED : TeamType.BLUE, looseMember, -gamePoints, (int) winnerMember.getSumDamage());

			pointDiff += gamePoints;
		}

		if(_member1 != null && _member2 != null)
		{
			int team = _member1 == winnerMember ? 1 : 2;
			int diff = (int) ((System.currentTimeMillis() - _startTime) / 1000L);
			OlympiadHistory h = new OlympiadHistory(_member1.getObjectId(), _member2.getObjectId(), _member1.getClassId(), _member2.getClassId(), _member1.getName(), _member2.getName(), _startTime, diff, team, _type.ordinal());
			OlympiadHistoryManager.getInstance().saveHistory(h);
		}

		if(Config.ALT_OLY_BATTLE_REWARD_ITEM > 0)
		{
			if(getType().getWinnerReward() > 0)
			{
				Player winnerPlayer = winnerMember.getPlayer();
				if(winnerPlayer != null)
					ItemFunctions.addItem(winnerPlayer, Config.ALT_OLY_BATTLE_REWARD_ITEM, getType().getWinnerReward());
			}

			if(getType().getLooserReward() > 0)
			{
				Player looserPlayer = looseMember.getPlayer();
				if(looserPlayer != null)
					ItemFunctions.addItem(looserPlayer, Config.ALT_OLY_BATTLE_REWARD_ITEM, getType().getLooserReward());
			}
		}

		for(OlympiadMember member : getAllMembers())
		{
			Player player = member.getPlayer();
			if(player == null)
				continue;

			player.getListeners().onOlympiadFinishBattle(this, winnerMember == member);

			for(QuestState qs : player.getAllQuestsStates())
			{
				if(qs.isStarted())
					qs.getQuest().onOlympiadEnd(this, qs);
			}
		}

		broadcastPacket(packet, true, false);

		//FIXME [VISTALL] неверная мессага?
		broadcastPacket(new SystemMessagePacket(SystemMsg.CONGRATULATIONS_C1_YOU_WIN_THE_MATCH).addString(winnerMember.getName()), false, true);

		//FIXME [VISTALL] нужно ли?
		//broadcastPacket(new SystemMessagePacket(SystemMsg.C1_HAS_EARNED_S2_POINTS_IN_THE_GRAND_OLYMPIAD_GAMES).addString(winnerMember.getName()).addInteger(pointDiff), true, false);
		//broadcastPacket(new SystemMessagePacket(SystemMsg.C1_HAS_LOST_S2_POINTS_IN_THE_GRAND_OLYMPIAD_GAMES).addString(looseMember.getName()).addInteger(pointDiff), true, false);

		Log.add("Olympiad Result: " + winnerMember.getName() + " vs " + looseMember.getName() + " ... (" + (int) winnerMember.getDamage() + " vs " + (int) looseMember.getDamage() + ") " + winnerMember.getName() + " win " + pointDiff + " points", "olympiad");
	}

	public void tie()
	{
		ExReceiveOlympiadPacket.MatchResult packet = new ExReceiveOlympiadPacket.MatchResult(true, StringUtils.EMPTY);
		try
		{
			if(_member1 != null)
			{
				_member1.incGameCount();
				OlympiadParticipiantData stat1 = _member1.getStat();
				packet.addPlayer(TeamType.RED, _member1, -2, (int) _member2.getSumDamage());

				stat1.setPoints(stat1.getPoints() - 2);
			}

			if(_member2 != null)
			{
				_member2.incGameCount();
				OlympiadParticipiantData stat2 = _member2.getStat();
				packet.addPlayer(TeamType.BLUE, _member2, -2, (int) _member1.getSumDamage());

				stat2.setPoints(stat2.getPoints() - 2);
			}
		}
		catch(Exception e)
		{
			_log.error("OlympiadGame.tie(): " + e, e);
		}

		if(_member1 != null && _member2 != null)
		{
			int diff = (int) ((System.currentTimeMillis() - _startTime) / 1000L);
			OlympiadHistory h = new OlympiadHistory(_member1.getObjectId(), _member2.getObjectId(), _member1.getClassId(), _member2.getClassId(), _member1.getName(), _member2.getName(), _startTime, diff, 0, _type.ordinal());

			OlympiadHistoryManager.getInstance().saveHistory(h);
		}

		for(OlympiadMember member : getAllMembers())
		{
			Player player = member.getPlayer();
			if(player == null)
				continue;

			player.getListeners().onOlympiadFinishBattle(this, false);

			for(QuestState qs : player.getAllQuestsStates())
			{
				if(qs.isStarted())
					qs.getQuest().onOlympiadEnd(this, qs);
			}
		}

		broadcastPacket(SystemMsg.THERE_IS_NO_VICTOR_THE_MATCH_ENDS_IN_A_TIE, false, true);
		broadcastPacket(packet, true, false);

		Log.add("Olympiad Result: " + _member1.getName() + " vs " + _member2.getName() + " ... tie", "olympiad");
	}

	private int transferPoints(OlympiadParticipiantData from, OlympiadParticipiantData to)
	{
		int fromPoints = from.getPoints();
		int fromLoose = from.getCompLoose();
		int fromPlayed = from.getCompDone();

		int toPoints = to.getPoints();
		int toWin = to.getCompWin();
		int toPlayed = to.getCompDone();

		int pointDiff = Math.max(1, Math.min(fromPoints, toPoints) / getType().getLooseMult());
		pointDiff = pointDiff > OlympiadGame.MAX_POINTS_LOOSE ? OlympiadGame.MAX_POINTS_LOOSE : pointDiff;

		from.setPoints(fromPoints - pointDiff);
		from.setCompLoose(fromLoose + 1);
		from.setCompDone(fromPlayed + 1);

		to.setPoints(toPoints + pointDiff);
		to.setCompWin(toWin + 1);
		to.setCompDone(toPlayed + 1);

		return pointDiff;
	}

	public void openDoors()
	{
		for(DoorInstance door : _reflection.getDoors())
			door.openMe();
	}

	public int getId()
	{
		return _id;
	}

	@Override
	public Reflection getReflection()
	{
		return _reflection;
	}

	@Override
	public Location getObserverEnterPoint(Player player)
	{
		List<Location> spawns = getReflection().getInstancedZone().getTeleportCoords();
		if(spawns.size() < 3)
		{
			Location c1 = spawns.get(0);
			Location c2 = spawns.get(1);
			return new Location((c1.x + c2.x) / 2, (c1.y + c2.y) / 2, (c1.z + c2.z) / 2);
		}
		else
			return spawns.get(2);
	}

	@Override
	public boolean showObservableArenasList(Player player)
	{
		if(!Olympiad.inCompPeriod() || Olympiad.isOlympiadEnd())
		{
			player.sendPacket(SystemMsg.THE_GRAND_OLYMPIAD_GAMES_ARE_NOT_CURRENTLY_IN_PROGRESS);
			return false;
		}
		player.sendPacket(new ExReceiveOlympiadPacket.MatchList());
		return true;
	}

	@Override
	public void onAppearObserver(ObservePoint observer)
	{
		broadcastInfo(null, observer.getPlayer(), true);
	}

	@Override
	public void onEnterObserverArena(Player player)
	{
		player.sendPacket(new ExOlympiadModePacket(3));
	}

	@Override
	public void onChangeObserverArena(Player player)
	{
		player.sendPacket(ExOlympiadMatchEndPacket.STATIC);
	}

	@Override
	public void onExitObserverArena(Player player)
	{
		// After collapsing arena, in case player just left the game
		if (player != null)
		{
			player.sendPacket(new ExOlympiadModePacket(0));
			player.sendPacket(ExOlympiadMatchEndPacket.STATIC);
		}
	}

	public boolean isRegistered(int objId)
	{
		return _member1.getObjectId() == objId || _member2.getObjectId() == objId;
	}

	public void broadcastInfo(Player sender, Player receiver, boolean onlyToObservers)
	{
		// TODO заюзать пакеты:
		// ExEventMatchCreate
		// ExEventMatchFirecracker
		// ExEventMatchManage
		// ExEventMatchMessage
		// ExEventMatchObserver
		// ExEventMatchScore
		// ExEventMatchTeamInfo
		// ExEventMatchTeamUnlocked
		// ExEventMatchUserInfo

		if(sender != null)
			if(receiver != null)
				receiver.sendPacket(new ExOlympiadUserInfoPacket(sender, sender.getOlympiadSide()));
			else
				broadcastPacket(new ExOlympiadUserInfoPacket(sender, sender.getOlympiadSide()), !onlyToObservers, true);
		else
		{
			// Рассылаем информацию о первой команде
			Player player = _member1.getPlayer();
			if(player != null)
			{
				if(receiver != null)
					receiver.sendPacket(new ExOlympiadUserInfoPacket(player, player.getOlympiadSide()));
				else
				{
					broadcastPacket(new ExOlympiadUserInfoPacket(player, player.getOlympiadSide()), !onlyToObservers, true);
					PlayerUtils.updateAttackableFlags(player);
				}
			}

			// Рассылаем информацию о второй команде
			player = _member2.getPlayer();
			if(player != null)
			{
				if(receiver != null)
					receiver.sendPacket(new ExOlympiadUserInfoPacket(player, player.getOlympiadSide()));
				else
				{
					broadcastPacket(new ExOlympiadUserInfoPacket(player, player.getOlympiadSide()), !onlyToObservers, true);
					PlayerUtils.updateAttackableFlags(player);
				}
			}
		}
	}

	public void broadcastRelation()
	{
		for(OlympiadMember member : getAllMembers())
		{
			Player player = member.getPlayer();
			if(player == null)
				continue;

			PlayerUtils.updateAttackableFlags(player);
		}
	}

	public void broadcastPacket(IBroadcastPacket packet, boolean toTeams, boolean toObservers)
	{
		if(toTeams)
		{
			for(OlympiadMember member : getAllMembers())
			{
				Player player = member.getPlayer();
				if(player == null)
					continue;

				player.sendPacket(packet);
			}
		}

		if(toObservers)
		{
			for(ObservePoint observer : getObservers())
				observer.sendPacket(packet);
		}
	}

	public List<Player> getAllPlayers()
	{
		List<Player> result = new ArrayList<Player>();

		Player player = _member1.getPlayer();
		if(player != null)
			result.add(player);

		player = _member2.getPlayer();
		if(player != null)
			result.add(player);

		for(ObservePoint observer : getObservers())
			result.add(observer.getPlayer());

		return result;
	}

	public void setWinner(int val)
	{
		if(val == 1){
			_winCountTeam1++;
			_winCountTeam1 = Math.min(_winCountTeam1, 3);
		}
		else if(val == 2){
			_winCountTeam2++;
			_winCountTeam2 = Math.min(_winCountTeam2, 3);
		}
		try {
			validateWinner(true);
		} catch (Exception e) {
			throw new RuntimeException(e);
		}

	}

	public OlympiadMember getWinnerMember()
	{
		if(_winner == 1) // Выиграла первая команда
			return _member1;
		else if(_winner == 2) // Выиграла вторая команда
			return _member2;
		return null;
	}

	public OlympiadMember[] getAllMembers()
	{
		return new OlympiadMember[] { _member1, _member2 };
	}

	public void setState(int val)
	{
		_state = val;
		if(_state == 1)
			_startTime = System.currentTimeMillis();
	}

	public int getState()
	{
		return _state;
	}

	public void addDamage(Player player, double damage)
	{
		if(player.getOlympiadSide() == 1)
			_member1.addDamage(damage);
		else
			_member2.addDamage(damage);
	}
	public void addSumDamage(Player player, double damage)
	{
		if(player.getOlympiadSide() == 1)
			_member1.addSumDamage(damage);
		else
			_member2.addSumDamage(damage);
	}

	public boolean checkPlayersOnline()
	{
		return _member1.checkPlayer() && _member2.checkPlayer();
	}

	public void logoutPlayer(Player player)
	{
		if(player != null)
		{
			if(player.getOlympiadSide() == 1)
			{
				_member1.logout();
				endGame(getStatus().ordinal() > BattleStatus.Begin_Countdown.ordinal() ? 20000 : 0, true);
			}
			else if(player.getOlympiadSide() == 2)
			{
				_member2.logout();
				endGame(getStatus().ordinal() > BattleStatus.Begin_Countdown.ordinal() ? 20000 : 0, true);
			}
		}
	}

	OlympiadGameTask _task;
	ScheduledFuture<?> _shedule;

	public synchronized void sheduleTask(OlympiadGameTask task)
	{
		if(_shedule != null)
			_shedule.cancel(false);
		_task = task;
		_shedule = task.shedule();
	}

	public OlympiadGameTask getTask()
	{
		return _task;
	}

	public BattleStatus getStatus()
	{
		if(_task != null)
			return _task.getStatus();
		return BattleStatus.Begining;
	}

	public void endGame(long time, boolean aborted)
	{
		try
		{
			validateWinner(aborted);
		}
		catch(Exception e)
		{
			_log.error("", e);
		}
	}



	public CompType getType()
	{
		return _type;
	}
	public void healMembers(){
		_member1.getPlayer().setCurrentHpMp(_member1.getPlayer().getMaxHp(), _member1.getPlayer().getMaxMp());
		_member1.getPlayer().setCurrentCp(_member1.getPlayer().getMaxCp());
		_member2.getPlayer().setCurrentHpMp(_member2.getPlayer().getMaxHp(), _member2.getPlayer().getMaxMp());
		_member2.getPlayer().setCurrentCp(_member2.getPlayer().getMaxCp());
	}

	public String getMemberName1()
	{
		return _member1.getName();
	}

	public String getMemberName2()
	{
		return _member2.getName();
	}
}