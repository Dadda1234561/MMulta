package l2s.gameserver.stats;

import l2s.commons.util.Rnd;
import l2s.gameserver.Config;
import l2s.gameserver.GameTimeController;
import l2s.gameserver.data.xml.holder.HitCondBonusHolder;
import l2s.gameserver.data.xml.holder.KarmaIncreaseDataHolder;
import l2s.gameserver.model.Creature;
import l2s.gameserver.model.Player;
import l2s.gameserver.model.Skill;
import l2s.gameserver.model.Skill.SkillType;
import l2s.gameserver.model.actor.instances.creature.Abnormal;
import l2s.gameserver.model.base.BaseStats;
import l2s.gameserver.model.base.Element;
import l2s.gameserver.model.base.HitCondBonusType;
import l2s.gameserver.network.l2.components.SystemMsg;
import l2s.gameserver.network.l2.s2c.SystemMessagePacket;
import l2s.gameserver.skills.*;
import l2s.gameserver.templates.item.WeaponTemplate;
import l2s.gameserver.templates.item.WeaponTemplate.WeaponType;
import l2s.gameserver.utils.PositionUtils;

public class Formulas
{
	private static final double CRAFTING_MASTERY_CHANCE = 25.; // TODO: Check.

	public static class AttackInfo
	{
		public double damage = 0;
		public double defence = 0;
		public boolean crit = false;
		public boolean shld = false;
		public boolean miss = false;
		public boolean blow = false;
	}

	/**
	 * Для простых ударов
	 * patk = patk
	 * При крите простым ударом:
	 * patk = patk * (1 + crit_damage_rcpt) * crit_damage_mod + crit_damage_static
	 * Для blow скиллов
	 * TODO
	 * Для скилловых критов, повреждения просто удваиваются, бафы не влияют (кроме blow, для них выше)
	 * patk = (1 + crit_damage_rcpt) * (patk + skill_power)
	 * Для обычных атак
	 * damage = patk * ss_bonus * 70 / pdef
	 */
	public static AttackInfo calcAutoAttackDamage(Creature attacker, Creature target, double pAtkMod, boolean range, boolean useShot, boolean canCrit)
	{
		AttackInfo info = new AttackInfo();

		double pAtk = attacker.getPAtk(target) * pAtkMod;
		info.damage = pAtk;
		info.defence = target.getPDef(attacker);
		info.crit = canCrit && calcPCrit(attacker, target, null, false);
		info.shld = calcShldUse(attacker, target);
		info.miss = false;
		info.blow = false;
		boolean isPvP = attacker.isPlayable() && target.isPlayable();
		boolean isPvE = attacker.isPlayable() && target.isNpc();

		if(info.shld)
		{
			info.defence += target.getShldDef();
		}

		if(info.crit)
		{
			double critDmg = info.damage;
			critDmg *= 2 * attacker.getStat().getMul(Stats.CRITICAL_DAMAGE, target, null);
			critDmg += attacker.getStat().getAdd(Stats.CRITICAL_DAMAGE, target, null);
			critDmg -= info.damage;
			critDmg = target.getStat().calc(Stats.P_CRIT_DAMAGE_RECEPTIVE, critDmg);
			//critDmg = Math.max(0, critDmg);
			info.damage += critDmg;
		}

		if(range)
		{
			info.damage += Math.max(0, (Config.LONG_RANGE_AUTO_ATTACK_P_ATK_MOD - 1)) * pAtk;
		}
		else
		{
			info.damage += Math.max(0, (Config.SHORT_RANGE_AUTO_ATTACK_P_ATK_MOD - 1)) * pAtk;
		}

		if(attacker.isDistortedSpace())
		{
			info.damage += pAtk * 0.2;
		}
		else
		{
			switch(PositionUtils.getDirectionTo(target, attacker))
			{
				case BEHIND:
					info.damage += pAtk * 0.2;
					break;
				case SIDE:
					info.damage += pAtk * 0.1;
					break;
			}
		}

		if (Config.ALT_AUTO_ATTACK_DMG_RANDOMISE)
		{
			info.damage *= 1 + (Rnd.get() * attacker.getRandomDamage() * 2 - attacker.getRandomDamage()) / 100.;
		}

		if(info.crit)
		{
			// шанс абсорбации души (без анимации) при крите, если Soul Mastery 4го уровня или более
			int chance = attacker.getSkillLevel(Skill.SKILL_SOUL_MASTERY);
			if(chance > 0)
			{
				if(chance >= 21)
					chance = 30;
				else if(chance >= 15)
					chance = 25;
				else if(chance >= 9)
					chance = 20;
				else if(chance >= 4)
					chance = 15;
				if(Rnd.chance(chance))
					attacker.setConsumedSouls(attacker.getConsumedSouls() + 1, null);
			}
		}

		if(useShot)
			info.damage *= (((100 + attacker.getChargedSoulshotPower()) / 100.) * target.getSoulShotDefence());

		info.damage *= (range ? 70. : 77.) / info.defence;
		info.damage *= calcAttackTraitBonus(attacker, target);
		info.damage *= calcAttributeBonus(attacker, target, null);

		info.damage = attacker.getStat().calc(Stats.INFLICTS_P_DAMAGE_POWER, info.damage, target, null);
		info.damage = target.getStat().calc(Stats.RECEIVE_P_DAMAGE_POWER, info.damage, attacker, null);

		if(info.shld)
		{
			if(Rnd.chance(Config.EXCELLENT_SHIELD_BLOCK_CHANCE))
			{
				info.damage = Config.EXCELLENT_SHIELD_BLOCK_RECEIVED_DAMAGE;
				return info;
			}
		}

		if(isPvP)
		{
			final double customAtkMod = attacker.isMageClass() ? Config.PLAYER_M_PVP_ATTACK_MODIFIER : Config.PLAYER_P_PVP_ATTACK_MODIFIER;
			final double customDefMod = target.isMageClass() ? Config.PLAYER_M_PVP_PDEF_MODIFIER : Config.PLAYER_P_PVP_PDEF_MODIFIER;

			info.damage *= (attacker.getStat().calc(Stats.PVP_PHYS_DMG_BONUS, 1) * customAtkMod);
			info.damage /= (target.getStat().calc(Stats.PVP_PHYS_DEFENCE_BONUS, 1) * customDefMod);
		}
		else if(isPvE)
		{
			info.damage *= attacker.getStat().calc(Stats.PVE_PHYS_DMG_BONUS, 1);
			info.damage /= target.getStat().calc(Stats.PVE_PHYS_DEFENCE_BONUS, 1);
		}
		
		if (target.isImmobilized() || target.isFlyUp() || target.isStunned() || target.isParalyzed())
		{
			info.damage *= attacker.getStat().calc(Stats.DAMAGE_TO_IMMOBILIZED, 1);
			info.damage /= target.getStat().calc(Stats.RESIST_IMMOBILIZED_DAMAGE, 1);
		}

		if(info.crit)
			info.damage = info.damage * getPCritDamageMode(attacker, true);
		else
			info.damage = info.damage * getPDamModifier(attacker);

		info.damage = calcDamageDecreaseDif(target, info.damage);
		info.damage = calcDamageDecreasePer(target, info.damage);

		if(target.isRaid())
			info.damage = calcRaidBossDamageDamage(attacker, info.damage);

		return info;
	}

	public static AttackInfo calcSkillPDamage(Creature attacker, Creature target, Skill skill, boolean blow, boolean useShot)
	{
		return calcSkillPDamage(attacker, target, skill, skill.getPower(target), blow, useShot);
	}

	public static AttackInfo calcSkillPDamage(Creature attacker, Creature target, Skill skill, double power, boolean blow, boolean useShot)
	{
		AttackInfo info = new AttackInfo();
		if(power == 0) // если скилл не имеет своей силы дальше идти бесполезно, можно сразу вернуть дамаг от летала
			return info;	// @Rivelia. Send empty AttackInfo so it does not show up in system messages.

		double pAtk = attacker.getPAtk(target);
		info.damage = pAtk;
		info.defence = target.getPDef(attacker);
		info.blow = blow;
		info.crit = calcPCrit(attacker, target, skill, info.blow);
		info.shld = !skill.getShieldIgnore() && calcShldUse(attacker, target);
		info.miss = false;
		boolean isPvP = attacker.isPlayable() && target.isPlayable();
		boolean isPvE = attacker.isPlayable() && target.isNpc();

		if(info.shld)
		{
			double shldDef = target.getShldDef();
			if(skill.getShieldIgnorePercent() > 0)
				shldDef -= shldDef * skill.getShieldIgnorePercent() / 100.;
			info.defence += shldDef;
		}

		if(skill.getDefenceIgnorePercent() > 0)
			info.defence *= (1. - (skill.getDefenceIgnorePercent() / 100.));

		if(info.damage > 0 && skill.canBeEvaded() && Rnd.chance(target.getStat().calc(Stats.P_SKILL_EVASION, 100, attacker, skill) - 100))
		{
			// @Rivelia. info.miss makes the Damage Text "Evaded" appear.
			info.miss = true;
			info.damage = 0;
			return info;
		}

		info.damage *= attacker.getLevelBonus();

		double skillPowerMod = 1;

		if(skill.getId() == 10510)
		{
			if(target.getAbnormalList().contains(AbnormalType.BLEEDING))
				skillPowerMod *= 1.2;
		}
		else if(skill.getId() == 30500)
		{
			if(attacker.isStunned())
				skillPowerMod *= 1.2;
		}

		if(skill.getNumCharges() > 0)
			skillPowerMod *= attacker.getStat().calc(Stats.CHARGED_P_SKILL_POWER, 1);

		info.damage += attacker.getStat().calc(Stats.P_SKILL_POWER, (attacker.isServitor() ? Config.SERVITOR_P_SKILL_POWER_MODIFIER : 1.) * power) * skillPowerMod;

		info.damage += attacker.getStat().calc(Stats.P_SKILL_POWER_STATIC);

		if (Config.ALT_P_DMG_RANDOMISE) {
			//Заряжаемые скилы имеют постоянный урон
			if(!skill.isChargeBoost())
				info.damage *= 1 + (Rnd.get() * attacker.getRandomDamage() * 2 - attacker.getRandomDamage()) / 100.;
		}

		if(info.blow)
		{
			double critDmg = info.damage;
			critDmg *= attacker.getStat().getMul(Stats.CRITICAL_DAMAGE, target, skill) * 0.666;
			critDmg += 6 * attacker.getStat().getAdd(Stats.CRITICAL_DAMAGE, target, skill);
			critDmg -= info.damage;
			critDmg -= (critDmg - target.getStat().calc(Stats.P_CRIT_DAMAGE_RECEPTIVE, critDmg)) / 2;
			critDmg = Math.max(0, critDmg);
			info.damage += critDmg;
		}

		if(skill.isChargeBoost())
		{
			int force = attacker.getIncreasedForce();
			// @Rivelia. Jump Attack hardcoded to 5 momentum max. Others are set to 3.
			if(force > 5 && skill.getId() == 10269)
				force = 5;
			else if(force > 3)
				force = 3;

			// @Rivelia. Momentum increases damage up to 30% if 3 forces used, so 10% per momentum.
			info.damage *= 1 + 0.1 * force;
		}
		else if(skill.isSoulBoost())
			info.damage *= 1.0 + 0.06 * Math.min(attacker.getConsumedSouls(), 5);

		if(info.crit)
		{
			if(info.blow)
			{
				info.damage *= 2;
			}
			else
			{
				double critDmg = info.damage;
				critDmg *= 2 * attacker.getStat().getMul(Stats.SKILL_CRITICAL_DAMAGE, target, skill);
				critDmg += attacker.getStat().getAdd(Stats.SKILL_CRITICAL_DAMAGE, target, null);
				critDmg -= info.damage;
				critDmg = target.getStat().calc(Stats.P_SKILL_CRIT_DAMAGE_RECEPTIVE, critDmg);
				info.damage += critDmg;
			}
		}

		if(attacker.isDistortedSpace())
		{
			info.damage += pAtk * 0.2;
		}
		else
		{
			switch(PositionUtils.getDirectionTo(target, attacker))
			{
				case BEHIND:
					info.damage += pAtk * 0.2;
					break;
				case SIDE:
					info.damage += pAtk * 0.1;
					break;
			}
		}

		if(info.crit)
		{
			// шанс абсорбации души (без анимации) при крите, если Soul Mastery 4го уровня или более
			int chance = attacker.getSkillLevel(Skill.SKILL_SOUL_MASTERY);
			if(chance > 0)
			{
				if(chance >= 21)
					chance = 30;
				else if(chance >= 15)
					chance = 25;
				else if(chance >= 9)
					chance = 20;
				else if(chance >= 4)
					chance = 15;
				if(Rnd.chance(chance))
					attacker.setConsumedSouls(attacker.getConsumedSouls() + 1, null);
			}
		}

		if(useShot)
			info.damage *= (((100 + attacker.getChargedSoulshotPower()) / 100.) * target.getSoulShotDefence());


		info.damage *= 77. / info.defence;
		info.damage *= calcWeaponTraitBonus(attacker, target);
		info.damage *= calcGeneralTraitBonus(attacker, target, skill.getTraitType(), true);
		info.damage *= calcAttributeBonus(attacker, target, skill);

		info.damage = attacker.getStat().calc(Stats.INFLICTS_P_DAMAGE_POWER, info.damage, target, skill);
		info.damage = target.getStat().calc(Stats.RECEIVE_P_DAMAGE_POWER, info.damage, attacker, skill);

		if(info.shld)
		{
			if(Rnd.chance(Config.EXCELLENT_SHIELD_BLOCK_CHANCE))
			{
				info.damage = Config.EXCELLENT_SHIELD_BLOCK_RECEIVED_DAMAGE;
				return info;
			}
		}

		if(isPvP)
		{
			final double customAtkMod = attacker.isMageClass() ? Config.PLAYER_M_PVP_MATTACK_MODIFIER : Config.PLAYER_P_PVP_MATTACK_MODIFIER;
			final double customDefMod = target.isMageClass() ? Config.PLAYER_M_PVP_MDEF_MODIFIER : Config.PLAYER_P_PVP_MDEF_MODIFIER;

			info.damage *= attacker.getStat().calc(Stats.PVP_PHYS_SKILL_DMG_BONUS, 1) * customAtkMod;
			info.damage /= target.getStat().calc(Stats.PVP_PHYS_SKILL_DEFENCE_BONUS, 1) * customDefMod;
		}
		else if(isPvE)
		{
			info.damage *= attacker.getStat().calc(Stats.PVE_PHYS_SKILL_DMG_BONUS, 1);
			info.damage /= target.getStat().calc(Stats.PVE_PHYS_SKILL_DEFENCE_BONUS, 1);
		}
		
		if (target.isImmobilized() || target.isFlyUp() || target.isStunned() || target.isParalyzed())
		{
			info.damage *= attacker.getStat().calc(Stats.DAMAGE_TO_IMMOBILIZED, 1);
			info.damage /= target.getStat().calc(Stats.RESIST_IMMOBILIZED_DAMAGE, 1);
		}

		if(info.crit)
			info.damage = info.damage * getPCritDamageMode(attacker, false);
		if(info.blow)
			info.damage = info.damage * Config.ALT_BLOW_DAMAGE_MOD;
		if(!info.crit && !info.blow)
			info.damage = info.damage * getPDamModifier(attacker);

		if(info.damage > 0 && skill.isDeathlink())
			info.damage *= 1.8 * ((skill.isPhysic() ? 2.0 : 1.0) - attacker.getCurrentHpRatio()); // TODO: Перепроверить формулу по оффу.

		if(info.blow)
		{
			// Тупая заглушка, переделать.
			if(attacker.getSkillCast(SkillCastingType.NORMAL).isCriticalBlow() && attacker.getSkillCast(SkillCastingType.NORMAL).getSkillEntry().getTemplate().equals(skill))
			{
				//
			}
			else if(attacker.getSkillCast(SkillCastingType.NORMAL_SECOND).isCriticalBlow() && attacker.getSkillCast(SkillCastingType.NORMAL_SECOND).getSkillEntry().getTemplate().equals(skill))
			{
				//
			}
			else
				return null;
		}

		info.damage = calcDamageDecreaseDif(target, info.damage);
		info.damage = calcDamageDecreasePer(target, info.damage);

		if(target.isRaid())
			info.damage = calcRaidBossDamageDamage(attacker, info.damage);

		if(info.damage > 0)
		{
			WeaponTemplate weaponItem = attacker.getActiveWeaponTemplate();
			if(skill.getIncreaseOnPole() > 0. && weaponItem != null && weaponItem.getItemType() == WeaponType.POLE)
				info.damage *= skill.getIncreaseOnPole();
			if(skill.getDecreaseOnNoPole() > 0. && weaponItem != null && weaponItem.getItemType() != WeaponType.POLE)
				info.damage *= skill.getDecreaseOnNoPole();

			if(calcStunBreak(info.crit, true, false))
			{
				target.getAbnormalList().stop(AbnormalType.STUN);
				target.getAbnormalList().stop(AbnormalType.TURN_FLEE);
			}

			if(calcCastBreak(target, info.crit))
				target.abortCast(false, true);

			for(Abnormal abnormal : target.getAbnormalList())
			{
				double chance = info.crit ? abnormal.getSkill().getOnCritCancelChance() : abnormal.getSkill().getOnAttackCancelChance();
				if(chance > 0 && Rnd.chance(chance))
					abnormal.exit();
			}
		}
		return info;
	}

	public static double calcLethalDamage(Creature attacker, Creature target, Skill skill)
	{
		if(skill == null)
			return 0.;

		if(target.isLethalImmune())
			return 0.;

		final double deathRcpt = 0.01 * target.getStat().calc(Stats.DEATH_VULNERABILITY, attacker, skill);
		final double lethal1Chance = skill.getLethal1(attacker) * deathRcpt;
		final double lethal2Chance = skill.getLethal2(attacker) * deathRcpt;

		double damage = 0.;

		if(Rnd.chance(lethal2Chance))
		{
			if(target.isPlayer())
			{
				damage = target.getCurrentHp() + target.getCurrentCp() - 1.1; // Oly\Duel хак установки не точно 1 ХП, а чуть больше для предотвращения псевдосмерти
				target.sendPacket(SystemMsg.LETHAL_STRIKE);
			}
			else
				damage = target.getCurrentHp() - 1;
			attacker.sendPacket(SystemMsg.YOUR_LETHAL_STRIKE_WAS_SUCCESSFUL);
		}
		else if(Rnd.chance(lethal1Chance))
		{
			if(target.isPlayer())
			{
				damage = target.getCurrentCp();
				target.sendPacket(SystemMsg.YOUR_CP_WAS_DRAINED_BECAUSE_YOU_WERE_HIT_WITH_A_CP_SIPHON_SKILL);
			}
			else
				damage = target.getCurrentHp() / 2.;
			attacker.sendPacket(SystemMsg.CP_SIPHON);
		}
		return damage;
	}

	private static double getMSimpleDamageMode(Creature attacker) //ONLY for 4-th proffs
	{
		if(!attacker.isPlayer())
			return Config.ALT_M_SIMPLE_DAMAGE_MOD;
		switch(attacker.getPlayer().getActiveClassId())
		{
			case 139:
				return Config.ALT_M_SIMPLE_DAMAGE_MOD_SIGEL;
			case 140:
				return Config.ALT_M_SIMPLE_DAMAGE_MOD_TIR_WARRIOR;
			case 141:
				return Config.ALT_M_SIMPLE_DAMAGE_MOD_OTHEL_ROGUE;
			case 142:
				return Config.ALT_M_SIMPLE_DAMAGE_MOD_YR_ARCHER;
			case 143:
				return Config.ALT_M_SIMPLE_DAMAGE_MOD_FEO_WIZZARD;
			case 144:
				return Config.ALT_M_SIMPLE_DAMAGE_MOD_ISS_ENCHANTER;
			case 145:
				return Config.ALT_M_SIMPLE_DAMAGE_MOD_WYN_SUMMONER;
			case 146:
				return Config.ALT_M_SIMPLE_DAMAGE_MOD_EOL_HEALER;
			//new
			case 148:
				return Config.ALT_M_SIMPLE_DAMAGE_MOD_SIGEL_PHOENIX_KNIGHT;
			case 149:
				return Config.ALT_M_SIMPLE_DAMAGE_MOD_SIGEL_HELL_KNIGHT;
			case 150:
				return Config.ALT_M_SIMPLE_DAMAGE_MOD_SIGEL_EVAS_TEMPLAR;
			case 151:
				return Config.ALT_M_SIMPLE_DAMAGE_MOD_SIGEL_SHILLIEN_TEMPLAR;
			case 152:
				return Config.ALT_M_SIMPLE_DAMAGE_MOD_TYR_DUELIST;
			case 153:
				return Config.ALT_M_SIMPLE_DAMAGE_MOD_TYR_DREADNOUGHT;
			case 154:
				return Config.ALT_M_SIMPLE_DAMAGE_MOD_TYR_TITAN;
			case 155:
				return Config.ALT_M_SIMPLE_DAMAGE_MOD_TYR_GRAND_KHAVATARI;
			case 156:
				return Config.ALT_M_SIMPLE_DAMAGE_MOD_TYR_MAESTRO;
			case 157:
				return Config.ALT_M_SIMPLE_DAMAGE_MOD_TYR_DOOMBRINGER;
			case 158:
				return Config.ALT_M_SIMPLE_DAMAGE_MOD_OTHELL_ADVENTURER;
			case 159:
				return Config.ALT_M_SIMPLE_DAMAGE_MOD_OTHELL_WIND_RIDER;
			case 160:
				return Config.ALT_M_SIMPLE_DAMAGE_MOD_OTHELL_GHOST_HUNTER;
			case 161:
				return Config.ALT_M_SIMPLE_DAMAGE_MOD_OTHELL_FORTUNE_SEEKER;
			case 162:
				return Config.ALT_M_SIMPLE_DAMAGE_MOD_YR_SAGITTARIUS;
			case 163:
				return Config.ALT_M_SIMPLE_DAMAGE_MOD_YR_MOONLIGHT_SENTINEL;
			case 164:
				return Config.ALT_M_SIMPLE_DAMAGE_MOD_YR_GHOST_SENTINEL;
			case 165:
				return Config.ALT_M_SIMPLE_DAMAGE_MOD_YR_TRICKSTER;
			case 166:
				return Config.ALT_M_SIMPLE_DAMAGE_MOD_FEOH_ARCHMAGE;
			case 167:
				return Config.ALT_M_SIMPLE_DAMAGE_MOD_FEOH_SOULTAKER;
			case 168:
				return Config.ALT_M_SIMPLE_DAMAGE_MOD_FEOH_MYSTIC_MUSE;
			case 169:
				return Config.ALT_M_SIMPLE_DAMAGE_MOD_FEOH_STORM_SCREAMER;
			case 170:
				return Config.ALT_M_SIMPLE_DAMAGE_MOD_FEOH_SOUL_HOUND;
			case 171:
				return Config.ALT_M_SIMPLE_DAMAGE_MOD_ISS_HIEROPHANT;
			case 172:
				return Config.ALT_M_SIMPLE_DAMAGE_MOD_ISS_SWORD_MUSE;
			case 173:
				return Config.ALT_M_SIMPLE_DAMAGE_MOD_ISS_SPECTRAL_DANCER;
			case 174:
				return Config.ALT_M_SIMPLE_DAMAGE_MOD_ISS_DOMINATOR;
			case 175:
				return Config.ALT_M_SIMPLE_DAMAGE_MOD_ISS_DOOMCRYER;
			case 176:
				return Config.ALT_M_SIMPLE_DAMAGE_MOD_WYNN_ARCANA_LORD;
			case 177:
				return Config.ALT_M_SIMPLE_DAMAGE_MOD_WYNN_ELEMENTAL_MASTER;
			case 178:
				return Config.ALT_M_SIMPLE_DAMAGE_MOD_WYNN_SPECTRAL_MASTER;
			case 179:
				return Config.ALT_M_SIMPLE_DAMAGE_MOD_AEORE_CARDINAL;
			case 180:
				return Config.ALT_M_SIMPLE_DAMAGE_MOD_AEORE_EVAS_SAINT;
			case 181:
				return Config.ALT_M_SIMPLE_DAMAGE_MOD_AEORE_SHILLIEN_SAINT;
			case 188:
				return Config.ALT_M_SIMPLE_DAMAGE_MOD_EVISCERATOR;
			case 189:
				return Config.ALT_M_SIMPLE_DAMAGE_MOD_SAHYAS_SEER;
			default:
				return Config.ALT_M_SIMPLE_DAMAGE_MOD;
		}
	}

	public static double getMCritDamageMode(Creature attacker) //ONLY for 4-th proffs
	{
		if(!attacker.isPlayer())
			return Config.ALT_M_CRIT_DAMAGE_MOD;
		switch(attacker.getPlayer().getActiveClassId())
		{
			case 139:
				return Config.ALT_M_CRIT_DAMAGE_MOD_SIGEL;
			case 140:
				return Config.ALT_M_CRIT_DAMAGE_MOD_TIR_WARRIOR;
			case 141:
				return Config.ALT_M_CRIT_DAMAGE_MOD_OTHEL_ROGUE;
			case 142:
				return Config.ALT_M_CRIT_DAMAGE_MOD_YR_ARCHER;
			case 143:
				return Config.ALT_M_CRIT_DAMAGE_MOD_FEO_WIZZARD;
			case 144:
				return Config.ALT_M_CRIT_DAMAGE_MOD_ISS_ENCHANTER;
			case 145:
				return Config.ALT_M_CRIT_DAMAGE_MOD_WYN_SUMMONER;
			case 146:
				return Config.ALT_M_CRIT_DAMAGE_MOD_EOL_HEALER;
			//new
			case 148:
				return Config.ALT_M_CRIT_DAMAGE_MOD_SIGEL_PHOENIX_KNIGHT;
			case 149:
				return Config.ALT_M_CRIT_DAMAGE_MOD_SIGEL_HELL_KNIGHT;
			case 150:
				return Config.ALT_M_CRIT_DAMAGE_MOD_SIGEL_EVAS_TEMPLAR;
			case 151:
				return Config.ALT_M_CRIT_DAMAGE_MOD_SIGEL_SHILLIEN_TEMPLAR;
			case 152:
				return Config.ALT_M_CRIT_DAMAGE_MOD_TYR_DUELIST;
			case 153:
				return Config.ALT_M_CRIT_DAMAGE_MOD_TYR_DREADNOUGHT;
			case 154:
				return Config.ALT_M_CRIT_DAMAGE_MOD_TYR_TITAN;
			case 155:
				return Config.ALT_M_CRIT_DAMAGE_MOD_TYR_GRAND_KHAVATARI;
			case 156:
				return Config.ALT_M_CRIT_DAMAGE_MOD_TYR_MAESTRO;
			case 157:
				return Config.ALT_M_CRIT_DAMAGE_MOD_TYR_DOOMBRINGER;
			case 158:
				return Config.ALT_M_CRIT_DAMAGE_MOD_OTHELL_ADVENTURER;
			case 159:
				return Config.ALT_M_CRIT_DAMAGE_MOD_OTHELL_WIND_RIDER;
			case 160:
				return Config.ALT_M_CRIT_DAMAGE_MOD_OTHELL_GHOST_HUNTER;
			case 161:
				return Config.ALT_M_CRIT_DAMAGE_MOD_OTHELL_FORTUNE_SEEKER;
			case 162:
				return Config.ALT_M_CRIT_DAMAGE_MOD_YR_SAGITTARIUS;
			case 163:
				return Config.ALT_M_CRIT_DAMAGE_MOD_YR_MOONLIGHT_SENTINEL;
			case 164:
				return Config.ALT_M_CRIT_DAMAGE_MOD_YR_GHOST_SENTINEL;
			case 165:
				return Config.ALT_M_CRIT_DAMAGE_MOD_YR_TRICKSTER;
			case 166:
				return Config.ALT_M_CRIT_DAMAGE_MOD_FEOH_ARCHMAGE;
			case 167:
				return Config.ALT_M_CRIT_DAMAGE_MOD_FEOH_SOULTAKER;
			case 168:
				return Config.ALT_M_CRIT_DAMAGE_MOD_FEOH_MYSTIC_MUSE;
			case 169:
				return Config.ALT_M_CRIT_DAMAGE_MOD_FEOH_STORM_SCREAMER;
			case 170:
				return Config.ALT_M_CRIT_DAMAGE_MOD_FEOH_SOUL_HOUND;
			case 171:
				return Config.ALT_M_CRIT_DAMAGE_MOD_ISS_HIEROPHANT;
			case 172:
				return Config.ALT_M_CRIT_DAMAGE_MOD_ISS_SWORD_MUSE;
			case 173:
				return Config.ALT_M_CRIT_DAMAGE_MOD_ISS_SPECTRAL_DANCER;
			case 174:
				return Config.ALT_M_CRIT_DAMAGE_MOD_ISS_DOMINATOR;
			case 175:
				return Config.ALT_M_CRIT_DAMAGE_MOD_ISS_DOOMCRYER;
			case 176:
				return Config.ALT_M_CRIT_DAMAGE_MOD_WYNN_ARCANA_LORD;
			case 177:
				return Config.ALT_M_CRIT_DAMAGE_MOD_WYNN_ELEMENTAL_MASTER;
			case 178:
				return Config.ALT_M_CRIT_DAMAGE_MOD_WYNN_SPECTRAL_MASTER;
			case 179:
				return Config.ALT_M_CRIT_DAMAGE_MOD_AEORE_CARDINAL;
			case 180:
				return Config.ALT_M_CRIT_DAMAGE_MOD_AEORE_EVAS_SAINT;
			case 181:
				return Config.ALT_M_CRIT_DAMAGE_MOD_AEORE_SHILLIEN_SAINT;
			case 188:
				return Config.ALT_M_CRIT_DAMAGE_MOD_EVISCERATOR;
			case 189:
				return Config.ALT_M_CRIT_DAMAGE_MOD_SAHYAS_SEER;
			default:
				return Config.ALT_M_CRIT_DAMAGE_MOD;
		}
	}

	private static double getPDamModifier(Creature attacker) //ONLY for 4-th proffs
	{
		if(!attacker.isPlayer())
			return Config.ALT_P_DAMAGE_MOD;
		switch(attacker.getPlayer().getActiveClassId())
		{
			case 139:
				return Config.ALT_P_DAMAGE_MOD_SIGEL;
			case 140:
				return Config.ALT_P_DAMAGE_MOD_TIR_WARRIOR;
			case 141:
				return Config.ALT_P_DAMAGE_MOD_OTHEL_ROGUE;
			case 142:
				return Config.ALT_P_DAMAGE_MOD_YR_ARCHER;
			case 143:
				return Config.ALT_P_DAMAGE_MOD_FEO_WIZZARD;
			case 144:
				return Config.ALT_P_DAMAGE_MOD_ISS_ENCHANTER;
			case 145:
				return Config.ALT_P_DAMAGE_MOD_WYN_SUMMONER;
			case 146:
				return Config.ALT_P_DAMAGE_MOD_EOL_HEALER;
			//new
			case 148:
				return Config.ALT_P_DAMAGE_MOD_SIGEL_PHOENIX_KNIGHT;
			case 149:
				return Config.ALT_P_DAMAGE_MOD_SIGEL_HELL_KNIGHT;
			case 150:
				return Config.ALT_P_DAMAGE_MOD_SIGEL_EVAS_TEMPLAR;
			case 151:
				return Config.ALT_P_DAMAGE_MOD_SIGEL_SHILLIEN_TEMPLAR;
			case 152:
				return Config.ALT_P_DAMAGE_MOD_TYR_DUELIST;
			case 153:
				return Config.ALT_P_DAMAGE_MOD_TYR_DREADNOUGHT;
			case 154:
				return Config.ALT_P_DAMAGE_MOD_TYR_TITAN;
			case 155:
				return Config.ALT_P_DAMAGE_MOD_TYR_GRAND_KHAVATARI;
			case 156:
				return Config.ALT_P_DAMAGE_MOD_TYR_MAESTRO;
			case 157:
				return Config.ALT_P_DAMAGE_MOD_TYR_DOOMBRINGER;
			case 158:
				return Config.ALT_P_DAMAGE_MOD_OTHELL_ADVENTURER;
			case 159:
				return Config.ALT_P_DAMAGE_MOD_OTHELL_WIND_RIDER;
			case 160:
				return Config.ALT_P_DAMAGE_MOD_OTHELL_GHOST_HUNTER;
			case 161:
				return Config.ALT_P_DAMAGE_MOD_OTHELL_FORTUNE_SEEKER;
			case 162:
				return Config.ALT_P_DAMAGE_MOD_YR_SAGITTARIUS;
			case 163:
				return Config.ALT_P_DAMAGE_MOD_YR_MOONLIGHT_SENTINEL;
			case 164:
				return Config.ALT_P_DAMAGE_MOD_YR_GHOST_SENTINEL;
			case 165:
				return Config.ALT_P_DAMAGE_MOD_YR_TRICKSTER;
			case 166:
				return Config.ALT_P_DAMAGE_MOD_FEOH_ARCHMAGE;
			case 167:
				return Config.ALT_P_DAMAGE_MOD_FEOH_SOULTAKER;
			case 168:
				return Config.ALT_P_DAMAGE_MOD_FEOH_MYSTIC_MUSE;
			case 169:
				return Config.ALT_P_DAMAGE_MOD_FEOH_STORM_SCREAMER;
			case 170:
				return Config.ALT_P_DAMAGE_MOD_FEOH_SOUL_HOUND;
			case 171:
				return Config.ALT_P_DAMAGE_MOD_ISS_HIEROPHANT;
			case 172:
				return Config.ALT_P_DAMAGE_MOD_ISS_SWORD_MUSE;
			case 173:
				return Config.ALT_P_DAMAGE_MOD_ISS_SPECTRAL_DANCER;
			case 174:
				return Config.ALT_P_DAMAGE_MOD_ISS_DOMINATOR;
			case 175:
				return Config.ALT_P_DAMAGE_MOD_ISS_DOOMCRYER;
			case 176:
				return Config.ALT_P_DAMAGE_MOD_WYNN_ARCANA_LORD;
			case 177:
				return Config.ALT_P_DAMAGE_MOD_WYNN_ELEMENTAL_MASTER;
			case 178:
				return Config.ALT_P_DAMAGE_MOD_WYNN_SPECTRAL_MASTER;
			case 179:
				return Config.ALT_P_DAMAGE_MOD_AEORE_CARDINAL;
			case 180:
				return Config.ALT_P_DAMAGE_MOD_AEORE_EVAS_SAINT;
			case 181:
				return Config.ALT_P_DAMAGE_MOD_AEORE_SHILLIEN_SAINT;
			case 188:
				return Config.ALT_P_DAMAGE_MOD_EVISCERATOR;
			case 189:
				return Config.ALT_P_DAMAGE_MOD_SAHYAS_SEER;
			default:
				return Config.ALT_P_DAMAGE_MOD;
		}
	}

	private static double getPCritDamageMode(Creature attacker, boolean notSkill) //ONLY for 4-th proffs
	{
		if(!attacker.isPlayer())
			return Config.ALT_P_CRIT_DAMAGE_MOD;
		switch(attacker.getPlayer().getActiveClassId())
		{
			case 139:
				return notSkill ? Config.ALT_P_CRIT_DAMAGE_MOD_SIGEL_FIZ : Config.ALT_P_CRIT_DAMAGE_MOD_SIGEL;
			case 140:
				return notSkill ? Config.ALT_P_CRIT_DAMAGE_MOD_TIR_WARRIOR_FIZ : Config.ALT_P_CRIT_DAMAGE_MOD_TIR_WARRIOR;
			case 141:
				return notSkill ? Config.ALT_P_CRIT_DAMAGE_MOD_OTHEL_ROGUE_FIZ : Config.ALT_P_CRIT_DAMAGE_MOD_OTHEL_ROGUE;
			case 142:
				return notSkill ? Config.ALT_P_CRIT_DAMAGE_MOD_YR_ARCHER_FIZ : Config.ALT_P_CRIT_DAMAGE_MOD_YR_ARCHER;
			case 143:
				return Config.ALT_P_CRIT_DAMAGE_MOD_FEO_WIZZARD;
			case 144:
				return Config.ALT_P_CRIT_DAMAGE_MOD_ISS_ENCHANTER;
			case 145:
				return Config.ALT_P_CRIT_DAMAGE_MOD_WYN_SUMMONER;
			case 146:
				return Config.ALT_P_CRIT_DAMAGE_MOD_EOL_HEALER;
			//new
			case 148:
				return notSkill ? Config.ALT_P_CRIT_DAMAGE_MOD_SIGEL_PHOENIX_KNIGHT_FIZ : Config.ALT_P_CRIT_DAMAGE_MOD_SIGEL_PHOENIX_KNIGHT;
			case 149:
				return notSkill ? Config.ALT_P_CRIT_DAMAGE_MOD_SIGEL_HELL_KNIGHT_FIZ : Config.ALT_P_CRIT_DAMAGE_MOD_SIGEL_HELL_KNIGHT;
			case 150:
				return notSkill ? Config.ALT_P_CRIT_DAMAGE_MOD_SIGEL_EVAS_TEMPLAR_FIZ : Config.ALT_P_CRIT_DAMAGE_MOD_SIGEL_EVAS_TEMPLAR;
			case 151:
				return notSkill ? Config.ALT_P_CRIT_DAMAGE_MOD_SIGEL_SHILLIEN_TEMPLAR_FIZ : Config.ALT_P_CRIT_DAMAGE_MOD_SIGEL_SHILLIEN_TEMPLAR;
			case 152:
				return notSkill ? Config.ALT_P_CRIT_DAMAGE_MOD_TYR_DUELIST_FIZ : Config.ALT_P_CRIT_DAMAGE_MOD_TYR_DUELIST;
			case 153:
				return notSkill ? Config.ALT_P_CRIT_DAMAGE_MOD_TYR_DREADNOUGHT_FIZ : Config.ALT_P_CRIT_DAMAGE_MOD_TYR_DREADNOUGHT;
			case 154:
				return notSkill ? Config.ALT_P_CRIT_DAMAGE_MOD_TYR_TITAN_FIZ : Config.ALT_P_CRIT_DAMAGE_MOD_TYR_TITAN;
			case 155:
				return notSkill ? Config.ALT_P_CRIT_DAMAGE_MOD_TYR_GRAND_KHAVATARI_FIZ : Config.ALT_P_CRIT_DAMAGE_MOD_TYR_GRAND_KHAVATARI;
			case 156:
				return notSkill ? Config.ALT_P_CRIT_DAMAGE_MOD_TYR_MAESTRO_FIZ : Config.ALT_P_CRIT_DAMAGE_MOD_TYR_MAESTRO;
			case 157:
				return notSkill ? Config.ALT_P_CRIT_DAMAGE_MOD_TYR_DOOMBRINGER_FIZ : Config.ALT_P_CRIT_DAMAGE_MOD_TYR_DOOMBRINGER;
			case 158:
				return notSkill ? Config.ALT_P_CRIT_DAMAGE_MOD_OTHELL_ADVENTURER_FIZ : Config.ALT_P_CRIT_DAMAGE_MOD_OTHELL_ADVENTURER;
			case 159:
				return notSkill ? Config.ALT_P_CRIT_DAMAGE_MOD_OTHELL_WIND_RIDER_FIZ : Config.ALT_P_CRIT_DAMAGE_MOD_OTHELL_WIND_RIDER;
			case 160:
				return notSkill ? Config.ALT_P_CRIT_DAMAGE_MOD_OTHELL_GHOST_HUNTER_FIZ : Config.ALT_P_CRIT_DAMAGE_MOD_OTHELL_GHOST_HUNTER;
			case 161:
				return notSkill ? Config.ALT_P_CRIT_DAMAGE_MOD_OTHELL_FORTUNE_SEEKER_FIZ : Config.ALT_P_CRIT_DAMAGE_MOD_OTHELL_FORTUNE_SEEKER;
			case 162:
				return notSkill ? Config.ALT_P_CRIT_DAMAGE_MOD_YR_SAGITTARIUS_FIZ : Config.ALT_P_CRIT_DAMAGE_MOD_YR_SAGITTARIUS;
			case 163:
				return notSkill ? Config.ALT_P_CRIT_DAMAGE_MOD_YR_MOONLIGHT_SENTINEL_FIZ : Config.ALT_P_CRIT_DAMAGE_MOD_YR_MOONLIGHT_SENTINEL;
			case 164:
				return notSkill ? Config.ALT_P_CRIT_DAMAGE_MOD_YR_GHOST_SENTINEL_FIZ : Config.ALT_P_CRIT_DAMAGE_MOD_YR_GHOST_SENTINEL;
			case 165:
				return notSkill ? Config.ALT_P_CRIT_DAMAGE_MOD_YR_TRICKSTER_FIZ : Config.ALT_P_CRIT_DAMAGE_MOD_YR_TRICKSTER;
			case 166:
				return Config.ALT_P_CRIT_DAMAGE_MOD_FEOH_ARCHMAGE;
			case 167:
				return Config.ALT_P_CRIT_DAMAGE_MOD_FEOH_SOULTAKER;
			case 168:
				return Config.ALT_P_CRIT_DAMAGE_MOD_FEOH_MYSTIC_MUSE;
			case 169:
				return Config.ALT_P_CRIT_DAMAGE_MOD_FEOH_STORM_SCREAMER;
			case 170:
				return notSkill ? Config.ALT_P_CRIT_DAMAGE_MOD_FEOH_SOUL_HOUND_FIZ : Config.ALT_P_CRIT_DAMAGE_MOD_FEOH_SOUL_HOUND;
			case 171:
				return Config.ALT_P_CRIT_DAMAGE_MOD_ISS_HIEROPHANT;
			case 172:
				return Config.ALT_P_CRIT_DAMAGE_MOD_ISS_SWORD_MUSE;
			case 173:
				return Config.ALT_P_CRIT_DAMAGE_MOD_ISS_SPECTRAL_DANCER;
			case 174:
				return notSkill ? Config.ALT_P_CRIT_DAMAGE_MOD_ISS_DOMINATOR_FIZ : Config.ALT_P_CRIT_DAMAGE_MOD_ISS_DOMINATOR;
			case 175:
				return notSkill ? Config.ALT_P_CRIT_DAMAGE_MOD_ISS_DOOMCRYER_FIZ : Config.ALT_P_CRIT_DAMAGE_MOD_ISS_DOOMCRYER;
			case 176:
				return Config.ALT_P_CRIT_DAMAGE_MOD_WYNN_ARCANA_LORD;
			case 177:
				return Config.ALT_P_CRIT_DAMAGE_MOD_WYNN_ELEMENTAL_MASTER;
			case 178:
				return Config.ALT_P_CRIT_DAMAGE_MOD_WYNN_SPECTRAL_MASTER;
			case 179:
				return Config.ALT_P_CRIT_DAMAGE_MOD_AEORE_CARDINAL;
			case 180:
				return Config.ALT_P_CRIT_DAMAGE_MOD_AEORE_EVAS_SAINT;
			case 181:
				return Config.ALT_P_CRIT_DAMAGE_MOD_AEORE_SHILLIEN_SAINT;
			case 188:
				return notSkill ? Config.ALT_P_CRIT_DAMAGE_MOD_EVISCERATOR_FIZ : Config.ALT_P_CRIT_DAMAGE_MOD_EVISCERATOR;
			case 189:
				return notSkill ? Config.ALT_P_CRIT_DAMAGE_MOD_SAHYAS_SEER_FIZ : Config.ALT_P_CRIT_DAMAGE_MOD_SAHYAS_SEER;
			default:
				return Config.ALT_P_CRIT_DAMAGE_MOD;
		}
	}

	private static double getPCritChanceMode(Creature attacker) //ONLY for 4-th proffs
	{
		if(!attacker.isPlayer())
			return Config.ALT_P_CRIT_CHANCE_MOD;
		switch(attacker.getPlayer().getActiveClassId())
		{
			case 139:
				return Config.ALT_P_CRIT_CHANCE_MOD_SIGEL;
			case 140:
				return Config.ALT_P_CRIT_CHANCE_MOD_TIR_WARRIOR;
			case 141:
				return Config.ALT_P_CRIT_CHANCE_MOD_OTHEL_ROGUE;
			case 142:
				return Config.ALT_P_CRIT_CHANCE_MOD_YR_ARCHER;
			case 143:
				return Config.ALT_P_CRIT_CHANCE_MOD_FEO_WIZZARD;
			case 144:
				return Config.ALT_P_CRIT_CHANCE_MOD_ISS_ENCHANTER;
			case 145:
				return Config.ALT_P_CRIT_CHANCE_MOD_WYN_SUMMONER;
			case 146:
				return Config.ALT_P_CRIT_CHANCE_MOD_EOL_HEALER;
			//new
			case 148:
				return Config.ALT_P_CRIT_CHANCE_MOD_SIGEL_PHOENIX_KNIGHT;
			case 149:
				return Config.ALT_P_CRIT_CHANCE_MOD_SIGEL_HELL_KNIGHT;
			case 150:
				return Config.ALT_P_CRIT_CHANCE_MOD_SIGEL_EVAS_TEMPLAR;
			case 151:
				return Config.ALT_P_CRIT_CHANCE_MOD_SIGEL_SHILLIEN_TEMPLAR;
			case 152:
				return Config.ALT_P_CRIT_CHANCE_MOD_TYR_DUELIST;
			case 153:
				return Config.ALT_P_CRIT_CHANCE_MOD_TYR_DREADNOUGHT;
			case 154:
				return Config.ALT_P_CRIT_CHANCE_MOD_TYR_TITAN;
			case 155:
				return Config.ALT_P_CRIT_CHANCE_MOD_TYR_GRAND_KHAVATARI;
			case 156:
				return Config.ALT_P_CRIT_CHANCE_MOD_TYR_MAESTRO;
			case 157:
				return Config.ALT_P_CRIT_CHANCE_MOD_TYR_DOOMBRINGER;
			case 158:
				return Config.ALT_P_CRIT_CHANCE_MOD_OTHELL_ADVENTURER;
			case 159:
				return Config.ALT_P_CRIT_CHANCE_MOD_OTHELL_WIND_RIDER;
			case 160:
				return Config.ALT_P_CRIT_CHANCE_MOD_OTHELL_GHOST_HUNTER;
			case 161:
				return Config.ALT_P_CRIT_CHANCE_MOD_OTHELL_FORTUNE_SEEKER;
			case 162:
				return Config.ALT_P_CRIT_CHANCE_MOD_YR_SAGITTARIUS;
			case 163:
				return Config.ALT_P_CRIT_CHANCE_MOD_YR_MOONLIGHT_SENTINEL;
			case 164:
				return Config.ALT_P_CRIT_CHANCE_MOD_YR_GHOST_SENTINEL;
			case 165:
				return Config.ALT_P_CRIT_CHANCE_MOD_YR_TRICKSTER;
			case 166:
				return Config.ALT_P_CRIT_CHANCE_MOD_FEOH_ARCHMAGE;
			case 167:
				return Config.ALT_P_CRIT_CHANCE_MOD_FEOH_SOULTAKER;
			case 168:
				return Config.ALT_P_CRIT_CHANCE_MOD_FEOH_MYSTIC_MUSE;
			case 169:
				return Config.ALT_P_CRIT_CHANCE_MOD_FEOH_STORM_SCREAMER;
			case 170:
				return Config.ALT_P_CRIT_CHANCE_MOD_FEOH_SOUL_HOUND;
			case 171:
				return Config.ALT_P_CRIT_CHANCE_MOD_ISS_HIEROPHANT;
			case 172:
				return Config.ALT_P_CRIT_CHANCE_MOD_ISS_SWORD_MUSE;
			case 173:
				return Config.ALT_P_CRIT_CHANCE_MOD_ISS_SPECTRAL_DANCER;
			case 174:
				return Config.ALT_P_CRIT_CHANCE_MOD_ISS_DOMINATOR;
			case 175:
				return Config.ALT_P_CRIT_CHANCE_MOD_ISS_DOOMCRYER;
			case 176:
				return Config.ALT_P_CRIT_CHANCE_MOD_WYNN_ARCANA_LORD;
			case 177:
				return Config.ALT_P_CRIT_CHANCE_MOD_WYNN_ELEMENTAL_MASTER;
			case 178:
				return Config.ALT_P_CRIT_CHANCE_MOD_WYNN_SPECTRAL_MASTER;
			case 179:
				return Config.ALT_P_CRIT_CHANCE_MOD_AEORE_CARDINAL;
			case 180:
				return Config.ALT_P_CRIT_CHANCE_MOD_AEORE_EVAS_SAINT;
			case 181:
				return Config.ALT_P_CRIT_CHANCE_MOD_AEORE_SHILLIEN_SAINT;
			case 188:
				return Config.ALT_P_CRIT_CHANCE_MOD_EVISCERATOR;
			case 189:
				return Config.ALT_P_CRIT_CHANCE_MOD_SAHYAS_SEER;
			default:
				return Config.ALT_P_CRIT_CHANCE_MOD;
		}
	}

	private static double getMCritChanceMode(Creature attacker) //ONLY for 4-th proffs
	{
		if(!attacker.isPlayer())
			return Config.ALT_M_CRIT_CHANCE_MOD;
		switch(attacker.getPlayer().getActiveClassId())
		{
			case 139:
				return Config.ALT_M_CRIT_CHANCE_MOD_SIGEL;
			case 140:
				return Config.ALT_M_CRIT_CHANCE_MOD_TIR_WARRIOR;
			case 141:
				return Config.ALT_M_CRIT_CHANCE_MOD_OTHEL_ROGUE;
			case 142:
				return Config.ALT_M_CRIT_CHANCE_MOD_YR_ARCHER;
			case 143:
				return Config.ALT_M_CRIT_CHANCE_MOD_FEO_WIZZARD;
			case 144:
				return Config.ALT_M_CRIT_CHANCE_MOD_ISS_ENCHANTER;
			case 145:
				return Config.ALT_M_CRIT_CHANCE_MOD_WYN_SUMMONER;
			case 146:
				return Config.ALT_M_CRIT_CHANCE_MOD_EOL_HEALER;
			//new
			case 148:
				return Config.ALT_M_CRIT_CHANCE_MOD_SIGEL_PHOENIX_KNIGHT;
			case 149:
				return Config.ALT_M_CRIT_CHANCE_MOD_SIGEL_HELL_KNIGHT;
			case 150:
				return Config.ALT_M_CRIT_CHANCE_MOD_SIGEL_EVAS_TEMPLAR;
			case 151:
				return Config.ALT_M_CRIT_CHANCE_MOD_SIGEL_SHILLIEN_TEMPLAR;
			case 152:
				return Config.ALT_M_CRIT_CHANCE_MOD_TYR_DUELIST;
			case 153:
				return Config.ALT_M_CRIT_CHANCE_MOD_TYR_DREADNOUGHT;
			case 154:
				return Config.ALT_M_CRIT_CHANCE_MOD_TYR_TITAN;
			case 155:
				return Config.ALT_M_CRIT_CHANCE_MOD_TYR_GRAND_KHAVATARI;
			case 156:
				return Config.ALT_M_CRIT_CHANCE_MOD_TYR_MAESTRO;
			case 157:
				return Config.ALT_M_CRIT_CHANCE_MOD_TYR_DOOMBRINGER;
			case 158:
				return Config.ALT_M_CRIT_CHANCE_MOD_OTHELL_ADVENTURER;
			case 159:
				return Config.ALT_M_CRIT_CHANCE_MOD_OTHELL_WIND_RIDER;
			case 160:
				return Config.ALT_M_CRIT_CHANCE_MOD_OTHELL_GHOST_HUNTER;
			case 161:
				return Config.ALT_M_CRIT_CHANCE_MOD_OTHELL_FORTUNE_SEEKER;
			case 162:
				return Config.ALT_M_CRIT_CHANCE_MOD_YR_SAGITTARIUS;
			case 163:
				return Config.ALT_M_CRIT_CHANCE_MOD_YR_MOONLIGHT_SENTINEL;
			case 164:
				return Config.ALT_M_CRIT_CHANCE_MOD_YR_GHOST_SENTINEL;
			case 165:
				return Config.ALT_M_CRIT_CHANCE_MOD_YR_TRICKSTER;
			case 166:
				return Config.ALT_M_CRIT_CHANCE_MOD_FEOH_ARCHMAGE;
			case 167:
				return Config.ALT_M_CRIT_CHANCE_MOD_FEOH_SOULTAKER;
			case 168:
				return Config.ALT_M_CRIT_CHANCE_MOD_FEOH_MYSTIC_MUSE;
			case 169:
				return Config.ALT_M_CRIT_CHANCE_MOD_FEOH_STORM_SCREAMER;
			case 170:
				return Config.ALT_M_CRIT_CHANCE_MOD_FEOH_SOUL_HOUND;
			case 171:
				return Config.ALT_M_CRIT_CHANCE_MOD_ISS_HIEROPHANT;
			case 172:
				return Config.ALT_M_CRIT_CHANCE_MOD_ISS_SWORD_MUSE;
			case 173:
				return Config.ALT_M_CRIT_CHANCE_MOD_ISS_SPECTRAL_DANCER;
			case 174:
				return Config.ALT_M_CRIT_CHANCE_MOD_ISS_DOMINATOR;
			case 175:
				return Config.ALT_M_CRIT_CHANCE_MOD_ISS_DOOMCRYER;
			case 176:
				return Config.ALT_M_CRIT_CHANCE_MOD_WYNN_ARCANA_LORD;
			case 177:
				return Config.ALT_M_CRIT_CHANCE_MOD_WYNN_ELEMENTAL_MASTER;
			case 178:
				return Config.ALT_M_CRIT_CHANCE_MOD_WYNN_SPECTRAL_MASTER;
			case 179:
				return Config.ALT_M_CRIT_CHANCE_MOD_AEORE_CARDINAL;
			case 180:
				return Config.ALT_M_CRIT_CHANCE_MOD_AEORE_EVAS_SAINT;
			case 181:
				return Config.ALT_M_CRIT_CHANCE_MOD_AEORE_SHILLIEN_SAINT;
			case 188:
				return Config.ALT_M_CRIT_CHANCE_MOD_EVISCERATOR;
			case 189:
				return Config.ALT_M_CRIT_CHANCE_MOD_SAHYAS_SEER;
			default:
				return Config.ALT_M_CRIT_CHANCE_MOD;
		}
	}

	public static AttackInfo calcMagicDam(Creature attacker, Creature target, Skill skill, boolean useShot, boolean canMiss)
	{
		return calcMagicDam(attacker, target, skill, skill.getPower(target), useShot, canMiss);
	}

	public static AttackInfo calcMagicDam(Creature attacker, Creature target, Skill skill, double power, boolean useShot, boolean canMiss)
	{
		boolean isPvP = attacker.isPlayable() && target.isPlayable();
		boolean isPvE = attacker.isPlayable() && target.isNpc();
		// @Rivelia. If skill doesn't ignore shield and CalcShieldUse returns true, shield = true.
		boolean shield = !skill.getShieldIgnore() && calcShldUse(attacker, target);

		double mAtk = attacker.getMAtk(target, skill);

		double mdef = target.getMDef(null, skill);

		if(shield)
		{
			double shldDef = target.getShldDef();
			if(skill.getShieldIgnorePercent() > 0)
				shldDef -= shldDef * skill.getShieldIgnorePercent() / 100.;
			mdef += shldDef;
		}

		if(skill.getDefenceIgnorePercent() > 0)
			mdef *= (1. - (skill.getDefenceIgnorePercent() / 100.));

		mdef = Math.max(mdef, 1);

		AttackInfo info = new AttackInfo();
		if(power == 0)
			return info;

		if(skill.isSoulBoost())
			power *= 1.0 + 0.06 * Math.min(attacker.getConsumedSouls(), 5);

		info.damage = (91 * power * Math.sqrt(mAtk)) / mdef;

		if(useShot)
			info.damage *= (((100 + attacker.getChargedSpiritshotPower()) / 100.) * target.getSoulShotDefence());

		if(target.isTargetUnderDebuff())
			info.damage *= skill.getPercentDamageIfTargetDebuff();

		if(canMiss)
		{
			//TODO: [Bonux] Переделать по оффу.
			if(calcMagicHitMiss(skill, attacker, target))
			{
				info.miss = true;
				info.damage = 0;
				return info;
			}
		}
		if (Config.ALT_M_DMG_RANDOMISE) {
			info.damage *= 1 + (((Rnd.get() * attacker.getRandomDamage() * 2) - attacker.getRandomDamage()) / 100.);
		}

		double asAddMod = 1 + ((attacker.getStat().calc(Stats.M_SKILL_POWER, (attacker.isServitor() ? Config.SERVITOR_M_SKILL_POWER_MODIFIER : 1.))) - 1) / 100;
		double normalMod = attacker.getStat().calc(Stats.M_SKILL_POWER, (attacker.isServitor() ? Config.SERVITOR_M_SKILL_POWER_MODIFIER : 1.));
		info.damage *= Math.max(1., Config.M_SKILL_POWER_MUL_AS_ADD_MODE ? asAddMod : normalMod);
		info.crit = calcMCrit(attacker, target, skill);

		if(info.crit)
		{
			// @Rivelia. Based on config, Magic skills can be reduced by Critical Damage Reduction if Critical Damage Receptive < 1.
			if(Config.ENABLE_CRIT_DMG_REDUCTION_ON_MAGIC)
			{
				double critDmg = info.damage;
				critDmg *= 2.5;
				double critMul = (attacker.getStat().getMul(Stats.MAGIC_CRITICAL_DMG, target, skill) * Config.MAGIC_CRIT_DMG_MODIFIER);
				critDmg *= critMul;
				critDmg *= getMCritDamageMode(attacker);
				critDmg -= info.damage;
				double tempDamage = target.getStat().calc(Stats.M_CRIT_DAMAGE_RECEPTIVE, critDmg, attacker, skill);
				critDmg = Math.min(tempDamage, critDmg);
				critDmg = Math.max(0, critDmg);
				info.damage += critDmg;
			}
			else
			{
				info.damage *= 1 + attacker.getStat().getMul(Stats.MAGIC_CRITICAL_DMG, target, skill);
				info.damage += attacker.getStat().getAdd(Stats.MAGIC_CRITICAL_DMG, target, skill);
				info.damage *= getMCritDamageMode(attacker);
			}
		}
		else
			info.damage = info.damage * getMSimpleDamageMode(attacker);

		info.damage *= calcGeneralTraitBonus(attacker, target, skill.getTraitType(), true);
		info.damage *= calcAttributeBonus(attacker, target, skill);

		info.damage = attacker.getStat().calc(Stats.INFLICTS_M_DAMAGE_POWER, info.damage, target, skill);
		info.damage = target.getStat().calc(Stats.RECEIVE_M_DAMAGE_POWER, info.damage, attacker, skill);

		if(shield)
		{
			info.shld = true;
			if(Rnd.chance(Config.EXCELLENT_SHIELD_BLOCK_CHANCE))
			{
				info.damage = Config.EXCELLENT_SHIELD_BLOCK_RECEIVED_DAMAGE;
				return info;
			}
		}

		int levelDiff = target.getLevel() - attacker.getLevel(); // C Gracia Epilogue уровень маг. атак считается только по уроню атакующего

		if(info.damage > 0 && skill.isDeathlink())
			info.damage *= 1.8 * (1.0 - attacker.getCurrentHpRatio());

		if(info.damage > 0 && skill.isBasedOnTargetDebuff())
			info.damage *= 1 + 0.05 * target.getAbnormalList().size();

		if(skill.getSkillType() == SkillType.MANADAM)
			info.damage = Math.max(1, info.damage / 4.);
		else if(info.damage > 0)
		{
			if(isPvP)
			{
				final double customAtkMod = attacker.isMageClass() ? Config.PLAYER_M_PVP_MATTACK_MODIFIER : Config.PLAYER_P_PVP_MATTACK_MODIFIER;
				final double customDefMod = target.isMageClass() ? Config.PLAYER_M_PVP_MDEF_MODIFIER : Config.PLAYER_P_PVP_MDEF_MODIFIER;

				info.damage *= (attacker.getStat().calc(Stats.PVP_MAGIC_SKILL_DMG_BONUS, 1) * customAtkMod);
				info.damage /= (target.getStat().calc(Stats.PVP_MAGIC_SKILL_DEFENCE_BONUS, 1) * customDefMod);
			}
			else if(isPvE)
			{
				info.damage *= attacker.getStat().calc(Stats.PVE_MAGIC_SKILL_DMG_BONUS, 1);
				info.damage /= target.getStat().calc(Stats.PVE_MAGIC_SKILL_DEFENCE_BONUS, 1);
			}
			
			if (target.isImmobilized() || target.isFlyUp() || target.isStunned() || target.isParalyzed())
			{
				info.damage *= attacker.getStat().calc(Stats.DAMAGE_TO_IMMOBILIZED, 1);
				info.damage /= target.getStat().calc(Stats.RESIST_IMMOBILIZED_DAMAGE, 1);
			}
		}

		double magic_rcpt = target.getStat().calc(Stats.MAGIC_RESIST, attacker, skill) - attacker.getStat().calc(Stats.MAGIC_POWER, target, skill);
		double failChance = 4. * Math.max(1., levelDiff) * (1. + magic_rcpt / 100.);

		/* MAGIC FAILURES
		if(levelDiff > 9)
			{
				info.damage = 0;
				SystemMessagePacket msg = new SystemMessagePacket(SystemMsg.C1_RESISTED_C2S_MAGIC).addName(target).addName(attacker);
				attacker.sendPacket(msg);
				target.sendPacket(msg);
				attacker.sendPacket(new ExMagicAttackInfo(attacker.getObjectId(), target.getObjectId(), ExMagicAttackInfo.RESISTED));
				target.sendPacket(new ExMagicAttackInfo(attacker.getObjectId(), target.getObjectId(), ExMagicAttackInfo.RESISTED));
			}
		 */

		if(Rnd.chance(failChance))
		{
			info.damage /= 2;
			SystemMessagePacket msg = new SystemMessagePacket(SystemMsg.DAMAGE_IS_DECREASED_BECAUSE_C1_RESISTED_C2S_MAGIC).addName(target).addName(attacker);
			attacker.sendPacket(msg);
			target.sendPacket(msg);
		}

		if(calcCastBreak(target, info.crit))
			target.abortCast(false, true);

		if(calcStunBreak(info.crit, true, true) && info.damage > 0)
		{
			target.getAbnormalList().stop(AbnormalType.STUN);
			target.getAbnormalList().stop(AbnormalType.TURN_FLEE);
		}

		for(Abnormal abnormal : target.getAbnormalList())
		{
			double chance = info.crit ? abnormal.getSkill().getOnCritCancelChance() : abnormal.getSkill().getOnAttackCancelChance();
			if(chance > 0 && Rnd.chance(chance))
				abnormal.exit();
		}

		info.damage = calcDamageDecreaseDif(target, info.damage);
		info.damage = calcDamageDecreasePer(target, info.damage);

		if(target.isRaid())
			info.damage = calcRaidBossDamageDamage(attacker, info.damage);

		return info;
	}

	/* @Rivelia. Default chances:
	* On magical skill non-crit: 33.33%
	* On magical skill crit: 66.67%
	* On physical skill non-crit: 33.33%
	* On physical skill crit: 66.67%
	* On regular hit non-crit: 16.67%
	* On regular hit crit: 33.33%
	*/
	public static boolean calcStunBreak(boolean crit, boolean isSkill, boolean isMagic)
	{
		if(!Config.ENABLE_STUN_BREAK_ON_ATTACK)
			return false;

		if(isSkill)
		{
			if(isMagic)
				return Rnd.chance(crit ? Config.CRIT_STUN_BREAK_CHANCE_ON_MAGICAL_SKILL : Config.NORMAL_STUN_BREAK_CHANCE_ON_MAGICAL_SKILL);
			return Rnd.chance(crit ? Config.CRIT_STUN_BREAK_CHANCE_ON_PHYSICAL_SKILL : Config.NORMAL_STUN_BREAK_CHANCE_ON_PHYSICAL_SKILL);
		}
		return Rnd.chance(crit ? Config.CRIT_STUN_BREAK_CHANCE_ON_REGULAR_HIT : Config.NORMAL_STUN_BREAK_CHANCE_ON_REGULAR_HIT);
	}

	/** Returns true in case of fatal blow success */
	public static boolean calcBlow(Creature activeChar, Creature target, Skill skill)
	{
		// TODO: Правильная ли формула резиста блов умений?
		final double vulnMod = target.getStat().calc(Stats.BLOW_RESIST, activeChar, skill);;
		final double profMod = activeChar.getStat().calc(Stats.BLOW_POWER, target, skill);
		if(vulnMod == Double.POSITIVE_INFINITY || profMod == Double.NEGATIVE_INFINITY)
			return false;

		if(vulnMod == Double.NEGATIVE_INFINITY || profMod == Double.POSITIVE_INFINITY)
			return true;

		WeaponTemplate weapon = activeChar.getActiveWeaponTemplate();

		double base_weapon_crit = weapon == null ? 4. : weapon.getCritical();
		double crit_height_bonus = 1;
		if(Config.ENABLE_CRIT_HEIGHT_BONUS)
			crit_height_bonus = 0.008 * Math.min(25, Math.max(-25, target.getZ() - activeChar.getZ())) + 1.1;
		double buffs_mult = activeChar.getStat().calc(Stats.FATALBLOW_RATE, target, skill);
		// @Rivelia. Default values: BLOW_SKILL_CHANCE_MOD_ON_BEHIND = 5, BLOW_SKILL_CHANCE_MOD_ON_FRONT = 4
		double skill_mod = skill.isBehind() ? Config.BLOW_SKILL_CHANCE_MOD_ON_BEHIND : Config.BLOW_SKILL_CHANCE_MOD_ON_FRONT;

		double chance = base_weapon_crit * buffs_mult * crit_height_bonus * skill_mod;

		double modDiff = profMod - vulnMod;
		if(modDiff != 1)
			chance *= 1. + ((80 + modDiff) / 200.);

		if(!target.isInCombat())
			chance *= 1.1;

		if(activeChar.isDistortedSpace())
			chance *= 1.3;
		else
		{
			switch(PositionUtils.getDirectionTo(target, activeChar))
			{
				case BEHIND:
					chance *= 1.3;
					break;
				case SIDE:
					chance *= 1.1;
					break;
				case FRONT:
					if(skill.isBehind())
						chance = 3.0;
					break;
			}
		}
		// @Rivelia. Default values: MAX_BLOW_RATE_ON_BEHIND = 100, MAX_BLOW_RATE_ON_FRONT_AND_SIDE = 80.
		chance = Math.min(skill.isBehind() ? Config.MAX_BLOW_RATE_ON_BEHIND : Config.MAX_BLOW_RATE_ON_FRONT_AND_SIDE, chance);
		return Rnd.chance(chance);
	}

	/** Возвращает шанс крита в процентах */
	public static boolean calcPCrit(Creature attacker, Creature target, Skill skill, boolean blow)
	{
		if(skill != null)
		{
			final boolean dexDep = attacker.getStat().calc(Stats.P_SKILL_CRIT_RATE_DEX_DEPENDENCE) > 0;
			final double skillCritRate = skill.getCriticalRate();
			final double skillCritChanceMod = attacker.getStat().calc(Stats.P_SKILL_CRITICAL_RATE, 1., target, skill);
			final double pSkillCritChanceReceptive = target.getStat().calc(Stats.P_SKILL_CRIT_CHANCE_RECEPTIVE, attacker, skill) * 0.01;
			final double pCritChanceMode = getPCritChanceMode(attacker);
			final double critRate = skillCritRate * skillCritChanceMod * pSkillCritChanceReceptive * pCritChanceMode * 10;
			final double blowCritModifier = Config.ALT_BLOW_CRIT_RATE_MODIFIER;
	
			double finalRate = critRate;

			double statModifier;
			if(dexDep)
			{
				statModifier = BaseStats.DEX.calcBonus(attacker);
				if(blow)
					statModifier *= Config.BLOW_SKILL_DEX_CHANCE_MOD;
				else
					statModifier *= Config.NORMAL_SKILL_DEX_CHANCE_MOD;
			}
			else
				statModifier = BaseStats.STR.calcBonus(attacker);

			finalRate *= statModifier;

			if(blow)
				finalRate *= blowCritModifier;

			final boolean result = finalRate > Rnd.get(1000);

			boolean debugCaster = attacker.getPlayer() != null && attacker.getPlayer().isDebug();
			boolean debugTarget = target.getPlayer() != null && target.getPlayer().isDebug();
			if(debugCaster || debugTarget)
			{
				StringBuilder stat = new StringBuilder(100);
				stat.append("'" + attacker.getName() + "' p. skill crit chance debug: ");
				stat.append(skill.getName());
				stat.append("\ndexDep: ");
				stat.append(dexDep);
				stat.append("\nskillCritRate: ");
				stat.append(String.format("%1.3f", skillCritRate));
				stat.append("\nskillCritChanceMod: ");
				stat.append(String.format("%1.3f", skillCritChanceMod));
				stat.append("\npCritChanceMode: ");
				stat.append(String.format("%1.3f", pCritChanceMode));
				stat.append("\ncritRate: ");
				stat.append(String.format("%1.3f", critRate));
				stat.append("\nblowCritModifier: ");
				stat.append(String.format("%1.3f", blowCritModifier));
				stat.append("\nstatModifier: ");
				stat.append(String.format("%1.3f", statModifier));
				stat.append("\nfinalRate: ");
				stat.append(String.format("%1.3f", finalRate));

				if(result)
					stat.append("\nResult: success");
				else
					stat.append("\nResult: failed");

				// отсылаем отладочные сообщения
				if(debugCaster)
					attacker.getPlayer().sendMessage(stat.toString());
				if(debugTarget)
					target.getPlayer().sendMessage(stat.toString());
			}
			return result;
		}
		else
		{
			final double pCriticalHit = attacker.getPCriticalHit(target);
			final double pCritChanceReceptive = target.getStat().calc(Stats.P_CRIT_CHANCE_RECEPTIVE, attacker, skill) * 0.01;
			final double pCritChanceMode = getPCritChanceMode(attacker);
			final double critRate = pCriticalHit * pCritChanceReceptive * pCritChanceMode;
			final double criticalHeightBonus = calcCriticalHeightBonus(attacker, target);

			double directionRate = 1.;
			if(attacker.isDistortedSpace())
				directionRate *= 1.4;
			else
			{
				switch(PositionUtils.getDirectionTo(target, attacker))
				{
					case BEHIND:
						directionRate *= 1.4;
						break;
					case SIDE:
						directionRate *= 1.2;
						break;
				}
			}
		
			// Autoattack critical depends on level difference at high levels as well.
			double levelDiffChanceAdd = 0;
			if(attacker.getLevel() >= 78 || target.getLevel() >= 78)
				levelDiffChanceAdd = (Math.sqrt(attacker.getLevel()) * (attacker.getLevel() - target.getLevel()) * 0.125);

			double finalRate = (critRate + levelDiffChanceAdd) * directionRate / 10;
			
			// Autoattack critical rate is limited between 3%-97%.
			finalRate = Math.min(Math.max(finalRate, 3), 97);

			final boolean result = Rnd.chance(finalRate);

			boolean debugCaster = attacker.getPlayer() != null && attacker.getPlayer().isDebug();
			boolean debugTarget = target.getPlayer() != null && target.getPlayer().isDebug();
			if(debugCaster || debugTarget)
			{
				StringBuilder stat = new StringBuilder(100);
				stat.append("'" + attacker.getName() + "' p. attack crit chance debug: ");
				stat.append("\npCriticalHit: ");
				stat.append(String.format("%1.3f", pCriticalHit));
				stat.append("\npCritChanceReceptive: ");
				stat.append(String.format("%1.3f", pCritChanceReceptive));
				stat.append("\npCritChanceMode: ");
				stat.append(String.format("%1.3f", pCritChanceMode));
				stat.append("\ncritRate: ");
				stat.append(String.format("%1.3f", critRate));
				stat.append("\ncriticalHeightBonus: ");
				stat.append(String.format("%1.3f", criticalHeightBonus));
				stat.append("\ndirectionRate: ");
				stat.append(String.format("%1.3f", directionRate));
				stat.append("\nlevelDiffChanceAdd: ");
				stat.append(String.format("%1.3f", levelDiffChanceAdd));
				stat.append("\nfinalRate: ");
				stat.append(String.format("%1.3f", finalRate));

				if(result)
					stat.append("\nResult: success");
				else
					stat.append("\nResult: failed");

				// отсылаем отладочные сообщения
				if(debugCaster)
					attacker.getPlayer().sendMessage(stat.toString());
				if(debugTarget)
					target.getPlayer().sendMessage(stat.toString());
			}
			return result;
		}
	}
	
	public static double calcCriticalHeightBonus(Creature from, Creature target)
	{
		return ((((Math.min(Math.max(from.getZ() - target.getZ(), -25), 25) * 4) / 5) + 10) / 100) + 1;
	}

	// Magic Critical Rate
	public static boolean calcMCrit(Creature attacker, Creature target, Skill skill)
	{
		final double mCriticalHit = attacker.getMCriticalHit(target, skill);
		final double skillCriticalRateMod = skill.getCriticalRateMod();
		final double mCritChanceMode = getMCritChanceMode(attacker);
		final double critRate;
		if(target == null || !skill.isDebuff())
		{
			critRate = mCriticalHit * skillCriticalRateMod * mCritChanceMode;
//			return Math.min(critRate, 320) > Rnd.get(1000);
			return critRate > Rnd.get(1000);
		}

		final double mCritChanceReceptive = target.getStat().calc(Stats.M_CRIT_CHANCE_RECEPTIVE, attacker, skill) * 0.01;
		critRate = mCriticalHit * skillCriticalRateMod * mCritChanceMode * mCritChanceReceptive;

		double finalRate = critRate;

		double levelDiffChanceAdd = 0;
		if(attacker.getLevel() >= 78 && target.getLevel() >= 78)
		{
			levelDiffChanceAdd = Math.sqrt(attacker.getLevel()) + ((attacker.getLevel() - target.getLevel()) / 25);
			finalRate += levelDiffChanceAdd;
//			finalRate = Math.min(finalRate, 320);
		}
//		else
//			finalRate = Math.min(finalRate, 200);

		final boolean result = finalRate > Rnd.get(1000);

		boolean debugCaster = attacker.getPlayer() != null && attacker.getPlayer().isDebug();
		boolean debugTarget = target.getPlayer() != null && target.getPlayer().isDebug();
		if(debugCaster || debugTarget)
		{
			StringBuilder stat = new StringBuilder(100);
			stat.append("'" + attacker.getName() + "' m. skill crit chance debug: ");
			stat.append(skill.getName());
			stat.append("\nmCriticalHit: ");
			stat.append(String.format("%1.3f", mCriticalHit));
			stat.append("\nskillCriticalRateMod: ");
			stat.append(String.format("%1.3f", skillCriticalRateMod));
			stat.append("\nmCritChanceReceptive: ");
			stat.append(String.format("%1.3f", mCritChanceReceptive));
			stat.append("\nmCritChanceMode: ");
			stat.append(String.format("%1.3f", mCritChanceMode));
			stat.append("\ncritRate: ");
			stat.append(String.format("%1.3f", critRate));
			stat.append("\nlevelDiffChanceAdd: ");
			stat.append(String.format("%1.3f", levelDiffChanceAdd));
			stat.append("\nfinalRate: ");
			stat.append(String.format("%1.3f", finalRate));

			if(result)
				stat.append("\nResult: success");
			else
				stat.append("\nResult: failed");

			// отсылаем отладочные сообщения
			if(debugCaster)
				attacker.getPlayer().sendMessage(stat.toString());
			if(debugTarget)
				target.getPlayer().sendMessage(stat.toString());
		}
		return result;
	}

	public static boolean calcCastBreak(Creature target, boolean crit)
	{
		if(target == null || target.isInvulnerable() || target.isRaid() || !target.isCastingNow())
			return false;

		Skill skill = null;

		SkillEntry skillEntry = target.getSkillCast(SkillCastingType.NORMAL).getSkillEntry();
		if(skillEntry != null) {
			skill = skillEntry.getTemplate();
			if (skill.isPhysic() || skill.getSkillType() == SkillType.TAKECASTLE || skill.getSkillType() == SkillType.TAKEFORTRESS)
				return false;
		}

		skillEntry = target.getSkillCast(SkillCastingType.NORMAL_SECOND).getSkillEntry();
		if(skillEntry != null) {
			skill = skillEntry.getTemplate();
			if (skill.isPhysic() || skill.getSkillType() == SkillType.TAKECASTLE || skill.getSkillType() == SkillType.TAKEFORTRESS)
				return false;
		}

		return Rnd.chance(target.getStat().calc(Stats.CAST_INTERRUPT, crit ? 75 : 10, null, skill));
	}

	/** Calculate delay (in milliseconds) before next ATTACK */
	public static int calcPAtkSpd(double rate)
	{
		return Math.max(Config.PHYS_ATK_REUSE_MIN, (int) (500000 / rate)); // в миллисекундах поэтому 500*1000
	}

	/** Calculate delay (in milliseconds) for skills cast */
	public static int calcSkillCastSpd(Creature attacker, Skill skill, double skillTime)
	{
		if(skill.isMagic())
			return (int) (skillTime * 333 / Math.max(attacker.getMAtkSpd(), 1));
		if(skill.isPhysic())
			return (int) (skillTime * 333 / Math.max(attacker.getPAtkSpd(), 1));
		return (int) skillTime;
	}

	/** Calculate reuse delay (in milliseconds) for skills */
	public static long calcSkillReuseDelay(Creature actor, Creature target, Skill skill)
	{
		long reuseDelay = skill.getReuseDelay();
		if (target.isPlayer())
			reuseDelay = skill.getReuseDelayPvP();
		if(target.isMonster())
			reuseDelay = skill.getReuseDelayPvE();
		if(actor.isMonster())
			reuseDelay = skill.getReuseForMonsters();
		if(skill.isHandler() || skill.isItemSkill())
			return reuseDelay;
		if(skill.isReuseDelayPermanent())
			return reuseDelay;
		if(skill.isMusic())
			return (long) actor.getStat().calc(Stats.MUSIC_REUSE_RATE, reuseDelay, null, skill);
		if(skill.isMagic())
			return (long) actor.getStat().calc(Stats.MAGIC_REUSE_RATE, reuseDelay, null, skill);
		return (long) actor.getStat().calc(Stats.PHYSIC_REUSE_RATE, reuseDelay, null, skill);
	}

	private static double getConditionBonus(Creature attacker, Creature target)
	{
		double mod = 100;
		// Get high or low bonus
		if((attacker.getZ() - target.getZ()) > 50)
			mod += HitCondBonusHolder.getInstance().getHitCondBonus(HitCondBonusType.HIGH);
		else if ((attacker.getZ() - target.getZ()) < -50)
			mod += HitCondBonusHolder.getInstance().getHitCondBonus(HitCondBonusType.LOW);

		// Get weather bonus
		if(GameTimeController.getInstance().isNowNight())
			mod += HitCondBonusHolder.getInstance().getHitCondBonus(HitCondBonusType.DARK);

		/*if(isRain)
			mod += HitCondBonusHolder.getInstance().getHitCondBonus(HitCondBonusType.RAIN);*/

		if(attacker.isDistortedSpace())
			mod += HitCondBonusHolder.getInstance().getHitCondBonus(HitCondBonusType.BACK);
		else
		{
			PositionUtils.TargetDirection direction = PositionUtils.getDirectionTo(attacker, target);
			switch(direction)
			{
				case BEHIND:
					mod += HitCondBonusHolder.getInstance().getHitCondBonus(HitCondBonusType.BACK);
					break;
				case SIDE:
					mod += HitCondBonusHolder.getInstance().getHitCondBonus(HitCondBonusType.SIDE);
					break;
				default:
					mod += HitCondBonusHolder.getInstance().getHitCondBonus(HitCondBonusType.AHEAD);
					break;
			}
		}

		// If (mod / 100) is less than 0, return 0, because we can't lower more than 100%.
		return Math.max(mod / 100, 0);
	}

	/** Returns true if hit missed (target evaded) */
	public static boolean calcHitMiss(Creature attacker, Creature target)
	{
		int chance = (80 + (2 * (attacker.getPAccuracy() - target.getPEvasionRate(attacker)))) * 10;

		chance *= getConditionBonus(attacker, target);
		chance = (int) Math.max(chance, Config.PHYSICAL_MIN_CHANCE_TO_HIT * 10);
		chance = (int) Math.min(chance, Config.PHYSICAL_MAX_CHANCE_TO_HIT * 10);

		return chance < Rnd.get(1000);
	}

	private static boolean calcMagicHitMiss(Skill skill, Creature attacker, Creature target)
	{
		int chance = (98 + (2 * (attacker.getMAccuracy() + 3 - target.getMEvasionRate(attacker)))) * 10;

		chance = (int) Math.max(chance, Config.MAGIC_MIN_CHANCE_TO_HIT * 10);
		chance = (int) Math.min(chance, Config.MAGIC_MAX_CHANCE_TO_HIT * 10);

		return chance < Rnd.get(1000);
	}

	/** Returns true if shield defence successfull */
	public static boolean calcShldUse(Creature attacker, Creature target)
	{
		WeaponTemplate template = target.getSecondaryWeaponTemplate();
		if(template == null || template.getItemType() != WeaponTemplate.WeaponType.NONE)
			return false;
		int angle = (int) target.getStat().calc(Stats.SHIELD_ANGLE, attacker, null);
		if(angle < 360 && !PositionUtils.isFacing(target, attacker, angle))
			return false;
		return Rnd.chance((int) target.getStat().calc(Stats.SHIELD_RATE, attacker, null));
	}

	public static boolean calcEffectsSuccess(Creature caster, Creature target, Skill skill, int activateRate)
	{
		if(activateRate == -1)
			return true;
		
		int magicLevel = skill.getMagicLevel();
		if(magicLevel <= -1)
			magicLevel = target.getLevel() + 3;

		double targetBasicProperty = getAbnormalResist(skill.getBasicProperty(), target);
		final double baseMod = ((((((magicLevel - target.getLevel()) + 3) * skill.getLevelBonusRate()) + activateRate) + 30.0) - targetBasicProperty);
		final double elementMod = calcAttributeBonus(caster, target, skill);
		final double traitMod = calcGeneralTraitBonus(caster, target, skill.getTraitType(), false);
		final double basicPropertyResist = getBasicPropertyResistBonus(skill.getBasicProperty(), target);
		final double buffDebuffMod = 1. + ((skill.isDebuff() ? target.getStat().calc(Stats.RESIST_ABNORMAL_DEBUFF, 0) : target.getStat().calc(Stats.RESIST_ABNORMAL_BUFF, 0)) / 100.);
		final double rate = baseMod * elementMod * traitMod * buffDebuffMod;
		final double finalRate = traitMod > 0 ? Math.min(skill.getMaxChance(), Math.max(rate, skill.getMinChance())) * basicPropertyResist : 0;

		final boolean result = (finalRate > Rnd.get(100));

		boolean debugCaster = caster.getPlayer() != null && caster.getPlayer().isDebug();
		boolean debugTarget = target.getPlayer() != null && target.getPlayer().isDebug();
		if(debugCaster || debugTarget)
		{
			StringBuilder stat = new StringBuilder(100);
			stat.append("'" + caster.getName() + "' effects chance debug: ");
			stat.append(skill.getName());
			stat.append("\nactivateRate: ");
			stat.append(activateRate);
			stat.append("\nbaseMod: ");
			stat.append(String.format("%1.3f", baseMod));
			stat.append("\nelementMod: ");
			stat.append(String.format("%1.3f", elementMod));
			stat.append("\ntraitMod: ");
			stat.append(String.format("%1.3f", traitMod));
			stat.append("\nbuffDebuffMod: ");
			stat.append(String.format("%1.3f", buffDebuffMod));
			stat.append("\nrate: ");
			stat.append(String.format("%1.3f", rate));
			stat.append("\nfinalRate: ");
			stat.append(String.format("%1.3f", finalRate));

			if(result)
				stat.append("\nResult: success");
			else
				stat.append("\nResult: failed");

			// отсылаем отладочные сообщения
			if(debugCaster)
				caster.getPlayer().sendMessage(stat.toString());
			if(debugTarget)
				target.getPlayer().sendMessage(stat.toString());
		}
		return result;
	}

	public static boolean calcSkillMastery(Creature creature, Skill skill, boolean isAbnormal)
	{
		if(skill.isHandler() || skill.isToggle())
			return false;

		/*TODO: Использовать, когда спарсятся статты с ПТСа:
		if(isAbnormal)
		{
			// Toggle/Aura skills are excluded.
			if(!skill.isContinuous())
				return false;

			// Special level -2 or below cannot result in double abnormal duration.
			if(skill.isStatic() || (skill.getSpecialLevel() <= -2))
				return false;
		}
		else
		{
			// Only A1 operate type can get reuse reset.
			if(!SkillOperateType.A1.equals(skill.getOperateType()))
				return false;

			// Static (isMagic = 2) and reuse delay locked skills are excluded.
			if(skill.isStatic() || skill.isReuseDelayLocked())
				return false;

			// Special level other than 0 cannot reset reuse.
			if(skill.getSpecialLevel() != 0)
				return false;
		}*/

		int skillMasteryStat = (int) creature.getStat().calc(Stats.P_SKILL_CRITICAL);
		if(skillMasteryStat < 0 || skillMasteryStat >= BaseStats.VALUES.length)
			return false;

		BaseStats stat = BaseStats.VALUES[skillMasteryStat];
		if(stat == BaseStats.NONE)
			return false;

		// Chance calculation: statBonus * mul + add. isMagic = 1 skills have 0.5 chance multiplier.
		double chance = creature.getStat().calc(Stats.P_SKILL_CRITICAL_PROBABILITY, stat.calcBonus(creature));
		if(skill.isMagic())
			chance /= 2; // Magic skills (isMagic = 1) have half the chance to trigger.

		if(chance > (Rnd.nextDouble() * 100.))
		{
			//byte mastery level, 0 = no skill mastery, 1 = no reuseTime, 2 = effect duration*2, 3 = power*3
			int masteryLevel = 0;
			// @Rivelia. If skill has effects -> effect duration * 2, else -> no reuse time.
			if(Config.OFFLIKE_MASTERY_SYSTEM)
			{
				int skillMastery = skill.getMasteryLevel();	// -1 = calculate. 0 = no mastery. 1 = no reuse. 2 = effect duration * 2.
				if(skillMastery == 0)
					return false;

				switch(skill.getSkillType())
				{
					case CHANGE_CLASS:
					case CLAN_GATE:
					case CRAFT:
					case DEATH_PENALTY:
					case ENCHANT_ARMOR:
					case ENCHANT_WEAPON:
					case EXTRACT_STONE:
					case HARDCODED:
					case KAMAEL_WEAPON_EXCHANGE:
					case LUCK:
					case ADD_PC_BANG:
					case NOTDONE:
					case NOTUSED:
					case PASSIVE:
					case BEAST_FEED:
					case PET_FEED:
					case REFILL:
					case SOWING:
					case SUMMON_FLAG:
					case RESTORATION:
					case TAKECASTLE:
					case TAKEFORTRESS:
					case TAMECONTROL:
					case WATCHER_GAZE:
					case VITALITY_HEAL:
						return false;
				}

				if(skillMastery == -1)
				{
					// Skill has valid effect. So duration must double.
					if(skill.hasEffects(EffectUseType.NORMAL))
						masteryLevel = 2;
					else
						masteryLevel = 1;	// No valid effects found or skill effects count <= 0. So skill must reset its reuse time.
				}
				else
					masteryLevel = skillMastery;	// XML-defined mastery level.
			}
			else
			{
				if(skill.hasEffects(EffectUseType.NORMAL))
					masteryLevel = 2;
				else
					masteryLevel = 1;
			}
			return isAbnormal && masteryLevel == 2 || !isAbnormal && masteryLevel == 1;
		}
		return false;
	}

	public static double calcDamageResists(Skill skill, Creature attacker, Creature defender, double value)
	{
		if(attacker == defender) // это дамаг от местности вроде ожога в лаве, наносится от своего имени
			return value; // TODO: по хорошему надо учитывать защиту, но поскольку эти скиллы немагические то надо делать отдельный механизм
		//DEPRECATED
		if(attacker.isBoss())
			value *= Config.RATE_EPIC_ATTACK;
		else if(attacker.isRaid())
			value *= Config.RATE_RAID_ATTACK;

		if(defender.isBoss())
			value /= Config.RATE_EPIC_DEFENSE;
		else if(defender.isRaid())
			value /= Config.RATE_RAID_DEFENSE;

		Player pAttacker = attacker.getPlayer();

		// если уровень игрока ниже чем на 2 и более уровней моба 78+, то его урон по мобу снижается
		int diff = defender.getLevel() - (pAttacker != null ? pAttacker.getLevel() : attacker.getLevel());
		if(attacker.isPlayable() && defender.isMonster() && defender.getLevel() >= 78 && diff > 2)
			value *= .7 / Math.pow(diff - 2, .25);

		return value;
	}

	/**
	 * Возвращает множитель для атаки из значений атакующего и защитного элемента.
	 * <br /><br />
	 * Диапазон от 1.0 до 1.7 (Freya)
	 * <br /><br />
	 * @param defense значение защиты
	 * @param attack значение атаки
	 * @return множитель
	 */
	private static double getElementMod(double defense, double attack)
	{
		double diff = attack - defense;
		if(diff > 0)
			diff = 1.025 + Math.sqrt(Math.pow(Math.abs(diff), 3) / 2.) * 0.0001;
		else if(diff < 0)
			diff = 0.975 - Math.sqrt(Math.pow(Math.abs(diff), 3) / 2.) * 0.0001;
		else
			diff = 1;

		diff = Math.max(diff, 0.75);
		diff = Math.min(diff, 1.25);
		return diff;
	}

	/**
	 * Возвращает максимально эффективный атрибут, при атаке цели
	 * @param attacker
	 * @param target
	 * @return
	 */
	public static Element getAttackElement(Creature attacker, Creature target)
	{
		double val, max = Double.MIN_VALUE;
		Element result = Element.NONE;
		for(Element e : Element.VALUES)
		{
			val = attacker.getStat().calc(e.getAttack(), 0.);
			if(val <= 0.)
				continue;

			if(target != null)
				val -= target.getStat().calc(e.getDefence(), 0.);

			if(val > max)
			{
				result = e;
				max = val;
			}
		}

		return result;
	}

	public static int calculateKarmaLost(Player player, long exp)
	{
		if(Config.RATE_KARMA_LOST_STATIC != -1)
			return Config.RATE_KARMA_LOST_STATIC;

		double karmaLooseMul = KarmaIncreaseDataHolder.getInstance().getData(player.getLevel());
		if(exp > 0) // Received exp
			exp /= Config.KARMA_RATE_KARMA_LOST == -1 ? Config.RATE_XP_BY_LVL[player.getLevel()] : Config.KARMA_RATE_KARMA_LOST;
		return (int) ((Math.abs(exp) / karmaLooseMul) / 15);
	}

	public static boolean calcCraftingMastery(Player player)
	{
		if(player.getSkillLevel(Skill.SKILL_CRAFTING_MASTERY) > 0)
		{
			if(Rnd.chance(CRAFTING_MASTERY_CHANCE + (player.hasPremiumAccount() ? 5. : 0.)))
				return true;
		}
		return false;
	}

	public static boolean tryLuck(Player player)
	{
		//TODO: [Bonux] Сделать правильную формулу.
		double luc = player.getLUC() * Config.LUC_BONUS_MODIFIER;
		if(luc > 0)
			return Rnd.chance(luc);
		return false;
	}

	public static boolean calcCancelSuccess(Creature attacker, Creature target, int dispelChance, Skill skill, Abnormal abnormal)
	{
		final int cancelLevel = skill.getMagicLevel() > 0 ? skill.getMagicLevel() : attacker.getLevel();
		final int buffLevel = abnormal.getSkill().getMagicLevel() > 0 ? abnormal.getSkill().getMagicLevel() : target.getLevel();
		final int abnormalTime = abnormal.getSkill().getAbnormalTime();
		final double cancelPower = attacker.getStat().calc(Stats.CANCEL_POWER, 100, null, null);
		final double cancelResist = target.getStat().calc(Stats.CANCEL_RESIST, 100, null, null);

		int chance = (int) (dispelChance + ((cancelLevel - buffLevel) * 2) + ((abnormalTime / 120) * 0.01 * cancelPower * 0.01 * cancelResist));
		chance = Math.max(Math.min(Config.CANCEL_SKILLS_HIGH_CHANCE_CAP, chance), Config.CANCEL_SKILLS_LOW_CHANCE_CAP);

		boolean result = Rnd.get(100) < chance;

		boolean debugCaster = attacker.getPlayer() != null && attacker.getPlayer().isDebug();
		boolean debugTarget = target.getPlayer() != null && target.getPlayer().isDebug();
		if(debugCaster || debugTarget)
		{
			StringBuilder stat = new StringBuilder(100);
			stat.append("----------------------------------");
			stat.append("\n'" + attacker.getName() + "' buff cancel chance debug: ");
			stat.append(skill.getName());
			stat.append("\nDispel chance: ");
			stat.append(dispelChance);
			stat.append("\nCancel skill magic level: ");
			stat.append(cancelLevel);
			stat.append("\nBuff magic level: ");
			stat.append(buffLevel);
			stat.append("\nBuff abormal time: ");
			stat.append(abnormalTime);
			stat.append("\nCancel power: ");
			stat.append(String.format("%1.3f", cancelPower));
			stat.append("\nCancel resist: ");
			stat.append(String.format("%1.3f", cancelResist));
			stat.append("\nBuff cancel chance: ");
			stat.append(chance);
			if(result)
				stat.append("\nResult: success");
			else
				stat.append("\nResult: failed");
			stat.append("----------------------------------");

			// отсылаем отладочные сообщения
			if(debugCaster)
				attacker.getPlayer().sendMessage(stat.toString());
			if(debugTarget)
				target.getPlayer().sendMessage(stat.toString());
		}
		return result;
	}

	public static double getAbnormalResist(BasicProperty basicProperty, Creature target)
	{
		switch(basicProperty)
		{
			case PHYSICAL_ABNORMAL_RESIST:
				return target.getPhysicalAbnormalResist();
			case MAGIC_ABNORMAL_RESIST:
				return target.getMagicAbnormalResist();
		}
		return 0;
	}
	
	/**
	 * Calculates the attribute bonus with the following formula: <BR>
	 * diff > 0, so AttBonus = 1,025 + sqrt[(diff^3) / 2] * 0,0001, cannot be above 1,25! <BR>
	 * diff < 0, so AttBonus = 0,975 - sqrt[(diff^3) / 2] * 0,0001, cannot be below 0,75! <BR>
	 * diff == 0, so AttBonus = 1
	 * @param attacker
	 * @param target
	 * @param skill Can be {@code null} if there is no skill used for the attack.
	 * @return The attribute bonus
	 */
	public static double calcAttributeBonus(Creature attacker, Creature target, Skill skill)
	{
		int attack_attribute;
		int defence_attribute;

		if(skill != null)
		{
			if((skill.getElement() == Element.NONE) || (skill.getElement() == Element.NONE_ARMOR))
			{
				attack_attribute = 0;
				defence_attribute = target.getDefence(Element.NONE_ARMOR);
			}
			else
			{
				if(attacker.getAttackElement() == skill.getElement())
				{
					attack_attribute = attacker.getAttack(attacker.getAttackElement()) + skill.getElementPower();
					defence_attribute = target.getDefence(attacker.getAttackElement());
				}
				else
				{
					attack_attribute = skill.getElementPower();
					defence_attribute = target.getDefence(skill.getElement());
				}
			}
		}
		else
		{
			attack_attribute = attacker.getAttack(attacker.getAttackElement());
			defence_attribute = target.getDefence(attacker.getAttackElement());
		}

		final int diff = attack_attribute - defence_attribute;
		if(diff > 0)
			return Math.min(1.025 + (Math.sqrt(Math.pow(diff, 3) / 2) * 0.0001), 1.25);

		if(diff < 0)
			return Math.max(0.975 - (Math.sqrt(Math.pow(-diff, 3) / 2) * 0.0001), 0.75);

		return 1;
	}

	public static double calcGeneralTraitBonus(Creature attacker, Creature target, SkillTrait trait, boolean ignoreResistance)
	{
		if(trait == SkillTrait.NONE)
			return 1.;

		Stats defenceStat = trait.getDefence();
		double targetDefence = defenceStat == null ? 0. : target.getStat().calc(defenceStat) * trait.getDefenceMod();
		double targetDefenceModifier = (targetDefence + 100.) / 100.;

		Stats attackStat = trait.getAttack();
		double attackerAttackModifier = ((attackStat == null ? 0. : attacker.getStat().calc(attackStat) * trait.getAttackMod()) + 100.) / 100.;

		switch(trait.getType())
		{
			case WEAKNESS:
			{
				if(attackerAttackModifier == 1. || targetDefenceModifier == 1.)
					return 1.;
				break;
			}
			case RESISTANCE:
			{
				if(ignoreResistance)
					return 1.;
				break;
			}
			default:
				return 1.;
		}

		if(targetDefence == Double.POSITIVE_INFINITY)
			return 0.;

		final double result = (attackerAttackModifier - targetDefenceModifier) + 1.;
		return Math.max(0.05, Math.min(2., result));
	}
	
	public static double calcWeaponTraitBonus(Creature attacker, Creature target)
	{
		final SkillTrait type = attacker.getBaseStats().getAttackType().getTrait();
		Stats defenceStat = type.getDefence();
		if(defenceStat != null)
		{
			double targetDefenceModifier = Config.USE_CUSTOM_DEFENCE_TRAITS ? Config.DEFENCE_TRAIT_WEAPON_MOD : (target.getStat().calc(defenceStat) * type.getDefenceMod() + 100.) / 100.;
			double result = targetDefenceModifier - 1.;
			return 1. - result;
		}
		return 1.;
	}
	
	public static double calcAttackTraitBonus(Creature attacker, Creature target)
	{
		final double weaponTraitBonus = calcWeaponTraitBonus(attacker, target);
		if(weaponTraitBonus == 0)
			return 0;
		
		double weaknessBonus = 1.;
		for(SkillTrait traitType : SkillTrait.VALUES)
		{
			if(traitType.getType() == SkillTraitType.WEAKNESS)
			{
				weaknessBonus *= calcGeneralTraitBonus(attacker, target, traitType, true);
				if(weaknessBonus == 0)
					return 0;
			}
		}
		return Math.max(0.05, Math.min(2., (weaponTraitBonus * weaknessBonus)));
	}
	
	public static double getBasicPropertyResistBonus(BasicProperty basicProperty, Creature target)
	{
		if((basicProperty == BasicProperty.NONE) || !target.hasBasicPropertyResist())
			return 1.0;
		
		final BasicPropertyResist resist = target.getBasicPropertyResist(basicProperty);
		switch(resist.getResistLevel())
		{
			case 0:
				return 1.0;
			case 1:
				return 0.6;
			case 2:
				return 0.3;
		}
		return 0;
	}
	public static double calcDamageDecreaseDif(Creature target, double damage){
		damage -= target.getDamageDecreaseDif();
		return damage;
	}

	public static double calcDamageDecreasePer(Creature target, double damage){
		damage *= target.getDamageDecreasePer();
		return damage;
	}

	public static double calcRaidBossDamageDamage(Creature attacker, double damage){
		damage *= attacker.getRaidBossDamage();
		return damage;
	}

	/**
	 * @param totalAttackTime the time needed to make a full attack.
	 * @param attackType the weapon type used for attack.
	 * @param secondHit calculates the second hit for dual attacks.
	 * @return the time required from the start of the attack until you hit the target.
	 */
	public static int calculateTimeToHit(int totalAttackTime, WeaponTemplate.WeaponType attackType, boolean secondHit) {
		// Gracia Final Retail confirmed:
		// Time to damage (1 hand, 1 hit): TotalBasicAttackTime * 0.644
		// Time to damage (2 hand, 1 hit): TotalBasicAttackTime * 0.735
		// Time to damage (2 hand, 2 hit): TotalBasicAttackTime * 0.2726 and TotalBasicAttackTime * 0.6
		// Time to damage (bow/xbow): TotalBasicAttackTime * 0.978

		// Measured July 2016 by Nik.
		// Due to retail packet delay, we are unable to gather too accurate results. Therefore the below formulas are based on original Gracia Final values.
		// Any original values that appear higher than tested have been replaced with the tested values, because even with packet delay its obvious they are wrong.
		// All other original values are compared with the test results and differences are considered to be too insignificant and mostly caused due to packet delay.
		switch (attackType) {
			// Bows
			case BOW:
			case CROSSBOW: {
				return (int) (totalAttackTime * 0.95);
			}
			// Dual weapons
			case DUALDAGGER:
			case DUAL:
			case DUALFIST: {
				if (secondHit) {
					return (int) (totalAttackTime * 0.6);
				}
				return (int) (totalAttackTime * 0.2726);
			}
			// One-hand weapons
			case SWORD:
			case BLUNT:
			case DAGGER:
			case RAPIER:
			case ETC:
				return (int) (totalAttackTime * 0.644);
			default: {
				return (int) (totalAttackTime * 0.735);
			}
		}
	}
}