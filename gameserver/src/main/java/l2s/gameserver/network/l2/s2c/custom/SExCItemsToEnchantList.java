package l2s.gameserver.network.l2.s2c.custom;


import java.util.List;

/**
 * @author Bonux (bonuxq@gmail.com)
 * @date 15.07.2022
 **/
public class SExCItemsToEnchantList extends ACustomServerPacket {
	private final List<Integer> vItemList;

	public SExCItemsToEnchantList(List<Integer> vItemList) {
		this.vItemList = vItemList;
	}

	@Override
	protected void writeCustomImpl() {
		writeC(SExCustomOpcode.S_EX_C_ITEMS_TO_ENCHANT_LIST);
		writeD(vItemList.size());
		for (int itemObjectId : vItemList) {
			writeD(itemObjectId);
		}
	}
}
