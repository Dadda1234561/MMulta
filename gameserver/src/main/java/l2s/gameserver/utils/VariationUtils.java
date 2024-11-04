package l2s.gameserver.utils;

import java.util.ArrayList;
import java.util.List;

import l2s.gameserver.model.items.Inventory;
import l2s.gameserver.templates.item.ItemTemplate;
import l2s.gameserver.templates.item.support.variation.VariationResult;
import org.apache.commons.lang3.ArrayUtils;

import l2s.commons.dao.JdbcEntityState;
import l2s.commons.util.Rnd;
import l2s.gameserver.data.xml.holder.VariationDataHolder;
import l2s.gameserver.listener.Acts;
import l2s.gameserver.model.Player;
import l2s.gameserver.model.actor.instances.player.ShortCut;
import l2s.gameserver.model.items.ItemInstance;
import l2s.gameserver.network.l2.s2c.InventoryUpdatePacket;
import l2s.gameserver.network.l2.s2c.ShortCutRegisterPacket;
import l2s.gameserver.templates.item.ExItemType;
import l2s.gameserver.templates.item.VariationType;
import l2s.gameserver.templates.item.support.variation.VariationCategory;
import l2s.gameserver.templates.item.support.variation.VariationFee;
import l2s.gameserver.templates.item.support.variation.VariationGroup;
import l2s.gameserver.templates.item.support.variation.VariationInfo;
import l2s.gameserver.templates.item.support.variation.VariationOption;
import l2s.gameserver.templates.item.support.variation.VariationStone;

/**
 * @author Bonux
**/
public final class VariationUtils
{
	public static long getRemovePrice(ItemInstance item)
	{
		if(item == null)
			return -1;

		VariationGroup group = VariationDataHolder.getInstance().getGroup(item.getTemplate().getVariationGroupId());
		if(group == null)
			return -1;

		int stoneId = item.getVariationStoneId();
		if(stoneId == -1)
			return 0;

		VariationFee fee = group.getFee(stoneId);
		if(fee == null)
			return -1;

		return fee.getCancelFee();
	}

	public static VariationFee getVariationFee(ItemInstance item, ItemInstance stone)
	{
		if(item == null)
			return null;

		if(stone == null)
			return null;

		VariationGroup group = VariationDataHolder.getInstance().getGroup(item.getTemplate().getVariationGroupId());
		if(group == null)
			return null;

		return group.getFee(stone.getItemId());
	}

	public static VariationResult tryAugmentItem(Player player, ItemInstance targetItem, ItemInstance refinerItem, ItemInstance feeItem, long feeItemCount, long adenaCount)
	{
		if(!targetItem.canBeAugmented(player))
			return VariationResult.FAILED;

		if(refinerItem.getTemplate().isBlocked(player, refinerItem))
			return VariationResult.FAILED;

		int stoneId = refinerItem.getItemId();
		VariationStone stone = null;
		
		int[] ANGEL_EARRINGS = 
		{
			48841,
			81213,
			81373,
			81374,
			81375,
			81391,
			81392,
			81393
		};
		
		int[] ANGEL_NECKLACES =
		{
			48669,
			81212,
			81370,
			81371,
			81372,
			81388,
			81389,
			81390
		};
		
		int[] ANGEL_RINGS =
		{
			81154,
			81214,
			81376,
			81377,
			81378,
			81394,
			81395,
			81396
		};
		
		int[] FALLEN_ANGEL_RINGS =
		{
			48864,
			81364,
			81365,
			81366
		};
		
		int[] DRAGON_EARRINGS =
		{
			80334,
			81382,
			81383,
			81384
		};
		
		int[] DRAGON_NECKLACES =
		{
			80333,
			81379,
			81380,
			81381
		};
		
		int[] DRAGON_RINGS =
		{
			80335,
			81385,
			81386,
			81387
		};
		
		int[] CIRCLETS =
		{
			48202,
			48203,
			48204,
			48205,
			48206,
			48207,
			48208,
			48209,
			48210,
			48918,
			48919,
			48920,
			80776,
			80777,
			80778
		};

		int[] ARTEFACTBOOK =
		{
				48956
		};

		if (targetItem.isWeapon())
			stone = VariationDataHolder.getInstance().getStone(VariationType.WEAPON, stoneId);
		else if ((targetItem.getTemplate().getExType() == ExItemType.UPPER_PIECE) || (targetItem.getTemplate().getExType() == ExItemType.FULL_BODY))
			stone = VariationDataHolder.getInstance().getStone(VariationType.ARMOR_CHEST, stoneId);
		else if (targetItem.getTemplate().getExType() == ExItemType.LOWER_PIECE)
			stone = VariationDataHolder.getInstance().getStone(VariationType.ARMOR_LEGS, stoneId);
		else if (targetItem.getTemplate().getExType() == ExItemType.HELMET)
			stone = VariationDataHolder.getInstance().getStone(VariationType.ARMOR_HELMET, stoneId);
		else if (targetItem.getTemplate().getExType() == ExItemType.GLOVES)
			stone = VariationDataHolder.getInstance().getStone(VariationType.ARMOR_GLOVES, stoneId);
		else if (targetItem.getTemplate().getExType() == ExItemType.FEET)
			stone = VariationDataHolder.getInstance().getStone(VariationType.ARMOR_BOOTS, stoneId);
		else if (ArrayUtils.contains(ANGEL_EARRINGS, targetItem.getItemId()))
			stone = VariationDataHolder.getInstance().getStone(VariationType.ACCESSORY_ANGEL_EARRING, stoneId);
		else if (ArrayUtils.contains(ANGEL_NECKLACES, targetItem.getItemId()))
			stone = VariationDataHolder.getInstance().getStone(VariationType.ACCESSORY_ANGEL_NECKLACE, stoneId);
		else if (ArrayUtils.contains(ANGEL_RINGS, targetItem.getItemId()))
			stone = VariationDataHolder.getInstance().getStone(VariationType.ACCESSORY_ANGEL_RING, stoneId);
		else if (ArrayUtils.contains(FALLEN_ANGEL_RINGS, targetItem.getItemId()))
			stone = VariationDataHolder.getInstance().getStone(VariationType.ACCESSORY_FALLEN_ANGEL_RING, stoneId);
		else if ((targetItem.getItemId() == 81350) || (targetItem.getItemId() == 81454)) // Atlas' Earring
			stone = VariationDataHolder.getInstance().getStone(VariationType.ACCESSORY_ATLAS_EARRING, stoneId);
		else if(ArrayUtils.contains(DRAGON_EARRINGS, targetItem.getItemId()))
			stone = VariationDataHolder.getInstance().getStone(VariationType.ACCESSORY_DRAGON_EARRING, stoneId);
		else if(ArrayUtils.contains(DRAGON_NECKLACES, targetItem.getItemId()))
			stone = VariationDataHolder.getInstance().getStone(VariationType.ACCESSORY_DRAGON_NECKLACE, stoneId);
		else if(ArrayUtils.contains(DRAGON_RINGS, targetItem.getItemId()))
			stone = VariationDataHolder.getInstance().getStone(VariationType.ACCESSORY_DRAGON_RING, stoneId);
		else if (targetItem.getTemplate().isCloak())
			stone = VariationDataHolder.getInstance().getStone(VariationType.CLOAK, stoneId);
		else if (targetItem.getTemplate().isBrooch())
			stone = VariationDataHolder.getInstance().getStone(VariationType.BROOCH, stoneId);
		else if (targetItem.getTemplate().isBracelet())
			stone = VariationDataHolder.getInstance().getStone(VariationType.BRACELET, stoneId);
		else if (targetItem.getTemplate().isUnderwear())
			stone = VariationDataHolder.getInstance().getStone(VariationType.UNDERWEAR, stoneId);
		else if (targetItem.getTemplate().isBelt())
			stone = VariationDataHolder.getInstance().getStone(VariationType.BELT, stoneId);
		else if (ArrayUtils.contains(CIRCLETS, targetItem.getItemId()))
			stone = VariationDataHolder.getInstance().getStone(VariationType.HAIR_ACCESSORY, stoneId);
		else if (ArrayUtils.contains(ARTEFACTBOOK, targetItem.getItemId()))
			stone = VariationDataHolder.getInstance().getStone(VariationType.ARTEFACTBOOK, stoneId);
		
		if(stone == null)
			return VariationResult.FAILED;

		int variation1Id = getRandomOptionId(stone.getVariation(1));
		int variation2Id = getRandomOptionId(stone.getVariation(2));
		if(variation1Id == 0 && variation2Id == 0)
			return VariationResult.FAILED;

		if(player.getInventory().getCountOf(refinerItem.getItemId()) < 1L)
			return VariationResult.FAILED;

		if(player.getInventory().getCountOf(feeItem.getItemId()) < feeItemCount)
			return VariationResult.FAILED;

/*		if(!player.getInventory().destroyItem(refinerItem, 1L))
			return VariationResult.FAILED;

		if(!player.getInventory().destroyItem(feeItem, feeItemCount))
			return VariationResult.FAILED;

		if (!player.getInventory().destroyItemByItemId(57, adenaCount))
			return VariationResult.FAILED;*/

		final VariationResult variationResult = new VariationResult(true, targetItem.getObjectId(), variation1Id, variation2Id);
		variationResult.assignRemovableItems(refinerItem.getItemId(), 1L, feeItem.getItemId(), feeItemCount, ItemTemplate.ITEM_ID_ADENA, adenaCount);

//		if (!targetItem.isAugmented())
//		{
//			setVariation(player, targetItem, stoneId, variation1Id, variation2Id);
//		}

		return variationResult;
	}

	public static void setVariation(Player player, ItemInstance item, int variationStoneId, int variation1Id, int variation2Id) {
		item.setVariationStoneId(variationStoneId);
		if (item.getTemplate().getExType() != ExItemType.CLOAK)
		{
			item.setVariation1Id(variation1Id);
			item.setVariation2Id(variation2Id);
		}
		else 
		{
			if ((variationStoneId == 28597) || (variationStoneId == 29165))
			{
				item.setVariation1Id(variation1Id);
			}
			else
				item.setVariation2Id(variation2Id);
		}

		player.getInventory().refreshEquip(item);

		item.setJdbcState(JdbcEntityState.UPDATED);
		item.update();

		player.sendPacket(new InventoryUpdatePacket().addModifiedItem(player, item));

		for(ShortCut sc : player.getAllShortCuts())
		{
			if(sc.getId() == item.getObjectId() && sc.getType() == ShortCut.ShortCutType.ITEM)
				player.sendPacket(new ShortCutRegisterPacket(player, sc));
		}

		player.getListeners().onAct(Acts.ADD_AUGMENTATION, item, variationStoneId);
		player.sendChanges();
	}

	private static int getRandomOptionId(VariationInfo variation)
	{
		if(variation == null)
			return 0;

		double probalityAmount = 0.;
		VariationCategory[] categories = variation.getCategories();
		for(VariationCategory category : categories)
			probalityAmount += category.getProbability();

		if(Rnd.chance(probalityAmount))
		{
			double probalityMod = (100. - probalityAmount) / categories.length;
			List<VariationCategory> successCategories = new ArrayList<VariationCategory>();
			int tryCount = 0;
			while(successCategories.isEmpty())
			{
				tryCount++;
				for(VariationCategory category : categories)
				{
					if((tryCount % 10) == 0) //Немного теряем шанс, но зато зацикливания будут меньше.
						probalityMod += 1.;
					if(Rnd.chance(category.getProbability() + probalityMod))
						successCategories.add(category);
				}
			}

			VariationCategory[] categoriesArray = successCategories.toArray(new VariationCategory[successCategories.size()]);

			return getRandomOptionId(categoriesArray[Rnd.get(categoriesArray.length)]);
		}
		else
			return 0;
	}

	private static int getRandomOptionId(VariationCategory category)
	{
		if(category == null)
			return 0;

		double chanceAmount = 0.;
		VariationOption[] options = category.getOptions();
		for(VariationOption option : options)
			chanceAmount += option.getChance();

		if(Rnd.chance(chanceAmount))
		{
			double chanceMod = (100. - chanceAmount) / options.length;
			List<VariationOption> successOptions = new ArrayList<VariationOption>();
			int tryCount = 0;
			while(successOptions.isEmpty())
			{
				tryCount++;
				for(VariationOption option : options)
				{
					if((tryCount % 10) == 0) //Немного теряем шанс, но зато зацикливания будут меньше.
						chanceMod += 1.;
					if(Rnd.chance(option.getChance() + chanceMod))
						successOptions.add(option);
				}
			}

			VariationOption[] optionsArray = successOptions.toArray(new VariationOption[successOptions.size()]);

			return optionsArray[Rnd.get(optionsArray.length)].getId();
		}
		else
			return 0;
	}
}
