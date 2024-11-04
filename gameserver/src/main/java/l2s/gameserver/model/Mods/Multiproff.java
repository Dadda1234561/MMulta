package l2s.gameserver.model.Mods;

import l2s.gameserver.Config;
import l2s.gameserver.data.xml.holder.SkillAcquireHolder;
import l2s.gameserver.data.xml.holder.SkillHolder;
import l2s.gameserver.model.Player;
import l2s.gameserver.model.Skill;
import l2s.gameserver.model.SkillLearn;
import l2s.gameserver.model.base.AcquireType;
import l2s.gameserver.model.base.ClassId;
import l2s.gameserver.model.instances.NpcInstance;
import l2s.gameserver.network.l2.s2c.AcquireSkillDonePacket;
import l2s.gameserver.network.l2.components.HtmlMessage;
import l2s.gameserver.network.l2.components.SystemMsg;
import l2s.gameserver.network.l2.s2c.ExAcquirableSkillListByClass;
import l2s.gameserver.skills.SkillEntry;
import l2s.gameserver.utils.HtmlUtils;

import java.util.Collection;

/**
 * Создан пользователем Alex в 11.01.2019
 */
public class Multiproff {

    /*/public static void showCustomSkillList(Player player) {
        showCustomList(AcquireType.CUSTOM, player);
    }

    private static void showCustomList(AcquireType t, Player player) {

        final Collection<SkillLearn> skills = SkillAcquireHolder.getInstance().getAvailableSkillsCustom(player, t);
        final ExAcquirableSkillListByClass asl = new ExAcquirableSkillListByClass(t, skills.size(), player);
        for (SkillLearn s : skills) {
            asl.addSkill(s.getId(), s.getLevel(), s.getLevel(), s.getCost(), 0);
        }

        if (skills.size() == 0) {
            player.sendPacket(AcquireSkillDonePacket.STATIC);
            player.sendPacket(SystemMsg.THERE_ARE_NO_OTHER_SKILLS_TO_LEARN);
        } else {
            player.sendPacket(asl);
        }

        player.sendActionFailed();
    }

    public static void showCustomSkillList1(Player player) {
        showCustomList1(AcquireType.CUSTOM1, player);
    }

    private static void showCustomList1(AcquireType t, Player player) {

        final Collection<SkillLearn> skills = SkillAcquireHolder.getInstance().getAvailableSkillsCustom(player, t);
        final ExAcquirableSkillListByClass asl = new ExAcquirableSkillListByClass(t, skills.size(), player);
        for (SkillLearn s : skills) {
            asl.addSkill(s.getId(), s.getLevel(), s.getLevel(), s.getCost(), 0);
        }

        if (skills.size() == 0) {
            player.sendPacket(AcquireSkillDonePacket.STATIC);
            player.sendPacket(SystemMsg.THERE_ARE_NO_OTHER_SKILLS_TO_LEARN);
        } else {
            player.sendPacket(asl);
        }

        player.sendActionFailed();
    }*/

    public static void showSkillListM(Player player, int class_id) {
        if (player == null)
            return;

        ClassId classId = ClassId.VALUES[class_id];

        if (classId == null)
            return;

        final Collection<SkillLearn> skills = SkillAcquireHolder.getInstance().getAvailableSkillsM(class_id, player);

        final ExAcquirableSkillListByClass asl = new ExAcquirableSkillListByClass(AcquireType.MULTICLASS, skills.size(), player);

        for (SkillLearn s : skills) {
            /*if (s.isClicked())
                continue;*/
            if (s.getMinLevel() > player.getLevel())
                continue;

            Skill sk = SkillHolder.getInstance().getSkill(s.getId(), s.getLevel());
            if (sk == null)
                continue;

            asl.addSkill(s.getId(), s.getLevel(), s.getLevel(), s.getCost(), 0);

        }

        player.sendPacket(asl);
    }

    public static void RemoveMPSkill(Player player, int id, NpcInstance npc) {
        if (player == null) {
            return;
        }
        int level = player.getSkillLevel(id);
        Skill skill = SkillHolder.getInstance().getSkill(id, level);
        if (skill != null) {
            if (!Config.ENABLE_MULTICLASS_SKILL_REMOVE_ITEM.isEmpty()) {
                String[] items_s = Config.ENABLE_MULTICLASS_SKILL_REMOVE_ITEM.split(":");
                if (!player.consumeItem(Integer.parseInt(items_s[0]), Integer.parseInt(items_s[1]), true)) {
                    player.sendPacket(SystemMsg.INCORRECT_ITEM_COUNT);
                    removeSkillsPageM(player, player.getSkillRemPage(), npc);
                    return;
                }
            }
            player.sendMessage("Skill " + skill.getName() + " removed.");
            player.removeSkill(skill, true);
            player.sendSkillList();
        }
        removeSkillsPageM(player, player.getSkillRemPage(), npc);
    }

    public static void removeSkillsPageM(Player player, int page_n, NpcInstance npc) {
        player.setSkillRemPage(page_n);
        Collection<SkillEntry> skills = player.getAllSkills();

        HtmlMessage html = new HtmlMessage(npc);
        StringBuilder replyMSG = new StringBuilder("<html><body>");

        if (skills.size() <= 50) {
            replyMSG.append("<table>");
            for (SkillEntry skill : skills) {
                if (Config.ENABLE_MULTICLASS_SKILL_REMOVE_BLACKLIST.contains(skill.getId()))
                    continue;
                if (player.isLangRus())
                    replyMSG.append("<tr><td><img src=\"").append(skill.getTemplate().getIcon()).append("\" width=32 height=32></td><td>[npc_%objectId%_RMPS ").append(skill.getId()).append("| Удалить ").append(skill.getName()).append("]</td><td>").append(Config.ENABLE_MULTICLASS_SKILL_REMOVE_ITEM_S.isEmpty() ? "" : Config.ENABLE_MULTICLASS_SKILL_REMOVE_ITEM_S).append("</td></tr>");
                else
                    replyMSG.append("<tr><td><img src=\"").append(skill.getTemplate().getIcon()).append("\" width=32 height=32></td><td>[npc_%objectId%_RMPS ").append(skill.getId()).append("| Delete ").append(skill.getName()).append("]</td><td>").append(Config.ENABLE_MULTICLASS_SKILL_REMOVE_ITEM_S.isEmpty() ? "" : Config.ENABLE_MULTICLASS_SKILL_REMOVE_ITEM_S).append("</td></tr>");
            }
            replyMSG.append("</table>");
        } else {
            replyMSG.append("<table>");
            for (int i = (page_n - 1) * 50; (i < page_n * 50) && (i < skills.size()); i++) {
                if (Config.ENABLE_MULTICLASS_SKILL_REMOVE_BLACKLIST.contains(((Skill) skills.toArray()[i]).getId()))
                    continue;
                if (player.isLangRus())
                    replyMSG.append("<tr><td><img src=\"").append(((Skill) skills.toArray()[i]).getIcon()).append("\" width=32 height=32></td><td>[npc_%objectId%_RMPS ").append(((Skill) skills.toArray()[i]).getId()).append("| Удалить ").append(((Skill) skills.toArray()[i]).getName()).append("]</td><td>").append(Config.ENABLE_MULTICLASS_SKILL_REMOVE_ITEM_S.isEmpty() ? "" : Config.ENABLE_MULTICLASS_SKILL_REMOVE_ITEM_S).append("</td></tr>");
                else
                    replyMSG.append("<tr><td><img src=\"").append(((Skill) skills.toArray()[i]).getIcon()).append("\" width=32 height=32></td><td>[npc_%objectId%_RMPS ").append(((Skill) skills.toArray()[i]).getId()).append("| Delete ").append(((Skill) skills.toArray()[i]).getName()).append("]</td><td>").append(Config.ENABLE_MULTICLASS_SKILL_REMOVE_ITEM_S.isEmpty() ? "" : Config.ENABLE_MULTICLASS_SKILL_REMOVE_ITEM_S).append("</td></tr>");
            }
            replyMSG.append("</table><br>");
            int page = 1;
            for (int i = 1; i <= skills.size(); i = i + 50) {
                if (page_n == page) {
                    replyMSG.append(page_n).append("  ");
                } else {
                    replyMSG.append("[npc_%objectId%_RemSkills ").append(page).append("| ").append(page).append("]  ");
                }
                page++;
            }
        }

        replyMSG.append("</body></html>");
        html.setHtml(HtmlUtils.bbParse(replyMSG.toString()));
        player.sendPacket(html);
    }

    public static long getCost(Player player, Skill skill, double mult, AcquireType type){
        long cost = 0;
        int level = player.getSkillLevel(skill.getId()) == -1 ? 1 : player.getSkillLevel(skill.getId());
        for (; level <= skill.getLevel(); level++) {
            SkillLearn skillLearn = SkillAcquireHolder.getInstance().getSkillLearnM(player, skill.getId(), level, type);
            if (skillLearn != null && skillLearn.getMinLevel() <= player.getLevel())
                cost += skillLearn.getCost();
        }
        return (long) (cost * mult);
    }

    public static long getCostDop(Player player, Skill skill, double mult, AcquireType type){
        long cost = 0;
        int level = player.getSkillLevel(skill.getId()) == -1 ? 1 : player.getSkillLevel(skill.getId());
        for (; level <= skill.getLevel(); level++) {
            SkillLearn skillLearn = SkillAcquireHolder.getInstance().getSkillLearn(player, skill.getId(), level, type);
            if (skillLearn != null && skillLearn.getMinLevel() <= player.getLevel())
                cost += skillLearn.getCost();
        }
        return (long) (cost * mult);
    }
}
