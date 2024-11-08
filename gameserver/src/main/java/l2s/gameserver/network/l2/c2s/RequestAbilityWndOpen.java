package l2s.gameserver.network.l2.c2s;

import l2s.gameserver.model.Player;
import l2s.gameserver.network.l2.s2c.ExShowAPListWnd;

/**
 * @author Bonux
 **/
public class RequestAbilityWndOpen extends L2GameClientPacket {
	@Override
	protected boolean readImpl() {
		return true;
	}

	@Override
	protected void runImpl() {
		Player activeChar = getClient().getActiveChar();
		if (activeChar == null)
			return;

		if (activeChar.isAllowAbilities()) {
			activeChar.sendPacket(ExShowAPListWnd.STATIC);
		}
	}
}