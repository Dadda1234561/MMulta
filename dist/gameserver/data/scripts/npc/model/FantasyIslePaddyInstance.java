package npc.model;

import java.util.StringTokenizer;

import l2s.commons.collections.MultiValueSet;
import l2s.gameserver.model.Player;
import l2s.gameserver.model.instances.NpcInstance;
import l2s.gameserver.model.items.ItemInstance;
import l2s.gameserver.model.items.PcInventory;
import l2s.gameserver.templates.npc.NpcTemplate;
import l2s.gameserver.utils.ItemFunctions;

import org.apache.commons.lang3.ArrayUtils;
import org.napile.primitive.maps.IntObjectMap;
import org.napile.primitive.maps.impl.HashIntObjectMap;

/**
 * @author Bonux
 */
public class FantasyIslePaddyInstance extends NpcInstance
{
	// Item's
	private static final int SHINY_ELEMENTAL_SHIRT_EXCHANGE_STONE = 37723;	// Камень Обмена Сияющей Футболки Эйнхасад
	private static final int PAAGRIO_SHIRT_1 = 23240;	// Футболка Паагрио
	private static final int SAYHAS_SHIRT_1 = 23301;	// Футболка Сайхи
	private static final int EVAS_SHIRT_1 = 23304;	// Футболка Евы
	private static final int MAPHRS_SHIRT_1 = 23307;	// Футболка Мафр
	private static final int PAAGRIO_SHIRT_2 = 34623;	// Футболка Паагрио
	private static final int SAYHAS_SHIRT_2 = 34624;	// Футболка Сайхи
	private static final int EVAS_SHIRT_2 = 34625;	// Футболка Евы
	private static final int MAPHRS_SHIRT_2 = 34626;	// Футболка Мафр
	private static final int PAAGRIO_SHIRT_3 = 34770;	// Футболка Паагрио
	private static final int SAYHAS_SHIRT_3 = 34771;	// Футболка Сайхи
	private static final int EVAS_SHIRT_3 = 34772;	// Футболка Евы
	private static final int MAPHRS_SHIRT_3 = 34773;	// Футболка Мафр
	private static final int PHYSICAL_REFLECT_SHIRT = 46193;	// Футболка Отражения Атаки
	private static final int MAGICAL_REFLECT_SHIRT = 46194;	// Футболка Отражения Магии
	private static final int SHINY_ELEMENTAL_SHIRT = 37718;	// Сияющая Футболка Эйнхасад

	private static final IntObjectMap<int[]> PAAGRIO_EXCHANGE_MAP = new HashIntObjectMap<int[]>();
	private static final IntObjectMap<int[]> SAYHAS_EXCHANGE_MAP = new HashIntObjectMap<int[]>();
	private static final IntObjectMap<int[]> EVAS_EXCHANGE_MAP = new HashIntObjectMap<int[]>();
	private static final IntObjectMap<int[]> MAPHRS_EXCHANGE_MAP = new HashIntObjectMap<int[]>();
	static
	{
		// TODO: Должны ли обмениваться Ивентовые рубашки?!?
		PAAGRIO_EXCHANGE_MAP.put(PAAGRIO_SHIRT_1, new int[]{ SHINY_ELEMENTAL_SHIRT_EXCHANGE_STONE, 7 });
		SAYHAS_EXCHANGE_MAP.put(SAYHAS_SHIRT_1, new int[]{ SHINY_ELEMENTAL_SHIRT_EXCHANGE_STONE, 7 });
		EVAS_EXCHANGE_MAP.put(EVAS_SHIRT_1, new int[]{ SHINY_ELEMENTAL_SHIRT_EXCHANGE_STONE, 7 });
		MAPHRS_EXCHANGE_MAP.put(MAPHRS_SHIRT_1, new int[]{ SHINY_ELEMENTAL_SHIRT_EXCHANGE_STONE, 7 });
		PAAGRIO_EXCHANGE_MAP.put(PAAGRIO_SHIRT_2, new int[]{ SHINY_ELEMENTAL_SHIRT_EXCHANGE_STONE, 7 });
		SAYHAS_EXCHANGE_MAP.put(SAYHAS_SHIRT_2, new int[]{ SHINY_ELEMENTAL_SHIRT_EXCHANGE_STONE, 7 });
		EVAS_EXCHANGE_MAP.put(EVAS_SHIRT_2, new int[]{ SHINY_ELEMENTAL_SHIRT_EXCHANGE_STONE, 7 });
		MAPHRS_EXCHANGE_MAP.put(MAPHRS_SHIRT_2, new int[]{ SHINY_ELEMENTAL_SHIRT_EXCHANGE_STONE, 7 });
		PAAGRIO_EXCHANGE_MAP.put(PAAGRIO_SHIRT_3, new int[]{ SHINY_ELEMENTAL_SHIRT_EXCHANGE_STONE, 7 });
		SAYHAS_EXCHANGE_MAP.put(SAYHAS_SHIRT_3, new int[]{ SHINY_ELEMENTAL_SHIRT_EXCHANGE_STONE, 7 });
		EVAS_EXCHANGE_MAP.put(EVAS_SHIRT_3, new int[]{ SHINY_ELEMENTAL_SHIRT_EXCHANGE_STONE, 7 });
		MAPHRS_EXCHANGE_MAP.put(MAPHRS_SHIRT_3, new int[]{ SHINY_ELEMENTAL_SHIRT_EXCHANGE_STONE, 7 });
	}

	public FantasyIslePaddyInstance(int objectId, NpcTemplate template, MultiValueSet<String> set)
	{
		super(objectId, template, set);
	}

	@Override
	public void onBypassFeedback(Player player, String command)
	{
		StringTokenizer st = new StringTokenizer(command, "_");
		String cmd = st.nextToken();
		if(cmd.equals("exchangeshirt"))
		{
			if(!st.hasMoreTokens())
				return;

			int shirtType = Integer.parseInt(st.nextToken());

			IntObjectMap<int[]> exchangeMap;
			switch(shirtType)
			{
				case 1:
					exchangeMap = PAAGRIO_EXCHANGE_MAP;
					break;
				case 2:
					exchangeMap = SAYHAS_EXCHANGE_MAP;
					break;
				case 3:
					exchangeMap = EVAS_EXCHANGE_MAP;
					break;
				case 4:
					exchangeMap = MAPHRS_EXCHANGE_MAP;
					break;
				default:
					return;
			}

			PcInventory inventory = player.getInventory();

			inventory.writeLock();
			try
			{
				for(ItemInstance item : inventory.getItems())
				{
					int[] info = exchangeMap.get(item.getItemId());
					if(info == null || info.length < 2)
						continue;

					if(item.getEnchantLevel() == info[1]) // TODO: Должна ли быть четко указанная заточка или можно больше?
					{
						ItemFunctions.deleteItem(player, item, 1);
						ItemFunctions.addItem(player, info[0], 1);
						// TODO: Должно ли тут быть сообщение?
						return;
					}
				}
				showChatWindow(player, "Town/FantasyIsle/" + getNpcId() + "-no_shirt.htm", false);
			}
			finally
			{
				inventory.writeUnlock();
			}
		}
		else if(cmd.equals("upgradeshirt"))
		{
			if(!st.hasMoreTokens())
				return;

			int shirtType = Integer.parseInt(st.nextToken());

			int[] itemIds;
			switch(shirtType)
			{
				case 1:
					itemIds = PAAGRIO_EXCHANGE_MAP.keys();
					break;
				case 2:
					itemIds = SAYHAS_EXCHANGE_MAP.keys();
					break;
				case 3:
					itemIds = EVAS_EXCHANGE_MAP.keys();
					break;
				case 4:
					itemIds = MAPHRS_EXCHANGE_MAP.keys();
					break;
				case 5:
					itemIds = new int[]{ PHYSICAL_REFLECT_SHIRT };
					break;
				case 6:
					itemIds = new int[]{ MAGICAL_REFLECT_SHIRT };
					break;
				case 7:
					itemIds = new int[]{ SHINY_ELEMENTAL_SHIRT };
					break;
				default:
					return;
			}

			PcInventory inventory = player.getInventory();

			inventory.writeLock();
			try
			{
				for(ItemInstance item : inventory.getItems())
				{
					if(!ArrayUtils.contains(itemIds, item.getItemId()))
						continue;

					if(item.getEnchantLevel() == 8) // TODO: Должна ли быть четко указанная заточка или можно больше?
					{
						if(!ItemFunctions.deleteItem(player, SHINY_ELEMENTAL_SHIRT_EXCHANGE_STONE, 1))
						{
							showChatWindow(player, "Town/FantasyIsle/" + getNpcId() + "-no_shirt_upgrade.htm", false);
							return;
						}
						ItemFunctions.deleteItem(player, item, 1);
						ItemFunctions.addItem(player, item.getItemId(), 1, 10, true);
						// TODO: Должно ли тут быть сообщение?
						return;
					}
				}
				showChatWindow(player, "Town/FantasyIsle/" + getNpcId() + "-no_shirt_upgrade.htm", false);
			}
			finally
			{
				inventory.writeUnlock();
			}
		}

		else if(cmd.equals("upgradeshirt1"))
		{
			ItemInstance item = player.getInventory().getItemByItemId(46193);//футболка отражения атаки
					if(item!=null && item.getEnchantLevel() == 10 && player.getAdena()>1000000000)
					{
						ItemFunctions.deleteItem(player, 46193, 1);
						ItemFunctions.deleteItem(player, 57, 1000000000);
						ItemFunctions.addItem(player, 48491, 1, 0, true);//необработанная кожа
						showChatWindow(player, "Town/FantasyIsle/" + getNpcId() + "-upgradedone.htm", false);
						return;
					}
					else{
						showChatWindow(player, "Town/FantasyIsle/" + getNpcId() + "-no_shirtadena.htm", false);
						return;
					}
		}
		else if(cmd.equals("upgradeshirt2"))
		{
			ItemInstance item = player.getInventory().getItemByItemId(46194);//футболка отражения магии
			if(item!=null && item.getEnchantLevel() == 10 && player.getAdena()>1000000000)
			{
				ItemFunctions.deleteItem(player, 46194, 1);
				ItemFunctions.deleteItem(player, 57, 1000000000);
				ItemFunctions.addItem(player, 48491, 1, 0, true);//необработанная кожа
				showChatWindow(player, "Town/FantasyIsle/" + getNpcId() + "-upgradedone.htm", false);
				return;
			}
			else{
				showChatWindow(player, "Town/FantasyIsle/" + getNpcId() + "-no_shirtadena.htm", false);
				return;
			}
		}
		else if(cmd.equals("upgradeshirt3"))
		{
			ItemInstance item = player.getInventory().getItemByItemId(37718);//футболка отражения атаки
			if(item!=null && item.getEnchantLevel() == 10 && player.getAdena()>1000000000)
			{
				ItemFunctions.deleteItem(player, 37718, 1);
				ItemFunctions.deleteItem(player, 57, 1000000000);
				ItemFunctions.addItem(player, 48491, 1, 0, true);//необработанная кожа
				showChatWindow(player, "Town/FantasyIsle/" + getNpcId() + "-upgradedone.htm", false);
				return;
			}
			else{
				showChatWindow(player, "Town/FantasyIsle/" + getNpcId() + "-no_shirtadena.htm", false);
				return;
			}
		}


		else if(cmd.equals("change1"))
		{
			ItemInstance item = player.getInventory().getItemByItemId(46193);//футболка отражения атаки
			if(item!=null && item.getEnchantLevel() == 10)
			{
				ItemFunctions.deleteItem(player, 46193, 1);
				ItemFunctions.addItem(player, 48495, 1, 0, true);
				showChatWindow(player, "Town/FantasyIsle/" + getNpcId() + "-upgradedone.htm", false);
				return;
			}
			else{
				showChatWindow(player, "Town/FantasyIsle/" + getNpcId() + "-no_shirtadena1.htm", false);
				return;
			}
		}
		else if(cmd.equals("change2"))
		{
			ItemInstance item = player.getInventory().getItemByItemId(46194);//футболка отражения магии
			if(item!=null && item.getEnchantLevel() == 10)
			{
				ItemFunctions.deleteItem(player, 46194, 1);
				ItemFunctions.addItem(player, 48495, 1, 0, true);
				showChatWindow(player, "Town/FantasyIsle/" + getNpcId() + "-upgradedone.htm", false);
				return;
			}
			else{
				showChatWindow(player, "Town/FantasyIsle/" + getNpcId() + "-no_shirtadena1.htm", false);
				return;
			}
		}
		else if(cmd.equals("change3"))
		{
			ItemInstance item = player.getInventory().getItemByItemId(37718);//футболка отражения атаки
			if(item!=null && item.getEnchantLevel() == 10)
			{
				ItemFunctions.deleteItem(player, 37718, 1);
				ItemFunctions.addItem(player, 48495, 1, 0, true);
				showChatWindow(player, "Town/FantasyIsle/" + getNpcId() + "-upgradedone.htm", false);
				return;
			}
			else{
				showChatWindow(player, "Town/FantasyIsle/" + getNpcId() + "-no_shirtadena1.htm", false);
				return;
			}
		}

		else
			super.onBypassFeedback(player, command);
	}
}
