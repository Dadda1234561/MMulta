package l2s.gameserver.network.l2.c2s;

import java.util.ArrayList;
import java.util.Collection;
import java.util.List;

import l2s.commons.util.Rnd;
import l2s.gameserver.listener.Acts;
import l2s.gameserver.model.Player;
import l2s.gameserver.model.items.ItemInstance;
import l2s.gameserver.network.l2.components.SystemMsg;
import l2s.gameserver.templates.item.data.ChancedItemData;
import l2s.gameserver.templates.item.data.ItemData;
import l2s.gameserver.templates.item.support.CrystallizationInfo;
import l2s.gameserver.utils.ItemFunctions;
import l2s.gameserver.utils.Log;

public class RequestCrystallizeItem extends L2GameClientPacket
{
	private int _objectId;
	private long _count;

	@Override
	protected boolean readImpl()
	{
		_objectId = readD();
		_count = readQ();
		return true;
	}

	@Override
	protected void runImpl()
	{
		Player activeChar = getClient().getActiveChar();

		if(activeChar == null)
			return;

		ItemInstance item = activeChar.getInventory().getItemByObjectId(_objectId);
		if(item == null)
		{
			activeChar.sendActionFailed();
			return;
		}

		if(!item.canBeCrystallized(activeChar))
		{
			// На всякий пожарный..
			activeChar.sendPacket(SystemMsg.THIS_ITEM_CANNOT_BE_CRYSTALLIZED);
			return;
		}

		Log.LogItem(activeChar, Log.Crystalize, item);

		if(!activeChar.getInventory().destroyItemByObjectId(_objectId, _count))
		{
			activeChar.sendActionFailed();
			return;
		}

		activeChar.sendPacket(SystemMsg.THE_ITEM_HAS_BEEN_SUCCESSFULLY_CRYSTALLIZED);

		List<ItemData> crystallizeResult = new ArrayList<>();

		int crystalId = item.getGrade().getCrystalId();
		int crystalCount = item.getCrystalCountOnCrystallize();
		if(crystalId > 0 && crystalCount > 0)
			crystallizeResult.add(new ItemData(crystalId, crystalCount));

		CrystallizationInfo info = item.getTemplate().getCrystallizationInfo();
		if(info != null)
		{
			Collection<ChancedItemData> items = info.getItems();
			for(ChancedItemData i : items)
			{
				if(Rnd.chance(i.getChance()))
					crystallizeResult.add(new ItemData(i.getId(), i.getCount()));
			}
		}
		crystallizeResult.forEach((i) -> ItemFunctions.addItem(activeChar, i.getId(), i.getCount(), true));
		activeChar.sendChanges();
		activeChar.getListeners().onAct(Acts.CRYSTALLIZE, item, crystallizeResult);
	}
}