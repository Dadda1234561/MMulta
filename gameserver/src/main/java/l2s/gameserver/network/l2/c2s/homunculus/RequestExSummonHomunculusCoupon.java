package l2s.gameserver.network.l2.c2s.homunculus;

import l2s.commons.util.Rnd;
import l2s.gameserver.data.xml.holder.HomunculusHolder;
import l2s.gameserver.model.Player;
import l2s.gameserver.model.actor.instances.player.Homunculus;
import l2s.gameserver.model.actor.variables.PlayerVariables;
import l2s.gameserver.model.items.ItemInstance;
import l2s.gameserver.network.l2.c2s.L2GameClientPacket;
import l2s.gameserver.network.l2.components.SystemMsg;
import l2s.gameserver.network.l2.s2c.SystemMessage;
import l2s.gameserver.network.l2.s2c.homunculus.ExShowHomunculusBirthInfo;
import l2s.gameserver.network.l2.s2c.homunculus.ExShowHomunculusList;
import l2s.gameserver.network.l2.s2c.homunculus.ExSummonHomunculusCouponResult;
import l2s.gameserver.templates.HomunculusTemplate;
import l2s.gameserver.utils.ItemFunctions;

public class RequestExSummonHomunculusCoupon extends L2GameClientPacket {

    private static final long ADENA_FEE = 2_000_000L; // NOT HERE ...
    private int nItemID;

    @Override
    protected boolean readImpl() throws Exception {
        nItemID = readD();
        return true;
    }

    @Override
    protected void runImpl() throws Exception {
        Player player = getClient().getActiveChar();
        if (player == null) {
            return;
        }

        // check coupon
        ItemInstance coupon = player.getInventory().getItemByItemId(nItemID);
        if (coupon == null) {
            player.sendActionFailed();
            return;
        }

        // check adena
        if (player.getAdena() < ADENA_FEE) {
            player.sendActionFailed();
            player.sendPacket(SystemMsg.valueOf(SystemMessage.YOU_DO_NOT_HAVE_ENOUGH_ADENA));
            return;
        }

        if (player.getHomunculusList().getFreeSize() == 0) {
            player.sendActionFailed();
            return;
        }

        // delete coupon
        if (!ItemFunctions.deleteItem(player, coupon, 1, true)) {
            player.sendActionFailed();
            player.sendPacket(SystemMsg.valueOf(SystemMessage.YOU_DO_NOT_HAVE_ENOUGH_REQUIRED_ITEMS));
            return;
        }

        // delete adena
        if (!ItemFunctions.deleteItem(player, 57, ADENA_FEE, true)) {
            player.sendActionFailed();
            player.sendPacket(SystemMsg.valueOf(SystemMessage.YOU_DO_NOT_HAVE_ENOUGH_ADENA));

            return;
        }

        // Currently uses same logic...
        int homunculusId = 0;
        int chance = Rnd.get(100);
        if (chance >= 60) // Basic Homunculus
        {
            int chance2 = Rnd.get(100);
            if (chance2 >= 80) {
                homunculusId = 1;
            } else if (chance2 >= 60) {
                homunculusId = 4;
            } else if (chance2 >= 40) {
                homunculusId = 7;
            } else if (chance2 >= 20) {
                homunculusId = 10;
            } else {
                homunculusId = 13;
            }
        } else if (chance >= 10) // Water Homunculus
        {
            int chance2 = Rnd.get(100);
            if (chance2 >= 80) {
                homunculusId = 2;
            } else if (chance2 >= 60) {
                homunculusId = 5;
            } else if (chance2 >= 40) {
                homunculusId = 8;
            } else if (chance2 >= 20) {
                homunculusId = 11;
            } else {
                homunculusId = 14;
            }
        } else // Luminous Homunculus
        {
            int chance2 = Rnd.get(100);
            if (chance2 >= 80) {
                homunculusId = 3;
            } else if (chance2 >= 60) {
                homunculusId = 6;
            } else if (chance2 >= 40) {
                homunculusId = 9;
            } else if (chance2 >= 20) {
                homunculusId = 12;
            } else {
                homunculusId = 15;
            }
        }

        int slot = player.getHomunculusList().size();
        HomunculusTemplate template = HomunculusHolder.getInstance().getHomunculusInfo(homunculusId);
        Homunculus homunculus = new Homunculus(template, player.getHomunculusList().size(), 1, 0, 0, 0, 0, 0, 0, false);
        if (player.getHomunculusList().add(homunculus)) {
            player.setVar(PlayerVariables.HOMUNCULUS_CREATION_TIME, 0);
            player.setVar(PlayerVariables.HOMUNCULUS_HP_POINTS, 0);
            player.setVar(PlayerVariables.HOMUNCULUS_SP_POINTS, 0);
            player.setVar(PlayerVariables.HOMUNCULUS_VP_POINTS, 0);

            player.sendPacket(new ExShowHomunculusBirthInfo(player));
            player.sendPacket(new ExShowHomunculusList(player.getHomunculusList()));
            player.sendPacket(new ExSummonHomunculusCouponResult(1, slot));
        }
    }
}
