package l2s.gameserver.network.l2.c2s;

import l2s.gameserver.model.Player;
import l2s.gameserver.model.Skill;
import l2s.gameserver.network.l2.components.SystemMsg;
import l2s.gameserver.network.l2.s2c.SystemMessagePacket;

/**
 * @author Bonux
**/
public class RequestResetAbilityPoint extends L2GameClientPacket
{
	private int[][] _skills;

	@Override
	protected boolean readImpl()
	{
		return true;
	}

	@Override
	protected void runImpl()
	{
		Player activeChar = getClient().getActiveChar();
		if(activeChar == null)
			return;

		if(!activeChar.isAllowAbilities())
		{
			activeChar.sendPacket(SystemMsg.ABILITIES_CAN_BE_USED_BY_NOBLESSE_LV_99_OR_ABOVE);
			return;
		}

		long spConsumeCount = Player.getAbilitiesRefreshPrice();
		if(activeChar.getSp() < spConsumeCount)
		{
			activeChar.sendActionFailed();
			return;
		}

		activeChar.abilityWrite.lock();
		try
		{
			int removed = 0;
			for(Skill skill : activeChar.getLearnedAbilitiesSkills())
			{
				activeChar.removeSkill(skill, true);
				removed++;
			}

			if(removed > 0)
			{
				activeChar.setSp(activeChar.getSp() - spConsumeCount);
				activeChar.sendPacket(new SystemMessagePacket(SystemMsg.S1_ADENA_WILL_BE_CONSUMED_AND_SPECIAL_POINTS_WILL_BE_RESET).addLong(spConsumeCount));
			}

			activeChar.sendAbilitiesInfo();
			activeChar.updateStats();
		}
		finally
		{
			activeChar.abilityWrite.unlock();
		}
	}
}