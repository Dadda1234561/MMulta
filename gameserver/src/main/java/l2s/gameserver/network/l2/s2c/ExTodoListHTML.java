package l2s.gameserver.network.l2.s2c;

/**
 * @author Bonux
**/
public class ExTodoListHTML extends L2GameServerPacket
{
	@Override
	protected final void writeImpl()
	{
		writeC(0x00);	// TODO[UNDERGROUND]: Tab 1=event List 2=zone List
		writeS("");	// TODO[UNDERGROUND]: HTML name
		writeS("");	// TODO[UNDERGROUND]: Message
	}
}