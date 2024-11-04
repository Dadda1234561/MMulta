package l2s.gameserver.network.l2.c2s.herobook;

import l2s.gameserver.model.Player;
import l2s.gameserver.model.herobook.HeroBookManager;
import l2s.gameserver.network.l2.c2s.L2GameClientPacket;

public class RequestHeroBookEnchant extends L2GameClientPacket
{
    @Override
    public boolean readImpl()
    {
        return true;
    }

    @Override
    public void runImpl()
    {
        Player player = getClient().getActiveChar();
        if (player == null)
        {
            return;
        }

        new HeroBookManager().tryIncreaseLevel(player);
    }
}
