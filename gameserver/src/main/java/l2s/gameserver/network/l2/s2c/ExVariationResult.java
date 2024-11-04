package l2s.gameserver.network.l2.s2c;

public class ExVariationResult extends L2GameServerPacket
{
	private int _option01;
	private int _option02;
	private int _result;

	public ExVariationResult(int option01, int option02, int result)
	{
		_option01 = option01;
		_option02 = option02;
		_result = result;
	}

	@Override
	protected void writeImpl()
	{
		writeD(_option01);
		writeD(_option02);
		writeD(_result);
	}
}