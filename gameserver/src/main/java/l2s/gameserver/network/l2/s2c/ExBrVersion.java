package l2s.gameserver.network.l2.s2c;


/**
 * @author sharp on 01.01.2023
 * t.me/sharp1que
 */
public class ExBrVersion extends L2GameServerPacket {

    public ExBrVersion() {

    }

    @Override
    protected void writeImpl() {
        writeC(0x01);
    }
}
