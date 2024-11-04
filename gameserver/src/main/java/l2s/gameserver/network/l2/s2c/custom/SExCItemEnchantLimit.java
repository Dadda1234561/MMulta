package l2s.gameserver.network.l2.s2c.custom;

import l2s.gameserver.Config;
import l2s.gameserver.model.Player;

import java.util.Map;

/**
 * @author Bonux (bonuxq@gmail.com)
 * @date 10.05.2024
 **/
public class SExCItemEnchantLimit extends ACustomServerPacket {
	private final Map<Integer, Integer> map;

	public SExCItemEnchantLimit(Map<Integer, Integer> map) {
		this.map = map;
	}

	@Override
	public boolean canWrite(Player player) {
		return Config.SHOW_ITEM_ENCHANT_LIMITS && super.canWrite(player);
	}

	@Override
	protected void writeCustomImpl() {
		writeC(SExCustomOpcode.S_EX_C_ITEM_ENCHANT_LIMIT);
		writeD(map.size());
		for (Map.Entry<Integer, Integer> i : map.entrySet()) {
			writeD(i.getKey());
			writeC(i.getValue());
		}
	}
}
