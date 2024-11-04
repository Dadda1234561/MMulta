package l2s.gameserver.network.l2.c2s;

public final class RequestExEnchantSkillUntrain extends L2GameClientPacket
{
	@Override
	protected boolean readImpl()
	{
		readD();
		readD();
		return true;
	}

	@Override
	protected void runImpl()
	{
		//
	}
}