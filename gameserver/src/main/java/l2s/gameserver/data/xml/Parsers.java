package l2s.gameserver.data.xml;

import l2s.gameserver.ThreadPoolManager;
import l2s.gameserver.data.htm.HtmCache;
import l2s.gameserver.data.string.*;
import l2s.gameserver.data.xml.parser.*;
import l2s.gameserver.instancemanager.ReflectionManager;

/**
 * @author VISTALL
 * @date  20:55/30.11.2010
 */
public abstract class Parsers
{
	public static void parseAll()
	{
		ThreadPoolManager.getInstance().execute(() -> HtmCache.getInstance().reload());
		StringsHolder.getInstance().load();
		ItemNameHolder.getInstance().load();
		NpcNameHolder.getInstance().load();
		NpcStringHolder.getInstance().load();
		SkillNameHolder.getInstance().load();
		SkillDescHolder.getInstance().load();
		//
		SkillEnchantInfoParser.getInstance().load();
		SkillParser.getInstance().load();
		OptionDataParser.getInstance().load();
		VariationDataParser.getInstance().load();
		AgathionParser.getInstance().load();
		ItemParser.getInstance().load();
		ItemDeletionParser.getInstance().load();
		EnsoulParser.getInstance().load();
		RecipeParser.getInstance().load();
		AlchemyDataParser.getInstance().load();
		CrystallizationDataParser.getInstance().load();
		SynthesisDataParser.getInstance().load();
		CollectionsParser.getInstance().load();
		GearScoreParser.getInstance().load();
		//
		ExperienceDataParser.getInstance().load();
		BaseStatsBonusParser.getInstance().load();
		BeautyShopParser.getInstance().load();
		LevelBonusParser.getInstance().load();
		KarmaIncreaseDataParser.getInstance().load();
		HitCondBonusParser.getInstance().load();
		PlayerTemplateParser.getInstance().load();
		InitialShortCutsParser.getInstance().load();
		ClassDataParser.getInstance().load();
		TransformTemplateParser.getInstance().load();
		NpcParser.getInstance().load();
		PetDataParser.getInstance().load();
		FactionDataParser.getInstance().load();
		CostumeParser.getInstance().load();
		TeleportListParser.getInstance().load();
		DomainParser.getInstance().load();
		RestartPointParser.getInstance().load();

		StaticObjectParser.getInstance().load();
		DoorParser.getInstance().load();
		ZoneParser.getInstance().load();
		SpawnParser.getInstance().load();
		InstantZoneParser.getInstance().load();
		TimeRestrictFieldParser.getInstance().load();

		ReflectionManager.getInstance().init();
		//
		AirshipDockParser.getInstance().load();
		SkillAcquireParser.getInstance().load();
		ClanMasteryParser.getInstance().load();
		ClanShopParser.getInstance().load();
		//
		ResidenceFunctionsParser.getInstance().load();
		ResidenceParser.getInstance().load();
		ShuttleTemplateParser.getInstance().load();
		FightClubMapParser.getInstance().load();
		EventParser.getInstance().load();
		// support(cubic & agathion)
		CubicParser.getInstance().load();
		//
		BuyListParser.getInstance().load();
		MultiSellParser.getInstance().load();
		UpgradeSystemParser.getInstance().load();
		ProductDataParser.getInstance().load();
		AttendanceRewardParser.getInstance().load();
		LimitedShopParser.getInstance().load();
		SymbolSealParser.getInstance().load();
		HomunculusParser.getInstance().load();
		// AgathionParser.getInstance();
		// item support
		HennaParser.getInstance().load();
		JumpTracksParser.getInstance().load();
		EnchantItemParser.getInstance().load();
		EnchantStoneParser.getInstance().load();
		AttributeStoneParser.getInstance().load();
		AppearanceStoneParser.getInstance().load();
		ArmorSetsParser.getInstance().load();
		FishDataParser.getInstance().load();
		RandomCraftListParser.getInstance().load();

		LevelUpRewardParser.getInstance().load();
		LuckyGameParser.getInstance().load();

		PremiumAccountParser.getInstance().load();

		// etc
		PetitionGroupParser.getInstance().load();
		BotReportPropertiesParser.getInstance().load();

		PledgeMissionsParser.getInstance().load();
		FestivalBMParser.getInstance().load();

		DailyMissionsParser.getInstance().load();

		// Fake players
		FakeItemParser.getInstance().load();
		FakePlayersParser.getInstance().load();

		ChampionTemplateParser.getInstance().load();
		UpMonsterTemplateParser.getInstance().load();

		// Alt dimension data
		AltDimensionParser.getInstance().load();

		// Parse smelting resources
		ResourceParser.getInstance().load();
	}
}
