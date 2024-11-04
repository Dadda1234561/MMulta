package l2s.gameserver.network.l2.s2c.homunculus;

import l2s.gameserver.model.Player;
import l2s.gameserver.model.actor.variables.PlayerVariables;
import l2s.gameserver.network.l2.s2c.L2GameServerPacket;

/**
 * @author nexvill
 */
public class ExShowHomunculusBirthInfo extends L2GameServerPacket {
    private static int _hpPoints, _spPoints, _vpPoints, _homunculusCreateTime;

    public ExShowHomunculusBirthInfo(Player player) {
        _hpPoints = player.getVarInt(PlayerVariables.HOMUNCULUS_HP_POINTS, 0);
        _spPoints = player.getVarInt(PlayerVariables.HOMUNCULUS_SP_POINTS, 0);
        _vpPoints = player.getVarInt(PlayerVariables.HOMUNCULUS_VP_POINTS, 0);
        _homunculusCreateTime = (int) (player.getVarLong(PlayerVariables.HOMUNCULUS_CREATION_TIME, 0) / 1000);
    }

    @Override
    protected final void writeImpl() {
        int type = 0;
        if (_homunculusCreateTime > 0) {
            if (((System.currentTimeMillis() / 1000) >= _homunculusCreateTime) && (_hpPoints == 100) && (_spPoints == 10) && (_vpPoints == 5)) {
                type = 2;
            } else {
                type = 1;
            }
        }
        writeD(type); // in creation process (0: can create, 1: in process, 2: can awake
        writeD(_hpPoints); // hp points
        writeD(_spPoints); // sp points
        writeD(_vpPoints); // vp points
        writeQ(_homunculusCreateTime); // finish time
    }
}