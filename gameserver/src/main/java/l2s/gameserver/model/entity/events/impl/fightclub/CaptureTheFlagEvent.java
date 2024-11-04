package l2s.gameserver.model.entity.events.impl.fightclub;

import l2s.commons.collections.MultiValueSet;
import l2s.gameserver.Announcements;
import l2s.gameserver.geometry.Location;
import l2s.gameserver.model.Creature;
import l2s.gameserver.model.Player;
import l2s.gameserver.model.entity.events.fightclubmanager.FightClubPlayer;
import l2s.gameserver.model.entity.events.fightclubmanager.FightClubTeam;
import l2s.gameserver.model.entity.events.fightclubmanager.enums.EventState;
import l2s.gameserver.model.entity.events.fightclubmanager.enums.MessageType;
import l2s.gameserver.model.entity.events.impl.AbstractFightClub;
import l2s.gameserver.model.entity.events.objects.CTFCombatFlagObject;
import l2s.gameserver.model.instances.NpcInstance;
import l2s.gameserver.network.l2.components.CustomMessage;
import l2s.gameserver.network.l2.s2c.ExShowScreenMessage;
import l2s.gameserver.network.l2.s2c.RelationChangedPacket;

import java.util.concurrent.TimeUnit;

public class CaptureTheFlagEvent extends AbstractFightClub
{
	private CaptureFlagTeam[] _flagTeams;
	private final int _badgesCaptureFlag;

	public CaptureTheFlagEvent(MultiValueSet<String> set)
	{
		super(set);
		_badgesCaptureFlag = set.getInteger("badgesCaptureFlag");
	}

	@Override
	public void onKilled(Creature actor, Creature victim)
	{
		try
		{
			if ((actor != null) && (actor.isPlayable()))
			{
				FightClubPlayer realActor = getFightClubPlayer(actor.getPlayer());
				if ((victim.isPlayer()) && (realActor != null))
				{
					realActor.increaseKills(true);
					updatePlayerScore(realActor);
					sendMessageToPlayer(realActor, MessageType.GM, new CustomMessage("l2s.gameserver.model.entity.events.impl.fightclub.ctf.enemyKilled").addString(victim.getName()));
				}
				actor.getPlayer().sendUserInfo();


				if (realActor != null && victim.isPlayer()) {
					FightClubPlayer realVictim = getFightClubPlayer(victim);
					realVictim.increaseDeaths();
					sendMessageToPlayer(realVictim, MessageType.GM, new CustomMessage("l2s.gameserver.model.entity.events.impl.fightclub.ctf.killedBy").addString(actor.getName()));
					victim.getPlayer().sendUserInfo();

					CaptureFlagTeam actorTeam = getTeam(realActor.getTeam());
					CaptureFlagTeam victimTeam = getTeam(realVictim.getTeam());

					CaptureFlagHolder victimFlagHolder = victimTeam._thisTeamHolder;
					if (victimFlagHolder != null) {
						boolean isHoldingAFlag = victimFlagHolder.playerHolding != null && victimFlagHolder.playerHolding.equals(realVictim);
						CTFCombatFlagObject flagInfo = victimTeam._thisTeamHolder.enemyFlagHoldByPlayer;
						if (isHoldingAFlag && flagInfo != null) {
							// despawn flag in player's hands
							flagInfo.despawnObject(this, getReflection());
							// reset this team holder
							victimTeam._thisTeamHolder = null;
							// spawn new flag
							returnFlag(actorTeam);
						}
					}
				}
			}

			super.onKilled(actor, victim);
		}
		catch (Exception e)
		{
			_log.error("Error on CaptureTheFlag OnKilled!", e);
		}
	}

	private void returnFlag(CaptureFlagTeam forTeam) {
		// delete flag if any
		if (forTeam._flag != null) {
			forTeam._flag.deleteMe();
		}
		// delete holder if any
		if (forTeam._holder != null) {
			forTeam._holder.deleteMe();
			// set new holder
			forTeam._holder = spawnNpc(getFlagHolderId(), getFlagHolderSpawnLocation(forTeam._team), -3, true);
		}

		spawnFlag(forTeam);
	}

	@Override
	public void startEvent()
	{
		try
		{
			super.startEvent();
			_flagTeams = new CaptureFlagTeam[getTeams().size()];
			int i = 0;
			for (FightClubTeam team : getTeams())
			{
				CaptureFlagTeam flagTeam = new CaptureFlagTeam();
				flagTeam._team = team;
				flagTeam._holder = spawnNpc(getFlagHolderId(), getFlagHolderSpawnLocation(team), -3, true);
				spawnFlag(flagTeam);
				_flagTeams[i] = flagTeam;
				i++;
			}
		}
		catch (Exception e)
		{
			_log.error("Error on CaptureTheFlag startEvent!", e);
		}
	}

	@Override
	public void stopEvent(boolean force)
	{
		try
		{
			super.stopEvent(force);
			if (_flagTeams == null)
				return;
			for (CaptureFlagTeam iFlagTeam : _flagTeams)
			{
				if (iFlagTeam._flag != null)
					iFlagTeam._flag.deleteMe();
				if (iFlagTeam._holder != null)
					iFlagTeam._holder.deleteMe();
				if ((iFlagTeam._thisTeamHolder != null) && (iFlagTeam._thisTeamHolder.enemyFlagHoldByPlayer != null))
				{
					iFlagTeam._thisTeamHolder.enemyFlagHoldByPlayer.despawnObject(this, getReflection());
				}
			}
			_flagTeams = null;
		}
		catch (Exception e)
		{
			_log.error("Error on CaptureTheFlag stopEvent!", e);
		}
	}

	@Override
	protected long getWarRelation() {
		long relation = 0;

		relation |= RelationChangedPacket.RelationChangedType.IN_BATTLE_FIELD.getRelationState();
		relation |= RelationChangedPacket.RelationChangedType.GUILTY.getRelationState();
		relation |= RelationChangedPacket.RelationChangedType.ENEMY_IN_PVP_MATCH.getRelationState();

		return  relation;
	}

	public boolean tryToTakeFlag(Player player, NpcInstance flag)
	{
		try
		{
			FightClubPlayer fPlayer = getFightClubPlayer(player);
			if (fPlayer == null)
			{
				return false;
			}
			if (getState() != EventState.STARTED)
			{
				return false;
			}
			CaptureFlagTeam flagTeam = null;
			for (CaptureFlagTeam iFlagTeam : _flagTeams) {
				if ((iFlagTeam._flag != null) && (iFlagTeam._flag.equals(flag))) {
					flagTeam = iFlagTeam;
					break;
				}
			}

			if (flagTeam != null && fPlayer.getTeam().equals(flagTeam._team))
			{
				giveFlagBack(fPlayer, flagTeam);
				return false;
			}
			else
			{
				return getEnemyFlag(fPlayer, flagTeam);
			}
		}
		catch (Exception e)
		{
			_log.error("Error on CaptureTheFlag tryToTakeFlag!", e);
			return false;
		}
	}

	public void talkedWithFlagHolder(Player player, NpcInstance holder)
	{
		try
		{
			FightClubPlayer fPlayer = getFightClubPlayer(player);
			if (fPlayer == null)
			{
				return;
			}
			if (getState() != EventState.STARTED)
			{
				return;
			}
			CaptureFlagTeam flagTeam = null;
			for (CaptureFlagTeam iFlagTeam : _flagTeams)
			{
				if ((iFlagTeam._holder != null) && (iFlagTeam._holder.equals(holder)))
				{
					flagTeam = iFlagTeam;
				}
			}
			if (flagTeam != null && fPlayer.getTeam().equals(flagTeam._team))
			{
				giveFlagBack(fPlayer, flagTeam);
			}
		}
		catch (Exception e)
		{
			_log.error("Error on CaptureTheFlag talkedWithFlagHolder!", e);
		}
	}

	private synchronized boolean getEnemyFlag(FightClubPlayer fPlayer, CaptureFlagTeam enemyFlagTeam)
	{
		try
		{
			final CaptureFlagTeam playerTeam = getTeam(fPlayer.getTeam());
			final Player player = fPlayer.getPlayer();

			if (enemyFlagTeam._flag != null)
			{
				enemyFlagTeam._flag.deleteMe();
				enemyFlagTeam._flag = null;

				CTFCombatFlagObject flag = new CTFCombatFlagObject();
				flag.spawnObject(this, getReflection());
				player.getInventory().addItem(flag.getItem());
				player.getInventory().equipItem(flag.getItem());

				CaptureFlagHolder holder = new CaptureFlagHolder();
				holder.enemyFlagHoldByPlayer = flag;
				holder.playerHolding = fPlayer;
				holder.teamFlagOwner = playerTeam._team;
				playerTeam._thisTeamHolder = holder;

				/* Спавним холдер вместо флага */
				if (enemyFlagTeam._holder != null)
				{
					enemyFlagTeam._holder.setReflection(getReflection());
					enemyFlagTeam._holder.spawnMe(enemyFlagTeam._holder.getSpawnedLoc());
				}


				sendMessageToTeam(enemyFlagTeam._team, MessageType.CRITICAL, new CustomMessage("l2s.gameserver.model.entity.events.impl.fightclub.ctf.flagStolenToEnemy")); // "Someone stole your Flag!
				sendMessageToTeam(playerTeam._team, MessageType.CRITICAL, new CustomMessage("l2s.gameserver.model.entity.events.impl.fightclub.ctf.flagStolenToTeam").addString(fPlayer.getPlayer().getName()).addString(enemyFlagTeam._team.getName()));

				return true;
			}
			return false;
		}
		catch (Exception e)
		{
			_log.error("Error on CaptureTheFlag talkedWithFlagHolder!", e);
			return false;
		}
	}

	private CaptureFlagTeam getTeam(FightClubTeam team)
	{
		if (team == null)
		{
			return null;
		}
		try
		{
			for (CaptureFlagTeam iFlagTeam : _flagTeams)
			{
				if ((iFlagTeam._team != null) && (iFlagTeam._team.equals(team)))
				{
					return iFlagTeam;
				}
			}
			return null;
		}
		catch (Exception e)
		{
			_log.error("Error on CaptureTheFlag getTeam!", e);
			return null;
		}
	}

	private synchronized void giveFlagBack(FightClubPlayer fPlayer, CaptureFlagTeam flagTeam)
	{
		try
		{
			CaptureFlagHolder holdingTeam = flagTeam._thisTeamHolder;
			if ((holdingTeam != null) && (fPlayer.equals(holdingTeam.playerHolding)))
			{
				holdingTeam.enemyFlagHoldByPlayer.despawnObject(this, getReflection());

				/* Удаляем холдер и спавним флаг у владельцев флага */
				for (CaptureFlagTeam team : _flagTeams) {
					if (!team.equals(flagTeam)) {
						if (team._holder != null) {
							team._holder.deleteMe();
							team._holder = null;
						}
						team._holder = spawnNpc(getFlagHolderId(), getFlagHolderSpawnLocation(team._team), -3, true);
						spawnFlag(team);
						break;
					}
				}

				flagTeam._thisTeamHolder = null;
				flagTeam._team.incScore(1);
				updateScreenScores();

				for (CaptureFlagTeam team : _flagTeams) {
					if (!team.equals(flagTeam)) {
						sendMessageToTeam(team._team, MessageType.CRITICAL, new CustomMessage("l2s.gameserver.model.entity.events.impl.fightclub.ctf.teamGainedScore").addString(flagTeam._team.getName()));
					}
				}
				sendMessageToTeam(flagTeam._team, MessageType.CRITICAL, new CustomMessage("l2s.gameserver.model.entity.events.impl.fightclub.ctf.youGainedScore"));
				fPlayer.increaseEventSpecificScore("capture");
			}
		}
		catch (Exception e)
		{
			_log.error("Error on CaptureTheFlag giveFlagBack!", e);
		}
	}

	private int getFlagNpcId(FightClubTeam team)
	{
		return team.getIndex() == 1 ? 35423 : 35426;
	}

	private int getFlagHolderId()
	{
		return 35422;
	}

	private Location getFlagHolderSpawnLocation(FightClubTeam team)
	{
		return getMap().getKeyLocations()[(team.getIndex() - 1)];
	}

	private void spawnFlag(CaptureFlagTeam flagTeam)
	{
		try
		{
			NpcInstance flag = spawnNpc(getFlagNpcId(flagTeam._team), getFlagHolderSpawnLocation(flagTeam._team), -3, true);
			flag.setName(flagTeam._team.getName() + " Flag");
			flag.setReflection(getReflection());
			flag.spawnMe(flag.getSpawnedLoc());
			flagTeam._flag = flag;
		}
		catch (Exception e)
		{
			_log.error("Error on CaptureTheFlag spawnFlag!", e);
		}
	}

	@Override
	public String getVisibleTitle(Player player, String currentTitle, boolean toMe)
	{
		final FightClubPlayer fPlayer = getFightClubPlayer(player);

		if (fPlayer == null)
		{
			return currentTitle;
		}
		return "Kills: " + fPlayer.getKills(true) + " | Deaths: " + fPlayer.getDeaths();
	}

	@Override
	public boolean loseBuffsOnDeath(Player player) {
		return false;
	}

	@Override
	public boolean removeBuffsOnEnter() {
		return false;
	}

	@Override
	public boolean removeBuffsOnDeath() {
		return false;
	}

	private class CaptureFlagHolder
	{
		private FightClubPlayer playerHolding;
		private CTFCombatFlagObject enemyFlagHoldByPlayer;
		private FightClubTeam teamFlagOwner;

		private CaptureFlagHolder()
		{
		}
	}

	private class CaptureFlagTeam
	{
		private FightClubTeam _team;
		private NpcInstance _holder;
		private NpcInstance _flag;
		private CaptureTheFlagEvent.CaptureFlagHolder _thisTeamHolder;

		private CaptureFlagTeam()
		{
		}
	}

	@Override
	public boolean giveKarma() {
		return false;
	}

	@Override
	public boolean startFlagTask() {
		return false;
	}

	@Override
	protected void teleportRegisteredPlayers()
	{
		super.teleportRegisteredPlayers();
		for (FightClubPlayer fPlayer : getPlayers(FIGHTING_PLAYERS)) {
			Player player = fPlayer.getPlayer();
			if (player != null) {
				// Daily event handler
				player.getListeners().onParticipateInEvent("CtF", false);
			}
		}
	}
}
