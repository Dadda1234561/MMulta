package l2s.gameserver.network.l2.s2c.pledge;

import l2s.gameserver.network.l2.s2c.L2GameServerPacket;

public class AskJoinPledgePacket extends L2GameServerPacket
{
	private int _requestorId;
	private String _pledgeName;

	public AskJoinPledgePacket(int requestorId, String pledgeName)
	{
		_requestorId = requestorId;
		_pledgeName = pledgeName;
	}

	@Override
	protected final void writeImpl()
	{
		writeD(_requestorId);
		writeS(""); // Invitor name
		writeS(_pledgeName);
		writeD(0x00); // Pledge type
		writeS(""); // Pledge Unit name
	}
}