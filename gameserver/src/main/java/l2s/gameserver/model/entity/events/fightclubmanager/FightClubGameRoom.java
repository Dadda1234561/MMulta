package l2s.gameserver.model.entity.events.fightclubmanager;

import java.util.List;
import java.util.concurrent.CopyOnWriteArrayList;

import l2s.commons.util.Rnd;
import l2s.gameserver.data.xml.holder.FightClubMapHolder;
import l2s.gameserver.listener.actor.player.OnPlayerExitListener;
import l2s.gameserver.model.Player;
import l2s.gameserver.model.base.ClassId;
import l2s.gameserver.model.entity.events.fightclubmanager.enums.PlayerClass;
import l2s.gameserver.model.entity.events.impl.AbstractFightClub;
import l2s.gameserver.utils.Util;

public class FightClubGameRoom
{
	private class LeaveListener implements OnPlayerExitListener
	{
		@Override
		public void onPlayerExit(Player player)
		{
			leaveRoom(player);
		}
	}

	private final FightClubMap _map;
	private AbstractFightClub _event;
	private final int _roomMaxPlayers;
	private final int _teamsCount;
	private List<Player> _players;
	private LeaveListener _leaveListener = new LeaveListener();

	public FightClubGameRoom(AbstractFightClub event)
	{
		_event = event;
		_players = new CopyOnWriteArrayList<>();
		String eventName = Util.getChangedEventName(event);
		_map = Rnd.get(FightClubMapHolder.getInstance().getMapsForEvent(eventName));
		_roomMaxPlayers = _map.getMaxAllPlayers();

		if (event.isTeamed())
		{
			_teamsCount = Rnd.get(_map.getTeamCount()); // += ?
		}
		else
		{
			_teamsCount = 0;
		}
	}

	public void leaveRoom(Player player)
	{
		_players.remove(player);
		player.removeListener(_leaveListener);
	}

	public int getMaxPlayers()
	{
		return _roomMaxPlayers;
	}

	public int getTeamsCount()
	{
		return _teamsCount;
	}

	public int getSlotsLeft()
	{
		return getMaxPlayers() - getPlayersCount();
	}

	public AbstractFightClub getGame()
	{
		return _event;
	}

	public int getPlayersCount()
	{
		return _players.size();
	}

	public FightClubMap getMap()
	{
		return _map;
	}

	public List<Player> getAllPlayers()
	{
		return _players;
	}

	synchronized void addAlonePlayer(Player player)
	{
		player.setFightClubGameRoom(this);
		addPlayerToTeam(player);
	}

	public boolean containsPlayer(Player player)
	{
		return _players.contains(player);
	}

	private void addPlayerToTeam(Player player)
	{
		_players.add(player);
	}

	public static PlayerClass getPlayerClassGroup(Player player)
	{
		PlayerClass classType = null;
		for (PlayerClass iClassType : PlayerClass.values())
		{
			for (ClassId id : iClassType.getClasses())
			{
				// is same class or parent for awaken
				if (id == player.getClassId() || (player.getClassId().isAwaked() && player.getClassId().getBaseAwakeParent(id) == id))
				{
					classType = iClassType;
				}
			}
		}
		return classType;
	}
}