package l2s.gameserver.network.l2.s2c.pledge;

import l2s.gameserver.network.l2.s2c.L2GameServerPacket;

/**
 * @author Bonux (bonuxq@gmail.com)
 * @date 25.09.2019
 **/
public class ExPledgeItemBuy extends L2GameServerPacket {
	public static final ExPledgeItemBuy SUCCESS = new ExPledgeItemBuy(0);
	public static final ExPledgeItemBuy FAIL = new ExPledgeItemBuy(1);
	public static final ExPledgeItemBuy NOT_AUTHORIZED = new ExPledgeItemBuy(2);
	public static final ExPledgeItemBuy REQUIREMENTS_NOT_MET = new ExPledgeItemBuy(3);

	private final int result;

	private ExPledgeItemBuy(int result) {
		this.result = result;
	}

	@Override
	protected void writeImpl() {
		writeD(result); // 0 success, 2 not authorized, 3 trade requirements not met
	}
}