package l2s.gameserver.network.l2.s2c.pledge;

import l2s.gameserver.model.pledge.Clan;
import l2s.gameserver.network.l2.s2c.L2GameServerPacket;
import l2s.gameserver.skills.SkillEntry;

import java.util.Collection;

/**
 * Reworked: VISTALL
 */
public class PledgeSkillListPacket extends L2GameServerPacket
{
	private final Collection<SkillEntry> _allSkills;

	public PledgeSkillListPacket(Clan clan)
	{
		_allSkills = clan.getSkills();
	}

	@Override
	protected final void writeImpl()
	{
		writeD(_allSkills.size());
		writeD(0); // Unit skills count
		for(SkillEntry skill : _allSkills)
		{
			writeD(skill.getId());
			writeD(skill.getLevel());
		}
	}
}