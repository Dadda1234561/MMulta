package l2s.gameserver.network.l2.c2s;

import l2s.gameserver.Config;
import l2s.gameserver.common.DifferentMethods;
import l2s.gameserver.model.Player;
import l2s.gameserver.model.base.ClassId;
import l2s.gameserver.model.base.ClassLevel;
import l2s.gameserver.network.l2.components.SystemMsg;

public class RequestExRequestClassChange extends L2GameClientPacket
{
	private int _classId;

	@Override
	protected boolean readImpl() {
		_classId = readD();
		return true;
	}

	@Override
	protected void runImpl() {
		Player player = getClient().getActiveChar();
		if(player == null)
			return;

		ClassId classId = ClassId.valueOf(_classId);
		if(classId == null) {
			player.sendActionFailed();
			return;
		}

		if(!player.canClassChange()) {
			player.sendActionFailed();
			return;
		}

		// Check for awaked class change price
		if (classId.isOfLevel(ClassLevel.AWAKED)) {
			boolean hasEnoughItems = true;
			for ( int i = 0; i < Config.FOURTH_CLASS_CHANGE_PRICE.length; i+=2 ) {
				if (player.getInventory().getCountOf((int) Config.FOURTH_CLASS_CHANGE_PRICE[i]) < Config.FOURTH_CLASS_CHANGE_PRICE[i+1]) {
					hasEnoughItems = false;
					if (player.isLangRus()) {
						player.sendScreenMessage("Для получения 4-ой Профессии, Вам необходим Сертификат 4-ой Профессии.");
					} else {
						player.sendScreenMessage("To obtain 4th Profession, you need Certificate of 4th Profession.");
					}
					break;
				}
			}

			if (!hasEnoughItems) {
				player.sendActionFailed();
				return;
			}

			boolean itemsRemoved = true;
			for (int i = 0; i < Config.FOURTH_CLASS_CHANGE_PRICE.length; i+=2) {
				if (!DifferentMethods.getPay(player, (int) Config.FOURTH_CLASS_CHANGE_PRICE[i], Config.FOURTH_CLASS_CHANGE_PRICE[i+1], true)) {
					itemsRemoved = false;
					if (player.isLangRus()) {
						player.sendScreenMessage("Для получения 4-ой Профессии, Вам необходим Сертификат 4-ой Профессии.");
					} else {
						player.sendScreenMessage("To obtain 4th Profession, you need Certificate of 4th Profession.");
					}
					break;
				}
			}

			if (!itemsRemoved) {
				player.sendActionFailed();
				return;
			}
		}

		if(!player.setClassId(classId.getId(), false)) {
			player.sendActionFailed();
			return;
		}

		player.sendPacket(SystemMsg.CONGRATULATIONS__YOUVE_COMPLETED_A_CLASS_TRANSFER);
		player.broadcastUserInfo(true);
	}
}
