package l2s.gameserver.network.l2.s2c;

import java.util.List;

/**
 * @author Bonux (bonuxq@gmail.com)
 * @date 09.09.2019
 * TODO: Fix packet structure.
 **/
public class ExTryEnchantArtifactResult extends L2GameServerPacket {
	public static final int SUCCESS = 0;
	public static final int FAIL = 1;
	public static final int ERROR = 2;

	public static final ExTryEnchantArtifactResult ERROR_PACKET = new ExTryEnchantArtifactResult(ERROR, 0);

	private final int state;
	private final int enchant;

	public ExTryEnchantArtifactResult(int state, int enchant) {
		this.state = state;
		this.enchant = enchant;
	}

	@Override
	protected final void writeImpl() {
		writeD(state);
		writeD(enchant);
		writeD(0);
		writeD(0);
		writeD(0);
	}
}
