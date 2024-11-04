package l2s.gameserver.stats.funcs;

import l2s.gameserver.model.items.ItemInstance;
import l2s.gameserver.stats.Env;
import l2s.gameserver.stats.StatModifierType;
import l2s.gameserver.stats.Stats;
import l2s.gameserver.tables.EnchantHPBonusTable;
import l2s.gameserver.templates.StatsSet;
import l2s.gameserver.templates.item.ItemGrade;
import l2s.gameserver.templates.item.ItemQuality;
import l2s.gameserver.templates.item.ItemTemplate;
import l2s.gameserver.templates.item.ItemType;
import l2s.gameserver.templates.item.WeaponTemplate.WeaponType;

public class FuncEnchant extends Func
{
	public FuncEnchant(Stats stat, int order, Object owner, double value, StatsSet params) {
		super(stat, order, owner);
	}



	@Override
	public void calc(Env env, StatModifierType modifierType) {
		ItemInstance item = (ItemInstance) owner;

		int enchant = env.character.isPlayer() ? item.getFixedEnchantLevel(env.character.getPlayer()) : item.getEnchantLevel();
		int overenchant = Math.max(0, enchant + 2);
		int overenchantR1 = Math.max(0, enchant + 4);
		int overenchantR2 = Math.max(0, enchant + 6);
		int overenchantR3 = Math.max(0, enchant + 8);
		boolean isBlessed = item.getTemplate().getQuality() == ItemQuality.BLESSED;
		double modBonus = 1.0d;

		switch(stat) {
			case SHIELD_DEFENCE:
			case MAGIC_DEFENCE:
			case POWER_DEFENCE: {
				env.value += enchant + overenchant * 2 * (isBlessed ? 1.6 : 1.0);
				return;
			}

			case MAX_HP: {
				if(env.character.isPlayer())
					env.value += EnchantHPBonusTable.getInstance().getHPBonus(env.character.getPlayer(), item) * (isBlessed ? 1.6 : 1.0); // TODO: [Bonux] Проверить на оффе.
				return;
			}

			case CRITICAL_DAMAGE: {
				if (item.getTemplate().isWeapon() && !item.getTemplate().isMagicWeapon() && item.getTemplate().getGrade().ordinal() >= ItemGrade.S.ordinal()) {
					if (enchant >= 3 && enchant < 6) {
						modBonus = 2;
					} else if (enchant >= 6 && enchant < 9) {
						modBonus = 4;
					} else if (enchant >= 9 && enchant < 12) {
						modBonus = 6;
					} else if (enchant >= 12 && enchant < 16) {
						modBonus = 8;
					} else if (enchant >= 16 && enchant < 20) {
						modBonus = 10;
					} else if (enchant >= 20) {
						modBonus = 15;
					}
					env.value += modBonus;
				}
				break;
			}
			case MAGIC_CRITICAL_DMG: {
				if (item.getTemplate().isMagicWeapon() && item.getTemplate().getGrade().ordinal() >= ItemGrade.S.ordinal()) {
					if (enchant >= 3 && enchant < 6) {
						modBonus = 2;
					} else if (enchant >= 6 && enchant < 9) {
						modBonus = 4;
					} else if (enchant >= 9 && enchant < 12) {
						modBonus = 6;
					} else if (enchant >= 12 && enchant < 16) {
						modBonus = 8;
					} else if (enchant >= 16 && enchant < 20) {
						modBonus = 10;
					} else if (enchant >= 20) {
						modBonus = 15;
					}
					env.value += modBonus;
				}
				break;
			}

			case MAGIC_ATTACK:
			{
				switch(item.getTemplate().getGrade().getCrystalId())
				{
					case ItemTemplate.CRYSTAL_R:
						env.value += 36 * (enchant + overenchant) * (isBlessed ? 1.6 : 1.0);
						break;
					case ItemTemplate.CRYSTAL_S:
						env.value += 36 * (enchant + overenchant) * (isBlessed ? 1.6 : 1.0);
						break;
					case ItemTemplate.CRYSTAL_A:
						env.value += 24 * (enchant + overenchant) * (isBlessed ? 1.6 : 1.0);
						break;
					case ItemTemplate.CRYSTAL_B:
						env.value += 16 * (enchant + overenchant) * (isBlessed ? 1.6 : 1.0);
						break;
					case ItemTemplate.CRYSTAL_C:
						env.value += 10 * (enchant + overenchant) * (isBlessed ? 1.6 : 1.0);
						break;
					case ItemTemplate.CRYSTAL_D:
					case ItemTemplate.CRYSTAL_NONE:
						env.value += 6 * (enchant + overenchant) * (isBlessed ? 1.6 : 1.0);
						break;
				}

				//if (enchant >= 3 && enchant < 6) {
				//	modBonus = 3;
				//} else if (enchant >= 6 && enchant < 9) {
				//	modBonus = 6;
				//} else if (enchant >= 9 && enchant < 12) {
				//	modBonus = 9;
				//} else if (enchant >= 12 && enchant < 16) {
				//	modBonus = 12;
				//} else if (enchant >= 16 && enchant < 20) {
				//	modBonus = 16;
				//} else if (enchant >= 20) {
				//	modBonus = 20;
				//}
				//env.value += modBonus;
				break;
			}

			case POWER_ATTACK: {
				ItemType itemType = item.getItemType();
				//boolean isBow = itemType == WeaponType.BOW;
				//boolean isCrossbow = itemType == WeaponType.CROSSBOW || itemType == WeaponType.TWOHANDCROSSBOW;
				//boolean isSword = (itemType == WeaponType.DUALFIST || itemType == WeaponType.DUAL || itemType == WeaponType.BIGSWORD || itemType == WeaponType.SWORD || itemType == WeaponType.RAPIER || itemType == WeaponType.ANCIENTSWORD) && item.getTemplate().getBodyPart() == ItemTemplate.SLOT_LR_HAND;
				//boolean isDualBlunt = itemType == WeaponType.DUALBLUNT;
				switch (item.getTemplate().getGrade().getCrystalId()) {
					case ItemTemplate.CRYSTAL_R:
							env.value += 32 * (enchant + overenchant);
						break;
					case ItemTemplate.CRYSTAL_S:
							env.value += 32 * (enchant + overenchant);
						break;
					case ItemTemplate.CRYSTAL_A:
							env.value += 20 * (enchant + overenchant);
						break;
					case ItemTemplate.CRYSTAL_B:
					case ItemTemplate.CRYSTAL_C:
							env.value += 16 * (enchant + overenchant);
						break;
					case ItemTemplate.CRYSTAL_D:
					case ItemTemplate.CRYSTAL_NONE:
							env.value += 8 * (enchant + overenchant);
						break;
				}
				//if (item.getTemplate().isWeapon() && !item.getTemplate().isMagicWeapon() && item.getTemplate().getGrade().ordinal() >= ItemGrade.S.ordinal())
				//{
				//	if (enchant >= 3 && enchant < 6) {
				//		modBonus = 3;
				//	} else if (enchant >= 6 && enchant < 9) {
				//		modBonus = 6;
				//	} else if (enchant >= 9 && enchant < 12) {
				//		modBonus = 9;
				//	} else if (enchant >= 12 && enchant < 16) {
				//		modBonus = 12;
				//	} else if (enchant >= 16 && enchant < 20) {
				//		modBonus = 16;
				//	} else if (enchant >= 20) {
				//		modBonus = 20;
				//	}
				//env.value += modBonus;
				//System.out.println(env.value);
				break;
				//}
			}

			case SOULSHOT_POWER:
			case SPIRITSHOT_POWER: {
				env.value += Math.min(30, enchant) * 0.7;
				return;
			}
		}
	}
}