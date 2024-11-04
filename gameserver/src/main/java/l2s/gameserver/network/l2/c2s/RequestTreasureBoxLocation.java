package l2s.gameserver.network.l2.c2s;

/**
 * @author sharp on 09.12.2022
 * t.me/sharp1que
 */
public class RequestTreasureBoxLocation extends L2GameClientPacket{
    @Override
    protected boolean readImpl() throws Exception {

        return true;
    }

    @Override
    protected void runImpl() throws Exception {

    }
}
