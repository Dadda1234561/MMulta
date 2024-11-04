package l2s.gameserver.network.l2.c2s.herobook;

import l2s.gameserver.model.Player;
import l2s.gameserver.model.herobook.HeroBookManager;
import l2s.gameserver.network.l2.c2s.L2GameClientPacket;
import l2s.gameserver.network.l2.s2c.herobook.ExHeroBookCharge;
import l2s.gameserver.network.l2.s2c.herobook.ExHeroBookInfo;

import java.util.HashMap;
import java.util.Map;

public class RequestHeroBookCharge extends L2GameClientPacket
{
    private final Map<Integer, Long> _items = new HashMap<>();

    @Override
    public boolean readImpl()
    {
        final int size = readD();
        for (int curr = 0; curr < size; curr++)
        {
            _items.put(readD(), readQ());
        }
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

        final boolean isSuccess = new HeroBookManager().tryEnchant(player, _items);
        player.sendPacket(new ExHeroBookCharge(isSuccess));
        player.sendPacket(new ExHeroBookInfo(player.getHeroBookProgress()));
    }
}
