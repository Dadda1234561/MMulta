package l2s.gameserver.network.l2.c2s;

import l2s.gameserver.model.Player;
import l2s.gameserver.model.actor.instances.player.ShortCut;
import l2s.gameserver.network.l2.components.IBroadcastPacket;
import l2s.gameserver.network.l2.s2c.ShortCutRegisterPacket;

public class RequestShortCutReg extends L2GameClientPacket
{
	private ShortCut.ShortCutType _type;
	private int _id, _slot, _page, _lvl, _characterType;

	@Override
	protected boolean readImpl()
	{
		try
		{
			_type = ShortCut.ShortCutType.VALUES[readD()];
		}
		catch (Exception e)
		{
			return false;
		}
		int slot = readD();
		int unk0 = readC();
		_id = readD();
		_lvl = readD();
		_characterType = readD();

		if (_buf.remaining() >= 8)
		{
			int unk1 = readD(); // UNK
			int unk2 = readD(); // UNK
		}

		_slot = slot % 12;
		_page = slot / 12;
		return true;
	}

	@Override
	protected void runImpl()
	{
		Player activeChar = getClient().getActiveChar();
		if(activeChar == null)
			return;

		if(_page < 0 || _page > ShortCut.PAGE_MAX)
		{
			activeChar.sendActionFailed();
			return;
		}

		if (_type.equals(ShortCut.ShortCutType.TPBOOKMARK) && !activeChar.getBookMarkList().contains(_id)) {
			activeChar.sendActionFailed();
			return;
		}

		IBroadcastPacket msg = activeChar.getAutoShortCuts().canRegShortCut(_slot, _page, _type, _id);
		if(msg != null)
		{
			activeChar.sendPacket(msg);
			return;
		}

		boolean isReplaced = false;
		boolean isToggled = false;
		for (ShortCut allShortCut : activeChar.getAllShortCuts())
		{
			if (allShortCut.getType() == _type && allShortCut.getId() == _id)
			{
				isReplaced = true;
				isToggled = allShortCut.isToggled();
				break;
			}
		}

		ShortCut shortCut = new ShortCut(_slot, _page, _type, _id, _lvl, _characterType, isToggled);
		activeChar.sendPacket(new ShortCutRegisterPacket(activeChar, shortCut));
		activeChar.registerShortCut(shortCut, isReplaced);
		
		if ((_slot == 1) && (_page == 23))
			activeChar.getAutoShortCuts().activate(277, true);
	}
}