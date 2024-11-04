package l2s.gameserver.network.l2.s2c;

/**
 * @author sharp on 09.12.2022
 * t.me/sharp1que
 */
public class ExRaidTeleportInfo extends L2GameServerPacket{
    @Override
    protected void writeImpl() {
        writeD(0); // nUsedFreeCount
    }
}
