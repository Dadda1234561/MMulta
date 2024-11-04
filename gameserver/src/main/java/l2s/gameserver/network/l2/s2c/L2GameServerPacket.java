package l2s.gameserver.network.l2.s2c;

import l2s.commons.net.nio.impl.SendablePacket;
import l2s.gameserver.GameServer;
import l2s.gameserver.data.xml.holder.ItemHolder;
import l2s.gameserver.model.Player;
import l2s.gameserver.model.base.Element;
import l2s.gameserver.model.base.MultiSellIngredient;
import l2s.gameserver.model.items.ItemInfo;
import l2s.gameserver.model.items.ItemInstance;
import l2s.gameserver.model.items.LockType;
import l2s.gameserver.network.l2.GameClient;
import l2s.gameserver.network.l2.ServerPacketOpcodes;
import l2s.gameserver.network.l2.s2c.custom.SExCustomOpcode;
import l2s.gameserver.network.l2.s2c.updatetype.IUpdateTypeComponent;
import l2s.gameserver.network.l2.components.IBroadcastPacket;
import l2s.gameserver.templates.item.ItemTemplate;
import l2s.gameserver.templates.item.support.Ensoul;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

public abstract class L2GameServerPacket extends SendablePacket<GameClient> implements IBroadcastPacket
{
	private static final int IS_AUGMENTED = 1 << 0;
	private static final int IS_ELEMENTED = 1 << 1;
	private static final int VISUAL_CHANGED = 1 << 2;
	private static final int HAVE_ENSOUL = 1 << 3;
	private static final int USAGE_LIMIT = 1 << 4;
	private static final int PET_EVOLVE = 1 << 5;
	private static final int IS_BLESSED = 1 << 6;

	private static final int NORMAL_ENSOUL_SIZE = 2;
	private static final int SPECIAL_ENSOUL_SIZE = 1;

	protected static final Logger _log = LoggerFactory.getLogger(L2GameServerPacket.class);

	@Override
	public final boolean write()
	{
		if(!canWrite())
			return false;

		try
		{
			if(writeOpcodes())
			{
				writeImpl();
				return true;
			}
		}
		catch(Exception e)
		{
			_log.error("Client: " + getClient() + " - Failed writing: " + getType() + " - Server Version: " + GameServer.getInstance().getVersion().getRevisionNumber(), e);
		}
		return false;
	}

	protected ServerPacketOpcodes getOpcodes()
	{
		try
		{
			return ServerPacketOpcodes.valueOf(getClass().getSimpleName());
		}
		catch(Exception e)
		{
			_log.error("Cannot find serverpacket opcode: " + getClass().getSimpleName() + "!");
		}
		return null;
	}

	protected boolean writeOpcodes()
	{
		ServerPacketOpcodes opcodes = getOpcodes();
		if(opcodes == null)
			return false;

		writeC(opcodes.getId());

		int exOpcode = opcodes.getExId();
		if(exOpcode >= 0)
			writeH(exOpcode);

		return true;
	}

	protected abstract void writeImpl();

	protected boolean canWrite()
	{
		return true;
	}

	protected boolean canWrite(Player player)
	{
		return canWrite();
	}

	protected void writeD(boolean b)
	{
		writeD(b ? 1 : 0);
	}

	protected void writeH(boolean b)
	{
		writeH(b ? 1 : 0);
	}

	protected void writeC(boolean b)
	{
		writeC(b ? 1 : 0);
	}

	protected void writeC(SExCustomOpcode opcode)
	{
		writeC(opcode.ordinal());
	}

	/**
	 * Отсылает число позиций + массив
	 */
	protected void writeDD(int[] values, boolean sendCount)
	{
		if(sendCount)
			getByteBuffer().putInt(values.length);
		for(int value : values)
			getByteBuffer().putInt(value);
	}

	protected void writeDD(int[] values)
	{
		writeDD(values, false);
	}

	protected void writeOptionalD(int value)
	{
		if(value >= Short.MAX_VALUE)
		{
			writeH(Short.MAX_VALUE);
			writeD(value);
		}
		else
			writeH(value);
	}

	protected void writeItemInfo(ItemInstance item)
	{
		writeItemInfo(null, item, item.getCount());
	}

	protected void writeItemInfo(Player player, ItemInstance item)
	{
		writeItemInfo(player, item, item.getCount());
	}

	protected void writeItemInfo(ItemInstance item, long count)
	{
		writeItemInfo(null, item, count);
	}

	protected void writeItemInfo(Player player, ItemInstance item, long count)
	{
		int flags = 0;

		if(item.isAugmented())
			flags |= IS_AUGMENTED;

		int attackElementValue = item.getAttackElementValue();
		int defenceFire = item.getDefenceFire();
		int defenceWater = item.getDefenceWater();
		int defenceWind = item.getDefenceWind();
		int defenceEarth = item.getDefenceEarth();
		int defenceHoly = item.getDefenceHoly();
		int defenceUnholy = item.getDefenceUnholy();
		if(attackElementValue > 0 || defenceFire > 0 || defenceWater > 0 || defenceWind > 0 || defenceEarth > 0 || defenceHoly > 0 || defenceUnholy > 0)
			flags |= IS_ELEMENTED;

		if(item.getVisualId() > 0)
			flags |= VISUAL_CHANGED;

		if(!item.getNormalEnsoulsMap().isEmpty() || !item.getSpecialEnsoulsMap().isEmpty())
			flags |= HAVE_ENSOUL;

		if (player != null && (item.getUsedCnt() > 0))
		{
			flags |= USAGE_LIMIT;
		}

//		if(player != null) {
//			TimeStamp sts = player.getSharedGroupReuse(item.getTemplate().getReuseGroup());
//			if(sts != null && sts.hasNotPassed()) {
//				reuseTimeleft = (int) sts.getReuseCurrent();
//				if(reuseTimeleft > 0)
//					flags |= REUSE_DELAY;
//			}
//		}

		/*
			final boolean isPetCollar = item.getItemType().equals(EtcItemTemplate.EtcItemType.PET_COLLAR);
			if (isPetCollar) {
				// get evolve info
			}

			if (item.isBlessed())
				flags |= IS_BLESSED;
		 */


		writeH(flags);
		writeD(item.getObjectId());
		writeD(item.getItemId());
		writeC(item.isEquipped() ? -1 : item.getEquipSlot());
		writeQ(count);
		writeC(item.getTemplate().getType2());
		writeC(item.getCustomType1());
		writeH(item.isEquipped() ? 1 : 0);
		writeQ(item.getTemplate().getBodyPart());
		writeH(item.getEnchantLevel());
		writeD(item.getShadowLifeTime());
		writeC(item.getCustomType2());
		writeD(item.getTemporalLifeTime());
		writeC(!item.getTemplate().isBlocked(player, item));
		writeC(0x00); // bSecurityLockable
		writeC(0x00); // bSecurityLock

		if((flags & IS_AUGMENTED) == IS_AUGMENTED)
		{
			writeD(item.getVariation1Id());
			writeD(item.getVariation2Id());
		}

		if((flags & IS_ELEMENTED) == IS_ELEMENTED)
		{
			writeH(item.getAttackElement().getId());
			writeH(attackElementValue);
			writeH(defenceFire);
			writeH(defenceWater);
			writeH(defenceWind);
			writeH(defenceEarth);
			writeH(defenceHoly);
			writeH(defenceUnholy);
		}

		if((flags & VISUAL_CHANGED) == VISUAL_CHANGED)
			writeD(item.getVisualId());

		if((flags & HAVE_ENSOUL) == HAVE_ENSOUL)
		{
			writeC(NORMAL_ENSOUL_SIZE);
			for (int i = 1; i <= NORMAL_ENSOUL_SIZE; i++)
			{
				Ensoul ensoul = item.getNormalEnsoulsMap().getOrDefault(i, null);
				writeD(ensoul == null ? 0x00 : ensoul.getId());
			}

			writeC(SPECIAL_ENSOUL_SIZE);
			for (int i = 1; i <= SPECIAL_ENSOUL_SIZE; i++)
			{
				Ensoul ensoul = item.getSpecialEnsoulsMap().getOrDefault(i, null);
				writeD(ensoul == null ? 0x00 : ensoul.getId());
			}

		}

		if((flags & USAGE_LIMIT) == USAGE_LIMIT)
		{
			writeH(item.getUsedCnt());
		}


		/*
			if ((flags & PET_EVOLVE) == PET_EVOLVE)
				writePetEvolve(item);

			if ((flags & IS_BLESSED) == IS_BLESSED)
				writeC(item.isBlessed());
	 	*/
	}

	protected void writePetEvolve(ItemInstance item)
	{

	}

	protected void writePetEvolve(ItemInfo item)
	{

	}

	protected void writeItemInfo(ItemInfo item)
	{
		writeItemInfo(item, item.getCount());
	}

	protected void writeItemInfo(ItemInfo item, long count)
	{
		int flags = 0;

		if(item.getVariation1Id() > 0 || item.getVariation2Id() > 0)
			flags |= IS_AUGMENTED;

		int attackElementValue = item.getAttackElementValue();
		int defenceFire = item.getDefenceFire();
		int defenceWater = item.getDefenceWater();
		int defenceWind = item.getDefenceWind();
		int defenceEarth = item.getDefenceEarth();
		int defenceHoly = item.getDefenceHoly();
		int defenceUnholy = item.getDefenceUnholy();
		if(attackElementValue > 0 || defenceFire > 0 || defenceWater > 0 || defenceWind > 0 || defenceEarth > 0 || defenceHoly > 0 || defenceUnholy > 0)
			flags |= IS_ELEMENTED;

		if(item.getVisualId() > 0)
			flags |= VISUAL_CHANGED;

		if(!item.getNormalEnsouls().isEmpty() || !item.getSpecialEnsouls().isEmpty())
			flags |= HAVE_ENSOUL;

		if (item.getUsedCnt() > 0) {
			flags |= USAGE_LIMIT;
		}

		/*
			// Pet Evolve

			// Blessed
			if (item.isBlessed())
				flags |= IS_BLESSED;
		 */

		writeH(flags);
		writeD(item.getObjectId());
		writeD(item.getItemId());
		writeC(item.isEquipped() ? -1 : item.getEquipSlot());
		writeQ(count);
		writeC(item.getItem().getType2());
		writeC(item.getCustomType1());
		writeH(item.isEquipped() ? 1 : 0);
		writeQ(item.getItem().getBodyPart());
		writeH(item.getEnchantLevel());
		writeD(item.getShadowLifeTime());
		writeC(item.getCustomType2());
		writeD(item.getTemporalLifeTime());
		writeC(!item.isBlocked());
		writeC(0x00);
		writeC(0x00);

		if((flags & IS_AUGMENTED) == IS_AUGMENTED)
		{
			writeD(item.getVariation1Id());
			writeD(item.getVariation2Id());
		}

		if((flags & IS_ELEMENTED) == IS_ELEMENTED)
		{
			writeH(item.getAttackElement());
			writeH(attackElementValue);
			writeH(defenceFire);
			writeH(defenceWater);
			writeH(defenceWind);
			writeH(defenceEarth);
			writeH(defenceHoly);
			writeH(defenceUnholy);
		}

		if((flags & VISUAL_CHANGED) == VISUAL_CHANGED)
			writeD(item.getVisualId());

		if((flags & HAVE_ENSOUL) == HAVE_ENSOUL)
		{
			writeC(NORMAL_ENSOUL_SIZE);
			for (int i = 1; i <= NORMAL_ENSOUL_SIZE; i++)
			{
				Ensoul ensoul = item.getNormalEnsouls().getOrDefault(i, null);
				writeD(ensoul == null ? 0 : ensoul.getId());
			}

			writeC(SPECIAL_ENSOUL_SIZE);
			for (int i = 1; i <= SPECIAL_ENSOUL_SIZE; i++)
			{
				Ensoul ensoul = item.getSpecialEnsouls().getOrDefault(i, null);
				writeD(ensoul == null ? 0 : ensoul.getId());
			}
		}

		if((flags & USAGE_LIMIT) == USAGE_LIMIT)
		{
			writeH(item.getUsedCnt());
		}

		/*
			if((flags & PET_EVOLVE) == PET_EVOLVE)
				writePetEvolve(item);

			if((flags & IS_BLESSED) == IS_BLESSED)
				writeC(item.isBlessed());
		 */
	}

	protected void writeItemAugment()
	{
		writeD(0);
		writeD(0);
	}

	protected void writeItemAugment(MultiSellIngredient item)
	{
		writeD(0);
		writeD(0);
	}

	protected void writeItemEnsoul()
	{
		writeC(0);
		writeC(0);
	}

	protected void writeItemEnsoul(MultiSellIngredient item)
	{
		writeC(0);
//		for(Ensoul ensoul : normalEnsouls)
//			writeD(ensoul.getId());

		writeC(0);
//		for(Ensoul ensoul : specialEnsouls)
//			writeD(ensoul.getId());
	}

	protected void writeItemElements(MultiSellIngredient item)
	{
		if(item.getItemId() <= 0)
		{
			writeItemElements();
			return;
		}
		ItemTemplate i = ItemHolder.getInstance().getTemplate(item.getItemId());
		if(item.getItemAttributes().getValue() > 0)
		{
			if(i.isWeapon())
			{
				Element e = item.getItemAttributes().getElement();
				writeH(e.getId()); // attack element (-1 - none)
				writeH(item.getItemAttributes().getValue(e) + i.getBaseAttributeValue(e)); // attack element value
				writeH(0); // водная стихия (fire pdef)
				writeH(0); // огненная стихия (water pdef)
				writeH(0); // земляная стихия (wind pdef)
				writeH(0); // воздушная стихия (earth pdef)
				writeH(0); // темная стихия (holy pdef)
				writeH(0); // светлая стихия (dark pdef)
			}
			else if(i.isArmor())
			{
				writeH(-1); // attack element (-1 - none)
				writeH(0); // attack element value
				for(Element e : Element.VALUES)
					writeH(item.getItemAttributes().getValue(e) + i.getBaseAttributeValue(e));
			}
			else
				writeItemElements();
		}
		else
			writeItemElements();
	}

	protected void writeItemElements()
	{
		writeH(-1); // attack element (-1 - none)
		writeH(0x00); // attack element value
		writeH(0x00); // водная стихия (fire pdef)
		writeH(0x00); // огненная стихия (water pdef)
		writeH(0x00); // земляная стихия (wind pdef)
		writeH(0x00); // воздушная стихия (earth pdef)
		writeH(0x00); // темная стихия (holy pdef)
		writeH(0x00); // светлая стихия (dark pdef)
	}
	protected void writeInventoryBlock(LockType lockType, int[] lockItems)
	{
//		if (inventory.hasInventoryBlock())
//		{
//			packet.writeH(inventory.getBlockItems().size());
//			packet.writeC(inventory.getBlockMode().getClientId());
//			for (int id : inventory.getBlockItems())
//			{
//				packet.writeD(id);
//			}
//		}
//		else
//		{
			writeH(0x00);
//		}
	}

	public String getType()
	{
		return "[S] " + getClass().getSimpleName();
	}

	public L2GameServerPacket packet(Player player)
	{
		return this;
	}

	/**
	 * @param masks
	 * @param type
	 * @return {@code true} if the mask contains the current update component type
	 */
	protected static boolean containsMask(int masks, IUpdateTypeComponent type)
	{
		return (masks & type.getMask()) == type.getMask();
	}
}