package l2s.gameserver.network.l2.s2c.custom;

import l2s.gameserver.network.l2.ServerPacketOpcodes;
import l2s.gameserver.network.l2.s2c.L2GameServerPacket;

/**
 * @author Bonux (bonuxq@gmail.com)
 * @date 04.01.2024
 **/
public abstract class ACustomServerPacket extends L2GameServerPacket {

	@Override
	protected ServerPacketOpcodes getOpcodes() {
		return ServerPacketOpcodes.ExDethroneServerInfo;
	}

	@Override
	protected final void writeImpl() {
		writeCustomImpl();
	}

	protected abstract void writeCustomImpl();
}
