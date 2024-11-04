package l2s.gameserver.network.l2.c2s.timerestrictfield;

import l2s.gameserver.model.Player;
import l2s.gameserver.network.l2.c2s.L2GameClientPacket;
import l2s.gameserver.network.l2.s2c.ActionFailPacket;
import l2s.gameserver.network.l2.s2c.SystemMessage;
import l2s.gameserver.network.l2.s2c.timerestrictfield.ExTimeRestrictFieldUserExit;

public class RequestExTimeRestrictFieldUserLeave extends L2GameClientPacket {
    @Override
    protected boolean readImpl() throws Exception {
        // trigger packet
        return true;
    }

    @Override
    protected void runImpl() throws Exception {
        final Player player = getClient().getActiveChar();
        if (player == null) {
            return;
        }

        if (player.isAttackingNow() || player.isInCombat())
        {
            player.sendPacket(new SystemMessage(SystemMessage.YOU_CANNOT_LEAVE_WHILE_IN_COMBAT), ActionFailPacket.STATIC);
            return;
        }

        player.stopTimedHuntingZoneTask(true);
    }
}
