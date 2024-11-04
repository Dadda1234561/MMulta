package handler.bbs.custom;

import l2s.gameserver.Config;
import l2s.gameserver.common.DifferentMethods;
import l2s.gameserver.data.htm.HtmCache;
import l2s.gameserver.data.string.SkillDescHolder;
import l2s.gameserver.data.xml.holder.ItemHolder;
import l2s.gameserver.data.xml.holder.SkillAcquireHolder;
import l2s.gameserver.data.xml.holder.SkillHolder;
import l2s.gameserver.handler.bbs.BbsHandlerHolder;
import l2s.gameserver.handler.bbs.IBbsHandler;
import l2s.gameserver.listener.actor.player.OnAnswerListener;
import l2s.gameserver.listener.script.OnInitScriptListener;
import l2s.gameserver.model.Mods.Multiproff;
import l2s.gameserver.model.Mods.Reborn.RebornSystem;
import l2s.gameserver.model.Mods.Reborn.RebornSystemInfo;
import l2s.gameserver.model.Mods.Reborn.RebornSystemManager;
import l2s.gameserver.model.Mods.RebornDivine.RebornDivineSystemInfo;
import l2s.gameserver.model.Mods.RebornDivine.RebornDivineSystemManager;
import l2s.gameserver.model.Mods.RebornDivine.RebornDivineSystem;
import l2s.gameserver.model.Mods.RebornPercent.RebornPercentSystem;
import l2s.gameserver.model.Mods.RebornPercent.RebornPercentSystemInfo;
import l2s.gameserver.model.Mods.RebornPercent.RebornPercentSystemManager;
import l2s.gameserver.model.Mods.RebornSub.RebornSubSystem;
import l2s.gameserver.model.Mods.RebornSub.RebornSubSystemInfo;
import l2s.gameserver.model.Mods.RebornSub.RebornSubSystemManager;
import l2s.gameserver.model.Player;
import l2s.gameserver.model.Skill;
import l2s.gameserver.model.SkillLearn;
import l2s.gameserver.model.base.AcquireType;
import l2s.gameserver.model.base.ClassId;
import l2s.gameserver.model.base.ClassLevel;
import l2s.gameserver.network.l2.components.SystemMsg;
import l2s.gameserver.network.l2.s2c.ConfirmDlgPacket;
import l2s.gameserver.network.l2.s2c.ShowBoardPacket;
import l2s.gameserver.network.l2.s2c.SystemMessage;
import l2s.gameserver.network.l2.s2c.UIPacket;
import l2s.gameserver.network.l2.s2c.updatetype.UserInfoType;
import l2s.gameserver.skills.SkillEntry;
import l2s.gameserver.skills.SkillEntryType;
import l2s.gameserver.templates.item.ItemTemplate;
import l2s.gameserver.templates.item.data.ItemData;
import l2s.gameserver.utils.ItemFunctions;
import l2s.gameserver.utils.Util;
import org.apache.commons.lang3.ArrayUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.util.ArrayList;
import java.util.Collection;
import java.util.List;
import java.util.StringTokenizer;
import java.util.stream.Collectors;

import static l2s.gameserver.utils.HtmlUtils.iconImg;

public class CommunitySkillLearn implements OnInitScriptListener, IBbsHandler {
    private static final Logger _log = LoggerFactory.getLogger(CommunitySkillLearn.class);
    // запрещенные скилы для изучения, через запятую
    private static final int[] IGNORE_SKILLS = {0};
    private static final String SP_TEMPLATE = "<table border=0 width=620><tr><td></td><td><table><tr><td width=38 height=22 align=center valign=center><Img width=32 height=16\" src=\"L2UI_CT1.HtmlWnd.HTMLWnd_SP\"></td><td height=22 width=236><font color=ba8860><?sp?></font> SP [<?sp_availability?>]</td></tr></table></td></tr></table>";
    private static final String ITEM_TEMPLATE = "<table border=0 width=620><tr><td></td><td><table><tr><td align=center valign=center width=32 height=32><button width=32 height=32\" itemtooltip=\"<?itemId?>\" back=\"<?itemIcon?>\" high=\"<?itemIcon?>\" fore=\"<?itemIcon?>\"></button></td><td width=234 height=32><font color=\"d3c5ae\">&#<?itemId?>;</font><br1>x<?itemCount?> [<?availability>?]</td></tr></table></td></tr></table>";
    //Количество строк на странице
    private final int SHOW_SKILL_PAGE = Config.SHOW_SKILL_PAGE;//Config.SHOW_SKILL_PAGE;
    // Айди итема который береться за изучение скила
    // Айди итема который береться за удаление скила
    private final int ItemIdDelete = Config.SKILL_DELETE_ITEM_ID;//4355;
    // Количество итемов
    private final long ItemCountDelete = Config.SKILL_DELETE_ITEM_COUNT;//1;
    // Айди итема который береться за изучения дополнительных скилов
    private final int ItemIdCustom = Config.SKILL_LEARN_CUSTOM_ITEM_ID;//4357;
    // Количество итемов
    private final long ItemCountCustom = Config.SKILL_LEARN_CUSTOM_ITEM_COUNT;//1;
    //Id скилов которые нужно увеличить в цене
    private final int[] skills_id = Config.SKILL_LEARN_SKILL_ID;//{789, 1495, 785};
    // ID итема для индивидуального скила skills_id
    private final int ItemIdIndiv = Config.SKILL_LEARN_INDIVID_ITEM_ID;//4357;
    // ID итема для индивидуального скила skills_id C
    private final int ItemIdIndivC = Config.SKILL_LEARN_INDIVIDC_ITEM_ID;//4357;
    // Количество итемов для индивидуального скила
    private final long ItemCountIndiv = Config.SKILL_LEARN_INDIVID_ITEM_COUNT;//5;
    // Количество итемов для индивидуального скила
    private final long ItemCountIndivC = Config.SKILL_LEARN_INDIVIDC_ITEM_COUNT;//5;
    //Id скилов которые нужно увеличить в цене для дополнительных скилов
    private final int[] skills_idCustom = Config.SKILL_LEARN_CUSTOM_SKILL_ID;//{789, 1495, 785};
    // ID итема для индивидуального скила skills_id
    private final int ItemIdIndivCustom = Config.SKILL_LEARN_INDIVID_CUSTOM_ITEM_ID;//4357;
    // Количество итемов для индивидуального скила
    private final long ItemCountIndivCustom = Config.SKILL_LEARN_INDIVID_CUSTOM_ITEM_COUNT;//5;
    //рейт на СП при учении обычных скилов
    private final double SP_NORMAL = Config.SKILL_LEARN_SP_NORM;//1.0;
    //рейт на СП при учении дополнительных скилов
    private final double SP_CUSTOM = Config.SKILL_LEARN_SP_CUSTOM;//1.0;
    // рейт на СП при учении дополнительных скилов
    private final double SP_CUSTOM1 = Config.SKILL_LEARN_SP_CUSTOM1;//1.0;

    @Override
    public String[] getBypassCommands() {
        return new String[]{"_bbsskill"};
    }

    @Override
    public void onBypassCommand(Player player, String bypass) {
        StringTokenizer st = new StringTokenizer(bypass, ":");
        st.nextToken();
        String action = st.hasMoreTokens() ? st.nextToken() : "main";
        if (action.startsWith("main-")) {
            StringTokenizer stid = new StringTokenizer(bypass, "-");
            stid.nextToken();
            int classId;
            try {
                classId = Integer.parseInt(stid.nextToken());
            } catch (Exception e) {
                return;
            }
            showSkill(player, 1, classId);
        } else if (action.startsWith("show-")) {
            StringTokenizer stid = new StringTokenizer(bypass, "-");
            stid.nextToken();
            int page;
            int classId;
            try {
                page = Integer.parseInt(stid.nextToken());
                classId = Integer.parseInt(stid.nextToken());
            } catch (Exception e) {
                return;
            }
            showSkill(player, page, classId);
        } else if (action.startsWith("learn-")) {
            StringTokenizer stid = new StringTokenizer(bypass, "-");
            stid.nextToken();
            int skillId;
            int level;
            int classId;
            long cost;
            int page;
            try {
                skillId = Integer.parseInt(stid.nextToken());
                level = Integer.parseInt(stid.nextToken());
                cost = Long.parseLong(stid.nextToken());
                classId = Integer.parseInt(stid.nextToken());
                page = Integer.parseInt(stid.nextToken());
            } catch (Exception e) {
                return;
            }
            learn(player, skillId, level, classId, cost, page);
        } else if (action.startsWith("showdelete")) {
            showDelete(player, 1);
        } else if (action.startsWith("showp-")) {
            StringTokenizer stid = new StringTokenizer(bypass, "-");
            stid.nextToken();
            int page;
            try {
                page = Integer.parseInt(stid.nextToken());
            } catch (Exception e) {
                return;
            }
            showDelete(player, page);
        } else if (action.startsWith("delete")) {
            StringTokenizer stid = new StringTokenizer(bypass, "-");
            stid.nextToken();
            int skillId;
            int level;
            try {
                skillId = Integer.parseInt(stid.nextToken());
                level = Integer.parseInt(stid.nextToken());
            } catch (Exception e) {
                return;
            }
            delete(player, skillId, level);
        } else if (action.equalsIgnoreCase("custom")) {
            showCustom(player, 1);
        } else if (action.startsWith("showcp-")) {
            StringTokenizer stid = new StringTokenizer(bypass, "-");
            stid.nextToken();
            int page;
            try {
                page = Integer.parseInt(stid.nextToken());
            } catch (Exception e) {
                return;
            }
            showCustom(player, page);
        } else if (action.equalsIgnoreCase("custom1")) {
            showCustom1(player, 1);
        } else if (action.startsWith("showcp1-")) {
            StringTokenizer stid = new StringTokenizer(bypass, "-");
            stid.nextToken();
            int page;
            try {
                page = Integer.parseInt(stid.nextToken());
            } catch (Exception e) {
                return;
            }
            showCustom1(player, page);
        } else if (action.equalsIgnoreCase("certification")) {
            showCertification(player, 1);
        } else if (action.startsWith("showCertifPage-")) {
            StringTokenizer stid = new StringTokenizer(bypass, "-");
            stid.nextToken();
            int page;
            try {
                page = Integer.parseInt(stid.nextToken());
            } catch (Exception e) {
                return;
            }
            showCertification(player, page);
        } else if (action.startsWith("learnC-")) {
            StringTokenizer stid = new StringTokenizer(bypass, "-");
            stid.nextToken();
            int skillId;
            int level;
            long cost;
            int page;
            try {
                skillId = Integer.parseInt(stid.nextToken());
                level = Integer.parseInt(stid.nextToken());
                cost = Long.parseLong(stid.nextToken());
                page = Integer.parseInt(stid.nextToken());
            } catch (Exception e) {
                return;
            }
            learnC(player, skillId, level, cost, page);
        } else if (action.startsWith("learnC1-")) {
            StringTokenizer stid = new StringTokenizer(bypass, "-");
            stid.nextToken();
            int skillId;
            int level;
            long cost;
            int page;
            try {
                skillId = Integer.parseInt(stid.nextToken());
                level = Integer.parseInt(stid.nextToken());
                cost = Long.parseLong(stid.nextToken());
                page = Integer.parseInt(stid.nextToken());
            } catch (Exception e) {
                return;
            }
            learnC1(player, skillId, level, cost, page);
        } else if (action.startsWith("Reborn_show")) {
            RebornSystem_info(player);
        } else if (action.startsWith("newRebornSystem_delReborn")) {
            String[] args = bypass.split(":");
            if (args.length != 3) {
                _log.info("Wrong args passed to delReborn!");
                return;
            }
            int rebornStatId = -1;
            try {
                rebornStatId = Integer.parseInt(args[2]);
            } catch (NumberFormatException e) {
                e.printStackTrace();
            }
            newRebornSystem_delReborn(player, rebornStatId);
        } else if (action.startsWith("newRebornSystem_delShow")) {
            newRebornSystem_delShow(player);
        }
        else if (action.startsWith("newRebornSystem_show")) {
            newRebornSystem_info(player);
        } else if (action.startsWith("RebornPercentSystem_show")) {
            RebornPercentSystem_info(player);
        } else if (action.startsWith("RebornDivineSystem_show")) {
            RebornDivineSystem_info(player);
        } else if (action.startsWith("RebornSub_show")) {
            RebornSubSystem_info(player);
        } else if (action.startsWith("RebornSub_tryReborn")) {
            RebornSubSystem.RebornSubAdd(player, 0, true);
        }
        else if (action.startsWith("newRebornButton")) {
            ConfirmDlgPacket dlg = new ConfirmDlgPacket(SystemMsg.S1, 20000).addString(player.isLangRus() ? "Вы уверены, что хотите переродиться?" : "Are you sure you want to be reborn?");
            player.ask(dlg, new OnAnswerListener() {
                @Override
                public void sayYes() {
                    RebornSystem.rebornSystemNew(player, true);
                }

                @Override
                public void sayNo() {
                    newRebornSystem_info(player);
                }
            });
        }
        else if (action.startsWith("RebornPercentSystemButton")) {
            ConfirmDlgPacket dlg = new ConfirmDlgPacket(SystemMsg.S1, 20000).addString(player.isLangRus() ? "Вы уверены, что хотите переродиться?" : "Are you sure you want to be reborn?");
            player.ask(dlg, new OnAnswerListener() {
                @Override
                public void sayYes() {
                    RebornPercentSystem.RebornPercentAdd(player, true);
                }

                @Override
                public void sayNo() {
                    RebornPercentSystem_info(player);
                }
            });
        }
        else if (action.startsWith("RebornDivineSystemButton")) {
            ConfirmDlgPacket dlg = new ConfirmDlgPacket(SystemMsg.S1, 20000).addString(player.isLangRus() ? "Вы уверены, что хотите переродиться?" : "Are you sure you want to be reborn?");
            player.ask(dlg, new OnAnswerListener() {
                @Override
                public void sayYes() {
                    RebornDivineSystem.RebornDivineAdd(player, true);
                }

                @Override
                public void sayNo() {
                    RebornDivineSystem_info(player);
                }
            });
        } else if (action.startsWith("Reborn-")) {
            StringTokenizer stid = new StringTokenizer(bypass, "-");
            stid.nextToken();
            int value;
            try {
                value = Integer.parseInt(stid.nextToken());
            } catch (Exception e) {
                return;
            }
            ConfirmDlgPacket dlg = new ConfirmDlgPacket(SystemMsg.S1, 20000).addString(player.isLangRus() ? "Вы уверены, что хотите выбрать данное умение?" : "Are you sure you want to be reborn skill?");

            player.ask(dlg, new OnAnswerListener() {
                @Override
                public void sayYes() {
                    RebornSystem.rebornSkillAdd(player, value, true);
                }

                @Override
                public void sayNo() {
                    RebornSystem_info(player);
                }
            });
        } else if (action.startsWith("RebornSub-")) {
            StringTokenizer stid = new StringTokenizer(bypass, "-");
            stid.nextToken();
            int value;
            try {
                value = Integer.parseInt(stid.nextToken());
            } catch (Exception e) {
                return;
            }
            ConfirmDlgPacket dlg = new ConfirmDlgPacket(SystemMsg.S1, 20000).addString(player.isLangRus() ? "Вы уверены, что хотите переродиться?" : "Are you sure you want to be reborn?");

            player.ask(dlg, new OnAnswerListener() {
                @Override
                public void sayYes() {
                    RebornSubSystem.RebornSubAdd(player, value, true);
                }

                @Override
                public void sayNo() {
                    RebornSubSystem_info(player);
                }
            });
        }
        else if (action.startsWith("showF-")) {
            StringTokenizer stid = new StringTokenizer(bypass, "-");
            stid.nextToken();
            int skillId;
            int level;
            long cost;
            int classId;
            int page;
            try {
                skillId = Integer.parseInt(stid.nextToken());
                level = Integer.parseInt(stid.nextToken());
                cost = Long.parseLong(stid.nextToken());
                classId = Integer.parseInt(stid.nextToken());
                page = Integer.parseInt(stid.nextToken());
            } catch (Exception e) {
                return;
            }
            showF(player, skillId, level, cost, classId, page);
        } else if (action.startsWith("showFcustom-")) {
            StringTokenizer stid = new StringTokenizer(bypass, "-");
            stid.nextToken();
            int skillId;
            int level;
            long cost;
            int page;
            try {
                skillId = Integer.parseInt(stid.nextToken());
                level = Integer.parseInt(stid.nextToken());
                cost = Long.parseLong(stid.nextToken());
                page = Integer.parseInt(stid.nextToken());
            } catch (Exception e) {
                return;
            }
            showFCustom(player, skillId, level, cost, page);
        } else if (action.startsWith("showFcustom1-")) {
            StringTokenizer stid = new StringTokenizer(bypass, "-");
            stid.nextToken();
            int skillId;
            int level;
            long cost;
            int page;
            try {
                skillId = Integer.parseInt(stid.nextToken());
                level = Integer.parseInt(stid.nextToken());
                cost = Long.parseLong(stid.nextToken());
                page = Integer.parseInt(stid.nextToken());
            } catch (Exception e) {
                return;
            }
            showFCustom1(player, skillId, level, cost, page);
        }
    }
    private void RebornSubSystem_info(Player player) {
        String html = HtmCache.getInstance().getHtml(Config.BBS_HOME_DIR + "pages/SkillLearn/RebornSub.htm", player);
        int REBORN_COUNT = player.getRebirthCountSub();
        RebornSubSystemInfo info = RebornSubSystemManager.getRebornId(REBORN_COUNT);

        if (info != null) {
            String content = "";
            String need_item = "";
            String reward_item = "";
            String level_need = "";
            String time_rebirth = "";
            int max_rebirth = 0;
            int maxSTR = 0;
            int maxINT = 0;
            int maxDEX = 0;
            int maxWIT = 0;

            int maxCON = 0;
            int maxMEN = 0;
            int maxPvePhysDmg = 0;
            int maxPveMagDmg = 0;

            int maxCHA = 0;
            int maxMaxCP = 0;
            int maxMaxHP = 0;
            int maxMaxMP = 0;

            int maxPhysDmg = 0;
            int maxMagDmg = 0;
            int maxPhysDef = 0;
            int maxMagDef = 0;

            int maxPhysCritDmg = 0;
            int maxMagCritDmg = 0;
            int maxPhysCritRate = 0;
            int maxMagCritRate = 0;

            int maxPvpDmg = 0;
            int maxPvpMagDmg = 0;
            int maxPvpDef = 0;
            int maxPvpMagDef = 0;

            int maxMReuse = 0;
            int maxAdenaRate = 0;
            int maxExpRate = 0;
            int maxDropRate = 0;

            int addSTR = 0;
            int addINT = 0;
            int addDEX = 0;
            int addWIT = 0;

            int addCON = 0;
            int addMEN = 0;
            int addPvePhysDmg = 0;
            int addPveMagDmg = 0;

            int addCHA = 0;
            int addMaxCP = 0;
            int addMaxHP = 0;
            int addMaxMP = 0;

            int addPhysDmg = 0;
            int addMagDmg = 0;
            int addPhysDef = 0;
            int addMagDef = 0;

            int addPhysCritDmg = 0;
            int addMagCritDmg = 0;
            int addPhysCritRate = 0;
            int addMagCritRate = 0;

            int addPvpPhysDmg = 0;
            int addPvpMagDmg = 0;
            int addPvpPhysDef = 0;
            int addPvpMagDef = 0;

            int addMReuse = 0;
            int addAdenaRate = 0;
            int addExpRate = 0;
            int addDropRate = 0;
            int rebirthsSub = 0;
            if (REBORN_COUNT == (info.getRebornId() - 1)) {
                for (String ingredient : info.getNeedItem().split(";")) {
                    String[] ingredients = ingredient.split(",");
                    if (ingredients.length == 2) {
                        need_item = need_item + Long.parseLong(ingredients[1]) + " " + DifferentMethods.getItemName(Integer.parseInt(ingredients[0])) + " ";
                    } else {
                        _log.error("Error reward_array.length != 2");
                    }
                }
                for (String reward : info.getReward().split(";")) {
                    if (!reward.isEmpty()) {
                        String[] reward_array = reward.split(",");
                        if (reward_array.length == 2) {
                            reward_item = reward_item + Long.parseLong(reward_array[1]) + " " + DifferentMethods.getItemName(Integer.parseInt(reward_array[0])) + " ";
                        } else {
                            _log.error("Error reward_array.length != 2");
                        }
                    }
                }
                level_need = String.valueOf(info.getLevelNeed());
                time_rebirth = String.valueOf(info.getResetTimeInBoard(player));
                max_rebirth = RebornSubSystemManager.getSize();
                maxSTR = RebornSubSystemManager.maxSTR();
                maxINT = RebornSubSystemManager.maxINT();
                maxDEX = RebornSubSystemManager.maxDEX();
                maxWIT = RebornSubSystemManager.maxWIT();

                maxCON = RebornSubSystemManager.maxCON();
                maxMEN = RebornSubSystemManager.maxMEN();
                maxPvePhysDmg = RebornSubSystemManager.maxPvePhysDmg();
                maxPveMagDmg = RebornSubSystemManager.maxPveMagDmg();

                maxCHA = RebornSubSystemManager.maxCHA();
                maxMaxCP = RebornSubSystemManager.maxMaxCP();
                maxMaxHP = RebornSubSystemManager.maxMaxHP();
                maxMaxMP = RebornSubSystemManager.maxMaxMP();

                maxPhysDmg = RebornSubSystemManager.maxPhysDmg();
                maxMagDmg = RebornSubSystemManager.maxMagDmg();
                maxPhysDef = RebornSubSystemManager.maxPhysDef();
                maxMagDef = RebornSubSystemManager.maxMagDef();

                maxPhysCritDmg = RebornSubSystemManager.maxPhysCritDmg();
                maxMagCritDmg = RebornSubSystemManager.maxMagCritDmg();
                maxPhysCritRate = RebornSubSystemManager.maxPhysCritRate();
                maxMagCritRate = RebornSubSystemManager.maxMagCritRate();

                maxPvpDmg = RebornSubSystemManager.maxPvpDmg();
                maxPvpMagDmg = RebornSubSystemManager.maxPvpMagDmg();
                maxPvpDef = RebornSubSystemManager.maxPvpDef();
                maxPvpMagDef = RebornSubSystemManager.maxPvpMagDef();

                maxMReuse = RebornSubSystemManager.maxMReuse();
                maxAdenaRate = RebornSubSystemManager.maxAdenaRate();
                maxExpRate = RebornSubSystemManager.maxExpRate();
                maxDropRate = RebornSubSystemManager.maxDropRate();

                addSTR = info.getSTR();
                addINT = info.getINT();
                addDEX = info.getDEX();
                addWIT = info.getWIT();

                addCON = info.getCON();
                addMEN = info.getMEN();
                addPvePhysDmg = info.getPvePhysDmg();
                addPveMagDmg = info.getPveMagDmg();

                addCHA = info.getCHA();
//                addMaxCP = info.getMaxCP();
                addMaxCP = RebornSubSystemManager.maxMaxCP();
                addMaxHP = info.getMaxHP();
                addMaxMP = info.getMaxMP();

                addPhysDmg = info.getPhysDmg();
                addMagDmg = info.getMagDmg();
                addPhysDef = info.getPhysDef();
                addMagDef = info.getMagDef();

                addPhysCritDmg = info.getPhysCritDmg();
                addMagCritDmg = info.getMagCritDmg();
                addPhysCritRate = info.getPhysCritRate();
                addMagCritRate = info.getMagCritRate();

                addPvpPhysDmg = info.getPvpDmg();
                addPvpMagDmg = info.getPvpMagDmg();
                addPvpPhysDef = info.getPvpDef();
                addPvpMagDef = info.getPvpMagDef();

                addMReuse = info.getMReuse();
                addAdenaRate = info.getAdenaRate();
                addExpRate = info.getExpRate();
                addDropRate = info.getDropRate();
                rebirthsSub = player.getRebirthCountSub();

            }
            html = html.replace("<?need_item?>", need_item);
            html = html.replace("<?rebirthsSub?>", String.valueOf(rebirthsSub));
            html = html.replace("<?need_item?>", need_item);
            html = html.replace("<?max_rebirth?>", String.valueOf(max_rebirth));

//            html = html.replace("<?count_str_max?>", String.valueOf(maxSTR));
//            html = html.replace("<?count_int_max?>", String.valueOf(maxINT));
//            html = html.replace("<?count_dex_max?>", String.valueOf(maxDEX));
//            html = html.replace("<?count_wit_max?>", String.valueOf(maxWIT));
//
//            html = html.replace("<?count_con_max?>", String.valueOf(maxCON));
//            html = html.replace("<?count_men_max?>", String.valueOf(maxMEN));
//            html = html.replace("<?count_PvePhysDmg_max?>", String.valueOf(maxPvePhysDmg));
//            html = html.replace("<?count_PveMagDmg_max?>", String.valueOf(maxPveMagDmg));
//
//            html = html.replace("<?count_CHA_max?>", String.valueOf(maxCHA));
//            html = html.replace("<?count_MaxCP_max?>", String.valueOf(maxMaxCP));
//            html = html.replace("<?count_MaxHP_max?>", String.valueOf(maxMaxHP));
//            html = html.replace("<?count_MaxMP_max?>", String.valueOf(maxMaxMP));
//
//            html = html.replace("<?count_PhysDmg_max?>", String.valueOf(maxPhysDmg));
//            html = html.replace("<?count_MagDmg_max?>", String.valueOf(maxMagDmg));
            html = html.replace("<?count_PhysDef_max?>", String.valueOf(maxPhysDef));
            html = html.replace("<?count_MagDef_max?>", String.valueOf(maxMagDef));

            html = html.replace("<?count_PhysCritDmg_max?>", String.valueOf(maxPhysCritDmg));
            html = html.replace("<?count_MagCritDmg_max?>", String.valueOf(maxMagCritDmg));
//            html = html.replace("<?count_PhysCritRate_max?>", String.valueOf(maxPhysCritRate));
//            html = html.replace("<?count_MagCritRate_max?>", String.valueOf(maxMagCritRate));
//
            html = html.replace("<?count_PvpDmg_max?>", String.valueOf(maxPvpDmg));
//            html = html.replace("<?count_PvpMagDmg_max?>", String.valueOf(maxPvpMagDmg));
            html = html.replace("<?count_PvpDef_max?>", String.valueOf(maxPvpDef));
//            html = html.replace("<?count_PvpMagDef_max?>", String.valueOf(maxPvpMagDef));
//
//            html = html.replace("<?count_MReuse_max?>", String.valueOf(maxMReuse));
//            html = html.replace("<?count_AdenaRate_max?>", String.valueOf(maxAdenaRate));
//            html = html.replace("<?count_ExpRate_max?>", String.valueOf(maxExpRate));
//            html = html.replace("<?count_DropRate_max?>", String.valueOf(maxDropRate));
//
//
//            html = html.replace("<?count_str?>", String.valueOf(player.getVarInt("addSTRSub", 0)));
//            html = html.replace("<?count_int?>", String.valueOf(player.getVarInt("addINTSub", 0)));
//            html = html.replace("<?count_dex?>", String.valueOf(player.getVarInt("addDEXSub", 0)));
//            html = html.replace("<?count_wit?>", String.valueOf(player.getVarInt("addWITSub", 0)));
//
//            html = html.replace("<?count_con?>", String.valueOf(player.getVarInt("addCONSub", 0)));
//            html = html.replace("<?count_men?>", String.valueOf(player.getVarInt("addMENSub", 0)));
//            html = html.replace("<?count_PvePhysDmg?>", String.valueOf(player.getVarInt("addPvePhysDmgSub", 0)));
//            html = html.replace("<?count_PveMagDmg?>", String.valueOf(player.getVarInt("addPveMagDmgSub", 0)));
//
//            html = html.replace("<?count_CHA?>", String.valueOf(player.getVarInt("addCHASub", 0)));
            html = html.replace("<?count_HPMPCPSub?>", String.valueOf(player.getVarInt("addMaxHPMPCPSub", 0)));
//            html = html.replace("<?count_MaxHP?>", String.valueOf(player.getVarInt("addMaxHPSub", 0)));
//            html = html.replace("<?count_MaxMP?>", String.valueOf(player.getVarInt("addMaxMPSub", 0)));
//
//            html = html.replace("<?count_PhysDmg?>", String.valueOf(player.getVarInt("addPhysDmgSub", 0)));
//            html = html.replace("<?count_MagDmg?>", String.valueOf(player.getVarInt("addMagDmgSub", 0)));
            html = html.replace("<?count_PhysDef?>", String.valueOf(player.getVarInt("addPhysDefSub", 0)));
            html = html.replace("<?count_MagDef?>", String.valueOf(player.getVarInt("addMagDefSub", 0)));
//
            html = html.replace("<?count_PhysCritDmg?>", String.valueOf(player.getVarInt("addPhysCritDmgSub", 0)));
            html = html.replace("<?count_MagCritDmg?>", String.valueOf(player.getVarInt("addMagCritDmgSub", 0)));
//            html = html.replace("<?count_PhysCritRate?>", String.valueOf(player.getVarInt("addPhysCritRateSub", 0)));
//            html = html.replace("<?count_MagCritRate?>", String.valueOf(player.getVarInt("addMagCritRateSub", 0)));
//
            html = html.replace("<?count_PvpDmg?>", String.valueOf(player.getVarInt("addPvpDmgSub", 0)));
//            html = html.replace("<?count_PvpMagDmg?>", String.valueOf(player.getVarInt("addPvpMagDmgSub", 0)));
            html = html.replace("<?count_PvpDef?>", String.valueOf(player.getVarInt("addPvpDefSub", 0)));
//            html = html.replace("<?count_PvpMagDef?>", String.valueOf(player.getVarInt("addPvpMagDefSub", 0)));
//
//            html = html.replace("<?count_MReuse?>", String.valueOf(player.getVarInt("addMReuseSub", 0)));
//            html = html.replace("<?count_AdenaRate?>", String.valueOf(player.getVarInt("addAdenaRateSub", 0)));
//            html = html.replace("<?count_ExpRate?>", String.valueOf(player.getVarInt("addExpRateSub", 0)));
//            html = html.replace("<?count_DropRate?>", String.valueOf(player.getVarInt("addDropRateSub", 0)));
//
//            html = html.replace("<?add_str?>", String.valueOf(addSTR));
//            html = html.replace("<?add_int?>", String.valueOf(addINT));
//            html = html.replace("<?add_dex?>", String.valueOf(addDEX));
//            html = html.replace("<?add_wit?>", String.valueOf(addWIT));
//
//            html = html.replace("<?add_con?>", String.valueOf(addCON));
//            html = html.replace("<?add_men?>", String.valueOf(addMEN));
//            html = html.replace("<?add_PvePhysDmg?>", String.valueOf(addPvePhysDmg));
//            html = html.replace("<?add_PveMagDmg?>", String.valueOf(addPveMagDmg));
//
//            html = html.replace("<?add_MaxCHA?>", String.valueOf(addCHA));
            html = html.replace("<?Count_MaxHPMPCPSub?>", String.valueOf(addMaxCP));
//            html = html.replace("<?add_MaxHP?>", String.valueOf(addMaxHP));
//            html = html.replace("<?add_MaxMP?>", String.valueOf(addMaxMP));
//
//            html = html.replace("<?add_PhysDmg?>", String.valueOf(addPhysDmg));
//            html = html.replace("<?add_MagDmg?>", String.valueOf(addMagDmg));
//            html = html.replace("<?add_PhysDef?>", String.valueOf(addPhysDef));
//            html = html.replace("<?add_MagDef?>", String.valueOf(addMagDef));
//
//            html = html.replace("<?add_PhysCritDmg?>", String.valueOf(addPhysCritDmg));
//            html = html.replace("<?add_MagCritDmg?>", String.valueOf(addMagCritDmg));
//            html = html.replace("<?add_PhysCritRate?>", String.valueOf(addPhysCritRate));
//            html = html.replace("<?add_MagCritRate?>", String.valueOf(addMagCritRate));
//
//            html = html.replace("<?add_PvpPhysDmg?>", String.valueOf(addPvpPhysDmg));
//            html = html.replace("<?add_PvpMagDmg?>", String.valueOf(addPvpMagDmg));
//            html = html.replace("<?add_PvpPhysDef?>", String.valueOf(addPvpPhysDef));
//            html = html.replace("<?add_PvpMagDef?>", String.valueOf(addPvpMagDef));
//
//            html = html.replace("<?add_MReuse?>", String.valueOf(addMReuse));
//            html = html.replace("<?add_AdenaRate?>", String.valueOf(addAdenaRate));
//            html = html.replace("<?add_ExpRate?>", String.valueOf(addExpRate));
//            html = html.replace("<?add_DropRate?>", String.valueOf(addDropRate));
//            html = html.replace("<?reward_item?>", reward_item);
            html = html.replace("<?level_need?>", level_need);
            html = html.replace("<?time_rebirth?>", time_rebirth);
            html = html.replace("<?content?>", content);
        }

        ShowBoardPacket.separateAndSend(html, player);
    }

    private void RebornSystem_info(Player player) {
        String html = HtmCache.getInstance().getHtml(Config.BBS_HOME_DIR + "pages/SkillLearn/Reborn.htm", player);
        int REBORN_COUNT = player.getRebirthCount();
        RebornSystemInfo info = RebornSystemManager.getRebornId(REBORN_COUNT);

        if (info != null) {
            String content = "";
            String need_item = "";
            String reward_item = "";
            String level_need = "";
            String time_rebirth = "";
            int max_rebirth = 0;
            int maxSTR = 0;
            int maxINT = 0;
            int maxDEX = 0;
            int maxWIT = 0;

            int maxCON = 0;
            int maxMEN = 0;
            int maxPvePhysDmg = 0;
            int maxPveMagDmg = 0;

            int maxCHA = 0;
            int maxMaxCP = 0;
            int maxMaxHP = 0;
            int maxMaxMP = 0;

            int maxPhysDmg = 0;
            int maxMagDmg = 0;
            int maxPhysDef = 0;
            int maxMagDef = 0;

            int maxPhysCritDmg = 0;
            int maxMagCritDmg = 0;
            int maxPhysCritRate = 0;
            int maxMagCritRate = 0;

            int maxPvpPhysDmg = 0;
            int maxPvpMagDmg = 0;
            int maxPvpPhysDef = 0;
            int maxPvpMagDef = 0;

            int maxMReuse = 0;
            int maxAdenaRate = 0;
            int maxExpRate = 0;
            int maxDropRate = 0;

            int maxSoulShotPowerRate = 0;
            int maxSpiritShotPowerRate = 0;

            int addSTR = 0;
            int addINT = 0;
            int addDEX = 0;
            int addWIT = 0;

            int addCON = 0;
            int addMEN = 0;
            int addCHA = 0;
            double addPvePhysDmg = 0;
            double addPveMagDmg = 0;

            double addMaxCP = 0;
            double addMaxHP = 0;
            double addMaxMP = 0;

            double addPhysDmg = 0;
            double addMagDmg = 0;
            double addPhysDef = 0;
            double addMagDef = 0;

            double addPhysCritDmg = 0;
            double addMagCritDmg = 0;
            double addPhysCritRate = 0;
            double addMagCritRate = 0;

            double addPvpPhysDmg = 0;
            double addPvpMagDmg = 0;
            double addPvpPhysDef = 0;
            double addPvpMagDef = 0;

            double addMReuse = 0;
            double addAdenaRate = 0;
            double addExpRate = 0;
            double addDropRate = 0;

            double addSoulShotPowerRate = 0;
            double addSpiritShotPowerRate = 0;

            //content = content + "<button value =\"Переродиться\" action=\"bypass -h npc_%objectId%_Reborn " + REBORN_COUNT + "\"width=110 height=17 back=\"L2UI_CT1.ListCTRL_DF_Title_Down\" fore=\"L2UI_CT1.ListCTRL_DF_Title\">";
            if (REBORN_COUNT == (info.getRebornId() - 1)) {
                for (String ingredient : info.getNeedItem().split(";")) {
                    String[] ingredients = ingredient.split(",");
                    if (ingredients.length >= 2) {
                        int itemId = Integer.parseInt(ingredients[0]);
                        long itemCount = Long.parseLong(ingredients[1]);
                        int itemEnchant = ingredients.length == 3 ? Integer.parseInt(ingredients[2]) : 0;

                        need_item += itemCount + " " + DifferentMethods.getItemName(itemId);
                        if (itemEnchant > 0) {
                            need_item += " (+" + itemEnchant + ")";
                        }
                        need_item += " ";
                    } else {
                        _log.error("Error ingredients.length != 2 or 3");
                    }
                }

                for (String reward : info.getReward().split(";")) {
                    if (!reward.isEmpty()) {
                        String[] reward_array = reward.split(",");
                        if (reward_array.length >= 2) {
                            int itemId = Integer.parseInt(reward_array[0]);
                            long itemCount = Long.parseLong(reward_array[1]);
                            int itemEnchant = reward_array.length == 3 ? Integer.parseInt(reward_array[2]) : 0;

                            reward_item += itemCount + " " + DifferentMethods.getItemName(itemId);
                            if (itemEnchant > 0) {
                                reward_item += " (+" + itemEnchant + ")";
                            }
                            reward_item += " ";
                        } else {
                            _log.error("Error reward_array.length != 2 or 3");
                        }
                    }
                }

                level_need = String.valueOf(info.getLevelNeed());
                time_rebirth = String.valueOf(info.getResetTimeInBoard(player));
                max_rebirth = RebornSystemManager.getSize();
                maxSTR = RebornSystemManager.maxSTR();
                maxINT = RebornSystemManager.maxINT();
                maxDEX = RebornSystemManager.maxDEX();
                maxWIT = RebornSystemManager.maxWIT();

                maxCON = RebornSystemManager.maxCON();
                maxMEN = RebornSystemManager.maxMEN();
                maxPvePhysDmg = RebornSystemManager.maxPvePhysDmg();
                maxPveMagDmg = RebornSystemManager.maxPveMagDmg();

                maxCHA = RebornSystemManager.maxCHA();
                maxMaxCP = RebornSystemManager.maxMaxCP();
                maxMaxHP = RebornSystemManager.maxMaxHP();
                maxMaxMP = RebornSystemManager.maxMaxMP();

                maxPhysDmg = RebornSystemManager.maxPhysDmg();
                maxMagDmg = RebornSystemManager.maxMagDmg();
                maxPhysDef = RebornSystemManager.maxPhysDef();
                maxMagDef = RebornSystemManager.maxMagDef();

                maxPhysCritDmg = RebornSystemManager.maxPhysCritDmg();
                maxMagCritDmg = RebornSystemManager.maxMagCritDmg();
                maxPhysCritRate = RebornSystemManager.maxPhysCritRate();
                maxMagCritRate = RebornSystemManager.maxMagCritRate();

                maxPvpPhysDmg = RebornSystemManager.maxPvpPhysDmg();
                maxPvpMagDmg = RebornSystemManager.maxPvpMagDmg();
                maxPvpPhysDef = RebornSystemManager.maxPvpPhysDef();
                maxPvpMagDef = RebornSystemManager.maxPvpMagDef();

                maxMReuse = RebornSystemManager.maxMReuse();
                maxAdenaRate = RebornSystemManager.maxAdenaRate();
                maxExpRate = RebornSystemManager.maxExpRate();
                maxDropRate = RebornSystemManager.maxDropRate();
                maxSoulShotPowerRate = RebornSystemManager.maxSoulShotPowerRate();
                maxSpiritShotPowerRate = RebornSystemManager.maxSpiritShotPowerRate();

                addSTR = info.getSTR();
                addINT = info.getINT();
                addDEX = info.getDEX();
                addWIT = info.getWIT();

                addCON = info.getCON();
                addMEN = info.getMEN();
                addCHA = info.getCHA();
                addPvePhysDmg = info.getPvePhysDmg();
                addPveMagDmg = info.getPveMagDmg();

                addMaxCP = info.getMaxCP();
                addMaxHP = info.getMaxHP();
                addMaxMP = info.getMaxMP();

                addPhysDmg = info.getPhysDmg();
                addMagDmg = info.getMagDmg();
                addPhysDef = info.getPhysDef();
                addMagDef = info.getMagDef();

                addPhysCritDmg = info.getPhysCritDmg();
                addMagCritDmg = info.getMagCritDmg();
                addPhysCritRate = info.getPhysCritRate();
                addMagCritRate = info.getMagCritRate();

                addPvpPhysDmg = info.getPvpPhysDmg();
                addPvpMagDmg = info.getPvpMagDmg();
                addPvpPhysDef = info.getPvpPhysDef();
                addPvpMagDef = info.getPvpMagDef();

                addMReuse = info.getMReuse();
                addAdenaRate = info.getAdenaRate();
                addExpRate = info.getExpRate();
                addDropRate = info.getDropRate();

                addSpiritShotPowerRate = info.getSpiritShotPowerRate();
                addSoulShotPowerRate = info.getSoulShotPowerRate();
            }

            html = html.replace("<?need_item?>", need_item);
            html = html.replace("<?max_rebirth?>", String.valueOf(max_rebirth));
            html = html.replace("<?need_item?>", need_item);
            html = html.replace("<?max_rebirth?>", String.valueOf(max_rebirth));

            html = html.replace("<?count_str_max?>", String.valueOf(maxSTR));
            html = html.replace("<?count_int_max?>", String.valueOf(maxINT));
            html = html.replace("<?count_dex_max?>", String.valueOf(maxDEX));
            html = html.replace("<?count_wit_max?>", String.valueOf(maxWIT));

            html = html.replace("<?count_con_max?>", String.valueOf(maxCON));
            html = html.replace("<?count_men_max?>", String.valueOf(maxMEN));
            html = html.replace("<?count_PvePhysDmg_max?>", String.valueOf(maxPvePhysDmg));
            html = html.replace("<?count_PveMagDmg_max?>", String.valueOf(maxPveMagDmg));

            html = html.replace("<?count_CHA_max?>", String.valueOf(maxCHA));
            html = html.replace("<?count_MaxCP_max?>", String.valueOf(maxMaxCP));
            html = html.replace("<?count_MaxHP_max?>", String.valueOf(maxMaxHP));
            html = html.replace("<?count_MaxMP_max?>", String.valueOf(maxMaxMP));

            html = html.replace("<?count_PhysDmg_max?>", String.valueOf(maxPhysDmg));
            html = html.replace("<?count_MagDmg_max?>", String.valueOf(maxMagDmg));
            html = html.replace("<?count_PhysDef_max?>", String.valueOf(maxPhysDef));
            html = html.replace("<?count_MagDef_max?>", String.valueOf(maxMagDef));

            html = html.replace("<?count_PhysCritDmg_max?>", String.valueOf(maxPhysCritDmg));
            html = html.replace("<?count_MagCritDmg_max?>", String.valueOf(maxMagCritDmg));
            html = html.replace("<?count_PhysCritRate_max?>", String.valueOf(maxPhysCritRate));
            html = html.replace("<?count_MagCritRate_max?>", String.valueOf(maxMagCritRate));

            html = html.replace("<?count_PvpPhysDmg_max?>", String.valueOf(maxPvpPhysDmg));
            html = html.replace("<?count_PvpMagDmg_max?>", String.valueOf(maxPvpMagDmg));
            html = html.replace("<?count_PvpPhysDef_max?>", String.valueOf(maxPvpPhysDef));
            html = html.replace("<?count_PvpMagDef_max?>", String.valueOf(maxPvpMagDef));

            html = html.replace("<?count_MReuse_max?>", String.valueOf(maxMReuse));
            html = html.replace("<?count_AdenaRate_max?>", String.valueOf(maxAdenaRate));
            html = html.replace("<?count_ExpRate_max?>", String.valueOf(maxExpRate));
            html = html.replace("<?count_DropRate_max?>", String.valueOf(maxDropRate));

            html = html.replace("<?count_SpiritShotPowerRate_max?>", String.valueOf(maxSpiritShotPowerRate));
            html = html.replace("<?count_SoulShotPowerRate_max?>", String.valueOf(maxSoulShotPowerRate));


            html = html.replace("<?count_str?>", String.valueOf(player.getVarInt("addSTR", 0)));
            html = html.replace("<?count_int?>", String.valueOf(player.getVarInt("addINT", 0)));
            html = html.replace("<?count_dex?>", String.valueOf(player.getVarInt("addDEX", 0)));
            html = html.replace("<?count_wit?>", String.valueOf(player.getVarInt("addWIT", 0)));

            html = html.replace("<?count_con?>", String.valueOf(player.getVarInt("addCON", 0)));
            html = html.replace("<?count_men?>", String.valueOf(player.getVarInt("addMEN", 0)));
            html = html.replace("<?count_PvePhysDmg?>", String.valueOf(player.getVarInt("addPvePhysDmg", 0)));
            html = html.replace("<?count_PveMagDmg?>", String.valueOf(player.getVarInt("addPveMagDmg", 0)));

            html = html.replace("<?count_CHA?>", String.valueOf(player.getVarInt("addCHA", 0)));
            html = html.replace("<?count_MaxCP?>", String.valueOf(player.getVarInt("addMaxCP", 0)));
            html = html.replace("<?count_MaxHP?>", String.valueOf(player.getVarInt("addMaxHP", 0)));
            html = html.replace("<?count_MaxMP?>", String.valueOf(player.getVarInt("addMaxMP", 0)));

            html = html.replace("<?count_PhysDmg?>", String.valueOf(player.getVarInt("addPhysDmg", 0)));
            html = html.replace("<?count_MagDmg?>", String.valueOf(player.getVarInt("addMagDmg", 0)));
            html = html.replace("<?count_PhysDef?>", String.valueOf(player.getVarInt("addPhysDef", 0)));
            html = html.replace("<?count_MagDef?>", String.valueOf(player.getVarInt("addMagDef", 0)));

            html = html.replace("<?count_PhysCritDmg?>", String.valueOf(player.getVarInt("addPhysCritDmg", 0)));
            html = html.replace("<?count_MagCritDmg?>", String.valueOf(player.getVarInt("addMagCritDmg", 0)));
            html = html.replace("<?count_PhysCritRate?>", String.valueOf(player.getVarInt("addPhysCritRate", 0)));
            html = html.replace("<?count_MagCritRate?>", String.valueOf(player.getVarInt("addMagCritRate", 0)));

            html = html.replace("<?count_PvpPhysDmg?>", String.valueOf(player.getVarInt("addPvpPhysDmg", 0)));
            html = html.replace("<?count_PvpMagDmg?>", String.valueOf(player.getVarInt("addPvpMagDmg", 0)));
            html = html.replace("<?count_PvpPhysDef?>", String.valueOf(player.getVarInt("addPvpPhysDef", 0)));
            html = html.replace("<?count_PvpMagDef?>", String.valueOf(player.getVarInt("addPvpMagDef", 0)));

            html = html.replace("<?count_MReuse?>", String.valueOf(player.getVarInt("addMReuse", 0)));
            html = html.replace("<?count_AdenaRate?>", String.valueOf(player.getVarInt("addAdenaRate", 0)));
            html = html.replace("<?count_ExpRate?>", String.valueOf(player.getVarInt("addExpRate", 0)));
            html = html.replace("<?count_DropRate?>", String.valueOf(player.getVarInt("addDropRate", 0)));

            html = html.replace("<?count_SpiritShotPowerRate?>", String.valueOf(player.getVarInt("addSpiritShotPowerRate", 0)));
            html = html.replace("<?count_SoulShotPowerRate?>", String.valueOf(player.getVarInt("addSoulShotPowerRate", 0)));

            html = html.replace("<?add_str?>", String.valueOf(addSTR));
            html = html.replace("<?add_int?>", String.valueOf(addINT));
            html = html.replace("<?add_dex?>", String.valueOf(addDEX));
            html = html.replace("<?add_wit?>", String.valueOf(addWIT));

            html = html.replace("<?add_con?>", String.valueOf(addCON));
            html = html.replace("<?add_men?>", String.valueOf(addMEN));
            html = html.replace("<?add_PvePhysDmg?>", String.valueOf(addPvePhysDmg));
            html = html.replace("<?add_PveMagDmg?>", String.valueOf(addPveMagDmg));

            html = html.replace("<?add_MaxCHA?>", String.valueOf(addCHA));
            html = html.replace("<?add_MaxCP?>", String.valueOf(addMaxCP));
            html = html.replace("<?add_MaxHP?>", String.valueOf(addMaxHP));
            html = html.replace("<?add_MaxMP?>", String.valueOf(addMaxMP));

            html = html.replace("<?add_PhysDmg?>", String.valueOf(addPhysDmg));
            html = html.replace("<?add_MagDmg?>", String.valueOf(addMagDmg));
            html = html.replace("<?add_PhysDef?>", String.valueOf(addPhysDef));
            html = html.replace("<?add_MagDef?>", String.valueOf(addMagDef));

            html = html.replace("<?add_PhysCritDmg?>", String.valueOf(addPhysCritDmg));
            html = html.replace("<?add_MagCritDmg?>", String.valueOf(addMagCritDmg));
            html = html.replace("<?add_PhysCritRate?>", String.valueOf(addPhysCritRate));
            html = html.replace("<?add_MagCritRate?>", String.valueOf(addMagCritRate));

            html = html.replace("<?add_PvpPhysDmg?>", String.valueOf(addPvpPhysDmg));
            html = html.replace("<?add_PvpMagDmg?>", String.valueOf(addPvpMagDmg));
            html = html.replace("<?add_PvpPhysDef?>", String.valueOf(addPvpPhysDef));
            html = html.replace("<?add_PvpMagDef?>", String.valueOf(addPvpMagDef));

            html = html.replace("<?add_MReuse?>", String.valueOf(addMReuse));
            html = html.replace("<?add_AdenaRate?>", String.valueOf(addAdenaRate));
            html = html.replace("<?add_ExpRate?>", String.valueOf(addExpRate));
            html = html.replace("<?add_DropRate?>", String.valueOf(addDropRate));
            html = html.replace("<?add_SpiritShotPowerRate?>", String.valueOf(addSpiritShotPowerRate));
            html = html.replace("<?add_SoulShotPowerRate?>", String.valueOf(addSoulShotPowerRate));
            html = html.replace("<?reward_item?>", reward_item);
            html = html.replace("<?level_need?>", level_need);
            html = html.replace("<?time_rebirth?>", time_rebirth);
            html = html.replace("<?content?>", content);
        }

        ShowBoardPacket.separateAndSend(html, player);
    }

    public String getLocalizedStatName(Player player, int statId) {
        switch (statId) {
            case 1:
                return player.isLangRus() ? "СИЛ" : "STR";
            case 2:
                return player.isLangRus() ? "ИНТ" : "INT";
            case 3:
                return player.isLangRus() ? "ЛВК" : "DEX";
            case 4:
                return player.isLangRus() ? "МДР" : "WIT";
            case 5:
                return player.isLangRus() ? "ВЫН" : "CON";
            case 6:
                return player.isLangRus() ? "ДУХ" : "MEN";
            case 7:
                return player.isLangRus() ? "ХАР" : "CHA";
            case 8:
                return player.isLangRus() ? "PvE Ф.Атк" : "PvE P.Atk";
            case 9:
                return player.isLangRus() ? "PvE М.Атк" : "PvE М.Atk";
            case 10:
                return player.isLangRus() ? "Макс. HP/CP/MP" : "Max HP/CP/MP";
            case 11:
                return player.isLangRus() ? "Макс. HP" : "Max HP";
            case 12:
                return player.isLangRus() ? "Макс. MP" : "Max MP";
            case 13:
                return player.isLangRus() ? "Физ. Атк" : "P. Atk";
            case 14:
                return player.isLangRus() ? "Mаг. Атк" : "M. Atk";
            case 15:
                return player.isLangRus() ? "Физ. Защ" : "P. Def";
            case 16:
                return player.isLangRus() ? "Маг. Защ" : "M. Def";
            case 17:
                return player.isLangRus() ? "Урон Боссам" : "Boss Dmg";
            case 18:
                return player.isLangRus() ? "ХАР" : "CHA";
            case 19:
                return "addPhysCritRate";
            case 20:
                return "addMagCritRate";
            case 21:
                return player.isLangRus() ? "PvP Атака" : "PvP Damage";
            case 22:
                return "addPvpMagDmg";
            case 23:
                return player.isLangRus() ? "PvP Защита" : "PvP Defence";
            case 24:
                return "addPvpMagDef";
            case 25:
                return "addMReuse";
            case 26:
                return player.isLangRus() ? "Дроп Адены" : "Adena Rate";
            case 27:
                return "EXP";
            case 28:
                return "addDropRate";
            case 29:
                return player.isLangRus() ? "Заряд Души" : "Spirit Shot"; // Перепутано в оригинале
            case 30:
                return player.isLangRus() ? "Заряд Духа" : "Soul Shot"; // Перепутано в оригинале
            default:
                return "Unknown Stat"; // returns "Unknown Stat" if statId is not found
        }
    }

    public int getStatIdByName(String statName) {
        switch (statName) {
            case "addSTR":
                return 1;
            case "addINT":
                return 2;
            case "addDEX":
                return 3;
            case "addWIT":
                return 4;
            case "addCON":
                return 5;
            case "addMEN":
                return 6;
            case "addCHA":
                return 7;
            case "addPvePhysDmg":
                return 8;
            case "addPveMagDmg":
                return 9;
            case "addMaxCP":
                return 10;
            case "addMaxHP":
                return 11;
            case "addMaxMP":
                return 12;
            case "addPhysDmg":
                return 13;
            case "addMagDmg":
                return 14;
            case "addPhysDef":
                return 15;
            case "addMagDef":
                return 16;
            case "addPhysCritDmg":
                return 17;
            case "addMagCritDmg":
                return 18;
            case "addPhysCritRate":
                return 19;
            case "addMagCritRate":
                return 20;
            case "addPvpPhysDmg":
                return 21;
            case "addPvpMagDmg":
                return 22;
            case "addPvpPhysDef":
                return 23;
            case "addPvpMagDef":
                return 24;
            case "addMReuse":
                return 25;
            case "addAdenaRate":
                return 26;
            case "addExpRate":
                return 27;
            case "addDropRate":
                return 28;
            case "addSpiritShotPowerRate":
                return 29;
            case "addSoulShotPowerRate":
                return 30;
            default:
                return -1; // returns -1 if statName is not found
        }
    }

    public String getStatNameById(int statId) {
        switch (statId) {
            case 1:
                return "addSTR";
            case 2:
                return "addINT";
            case 3:
                return "addDEX";
            case 4:
                return "addWIT";
            case 5:
                return "addCON";
            case 6:
                return "addMEN";
            case 7:
                return "addCHA";
            case 8:
                return "addPvePhysDmg";
            case 9:
                return "addPveMagDmg";
            case 10:
                return "addMaxCP";
            case 11:
                return "addMaxHP";
            case 12:
                return "addMaxMP";
            case 13:
                return "addPhysDmg";
            case 14:
                return "addMagDmg";
            case 15:
                return "addPhysDef";
            case 16:
                return "addMagDef";
            case 17:
                return "addPhysCritDmg";
            case 18:
                return "addMagCritDmg";
            case 19:
                return "addPhysCritRate";
            case 20:
                return "addMagCritRate";
            case 21:
                return "addPvpPhysDmg";
            case 22:
                return "addPvpMagDmg";
            case 23:
                return "addPvpPhysDef";
            case 24:
                return "addPvpMagDef";
            case 25:
                return "addMReuse";
            case 26:
                return "addAdenaRate";
            case 27:
                return "addExpRate";
            case 28:
                return "addDropRate";
            case 29:
                return "addSpiritShotPowerRate";
            case 30:
                return "addSoulShotPowerRate";
            default:
                return "Unknown Stat"; // returns "Unknown Stat" if statId is not found
        }
    }

    private void newRebornSystem_delReborn(Player player, int statId) {
        final String statNameById = getStatNameById(statId);
        if (statNameById.equals("Unknown Stat")) {
            player.sendScreenMessage("Error.");
            newRebornSystem_delShow(player);
            return;
        }

        final int statValue = player.getVarInt(statNameById, 0);
        if (statValue <= 0) {
            player.sendScreenMessage(player.isLangRus() ? "Стат не изучен." : "Stat is not learned.");
            newRebornSystem_delShow(player);
            return;
        }

        ConfirmDlgPacket dlg = new ConfirmDlgPacket(SystemMsg.S1, 20000).addString(player.isLangRus()
                ? "Вы уверены, что хотите удалить " + getLocalizedStatName(player, statId) + ", заплатив, 300 Multi Coin?" : "Are you sure you want to delete " + getLocalizedStatName(player, statId) + ", pays, 300 Multi Coin?");
        player.ask(dlg, new OnAnswerListener() {
            @Override
            public void sayYes() {
                newRebornSystem_deleteAndReturnCoins(player, statId);
            }

            @Override
            public void sayNo() {
                newRebornSystem_delShow(player);
            }
        });
    }

    private String buildDeleteButton(Player player, String statName, int statValue) {
        int statId = getStatIdByName(statName);
        if (statId < 0) {
            return "Error";
        }
        final String btnName = player.isLangRus() ? "Удалить" : "Delete";
        return statValue > 0 ? "<font color=\"#ffffff\"><button disabled value=\"" + btnName + "\" action=\"bypass _bbsskill:newRebornSystem_delReborn:" + statId + "\" width=70 height=17 back=\"Multimperia.2fiol_btn_down\" fore=\"Multimperia.2fiol_btn\">" : "<img src=\"L2UI.SquareBlank\" width=70 height=23>";
    }

    private void newRebornSystem_deleteAndReturnCoins(Player player, int statId) {
        try
        {
            // if payment is successfully made
            if (DifferentMethods.getPay(player, 4037, 300, true))
            {
                final int statValue = player.getVarInt(getStatNameById(statId), 0);
                if (statValue > 0) {
                    // remove value
                    player.unsetVar(getStatNameById(statId));
                    // return coins
                    ItemFunctions.addItem(player, 110383, statValue, true);
                }

                // Remove stat funcs from player
                RebornSystem.rebornSkillDelete(player, statId, true);
            }
        }
        catch (Exception e)
        {
            e.printStackTrace();
        }

        // show delete page
        newRebornSystem_delShow(player);
    }

    private void newRebornSystem_delShow(Player player) {

        String html = HtmCache.getInstance().getHtml(Config.BBS_HOME_DIR + "pages/SkillLearn/RebornDelete.htm", player);

        final int addSTR = player.getVarInt("addSTR", 0);
        final int addINT = player.getVarInt("addINT", 0);
        final int addDEX = player.getVarInt("addDEX", 0);
        final int addWIT = player.getVarInt("addWIT", 0);
        final int addCON = player.getVarInt("addCON", 0);
        final int addMEN = player.getVarInt("addMEN", 0);
        final int addCHA = player.getVarInt("addCHA", 0);

        final int addPvePhysDmg = player.getVarInt("addPvePhysDmg", 0);
        final int addPveMagDmg = player.getVarInt("addPveMagDmg", 0);

        final int addMaxCP = player.getVarInt("addMaxCP", 0);
        final int addMaxHP = player.getVarInt("addMaxHP", 0);
        final int addMaxMP = player.getVarInt("addMaxMP", 0);
        final int addPhysDmg = player.getVarInt("addPhysDmg", 0);
        final int addMagDmg = player.getVarInt("addMagDmg", 0);
        final int addPhysDef = player.getVarInt("addPhysDef", 0);
        final int addMagDef = player.getVarInt("addMagDef", 0);
        final int addPhysCritDmg = player.getVarInt("addPhysCritDmg", 0);
        final int addMagCritDmg = player.getVarInt("addMagCritDmg", 0);
        final int addPhysCritRate = player.getVarInt("addPhysCritRate", 0);
        final int addMagCritRate = player.getVarInt("addMagCritRate", 0);
        final int addPvpPhysDmg = player.getVarInt("addPvpPhysDmg", 0);
        final int addPvpMagDmg = player.getVarInt("addPvpMagDmg", 0);
        final int addPvpPhysDef = player.getVarInt("addPvpPhysDef", 0);
        final int addPvpMagDef = player.getVarInt("addPvpMagDef", 0);

        final int addMReuse = player.getVarInt("addMReuse", 0);
        final int addAdenaRate = player.getVarInt("addAdenaRate", 0);
        final int addExpRate = player.getVarInt("addExpRate", 0);
        final int addDropRate = player.getVarInt("addDropRate", 0);

        final int addSpiritShotPowerRate = player.getVarInt("addSpiritShotPowerRate", 0);
        final int addSoulShotPowerRate = player.getVarInt("addSoulShotPowerRate", 0);

        html = html.replace("<?count_str?>", String.valueOf(addSTR));
        html = html.replace("<?count_str_btn?>", buildDeleteButton(player, "addSTR", addSTR));
        html = html.replace("<?count_int?>", String.valueOf(addINT));
        html = html.replace("<?count_int_btn?>", buildDeleteButton(player, "addINT", addINT));
        html = html.replace("<?count_dex?>", String.valueOf(addDEX));
        html = html.replace("<?count_dex_btn?>", buildDeleteButton(player, "addDEX", addDEX));
        html = html.replace("<?count_wit?>", String.valueOf(addWIT));
        html = html.replace("<?count_wit_btn?>", buildDeleteButton(player, "addWIT", addWIT));
        html = html.replace("<?count_con?>", String.valueOf(addCON));
        html = html.replace("<?count_con_btn?>", buildDeleteButton(player, "addCON", addCON));
        html = html.replace("<?count_men?>", String.valueOf(addMEN));
        html = html.replace("<?count_men_btn?>", buildDeleteButton(player, "addMEN", addMEN));
        html = html.replace("<?count_CHA?>", String.valueOf(addCHA));
        html = html.replace("<?count_CHA_btn?>", buildDeleteButton(player, "addCHA", addCHA));

        html = html.replace("<?count_PvePhysDmg?>", String.valueOf(addPvePhysDmg));
        html = html.replace("<?count_PvePhysDmg_btn?>", buildDeleteButton(player, "addPvePhysDmg", addPvePhysDmg));
        html = html.replace("<?count_PveMagDmg?>", String.valueOf(addPveMagDmg));
        html = html.replace("<?count_PveMagDmg_btn?>", buildDeleteButton(player, "addPveMagDmg", addPveMagDmg));

        html = html.replace("<?count_MaxHP?>", String.valueOf(addMaxHP));
        html = html.replace("<?count_MaxHP_btn?>", buildDeleteButton(player, "addMaxHP", addMaxHP));
        html = html.replace("<?count_MaxCP?>", String.valueOf(addMaxCP));
        html = html.replace("<?count_MaxCP_btn?>", buildDeleteButton(player, "addMaxCP", addMaxCP));
        html = html.replace("<?count_MaxMP?>", String.valueOf(addMaxMP));
        html = html.replace("<?count_MaxMP_btn?>", buildDeleteButton(player, "addMaxMP", addMaxMP));

        html = html.replace("<?count_PhysDmg?>", String.valueOf(addPhysDmg));
        html = html.replace("<?count_PhysDmg_btn?>", buildDeleteButton(player, "addPhysDmg", addPhysDmg));
        html = html.replace("<?count_MagDmg?>", String.valueOf(addMagDmg));
        html = html.replace("<?count_MagDmg_btn?>", buildDeleteButton(player, "addMagDmg", addMagDmg));
        html = html.replace("<?count_PhysDef?>", String.valueOf(addPhysDef));
        html = html.replace("<?count_PhysDef_btn?>", buildDeleteButton(player, "addPhysDef", addPhysDef));
        html = html.replace("<?count_MagDef?>", String.valueOf(addMagDef));
        html = html.replace("<?count_MagDef_btn?>", buildDeleteButton(player, "addMagDef", addMagDef));

        html = html.replace("<?count_PhysCritDmg?>", String.valueOf(addPhysCritDmg));
        html = html.replace("<?count_PhysCritDmg_btn?>", buildDeleteButton(player, "addPhysCritDmg", addPhysCritDmg));
        html = html.replace("<?count_MagCritDmg?>", String.valueOf(addMagCritDmg));
        html = html.replace("<?count_MagCritDmg_btn?>", buildDeleteButton(player, "addMagCritDmg", addMagCritDmg));
        html = html.replace("<?count_PhysCritRate?>", String.valueOf(addPhysCritRate));
        html = html.replace("<?count_PhysCritRate_btn?>", buildDeleteButton(player, "addPhysCritRate", addPhysCritRate));

        html = html.replace("<?count_MagCritRate?>", String.valueOf(addMagCritRate));
        html = html.replace("<?count_MagCritRate_btn?>", buildDeleteButton(player, "addMagCritRate", addMagCritRate));
        html = html.replace("<?count_PvpPhysDmg?>", String.valueOf(addPvpPhysDmg));
        html = html.replace("<?count_PvpPhysDmg_btn?>", buildDeleteButton(player, "addPvpPhysDmg", addPvpPhysDmg));
        html = html.replace("<?count_PvpMagDmg?>", String.valueOf(addPvpMagDmg));
        html = html.replace("<?count_PvpMagDmg_btn?>", buildDeleteButton(player, "addPvpMagDmg", addPvpMagDmg));
        html = html.replace("<?count_PvpPhysDef?>", String.valueOf(addPvpPhysDef));
        html = html.replace("<?count_PvpPhysDef_btn?>", buildDeleteButton(player, "addPvpPhysDef", addPvpPhysDef));
        html = html.replace("<?count_PvpMagDef?>", String.valueOf(addPvpMagDef));
        html = html.replace("<?count_PvpMagDef_btn?>", buildDeleteButton(player, "addPvpMagDef", addPvpMagDef));
        html = html.replace("<?count_MReuse?>", String.valueOf(addMReuse));
        html = html.replace("<?count_MReuse_btn?>", buildDeleteButton(player, "addMReuse", addMReuse));
        html = html.replace("<?count_AdenaRate?>", String.valueOf(addAdenaRate));
        html = html.replace("<?count_AdenaRate_btn?>", buildDeleteButton(player, "addAdenaRate", addAdenaRate));
        html = html.replace("<?count_ExpRate?>", String.valueOf(addExpRate));
        html = html.replace("<?count_ExpRate_btn?>", buildDeleteButton(player, "addExpRate", addExpRate));
        html = html.replace("<?count_DropRate?>", String.valueOf(addDropRate));
        html = html.replace("<?count_DropRate_btn?>", buildDeleteButton(player, "addDropRate", addDropRate));

        html = html.replace("<?count_SpiritShotPowerRate?>", String.valueOf(addSpiritShotPowerRate));
        html = html.replace("<?count_SpiritShotPowerRate_btn?>", buildDeleteButton(player, "addSpiritShotPowerRate", addSpiritShotPowerRate));
        html = html.replace("<?count_SoulShotPowerRate?>", String.valueOf(addSoulShotPowerRate));
        html = html.replace("<?count_SoulShotPowerRate_btn?>", buildDeleteButton(player, "addSoulShotPowerRate", addSoulShotPowerRate));;

        ShowBoardPacket.separateAndSend(html, player);
    }

    private void newRebornSystem_info(Player player) {
        String html = HtmCache.getInstance().getHtml(Config.BBS_HOME_DIR + "pages/SkillLearn/newRebornSystem.htm", player);
        int REBORN_COUNT = player.getRebirthCount();
        RebornSystemInfo info = RebornSystemManager.getRebornId(REBORN_COUNT);

        if (info != null) {
            String content = "";
            StringBuilder need_item = new StringBuilder();
            StringBuilder reward_item = new StringBuilder();
            String level_need = "";
            String time_rebirth = "";
            int max_rebirth = 0;

            if (REBORN_COUNT == (info.getRebornId() - 1)) {
                StringBuilder tableRows = new StringBuilder();
                int maxRows = 5; // Максимальное количество строк, которое должно быть всегда
                int currentRows = 0;

                for (String ingredient : info.getNeedItem().split(";")) {
                    currentRows++;
                    String[] ingredients = ingredient.split(",");
                    if (ingredients.length == 3) {
                        int itemId = Integer.parseInt(ingredients[0]);
                        String icon = DifferentMethods.getItemIcon(itemId);
                        String name = DifferentMethods.getItemName(itemId);
                        int countNeeded = Integer.parseInt(ingredients[1]);
                        int enchantLevel = Integer.parseInt(ingredients[2]);
                        long countInInventory = player.getInventory().getCountOf(itemId);
                        String rowColor = countInInventory >= countNeeded ? "3E9E22" : "DD765E";
                        String countInfo = countInInventory + " / " + countNeeded;

                        String row = "<tr>" +
                                "<td height=50 align=right width=150>" + iconImg(icon, 32 ,32) + "</td>" +
                                "<td height=30 align=left><font name=\"hs12\" color=\"" + rowColor + "\">"
                                + "+" + enchantLevel +
                                " " + name +
                                "   |   " + countInfo +
                                "</font></td>" +
                                "</tr>";
                        tableRows.append(row);
                    } else {
                        _log.error("Error: ingredients.length != 3: " + ingredient);
                    }
                }


                while (currentRows < maxRows) {
                    String emptyRow = "<tr>" +
                            "<td height=50 align=right> </td>" +
                            "<td height=30 align=center><font name=\"hs12\"> </font></td>" +
                            "</tr>";
                    tableRows.append(emptyRow);
                    currentRows++;
                }
                String htmlTable = "<table width=755>" + tableRows + "</table>";
                need_item.append(htmlTable);

                for (String reward : info.getReward().split(";")) {
                    if (!reward.isEmpty()) {
                        String[] reward_array = reward.split(",");
                        if (reward_array.length == 3) {
                            String countLang = player.isLangRus() ? "шт." : "pc.";
                            int itemId = Integer.parseInt(reward_array[0]);
                            long itemCount = Long.parseLong(reward_array[1]);
                            int itemEnchant = Integer.parseInt(reward_array[2]);

                            if (itemEnchant > 0) {
                                reward_item.append(" +")
                                        .append(itemEnchant);
                            }
                            reward_item.append(" ")
                                    .append(DifferentMethods.getItemName(itemId))
                                    .append(" ")
                                    .append(itemCount)
                                    .append(" ")
                                    .append(countLang);
                        } else {
                            _log.error("Error reward_array.length != 3: " + reward);
                        }
                    }
                }

                int currentLevel = player.getLevel();
                int requiredLevel = info.getLevelNeed();
                String uLevel = player.isLangRus() ? " Ваш текущий уровень " : " Your level ";
                String needLevel = player.isLangRus() ? " Уровень необходимый для перерождения " : " Level required for reborn ";
                String levelColor = (currentLevel < requiredLevel) ? "DD765E" : "3E9E22";
                level_need = String.format("<font name=\"hs10\" color=\"%s\">%s[%d]</font>  / <font name=\"hs10\" color=\"LEVEL\">%s[%d]</font>",
                        levelColor, uLevel, currentLevel, needLevel, requiredLevel);

                time_rebirth = String.valueOf(info.getResetTimeInBoard(player));
                max_rebirth = RebornSystemManager.getSize();
            }

            html = html.replace("<?need_item?>", need_item.toString());
            html = html.replace("<?max_rebirth?>", String.valueOf(max_rebirth));
            html = html.replace("<?max_rebirth?>", String.valueOf(max_rebirth));

            html = html.replace("<?reward_item?>", reward_item.toString());
            html = html.replace("<?level_need?>", level_need);
            html = html.replace("<?time_rebirth?>", time_rebirth);
            html = html.replace("<?content?>", content);
        }

        ShowBoardPacket.separateAndSend(html, player);
    }

    private void RebornPercentSystem_info(Player player) {
        String html = HtmCache.getInstance().getHtml(Config.BBS_HOME_DIR + "pages/SkillLearn/RebornPercentSystem.htm", player);
        int REBORN_COUNT = player.getRebirthCountPercent();
        RebornPercentSystemInfo info = RebornPercentSystemManager.getRebornId(REBORN_COUNT);

        if (info != null) {
            String content = "";
            StringBuilder need_item = new StringBuilder();
            StringBuilder reward_item = new StringBuilder();
            String level_need = "";
            String time_rebirth = "";
            int max_rebirth = 0;
            int rebirthsPercent = 0;

            if (REBORN_COUNT == (info.getRebornId() - 1)) {
                StringBuilder tableRows = new StringBuilder();
                int maxRows = 5; // Максимальное количество строк, которое должно быть всегда
                int currentRows = 0;

                for (String ingredient : info.getNeedItem().split(";")) {
                    currentRows++;
                    String[] ingredients = ingredient.split(",");
                    if (ingredients.length == 2) {
                        int itemId = Integer.parseInt(ingredients[0]);
                        String icon = DifferentMethods.getItemIcon(itemId);
                        String name = DifferentMethods.getItemName(itemId);
                        int countNeeded = Integer.parseInt(ingredients[1]);
                        long countInInventory = player.getInventory().getCountOf(itemId);
                        String rowColor = countInInventory >= countNeeded ? "3E9E22" : "DD765E";
                        String countInfo = countInInventory + " / " + countNeeded;
                        String row = "<tr>" +
                                "<td height=50 align=right width=150>" + iconImg(icon, 32 ,32) + "</td>" +
                                "<td height=30 align=left><font name=\"hs12\" color=\"" + rowColor + "\">" + name + "   |   " + countInfo + "</font></td>" +
                                "</tr>";
                        tableRows.append(row);
                    } else {
                        _log.error("Error: reward_array.length != 2");
                    }
                }

                while (currentRows < maxRows) {
                    String emptyRow = "<tr>" +
                            "<td height=50 align=right> </td>" +
                            "<td height=30 align=center><font name=\"hs12\"> </font></td>" +
                            "</tr>";
                    tableRows.append(emptyRow);
                    currentRows++;
                }
                String htmlTable = "<table width=755>" + tableRows + "</table>";
                need_item.append(htmlTable);

                for (String reward : info.getReward().split(";")) {
                    if (!reward.isEmpty()) {
                        String[] reward_array = reward.split(",");
                        if (reward_array.length == 2) {
                            String countLang = player.isLangRus() ? "шт. " : "pc. ";
                            reward_item.append(DifferentMethods.getItemName(Integer.parseInt(reward_array[0])))
                                    .append(" ")
                                    .append(Long.parseLong(reward_array[1]))
                                    .append(" ")
                                    .append(countLang);
                        } else {
                            _log.error("Error reward_array.length != 2");
                        }
                    }
                }

                int currentLevel = player.getLevel();
                int requiredLevel = info.getLevelNeed();
                String uLevel = player.isLangRus() ? " Ваш текущий уровень " : " Your level ";
                String needLevel = player.isLangRus() ? " Уровень необходимый для перерождения " : " Level required for reborn ";
                String levelColor = (currentLevel < requiredLevel) ? "DD765E" : "3E9E22";
                level_need = String.format("<font name=\"hs10\" color=\"%s\">%s[%d]</font>  / <font name=\"hs10\" color=\"LEVEL\">%s[%d]</font>",
                        levelColor, uLevel, currentLevel, needLevel, requiredLevel);

                time_rebirth = String.valueOf(info.getResetTimeInBoard(player));
                max_rebirth = RebornPercentSystemManager.getSize();
                rebirthsPercent = player.getRebirthCountPercent();

            }

            html = html.replace("<?need_item?>", need_item.toString());
            html = html.replace("<?rebirthsPercent?>", String.valueOf(rebirthsPercent));

            html = html.replace("<?max_rebirth?>", String.valueOf(max_rebirth));

            html = html.replace("<?reward_item?>", reward_item.toString());
            html = html.replace("<?level_need?>", level_need);
            html = html.replace("<?time_rebirth?>", time_rebirth);
            html = html.replace("<?content?>", content);
        }

        ShowBoardPacket.separateAndSend(html, player);
    }

    private void RebornDivineSystem_info(Player player) {
        String html = HtmCache.getInstance().getHtml(Config.BBS_HOME_DIR + "pages/SkillLearn/RebornDivineSystem.htm", player);
        int REBORN_COUNT = player.getRebirthCountDivine();
        RebornDivineSystemInfo info = RebornDivineSystemManager.getRebornId(REBORN_COUNT);

        if (info != null) {
            String content = "";
            StringBuilder need_item = new StringBuilder();
            StringBuilder reward_item = new StringBuilder();
            String level_need = "";
            String time_rebirth = "";
            int max_rebirth = 0;
            int rebirthsDivine = 0;

            if (REBORN_COUNT == (info.getRebornId() - 1)) {
                StringBuilder tableRows = new StringBuilder();
                int maxRows = 5;
                int currentRows = 0;

                for (String ingredient : info.getNeedItem().split(";")) {
                    currentRows++;
                    String[] ingredients = ingredient.split(",");
                    if (ingredients.length == 2) {
                        int itemId = Integer.parseInt(ingredients[0]);
                        String icon = DifferentMethods.getItemIcon(itemId);
                        String name = DifferentMethods.getItemName(itemId);
                        int countNeeded = Integer.parseInt(ingredients[1]);
                        long countInInventory = player.getInventory().getCountOf(itemId);
                        String rowColor = countInInventory >= countNeeded ? "3E9E22" : "DD765E";
                        String countInfo = countInInventory + " / " + countNeeded;
                        String row = "<tr>" +
                                "<td height=50 align=right width=150>" + iconImg(icon, 32 ,32) + "</td>" +
                                "<td height=30 align=left><font name=\"hs12\" color=\"" + rowColor + "\">" + name + "   |   " + countInfo + "</font></td>" +
                                "</tr>";
                        tableRows.append(row);
                    } else {
                        _log.error("Error: reward_array.length != 2");
                    }
                }

                while (currentRows < maxRows) {
                    String emptyRow = "<tr>" +
                            "<td height=50 align=right> </td>" +
                            "<td height=30 align=center><font name=\"hs12\"> </font></td>" +
                            "</tr>";
                    tableRows.append(emptyRow);
                    currentRows++;
                }
                String htmlTable = "<table width=755>" + tableRows + "</table>";
                need_item.append(htmlTable);

                for (String reward : info.getReward().split(";")) {
                    if (!reward.isEmpty()) {
                        String[] reward_array = reward.split(",");
                        if (reward_array.length == 2) {
                            String countLang = player.isLangRus() ? "шт. " : "pc. ";
                            reward_item.append(DifferentMethods.getItemName(Integer.parseInt(reward_array[0])))
                                    .append(" ")
                                    .append(Long.parseLong(reward_array[1]))
                                    .append(" ")
                                    .append(countLang);
                        } else {
                            _log.error("Error reward_array.length != 2");
                        }
                    }
                }

                int currentLevel = player.getLevel();
                int requiredLevel = info.getLevelNeed();
                String uLevel = player.isLangRus() ? " Ваш текущий уровень " : " Your level ";
                String needLevel = player.isLangRus() ? " Уровень необходимый для Божественного перерождения " : " Level required for Divine Reborn ";
                String levelColor = (currentLevel < requiredLevel) ? "DD765E" : "3E9E22";
                level_need = String.format("<font name=\"hs10\" color=\"%s\">%s[%d]</font>  / <font name=\"hs10\" color=\"LEVEL\">%s[%d]</font>",
                        levelColor, uLevel, currentLevel, needLevel, requiredLevel);

                time_rebirth = String.valueOf(info.getResetTimeInBoard(player));
                max_rebirth = RebornDivineSystemManager.getSize();
                rebirthsDivine = player.getRebirthCountDivine();

            }

            html = html.replace("<?need_item?>", need_item.toString());
            html = html.replace("<?rebirthsDivine?>", String.valueOf(rebirthsDivine));

            html = html.replace("<?max_rebirth?>", String.valueOf(max_rebirth));

            html = html.replace("<?reward_item?>", reward_item.toString());
            html = html.replace("<?level_need?>", level_need);
            html = html.replace("<?time_rebirth?>", time_rebirth);
            html = html.replace("<?content?>", content);
        }

        ShowBoardPacket.separateAndSend(html, player);
    }

    /*private void RebornSystem_info_Reborn(Player player){
        String html = HtmCache.getInstance().getHtml(Config.BBS_HOME_DIR + "pages/SkillLearn/Reborn.htm", player);
        int REBORN_COUNT = player.getVarInt("rebornCount", 1);
        RebornSystemInfo info = RebornSystemManager.getRebornId(REBORN_COUNT);

        show(player);
    }

    public void show(Player player)
    {

        String out = "";

        out += "<html><body>Расширение инвентаря";
        out += "<br><br><table>";
        out += "<tr><td>Текущий размер:</td><td>" + 111 + "</td></tr>";
        out += "<tr><td>Максимальный размер:</td><td>" + 222 + "</td></tr>";
        out += "<tr><td>Стоимость слота:</td><td>" + 333 + " " + 444 + "</td></tr>";
        out += "</table><br><br>";
        out += "<button width=100 height=15 back=\"L2UI_CT1.Button_DF_Down\" fore=\"L2UI_CT1.Button_DF\" action=\"bypass -h htmbypass_services.ExpandInventory:get\" value=\"Расширить\">";
        out += "</body></html>";

        Functions.show(out, player);
    }*/

    private void showF(Player player, int skillId, int skillLevel, long cost, int classId, int page) {
        String html = HtmCache.getInstance().getHtml(Config.BBS_HOME_DIR + "pages/SkillLearn/index.htm", player);
        String button = null;
        String template = HtmCache.getInstance().getHtml(Config.BBS_HOME_DIR + "pages/SkillLearn/showFskill.htm", player);
        String block = null;
        Skill sk = SkillHolder.getInstance().getSkill(skillId, skillLevel);
        if (sk != null) {
            String skillDesc = SkillDescHolder.getInstance().getSkillDesc(player, sk.getId(), sk.getLevel());
            if (skillDesc == null) {
                _log.info("[CBSkillLearn]: Description is missing for skill[" + sk.getId() + ", " + sk.getLevel() + "]");
                skillDesc = "";
            }
            block = template;
            block = block.replace("{name}", sk.getName(player));
            block = block.replace("{icon}", sk.getIcon());
            block = block.replace("{descriptions}", skillDesc);
            block = block.replace("{level}", String.valueOf(sk.getLevel()));
            block = block.replace("{sp}", buildSPCost(player, sk, AcquireType.MULTICLASS));
            block = block.replace("{dop}", buildAdditionalItems(player, sk, AcquireType.MULTICLASS));
            button = button + block;
        }
        html = html.replace("<?body?>", button);
        html = html.replace("<?pages?>", "<button value=\"Изучить умение\" action=\"bypass _bbsskill:learn-" + sk.getId() + "-" + sk.getLevel() + "-" + cost + "-" + classId + "-" + page + "\"width=177 height=42 back=\"multimperia.shop_btn_green_down\" fore=\"multimperia.shop_btn_green\">");
        html = html.replace("{link}", "bypass _bbsskill:show-" + page + "-" + classId);
        html = html.replace("{price}", "");
        ShowBoardPacket.separateAndSend(html, player);
    }

    private void showFCustom(Player player, int skillId, int skillLevel, long cost, int page) {
        String html = HtmCache.getInstance().getHtml(Config.BBS_HOME_DIR + "pages/SkillLearn/index.htm", player);
        String button = null;
        String template = HtmCache.getInstance().getHtml(Config.BBS_HOME_DIR + "pages/SkillLearn/showFCskill.htm", player);
        String block = null;
        Skill sk = SkillHolder.getInstance().getSkill(skillId, skillLevel);
        if (sk != null) {
            boolean individual = false;
            if (ArrayUtils.contains(skills_id, sk.getId()))
                individual = true;
            block = template;
            block = block.replace("{name}", sk.getName(player));
            block = block.replace("{icon}", sk.getIcon());
            block = block.replace("{descriptions}", SkillDescHolder.getInstance().getSkillDesc(player, sk.getId(), sk.getLevel()));
            block = block.replace("{level}", String.valueOf(sk.getLevel()));
            block = block.replace("{dop}", buildAdditionalItems(player, sk, AcquireType.CUSTOM));
            block = block.replace("{price}", "");
            block = block.replace("{sp}", String.valueOf(cost));
            button = button + block;

        }
        html = html.replace("<?body?>", button);
        html = html.replace("<?pages?>", "<button value=\"Изучить скил\" action=\"bypass _bbsskill:learnC-" + sk.getId() + "-" + sk.getLevel() + "-" + cost + "-" + page + "\"width=177 height=42 back=\"multimperia.shop_btn_green_down\" fore=\"multimperia.shop_btn_green\">");
        html = html.replace("{link}", "bypass _bbsskill:showcp-" + page);
        html = html.replace("{price}", "");
        ShowBoardPacket.separateAndSend(html, player);
    }

    private void showFCustom1(Player player, int skillId, int skillLevel, long cost, int page) {
        String html = HtmCache.getInstance().getHtml(Config.BBS_HOME_DIR + "pages/SkillLearn/index.htm", player);
        String button = null;
        String template = HtmCache.getInstance().getHtml(Config.BBS_HOME_DIR + "pages/SkillLearn/showFCskill.htm", player);
        String block = null;
        Skill sk = SkillHolder.getInstance().getSkill(skillId, skillLevel);
        if (sk != null) {
            boolean individual = false;
            if (ArrayUtils.contains(skills_id, sk.getId()))
                individual = true;
            block = template;
            block = block.replace("{name}", sk.getName(player));
            block = block.replace("{icon}", sk.getIcon());
            block = block.replace("{descriptions}", SkillDescHolder.getInstance().getSkillDesc(player, sk.getId(), sk.getLevel()));
            block = block.replace("{level}", String.valueOf(sk.getLevel()));
            block = block.replace("{dop}", buildAdditionalItems(player, sk, AcquireType.CUSTOM1));
            block = block.replace("{price}", "");
            block = block.replace("{sp}", String.valueOf(cost));
            button = button + block;

        }
        html = html.replace("<?body?>", button);
        html = html.replace("<?pages?>", "<button value=\"Изучить скил\" action=\"bypass _bbsskill:learnC1-" + sk.getId() + "-" + sk.getLevel() + "-" + cost + "-" + page + "\"width=177 height=42 back=\"multimperia.shop_btn_green_down\" fore=\"multimperia.shop_btn_green\">");
        html = html.replace("{link}", "bypass _bbsskill:showcp1-" + page);
        html = html.replace("{price}", "");
        ShowBoardPacket.separateAndSend(html, player);
    }

    private void showSkill(Player player, int page, int classId) {
        final ClassLevel classLevel = ClassId.values()[classId].getClassLevel();
        final List<SkillLearn> filteredSkills = SkillAcquireHolder.getInstance().getAvailableSkillsM(classId, player).stream().filter(skillLearn -> skillLearn.getClassLevel() == classLevel).collect(Collectors.toList());
        String html = HtmCache.getInstance().getHtml(Config.BBS_HOME_DIR + "pages/SkillLearn/index.htm", player);
        StringBuilder body = new StringBuilder();
        String template = HtmCache.getInstance().getHtml(Config.BBS_HOME_DIR + "pages/SkillLearn/showskill.htm", player);
        String block = null;
        List<Skill> temp = new ArrayList<>();

        for (SkillLearn s : filteredSkills) {
            Skill sk = SkillHolder.getInstance().getSkill(s.getId(), s.getLevel());
            if (sk == null) {
                _log.info("no skill found: " + s.getId() + " " + s.getLevel() + "...");
                continue;
            }
            if (ArrayUtils.contains(IGNORE_SKILLS, sk.getId()))
                continue;
            temp.add(sk);
        }
        if (temp.size() <= SHOW_SKILL_PAGE)
            page = 1;

        int perPage = SHOW_SKILL_PAGE;
        int maxSkills = temp.size();
        int maxPages = (int) Math.ceil((double) maxSkills / perPage);

        if (page > maxPages)
            page = maxPages;

        if (page < 1)
            page = 1;

        int start = (page - 1) * perPage;
        int end = Math.min(start + perPage, maxSkills);


        // start row
        body.append("<tr>");
        for (int i = start; i < end; i++) {
            boolean endsWithTR = body.toString().endsWith("</tr>");

            if (endsWithTR) {
                // open new row
                body.append("<tr>");
            }

            Skill sk = temp.get(i);
            if (sk == null) {
                body.append("<td></td>");
            } else {
                block = template;
                block = block.replace("{name}", sk.getName(player));
                block = block.replace("{icon}", sk.getIcon());
                block = block.replace("{level}", String.valueOf(sk.getLevel()));
                block = block.replace("{descript}", "bypass _bbsskill:showF-" + sk.getId() + "-" + sk.getLevel() + "-" + Multiproff.getCost(player, sk, SP_NORMAL, AcquireType.MULTICLASS) + "-" + classId + "-" + page);
                body.append(block);
            }

            boolean lastElement = i == end - 1;
            boolean isEvenNumber = i % 2 == 0;
            boolean endsWithTD = body.toString().endsWith("</td>");
            endsWithTR = body.toString().endsWith("</tr>");
            if (lastElement && endsWithTD) {
                body.append("<td></td>");
            }
            if (!endsWithTR && (lastElement || !isEvenNumber)) {
                body.append("</tr>");
            }
        }

        StringBuilder pg = new StringBuilder();
        // Если страниц больше 1, то показываем кнопки навигации
        if (maxSkills > perPage) {
            pg.append("<center><table width=25 border=0><tr>");
            // Проходя по всем страницам, формируем кнопки навигации
            for (int current = 1; current <= maxPages; current++) {
                if (page == current) {
                    pg.append("<td width=25 align=center><button value=\"[").append(current).append("]\" width=28 height=25 back=\"L2UI_EPIC.NewButton_Blue\" fore=\"L2UI_EPIC.NewButton_Blue\"></td>");
                } else {
                    pg.append("<td width=25 align=center><button value=\"").append(current).append("\" action=\"bypass _bbsskill:show-").append(current).append("-").append(classId).append("\" width=28 height=25 back=\"L2UI_EPIC.NewButton_Blue\" fore=\"L2UI_EPIC.NewButton_Blue\"></td>");
                }
            }
            pg.append("</tr></table></center>");
        }

        html = html.replace("<?body?>", block == null ? "Все скилы уже выучены" : body.toString());
        html = html.replace("<?pages?>", pg.toString());
        html = html.replace("{link}", "bypass _bbshome");
        html = html.replace("{price}", "");
        ShowBoardPacket.separateAndSend(html, player);
    }

    private void showCustom(Player player, int page) {
        final Collection<SkillLearn> skills = SkillAcquireHolder.getInstance().getAvailableSkillsCustom(player, AcquireType.CUSTOM);
        String html = HtmCache.getInstance().getHtml(Config.BBS_HOME_DIR + "pages/SkillLearn/index.htm", player);
        String button = null;
        String template = HtmCache.getInstance().getHtml(Config.BBS_HOME_DIR + "pages/SkillLearn/showCskill.htm", player);
        String block = null;
        List<Skill> temp = new ArrayList<>();

        for (SkillLearn s : skills) {
            Skill sk = SkillHolder.getInstance().getSkill(s.getId(), s.getLevel());
            temp.add(sk);
        }
        if (temp.size() <= SHOW_SKILL_PAGE)
            page = 1;

        for (int i = page * SHOW_SKILL_PAGE - SHOW_SKILL_PAGE; i < page * SHOW_SKILL_PAGE; i++) {
            if (i >= temp.size())
                break;

            Skill sk = temp.get(i);

            if (sk != null) {
                boolean individual = false;
                if (ArrayUtils.contains(skills_idCustom, sk.getId()))
                    individual = true;

                block = template;
                block = block.replace("{name}", sk.getName());
                block = block.replace("{icon}", sk.getIcon());
                block = block.replace("{level}", String.valueOf(sk.getLevel()));
                block = block.replace("{sp}", Multiproff.getCostDop(player, sk, SP_CUSTOM, AcquireType.CUSTOM) != 0 ? (Multiproff.getCostDop(player, sk, SP_CUSTOM, AcquireType.CUSTOM)) + " SP" : "");
                block = block.replace("{dop}", buildAdditionalItems(player, sk, AcquireType.CUSTOM));
                block = block.replace("{learn}", "bypass _bbsskill:learnC-" + sk.getId() + "-" + sk.getLevel() + "-" + Multiproff.getCost(player, sk, SP_CUSTOM, AcquireType.CUSTOM) + "-" + page);
                block = block.replace("{descript}", "bypass _bbsskill:showFcustom-" + sk.getId() + "-" + sk.getLevel() + "-" + Multiproff.getCost(player, sk, SP_CUSTOM, AcquireType.CUSTOM) + "-" + page);
                block = block.replace("{price}", (individual ? ItemCountIndiv : ItemCountCustom) == 0 ? "" : (individual ? ItemCountIndiv : ItemCountCustom) + " " + DifferentMethods.getItemName(individual ? ItemIdIndiv : ItemIdCustom));
                block = block.replace("{id_skill}", player.isGM() ? "ID: " + sk.getId() + " " : "");
                //block = block.replace("{and}", Multiproff.getCost(player, sk, SP_CUSTOM, AcquireType.CUSTOM) == 0 || (ItemCountIndiv == 0 && ItemCountCustom == 0) ? " " : " и ");
                button = button + block;

            }
        }

        StringBuilder pg = new StringBuilder();

        double skillcount = skills.size();
        double MaxItemPerPage = SHOW_SKILL_PAGE;

        if (skillcount > MaxItemPerPage) {
            double MaxPages = Math.ceil(skillcount / MaxItemPerPage);

            pg.append("<center><table width=25 border=0><tr>");
            int ButtonInLine = 1;
            for (int current = 1; current <= MaxPages; current++) {
                if (page == current)
                    pg.append("<td width=25 align=center><button value=\"[").append(current).append("]\" width=28 height=25 back=\"L2UI_EPIC.NewButton_Blue\" fore=\"L2UI_EPIC.NewButton_Blue\"></td>");
                else
                    pg.append("<td width=25 align=center><button value=\"").append(current).append("\" action=\"bypass _bbsskill:showcp-").append(current).append("\" width=28 height=25 back=\"L2UI_EPIC.NewButton_Blue\" fore=\"L2UI_EPIC.NewButton_Blue\"></td>");

                if (ButtonInLine == 18) {
                    pg.append("</tr><tr>");
                    ButtonInLine = 0;
                }
                ButtonInLine++;
            }
            pg.append("</tr></table></center>");
        }

        html = html.replace("<?body?>", button == null ? "Все скилы уже выучены" : button);
        html = html.replace("<?pages?>", pg.toString());
        html = html.replace("{link}", "bypass _bbspage:SkillLearn/dopskills");
        html = html.replace("{price}", "");
        ShowBoardPacket.separateAndSend(html, player);
    }

    private void showCustom1(Player player, int page) {
        final Collection<SkillLearn> skills = SkillAcquireHolder.getInstance().getAvailableSkillsCustom1(player, AcquireType.CUSTOM1);
        String html = HtmCache.getInstance().getHtml(Config.BBS_HOME_DIR + "pages/SkillLearn/index.htm", player);
        String button = null;
        String template = HtmCache.getInstance().getHtml(Config.BBS_HOME_DIR + "pages/SkillLearn/showC1skill.htm", player);
        String block = null;
        List<Skill> temp = new ArrayList<>();

        for (SkillLearn s : skills) {
            Skill sk = SkillHolder.getInstance().getSkill(s.getId(), s.getLevel());
            temp.add(sk);
        }
        if (temp.size() <= SHOW_SKILL_PAGE)
            page = 1;

        for (int i = page * SHOW_SKILL_PAGE - SHOW_SKILL_PAGE; i < page * SHOW_SKILL_PAGE; i++) {
            if (i >= temp.size())
                break;

            Skill sk = temp.get(i);

            if (sk != null) {
                boolean individual = false;
                if (ArrayUtils.contains(skills_idCustom, sk.getId()))
                    individual = true;

                block = template;
                block = block.replace("{name}", sk.getName());
                block = block.replace("{icon}", sk.getIcon());
                block = block.replace("{level}", String.valueOf(sk.getLevel()));
                block = block.replace("{sp}", String.valueOf(Multiproff.getCost(player, sk, SP_CUSTOM1, AcquireType.CUSTOM1)));
                block = block.replace("{dop}", buildAdditionalItems(player, sk, AcquireType.CUSTOM1));
                block = block.replace("{learn}", "bypass _bbsskill:learnC1-" + sk.getId() + "-" + sk.getLevel() + "-" + Multiproff.getCost(player, sk, SP_CUSTOM1, AcquireType.CUSTOM1) + "-" + page);
                block = block.replace("{descript}", "bypass _bbsskill:showFcustom1-" + sk.getId() + "-" + sk.getLevel() + "-" + Multiproff.getCost(player, sk, SP_CUSTOM1, AcquireType.CUSTOM1) + "-" + page);
                block = block.replace("{price}", "");
                button = button + block;

            }
        }

        StringBuilder pg = new StringBuilder();

        double skillcount = skills.size();
        double MaxItemPerPage = SHOW_SKILL_PAGE;

        if (skillcount > MaxItemPerPage) {
            double MaxPages = Math.ceil(skillcount / MaxItemPerPage);

            pg.append("<center><table width=25 border=0><tr>");
            int ButtonInLine = 1;
            for (int current = 1; current <= MaxPages; current++) {
                if (page == current)
                    pg.append("<td width=25 align=center><button value=\"[").append(current).append("]\" width=28 height=25 back=\"L2UI_EPIC.NewButton_Blue\" fore=\"L2UI_EPIC.NewButton_Blue\"></td>");
                else
                    pg.append("<td width=25 align=center><button value=\"").append(current).append("\" action=\"bypass _bbsskill:showcp1-").append(current).append("\" width=28 height=25 back=\"L2UI_EPIC.NewButton_Blue\" fore=\"L2UI_EPIC.NewButton_Blue\"></td>");

                if (ButtonInLine == 18) {
                    pg.append("</tr><tr>");
                    ButtonInLine = 0;
                }
                ButtonInLine++;
            }
            pg.append("</tr></table></center>");
        }

        html = html.replace("<?body?>", button == null ? "Все скилы уже выучены" : button);
        html = html.replace("<?pages?>", pg.toString());
        html = html.replace("{link}", "bypass _bbspage:SkillLearn/dopskills");
        html = html.replace("{price}", "");
        ShowBoardPacket.separateAndSend(html, player);
    }

    private void showCertification(Player player, int page) {
        final Collection<SkillLearn> skills = SkillAcquireHolder.getInstance().getAvailableSkills(player, AcquireType.CERTIFICATION);
        String html = HtmCache.getInstance().getHtml(Config.BBS_HOME_DIR + "pages/SkillLearn/index.htm", player);
        String button = null;
        String template = HtmCache.getInstance().getHtml(Config.BBS_HOME_DIR + "pages/SkillLearn/showCertification.htm", player);
        String block = null;
        List<SkillEntry> temp = new ArrayList<>();

        for (SkillLearn s : skills) {

            SkillEntry sk = SkillEntry.makeSkillEntry(SkillEntryType.NONE, s.getId(), s.getLevel());
            temp.add(sk);
        }
        if (temp.size() <= SHOW_SKILL_PAGE)
            page = 1;

        for (int i = page * SHOW_SKILL_PAGE - SHOW_SKILL_PAGE; i < page * SHOW_SKILL_PAGE; i++) {
            if (i >= temp.size())
                break;

            SkillEntry sk = temp.get(i);

            if (sk != null) {
                boolean individual = false;
                if (ArrayUtils.contains(skills_idCustom, sk.getId()))
                    individual = true;

                block = template;
                block = block.replace("{name}", sk.getName());
                block = block.replace("{icon}", sk.getTemplate().getIcon());
                block = block.replace("{level}", String.valueOf(sk.getLevel()));
                block = block.replace("{sp}", Multiproff.getCost(player, sk.getTemplate(), SP_CUSTOM, AcquireType.CERTIFICATION) != 0 ? (Multiproff.getCost(player, sk.getTemplate(), SP_CUSTOM, AcquireType.CERTIFICATION)) + " SP" : "");
                block = block.replace("{dop}", buildAdditionalItems(player, sk, AcquireType.CERTIFICATION));
                block = block.replace("{learn}", "bypass _bbsskill:learnC-" + sk.getId() + "-" + sk.getLevel() + "-" + Multiproff.getCost(player, sk.getTemplate(), SP_CUSTOM, AcquireType.CERTIFICATION) + "-" + page);
                block = block.replace("{descript}", "bypass _bbsskill:showFcustom-" + sk.getId() + "-" + sk.getLevel() + "-" + Multiproff.getCost(player, sk.getTemplate(), SP_CUSTOM, AcquireType.CERTIFICATION) + "-" + page);
                block = block.replace("{price}", "");
                block = block.replace("{id_skill}", player.isGM() ? "ID: " + sk.getId() + " " : "");
                //block = block.replace("{and}", Multiproff.getCost(player, sk, SP_CUSTOM, AcquireType.CUSTOM) == 0 || (ItemCountIndiv == 0 && ItemCountCustom == 0) ? " " : " и ");
                button = button + block;

            }
        }

        StringBuilder pg = new StringBuilder();

        double skillcount = skills.size();
        double MaxItemPerPage = SHOW_SKILL_PAGE;

        if (skillcount > MaxItemPerPage) {
            double MaxPages = Math.ceil(skillcount / MaxItemPerPage);

            pg.append("<center><table width=25 border=0><tr>");
            int ButtonInLine = 1;
            for (int current = 1; current <= MaxPages; current++) {
                if (page == current)
                    pg.append("<td width=25 align=center><button value=\"[").append(current).append("]\" width=28 height=25 back=\"L2UI_EPIC.NewButton_Blue\" fore=\"L2UI_EPIC.NewButton_Blue\"></td>");
                else
                    pg.append("<td width=25 align=center><button value=\"").append(current).append("\" action=\"bypass _bbsskill:showCertifPage-").append(current).append("\" width=28 height=25 back=\"L2UI_EPIC.NewButton_Blue\" fore=\"L2UI_EPIC.NewButton_Blue\"></td>");

                if (ButtonInLine == 18) {
                    pg.append("</tr><tr>");
                    ButtonInLine = 0;
                }
                ButtonInLine++;
            }
            pg.append("</tr></table></center>");
        }

        html = html.replace("<?body?>", button == null ? "Все скилы уже выучены" : button);
        html = html.replace("<?pages?>", pg.toString());
        html = html.replace("{link}", "bypass _bbspage:SkillLearn/dopskills");
        html = html.replace("{price}", "");
        ShowBoardPacket.separateAndSend(html, player);
    }

    private String buildAdditionalItems(Player player, SkillEntry sk, AcquireType type) {
        final StringBuilder sb = new StringBuilder();
        final SkillLearn skillLearn = SkillAcquireHolder.getInstance().getSkillLearn(player, sk.getId(), sk.getLevel(), type);

        if (skillLearn != null) {
            if (skillLearn.getItemId() > 0) {
                sb.append(DifferentMethods.getItemName(skillLearn.getItemId())).append(" ").append(Util.formatAdena(skillLearn.getItemCount()));

                if (skillLearn.getAdditionalRequiredItems().size() > 0) {
                    sb.append(", ");
                }
            }

            List<ItemData> additionalRequiredItems = skillLearn.getAdditionalRequiredItems();
            for (int i = 0; i < additionalRequiredItems.size(); i++) {
                final ItemData additionalRequiredItem = additionalRequiredItems.get(i);
                final boolean isLast = i == (additionalRequiredItems.size() - 1);
                sb.append(DifferentMethods.getItemName(additionalRequiredItem.getId())).append(" ").append(Util.formatAdena(additionalRequiredItem.getCount())).append(isLast ? "" : ", ");
            }
        }

        return sb.toString();
    }

    private String buildSPCost(Player player, Skill sk, AcquireType type) {
        double spCost = Multiproff.getCost(player, sk, SP_NORMAL, type);
        if (spCost > 0) {
            String template = SP_TEMPLATE;
            template = template.replace("<?sp?>", Util.formatAdena((long) spCost));
            template = template.replace("<?sp_availability?>", buildSPAvailability(player, (long) spCost));
            return template;
        } else {
            return "";
        }
    }

    private String buildAdditionalItems(Player player, Skill sk, AcquireType type) {
        final StringBuilder sb = new StringBuilder();
        final SkillLearn skillLearn;

        if (type.equals(AcquireType.MULTICLASS)) {
            skillLearn = SkillAcquireHolder.getInstance().getSkillLearnM(player, sk.getId(), sk.getLevel(), type);
        } else {
            skillLearn = SkillAcquireHolder.getInstance().getSkillLearn(player, sk.getId(), sk.getLevel(), type);
        }

        if (skillLearn != null) {
            if (skillLearn.getItemId() > 0) {
                ItemTemplate template = ItemHolder.getInstance().getTemplate(skillLearn.getItemId());
                sb.append(ITEM_TEMPLATE
                        .replaceAll("<\\?itemId\\?>", String.valueOf(skillLearn.getItemId()))
                        .replaceAll("<\\?itemIcon\\?>", template == null ? "" : template.getIcon())
                        .replace("<?itemCount?>", Util.formatAdena(skillLearn.getItemCount()))
                        .replace("<?availability>?", buildItemAvailability(player, skillLearn.getItemId(), skillLearn.getItemCount()))
                );
            }

            List<ItemData> additionalRequiredItems = skillLearn.getAdditionalRequiredItems();
            for (ItemData addItem : additionalRequiredItems) {
                ItemTemplate template = ItemHolder.getInstance().getTemplate(addItem.getId());
                sb.append(ITEM_TEMPLATE
                        .replaceAll("<\\?itemId\\?>", String.valueOf(addItem.getId()))
                        .replaceAll("<\\?itemIcon\\?>", template == null ? "" : template.getIcon())
                        .replace("<?itemCount?>", Util.formatAdena(addItem.getCount()))
                        .replace("<?availability>?", buildItemAvailability(player, addItem.getId(), addItem.getCount()))
                );
            }
        }


        return sb.toString();
    }

    private String buildSPAvailability(Player player, long requiredSP) {
        long availableSP = player.getSp();
        long remainingSP = availableSP - requiredSP;
        if (remainingSP < 0) {
            return "<font color=\"FF0000\">Недостаточно SP</font>";
        } else {
            return "<font color=\"00FF00\">Достаточно SP</font>";
        }
    }

    private String buildItemAvailability(Player player, int itemId, long itemCount) {
        long availableItemCnt = player.getInventory().getCountOf(itemId);
        long remainingItemCnt = itemCount - availableItemCnt;
        if (remainingItemCnt > 0) {
            if (itemId == 57) {
                return "<font color=\"FF0000\">Недостаточно &#" + itemId + ";</font>";
            }
            if (availableItemCnt == 0) {
                return "<font color=\"FF0000\">Нет необходимых предметов</font>";
            }
            return "<font color=\"FF0000\">В наличии " + Util.formatAdena(availableItemCnt) + " шт. / " + Util.formatAdena(itemCount) + " шт.</font>";
        } else {
            return "<font color=\"00FF00\">В наличии</font>";
        }
    }

    public void learn(Player player, int skillId, int level, int classId, long cost, int page) {

        SkillEntry sk = SkillEntry.makeSkillEntry(SkillEntryType.NONE, skillId, level);
        SkillLearn skillLearn = SkillAcquireHolder.getInstance().getSkillLearnM(player, skillId, level, AcquireType.MULTICLASS);

        if (skillLearn == null) {
            DifferentMethods.communityNextPage(player, "_bbsskill:show-" + page + "-" + classId);
            return;
        }

        if (player.getSp() < cost) {
            player.sendPacket(SystemMsg.YOU_DO_NOT_HAVE_ENOUGH_SP_TO_LEARN_THIS_SKILL);
            DifferentMethods.communityNextPage(player, "_bbsskill:show-" + page + "-" + classId);
            return;
        }

        // проверяем на итем базовый в хмл
        if (skillLearn.getItemId() > 0) {
            if (player.getInventory().getCountOf(skillLearn.getItemId()) < skillLearn.getItemCount()) {
                player.sendPacket(SystemMsg.INCORRECT_ITEM_COUNT);
                DifferentMethods.communityNextPage(player, "_bbsskill:show-" + page + "-" + classId);
                return;
            }
        }

        boolean hasItems = true;
        for (final ItemData addItem : skillLearn.getAdditionalRequiredItems()) {
            if (player.getInventory().getCountOf(addItem.getId()) < addItem.getCount()) {
                hasItems = false;
                break;
            }
        }

        if (!hasItems) {
            player.sendPacket(SystemMsg.INCORRECT_ITEM_COUNT);
            DifferentMethods.communityNextPage(player, "_bbsskill:show-" + page + "-" + classId);
            return;
        }

        //все гуд, снимаем итем и доп итем
        if (skillLearn.getItemId() > 0) {
            ItemFunctions.deleteItem(player, skillLearn.getItemId(), skillLearn.getItemCount(), true);
        }
        for (ItemData addItem : skillLearn.getAdditionalRequiredItems()) {
            ItemFunctions.deleteItem(player, addItem.getId(), addItem.getCount(), true);
        }

        player.sendPacket(new SystemMessage(SystemMsg.YOU_HAVE_EARNED_S1_SKILL).addSkillName(sk.getId(), sk.getLevel()));
        player.sendPacket(new SystemMessage(SystemMsg.YOUR_SP_HAS_DECREASED_BY_S1).addNumber(cost));
        player.setSp(player.getSp() - cost);
        player.addSkill(sk, true);

        DifferentMethods.communityNextPage(player, "_bbsskill:show-" + page + "-" + classId);
    }

    private void learnC(Player player, int skillId, int level, long cost, int page) {
        SkillLearn skillLearn = SkillAcquireHolder.getInstance().getSkillLearn(player, skillId, level, AcquireType.CUSTOM);
        SkillEntry sk = SkillEntry.makeSkillEntry(SkillEntryType.NONE, skillId, level);
        if (skillLearn == null)
            return;

        if (player.getSp() < cost) {
            player.sendPacket(SystemMsg.YOU_DO_NOT_HAVE_ENOUGH_SP_TO_LEARN_THIS_SKILL);
            DifferentMethods.communityNextPage(player, "_bbsskill:showcp-" + page);
            return;
        }
        // проверяем на итем базовый в хмл
        if (skillLearn.getItemId() > 0) { //Если базовый итем для изучения присутствует, то проверяем только его.
            if (player.getInventory().getCountOf(skillLearn.getItemId()) < skillLearn.getItemCount()) {
                player.sendPacket(SystemMsg.INCORRECT_ITEM_COUNT);
                DifferentMethods.communityNextPage(player, "_bbsskill:showcp-" + page);
                return;
            }
        }
        // проверяем на доп. итем
        if (player.getInventory().getCountOf(skillLearn.getItemId()) < skillLearn.getItemCount()) {
            player.sendPacket(SystemMsg.INCORRECT_ITEM_COUNT);
            DifferentMethods.communityNextPage(player, "_bbsskill:showcp-" + page);
            return;
        }

        boolean hasItems = true;
        for (final ItemData additionalRequiredItem : skillLearn.getAdditionalRequiredItems()) {
            if (player.getInventory().getCountOf(additionalRequiredItem.getId()) < additionalRequiredItem.getCount()) {
                hasItems = false;
                break;
            }
        }

        if (!hasItems) {
            player.sendPacket(SystemMsg.INCORRECT_ITEM_COUNT);
            DifferentMethods.communityNextPage(player, "_bbsskill:showcp-" + page);
            return;
        }

        //все гуд, снимаем итем и доп итем
        if (skillLearn.getItemId() > 0) {
            ItemFunctions.deleteItem(player, skillLearn.getItemId(), skillLearn.getItemCount(), true);
        }
        for (ItemData addItem : skillLearn.getAdditionalRequiredItems()) {
            ItemFunctions.deleteItem(player, addItem.getId(), addItem.getCount(), true);
        }

        player.sendPacket(new SystemMessage(SystemMsg.YOU_HAVE_EARNED_S1_SKILL).addSkillName(sk.getId(), sk.getLevel()));
        player.sendPacket(new SystemMessage(SystemMsg.YOUR_SP_HAS_DECREASED_BY_S1).addNumber(cost));
        player.setSp(player.getSp() - cost);
        player.addSkill(sk, true);
        player.sendSkillList();

        DifferentMethods.communityNextPage(player, "_bbsskill:showcp-" + page);
    }

    private void learnC1(Player player, int skillId, int level, long cost, int page) {
        SkillLearn skillLearn = SkillAcquireHolder.getInstance().getSkillLearn(player, skillId, level, AcquireType.CUSTOM1);
        SkillEntry sk = SkillEntry.makeSkillEntry(SkillEntryType.NONE, skillId, level);
        if (skillLearn == null)
            return;

        if (player.getSp() < cost) {
            player.sendPacket(SystemMsg.YOU_DO_NOT_HAVE_ENOUGH_SP_TO_LEARN_THIS_SKILL);
            DifferentMethods.communityNextPage(player, "_bbsskill:showcp1-" + page);
            return;
        }

        // проверяем на итем базовый в хмл
        if (skillLearn.getItemId() > 0) { //Если базовый итем для изучения присутствует, то проверяем только его.
            if (player.getInventory().getCountOf(skillLearn.getItemId()) < skillLearn.getItemCount()) {
                player.sendPacket(SystemMsg.INCORRECT_ITEM_COUNT);
                DifferentMethods.communityNextPage(player, "_bbsskill:showcp1-" + page);
                return;
            }
        }

        // проверяем на доп. итем
        if (player.getInventory().getCountOf(skillLearn.getItemId()) < skillLearn.getItemCount()) {
            player.sendPacket(SystemMsg.INCORRECT_ITEM_COUNT);
            DifferentMethods.communityNextPage(player, "_bbsskill:showcp1-" + page);
            return;
        }

        boolean hasItems = true;
        for (final ItemData addItem : skillLearn.getAdditionalRequiredItems()) {
            if (player.getInventory().getCountOf(addItem.getId()) < addItem.getCount()) {
                hasItems = false;
                break;
            }
        }

        if (!hasItems) {
            player.sendPacket(SystemMsg.INCORRECT_ITEM_COUNT);
            DifferentMethods.communityNextPage(player, "_bbsskill:showcp1-" + page);
            return;
        }

        if (skillLearn.getItemId() > 0) {
            ItemFunctions.deleteItem(player, skillLearn.getItemId(), skillLearn.getItemCount(), true);
        }
        for (ItemData additionalRequiredItem : skillLearn.getAdditionalRequiredItems()) {
            DifferentMethods.getPay(player, additionalRequiredItem.getId(), additionalRequiredItem.getCount(), true);
        }

        player.sendPacket(new SystemMessage(SystemMsg.YOU_HAVE_EARNED_S1_SKILL).addSkillName(sk.getId(), sk.getLevel()));
        player.sendPacket(new SystemMessage(SystemMsg.YOUR_SP_HAS_DECREASED_BY_S1).addNumber(cost));
        player.setSp(player.getSp() - cost);
        player.addSkill(sk, true);
        player.sendSkillList();

        DifferentMethods.communityNextPage(player, "_bbsskill:showcp1-" + page);
    }

    /*private void learnC1(Player player, int skillId, int level, long cost, int page) {
        SkillLearn skillLearn = SkillAcquireHolder.getInstance().getSkillLearnM(player, skillId, level, AcquireType.CUSTOM1);
        //SkillEntry sk = SkillHolder.getInstance().getSkillEntry(skillId, level);
        boolean individual = false;
        if (ArrayUtils.contains(skills_idCustom, skillId))
            individual = true;
        if (skillLearn == null)
            return;

        if (player.getSp() < cost) {
            player.sendPacket(SystemMsg.YOU_DO_NOT_HAVE_ENOUGH_SP_TO_LEARN_THIS_SKILL);
            //DifferentMethods.communityNextPage(player, "_bbsskill:showcp1-" + page);
            return;
        }

        // проверяем на итем базовый в хмл
        if (skillLearn.getItemId() > 0) { //Если базовый итем для изучения присутствует, то проверяем только его.
            if (player.getInventory().getCountOf(skillLearn.getItemId()) < skillLearn.getItemCount()){
                player.sendPacket(SystemMsg.INCORRECT_ITEM_COUNT);
                DifferentMethods.communityNextPage(player, "_bbsskill:showcp1-" + page);
                return;
            }
        }
        // проверяем на доп. итем
        if (player.getInventory().getCountOf(individual ? ItemIdIndivCustom : ItemIdCustom) < (individual ? ItemCountIndivCustom : ItemCountCustom)){
            player.sendPacket(SystemMsg.INCORRECT_ITEM_COUNT);
            DifferentMethods.communityNextPage(player, "_bbsskill:showcp1-" + page);
            return;
        }
        //все гуд, снимаем итем и доп итем
       if (skillLearn.getItemId() > 0){
            ItemFunctions.removeItem(player, skillLearn.getItemId(), skillLearn.getItemCount(), true);
        }
        ItemFunctions.removeItem(player, individual ? ItemIdIndivCustom : ItemIdCustom, individual ? ItemCountIndivCustom : ItemCountCustom, true);

        player.sendPacket(new SystemMessage(SystemMsg.YOU_HAVE_EARNED_S1_SKILL).addSkillName(sk.getId(), sk.getLevel()));
        player.sendPacket(new SystemMessage(SystemMsg.YOUR_SP_HAS_DECREASED_BY_S1).addNumber(cost));
        player.setSp(player.getSp() - cost);
        //player.addSkill(sk, true);
        player.sendSkillList();

        DifferentMethods.communityNextPage(player, "_bbsskill:showcp1-" + page);
    }*/

    private void showDelete(Player player, int page) {
        Collection<SkillEntry> skills = player.getAllSkills();
        String html = HtmCache.getInstance().getHtml(Config.BBS_HOME_DIR + "pages/SkillLearn/index.htm", player);
        String button = null;
        String template = HtmCache.getInstance().getHtml(Config.BBS_HOME_DIR + "pages/SkillLearn/showdskill.htm", player);
        String block = null;
        List<SkillEntry> temp = new ArrayList<>();

        for (SkillEntry s : skills) {
            SkillEntry sk = SkillEntry.makeSkillEntry(SkillEntryType.NONE, s.getId(), s.getLevel());
            temp.add(sk);
        }
        if (temp.size() <= SHOW_SKILL_PAGE)
            page = 1;

        for (int i = page * SHOW_SKILL_PAGE - SHOW_SKILL_PAGE; i < page * SHOW_SKILL_PAGE; i++) {
            if (i >= temp.size())
                break;

            SkillEntry sk = temp.get(i);
            if (sk != null) {
                block = template;
                block = block.replace("{name}", sk.getName());
                block = block.replace("{icon}", sk.getTemplate().getIcon());
                block = block.replace("{level}", String.valueOf(sk.getLevel()));
                block = block.replace("{link}", "bypass _bbsskill:delete-" + sk.getId() + "-" + sk.getLevel());
                block = block.replace("{price}", ItemCountDelete + " " + DifferentMethods.getItemName(ItemIdDelete));
                button = button + block;

            }
        }

        StringBuilder pg = new StringBuilder();

        double skillcount = skills.size();
        double MaxItemPerPage = SHOW_SKILL_PAGE;

        if (skillcount > MaxItemPerPage) {
            double MaxPages = Math.ceil(skillcount / MaxItemPerPage);

            pg.append("<center><table width=25 border=0><tr>");
            int ButtonInLine = 1;
            for (int current = 1; current <= MaxPages; current++) {
                if (page == current)
                    pg.append("<td width=25 align=center><button value=\"[").append(current).append("]\" width=28 height=25 back=\"L2UI_EPIC.NewButton_Blue\" fore=\"L2UI_EPIC.NewButton_Blue\"></td>");
                else
                    pg.append("<td width=25 align=center><button value=\"").append(current).append("\" action=\"bypass _bbsskill:showp-").append(current).append("\" width=28 height=25 back=\"L2UI_EPIC.NewButton_Blue\" fore=\"L2UI_EPIC.NewButton_Blue\"></td>");

                if (ButtonInLine == 18) {
                    pg.append("</tr><tr>");
                    ButtonInLine = 0;
                }
                ButtonInLine++;
            }
            pg.append("</tr></table></center>");
        }

        html = html.replace("<?body?>", button == null ? "У Вас нету скилов" : button);
        html = html.replace("<?pages?>", pg.toString());
        html = html.replace("{link}", "bypass _bbspage:SkillLearn/race");
        html = html.replace("{price}", ItemCountDelete + " " + DifferentMethods.getItemName(ItemIdDelete));
        ShowBoardPacket.separateAndSend(html, player);
    }

    public void delete(Player player, int skillId, int level) {
        SkillEntry sk = SkillEntry.makeSkillEntry(SkillEntryType.NONE, skillId, level);

        if (!DifferentMethods.getPay(player, ItemIdDelete, ItemCountDelete, true)) {
            DifferentMethods.communityNextPage(player, "_bbsskill:showdelete");
            return;
        }
        player.removeSkill(sk, true);
        player.sendSkillList();
        // Update 'can_crystalize' status
        if (sk != null && sk.getId() == Skill.SKILL_CRYSTALLIZE) {
            UIPacket uiPacket = new UIPacket(player, false);
            uiPacket.addComponentType(UserInfoType.STATUS);
            player.sendPacket(uiPacket);
        }

        DifferentMethods.communityNextPage(player, "_bbsskill:showdelete");
    }

    @Override
    public void onWriteCommand(Player player, String bypass, String arg1, String arg2, String arg3, String arg4, String arg5) {
    }

    @Override
    public void onInit() {
        _log.info("CommunityBoard: Community skill Learn loaded.");
        BbsHandlerHolder.getInstance().registerHandler(this);
    }
}