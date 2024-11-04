package l2s.gameserver.network.l2.c2s;

import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.IntStream;

import l2s.gameserver.data.xml.holder.SkillAcquireHolder;
import l2s.gameserver.model.Player;
import l2s.gameserver.model.Skill;
import l2s.gameserver.model.SkillLearn;
import l2s.gameserver.model.base.AcquireType;
import l2s.gameserver.network.l2.components.SystemMsg;
import l2s.gameserver.skills.SkillEntry;
import l2s.gameserver.skills.SkillEntryType;

/**
 * @author Bonux
**/
public class RequestAcquireAbilityList extends L2GameClientPacket
{
	private Map<Integer, SkillEntry> _skills;

	@Override
	protected boolean readImpl()
	{
		readD(); // nAP

		_skills = new LinkedHashMap<Integer, SkillEntry>();

		for(int i = 0; i < 3; i++)
		{
			int skillsCount = readD();
			for(int j = 0; j < skillsCount; j++)
			{
				final int skillId = readD();
				final int skillLevel = readD();

				SkillEntry skillEntry = SkillEntry.makeSkillEntry(SkillEntryType.NONE, skillId, skillLevel);
				if(skillEntry != null)
					_skills.putIfAbsent(skillEntry.getId(), skillEntry);
			}
		}
		return true;
	}

	@Override
	protected void runImpl()
	{
		Player activeChar = getClient().getActiveChar();
		if(activeChar == null)
			return;
		
		if(!activeChar.isBaseClassActive() && !activeChar.isDualClassActive())
			return;

		activeChar.abilityWrite.lock();
		try
		{
			if(activeChar.getAvailableAbilityPoints() == 0)
				return;

			if(!activeChar.isAllowAbilities())
			{
				activeChar.sendPacket(SystemMsg.ABILITIES_CAN_BE_USED_BY_NOBLESSE_LV_99_OR_ABOVE);
				return;
			}

			if(activeChar.isInOlympiadMode() || activeChar.isChaosFestivalParticipant())
			{
				activeChar.sendPacket(SystemMsg.YOU_CANNOT_USE_OR_RESET_ABILITY_POINTS_WHILE_PARTICIPATING_IN_THE_OLYMPIAD_OR_CEREMONY_OF_CHAOS);
				return;
			}

			List<SkillLearn> skillsToLearn = new ArrayList<SkillLearn>();
			for(SkillEntry skillEntry : _skills.values())
			{
				SkillLearn skillLearn = SkillAcquireHolder.getInstance().getSkillLearn(activeChar, skillEntry.getId(), skillEntry.getLevel(), AcquireType.ABILITY);
				if(skillLearn == null)
					break;

				skillsToLearn.add(skillLearn);
			}

			if(skillsToLearn.isEmpty())
			{
				activeChar.sendPacket(SystemMsg.FAILED_TO_ACQUIRE_ABILITY_PLEASE_TRY_AGAIN);
				return;
			}

			boolean learned = false;

			for(SkillLearn learn : skillsToLearn)
			{
				int knownLevel = activeChar.getSkillLevel(learn.getId(), 0);
				if(knownLevel > learn.getLevel())
					break;

				int points = learn.getLevel() - knownLevel;
				if(points > (activeChar.getAvailableAbilityPoints() - activeChar.getUsedAbilityPoints()))
					break;

				SkillEntry skillEntry = SkillEntry.makeSkillEntry(SkillEntryType.NONE, learn.getId(), learn.getLevel());
				if(skillEntry == null)
					break;

				if(!SkillAcquireHolder.getInstance().isSkillPossible(activeChar, skillEntry.getTemplate(), AcquireType.ABILITY))
					break;

				if(learn.getRequiredPoints() > 0)
				{
					int pointsUsedInTree = 0;
					for(Skill s : activeChar.getLearnedAbilitiesSkills())
					{
						SkillLearn sl = SkillAcquireHolder.getInstance().getSkillLearn(activeChar, s.getId(), s.getLevel(), AcquireType.ABILITY);
						if(sl != null && sl.getTree() == learn.getTree())
							pointsUsedInTree += s.getLevel();
					}

					if(learn.getRequiredPoints() > pointsUsedInTree)
						break;
				}

				SkillEntry oldSkillEntry = activeChar.addSkill(skillEntry, true);
				if(oldSkillEntry == null || oldSkillEntry.getLevel() < skillEntry.getLevel())
					learned = true;
			}

			if(learned)
			{
				activeChar.sendPacket(SystemMsg.THE_SELECTED_ABILITY_WILL_BE_ACQUIRED);
				activeChar.broadcastCharInfo();
				activeChar.sendAbilitiesInfo();
				activeChar.updateStats();
			}
			else
				activeChar.sendPacket(SystemMsg.FAILED_TO_ACQUIRE_ABILITY_PLEASE_TRY_AGAIN);
		}
		finally
		{
			activeChar.abilityWrite.unlock();
		}
	}
}