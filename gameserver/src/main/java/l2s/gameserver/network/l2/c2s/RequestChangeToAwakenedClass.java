package l2s.gameserver.network.l2.c2s;

/**
 * @author Bonux
 * nexvill: NOT USED since prelude of war update
**/
public class RequestChangeToAwakenedClass extends L2GameClientPacket
{
	@SuppressWarnings("unused")
	private boolean _change;

	@Override
	protected boolean readImpl()
	{
		_change = readD() == 1;
		return true;
	}

	@Override
	protected void runImpl()
	{
		
	}
}