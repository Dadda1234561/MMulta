package l2s.gameserver.network.l2.c2s;

import l2s.gameserver.instancemanager.CommissionManager;
import l2s.gameserver.model.Player;
import l2s.gameserver.network.l2.components.IBroadcastPacket;
import l2s.gameserver.network.l2.components.SystemMsg;
import l2s.gameserver.network.l2.s2c.ExResponseCommissionBuyItem;

public class RequestCommissionBuyItem extends L2GameClientPacket
{
	public long _bidId;
	public int _unk2;

	@Override
	protected boolean readImpl()
	{
		_bidId = readQ();
		_unk2 = readD();
		return true;
	}

	@Override
	protected void runImpl()
	{
		Player activeChar = getClient().getActiveChar();
		if(activeChar == null)
			return;

		if (activeChar.isActionsDisabled()) {
			activeChar.sendActionFailed();
			return;
		}

		if (activeChar.isInStoreMode()) {
			activeChar.sendPacket(SystemMsg.WHILE_OPERATING_A_PRIVATE_STORE_OR_WORKSHOP_YOU_CANNOT_DISCARD_DESTROY_OR_TRADE_AN_ITEM);
			return;
		}

		if (activeChar.isInTrade()) {
			activeChar.sendActionFailed();
			return;
		}

		if (activeChar.isFishing()) {
			activeChar.sendPacket(SystemMsg.YOU_CANNOT_DO_THAT_WHILE_FISHING_2);
			return;
		}

		if (activeChar.isInTrainingCamp()) {
			activeChar.sendPacket(SystemMsg.YOU_CANNOT_TAKE_OTHER_ACTION_WHILE_ENTERING_THE_TRAINING_CAMP);
			return;
		}

		if (!activeChar.getPlayerAccess().UseTrade) {
			activeChar.sendPacket(SystemMsg.SOME_LINEAGE_II_FEATURES_HAVE_BEEN_LIMITED_FOR_FREE_TRIALS_____);
			return;
		}

		IBroadcastPacket msg = CommissionManager.getInstance().buyItem(activeChar, (int) _bidId);
		if(msg != null)
		{
			activeChar.sendPacket(msg);
			activeChar.sendPacket(ExResponseCommissionBuyItem.FAILED);
			return;
		}
		activeChar.sendActionFailed();
	}
}
