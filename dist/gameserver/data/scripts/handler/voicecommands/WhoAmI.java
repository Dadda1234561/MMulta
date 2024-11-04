package handler.voicecommands;

import l2s.gameserver.data.htm.HtmCache;
import l2s.gameserver.model.Creature;
import l2s.gameserver.model.Player;
import l2s.gameserver.model.base.Element;
import l2s.gameserver.model.items.ItemInstance;
import l2s.gameserver.network.l2.components.HtmlMessage;
import l2s.gameserver.stats.Stats;
import l2s.gameserver.templates.item.WeaponTemplate.WeaponType;
import l2s.gameserver.utils.HtmlUtils;
import org.apache.commons.text.TextStringBuilder;

import java.text.NumberFormat;
import java.util.Locale;

public class WhoAmI extends ScriptVoiceCommandHandler
{
	private final String[] COMMANDS = new String[] { "whoami", "whoiam" };

	@Override
	public boolean useVoicedCommand(String command, Player player, String args)
	{
		Creature target = null;

		//TODO [G1ta0] добавить рефлекты
		//TODO [G1ta0] возможно стоит показывать статы в зависимости от цели
		double hpRegen = player.getHpRegen();
		double cpRegen = player.getCpRegen();
		double mpRegen = player.getMpRegen();
		double hpDrain = 0;
		double mpDrain = 0;
		for(int i = 0; i < 100; i++) {
			hpDrain = Math.max(hpDrain, player.getStat().calc(Stats.VAMPIRIC_ATTACK, target, null));
			mpDrain = Math.max(mpDrain, player.getStat().calc(Stats.MP_VAMPIRIC_ATTACK, target, null));
		}
		double hpGain = player.getStat().getMul(Stats.HEAL_EFFECT, target, null) * 100;
		double mpGain = player.getStat().calc(Stats.MANAHEAL_EFFECTIVNESS, 100., target, null);

		double pCritPercMul = (player.getStat().getMul(Stats.CRITICAL_DAMAGE, target, null) - 1) * 100;
		double pCritStatic = player.getStat().getAdd(Stats.CRITICAL_DAMAGE, target, null);
		double pCritPerc = player.getStat().calc(Stats.CRITICAL_DAMAGE, 100., target, null) - pCritStatic + pCritPercMul;

		double mCritPercMul = (player.getStat().getMul(Stats.MAGIC_CRITICAL_DMG, target, null) - 1) * 100;
		double mCritStatic = player.getStat().getAdd(Stats.MAGIC_CRITICAL_DMG, target, null);
		double mCritPerc = player.getStat().calc(Stats.MAGIC_CRITICAL_DMG, 100., target, null) - mCritStatic + mCritPercMul;

		double blowRate = player.getStat().calc(Stats.FATALBLOW_RATE, target, null) * 100. - 100.;

		double shieldDef = player.getStat().calc(Stats.SHIELD_DEFENCE, player.getBaseStats().getShldDef(), target, null);
		double shieldRate = player.getStat().calc(Stats.SHIELD_RATE, target, null);

		double xpRate = player.getRateExpWhoAmI();
		double spRate = player.getRateSpWhoAmI();
		double dropRate = player.getDropCountMod();
		double adenaRate = player.getRateAdena();
		double spoilRate = player.getSpoilCountMod();

		double fireResist = player.getStat().calc(Element.FIRE.getDefence(), 0., target, null);
		double windResist = player.getStat().calc(Element.WIND.getDefence(), 0., target, null);
		double waterResist = player.getStat().calc(Element.WATER.getDefence(), 0., target, null);
		double earthResist = player.getStat().calc(Element.EARTH.getDefence(), 0., target, null);
		double holyResist = player.getStat().calc(Element.HOLY.getDefence(), 0., target, null);
		double unholyResist = player.getStat().calc(Element.UNHOLY.getDefence(), 0., target, null);

		double bleedPower = player.getStat().calc(Stats.ATTACK_TRAIT_BLEED);
		double bleedResist = player.getStat().calc(Stats.DEFENCE_TRAIT_BLEED);
		double poisonPower = player.getStat().calc(Stats.ATTACK_TRAIT_POISON);
		double poisonResist = player.getStat().calc(Stats.DEFENCE_TRAIT_POISON);
		double stunPower = player.getStat().calc(Stats.ATTACK_TRAIT_SHOCK);
		double stunResist = player.getStat().calc(Stats.DEFENCE_TRAIT_SHOCK);
		double rootPower = player.getStat().calc(Stats.ATTACK_TRAIT_HOLD);
		double rootResist = player.getStat().calc(Stats.DEFENCE_TRAIT_HOLD);
		double sleepPower = player.getStat().calc(Stats.ATTACK_TRAIT_SLEEP);
		double sleepResist = player.getStat().calc(Stats.DEFENCE_TRAIT_SLEEP);
		double paralyzePower = player.getStat().calc(Stats.ATTACK_TRAIT_PARALYZE);
		double paralyzeResist = player.getStat().calc(Stats.DEFENCE_TRAIT_PARALYZE);
		double mentalPower = player.getStat().calc(Stats.ATTACK_TRAIT_DERANGEMENT);
		double mentalResist = player.getStat().calc(Stats.DEFENCE_TRAIT_DERANGEMENT);
		double debuffResist = player.getStat().calc(Stats.RESIST_ABNORMAL_DEBUFF, target, null);
		double cancelPower = player.getStat().calc(Stats.CANCEL_POWER, target, null);
		double cancelResist = player.getStat().calc(Stats.CANCEL_RESIST, target, null);

		double swordResist = player.getStat().calc(Stats.DEFENCE_TRAIT_SWORD);
		double dualResist = player.getStat().calc(Stats.DEFENCE_TRAIT_DUAL);
		double bluntResist = player.getStat().calc(Stats.DEFENCE_TRAIT_BLUNT);
		double daggerResist = player.getStat().calc(Stats.DEFENCE_TRAIT_DAGGER);
		double bowResist = player.getStat().calc(Stats.DEFENCE_TRAIT_BOW);
		double crossbowResist = player.getStat().calc(Stats.DEFENCE_TRAIT_CROSSBOW);
		double twoHandCrossbowResist = player.getStat().calc(Stats.DEFENCE_TRAIT_TWOHANDCROSSBOW);
		double poleResist = player.getStat().calc(Stats.DEFENCE_TRAIT_POLE);
		double fistResist = player.getStat().calc(Stats.DEFENCE_TRAIT_FIST);

		double critChanceResist = 100. - player.getStat().calc(Stats.P_CRIT_CHANCE_RECEPTIVE, target, null);
		double critDamResist = 100. - player.getStat().calc(Stats.P_CRIT_DAMAGE_RECEPTIVE, target, null);

		// PvP Dmg bonus
		double pvpPhysDmgBonus = player.getStat().calc(Stats.PVP_PHYS_DMG_BONUS, 100., target, null);
		double pvpPhysSkillDmgBonus = player.getStat().calc(Stats.PVP_PHYS_SKILL_DMG_BONUS, 100., target, null);
		double pvpMagicSkillDmgBonus = player.getStat().calc(Stats.PVP_MAGIC_SKILL_DMG_BONUS, 100., target, null);
		// PvP Def bonus
		double pvpPhysDefenceBonus = player.getStat().calc(Stats.PVP_PHYS_DEFENCE_BONUS, 100., target, null);
		double pvpPhysSkillDefenceBonus = player.getStat().calc(Stats.PVP_PHYS_SKILL_DEFENCE_BONUS, 100., target, null);
		double pvpMagicSkillDefenceBonus = player.getStat().calc(Stats.PVP_MAGIC_SKILL_DEFENCE_BONUS, 100., target, null);
		// PvE Dmg bonus
		double pvePhysDmgBonus = player.getStat().calc(Stats.PVE_PHYS_DMG_BONUS, 100., target, null);
		double pvePhysSkillDmgBonus = player.getStat().calc(Stats.PVE_PHYS_SKILL_DMG_BONUS, 100., target, null);
		double pveMagicSkillDmgBonus = player.getStat().calc(Stats.PVE_MAGIC_SKILL_DMG_BONUS, 100., target, null);


		double physCriticalDmg = player.getStat().calc(Stats.CRITICAL_DAMAGE);
		double magicCriticalDmg = player.getStat().calc(Stats.MAGIC_CRITICAL_DMG);
		double magicReuse = player.getStat().calc(Stats.MAGIC_REUSE_RATE, 100.);
		magicReuse = Math.max(20.0, magicReuse); // limit magic reuse display
		double reflectDam = player.getStat().calc(Stats.REFLECT_DAMAGE_PERCENT);
		double receivePhysDam = player.getStat().calc(Stats.RECEIVE_P_DAMAGE_POWER, 100.);
		double receiveMagDam = player.getStat().calc(Stats.RECEIVE_M_DAMAGE_POWER, 100.);
		double pSkillPower = player.getStat().calc(Stats.P_SKILL_POWER, 100.);
		double mSkillPower = player.getStat().calc(Stats.M_SKILL_POWER, 100.);
		double raidBossDamage = player.getStat().calc(Stats.RAID_BOSS_DAMAGE, 100.);
		double PVEdefence = player.getStat().calc(Stats.PVE_PHYS_DEFENCE_BONUS, 100.);
		double soulShotDmg = player.getStat().calc(Stats.SOULSHOT_POWER, 100.) + player.getChargedSoulshotPower();
		double spiritShotDmg = player.getStat().calc(Stats.SPIRITSHOT_POWER, 100.) + player.getChargedSpiritshotPower();


		String dialog = HtmCache.getInstance().getHtml("command/whoami.htm", player);

		NumberFormat iNtDf = NumberFormat.getInstance(Locale.ENGLISH);
		iNtDf.setMaximumIntegerDigits(2);
		iNtDf.setMinimumIntegerDigits(2);

		NumberFormat df = NumberFormat.getInstance(Locale.ENGLISH);
		df.setMaximumFractionDigits(1);
		df.setMinimumFractionDigits(0);

		TextStringBuilder sb = new TextStringBuilder(dialog);
		// PvP Dmg bonus
		sb.replaceFirst("%pvpPhysDmgBonus%", df.format(pvpPhysDmgBonus > 0 ? pvpPhysDmgBonus - 100: 0));
		sb.replaceFirst("%pvpPhysSkillDmgBonus%", df.format(pvpPhysSkillDmgBonus > 0 ? pvpPhysSkillDmgBonus - 100: 0));
		sb.replaceFirst("%pvpMagicSkillDmgBonus%", df.format(pvpMagicSkillDmgBonus > 0 ? pvpMagicSkillDmgBonus - 100: 0));
		// PvP Def bonus
		sb.replaceFirst("%pvpPhysDefenceBonus%", df.format(pvpPhysDefenceBonus > 0 ? pvpPhysDefenceBonus - 100: 0));
		sb.replaceFirst("%pvpPhysSkillDefenceBonus%", df.format(pvpPhysSkillDefenceBonus > 0 ? pvpPhysSkillDefenceBonus - 100: 0));
		sb.replaceFirst("%pvpMagicSkillDefenceBonus%", df.format(pvpMagicSkillDefenceBonus > 0 ? pvpMagicSkillDefenceBonus - 100: 0));
		// PvE Dmg bonus
		sb.replaceFirst("%pvePhysDmgBonus%", df.format(pvePhysDmgBonus > 0 ? pvePhysDmgBonus - 100: 0));
		sb.replaceFirst("%pvePhysSkillDmgBonus%", df.format(pvePhysSkillDmgBonus > 0 ? pvePhysSkillDmgBonus - 100: 0));
		sb.replaceFirst("%pveMagicSkillDmgBonus%", df.format(pveMagicSkillDmgBonus > 0 ? pveMagicSkillDmgBonus - 100: 0));

		sb.replaceFirst("%hpRegen%", df.format(hpRegen));
		sb.replaceFirst("%cpRegen%", df.format(cpRegen));
		sb.replaceFirst("%mpRegen%", df.format(mpRegen));
		sb.replaceFirst("%hpDrain%", df.format(hpDrain));
		sb.replaceFirst("%mpDrain%", df.format(mpDrain));
		sb.replaceFirst("%hpGain%", df.format(hpGain));
		sb.replaceFirst("%mpGain%", df.format(mpGain));
		sb.replaceFirst("%pCritPerc%", df.format(pCritPerc > 0 ? pCritPerc - 100: 0));
		sb.replaceFirst("%pCritStatic%", df.format(pCritStatic));
		sb.replaceFirst("%mCritPerc%", df.format(mCritPerc > 0 ? mCritPerc - 100: 0));
		sb.replaceFirst("%mCritStatic%", df.format(mCritStatic));
		sb.replaceFirst("%blowRate%", df.format(blowRate));
		sb.replaceFirst("%shieldDef%", df.format(shieldDef));
		sb.replaceFirst("%shieldRate%", df.format(shieldRate));
		sb.replaceFirst("%xpRate%", df.format(xpRate));
		sb.replaceFirst("%spRate%", df.format(spRate));
		sb.replaceFirst("%dropRate%", df.format(dropRate));
		sb.replaceFirst("%adenaRate%", df.format(adenaRate));
		sb.replaceFirst("%spoilRate%", df.format(spoilRate));
		sb.replaceFirst("%fireResist%", df.format(fireResist));
		sb.replaceFirst("%windResist%", df.format(windResist));
		sb.replaceFirst("%waterResist%", df.format(waterResist));
		sb.replaceFirst("%earthResist%", df.format(earthResist));
		sb.replaceFirst("%holyResist%", df.format(holyResist));
		sb.replaceFirst("%darkResist%", df.format(unholyResist));
		sb.replaceFirst("%bleedPower%", bleedPower == Double.POSITIVE_INFINITY ? (player.isLangRus() ? "Неуяз." : "Invul.") : df.format(bleedPower));
		sb.replaceFirst("%bleedResist%", bleedResist == Double.POSITIVE_INFINITY ? (player.isLangRus() ? "Неуяз." : "Invul.") : df.format(bleedResist));
		sb.replaceFirst("%poisonPower%", poisonPower == Double.POSITIVE_INFINITY ? (player.isLangRus() ? "Неуяз." : "Invul.") : df.format(poisonPower));
		sb.replaceFirst("%poisonResist%", poisonResist == Double.POSITIVE_INFINITY ? (player.isLangRus() ? "Неуяз." : "Invul.") : df.format(poisonResist));
		sb.replaceFirst("%stunPower%", stunPower == Double.POSITIVE_INFINITY ? (player.isLangRus() ? "Неуяз." : "Invul.") : df.format(stunPower));
		sb.replaceFirst("%stunResist%", stunResist == Double.POSITIVE_INFINITY ? (player.isLangRus() ? "Неуяз." : "Invul.") : df.format(stunResist));
		sb.replaceFirst("%rootPower%", rootPower == Double.POSITIVE_INFINITY ? (player.isLangRus() ? "Неуяз." : "Invul.") : df.format(rootPower));
		sb.replaceFirst("%rootResist%", rootResist == Double.POSITIVE_INFINITY ? (player.isLangRus() ? "Неуяз." : "Invul.") : df.format(rootResist));
		sb.replaceFirst("%sleepPower%", sleepPower == Double.POSITIVE_INFINITY ? (player.isLangRus() ? "Неуяз." : "Invul.") : df.format(sleepPower));
		sb.replaceFirst("%sleepResist%", sleepResist == Double.POSITIVE_INFINITY ? (player.isLangRus() ? "Неуяз." : "Invul.") : df.format(sleepResist));
		sb.replaceFirst("%paralyzePower%", paralyzePower == Double.POSITIVE_INFINITY ? (player.isLangRus() ? "Неуяз." : "Invul.") : df.format(paralyzePower));
		sb.replaceFirst("%paralyzeResist%", paralyzeResist == Double.POSITIVE_INFINITY ? (player.isLangRus() ? "Неуяз." : "Invul.") : df.format(paralyzeResist));
		sb.replaceFirst("%mentalPower%", mentalPower == Double.POSITIVE_INFINITY ? (player.isLangRus() ? "Неуяз." : "Invul.") : df.format(mentalPower));
		sb.replaceFirst("%mentalResist%", mentalResist == Double.POSITIVE_INFINITY ? (player.isLangRus() ? "Неуяз." : "Invul.") : df.format(mentalResist));
		sb.replaceFirst("%debuffResist%", df.format(debuffResist));
		sb.replaceFirst("%cancelPower%", df.format(cancelPower));
		sb.replaceFirst("%cancelResist%", df.format(cancelResist));
		sb.replaceFirst("%swordResist%", swordResist == Double.POSITIVE_INFINITY ? (player.isLangRus() ? "Неуяз." : "Invul.") : df.format(swordResist));
		sb.replaceFirst("%dualResist%", dualResist == Double.POSITIVE_INFINITY ? (player.isLangRus() ? "Неуяз." : "Invul.") : df.format(dualResist));
		sb.replaceFirst("%bluntResist%", bluntResist == Double.POSITIVE_INFINITY ? (player.isLangRus() ? "Неуяз." : "Invul.") : df.format(bluntResist));
		sb.replaceFirst("%daggerResist%", daggerResist == Double.POSITIVE_INFINITY ? (player.isLangRus() ? "Неуяз." : "Invul.") : df.format(daggerResist));
		sb.replaceFirst("%bowResist%", bowResist == Double.POSITIVE_INFINITY ? (player.isLangRus() ? "Неуяз." : "Invul.") : df.format(bowResist));
		sb.replaceFirst("%crossbowResist%", crossbowResist == Double.POSITIVE_INFINITY ? (player.isLangRus() ? "Неуяз." : "Invul.") : df.format(crossbowResist));
		sb.replaceFirst("%twoHandCrossbowResist%", twoHandCrossbowResist == Double.POSITIVE_INFINITY ? (player.isLangRus() ? "Неуяз." : "Invul.") : df.format(twoHandCrossbowResist));
		sb.replaceFirst("%fistResist%", fistResist == Double.POSITIVE_INFINITY ? (player.isLangRus() ? "Неуяз." : "Invul.") : df.format(fistResist));
		sb.replaceFirst("%poleResist%", poleResist == Double.POSITIVE_INFINITY ? (player.isLangRus() ? "Неуяз." : "Invul.") : df.format(poleResist));
		sb.replaceFirst("%critChanceResist%", df.format(critChanceResist));
		sb.replaceFirst("%critDamResist%", df.format(critDamResist));
		sb.replaceFirst("%physCriticalDmg%", df.format(physCriticalDmg));
		sb.replaceFirst("%magicCriticalDmg%", df.format(magicCriticalDmg));
		sb.replaceFirst("%magicReuse%", (100 - magicReuse) == 0 ? "0%" : (df.format(100 - magicReuse) + "%"));
		sb.replaceFirst("%reflectDam%", df.format(reflectDam));
		sb.replaceFirst("%receivePhysDam%", df.format(receivePhysDam > 0 ? receivePhysDam - 100: 0));
		sb.replaceFirst("%receiveMagDam%",df.format(receiveMagDam > 0 ? receiveMagDam - 100: 0));
		sb.replaceFirst("%pSkillPower%", df.format(pSkillPower > 0 ? pSkillPower - 100: 0));
		sb.replaceFirst("%mSkillPower%",df.format(mSkillPower > 0 ? mSkillPower - 100: 0));
		sb.replaceFirst("%raidBossDamage%",df.format(raidBossDamage > 0 ? raidBossDamage - 100: 0));
		sb.replaceFirst("%PVEdefence%",df.format(PVEdefence > 0 ? PVEdefence - 100: 0));
		sb.replaceFirst("%soulShotDmg%",df.format(soulShotDmg > 0 ? soulShotDmg - 100: 0));
		sb.replaceFirst("%spiritShotDmg%",df.format(spiritShotDmg > 0 ? spiritShotDmg - 100: 0));




		HtmlMessage msg = new HtmlMessage(0);
		msg.setHtml(HtmlUtils.bbParse(sb.toString()));
		player.sendPacket(msg);

		return true;
	}

	@Override
	public String[] getVoicedCommandList()
	{
		return COMMANDS;
	}
}
