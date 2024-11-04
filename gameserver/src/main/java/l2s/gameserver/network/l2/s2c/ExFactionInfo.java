package l2s.gameserver.network.l2.s2c;

import java.util.Collection;

import l2s.gameserver.dao.CharacterFactionDAO;
import l2s.gameserver.model.GameObjectsStorage;
import l2s.gameserver.model.Player;
import l2s.gameserver.model.actor.instances.player.Faction;
import l2s.gameserver.model.base.FactionType;

/**
 * @author Bonux
**/
public class ExFactionInfo extends L2GameServerPacket
{
	private final int _playerId;
	private final int _action;
	private final Collection<Faction> factions;

	public ExFactionInfo(int playerId, int action)
	{
		_playerId = playerId;
		_action = action;

		Player player = GameObjectsStorage.getPlayer(playerId);
		if(player != null)
			factions = player.getFactionList().valueCollection();
		else
			factions = CharacterFactionDAO.getInstance().restore(playerId);
	}

	@Override
	protected void writeImpl()
	{
		writeD(_playerId); // Player ID
		writeC(_action);
		writeD(factions.size()); // Factions count
		factions.forEach(faction ->
		{
			writeC(faction.getType().ordinal()); // Faction ID
			writeH(faction.getLevel()); // Faction level
			writeCutF(faction.getPercentForNextLevel()); // Progress to next level (%)
		});
	}
}