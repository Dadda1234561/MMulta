package l2s.gameserver.network.l2.s2c.homunculus;

import l2s.gameserver.model.Player;
import l2s.gameserver.model.actor.variables.PlayerVariables;
import l2s.gameserver.network.l2.s2c.L2GameServerPacket;

/**
 * @author nexvill
 */
public class ExHomunculusPointInfo extends L2GameServerPacket
{
	private final Player _player;

	public ExHomunculusPointInfo(Player player)
	{
		_player = player;
	}

	@Override
	protected final void writeImpl()
	{
		int nEnchantPoint = _player.getVarInt(PlayerVariables.HOMUNCULUS_UPGRADE_POINTS, 0);
		int nNPCKillPoint = _player.getVarInt(PlayerVariables.HOMUNCULUS_KILLED_MOBS, 0);
		int nInsertNPCKillPoint = _player.getVarInt(PlayerVariables.HOMUNCULUS_USED_KILL_CONVERT, 0);
		int nInitNPCKillPoint = _player.getVarInt(PlayerVariables.HOMUNCULUS_USED_RESET_KILLS, 0);
		int nVPPoint = _player.getVarInt(PlayerVariables.HOMUNCULUS_USED_VP_POINTS, 0);
		int nInsertVPPoint = _player.getVarInt(PlayerVariables.HOMUNCULUS_USED_VP_CONVERT, 0);
		int nInitVPPoint = _player.getVarInt(PlayerVariables.HOMUNCULUS_USED_RESET_VP, 0);
		int nActivateSlotIndex = _player.getHomunculusList().size() >= 3 ? _player.getHomunculusList().size() : -1;

		writeD(nEnchantPoint); // points
		writeD(nNPCKillPoint); // killed mobs
		writeD(nInsertNPCKillPoint); // consumed basic kill points
		writeD(nInitNPCKillPoint); // consumed reset kill points?
		writeD(nVPPoint); // vp points
		writeD(nInsertVPPoint); // consumed basic vp points
		writeD(nInitVPPoint); // consumed reset vp points
		writeD(nActivateSlotIndex);
	}
}