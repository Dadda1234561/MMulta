package l2s.gameserver.model.items.listeners;

import java.util.ArrayList;
import java.util.List;

import l2s.gameserver.data.xml.holder.ArmorSetsHolder;
import l2s.gameserver.listener.inventory.OnEquipListener;
import l2s.gameserver.model.ArmorSet;
import l2s.gameserver.model.Playable;
import l2s.gameserver.model.Player;
import l2s.gameserver.model.Skill;
import l2s.gameserver.model.actor.instances.player.Agathion;
import l2s.gameserver.model.items.Inventory;
import l2s.gameserver.model.items.ItemInstance;
import l2s.gameserver.skills.EffectUseType;
import l2s.gameserver.skills.SkillEntry;
import l2s.gameserver.network.l2.components.SystemMsg;
import l2s.gameserver.skills.SkillEntryType;
import l2s.gameserver.templates.agathion.AgathionTemplate;
import l2s.gameserver.templates.item.ItemTemplate;
import l2s.gameserver.utils.ItemFunctions;

public final class MaskListener extends AbstractSkillListener
{
	private static final MaskListener _instance = new MaskListener();

	public static MaskListener getInstance()
	{
		return _instance;
	}

	@Override
	public int onEquip(int slot, ItemInstance item, Playable actor)
	{
		if(!item.isEquipable())
			return 0;

		if(!actor.isPlayer())
			return 0;

		Player player = actor.getPlayer();

		if(item.getItemId()==48584 && item.getEnchantLevel()==7) {
			if(ItemFunctions.checkIsEquipped(player, -1, 48202, 0) || ItemFunctions.checkIsEquipped(player, -1, 48203, 0) || ItemFunctions.checkIsEquipped(player, -1, 48204, 0))
				player.addSkill(SkillEntry.makeSkillEntry(SkillEntryType.NONE, 35207, 1));
		}
		if(item.getItemId()==48202 || item.getItemId()==48203 || item.getItemId()==48204)
			if(ItemFunctions.checkIsEquipped(player, -1, 48584, 7)) {
				player.addSkill(SkillEntry.makeSkillEntry(SkillEntryType.NONE, 35207, 1));
			}
		if(item.getItemId()==48584 && item.getEnchantLevel()==8) {
			if(ItemFunctions.checkIsEquipped(player, -1, 48202, 0) || ItemFunctions.checkIsEquipped(player, -1, 48203, 0) || ItemFunctions.checkIsEquipped(player, -1, 48204, 0))
				player.addSkill(SkillEntry.makeSkillEntry(SkillEntryType.NONE, 35207, 2));
		}
		if(item.getItemId()==48202 || item.getItemId()==48203 || item.getItemId()==48204)
			if(ItemFunctions.checkIsEquipped(player, -1, 48584, 8)) {
				player.addSkill(SkillEntry.makeSkillEntry(SkillEntryType.NONE, 35207, 2));
			}
		if(item.getItemId()==48584 && item.getEnchantLevel()==9) {
			if(ItemFunctions.checkIsEquipped(player, -1, 48202, 0) || ItemFunctions.checkIsEquipped(player, -1, 48203, 0) || ItemFunctions.checkIsEquipped(player, -1, 48204, 0))
				player.addSkill(SkillEntry.makeSkillEntry(SkillEntryType.NONE, 35207, 3));
		}
		if(item.getItemId()==48202 || item.getItemId()==48203 || item.getItemId()==48204)
			if(ItemFunctions.checkIsEquipped(player, -1, 48584, 9)) {
				player.addSkill(SkillEntry.makeSkillEntry(SkillEntryType.NONE, 35207, 3));
			}
		if(item.getItemId()==48584 && item.getEnchantLevel()==10) {
			if(ItemFunctions.checkIsEquipped(player, -1, 48202, 0) || ItemFunctions.checkIsEquipped(player, -1, 48203, 0) || ItemFunctions.checkIsEquipped(player, -1, 48204, 0))
				player.addSkill(SkillEntry.makeSkillEntry(SkillEntryType.NONE, 35207, 4));
		}
		if(item.getItemId()==48202 || item.getItemId()==48203 || item.getItemId()==48204)
			if(ItemFunctions.checkIsEquipped(player, -1, 48584, 10)) {
				player.addSkill(SkillEntry.makeSkillEntry(SkillEntryType.NONE, 35207, 4));
			}


		if(item.getItemId()==48584 && item.getEnchantLevel()==7) {
			if(ItemFunctions.checkIsEquipped(player, -1, 48205, 0) || ItemFunctions.checkIsEquipped(player, -1, 48206, 0) || ItemFunctions.checkIsEquipped(player, -1, 48207, 0))
				player.addSkill(SkillEntry.makeSkillEntry(SkillEntryType.NONE, 35208, 1));
		}
		if(item.getItemId()==48205 || item.getItemId()==48206 || item.getItemId()==48207)
			if(ItemFunctions.checkIsEquipped(player, -1, 48584, 7)) {
				player.addSkill(SkillEntry.makeSkillEntry(SkillEntryType.NONE, 35208, 1));
			}
		if(item.getItemId()==48584 && item.getEnchantLevel()==8) {
			if(ItemFunctions.checkIsEquipped(player, -1, 48205, 0) || ItemFunctions.checkIsEquipped(player, -1, 48206, 0) || ItemFunctions.checkIsEquipped(player, -1, 48207, 0))
				player.addSkill(SkillEntry.makeSkillEntry(SkillEntryType.NONE, 35208, 2));
		}
		if(item.getItemId()==48205 || item.getItemId()==48206 || item.getItemId()==48207)
			if(ItemFunctions.checkIsEquipped(player, -1, 48584, 8)) {
				player.addSkill(SkillEntry.makeSkillEntry(SkillEntryType.NONE, 35208, 2));
			}
		if(item.getItemId()==48584 && item.getEnchantLevel()==9) {
			if(ItemFunctions.checkIsEquipped(player, -1, 48205, 0) || ItemFunctions.checkIsEquipped(player, -1, 48206, 0) || ItemFunctions.checkIsEquipped(player, -1, 48207, 0))
				player.addSkill(SkillEntry.makeSkillEntry(SkillEntryType.NONE, 35208, 3));
		}
		if(item.getItemId()==48205 || item.getItemId()==48206 || item.getItemId()==48207)
			if(ItemFunctions.checkIsEquipped(player, -1, 48584, 9)) {
				player.addSkill(SkillEntry.makeSkillEntry(SkillEntryType.NONE, 35208, 3));
			}
		if(item.getItemId()==48584 && item.getEnchantLevel()==10) {
			if(ItemFunctions.checkIsEquipped(player, -1, 48205, 0) || ItemFunctions.checkIsEquipped(player, -1, 48206, 0) || ItemFunctions.checkIsEquipped(player, -1, 48207, 0))
				player.addSkill(SkillEntry.makeSkillEntry(SkillEntryType.NONE, 35208, 4));
		}
		if(item.getItemId()==48205 || item.getItemId()==48206 || item.getItemId()==48207)
			if(ItemFunctions.checkIsEquipped(player, -1, 48584, 10)) {
				player.addSkill(SkillEntry.makeSkillEntry(SkillEntryType.NONE, 35208, 4));
			}


		if(item.getItemId()==48584 && item.getEnchantLevel()==7) {
			if(ItemFunctions.checkIsEquipped(player, -1, 48208, 0) || ItemFunctions.checkIsEquipped(player, -1, 48209, 0) || ItemFunctions.checkIsEquipped(player, -1, 48210, 0))
				player.addSkill(SkillEntry.makeSkillEntry(SkillEntryType.NONE, 35209, 1));
		}
		if(item.getItemId()==48208 || item.getItemId()==48209 || item.getItemId()==48210)
			if(ItemFunctions.checkIsEquipped(player, -1, 48584, 7)) {
				player.addSkill(SkillEntry.makeSkillEntry(SkillEntryType.NONE, 35209, 1));
			}
		if(item.getItemId()==48584 && item.getEnchantLevel()==8) {
			if(ItemFunctions.checkIsEquipped(player, -1, 48208, 0) || ItemFunctions.checkIsEquipped(player, -1, 48209, 0) || ItemFunctions.checkIsEquipped(player, -1, 48210, 0))
				player.addSkill(SkillEntry.makeSkillEntry(SkillEntryType.NONE, 35209, 2));
		}
		if(item.getItemId()==4828 || item.getItemId()==48209 || item.getItemId()==48210)
			if(ItemFunctions.checkIsEquipped(player, -1, 48584, 8)) {
				player.addSkill(SkillEntry.makeSkillEntry(SkillEntryType.NONE, 35209, 2));
			}
		if(item.getItemId()==48584 && item.getEnchantLevel()==9) {
			if(ItemFunctions.checkIsEquipped(player, -1, 48208, 0) || ItemFunctions.checkIsEquipped(player, -1, 48209, 0) || ItemFunctions.checkIsEquipped(player, -1, 48210, 0))
				player.addSkill(SkillEntry.makeSkillEntry(SkillEntryType.NONE, 35209, 3));
		}
		if(item.getItemId()==48208 || item.getItemId()==48209 || item.getItemId()==48210)
			if(ItemFunctions.checkIsEquipped(player, -1, 48584, 9)) {
				player.addSkill(SkillEntry.makeSkillEntry(SkillEntryType.NONE, 35209, 3));
			}
		if(item.getItemId()==48584 && item.getEnchantLevel()==10) {
			if(ItemFunctions.checkIsEquipped(player, -1, 48208, 0) || ItemFunctions.checkIsEquipped(player, -1, 48209, 0) || ItemFunctions.checkIsEquipped(player, -1, 48210, 0))
				player.addSkill(SkillEntry.makeSkillEntry(SkillEntryType.NONE, 35208, 4));
		}
		if(item.getItemId()==48208 || item.getItemId()==48209 || item.getItemId()==48210)
			if(ItemFunctions.checkIsEquipped(player, -1, 48584, 10)) {
				player.addSkill(SkillEntry.makeSkillEntry(SkillEntryType.NONE, 35209, 4));
			}

		player.sendSkillList();
		return 0;
	}

	@Override
	public int onUnequip(int slot, ItemInstance item, Playable actor)
	{
		if(!item.isEquipable())
			return 0;

		if(!actor.isPlayer())
			return 0;

		Player player = actor.getPlayer();

		if(item.getItemId()==48584){
			player.removeSkill(35207, true);
			player.removeSkill(35208, true);
			player.removeSkill(35209, true);
		}

		if(item.getItemId()==48202 || item.getItemId()==48203 || item.getItemId()==48204)
			player.removeSkill(35207, true);
		if(item.getItemId()==48205 || item.getItemId()==48206 || item.getItemId()==48207)
			player.removeSkill(35208, true);
		if(item.getItemId()==48208 || item.getItemId()==48209 || item.getItemId()==48210)
			player.removeSkill(35209, true);
		player.sendSkillList();
		return 0;
	}

	@Override
	public int onRefreshEquip(ItemInstance item, Playable actor)
	{
		//actor.ылшддsendSkillList();
		return 0;
	}
}