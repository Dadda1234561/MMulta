package l2s.gameserver.network.l2.c2s.items.autopeel;


import l2s.gameserver.model.Player;
import l2s.gameserver.network.l2.c2s.L2GameClientPacket;
import l2s.gameserver.network.l2.s2c.items.autopeel.ExStopItemAutoPeel;

public class RequestExStopItemAutoPeel extends L2GameClientPacket
{
    @Override
    protected boolean readImpl()
    {
        readC(); // cDummy
        return true;
    }

    @Override
    protected void runImpl()
    {
        final Player player = getClient().getActiveChar();
        if (player == null)
        {
            return;
        }

        player.sendPacket(new ExStopItemAutoPeel(true));
    }
}
