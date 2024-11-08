package l2s.gameserver.network.l2.c2s;

import l2s.gameserver.instancemanager.CommissionManager;
import l2s.gameserver.model.Player;
import l2s.gameserver.network.l2.components.IBroadcastPacket;
import l2s.gameserver.network.l2.components.SystemMsg;
import l2s.gameserver.network.l2.s2c.ExResponseCommissionItemList;

public class RequestCommissionDelete extends L2GameClientPacket
{
	public long _bidId;
	public int _unk2;
	public int _unk3;

	@Override
	protected boolean readImpl()
	{
		_bidId = readQ();
		_unk2 = readD();
		_unk3 = readD();
		return true;
	}

	@Override
	protected void runImpl()
	{
		Player activeChar = getClient().getActiveChar();
		if(activeChar == null)
			return;

		IBroadcastPacket msg = CommissionManager.getInstance().unregisterItem(activeChar, (int) _bidId);
		if(msg != null)
		{
			activeChar.sendPacket(msg);
			return;
		}
		activeChar.sendPacket(new ExResponseCommissionItemList(1, activeChar));
		activeChar.sendPacket(new ExResponseCommissionItemList(2, activeChar));
		CommissionManager.getInstance().sendMyCommissionList(activeChar);
		activeChar.sendPacket(SystemMsg.CANCELLATION_OF_SALE_FOR_THE_ITEM_IS_SUCCESSFUL);
	}
}
