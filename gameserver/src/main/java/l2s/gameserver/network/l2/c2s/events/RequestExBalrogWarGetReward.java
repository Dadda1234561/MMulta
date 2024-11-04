package l2s.gameserver.network.l2.c2s.events;

import l2s.gameserver.instancemanager.events.BalrogWarManager;
import l2s.gameserver.model.Player;
import l2s.gameserver.network.l2.c2s.L2GameClientPacket;
import l2s.gameserver.network.l2.components.SystemMsg;
import l2s.gameserver.network.l2.s2c.SystemMessage;
import l2s.gameserver.network.l2.s2c.events.balrog.ExBalrogwarGetReward;

public class RequestExBalrogWarGetReward extends L2GameClientPacket {
    @Override
    protected boolean readImpl() throws Exception {
        readC();
        return true;
    }

    @Override
    protected void runImpl() throws Exception {
        Player player = getClient().getActiveChar();
        if (player == null) {
            return;
        }

        final BalrogWarManager manager = BalrogWarManager.getInstance();
        if (manager.isAlreadyRewarded(player)) {
            player.sendActionFailed();
            return;
        }

        if (player.getLevel() < 85 || manager.getPlayerPoints(player) < 10000) {
            final SystemMessage sm = new SystemMessage(SystemMsg.TO_GET_A_REWARD_YOU_MUST_BE_OF_LV_S1_AND_GET_AT_LEAST_S2_POINTS);
            sm.addNumber(85);
            sm.addNumber(10000);
            player.sendPacket(sm, new ExBalrogwarGetReward(false));
            return;
        }

        manager.rewardPlayer(player);
    }
}
