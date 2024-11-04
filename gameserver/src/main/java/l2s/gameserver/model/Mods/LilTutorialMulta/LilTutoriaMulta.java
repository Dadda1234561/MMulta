package l2s.gameserver.model.Mods.LilTutorialMulta;

import l2s.gameserver.model.Player;
import l2s.gameserver.network.l2.components.HtmlMessage;

import java.util.HashMap;
import java.util.HashSet;

public class LilTutoriaMulta {

    private static HashMap<Player, HashSet<Integer>> playerLevelsProcessed = new HashMap<>();

    public static void info(Player player) {
        if (player == null)
            return;

        HashSet<Integer> processedLevels = playerLevelsProcessed.computeIfAbsent(player, k -> new HashSet<>());

        int level = player.getLevel();
        int rebirthCount = player.getRebirthCount();
        if (rebirthCount >= 1)
            return;

        if (level == 1 && processedLevels.add(level)) {
            player.sendPacket(new HtmlMessage(0).setFile("LilTutorialMulta/TutorialMulta_1.htm"));
        } else if (level == 10 && processedLevels.add(level)) {
            player.sendPacket(new HtmlMessage(0).setFile("LilTutorialMulta/TutorialMulta_2.htm"));
        } else if (level == 20 && processedLevels.add(level)) {
            player.sendPacket(new HtmlMessage(0).setFile("LilTutorialMulta/TutorialMulta_3.htm"));
        } else if (level == 40 && processedLevels.add(level)) {
            player.sendPacket(new HtmlMessage(0).setFile("LilTutorialMulta/TutorialMulta_4.htm"));
        } else if (level == 78 && processedLevels.add(level)) {
            player.sendPacket(new HtmlMessage(0).setFile("LilTutorialMulta/TutorialMulta_5.htm"));
        }
    }
}

