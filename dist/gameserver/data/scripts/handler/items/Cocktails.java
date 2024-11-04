package handler.items;
import l2s.gameserver.model.Player;
import l2s.gameserver.model.items.ItemInstance;
import l2s.gameserver.skills.SkillEntry;
import l2s.gameserver.skills.SkillEntryType;

public class Cocktails extends SimpleItemHandler
{
	// Sweet Fruit Cocktail
	private static final int[] sweet_list = { 2404, // Might
			2405, // Shield
			2406, // Wind Walk
			2407, // Focus
			2408, // Death Whisper
			2409, // Guidance
			2410, // Bless Shield
			2411, // Bless Body
			2412, // Haste
			2413, // Vampiric Rage
	};

	// Fresh Fruit Cocktail
	private static final int[] fresh_list = { 2414, // Berserker Spirit
			2411, // Bless Body
			2415, // Magic Barrier
			2405, // Shield
			2406, // Wind Walk
			2416, // Bless Soul
			2417, // Empower
			2418, // Acumen
			2419, // Clarity
	};

	//Event - Fresh Milk
	private static final int[] milk_list = { 2873, 2874, 2875, 2876, 2877, 2878, 2879, 2885, 2886, 2887, 2888, 2889, 2890, };

	//Elixir of Blessing
	private static final int[] ELIXIR_OF_BLESSING_LIST = { 9198, 9200, 9201, 9202, 9203, 9199 };
	private static final int[] ELIXIR_OF_BLESSING_LIST_2 = { 9198, 9200, 9201, 9202, 9203, 9199 };
	private static final int[] ELIXIR_OF_BLESSING_IMPERATOR_ATK = { 22929, 22931, 22933, 22935, 22937, 22939, 9660, 17297, 17298, 17299 };
	private static final int[] ELIXIR_OF_BLESSING_IMPERATOR_DEF = { 22929, 22931, 22933, 22935, 22937, 22939, 9661, 17297, 17298, 17299 };
	private static final int[] ELIXIR_OF_BLESSING_IMPERATOR_MAGE = { 22929, 22931, 22933, 22935, 22937, 22939, 9662, 17297, 17298, 17299 };
	private static final int[] ELIXIR_OF_BLESSING_EMPERATOR_COOKIE = { 17297, 17298, 17299 };

	// Chaos Festival Elixirs
	private static final int[] CHAOS_ELIXIR_GUARD_LIST = { 9545, 9546, 9547, 9548, 9549, 9550, 9551 };
	private static final int[] CHAOS_ELIXIR_BERSERK_LIST = { 9545, 9546, 9547, 9548, 9549, 9550, 9552 };
	private static final int[] CHAOS_ELIXIR_MAGIC_LIST = { 9545, 9546, 9547, 9548, 9549, 9550, 9553 };

	private static final int[] BUFF_LIST_20876 = { 22145, 22153 };
	private static final int[] BUFF_LIST_20877 = { 22143, 22144, 22154 };
	private static final int[] BUFF_LIST_20878 = { 22155, 22142, 22150 };
	private static final int[] BUFF_LIST_20879 = { 22149, 22157, 22147 };
	private static final int[] BUFF_LIST_20880 = { 22146, 22151, 22152 };
	private static final int[] BUFF_LIST_20881 = { 22140, 22156 };
	private static final int[] BUFF_LIST_20882 = { 22148, 22141, 22139 };
	
	// Особый Коктейль Императора - Защита
	private static final int[] EMPERORS_SPECIAL_COCTAIL_DEFENSE_LIST = {
			39407, // Horn Melody - Emperor's Special Cocktail 
			39410, // Guitar Melody - Emperor's Special Cocktail 
			39409, // Pipe Organ Melody - Emperor's Special Cocktail 
			39408, // Drum Melody - Emperor's Special Cocktail
			39417, // Гармония Стража - Особый Коктейль Императора
			39414, // War Drum - Emperor's Special Cocktail
			39415, // Marching Drum - Emperor's Special Cocktail
			39416, // Soothing Drum - Emperor's Special Cocktail
			39411, // Elemental Resistance - Emperor's Special Cocktail
			39412, // Resistance Debuff - Emperor's Special Cocktail
			39413, // Mental Attack Resistance - Emperor's Special Cocktail
	};
	
	// Особый Коктейль Императора - Атака
	private static final int[] EMPERORS_SPECIAL_COCTAIL_ATTACK_LIST = {
			39407, // Horn Melody - Emperor's Special Cocktail 
			39410, // Guitar Melody - Emperor's Special Cocktail 
			39409, // Pipe Organ Melody - Emperor's Special Cocktail 
			39408, // Drum Melody - Emperor's Special Cocktail
			39418, // Гармония Берсерка - Особый Коктейль Императора
			39414, // War Drum - Emperor's Special Cocktail
			39415, // Marching Drum - Emperor's Special Cocktail
			39416, // Soothing Drum - Emperor's Special Cocktail
			39411, // Elemental Resistance - Emperor's Special Cocktail
			39412, // Resistance Debuff - Emperor's Special Cocktail
			39413, // Mental Attack Resistance - Emperor's Special Cocktail
	};
	
	// Особый Коктейль Императора - Магия
	private static final int[] EMPERORS_SPECIAL_COCTAIL_MAGIC_LIST = {
			39407, // Horn Melody - Emperor's Special Cocktail 
			39410, // Guitar Melody - Emperor's Special Cocktail 
			39409, // Pipe Organ Melody - Emperor's Special Cocktail 
			39408, // Drum Melody - Emperor's Special Cocktail
			39419, // Гармония Мага - Особый Коктейль Императора
			39414, // War Drum - Emperor's Special Cocktail
			39415, // Marching Drum - Emperor's Special Cocktail
			39416, // Soothing Drum - Emperor's Special Cocktail
			39411, // Elemental Resistance - Emperor's Special Cocktail
			39412, // Resistance Debuff - Emperor's Special Cocktail
			39413, // Mental Attack Resistance - Emperor's Special Cocktail
	};
	
	@Override
	protected boolean useItemImpl(Player player, ItemInstance item, boolean ctrl)
	{
		int itemId = item.getItemId();

		if(!reduceItem(player, item))
			return false;

		sendUseMessage(player, item);

		switch(itemId)
		{
			// Sweet Fruit Cocktail
			case 10178:
			case 15356:
			case 20393:
				for(int skill : sweet_list)
					player.forceUseSkill(SkillEntry.makeSkillEntry(SkillEntryType.CUNSUMABLE_ITEM, skill, 1), player);
				break;
			// Fresh Fruit Cocktail				
			case 10179:
			case 15357:
			case 20394:
				for(int skill : fresh_list)
					player.forceUseSkill(SkillEntry.makeSkillEntry(SkillEntryType.CUNSUMABLE_ITEM, skill, 1), player);
				break;
			//Event - Fresh Milk				
			case 14739:
				player.forceUseSkill(SkillEntry.makeSkillEntry(SkillEntryType.CUNSUMABLE_ITEM, 2891, 6), player);
				for(int skill : milk_list)
					player.forceUseSkill(SkillEntry.makeSkillEntry(SkillEntryType.CUNSUMABLE_ITEM, skill, 1), player);
				break;
			case 32316:
			case 33766:
			case 33862:
				for(int skill_id : ELIXIR_OF_BLESSING_LIST)
					player.forceUseSkill(SkillEntry.makeSkillEntry(SkillEntryType.CUNSUMABLE_ITEM, skill_id, 1), player);
				break;
			case 34620:
				for(int skill_id : ELIXIR_OF_BLESSING_LIST_2)
					player.forceUseSkill(SkillEntry.makeSkillEntry(SkillEntryType.CUNSUMABLE_ITEM, skill_id, 1), player);
				break;
			case 35991:
				for(int skill_id : CHAOS_ELIXIR_BERSERK_LIST)
					player.forceUseSkill(SkillEntry.makeSkillEntry(SkillEntryType.CUNSUMABLE_ITEM, skill_id, 1), player);
				break;
			case 35992:
				for(int skill_id : CHAOS_ELIXIR_MAGIC_LIST)
					player.forceUseSkill(SkillEntry.makeSkillEntry(SkillEntryType.CUNSUMABLE_ITEM, skill_id, 1), player);
				break;
			case 35993:
				for(int skill_id : CHAOS_ELIXIR_GUARD_LIST)
					player.forceUseSkill(SkillEntry.makeSkillEntry(SkillEntryType.CUNSUMABLE_ITEM, skill_id, 1), player);
				break;
			case 20876:
				for(int skill : BUFF_LIST_20876)
					player.forceUseSkill(SkillEntry.makeSkillEntry(SkillEntryType.CUNSUMABLE_ITEM, skill, 1), player);
				break;
			case 20877:
				for(int skill : BUFF_LIST_20877)
					player.forceUseSkill(SkillEntry.makeSkillEntry(SkillEntryType.CUNSUMABLE_ITEM, skill, 1), player);
				break;
			case 20878:
				for(int skill : BUFF_LIST_20878)
					player.forceUseSkill(SkillEntry.makeSkillEntry(SkillEntryType.CUNSUMABLE_ITEM, skill, 1), player);
				break;
			case 20879:
				for(int skill : BUFF_LIST_20879)
					player.forceUseSkill(SkillEntry.makeSkillEntry(SkillEntryType.CUNSUMABLE_ITEM, skill, 1), player);
				break;
			case 20880:
				for(int skill : BUFF_LIST_20880)
					player.forceUseSkill(SkillEntry.makeSkillEntry(SkillEntryType.CUNSUMABLE_ITEM, skill, 1), player);
				break;
			case 20881:
				for(int skill : BUFF_LIST_20881)
					player.forceUseSkill(SkillEntry.makeSkillEntry(SkillEntryType.CUNSUMABLE_ITEM, skill, 1), player);
				break;
			case 20882:
				for(int skill : BUFF_LIST_20882)
					player.forceUseSkill(SkillEntry.makeSkillEntry(SkillEntryType.CUNSUMABLE_ITEM, skill, 1), player);
				break;
			case 37100:	// Elixir of Protection
				player.forceUseSkill(SkillEntry.makeSkillEntry(SkillEntryType.CUNSUMABLE_ITEM, 11523, 1), player);
				break;
			case 37101:	// Elixir of Magic
				player.forceUseSkill(SkillEntry.makeSkillEntry(SkillEntryType.CUNSUMABLE_ITEM, 11525, 1), player);
				break;
			case 37102:	// Elixir of Aggression
				player.forceUseSkill(SkillEntry.makeSkillEntry(SkillEntryType.CUNSUMABLE_ITEM, 11524, 1), player);
				break;
			case 37944:
				for(int skill : ELIXIR_OF_BLESSING_EMPERATOR_COOKIE)
					player.forceUseSkill(SkillEntry.makeSkillEntry(SkillEntryType.CUNSUMABLE_ITEM, skill, 1), player);
				break;
			case 38581:
				for(int skill : ELIXIR_OF_BLESSING_IMPERATOR_ATK)
					player.forceUseSkill(SkillEntry.makeSkillEntry(SkillEntryType.CUNSUMABLE_ITEM, skill, 1), player);
				break;
			case 38583:
				for(int skill : ELIXIR_OF_BLESSING_IMPERATOR_DEF)
					player.forceUseSkill(SkillEntry.makeSkillEntry(SkillEntryType.CUNSUMABLE_ITEM, skill, 1), player);
				break;
			case 38582:
				for(int skill : ELIXIR_OF_BLESSING_IMPERATOR_MAGE)
					player.forceUseSkill(SkillEntry.makeSkillEntry(SkillEntryType.CUNSUMABLE_ITEM, skill, 1), player);
				break;
			case 80753: // Особый Коктейль Императора для ПА - Атака
			case 80061: // Особый Коктейль Императора - Атака
				for(int skill : EMPERORS_SPECIAL_COCTAIL_ATTACK_LIST)
					player.forceUseSkill(SkillEntry.makeSkillEntry(SkillEntryType.CUNSUMABLE_ITEM, skill, 1), player);
				break;	
			case 80754: // Особый Коктейль Императора для ПА - Магия	
			case 80062: // Особый Коктейль Императора - Магия
				for(int skill : EMPERORS_SPECIAL_COCTAIL_MAGIC_LIST)
					player.forceUseSkill(SkillEntry.makeSkillEntry(SkillEntryType.CUNSUMABLE_ITEM, skill, 1), player);
				break;
			case 80755: // Особый Коктейль Императора для ПА - Защита
			case 80063: // Особый Коктейль Императора - Защита
				for(int skill : EMPERORS_SPECIAL_COCTAIL_DEFENSE_LIST)
					player.forceUseSkill(SkillEntry.makeSkillEntry(SkillEntryType.CUNSUMABLE_ITEM, skill, 1), player);
				break;
			case 80435: // Особый Коктейль Императора - Атака 4 ч.
				for(int skill : EMPERORS_SPECIAL_COCTAIL_ATTACK_LIST)
					player.forceUseSkill(SkillEntry.makeSkillEntry(SkillEntryType.CUNSUMABLE_ITEM, skill, 2), player);
				break;
			case 80436: // Особый Коктейль Императора - Магия 4 ч.
				for(int skill : EMPERORS_SPECIAL_COCTAIL_MAGIC_LIST)
					player.forceUseSkill(SkillEntry.makeSkillEntry(SkillEntryType.CUNSUMABLE_ITEM, skill, 2), player);
				break;
			case 80437: // Особый Коктейль Императора - Защита 4 ч.
				for(int skill : EMPERORS_SPECIAL_COCTAIL_DEFENSE_LIST)
					player.forceUseSkill(SkillEntry.makeSkillEntry(SkillEntryType.CUNSUMABLE_ITEM, skill, 2), player);
				break;
			case 80438: // Особый Коктейль Императора - Атака 8 ч.
				for(int skill : EMPERORS_SPECIAL_COCTAIL_ATTACK_LIST)
					player.forceUseSkill(SkillEntry.makeSkillEntry(SkillEntryType.CUNSUMABLE_ITEM, skill, 3), player);
				break;
			case 80439: // Особый Коктейль Императора - Магия 8 ч.
				for(int skill : EMPERORS_SPECIAL_COCTAIL_MAGIC_LIST)
					player.forceUseSkill(SkillEntry.makeSkillEntry(SkillEntryType.CUNSUMABLE_ITEM, skill, 3), player);
				break;
			case 80440: // Особый Коктейль Императора - Защита 8 ч.
				for(int skill : EMPERORS_SPECIAL_COCTAIL_DEFENSE_LIST)
					player.forceUseSkill(SkillEntry.makeSkillEntry(SkillEntryType.CUNSUMABLE_ITEM, skill, 3), player);
				break;
			default:
				return false;
		}

		return true;
	}
}