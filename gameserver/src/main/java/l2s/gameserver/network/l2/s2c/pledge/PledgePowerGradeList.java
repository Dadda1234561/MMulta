package l2s.gameserver.network.l2.s2c.pledge;

import l2s.gameserver.model.pledge.RankPrivs;
import l2s.gameserver.network.l2.s2c.L2GameServerPacket;

public class PledgePowerGradeList extends L2GameServerPacket
{
	private RankPrivs[] _privs;

	public PledgePowerGradeList(RankPrivs[] privs)
	{
		_privs = privs;
	}

	@Override
	protected final void writeImpl()
	{
		writeD(_privs.length);
		for(RankPrivs element : _privs)
		{
			writeD(element.getRank());
			writeD(element.getParty());
		}
	}
}