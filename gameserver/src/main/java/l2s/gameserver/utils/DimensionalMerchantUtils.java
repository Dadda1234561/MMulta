package l2s.gameserver.utils;

import l2s.gameserver.data.htm.HtmCache;
import l2s.gameserver.data.xml.holder.MultiSellHolder;
import l2s.gameserver.model.Player;
import l2s.gameserver.model.instances.NpcInstance;
import l2s.gameserver.model.items.ItemInstance;
import l2s.gameserver.network.l2.components.HtmlMessage;
import l2s.gameserver.network.l2.components.SystemMsg;
import l2s.gameserver.network.l2.s2c.ExGetPremiumItemListPacket;

import java.util.List;

public class DimensionalMerchantUtils {
	// Items
	private static final int MINION_COUPON = 13273; // Minion Coupon (5-hour)
	private static final int MINION_COUPON_EV = 13383; // Minion Coupon (5-hour) (Event)
	private static final int SUP_MINION_COUPON = 14065; // Superior Minion Coupon - 5-hour
	private static final int SUP_MINION_COUPON_EV = 14074; // Superior Minion Coupon (Event) - 5-hour
	private static final int ENH_MINION_COUPON = 20914; // Enhanced Rose Spirit Coupon (5-hour)
	private static final int ENH_MINION_COUPON_EV = 22240; // Enhanced Rose Spirit Coupon (5-hour) - Event

	public final static String DM_HTML_FILE_PATH = "dimensional_merchant/";

	public static void showLimitShopHtml(NpcInstance npc, Player player, String fileName, boolean premium) {
		if (npc == null) {
			HtmlMessage msg = new HtmlMessage(0);
			msg.setItemId(premium ? -1 : 0);
			msg.setFile(correctBypassLink(player, fileName));
			player.sendPacket(msg);
		} else {
			npc.showChatWindow(player, correctBypassLink(player, fileName), false);
		}
	}

	public static void showLimitShopHtml(Player player, String fileName, boolean premium) {
		showLimitShopHtml(null, player, fileName, premium);
	}

	public static String correctBypassLink(Player player, String link) {
		String path = DM_HTML_FILE_PATH + link;
		if (HtmCache.getInstance().getIfExists(path, player) != null)
			return path;
		return link;
	}

	public static boolean onMenuSelect(NpcInstance npc, Player player, int ask, long reply, int state) {
		if (ask == 1) // Receive incoming premium items.
		{
			if (reply == 1) {
				if (player.getPremiumItemList().isEmpty()) {
					player.sendPacket(SystemMsg.THERE_ARE_NO_MORE_VITAMIN_ITEMS_TO_BE_FOUND);
					return true;
				}
				player.sendPacket(new ExGetPremiumItemListPacket(player));
				return true;
			}
		} else if (ask == -303) {
			if (reply == 706) {
				MultiSellHolder.getInstance().SeparateAndSend((int) reply, player, 0);
				return true;
			} else if (reply == 3012) {
				MultiSellHolder.getInstance().SeparateAndSend((int) reply, player, 0);
				return true;
			} else if (reply == 3901) {
				if (player.isInventoryFull()) {
					player.sendPacket(SystemMsg.YOU_CAN_PROCEED_ONLY_WHEN_THE_INVENTORY_WEIGHT_IS_BELOW_80_PERCENT_AND_THE_QUANTITY_IS_BELOW_90_PERCENT);
				} else {
					MultiSellHolder.getInstance().SeparateAndSend((int) reply, player, 0);
				}
				return true;
			}
		} else if (ask == -1112231) {
			int itemId = (int) reply;
			switch (itemId) {
				case 13017: // White Weasel Minion Necklace
				case 13018: // Fairy Princess Minion Necklace
				case 13019: // Wild Beast Fighter Minion Necklace
				case 13020: // Fox Shaman Minion Necklace
					if (exchangeCoupon(player, itemId, new int[]{MINION_COUPON, MINION_COUPON_EV}))
						showLimitShopHtml(npc, player, "e_premium_manager002a.htm", true);
					else
						showLimitShopHtml(npc, player, "e_premium_manager002b.htm", true);
					return true;
				case 14061: // Toy Knight Summon Whistle
				case 14062: // Spirit Shaman Summon Whistle
				case 14064: // Turtle Ascetic Summon Necklace
					if (exchangeCoupon(player, itemId, new int[]{SUP_MINION_COUPON, SUP_MINION_COUPON_EV}))
						showLimitShopHtml(npc, player, "e_premium_manager002a.htm", true);
					else
						showLimitShopHtml(npc, player, "e_premium_manager002b.htm", true);
					return true;
				case 20915: // Enhanced Rose Necklace: Desheloph
				case 20916: // Enhanced Rose Necklace: Hyum
				case 20917: // Enhanced Rose Necklace: Lekang
				case 20918: // Enhanced Rose Necklace: Lilias
				case 20919: // Enhanced Rose Necklace: Lapham
				case 20920: // Enhanced Rose Necklace: Mafum
					if (exchangeCoupon(player, itemId, new int[]{ENH_MINION_COUPON, ENH_MINION_COUPON_EV}))
						showLimitShopHtml(npc, player, "e_premium_manager002a.htm", true);
					else
						showLimitShopHtml(npc, player, "e_premium_manager002c.htm", true);
					return true;
			}
		}
		return false;
	}

	private static boolean exchangeCoupon(Player player, int itemId, int[] coupons) {
		for (int coupon : coupons) {
			if (ItemFunctions.deleteItem(player, coupon, 1)) {
				List<ItemInstance> items = ItemFunctions.addItem(player, itemId, 1);
				if (player.getPet() == null) {
					for (ItemInstance item : items) {
						player.setPetControlItem(item);
						player.summonPet();
						break;
					}
				}
				return true;
			}
		}
		return false;
	}
}
