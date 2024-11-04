package l2s.gameserver.network.l2.s2c;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import l2s.commons.util.Rnd;
import l2s.gameserver.common.DifferentMethods;
import l2s.gameserver.data.xml.holder.ItemHolder;
import l2s.gameserver.data.xml.holder.LimitedShopHolder;
import l2s.gameserver.model.Player;
import l2s.gameserver.model.actor.variables.PlayerVariables;
import l2s.gameserver.model.base.LimitedShopEntry;
import l2s.gameserver.model.base.LimitedShopIngredient;
import l2s.gameserver.model.base.LimitedShopProduction;
import l2s.gameserver.model.items.PcInventory;
import l2s.gameserver.model.pledge.Clan;
import l2s.gameserver.templates.item.ItemTemplate;
import l2s.gameserver.templates.item.data.CapsuledItemData;
import l2s.gameserver.templates.item.data.ChancedItemData;

/**
 * @author nexvill
 */
public class ExPurchaseLimitShopItemBuy extends L2GameServerPacket
{
	private final Player _player;
	private final int _listId;
	private final List<LimitedShopEntry> _list;
	private final int _itemIndex;
	private final int _itemCount;

	public ExPurchaseLimitShopItemBuy(Player player, int listId, int itemIndex, int itemCount)
	{
		_player = player;
		_list = LimitedShopHolder.getInstance().getList(listId).getEntries();
		_listId = listId;
		_itemIndex = itemIndex;
		_itemCount = itemCount;
	}

	@Override
	protected final void writeImpl()
	{
		final PcInventory inventory = _player.getInventory();

		int size = _list.size();
		for (int i = 0; i < size; i++)
		{
			final LimitedShopEntry entry = _list.get(i);
			LimitedShopProduction product = entry.getProduction().get(0);
			if (product.getInfo().getInteger("index") == _itemIndex)
			{
				for (LimitedShopIngredient ingredient : entry.getIngredients())
				{
					if ((ingredient.getItemCount() <= 0) || (_itemCount <= 0))
					{
						return;
					}

					Clan clan = _player.getClan();

					if (ingredient.getItemId() == ItemTemplate.ITEM_ID_CLAN_REPUTATION_SCORE)
					{
						if (clan != null)
						{
							clan.incReputation((int) ingredient.getItemCount() * _itemCount, false, "Purchase in Limited Shop");
							final SystemMessage sm = new SystemMessage(SystemMessage.S1_POINTS_HAVE_BEEN_DEDUCTED_FROM_THE_CLAN_REPUTATION_SCORE);
							sm.addNumber(ingredient.getItemCount() * _itemCount);
							_player.sendPacket(sm);
						}
						else
						{
							return;
						}
					}
					else if (ingredient.getItemId() == ItemTemplate.ITEM_ID_FAME)
					{
						if (_player.getFame() >= (ingredient.getItemCount() * _itemCount))
						{
							int newFame = (int) (_player.getFame() - (ingredient.getItemCount() * _itemCount));
							_player.setFame(newFame, null, true);
							_player.broadcastUserInfo(true);
						}
						else
						{
							return;
						}
					}
					else if (ingredient.getItemId() == ItemTemplate.ITEM_ID_PC_BANG_POINTS)
					{
						if (_player.getPcBangPoints() >= (ingredient.getItemCount() * _itemCount))
						{
							int newPoints = (int) (_player.getPcBangPoints()
									- (ingredient.getItemCount() * _itemCount));
							_player.setPcBangPoints(newPoints, true);
							_player.sendPacket(new ExPCCafePointInfoPacket(_player,
									(int) -(ingredient.getItemCount() * _itemCount), 1, 0, 2));
						}
						else
						{
							return;
						}
					}
					else
					{
						boolean itemDestroyed = inventory.destroyItemByItemId(ingredient.getItemId(), ingredient.getItemCount() * _itemCount);
						if (!itemDestroyed)
						{
							final SystemMessage sm = new SystemMessage(SystemMessage.YOU_NEED_S2_S1_S);
							sm.addItemName(ingredient.getItemId());
							sm.addNumber(ingredient.getItemCount() * _itemCount);
							_player.sendPacket(sm);
							return;
						}
					}
				}
				break;
			}
		}

		final Map<Integer, RewardEntry> rewardList = new HashMap<>();

		for (int i = 0; i < size; i++)
		{
			final LimitedShopEntry entry = _list.get(i);
			LimitedShopProduction product = entry.getProduction().get(0);
			if (product.getInfo().getInteger("index") == _itemIndex)
			{
				int productId = product.getInfo().getInteger("product1Id");

				int productsCount = 1;
				if (product.getInfo().getInteger("product2Id") > 0)
					productsCount++;
				if (product.getInfo().getInteger("product3Id") > 0)
					productsCount++;
				if (product.getInfo().getInteger("product4Id") > 0)
					productsCount++;
				if (product.getInfo().getInteger("product5Id") > 0)
					productsCount++;

				int resultProductId = 0;
				int resultProductCount = 0;
				byte craftedSlot = 0;

				switch (productsCount)
				{
					case 1:
					{
						resultProductId = productId;
						resultProductCount = product.getInfo().getInteger("product1Count") * _itemCount;
						RewardEntry rewardEntry = rewardList.getOrDefault(resultProductId, new RewardEntry(0, 0));
						rewardEntry.setItemCnt(resultProductCount);
						rewardList.put(resultProductId, rewardEntry);
						break;
					}
					case 2:
					{
						for (int j = 0; j < _itemCount; j++) {
							if (Rnd.chance(product.getInfo().getDouble("product2Chance"))) {
								resultProductId = product.getInfo().getInteger("product2Id");
								resultProductCount = product.getInfo().getInteger("product2Count");
								craftedSlot = 1;
							}
							else {
								resultProductId = product.getInfo().getInteger("product1Id");
								resultProductCount = product.getInfo().getInteger("product1Count");
								craftedSlot = 0;
							}

							RewardEntry rewardEntry = rewardList.getOrDefault(resultProductId, new RewardEntry(0));
							rewardEntry.setSlot(craftedSlot);
							rewardEntry.setItemCnt(rewardEntry.getItemCnt() + resultProductCount);
							rewardList.put(resultProductId, rewardEntry);
						}
						break;
					}
					case 3:
					{
						for (int j = 0; j < _itemCount; j++) {
							double chance = Rnd.get(100);
							if (chance >= product.getInfo().getDouble("product1Chance")) {
								resultProductId = product.getInfo().getInteger("product1Id");
								resultProductCount = product.getInfo().getInteger("product1Count");
								craftedSlot = 0;
							}
							else if (chance >= product.getInfo().getDouble("product2Chance")) {
								resultProductId = product.getInfo().getInteger("product2Id");
								resultProductCount = product.getInfo().getInteger("product2Count");
								craftedSlot = 1;
							}
							else {
								resultProductId = product.getInfo().getInteger("product3Id");
								resultProductCount = product.getInfo().getInteger("product3Count");
								craftedSlot = 2;
							}

							RewardEntry rewardEntry = rewardList.getOrDefault(resultProductId, new RewardEntry(0));
							rewardEntry.setItemCnt(rewardEntry.getItemCnt() + resultProductCount);
							rewardEntry.setSlot(craftedSlot);
							rewardList.put(resultProductId, rewardEntry);
						}
						break;
					}
					case 4:
					{
						for (int j = 0; j < _itemCount; j++) {
							double chance = Rnd.get(100);
							if (chance >= product.getInfo().getDouble("product1Chance")) {
								resultProductId = product.getInfo().getInteger("product1Id");
								resultProductCount = product.getInfo().getInteger("product1Count");
								craftedSlot = 0;
							}
							else if (chance >= product.getInfo().getDouble("product2Chance")) {
								resultProductId = product.getInfo().getInteger("product2Id");
								resultProductCount = product.getInfo().getInteger("product2Count");
								craftedSlot = 1;
							}
							else if (chance >= product.getInfo().getDouble("product3Chance")) {
								resultProductId = product.getInfo().getInteger("product3Id");
								resultProductCount = product.getInfo().getInteger("product3Count");
								craftedSlot = 2;
							}
							else {
								resultProductId = product.getInfo().getInteger("product4Id");
								resultProductCount = product.getInfo().getInteger("product4Count");
								craftedSlot = 3;
							}

							RewardEntry rewardEntry = rewardList.getOrDefault(resultProductId, new RewardEntry(0));
							rewardEntry.setItemCnt(rewardEntry.getItemCnt() + resultProductCount);
							rewardEntry.setSlot(craftedSlot);
							rewardList.put(resultProductId, rewardEntry);
						}
						break;
					}
					case 5:
					{
						for (int j = 0; j < _itemCount; j++) {
							double chance = Rnd.get(100);
							if (chance >= product.getInfo().getDouble("product1Chance")) {
								resultProductId = product.getInfo().getInteger("product1Id");
								resultProductCount = product.getInfo().getInteger("product1Count");
								craftedSlot = 0;
							}
							else if (chance >= product.getInfo().getDouble("product2Chance")) {
								resultProductId = product.getInfo().getInteger("product2Id");
								resultProductCount = product.getInfo().getInteger("product2Count");
								craftedSlot = 1;
							}
							else if (chance >= product.getInfo().getDouble("product3Chance")) {
								resultProductId = product.getInfo().getInteger("product3Id");
								resultProductCount = product.getInfo().getInteger("product3Count");
								craftedSlot = 2;
							}
							else if (chance >= product.getInfo().getDouble("product4Chance")) {
								resultProductId = product.getInfo().getInteger("product4Id");
								resultProductCount = product.getInfo().getInteger("product4Count");
								craftedSlot = 3;
							}
							else {
								resultProductId = product.getInfo().getInteger("product5Id");
								resultProductCount = product.getInfo().getInteger("product5Count");
								craftedSlot = 4;
							}

							RewardEntry rewardEntry = rewardList.getOrDefault(resultProductId, new RewardEntry(0));
							rewardEntry.setItemCnt(rewardEntry.getItemCnt() + resultProductCount);
							rewardEntry.setSlot(craftedSlot);
							rewardList.put(resultProductId, rewardEntry);
						}
						break;
					}
				}

				/* При не стыкуемых предметах желательно проверять кол-во слотов в инвентаре */
				/* Но эту уже совсем другая история */
				rewardList.forEach((itemId, rewardEntry) ->
				{
					final ItemTemplate template = ItemHolder.getInstance().getTemplate(itemId);
					if (template == null) {
						return;
					}

					if (template.isStackable()) {
						DifferentMethods.addItem(_player, itemId, rewardEntry.getItemCnt());
					} else {
						for (int i1 = 0; i1 < rewardEntry.getItemCnt(); i1++) {
							DifferentMethods.addItem(_player, itemId, 1);
						}
					}
				});

				/* На последней покупке можно будет купить сверх лимита */
				int remainLimit = 0;
				if (product.getInfo().getInteger("dailyLimit") > 0)
				{
					remainLimit = _player.getVarInt(PlayerVariables.LIMIT_ITEM_REMAIN + "_" + productId, product.getInfo().getInteger("dailyLimit"));
					remainLimit = remainLimit - _itemCount;
					_player.setVar(PlayerVariables.LIMIT_ITEM_REMAIN + "_" + productId, remainLimit);
				}
				else
				{
					remainLimit = 999;
				}


				writeC(0);
				writeC(_listId);
				writeD(_itemIndex);
				writeD(rewardList.size());
				for (Map.Entry<Integer, RewardEntry> rewardEntry : rewardList.entrySet())
				{
					writeC(rewardEntry.getValue().getSlot()); // crafted slot
					writeD(rewardEntry.getKey());
					writeD(rewardEntry.getValue().getItemCnt());
				}
				writeD(remainLimit);
				break;
			}
		}
		_player.sendPacket(new ExBloodyCoinCount(_player));
	}

	private class RewardEntry {
		private int slot;
		private int itemCnt;


		public RewardEntry(int itemCnt) {
			this.itemCnt = itemCnt;
		}

		public RewardEntry(int slot, int itemCnt) {
			this.slot = slot;
			this.itemCnt = itemCnt;
		}

		public int getSlot() {
			return slot;
		}

		public int getItemCnt() {
			return itemCnt;
		}

		public void setItemCnt(int itemCnt) {
			this.itemCnt = itemCnt;
		}

		public void setSlot(int slot) {
			this.slot = slot;
		}
	}
}