package npc.model.custom;

import l2s.commons.collections.MultiValueSet;
import l2s.commons.util.Rnd;
import l2s.gameserver.common.DifferentMethods;
import l2s.gameserver.data.htm.HtmCache;
import l2s.gameserver.data.string.ItemNameHolder;
import l2s.gameserver.data.xml.holder.ResourceHolder;
import l2s.gameserver.instancemanager.SmeltingManager;
import l2s.gameserver.instancemanager.SmeltingManager.TaskState;
import l2s.gameserver.model.Player;
import l2s.gameserver.model.ProductionType;
import l2s.gameserver.model.instances.NpcInstance;
import l2s.gameserver.network.l2.components.HtmlMessage;
import l2s.gameserver.templates.ResourceTemplate;
import l2s.gameserver.templates.item.data.ItemData;
import l2s.gameserver.templates.npc.NpcTemplate;

import java.util.List;
import java.util.StringTokenizer;
import java.util.stream.Collectors;

public class SmeltingNpcInstance extends NpcInstance
{
	private static final int MAX_INGREDIENTS = 5;
	private static final int MAX_SLOTS = 3;
	private static final int DEFAULT_FREE_SLOTS = 1;

	private static final String SELECT_ACTION_TPL = "&nbsp;|&nbsp;<font color=\"7cfc00\">Все ингридиенты</font>&nbsp;|&nbsp;<a action=\"bypass -h npc_%d_selResource_%d_%d\" >[Выбрать]</a>";

	private static final String SPACING = "<td width=\"10\"></td>";
	private static final String INGREDIENT_EMPTY_SLOT = "<td><br><br><button action=\"bypass -h npc_%d_itemList_%d_%d\" tooltip=\"Пустой слот\\nНажмите, что бы добавить предмет.\" value=\" \" back=\"L2UI_CT1.ItemWindow_DF_SlotBox_Default\" fore=\"L2UI_CT1.ItemWindow_DF_SlotBox_Default\" high=\"L2UI_CT1.ItemWindow_DF_SlotBox_Default\" width=\"32\" height=32></td>";
	private static final String INGREDIENT_DEFAULT_SLOT = "<td height=\"64\" align=\"center\" valign=\"center\"><br><br><button itemtooltip=\"%d\" high=\"L2UI_CT1.ItemWindow_DF_SlotBox_Default\" width=\"32\" height=32></td>";
	private static final String INGREDIENT_BLOCKED_SLOT = "<td height=\"64\" align=\"center\" valign=\"center\"><br><br><button disabled value=\" \" tooltip=\"Незадействованный слот\" back=\"L2UI_CT1.ItemLock\" fore=\"L2UI_CT1.ItemLock\" high=\"L2UI_CT1.ItemLock\" width=\"32\" height=32></td>";

	private static final String REMAINING_TIME_TPL = "• Осталось: <font>%s</font>";
	private static final String UNAVAILABLE_TPL = "• Недоступно. Необходимо приобрести.";
	private static final String SLOT_READY_TPL = "• Готово к использованию.";

	private static final String PRODUCTION_EMPTY_SLOT = "<td><table><tr><td><button disabled tooltip=\"\" action=\"\" value=\" \" back=\"L2UI_EPIC.BlessWndBigSlot\" fore=\"L2UI_EPIC.BlessWndBigSlot\" high=\"L2UI_EPIC.BlessWndBigSlot\" width=\"62\" height=\"64\"></button></td></tr></table></td>";
	private static final String PRODUCTION_RANDOM_SLOT = "<td><table><tr><td><button disabled tooltip=\"Случайный предмет из списка:%s\" action=\"\" value=\" \" back=\"L2UI_EPIC.QuestionmarkSlot\" fore=\"L2UI_EPIC.QuestionmarkSlot\" high=\"L2UI_EPIC.QuestionmarkSlot\" width=\"64\" height=\"64\"></button></td></tr></table></td>";
	private static final String PRODUCTION_SLOT = "<td><button disabled itemtooltip=\"%d\" width=\"64\" height=64></td>";

	private static final String UNLOCK_BYPASS = "byPass -h npc_%d_unlockSlot_%d";

	public SmeltingNpcInstance(int objectId, NpcTemplate template, MultiValueSet<String> set)
	{
		super(objectId, template, set);
	}

	private static String getPrice(Player player, List<ItemData> unlockPrice)
	{
		StringBuilder price = new StringBuilder();
		for(int i = 0; i < unlockPrice.size(); i++)
		{
			ItemData itemData = unlockPrice.get(i);
			String itemName = ItemNameHolder.getInstance().getItemName(player, itemData.getId());
			price.append(itemData.getCount()).append(" ").append(itemName).append(i == unlockPrice.size() - 1 ? "" : ", ");
		}
		return price.toString();
	}

	private static String buildIngredientDisplayCnt(Player player, ItemData itemData)
	{
		long availableCount = player.getInventory().getCountOf(itemData.getId());
		return String.valueOf(Math.min(availableCount, itemData.getCount()));
	}

	@Override
	public void onBypassFeedback(Player player, String command)
	{
		StringTokenizer st = new StringTokenizer(command, "_");
		String cmd = st.nextToken();
		if(cmd == null)
		{
			return;
		}
		if(cmd.startsWith("unlockSlot"))
		{
			int slot = Integer.parseInt(st.nextToken());
			List<ItemData> unlockPrice = ResourceHolder.getInstance().getUnlockPrice(player, slot);
			if(unlockPrice.isEmpty())
			{
				return;
			}
			boolean itemsDestroyed = true;
			for(ItemData itemData : unlockPrice)
			{
				if(!DifferentMethods.getPay(player, itemData.getId(), itemData.getCount(), true))
				{
					itemsDestroyed = false;
					break;
				}
			}

			if(itemsDestroyed)
			{
				int smeltingSlots = player.getVarInt("SMELTING_SLOTS", DEFAULT_FREE_SLOTS);
				player.setVar("SMELTING_SLOTS", String.valueOf(smeltingSlots + 1), -1);
				showChatWindow(player, 0, false);
			}
		}
		else if(cmd.startsWith("itemList"))
		{
			int slot = Integer.parseInt(st.nextToken());
			ResourceTemplate selectedResource = SmeltingManager.getInstance().getSelectedResource(player, slot);
			if(selectedResource != null)
			{
				return;
			}

			if(!SmeltingManager.getInstance().isCompleted(player, slot))
			{
				showItemSelectionWindow(player, slot);
			}
		}
		else if(cmd.startsWith("selResource"))
		{
			int slot = Integer.parseInt(st.nextToken());
			if(!st.hasMoreTokens())
			{
				return;
			}
			int resourceId = Integer.parseInt(st.nextToken());
			ResourceTemplate resource = ResourceHolder.getInstance().getResource(resourceId);
			if(resource == null)
			{
				return;
			}

			if(!SmeltingManager.getInstance().isAllIngredients(player, resource))
			{
				return;
			}

			// remove ingredients
			boolean allRemoved = true;
			for(ItemData ingredient : resource.getIngredients())
			{
				if(!DifferentMethods.getPay(player, ingredient.getId(), ingredient.getCount(), true))
				{
					allRemoved = false;
					break;
				}
			}

			if(allRemoved)
			{
				SmeltingManager.getInstance().setSelectedResource(player, resourceId, slot);
				SmeltingManager.getInstance().store(slot);
				showChatWindow(player, 0, false);
			}
			else
			{
				showItemSelectionWindow(player, slot);
			}
		}
		else if(cmd.startsWith("takeReward"))
		{
			int slot = Integer.parseInt(st.nextToken());
			ResourceTemplate resource = SmeltingManager.getInstance().getSelectedResource(player, slot);
			if(resource == null)
			{
				return;
			}

			boolean isCompleted = SmeltingManager.getInstance().isCompleted(player, slot);
			if(!isCompleted)
			{
				return;
			}

			// reset slot
			SmeltingManager.getInstance().reset(player, slot);

			// reward player
			if (resource.getProductionType().equals(ProductionType.RANDOMLY_ONE))
			{
				ItemData randomItem = Rnd.get(resource.getProduction());
				if (randomItem != null) {
					DifferentMethods.addItem(player, randomItem.getId(), randomItem.getCount());
				}
			}
			else
			{
				for(ItemData reward : resource.getProduction())
				{
					DifferentMethods.addItem(player, reward.getId(), reward.getCount());
				}
			}
		}
	}

	private void showItemSelectionWindow(Player player, int slot)
	{
		String html = HtmCache.getInstance().getHtml("mods/smelting/item_list.htm", player);
		html = html.replace("%itemList%", buildItemList(player, slot));
		player.sendPacket(new HtmlMessage(this).setHtml(html));
	}

	private String buildItemList(Player player, int slot)
	{
		StringBuilder sb = new StringBuilder();
		List<ResourceTemplate> resources = ResourceHolder.getInstance().getResources().stream().filter(template -> template.getSlot() == slot).collect(Collectors.toList());
		for(ResourceTemplate resource : resources)
		{
			String resourceHtm = HtmCache.getInstance().getHtml("mods/smelting/partials/resources/resource_tpl.htm", player);
			boolean allIngredients = SmeltingManager.getInstance().isAllIngredients(player, resource);
			resourceHtm = resourceHtm.replace("%info%", resource.getProductionType().equals(ProductionType.RANDOMLY_ONE) ? "<font color=\"FF0000\">Случайно</font> производит <font color=\"LEVEL\">один из предметов</font>: " : "Производит: ");
			resourceHtm = resourceHtm.replace("%resourceName%", resource.getName());
			resourceHtm = resourceHtm.replace("%selectAction%", !allIngredients ? "" : String.format(SELECT_ACTION_TPL, getObjectId(), slot, resource.getId()));

			StringBuilder prodSb = new StringBuilder();
			for(ItemData itemData : resource.getProduction())
			{
				boolean isRandomlyOne = resource.getProductionType().equals(ProductionType.RANDOMLY_ONE);
				String prodHtm = HtmCache.getInstance().getHtml("mods/smelting/partials/resources/" + (isRandomlyOne ? "production_rnd_tpl.htm" : "production_tpl.htm"), player);
				prodHtm = prodHtm.replace("%itemId%", String.valueOf(itemData.getId()));
				prodHtm = prodHtm.replace("%itemCnt%", String.valueOf(itemData.getCount()));
				prodSb.append(prodHtm);
			}

			StringBuilder ingredientSb = new StringBuilder();
			for(ItemData itemData : resource.getIngredients())
			{
				String ingredientHtm = HtmCache.getInstance().getHtml("mods/smelting/partials/resources/ingredient_tpl.htm", player);
				ingredientHtm = ingredientHtm.replace("%itemId%", String.valueOf(itemData.getId()));
				ingredientHtm = ingredientHtm.replace("%itemCnt%", String.valueOf(itemData.getCount()));
				ingredientHtm = ingredientHtm.replace("%availableCount%", buildIngredientDisplayCnt(player, itemData));
				ingredientSb.append(ingredientHtm);
			}

			resourceHtm = resourceHtm.replace("%productionList%", prodSb.toString());
			resourceHtm = resourceHtm.replace("%ingredientList%", ingredientSb.toString());
			sb.append(resourceHtm);
		}

		return sb.toString();
	}

	@Override
	public void showChatWindow(Player player, int val, boolean firstTalk, Object... replace)
	{
		String html = HtmCache.getInstance().getHtml("mods/smelting/partials/page_tpl.htm", player);
		html = html.replace("%slots%", player.getVar("SMELTING_SLOTS", String.valueOf(DEFAULT_FREE_SLOTS)));
		html = html.replace("%maxSlots%", String.valueOf(MAX_SLOTS));
		html = html.replace("%slotList%", buildSlotList(player));
		player.sendPacket(new HtmlMessage(this).setHtml(html));
	}

	private String buildProductionList(Player player, int slot, ResourceTemplate resource)
	{
		StringBuilder sb = new StringBuilder();
		ResourceTemplate selectedResource = SmeltingManager.getInstance().getSelectedResource(player, slot);
		if(selectedResource == null || selectedResource.getProduction().isEmpty())
		{
			return PRODUCTION_EMPTY_SLOT;
		}
		else
		{
			if (resource.getProductionType().equals(ProductionType.RANDOMLY_ONE))
			{
				StringBuilder itemList = new StringBuilder();
				for (ItemData itemInfo : resource.getProduction()) {
					itemList.append("\\n - ").append(ItemNameHolder.getInstance().getItemName(player, itemInfo.getId())).append(" x").append(itemInfo.getCount()).append(" шт");
				}
				return String.format(PRODUCTION_RANDOM_SLOT, itemList);
			}

			List<ItemData> production = resource.getProduction();
			for(ItemData itemData : production)
			{
				sb.append(String.format(PRODUCTION_SLOT, itemData.getId()));
			}
		}
		return sb.toString();
	}

	private String buildIngredientList(Player player, int slot, ResourceTemplate resource)
	{
		StringBuilder sb = new StringBuilder();

		// handle empty slot
		if(resource == null)
		{
			for(int i = 0; i < MAX_INGREDIENTS; i++)
			{
				sb.append(String.format(INGREDIENT_EMPTY_SLOT, getObjectId(), slot, i));
				if(i != MAX_INGREDIENTS - 1)
				{
					sb.append(SPACING);
				}
			}
			return sb.toString();
		}

		// handle completed slot
		List<ItemData> ingredients = resource.getIngredients();
		for(int i = 0; i < MAX_INGREDIENTS; i++)
		{
			if(i >= ingredients.size())
			{
				TaskState state = SmeltingManager.getInstance().getTaskStateForSlot(player, slot);
				// if task is active, and item does not exist for this slot = show blocked slot
				if(state == TaskState.ACTIVE || state == TaskState.COMPLETED)
				{
					sb.append(INGREDIENT_BLOCKED_SLOT);
				}
				else
				{
					sb.append(String.format(INGREDIENT_EMPTY_SLOT, getObjectId(), slot, i));
				}
				if(i != MAX_INGREDIENTS - 1)
				{
					sb.append(SPACING);
				}
				continue;
			}

			ItemData itemData = ingredients.get(i);
			if(itemData != null)
			{
				sb.append(String.format(INGREDIENT_DEFAULT_SLOT, itemData.getId()));
			}

			// add spacing except for last slot
			if(i != MAX_INGREDIENTS - 1)
			{
				sb.append(SPACING);
			}
		}
		return sb.toString();
	}

	private String buildAction(Player player, int slot)
	{
		String html = HtmCache.getInstance().getHtml("mods/smelting/partials/action_tpl.htm", player);
		TaskState state = SmeltingManager.getInstance().getTaskStateForSlot(player, slot);
		switch(state)
		{
			case NOT_STARTED:
				html = html.replace("%action%", "Start");
				break;
			case ACTIVE:
				html = html.replace("%action%", "Stop");
				break;
			case COMPLETED:
				html = html.replace("%action%", "Take");
				break;
		}
		return html;
	}

	private String buildSlotList(Player player)
	{
		StringBuilder sb = new StringBuilder();
		HtmCache instance = HtmCache.getInstance();
		// iterate over slots and build html
		for(int slot = 1; slot < (MAX_SLOTS + 1); slot++)
		{
			TaskState state = SmeltingManager.getInstance().getTaskStateForSlot(player, slot);
			int playerSlots = player.getVarInt("SMELTING_SLOTS",DEFAULT_FREE_SLOTS);
			if(slot > playerSlots && state.equals(TaskState.NOT_EXISTS))
			{
				String slotTpl = instance.getHtml("mods/smelting/partials/locked_slot.htm", player);
				slotTpl = slotTpl.replace("%unlockBypass%", String.format(UNLOCK_BYPASS, getObjectId(), slot));
				slotTpl = slotTpl.replace("%openPrice%", buildUnlockPrice(player, slot));
				sb.append(slotTpl);
			}
			else
			{
				String slotTpl = instance.getHtml("mods/smelting/partials/slot_tpl.htm", player);
				ResourceTemplate resource = SmeltingManager.getInstance().getSelectedResource(player, slot);
				// build slot html
				slotTpl = slotTpl.replace("%description%", buildDescription(player, slot));
				slotTpl = slotTpl.replace("%ingredientList%", buildIngredientList(player, slot, resource));
				slotTpl = slotTpl.replace("%action%", buildAction(player, slot));
				slotTpl = slotTpl.replace("%status%", buildStatus(player, slot));
				slotTpl = slotTpl.replace("%tooltipText%", buildActionName(player, slot));
				slotTpl = slotTpl.replace("%actionBypass%", buildBypass(player, slot));
				slotTpl = slotTpl.replace("%actionIcon%", buildIcon(player, slot));
				slotTpl = slotTpl.replace("%productionList%", buildProductionList(player, slot, resource));

				sb.append(slotTpl);
			}
		}

		return sb.toString();
	}

	private String buildUnlockPrice(Player player, int slot)
	{
		StringBuilder sb = new StringBuilder();
		List<ItemData> unlockPrice = ResourceHolder.getInstance().getUnlockPrice(player, slot);
		for(int i = 0; i < unlockPrice.size(); i++)
		{
			ItemData itemData = unlockPrice.get(i);
			sb.append("&#").append(itemData.getId()).append(";").append(" ").append(itemData.getCount()).append(" шт.");
			if(i != unlockPrice.size() - 1)
			{
				sb.append(", ");
			}
		}
		return sb.toString();
	}

	private String buildActionName(Player player, int slot)
	{
		String message = "";
		final int currSlots = player.getVarInt("SMELTING_SLOTS", 1);
		final boolean isBought = slot > DEFAULT_FREE_SLOTS && currSlots >= slot;
		TaskState state = SmeltingManager.getInstance().getTaskStateForSlot(player, slot);
		switch(state)
		{
			case NOT_EXISTS:
			case NOT_STARTED:
				if(!isBought)
				{
					message = "";
					break;
				}
				message = "Пустой слот\nНажмите, что бы добавить предмет.";
				break;
			case ACTIVE:
				message = "Выполняется процесс переплавки.";
				break;
			case COMPLETED:
				message = "Забрать результат переплавки.";
				break;
		}

		return message;
	}

	private String buildIcon(Player player, int slot)
	{
		TaskState state = SmeltingManager.getInstance().getTaskStateForSlot(player, slot);
		String iconPath = "";
		switch(state)
		{
			case NOT_EXISTS:
			case NOT_STARTED:
				iconPath = "L2UI_CT1.BtnPaste";
				break;
			case ACTIVE:
				iconPath = "L2UI_CT1.AutoPartyMatchingWnd_DF_LoadingAni_01";
				break;
			case COMPLETED:
				iconPath = "L2UI_CT1.24Hz_DF_ChannelControlBtn_Next";
				break;
		}

		return iconPath;
	}

	private String buildBypass(Player player, int slot)
	{
		String bypass = "";
		final int currSlots = player.getVarInt("SMELTING_SLOTS", DEFAULT_FREE_SLOTS);
		final boolean isBought = slot > DEFAULT_FREE_SLOTS && currSlots >= slot;
		TaskState state = SmeltingManager.getInstance().getTaskStateForSlot(player, slot);
		switch(state)
		{
			// TODO: add bypass for buying slots
			// active state is always with empty bypass
			case ACTIVE:
				bypass = "";
				break;
			case NOT_EXISTS:
			case NOT_STARTED:
				if(slot > DEFAULT_FREE_SLOTS && !isBought)
				{
					bypass = "";
					break;
				}
				bypass = String.format("bypass -h npc_%d_itemList_%d", getObjectId(), slot);
				break;
			case COMPLETED:
				bypass = String.format("bypass -h npc_%d_takeReward_%d", getObjectId(), slot);
				break;
		}
		return bypass;
	}

	private String buildStatus(Player player, int slot)
	{
		final int currSlots = player.getVarInt("SMELTING_SLOTS", DEFAULT_FREE_SLOTS);
		final boolean isBought = slot > DEFAULT_FREE_SLOTS && currSlots >= slot;
		TaskState state = SmeltingManager.getInstance().getTaskStateForSlot(player, slot);
		String stateStr = "";
		switch(state)
		{
			case NOT_EXISTS:
			case NOT_STARTED:
				if(slot > DEFAULT_FREE_SLOTS && !isBought)
				{
					stateStr = "<font color=\"FF0000\">Locked</font>";
					break;
				}
				stateStr = "<font color=\"a9a9a9\">Not Started</font>";
				break;
			case ACTIVE:
				stateStr = "<font color=\"FFA500\">Active</font>";
				break;
			case COMPLETED:
				stateStr = "<font color=\"00FF00\">Completed</font>";
				break;
			default:
				stateStr = "<font color=\"a9a9a9\">Unknown</font>";
				break;
		}

		return stateStr;
	}

	private String buildDescription(Player player, int slot)
	{
		final int currSlots = player.getVarInt("SMELTING_SLOTS", DEFAULT_FREE_SLOTS);
		final boolean isBought = slot > DEFAULT_FREE_SLOTS && currSlots >= slot;
		TaskState state = SmeltingManager.getInstance().getTaskStateForSlot(player, slot);
		String description = "";

		switch(state)
		{
			case NOT_EXISTS:
			case NOT_STARTED:
				if(slot <= DEFAULT_FREE_SLOTS || isBought)
				{
					description = SLOT_READY_TPL;
				}
				else
				{
					description = UNAVAILABLE_TPL;
				}
				break;
			case COMPLETED:
			case ACTIVE:
				String remainingTime = SmeltingManager.getInstance().getRemainingTime(player, slot);
				description = String.format(REMAINING_TIME_TPL, remainingTime);
				break;
			default:
				description = SLOT_READY_TPL;
				break;
		}

		return description;
	}
}
