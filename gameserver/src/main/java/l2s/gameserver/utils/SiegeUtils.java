package l2s.gameserver.utils;

import l2s.gameserver.data.xml.holder.ResidenceHolder;
import l2s.gameserver.model.Player;
import l2s.gameserver.model.entity.residence.Residence;
import l2s.gameserver.skills.SkillEntry;
import l2s.gameserver.skills.SkillEntryType;

/**
 * @author VISTALL
 * @date 12:23/21.02.2011
 */
public class SiegeUtils
{
	public static final int MIN_CLAN_SIEGE_LEVEL = 5;

	public static void addSiegeSkills(Player character)
	{
		character.addSkill(SkillEntry.makeSkillEntry(SkillEntryType.NONE, 19034, 1), true); // Печать Света
		character.addSkill(SkillEntry.makeSkillEntry(SkillEntryType.NONE, 19035, 1), true); // Печать Тьмы
		character.addSkill(SkillEntry.makeSkillEntry(SkillEntryType.NONE, 247, 1), true);

		int castle = character.getClan().getCastle();

		if(character.isNoble())
			character.addSkill(SkillEntry.makeSkillEntry(SkillEntryType.NONE, 326, 1), true);

		if(character.getClan() != null && castle != 0)
		{
			character.addSkill(SkillEntry.makeSkillEntry(SkillEntryType.NONE, 844, 1), true);
			character.addSkill(SkillEntry.makeSkillEntry(SkillEntryType.NONE, 845, 1), true);

			if (castle == 5 || castle == 8) {
				// Умения для Замков  Аден и Руна:
				character.addSkill(SkillEntry.makeSkillEntry(SkillEntryType.NONE, 32117, 1), true);
				character.addSkill(SkillEntry.makeSkillEntry(SkillEntryType.NONE, 32119, 1), true);
				character.addSkill(SkillEntry.makeSkillEntry(SkillEntryType.NONE, 32120, 1), true);
				character.addSkill(SkillEntry.makeSkillEntry(SkillEntryType.NONE, 32122, 1), true);
			} else {
				// Умения для Замков Глудио, Дион, Орен, Иннадрил, Гиран, Годдард и Шутгарт:
				character.addSkill(SkillEntry.makeSkillEntry(SkillEntryType.NONE, 32118, 1), true);
				character.addSkill(SkillEntry.makeSkillEntry(SkillEntryType.NONE, 32119, 1), true);
				character.addSkill(SkillEntry.makeSkillEntry(SkillEntryType.NONE, 32121, 1), true);
				character.addSkill(SkillEntry.makeSkillEntry(SkillEntryType.NONE, 32122, 1), true);
			}
		}
	}

	public static void removeSiegeSkills(Player character)
	{
		character.removeSkill(SkillEntry.makeSkillEntry(SkillEntryType.NONE, 19034, 1), false); // Печать Света
		character.removeSkill(SkillEntry.makeSkillEntry(SkillEntryType.NONE, 19035, 1), false); // Печать Тьмы
		character.removeSkill(SkillEntry.makeSkillEntry(SkillEntryType.NONE, 247, 1), false);
		character.removeSkill(SkillEntry.makeSkillEntry(SkillEntryType.NONE, 326, 1), false);

		character.removeSkill(SkillEntry.makeSkillEntry(SkillEntryType.NONE, 32117, 1), true);
		character.removeSkill(SkillEntry.makeSkillEntry(SkillEntryType.NONE, 32118, 1), true);
		character.removeSkill(SkillEntry.makeSkillEntry(SkillEntryType.NONE, 32119, 1), true);
		character.removeSkill(SkillEntry.makeSkillEntry(SkillEntryType.NONE, 32120, 1), true);
		character.removeSkill(SkillEntry.makeSkillEntry(SkillEntryType.NONE, 32121, 1), true);
		character.removeSkill(SkillEntry.makeSkillEntry(SkillEntryType.NONE, 32122, 1), true);

		if(character.getClan() != null && character.getClan().getCastle() != 0)
		{
			character.removeSkill(SkillEntry.makeSkillEntry(SkillEntryType.NONE, 844, 1), false);
			character.removeSkill(SkillEntry.makeSkillEntry(SkillEntryType.NONE, 845, 1), false);
		}
	}

	public static boolean getCanRide()
	{
		for(Residence residence : ResidenceHolder.getInstance().getResidences())
			if(residence != null && residence.getSiegeEvent().isInProgress())
				return false;
		return true;
	}
}