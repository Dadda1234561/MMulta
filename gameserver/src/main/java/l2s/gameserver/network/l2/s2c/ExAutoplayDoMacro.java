package l2s.gameserver.network.l2.s2c;

public class ExAutoplayDoMacro extends L2GameServerPacket
{
	public static final ExAutoplayDoMacro STATIC_PACKET = new ExAutoplayDoMacro();

	public ExAutoplayDoMacro()
	{
		//
	}

	@Override
	protected void writeImpl()
	{
		writeC(20);
		writeC(1);
		writeH(0);
	}
}
