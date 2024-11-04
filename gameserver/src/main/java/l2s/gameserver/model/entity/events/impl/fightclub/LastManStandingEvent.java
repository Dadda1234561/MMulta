package l2s.gameserver.model.entity.events.impl.fightclub;

import l2s.commons.collections.MultiValueSet;
import l2s.gameserver.ThreadPoolManager;
import l2s.gameserver.model.Creature;
import l2s.gameserver.model.Player;
import l2s.gameserver.model.Zone;
import l2s.gameserver.model.entity.events.fightclubmanager.FightClubEventManager;
import l2s.gameserver.model.entity.events.fightclubmanager.FightClubPlayer;
import l2s.gameserver.model.entity.events.fightclubmanager.enums.EventState;
import l2s.gameserver.model.entity.events.fightclubmanager.enums.MessageType;
import l2s.gameserver.model.entity.events.impl.AbstractFightClub;

public class LastManStandingEvent extends AbstractFightClub
{
	private FightClubPlayer _winner;

	public LastManStandingEvent(MultiValueSet<String> set)
	{
		super(set);
	}

	public void onKilled(Creature actor, Creature victim)
	{
		if (actor != null && actor.isPlayable())
		{
			FightClubPlayer fActor = getFightClubPlayer(actor.getPlayer());
			if (victim.isPlayer())
			{
				fActor.increaseKills(true);
				updatePlayerScore(fActor);
				sendMessageToPlayer(fActor, MessageType.GM, "You have killed " + victim.getName());
			}
			actor.getPlayer().sendUserInfo();
		}

		if (victim.isPlayer())
		{
			FightClubPlayer fVictim = getFightClubPlayer(victim);
			fVictim.increaseDeaths();
			if (actor != null)
			{
				sendMessageToPlayer(fVictim, MessageType.GM, "You have been killed by " + actor.getName());
			}
			victim.getPlayer().sendUserInfo();
			checkRoundOver();
		}

		super.onKilled(actor, victim);
	}

	@Override
	public void startEvent()
	{
		super.startEvent();
		ThreadPoolManager.getInstance().schedule(new InactivityCheck(), 60000L);
	}

	public void startRound()
	{
		super.startRound();
		checkRoundOver();
	}

	public boolean leaveEvent(Player player, boolean teleportTown)
	{
		boolean result = super.leaveEvent(player, teleportTown);
		if (result)
		{
			checkRoundOver();
		}
		return result;
	}

	private boolean checkRoundOver()
	{
		if (getState() != EventState.STARTED)
		{
			return true;
		}

		int alivePlayers = 0;
		FightClubPlayer aliveFPlayer = null;

		for (final FightClubPlayer iFPlayer : getPlayers(FIGHTING_PLAYERS))
		{
			if (isPlayerActive(iFPlayer.getPlayer()))
			{
				alivePlayers++;
				aliveFPlayer = iFPlayer;
			}
			if (isPlayerAlive(iFPlayer.getPlayer()))
			{
				alivePlayers++;
				aliveFPlayer = iFPlayer;
			}
		}

		if (alivePlayers <= 1)
		{
			if (alivePlayers == 1)
			{
				_winner = aliveFPlayer;
				if (_winner != null)
				{
					aliveFPlayer.increaseScore(1);
					announceWinnerPlayer(false, aliveFPlayer);
				}
				updateScreenScores();
				FightClubEventManager.getInstance().sendToAllMsg(this, _winner.getPlayer().getName() + " Won Event!");
			}
			setState(EventState.OVER);
			ThreadPoolManager.getInstance().schedule(new Runnable()
			{
				@Override
				public void run()
				{
					endRound();
				}
			}, 5000L);
			return true;
		}
		return false;
	}

	private boolean isPlayerAlive(Player player)
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
			if (zone.checkIfInZone(player))
			{
				insideZone = true;
			}
		}
		return insideZone;
	}

	protected boolean inScreenShowBeScoreNotKills()
	{
		return false;
	}

	protected int getRewardForWinningTeam(FightClubPlayer fPlayer, boolean atLeast1Kill)
	{
		if (fPlayer.equals(_winner))
		{
			return (int) _badgeWin;
		}
		return super.getRewardForWinningTeam(fPlayer, true);
	}

	public String getVisibleTitle(Player player, String currentTitle, boolean toMe)
	{
		final FightClubPlayer realPlayer = getFightClubPlayer(player);
		if (realPlayer == null)
		{
			return currentTitle;
		}

		return "Kills: " + realPlayer.getKills(true);
	}

	private class InactivityCheck implements Runnable
	{
		@Override
		public void run()
		{
			if (getState() == EventState.NOT_ACTIVE)
			{
				return;
			}

			checkRoundOver();
			ThreadPoolManager.getInstance().schedule(this, 60000L);
		}
	}

	@Override
	public boolean removeBuffsOnEnter() {
		return false;
	}

	@Override
	public boolean removeBuffsOnDeath() {
		return false;
	}

	@Override
	public boolean canUseBuffer(Player player, boolean heal) {
		return true;
	}

	@Override
	public boolean giveKarma() {
		return false;
	}

	@Override
	public boolean startFlagTask() {
		return false;
	}
}