package npc.model;

import java.util.StringTokenizer;

import l2s.commons.collections.MultiValueSet;
import l2s.commons.time.cron.SchedulingPattern;
import l2s.commons.util.Rnd;
import l2s.gameserver.data.htm.HtmCache;
import l2s.gameserver.model.Player;
import l2s.gameserver.model.Skill;
import l2s.gameserver.model.base.ClassLevel;
import l2s.gameserver.model.instances.NpcInstance;
import l2s.gameserver.network.l2.components.SystemMsg;
import l2s.gameserver.network.l2.s2c.SystemMessagePacket;
import l2s.gameserver.skills.SkillEntry;
import l2s.gameserver.skills.SkillEntryType;
import l2s.gameserver.templates.npc.NpcTemplate;
import l2s.gameserver.utils.ItemFunctions;
import l2s.gameserver.utils.TimeUtils;

import org.apache.commons.lang3.ArrayUtils;

public class RuviBlessInstance extends NpcInstance
{

    private static final int[][] BUFF_SETS = new int[][]{
            { 120192, 1 }, // Путешественник - Поэма Рога
    };

    public RuviBlessInstance(int objectId, NpcTemplate template, MultiValueSet<String> set)
    {
        super(objectId, template, set);
    }

    @Override
    public String getHtmlDir(String filename, Player player)
    {
        return "ruvi/";
    }

    @Override
    public void onBypassFeedback(Player player, String command)
    {
        StringTokenizer st = new StringTokenizer(command, "_");
        String cmd = st.nextToken();
        if(cmd.equalsIgnoreCase("buffs"))
        {
            for(int[] skill : BUFF_SETS)
                getBuff(skill[0], skill[1], player);

        }
        else
            super.onBypassFeedback(player, command);
    }

    private void getBuff(int skillId, int skillLevel, Player player)
    {
        SkillEntry skillEntry = SkillEntry.makeSkillEntry(SkillEntryType.NONE, skillId, skillLevel);
        if(skillEntry == null)
            return;

        int removed = player.getAbnormalList().stop(skillEntry, false);
        if(removed > 0)
            player.sendPacket(new SystemMessagePacket(SystemMsg.THE_EFFECT_OF_S1_HAS_BEEN_REMOVED).addSkillName(skillEntry));

        forceUseSkill(skillEntry, player);
    }
}