package l2s.gameserver.network.l2.s2c;

import l2s.gameserver.data.xml.holder.InstantZoneHolder;
import l2s.gameserver.model.EpicBossState;
import l2s.gameserver.model.EpicBossState.State;
import l2s.gameserver.model.Player;
import org.napile.primitive.sets.IntSet;

import l2s.gameserver.instancemanager.RaidBossSpawnManager;

/**
 * @author Bonux
 **/
public class ExRaidBossSpawnInfo extends L2GameServerPacket
{
	private final IntSet _aliveBosses;
	private final int[] _npcIds;
	private final Player _player;

	public ExRaidBossSpawnInfo(Player player, IntSet npcIds)
	{
		_aliveBosses = RaidBossSpawnManager.getInstance().getAliveRaidBosees();
		_npcIds = npcIds.toArray();
		_player = player;
	}

	public ExRaidBossSpawnInfo(Player player)
	{
		_aliveBosses = RaidBossSpawnManager.getInstance().getAliveRaidBosees();
		_npcIds = _aliveBosses.toArray();
		_player = player;
	}

	@Override
	protected final void writeImpl()
	{
		writeD(1); // nBossRespawnFactor
		writeD(_npcIds.length);
		for (int npcId : _npcIds)
		{
			writeNpcSpawnInfo(npcId);
		}
	}

	private int getNpcStatus(int npcId)
	{
		EpicBossState epicBossState = null;
        switch (npcId)
        {
            case 29020:
            case 29028:
            case 29068:
                epicBossState = RaidBossSpawnManager.getInstance().getEpicState(npcId);
                return epicBossState.getState().equals(State.NOTSPAWN) || epicBossState.getState().equals(State.ALIVE) ? 1 : 0;
			case 29305:
			case 26124:
			case 29233:
				epicBossState = RaidBossSpawnManager.getInstance().getEpicState(npcId);
				return epicBossState.getState().equals(State.ALIVE) ? 1 : 0;
            default:
                return _aliveBosses.contains(npcId) ? 1 : 0;
        }
	}

	private void writeNpcSpawnInfo(int npcId)
	{
		writeD(npcId);
		writeD(getNpcStatus(npcId));
		writeD(0);
	}
}