package l2s.gameserver.network.l2.s2c.magiclamp;

import l2s.gameserver.model.Player;
import l2s.gameserver.network.l2.s2c.L2GameServerPacket;

public class ExMagicLampExpInfo extends L2GameServerPacket
{
    private int _enabled;
    private Player _player;

    public ExMagicLampExpInfo(boolean enabled, Player player)
    {
        _enabled = enabled == true ? 1 : 0;
        _player = player;
    }

    @Override
    protected final void writeImpl()
    {
        int currentPoints = 0;
        int lampsExist = 0;
        if ((_player.getMagicLampPoints() % 10000000) > 0)
        {
            currentPoints = (int) (_player.getMagicLampPoints() % 10000000);
        }
        if ((_player.getMagicLampPoints() / 10000000) >= 1)
        {
            lampsExist = (int) (_player.getMagicLampPoints() / 10000000);
        }
        writeD(_enabled);
        writeD(10_000_000); // points to gain 1 lamp
        writeD(currentPoints); // current points
        writeD(lampsExist); // lamps exist
    }
}