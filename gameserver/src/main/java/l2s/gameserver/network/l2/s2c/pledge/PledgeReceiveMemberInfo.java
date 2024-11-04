package l2s.gameserver.network.l2.s2c.pledge;

import l2s.gameserver.model.pledge.UnitMember;
import l2s.gameserver.network.l2.s2c.L2GameServerPacket;

import org.apache.commons.lang3.StringUtils;

public class PledgeReceiveMemberInfo extends L2GameServerPacket
{
	private UnitMember _member;

	public PledgeReceiveMemberInfo(UnitMember member)
	{
		_member = member;
	}

	@Override
	protected final void writeImpl()
	{
		writeD(_member.getPledgeType());
		writeS(_member.getName());
		writeS(_member.getTitle());
		writeD(_member.getPowerGrade());
		writeS(_member.getSubUnit().getClan().getName());
		writeS(StringUtils.EMPTY); // apprentice/sponsor name if any
	}
}