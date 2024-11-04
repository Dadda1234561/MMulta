package handler.voicecommands;

import l2s.gameserver.model.Player;
import l2s.gameserver.utils.ItemFunctions;

public class AaChange extends ScriptVoiceCommandHandler {
    private final String[] _commandList = new String[]{"aa"};

    @Override
    public boolean useVoicedCommand(String command, Player player, String args) {
        if (player.getInventory().containsItem(6360)) {
            long ancientAdena = player.getInventory().getCountOf(6360) * 3;
            ItemFunctions.deleteItem(player, 6360, player.getInventory().getCountOf(6360), true);
            ItemFunctions.addItem(player, 5575, ancientAdena, true);
        } else if (player.getInventory().containsItem(6361)) {
            long ancientAdena = player.getInventory().getCountOf(6361) * 5;
            ItemFunctions.deleteItem(player, 6361, player.getInventory().getCountOf(6361), true);
            ItemFunctions.addItem(player, 5575, ancientAdena, true);
        } else if (player.getInventory().containsItem(6362)) {
            long ancientAdena = player.getInventory().getCountOf(6362) * 10;
            ItemFunctions.deleteItem(player, 6362, player.getInventory().getCountOf(6362), true);
            ItemFunctions.addItem(player, 5575, ancientAdena, true);
        } else {
            player.sendMessage(player.isLangRus() ? "У вас нет камней печати для обмена!" : "You don't have Seal Stones to trade!");
            return false;
        }
        return true;
    }

    @Override
    public String[] getVoicedCommandList() {
        return _commandList;
    }
}