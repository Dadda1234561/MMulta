package l2s.gameserver.network.l2.c2s;
import l2s.gameserver.Config;
import l2s.gameserver.model.Creature;
import l2s.gameserver.model.Player;
import l2s.gameserver.model.Skill;
import l2s.gameserver.model.SkillChain;
import l2s.gameserver.model.actor.instances.creature.Abnormal;
import l2s.gameserver.model.items.attachment.FlagItemAttachment;
import l2s.gameserver.network.l2.components.SystemMsg;
import l2s.gameserver.skills.SkillEntry;
import l2s.gameserver.skills.SkillEntryType;

public class RequestMagicSkillUse extends L2GameClientPacket
{
	private Integer _magicId;
	private boolean _ctrlPressed;
	private boolean _shiftPressed;

	/**
	 * packet type id 0x39
	 * format:		cddc
	 */
	@Override
	protected boolean readImpl()
	{
		_magicId = readD();
		_ctrlPressed = readD() != 0;
		_shiftPressed = readC() != 0;
		return true;
	}

	@Override
	protected void runImpl()
	{
		Player activeChar = getClient().getActiveChar();
		if(activeChar == null)
			return;
		activeChar.setActive();

		if(activeChar.isOutOfControl())
		{
			activeChar.sendActionFailed();
			return;
		}

		if (_magicId == Config.SKILLER_SKILL_ID && _shiftPressed) {
			activeChar.getSkiller().showConfig();
			return;
		}
		else if (_magicId == Config.HEALER_SKILL_ID && _shiftPressed) {
			activeChar.getHealer().showConfig();
			return;
		}

		//[BONUX FIX THIS HARDCODING] Не работало сетактивкомбо вообще, удалил нахер ибо любой чар может скастовать комбо если оно возможно.
		SkillEntry skillEntry = SkillEntry.makeSkillEntry(SkillEntryType.NONE, _magicId, activeChar.getSkillLevel(_magicId));
		if(skillEntry == null) {
			SkillChain skillChain = activeChar.getTargetSkillChain();
			if(skillChain != null) {
				SkillEntry tempSkillEntry = skillChain.getSkillEntry();
				if(tempSkillEntry.getId() == _magicId)
					skillEntry = tempSkillEntry;
			}
		}

		if(skillEntry != null)
		{
			skillEntry = skillEntry.getTemplate().getElementalSkill(skillEntry, activeChar);

			Skill skill = skillEntry.getTemplate();
			if(!(skill.isActive() || skill.isToggle()))
			{
				activeChar.sendActionFailed();
				return;
			}

			FlagItemAttachment attachment = activeChar.getActiveWeaponFlagAttachment();
			if(attachment != null && !attachment.canCast(activeChar, skill))
			{
				activeChar.sendActionFailed();
				return;
			}

			// В режиме трансформации доступны только скилы трансформы
			if(activeChar.isTransformed() && !activeChar.getAllSkills().contains(skillEntry) && skill.getSkillType() != Skill.SkillType.CHANGE_CLASS)
			{
				activeChar.sendActionFailed();
				return;
			}

			if(skill.isToggle())
			{
				if(activeChar.getAbnormalList().contains(skill))
				{
					if(!skill.isNecessaryToggle())
					{
						if(activeChar.isSitting())
						{
							activeChar.sendPacket(SystemMsg.YOU_CANNOT_MOVE_WHILE_SITTING);
							return;
						}
						activeChar.getAbnormalList().stop(skill.getId());
						activeChar.sendActionFailed();
					}
					activeChar.sendActionFailed();
					return;
				}
			}

			activeChar.isntAfk();

			Creature target = skill.getAimingTarget(activeChar, activeChar.getTarget());

			activeChar.setGroundSkillLoc(null);
			activeChar.getAI().Cast(skillEntry, target, _ctrlPressed, _shiftPressed);
		}
		else
			activeChar.sendActionFailed();
	}
}