package l2s.gameserver.network.l2.c2s;

import l2s.commons.util.Rnd;
import l2s.gameserver.model.Player;
import l2s.gameserver.model.base.ArtifactSlot;
import l2s.gameserver.model.items.Inventory;
import l2s.gameserver.model.items.ItemInstance;
import l2s.gameserver.network.l2.components.SystemMsg;
import l2s.gameserver.network.l2.s2c.ExTryEnchantArtifactResult;
import l2s.gameserver.network.l2.s2c.InventoryUpdatePacket;
import l2s.gameserver.network.l2.s2c.SystemMessagePacket;
import l2s.gameserver.templates.item.ItemTemplate;
import l2s.gameserver.utils.ItemFunctions;

import java.util.HashSet;
import java.util.Set;

/**
 * @author Bonux (bonuxq@gmail.com)
 * @date 09.09.2019
 **/
public class RequestExTryEnchantArtifact extends L2GameClientPacket {
	private static final int[] ENCHANT_CHANCES = {100, 70, 70, 50, 40, 40, 40, 30, 30, 20};
	// private static final int[] ENCHANT_CHANCES = {100, 970, 970, 950, 940, 940, 940, 930, 930, 920};

	private int targetObjectId = 0;
	private int count = 0;
	private Set<Integer> ingridients = new HashSet<>();

	@Override
	protected boolean readImpl() throws Exception {
		targetObjectId = readD();
		count = readD();
		for (int i = 0; i < count; i++)
			ingridients.add(readD());
		return !ingridients.contains(targetObjectId);
	}

	@Override
	protected void runImpl() {
		Player player = getClient().getActiveChar();
		if (player == null)
			return;

		if (player.isActionsDisabled() || player.isInStoreMode() || player.isInTrade() || player.isFishing() || player.isInTrainingCamp() || count != ingridients.size()) {
			player.sendPacket(ExTryEnchantArtifactResult.ERROR_PACKET);
			return;
		}

		Inventory inventory = player.getInventory();
		inventory.writeLock();
		try {
			ItemInstance targetItem = inventory.getItemByObjectId(targetObjectId);
			if (targetItem == null) {
				player.sendPacket(ExTryEnchantArtifactResult.ERROR_PACKET);
				return;
			}

			ItemTemplate itemTemplate = targetItem.getTemplate();
			ArtifactSlot artifactSlot = itemTemplate.getArtifactSlot();
			if (artifactSlot == null) {
				player.sendPacket(ExTryEnchantArtifactResult.ERROR_PACKET);
				return;
			}

			int maxEnchantLevel = 0;
			for (int level : itemTemplate.getEnchantOptions().keys()) {
				if (level > maxEnchantLevel)
					maxEnchantLevel = level;
			}

			//maxEnchantLevel = Math.min(ENCHANT_CHANCES.length -1, maxEnchantLevel);

			int enchantLevel = targetItem.getEnchantLevel();
			if (enchantLevel >= maxEnchantLevel) {
				player.sendPacket(ExTryEnchantArtifactResult.ERROR_PACKET);
				return;
			}

			int needCount = 0;
			if (enchantLevel <= 6)
				needCount = 3;
			else if (enchantLevel <= 9)
				needCount = 2;

			if (needCount == 0 || needCount != ingridients.size()) {
				player.sendPacket(ExTryEnchantArtifactResult.ERROR_PACKET);
				return;
			}

			int chance = ENCHANT_CHANCES[enchantLevel];
			if (chance == 0) {
				player.sendPacket(ExTryEnchantArtifactResult.ERROR_PACKET);
				return;
			}

			int minIngridientEnchant = -1;
			if (enchantLevel <= 3)
				minIngridientEnchant = 0;
			else if (enchantLevel <= 6)
				minIngridientEnchant = 1;
			else if (enchantLevel <= 9)
				minIngridientEnchant = 3;

			if (minIngridientEnchant == -1) {
				player.sendPacket(ExTryEnchantArtifactResult.ERROR_PACKET);
				return;
			}

			for (int objectId : ingridients) {
				ItemInstance ingridient = inventory.getItemByObjectId(objectId);
				if (ingridient == null || ingridient.getEnchantLevel() < minIngridientEnchant || ingridient.getTemplate().getArtifactSlot() != artifactSlot) {
					player.sendPacket(ExTryEnchantArtifactResult.ERROR_PACKET);
					return;
				}
				ItemFunctions.deleteItem(player, ingridient, 1, true);
			}

			if (Rnd.chance(chance)) {
				targetItem.setEnchantLevel(enchantLevel + 1);


				player.sendPacket(new InventoryUpdatePacket().addModifiedItem(player, targetItem));
				player.sendPacket(new SystemMessagePacket(SystemMsg.ARTIFACT_UPGRADE_SUCCEEDED_AND_YOU_OBTAINED_S1).addItemName(targetItem.getItemId()));
				player.sendPacket(new ExTryEnchantArtifactResult(ExTryEnchantArtifactResult.SUCCESS, targetItem.getEnchantLevel()));

				targetItem.save();

			} else {
				player.sendPacket(new SystemMessagePacket(SystemMsg.FAILED_TO_UPGRADE_ARTIFACT_THE_ITEMS_UPGRADE_LEVEL_WILL_REMAIN_THE_SAME));
				player.sendPacket(new ExTryEnchantArtifactResult(ExTryEnchantArtifactResult.FAIL, targetItem.getEnchantLevel()));
			}
		} finally {
			inventory.writeUnlock();
		}
	}
}