package l2s.gameserver.network.l2.c2s;

import l2s.gameserver.Config;
import l2s.gameserver.listener.actor.player.OnAnswerListener;
import l2s.gameserver.model.Player;
import l2s.gameserver.model.base.SoulShotType;
import l2s.gameserver.model.items.ItemInstance;
import l2s.gameserver.network.l2.components.CustomMessage;
import l2s.gameserver.network.l2.components.SystemMsg;
import l2s.gameserver.network.l2.s2c.ConfirmDlgPacket;
import l2s.gameserver.network.l2.s2c.ExAutoSoulShot;
import l2s.gameserver.templates.item.EtcItemTemplate;
import l2s.gameserver.utils.ChatUtils;
import l2s.gameserver.utils.HtmlUtils;
import l2s.gameserver.utils.ItemFunctions;

import java.time.Instant;
import java.time.LocalDateTime;
import java.time.OffsetTime;
import java.time.ZoneId;
import java.time.ZoneOffset;
import java.util.concurrent.TimeUnit;

public class UseItem extends L2GameClientPacket
{
	private int _objectId;
	private boolean _ctrlPressed;

	@Override
	protected boolean readImpl()
	{
		_objectId = readD();
		_ctrlPressed = readD() == 1;
		return true;
	}

	@Override
	protected void runImpl()
	{
		Player activeChar = getClient().getActiveChar();
		if (activeChar == null)
			return;

		activeChar.setActive();

		ItemInstance item = activeChar.getInventory().getItemByObjectId(_objectId);
		if (item == null)
		{
			activeChar.sendActionFailed();
			return;
		}

		if(item.isWeapon()){
			if(Config.ALLOW_CLASSIC_AUTO_SHOTS){
				ItemInstance soulShot = activeChar.getInventory().getItemByItemId(Config.SOULSHOT_ID);
				ItemInstance spiritShot = activeChar.getInventory().getItemByItemId(Config.SPIRIT_SHOT_ID);
				ItemInstance blessSpiritShot = activeChar.getInventory().getItemByItemId(Config.BLESS_SPIRIT_SHOT_ID);

				if(soulShot != null) {
					activeChar.activateSoulShots(soulShot.getItemId(), SoulShotType.SOULSHOT);
					activeChar.addAutoShot(soulShot.getItemId(), true, SoulShotType.SOULSHOT);
				}

				if(spiritShot != null) {
					activeChar.activateSoulShots(spiritShot.getItemId(), SoulShotType.SPIRITSHOT);
					activeChar.addAutoShot(Config.SPIRIT_SHOT_ID, true, SoulShotType.SPIRITSHOT);
				}

				if(blessSpiritShot != null) {
					activeChar.activateSoulShots(blessSpiritShot.getItemId(), SoulShotType.SPIRITSHOT);
					activeChar.addAutoShot(Config.BLESS_SPIRIT_SHOT_ID, true, SoulShotType.SPIRITSHOT);
				}
			}
		}


		if (_ctrlPressed)
		{
			if (activeChar.isGM())
			{
				ChatUtils.sys(activeChar, "Предмет ID:" + item.getItemId() + "| Имя" + item.getName());
			}
			if (item.isWeapon() || item.isArmor() || item.isAccessory())
			{
				boolean hasRestrictions = false;

				StringBuilder sb = new StringBuilder();
				sb.append("<font color=LEVEL>Ограничения:</font>").append("<br1>");
				if ((item.getCustomFlags() & ItemInstance.FLAG_NO_DROP) == ItemInstance.FLAG_NO_DROP)
				{
					sb.append("Нельзя выбросить").append("<br1>");
					hasRestrictions = true;
				}
				if ((item.getCustomFlags() & ItemInstance.FLAG_NO_TRADE) == ItemInstance.FLAG_NO_TRADE)
				{
					sb.append("Нельзя продать/обменять").append("<br1>");
					hasRestrictions = true;
				}
				if ((item.getCustomFlags() & ItemInstance.FLAG_NO_TRANSFER) == ItemInstance.FLAG_NO_TRANSFER)
				{
					sb.append("Нельзя положить на склад").append("<br1>");
					hasRestrictions = true;
				}
				if ((item.getCustomFlags() & ItemInstance.FLAG_NO_CRYSTALLIZE) == ItemInstance.FLAG_NO_CRYSTALLIZE)
				{
					sb.append("Нельзя кристализовать").append("<br1>");
					hasRestrictions = true;
				}
				if ((item.getCustomFlags() & ItemInstance.FLAG_NO_SHAPE_SHIFTING) == ItemInstance.FLAG_NO_SHAPE_SHIFTING)
				{
					sb.append("Нельзя обработать").append("<br1>");
					hasRestrictions = true;
				}

				if (hasRestrictions)
				{
					HtmlUtils.sendHtm(activeChar, sb.toString());
					return;
				}
			}
		}


		if ((isForceDelete(activeChar, item) || !activeChar.useItem(item, _ctrlPressed, true)) && _ctrlPressed) {
			if (hasRestrictions(item)) {
				activeChar.sendActionFailed();
				return;
			}

			if (isForceDeleteModeActive(activeChar)) {
				ItemFunctions.deleteItem(activeChar, item, item.getCount());
			} else {
				askDelete(activeChar, item);
			}
		}
	}

	private boolean isForceDelete(Player player, ItemInstance item) {
		return isForceDeleteModeActive(player); /* || isForceDeleteItem(item) */
	}

	private boolean isForceDeleteModeActive(Player player) {
		return player.getVarInt("deleteTries", 0) > 2;
	}

	private boolean isForceDeleteItem(ItemInstance item) {
		return item.getItemType().equals(EtcItemTemplate.EtcItemType.RECIPE);
	}

	private boolean hasRestrictions(ItemInstance item) {
		boolean hasRestrictions = (item.getCustomFlags() & ItemInstance.FLAG_NO_DROP) == ItemInstance.FLAG_NO_DROP;
		if ((item.getCustomFlags() & ItemInstance.FLAG_NO_TRADE) == ItemInstance.FLAG_NO_TRADE) {
			hasRestrictions = true;
		}
		if ((item.getCustomFlags() & ItemInstance.FLAG_NO_TRANSFER) == ItemInstance.FLAG_NO_TRANSFER) {
			hasRestrictions = true;
		}
		if ((item.getCustomFlags() & ItemInstance.FLAG_NO_CRYSTALLIZE) == ItemInstance.FLAG_NO_CRYSTALLIZE) {
			hasRestrictions = true;
		}
		if ((item.getCustomFlags() & ItemInstance.FLAG_NO_SHAPE_SHIFTING) == ItemInstance.FLAG_NO_SHAPE_SHIFTING) {
			hasRestrictions = true;
		}
		if (item.isEquipped() || !item.getTemplate().getCapsuledItems().isEmpty()) {
			hasRestrictions = true;
		}

		return hasRestrictions;
	}

	private void askDelete(Player player, ItemInstance item) {
		final CustomMessage askMessage = new CustomMessage("custom.DeleteItem.ask").addItemName(item.getItemId());
		ConfirmDlgPacket dlg = new ConfirmDlgPacket(SystemMsg.S1, 5000).addString(askMessage.toString(player));
		player.ask(dlg, new OnAnswerListener() {
			@Override
			public void sayYes() {
				// get next valid time
				final Instant valLifeTimeEnd = LocalDateTime.now().plusMinutes(2).atZone(ZoneId.systemDefault()).toInstant();
				ItemFunctions.deleteItem(player, item, item.getCount());
				// get current tries
				int currTries = player.getVarInt("deleteTries", 0);
				// increment
				player.setVar("deleteTries", ++currTries, valLifeTimeEnd.toEpochMilli());
			}

			@Override
			public void sayNo() {

			}
		});
	}
}