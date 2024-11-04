package l2s.gameserver.model.items.listeners;

import l2s.gameserver.model.Playable;
import l2s.gameserver.model.Player;
import l2s.gameserver.model.items.Inventory;
import l2s.gameserver.model.items.ItemInstance;
import l2s.gameserver.skills.SkillEntry;
import l2s.gameserver.skills.SkillEntryType;

import java.util.Collections;

import static l2s.gameserver.model.items.Inventory.*;

public final class ArtifactListener extends AbstractSkillListener {
	private static final SkillEntry ARTIFACT_SET_LV1_SKILL_ENTRY = SkillEntry.makeSkillEntry(SkillEntryType.ITEM, 35227, 1); // Artifact Set Effect Lv. 1
	private static final SkillEntry ARTIFACT_SET_LV2_SKILL_ENTRY = SkillEntry.makeSkillEntry(SkillEntryType.ITEM, 35228, 1); // Artifact Set Effect Lv. 2
	private static final SkillEntry ARTIFACT_SET_LV3_SKILL_ENTRY = SkillEntry.makeSkillEntry(SkillEntryType.ITEM, 35229, 1); // Artifact Set Effect Lv. 3

	private static final int[] BOOK_SLOT_1_SET = {
			PAPERDOLL_BALANCE_ARTIFACT1,
			PAPERDOLL_BALANCE_ARTIFACT2,
			PAPERDOLL_BALANCE_ARTIFACT3,
			PAPERDOLL_BALANCE_ARTIFACT4,
			PAPERDOLL_ATTACK_ARTIFACT1,
			PAPERDOLL_PROTECTION_ARTIFACT1,
			PAPERDOLL_SUPPORT_ARTIFACT1
	};

	private static final int[] BOOK_SLOT_2_SET = {
			PAPERDOLL_BALANCE_ARTIFACT5,
			PAPERDOLL_BALANCE_ARTIFACT6,
			PAPERDOLL_BALANCE_ARTIFACT7,
			PAPERDOLL_BALANCE_ARTIFACT8,
			PAPERDOLL_ATTACK_ARTIFACT2,
			PAPERDOLL_PROTECTION_ARTIFACT2,
			PAPERDOLL_SUPPORT_ARTIFACT2
	};

	private static final int[] BOOK_SLOT_3_SET = {
			PAPERDOLL_BALANCE_ARTIFACT8,
			PAPERDOLL_BALANCE_ARTIFACT9,
			PAPERDOLL_BALANCE_ARTIFACT10,
			PAPERDOLL_BALANCE_ARTIFACT11,
			PAPERDOLL_BALANCE_ARTIFACT12,
			PAPERDOLL_ATTACK_ARTIFACT3,
			PAPERDOLL_PROTECTION_ARTIFACT3,
			PAPERDOLL_SUPPORT_ARTIFACT3
	};

	private static final ArtifactListener INSTANCE = new ArtifactListener();

	public static ArtifactListener getInstance() {
		return INSTANCE;
	}

	@Override
	public int onEquip(int slot, ItemInstance item, Playable actor) {
		if (!item.isEquipable())
			return 0;

		if (!actor.isPlayer())
			return 0;

		return checkEquippedArtifact(item, actor.getPlayer());
	}

	@Override
	public int onUnequip(int slot, ItemInstance item, Playable actor) {
		if (!item.isEquipable())
			return 0;

		if (!actor.isPlayer())
			return 0;

		int flags = super.onUnequip(slot, item, actor);
		flags |= checkEquippedArtifact(item, actor.getPlayer());
		return flags;
	}

	@Override
	public int onRefreshEquip(ItemInstance item, Playable actor) {
		if (!item.isEquipable())
			return 0;

		if (!actor.isPlayer())
			return 0;

		return checkEquippedArtifact(item, actor.getPlayer());
	}

	private int checkEquippedArtifact(ItemInstance item, Player player) {
		int flags = 0;

		if (player.removeSkill(ARTIFACT_SET_LV1_SKILL_ENTRY, false) != null)
			flags |= Inventory.UPDATE_SKILLS_FLAG;
		if (player.removeSkill(ARTIFACT_SET_LV2_SKILL_ENTRY, false) != null)
			flags |= Inventory.UPDATE_SKILLS_FLAG;
		if (player.removeSkill(ARTIFACT_SET_LV3_SKILL_ENTRY, false) != null)
			flags |= Inventory.UPDATE_SKILLS_FLAG;

		Inventory inv = player.getInventory();

		int level = 3;

		for (int slotId : BOOK_SLOT_1_SET) {
			ItemInstance artifact = inv.getPaperdollItem(slotId);
			if (artifact == null) {
				level--;
				break;
			}
		}
		for (int slotId : BOOK_SLOT_2_SET) {
			ItemInstance artifact = inv.getPaperdollItem(slotId);
			if (artifact == null) {
				level--;
				break;
			}
		}
		for (int slotId : BOOK_SLOT_3_SET) {
			ItemInstance artifact = inv.getPaperdollItem(slotId);
			if (artifact == null) {
				level--;
				break;
			}
		}

		SkillEntry skillEntry = null;
		switch (level) {
			case 1:
				skillEntry = ARTIFACT_SET_LV1_SKILL_ENTRY;
				break;
			case 2:
				skillEntry = ARTIFACT_SET_LV2_SKILL_ENTRY;
				break;
			case 3:
				skillEntry = ARTIFACT_SET_LV3_SKILL_ENTRY;
				break;
		}

		if (skillEntry != null)
			flags |= refreshSkills(player, item, Collections.singletonList(skillEntry));

		return flags;
	}
}
