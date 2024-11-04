package l2s.gameserver.network.l2.s2c.pledge;

import l2s.gameserver.model.pledge.SubUnit;
import l2s.gameserver.network.l2.s2c.L2GameServerPacket;

public class PledgeReceiveSubPledgeCreated extends L2GameServerPacket
{
	private int type;
	private String _name, leader_name;

	public PledgeReceiveSubPledgeCreated(SubUnit subPledge)
	{
		type = subPledge.getType();
		_name = subPledge.getClan().getName();
		leader_name = subPledge.getClan().getLeaderName();
	}

	@Override
	protected final void writeImpl()
	{
		writeD(0x01);
		writeD(type);
		writeS(_name);
		writeS(leader_name);
	}
}