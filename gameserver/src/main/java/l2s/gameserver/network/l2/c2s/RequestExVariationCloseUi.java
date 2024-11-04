package l2s.gameserver.network.l2.c2s;

import l2s.gameserver.model.Player;

/**
 * @author sharp on 08.01.2023
 * t.me/sharp1que
 */
public class RequestExVariationCloseUi extends L2GameClientPacket
{
    @Override
    protected boolean readImpl() throws Exception
    {
        readC();
        return true;
    }

    @Override
    protected void runImpl() throws Exception
    {
        final Player player = getClient().getActiveChar();
        if (player == null)
        {
            return;
        }

        player.setLastVariationStoneId(0);
    }
}
