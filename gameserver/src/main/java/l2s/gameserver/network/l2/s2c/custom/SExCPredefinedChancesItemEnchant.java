package l2s.gameserver.network.l2.s2c.custom;

import l2s.gameserver.Config;
import l2s.gameserver.model.Player;

/**
 * @author Bonux (bonuxq@gmail.com)
 * @date 10.05.2024
 **/
public class SExCPredefinedChancesItemEnchant extends ACustomServerPacket {
	private final int nCurrent;
	private final int nMax;

	public SExCPredefinedChancesItemEnchant(int nCurrent, int nMax) {
		this.nCurrent = nCurrent;
		this.nMax = nMax;
	}

	@Override
	public boolean canWrite(Player player) {
		return Config.ENABLE_GUARANTEED_ITEM_ENCHANT && super.canWrite(player);
	}

	@Override
	protected void writeCustomImpl() {
		writeC(SExCustomOpcode.S_EX_C_PREDEFINED_CHANCES_ITEM_ENCHANT);
		writeD(nCurrent);
		writeD(nMax);
	}
}
