package l2s.gameserver.network.l2.s2c;

import java.util.ArrayList;
import java.util.List;

import l2s.gameserver.Config;
import l2s.gameserver.data.xml.holder.ItemHolder;
import l2s.gameserver.model.MultiSellListContainer;
import l2s.gameserver.model.base.MultiSellEntry;
import l2s.gameserver.model.base.MultiSellIngredient;
import l2s.gameserver.templates.item.ItemTemplate;

public class MultiSellListPacket extends L2GameServerPacket
{
	private final int _page;
	private final int _finished;
	private final int _listId;
	private final int _type;
	private final List<MultiSellEntry> _list;

	public MultiSellListPacket(MultiSellListContainer list, int page, int finished)
	{
		_list = list.getEntries();
		_listId = list.getListId();
		_type = list.getType().ordinal();
		_page = page;
		_finished = finished;
	}


	private enum MultisellShowType
	{
		NORMAL,
		MATERIAL_TYPE,
		GOODS_EXCHANGE,
		ENCHANT_SCROLL
	}


	/*
		enum MULTISELLSHOWTYPE
		{
			Normal,
			MaterialType,
			GOODSEXCHANGE,
			ENCHANTSCROLL
		};
	 */

	@Override
	protected final void writeImpl()
	{
		writeC(0); // ShowAll
		writeD(_listId); // MultiSellGroupID
		writeC(MultisellShowType.NORMAL.ordinal()); // ShowType
		writeD(_page); // nPage
		writeD(_finished); // nMaxPage
		writeD(Config.MULTISELL_SIZE); // size of pages
		writeD(_list.size()); // list length
		writeC(0x00); // [TODO]: Grand Crusade
		writeC(_type); //Type (0x00 - Нормальный, 0xD0 - с шансом)
		writeD(0x20); // UNK
		List<MultiSellIngredient> ingredients;
		for(MultiSellEntry ent : _list)
		{
			ingredients = ent.getIngredients();
			writeD(ent.getEntryId()); // nMultiSellInfoID
			writeC(!ent.getProduction().isEmpty() && ent.getProduction().get(0).isStackable() ? 1 : 0); // nBuyType
			writeH(0x00); // Enchanted
			writeItemAugment();
			writeItemElements();
			writeItemEnsoul();
			writeC(0x00); // isBlessed

			writeH(ent.getProduction().size());
			writeH(ingredients.size());

			for(MultiSellIngredient prod : ent.getProduction())
			{
				int itemId = prod.getItemId();
				ItemTemplate template = itemId > 0 ? ItemHolder.getInstance().getTemplate(prod.getItemId()) : null;
				if (template != null)
				{
					writeD(template.getItemId());
					writeQ(template.getBodyPart());
					writeH(template.getType2());
				}
				else
				{
					writeD(prod.getItemId());
					writeQ(0);
					writeH(65535);
				}

				writeQ(prod.getItemCount());
				writeH(prod.getItemEnchant());
				writeD(prod.getChance());
				writeItemAugment(prod);
				writeItemElements(prod);
				writeItemEnsoul(prod);
				writeC(0x00); // isBlessed
			}

			for(MultiSellIngredient i : ingredients)
			{
				int itemId = i.getItemId();
				final ItemTemplate item = itemId > 0 ? ItemHolder.getInstance().getTemplate(i.getItemId()) : null;
				if (item != null)
				{
					writeD(item.getItemId());
					writeH(item.getType2());
				}
				else
				{
					writeD(i.getItemId());
					writeH(65535);
				}

				writeQ(i.getItemCount()); //Count
				writeH(i.getItemEnchant()); //Enchant Level
				writeItemAugment(i);
				writeItemElements(i);
				writeItemEnsoul(i);
				writeC(0x00);
			}
		}
	}

	//FIXME временная затычка, пока NCSoft не починят в клиенте отображение мультиселов где кол-во больше Integer.MAX_VALUE
	private static List<MultiSellIngredient> fixIngredients(List<MultiSellIngredient> ingredients)
	{
		int needFix = 0;
		for(MultiSellIngredient ingredient : ingredients)
			if(ingredient.getItemCount() > Integer.MAX_VALUE)
				needFix++;

		if(needFix == 0)
			return ingredients;

		MultiSellIngredient temp;
		List<MultiSellIngredient> result = new ArrayList<MultiSellIngredient>(ingredients.size() + needFix);
		for(MultiSellIngredient ingredient : ingredients)
		{
			ingredient = ingredient.clone();
			while(ingredient.getItemCount() > Integer.MAX_VALUE)
			{
				temp = ingredient.clone();
				temp.setItemCount(2000000000);
				result.add(temp);
				ingredient.setItemCount(ingredient.getItemCount() - 2000000000);
			}
			if(ingredient.getItemCount() > 0)
				result.add(ingredient);
		}

		return result;
	}
}