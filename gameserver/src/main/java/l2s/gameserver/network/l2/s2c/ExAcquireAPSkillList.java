package l2s.gameserver.network.l2.s2c;

import java.util.Collection;

import l2s.gameserver.model.Player;
import l2s.gameserver.model.Skill;

/**
 * @author Bonux
**/
public class ExAcquireAPSkillList extends L2GameServerPacket
{
	private final boolean _avaiable;
	private final long _abilitiesRefreshPrice;
	private final int _allowAbilitiesPoints;
	private final int _usedPoints;
	private final Collection<Skill> _learnedSkills;

	public ExAcquireAPSkillList(Player player)
	{
		_avaiable = player.isAllowAbilities();
		_abilitiesRefreshPrice = Player.getAbilitiesRefreshPrice();
		_usedPoints = player.getUsedAbilityPoints();
		_allowAbilitiesPoints = player.getAvailableAbilityPoints();
		_learnedSkills = player.getLearnedAbilitiesSkills();
	}

	@Override
	protected void writeImpl()
	{
		writeC(_avaiable ? 0x01 : 0x00);	// Разрешено ли использовать. bSuccess
		writeQ(_abilitiesRefreshPrice);	// Цена сброса способностей. nResetSP
		writeD(_allowAbilitiesPoints);	// Полученые очки. nAP
		writeD(_usedPoints);	// Использованные очки. nAcquiredAbilityCount
		writeD(_learnedSkills.size());	// Количество изученных умений.
		for(Skill skill : _learnedSkills)
		{
			writeD(skill.getId()); // ID Изученного умения.
			writeD(skill.getLevel()); // Уровень Изученного умения.
		}
	}
}
