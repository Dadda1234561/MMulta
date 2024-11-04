package l2s.gameserver.model.entity.events.objects;

import java.util.ArrayList;
import java.util.Collections;
import java.util.Comparator;
import java.util.HashMap;
import java.util.List;
import java.util.Set;
import java.util.concurrent.CopyOnWriteArraySet;
import java.util.concurrent.ScheduledFuture;
import java.util.stream.Collectors;

import l2s.gameserver.ThreadPoolManager;
import l2s.gameserver.data.xml.holder.SkillHolder;
import l2s.gameserver.network.l2.s2c.ExBlockUpSetList;
import l2s.gameserver.network.l2.s2c.ExBlockUpSetState;
import l2s.gameserver.network.l2.s2c.ExUserInfoAbnormalVisualEffect;
import l2s.gameserver.skills.AbnormalEffect;
import l2s.gameserver.utils.Language;
import org.napile.primitive.maps.IntObjectMap;
import org.napile.primitive.maps.impl.HashIntObjectMap;

import l2s.commons.util.Rnd;
import l2s.gameserver.Announcements;
import l2s.gameserver.data.xml.holder.DoorHolder;
import l2s.gameserver.geometry.Location;
import l2s.gameserver.instancemanager.ReflectionManager;
import l2s.gameserver.listener.hooks.ListenerHookType;
import l2s.gameserver.model.Player;
import l2s.gameserver.model.Servitor;
import l2s.gameserver.model.Skill;
import l2s.gameserver.model.actor.instances.creature.Abnormal;
import l2s.gameserver.model.actor.instances.player.Cubic;
import l2s.gameserver.model.base.TeamType;
import l2s.gameserver.model.entity.Reflection;
import l2s.gameserver.model.entity.events.hooks.PvPEventHook;
import l2s.gameserver.model.entity.events.impl.DuelEvent;
import l2s.gameserver.model.entity.events.impl.PvPEvent;
import l2s.gameserver.network.l2.components.CustomMessage;
import l2s.gameserver.network.l2.s2c.ExShowScreenMessage;
import l2s.gameserver.skills.TimeStamp;
import l2s.gameserver.templates.DoorTemplate;
import l2s.gameserver.templates.ZoneTemplate;
import l2s.gameserver.utils.ItemFunctions;

/**
 LIO
 24.02.2016
 */
public class PvPEventArenaObject extends Reflection
{
	private final PvPEvent _pvpEvent;

	private ScheduledFuture<?> _timerTask = null;

	private final List<Set<PvPEventPlayerObject>> _teamsList;

	public PvPEventArenaObject(PvPEvent pvpEvent, int teams)
	{
		super();

		_pvpEvent = pvpEvent;

		List<DoorObject> doors = _pvpEvent.getObjects("doors");
		IntObjectMap<DoorTemplate> doorTemplates = new HashIntObjectMap<DoorTemplate>(doors.size());
		for(DoorObject door : doors)
		{
			DoorTemplate doorTemplate = DoorHolder.getInstance().getTemplate(door.getId());
			if(doorTemplate != null)
				doorTemplates.put(doorTemplate.getId(), doorTemplate);
		}
		init(doorTemplates, new HashMap<String, ZoneTemplate>());

		List<SpawnableObject> spawns = _pvpEvent.getObjects("spawns");
		for(SpawnableObject spawn : spawns)
			spawn.spawnObject(_pvpEvent, this);

		_teamsList = new ArrayList<>(teams);
		for(int i = 0; i < teams; i++)
		{
			_teamsList.add(new CopyOnWriteArraySet<>());
		}
	}

	public void addPlayer(Player player, int teamId)
	{
		switch(teamId)
		{
			case 0:
				player.setTeam(TeamType.BLUE);
				break;
			case 1:
				player.setTeam(TeamType.RED);
				break;
		}
		_teamsList.get(teamId).add(new PvPEventPlayerObject(player, teamId));
	}

	public void sortPlayers(List<Player> players)
	{
		Collections.shuffle(players);
		int teamId = 0;
		for(Player player : players)
		{
			if(_teamsList.size() == 1)
			{
				player.setTeam(TeamType.RED);
				_teamsList.get(0).add(new PvPEventPlayerObject(player, -1));
			}
			else
			{
				switch(teamId)
				{
					case 0:
						player.setTeam(TeamType.BLUE);
						break;
					case 1:
						player.setTeam(TeamType.RED);
						break;
				}

				_teamsList.get(teamId).add(new PvPEventPlayerObject(player, teamId));
				teamId++;

				if(teamId == _teamsList.size())
					teamId = 0;
			}
		}
	}

//	public void teleportPlayer(Player player, int teamId)
//	{
//		player.leaveParty(false);
//		player.setStablePoint(player.getLoc());
//		player.addEvent(_pvpEvent);
//		teleportPlayer(player, _pvpEvent.getLocation("team" + teamId));
//		_pvpEvent.abnormals(player, true);
//		addHook(player);
//	}

	public void teleportPlayers()
	{
		for(int i = 0; i < _teamsList.size(); i++)
		{
			for(PvPEventPlayerObject member : _teamsList.get(i))
			{
				Player player = member.getPlayer();
				if(player == null)
					continue;

				if (player.isDead()) {
					player.doRevive(100);
				}

				player.setCurrentCp(player.getMaxCp());
				player.setCurrentHp(player.getMaxHp(), false);
				player.setCurrentMp(player.getMaxMp());

				player.leaveParty(true);
				player.setStablePoint(player.getLoc());
				player.addEvent(_pvpEvent);
				teleportPlayer(player, _pvpEvent.getLocation("team" + i));
				block(player);
				_pvpEvent.abnormals(player, true);
				addHook(player);
				player.sendPacket(new ExBlockUpSetList.TeamList(getRedPlayers(), getBluePlayers(), 1));
				// player.getInventory().validateItems();
				// player.getInventory().refreshEquip();
			}
		}
	}

	private List<Player> getBluePlayers() {
		return _teamsList.get(0).stream().map(PvPEventPlayerObject::getPlayer).collect(Collectors.toList());
	}

	private List<Player> getRedPlayers() {
		return _teamsList.get(1).stream().map(PvPEventPlayerObject::getPlayer).collect(Collectors.toList());
	}

	public void startBattle()
	{
		//Forming packets to send everybody
		final ExBlockUpSetState.PointsInfo initialPoints = new ExBlockUpSetState.PointsInfo(_pvpEvent.getTimer().get(), 0, 0);
		final ExBlockUpSetList.CloseUI cui = new ExBlockUpSetList.CloseUI();
		final ExBlockUpSetList.TeamList tList = new ExBlockUpSetList.TeamList(Collections.emptyList(), Collections.emptyList(), 1);

		ExBlockUpSetState.ChangePoints clientSetUp;

		for(int i = 0; i < _teamsList.size(); i++)
		{
			for(PvPEventPlayerObject member : _teamsList.get(i))
			{
				Player player = member.getPlayer();
				if(player == null)
					continue;

				unBlock(player);
				buff(player);

				clientSetUp = new ExBlockUpSetState.ChangePoints(_pvpEvent.getTimer().get(), 0, 0, TeamType.RED.equals(player.getTeam()), player, 0);
				player.sendPacket(clientSetUp);
				player.sendActionFailed(); //useless? copy&past from BlockChecker
				player.sendPacket(initialPoints);
				player.sendPacket(tList); //useless? copy&past from BlockChecker
				player.sendPacket(cui); //useless? copy&past from BlockChecker
				player.sendPacket(new ExShowScreenMessage(new CustomMessage("l2s.gameserver.model.entity.events.impl.PvPEvent.toBattle").toString(player), 5000, ExShowScreenMessage.ScreenMessageAlign.TOP_CENTER, true, 1, -1, true));
				if (_pvpEvent.getId() == 2) {
					player.getListeners().onParticipateInEvent("TvT", false);
				}
			}
		}
		startTimer();
	}

	private void startTimer()
	{
		if (_pvpEvent.getTimerSeconds() > 0)
		{
			stopTimer();
			_timerTask = ThreadPoolManager.getInstance().scheduleAtFixedRate(this::tickTimer, 1000L, 1000L);
		}

	}

	private void stopTimer()
	{
		if (_timerTask != null)
		{
			_timerTask.cancel(false);
			_timerTask = null;
		}

		_pvpEvent.getTimer().set(_pvpEvent.getTimerSeconds());
	}

	public void tickTimer()
	{
		int seconds = _pvpEvent.getTimer().decrementAndGet();
		if (seconds == 0)
		{
			stopTimer();
		}
	}

	public void stopBattle()
	{
		if (_pvpEvent.isBroadcastScore())
		{
			updateScreenScore(true);
		}

		rewardTeams();
		for(int i = 0; i < _teamsList.size(); i++)
		{
			for(PvPEventPlayerObject member : _teamsList.get(i))
			{
				Player player = member.getPlayer();
				if(player == null)
					continue;

				removePlayer(player);
			}
		}
		stopTimer();
		_pvpEvent.removeObject("arenas", this);
		collapse();
	}



	public void check()
	{
		if(_teamsList.size() >= 2)
		{
			int emptyTeams = 0;
			for(Set<PvPEventPlayerObject> team : _teamsList)
			{
				if(team.isEmpty())
					emptyTeams++;
			}

			if(_teamsList.size() - emptyTeams <= 1)
				stopBattle();
		}
		else
		{
			if(_teamsList.get(0).size() <= 1)
			{
				if(_teamsList.get(0).size() == 1)
				{
					PvPEventPlayerObject object = _teamsList.get(0).iterator().next();

					if(_pvpEvent.isAddHeroLastPlayer() && !object.getPlayer().isHero())
						object.getPlayer().setCustomHero(1);

					List<RewardObject> rewards = _pvpEvent.getObjects("reward_for_last_player");
					for(RewardObject reward : rewards)
					{
						if(Rnd.chance(reward.getChance()))
							ItemFunctions.addItem(object.getPlayer(), reward.getItemId(), Rnd.get(reward.getMinCount(), reward.getMaxCount()));
					}

					Announcements.announceToAllFromStringHolder("l2s.gameserver.model.entity.events.impl.PvPEvent.eventWinner", _pvpEvent.getName(), object.getPlayer().getName());
				}
				stopBattle();
			}
		}
	}

	public void teleportPlayer(Player player, Location location)
	{
		if(player.isTeleporting())
			return;

		if(player.isDead())
		{
			player.doRevive(100);
			player.setCurrentHp(player.getMaxHp(), true);
		}
		else
			player.setCurrentHp(player.getMaxHp(), false);

		player.setCurrentCp(player.getMaxCp());
		player.setCurrentMp(player.getMaxMp());

		if(player.isInObserverMode())
			player.leaveObserverMode();

		if(_pvpEvent.isDisableHeroAndClanSkills())
		{
			// Un activate clan skills
			if(player.getClan() != null)
				player.getClan().disableSkills(player);

			// Деактивируем геройские скиллы.
			player.activateHeroSkills(false);
		}

		// Abort casting if player casting
		player.abortCast(true, true);

		// Abort attack if player attacking
		player.abortAttack(true, true);

		if (_pvpEvent.isRemoveBuff())
		{
			// Удаляем баффы и чужие кубики
			for(Abnormal abnormal : player.getAbnormalList())
			{
				if(!player.isSpecialAbnormal(abnormal.getSkill()))
					abnormal.exit();
			}

			for(Cubic cubic : player.getCubics())
			{
				if(player.getSkillLevel(cubic.getSkill().getId()) <= 0)
					cubic.delete();
			}
		}

		// Remove Servitor's Buffs
		for(Servitor servitor : player.getServitors())
		{
			if(servitor.isPet())
				servitor.unSummon(false);
			else
			{
				if (_pvpEvent.isRemoveBuff())
				{
					servitor.getAbnormalList().stopAll();
				}
				servitor.transferOwnerBuffs();
			}
		}

		// unsummon agathion
		if(player.getAgathionNpcId() > 0)
			player.deleteAgathion();

		if(_pvpEvent.isResetSkills())
		{
			// Сброс кулдауна всех скилов, время отката которых меньше 15 минут
			for(TimeStamp sts : player.getSkillReuses())
			{
				if(sts == null)
					continue;

				Skill skill = SkillHolder.getInstance().getSkill(sts.getId(), sts.getLevel());
				if(skill == null)
					continue;

				if(sts.getReuseBasic() <= 15 * 60001L)
					player.enableSkill(skill);
			}
		}

		// Обновляем скилл лист, после удаления скилов
		player.sendSkillList();

		// Проверяем одетые вещи на возможность ношения.
		player.getInventory().validateItems();

		// remove bsps/sps/ss automation
		player.removeAutoShots(true);

		player.broadcastUserInfo(true);

		DuelEvent duel = player.getEvent(DuelEvent.class);
		if(duel != null)
			duel.abortDuel(player);

		if(player.isSitting())
			player.standUp();

		player.setTarget(null);

		player.teleToLocation(location, this);
	}

	public void block(Player player)
	{
		player.getFlags().getImmobilized().start(this);
		player.getFlags().getInvulnerable().start(this);
	}

	public void unBlock(Player player)
	{
		player.getFlags().getImmobilized().stop(this);
		player.getFlags().getInvulnerable().stop(this);
	}

	public void buff(Player player)
	{
		if (_pvpEvent.isRemoveBuff())
		{
			for(Abnormal abnormal : player.getAbnormalList())
			{
				if(!player.isSpecialAbnormal(abnormal.getSkill()))
					abnormal.exit();
			}
		}

		for(int[] skillId : _pvpEvent.getBuffs())
		{
			Skill skill = SkillHolder.getInstance().getSkill(skillId[0], skillId[1]);
			if(skill != null)
				skill.getEffects(player, player);
		}

		Skill skill = SkillHolder.getInstance().getSkill(1323, 1);
		if(skill != null)
			skill.getEffects(player, player);
	}

	public void heal(Player player)
	{
		player.setCurrentHp(player.getMaxHp(), false);
		player.setCurrentCp(player.getMaxCp());
		player.setCurrentMp(player.getMaxMp());

		if (_pvpEvent.isApplyInvul())
		{
			player.getFlags().getInvulnerable().start();
			player.getAbnormalEffects().add(AbnormalEffect.INVINCIBILITY);
			ThreadPoolManager.getInstance().schedule(() ->
					{
					player.getFlags().getInvulnerable().stop();
					player.getAbnormalEffects().remove(AbnormalEffect.INVINCIBILITY);
				}, 2 * 1000L);
		}
	}

	public void addHook(Player player)
	{
		player.addListenerHook(ListenerHookType.PLAYER_TELEPORT, PvPEventHook.getInstance());
		player.addListenerHook(ListenerHookType.PLAYER_DIE, PvPEventHook.getInstance());
	}

	public void removeHook(Player player)
	{
		player.removeListenerHookType(ListenerHookType.PLAYER_QUIT_GAME, PvPEventHook.getInstance());
		player.removeListenerHookType(ListenerHookType.PLAYER_TELEPORT, PvPEventHook.getInstance());
		player.removeListenerHookType(ListenerHookType.PLAYER_DIE, PvPEventHook.getInstance());
	}

	public void removePlayer(Player player)
	{
		PvPEventPlayerObject member = getParticipant(player);
		if(member == null)
			return;

		_pvpEvent.abnormals(player, false);

		int teamId = member.getTeam();
		if(teamId == -1)
		{
			teamId = 0;
		}

		_teamsList.get(teamId).remove(member);

		removeHook(player);
		unBlock(player);

		player.removeEvent(_pvpEvent);
		player.setTeam(TeamType.NONE);
		player.teleToLocation(player.getStablePoint(), ReflectionManager.MAIN);

		if(player.isDead())
		{
			player.doRevive(100);
			player.setCurrentHp(player.getMaxHp(), true);
		}
		else
		{
			player.setCurrentHp(player.getMaxHp(), false);
		}

		player.setCurrentCp(player.getMaxCp());
		player.setCurrentMp(player.getMaxMp());

		if(player.getClan() != null)
			player.getClan().enableSkills(player);

		player.activateHeroSkills(true);

		player.sendSkillList();
	}

	public void rewardTeams()
	{
		_teamsList.sort(new WinComparator());

		Set<PvPEventPlayerObject> teamWin = _teamsList.get(0);
		if(getPointByTeam(teamWin) >= _pvpEvent.getMinKillTeamFromReward())
		{
			List<RewardObject> rewards = _pvpEvent.getObjects("reward_for_win_team");

			for(PvPEventPlayerObject object : teamWin)
			{
				Player player = object.getPlayer();
				player.sendPacket(new ExShowScreenMessage(new CustomMessage("l2s.gameserver.model.entity.events.impl.PvPEvent.win").toString(player), 5000, ExShowScreenMessage.ScreenMessageAlign.TOP_CENTER, true, 1, -1, true));
				if (_pvpEvent.getId() == 2) { // Win
					player.getListeners().onParticipateInEvent("TvT", true);
				}
			}

			takeReward(teamWin, rewards);
		}

		List<RewardObject> rewards = _pvpEvent.getObjects("reward_for_lose_team");
		for(int i = 1; i < _teamsList.size(); i++)
		{
			Set<PvPEventPlayerObject> teamLose = _teamsList.get(i);

			for(PvPEventPlayerObject object : teamLose)
			{
				Player player = object.getPlayer();
				player.sendPacket(new ExShowScreenMessage(new CustomMessage("l2s.gameserver.model.entity.events.impl.PvPEvent.lose").toString(player), 5000, ExShowScreenMessage.ScreenMessageAlign.TOP_CENTER, true, 1, -1, true));
			}

			if(getPointByTeam(teamLose) < _pvpEvent.getMinKillTeamFromReward())
				continue;

			takeReward(teamLose, rewards);
		}
	}

	public void updateScreenScore(boolean finish)
	{
		int blueScore = getPointByTeam(_teamsList.get(0));
		int redScore = getPointByTeam(_teamsList.get(1));
		int seconds = _pvpEvent.getTimer().get();

		if (finish)
		{
			for (Set<PvPEventPlayerObject> pvPEventPlayerObjects : _teamsList)
			{
				for (PvPEventPlayerObject pvpEventPlayer : pvPEventPlayerObjects)
				{
					pvpEventPlayer.getPlayer().sendPacket(new ExBlockUpSetState.GameEnd(redScore > blueScore));
				}
			}
			return;
		}

        for (Set<PvPEventPlayerObject> eventPlayerObjects : _teamsList)
		{
            for (PvPEventPlayerObject pvpEventPlayer : eventPlayerObjects)
			{
                boolean isRed = pvpEventPlayer.getTeam() == 1;
                pvpEventPlayer.getPlayer().sendPacket(new ExBlockUpSetState.PointsInfo(_pvpEvent.getTimer().get(), getPointByTeam(_teamsList.get(0)), getPointByTeam(_teamsList.get(1))), new ExBlockUpSetState.ChangePoints(seconds, getPointByTeam(_teamsList.get(0)), getPointByTeam(_teamsList.get(1)), isRed, pvpEventPlayer.getPlayer(), pvpEventPlayer.getPoints()));
            }
        }
	}

	public static class WinComparator implements Comparator<Set<PvPEventPlayerObject>>
	{
		@Override
		public int compare(Set<PvPEventPlayerObject> o1, Set<PvPEventPlayerObject> o2)
		{
			return Integer.compare(getPointByTeam(o2), getPointByTeam(o1));
		}
	}

	private static int getPointByTeam(Set<PvPEventPlayerObject> players)
	{
		int points = 0;
		for(PvPEventPlayerObject member : players)
			points += member.getPoints();
		return points;
	}

	private void takeReward(Set<PvPEventPlayerObject> players, List<RewardObject> rewards)
	{
		for(PvPEventPlayerObject member : players)
		{
			if(member.getPoints() < _pvpEvent.getMinKillFromReward())
			{
				continue;
			}

			rewards.stream().filter(reward -> Rnd.chance(reward.getChance())).forEach(reward -> ItemFunctions.addItem(member.getPlayer(), reward.getItemId(), Rnd.get(reward.getMinCount(), reward.getMaxCount())));
		}
	}

//	public void takeRewardByTeamId(int teamId, List<RewardObject> rewards)
//	{
//		for(PvPEventPlayerObject member : _teamsList.get(teamId))
//		{
//			if(member.getPoints() < _pvpEvent.getMinKillFromReward())
//			{
//				continue;
//			}
//
//			rewards.stream().filter(reward -> Rnd.chance(reward.getChance())).forEach(reward -> ItemFunctions.addItem(member.getPlayer(), reward.getItemId(), Rnd.get(reward.getMinCount(), reward.getMaxCount())));
//		}
//	}

	public PvPEventPlayerObject getParticipant(Player player)
	{
		for(int i = 0; i < _teamsList.size(); i++)
		{
			for(PvPEventPlayerObject member : _teamsList.get(i))
			{
				if(member.getPlayer() == player)
					return member;
			}
		}
		return null;
	}
}