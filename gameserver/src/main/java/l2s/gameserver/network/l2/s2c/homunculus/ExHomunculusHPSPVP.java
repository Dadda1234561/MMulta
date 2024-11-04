package l2s.gameserver.network.l2.s2c.homunculus;

import l2s.gameserver.model.Player;
import l2s.gameserver.network.l2.s2c.L2GameServerPacket;

/**
 * @author nexvill
 */
public class ExHomunculusHPSPVP extends L2GameServerPacket
{
	private int _hp;
	private long _sp;
	private int _vp;

	public ExHomunculusHPSPVP(Player player)
	{
		_hp = (int) player.getCurrentHp();
		_sp = player.getSp();
		_vp = player.getVitality();
	}

	@Override
	protected final void writeImpl()
	{
		writeD(_hp);
		writeQ(_sp);
		writeD(_vp);
	}
}