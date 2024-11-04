package npc.model.custom;

import l2s.commons.collections.MultiValueSet;
import l2s.gameserver.Config;
import l2s.gameserver.data.xml.holder.ExperienceDataHolder;
import l2s.gameserver.model.Player;
import l2s.gameserver.model.instances.NpcInstance;
import l2s.gameserver.network.l2.s2c.ExShowScreenMessage;
import l2s.gameserver.network.l2.s2c.ExShowScreenMessage.ScreenMessageAlign;
import l2s.gameserver.templates.ExperienceData;
import l2s.gameserver.templates.npc.NpcTemplate;

import java.util.StringTokenizer;
import java.util.logging.Logger;

/**
 * @author sharp on 09.02.2023
 * t.me/sharp1que
 *
 * Just a simple level manipulation npc for now..
 */
public class OBTManagerInstance extends NpcInstance
{
    private static final Logger LOGGER = Logger.getLogger(OBTManagerInstance.class.getSimpleName());
    public OBTManagerInstance(int objectId, NpcTemplate template, MultiValueSet<String> set)
    {
        super(objectId, template, set);
    }

    @Override
    public String getHtmlDir(String filename, Player player)
    {
        return "custom/obt_manager/";
    }

    @Override
    public void onBypassFeedback(Player player, String command)
    {
        final StringTokenizer st = new StringTokenizer(command, " ");
        st.nextToken(); // skip command
        if (command.startsWith("setLevelTo")) {
            if (st.hasMoreTokens()) {
                int newLevel = -1;
                try {
                    newLevel = Integer.parseInt(st.nextToken());
                    if (newLevel <= 0) {
                        newLevel = 1;
                    } else if (newLevel > Config.ALT_MAX_LEVEL) {
                        newLevel = Config.ALT_MAX_LEVEL;
                    }
                } catch (NumberFormatException e) {
                    e.printStackTrace();
                }

                if (newLevel != -1) {
                    changePlayerLevel(player, newLevel);
                } else {
                    LOGGER.info(String.format("Player %s tries to set invalid new level!", player.getName()));
                    player.sendMessage("Произошла ошибка.");
                }
            } else {
                player.sendMessage("Не указан уровень.");
            }

        } else if (command.startsWith("modifySP")) {
            if (st.hasMoreTokens()) {
                String param = st.nextToken();
                if (param.equalsIgnoreCase("reset")) {
                    changePlayerSp(player, -player.getSp());
                } else if (param.equalsIgnoreCase("max")) {
                    changePlayerSp(player, Config.SP_LIMIT);
                }
            }
        }

        showChatWindow(player, 0, false);
    }

    private void changePlayerLevel(Player player, int level) {
        final ExperienceData expData = ExperienceDataHolder.getInstance().getData(level);
        if (expData == null) {
            return;
        }

        long currentExp = player.getExp();
        long expDiff = ((-currentExp) + expData.getExp());

        if (expDiff != 0) {
            player.addExpAndSp(expDiff, 0);
            showScreenMessage(player, "Поздравляем! Вы теперь " + player.getLevel() + " Ур. !");
        } else {
            player.sendMessage("Уровень не изменен.");
        }
    }

    private void changePlayerSp(Player player, long newSp) {
        if (newSp != 0) {
            player.addExpAndSp(0, newSp);
            if (newSp < 0) {
                showScreenMessage(player, "SP Сброшено на 0.");
            } else {
                showScreenMessage(player, "Установлено максимальное кол-во SP!");
            }
        }
    }

    private void showScreenMessage(Player player, String text) {
        player.sendPacket(new ExShowScreenMessage(text, 3000, ScreenMessageAlign.TOP_CENTER, false));
    }
}
