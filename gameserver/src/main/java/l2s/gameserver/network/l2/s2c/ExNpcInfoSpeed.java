/**
 * @date 27.03.2023 @ 19:30
 * @author sharp
 * https://t.me/sharp1que
 */

package l2s.gameserver.network.l2.s2c;

import l2s.gameserver.model.instances.NpcInstance;

public class ExNpcInfoSpeed extends L2GameServerPacket {

    int _objectId, _walkSpd, _runSpd;

    public ExNpcInfoSpeed(NpcInstance npc) {
        _objectId = npc.getObjectId();
        _walkSpd = npc.getWalkSpeed();
        _runSpd = npc.getRunSpeed();
    }

    @Override
    protected void writeImpl() {
        writeC(0x01);
        writeD(_objectId);
        writeD(_runSpd);
    }
}
