package l2s.gameserver.model.Mods.Reborn;

import l2s.gameserver.common.DifferentMethods;
import l2s.gameserver.model.Player;
import l2s.gameserver.model.base.Experience;
import l2s.gameserver.network.l2.components.HtmlMessage;
import l2s.gameserver.skills.SkillEntry;
import l2s.gameserver.skills.SkillEntryType;
import l2s.gameserver.stats.Stats;
import l2s.gameserver.stats.funcs.FuncAdd;
import l2s.gameserver.stats.funcs.FuncMul;
import l2s.gameserver.templates.StatsSet;
import l2s.gameserver.templates.item.ItemTemplate;
import l2s.gameserver.utils.ItemFunctions;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.text.SimpleDateFormat;
import java.util.concurrent.TimeUnit;

public class RebornSystem {
    public static final Logger _log = LoggerFactory.getLogger(RebornSystem.class);

    private static final int REBORN_STR = 120169;
    private static final int REBORN_INT = 120170;
    private static final int REBORN_DEX = 120171;
    private static final int REBORN_WIT = 120172;
    private static final int REBORN_CON = 120173;
    private static final int REBORN_MEN = 120174;
    private static final int REBORN_PVE_ATTACK = 120175;
    private static final int REBORN_EXP = 120176;
    private static final int REBORN_SOULSHOT_DAMAGE = 120177;
    private static final int REBORN_SPIRITSHOT_DAMAGE = 120178;
    private static final int REBORN_ADENA_DROP = 120179;
    private static final int REBORN_PVP_ATTACK = 120180;
    private static final int REBORN_PVP_DEFENCE = 120181;
    private static final int REBORN_CP_HP_MP = 120182;
    private static final int REBORN_PHYSICAL_ATTACK = 120183;
    private static final int REBORN_MAGE_ATTACK = 120184;
    private static final int REBORN_PHYSICAL_DEFENCE = 120185;
    private static final int REBORN_MAGE_DEFENCE = 120186;
    private static final int REBORN_RAID_BOSS_DAMAGE = 120187;
    private static final int REBORN_CHA = 120188;

    private static final int REBORN_COIN = 110383;

    public static void info(Player player, int npcobj) {
        HtmlMessage html = new HtmlMessage(npcobj).setFile("scripts/MCST/Reborn.htm");
        if (player == null)
            return;
        int REBORN_COUNT = player.getRebirthCount();
        RebornSystemInfo info = RebornSystemManager.getRebornId(REBORN_COUNT);

        if (info != null) {
            String content = "";
            String need_item = "";
            String reward_item = "";
            String level_need = "";
            int max_rebirth = 0;

            int maxSTR=0;
            int maxINT=0;
            int maxDEX=0;
            int maxWIT=0;

            int maxCON=0;
            int maxMEN=0;
            int maxPvePhysDmg=0;
            int maxPveMagDmg=0;

            int maxCHA=0;
            int maxMaxCP=0;
            int maxMaxHP=0;
            int maxMaxMP=0;

            int maxPhysDmg=0;
            int maxMagDmg=0;
            int maxPhysDef=0;
            int maxMagDef=0;

            int maxPhysCritDmg=0;
            int maxMagCritDmg=0;
            int maxPhysCritRate=0;
            int maxMagCritRate=0;

            int maxPvpPhysDmg=0;
            int maxPvpMagDmg=0;
            int maxPvpPhysDef=0;
            int maxPvpMagDef=0;

            int maxMReuse=0;
            int maxAdenaRate=0;
            int maxExpRate=0;
            int maxDropRate=0;

            //-/-/-/-/-/-//

            int addSTR=0;
            int addINT=0;
            int addDEX=0;
            int addWIT=0;

            int addCON=0;
            int addMEN=0;
            int addCHA=0;
            double addPvePhysDmg=0;
            double addPveMagDmg=0;

            double addMaxCP=0;
            double addMaxHP=0;
            double addMaxMP=0;

            double addPhysDmg=0;
            double addMagDmg=0;
            double addPhysDef=0;
            double addMagDef=0;

            double addPhysCritDmg=0;
            double addMagCritDmg=0;
            double addPhysCritRate=0;
            double addMagCritRate=0;

            double addPvpPhysDmg=0;
            double addPvpMagDmg=0;
            double addPvpPhysDef=0;
            double addPvpMagDef=0;

            double addMReuse=0;
            double addAdenaRate=0;
            double addExpRate=0;
            double addDropRate=0;

 //           content = content + "<button value =\"Переродиться\" action=\"bypass -h npc_%objectId%_Reborn " + REBORN_COUNT + "\"width=110 height=17 back=\"L2UI_CT1.ListCTRL_DF_Title_Down\" fore=\"L2UI_CT1.ListCTRL_DF_Title\">";
            if (REBORN_COUNT == (info.getRebornId() - 1)) {
                for (String reward : info.getNeedItem().split(";")) {
                    String[] reward_array = reward.split(",");
                    if (reward_array.length == 2) {
                        need_item = need_item + Long.parseLong(reward_array[1]) + " " + DifferentMethods.getItemName(Integer.parseInt(reward_array[0])) + " ";
                    } else {
                        _log.error("Error reward_array.length != 2");
                    }
                }
                for (String reward : info.getReward().split(";")) {
                    String[] reward_array = reward.split(",");
                    if (reward_array.length == 2) {
                        reward_item = reward_item + Long.parseLong(reward_array[1]) + " " + DifferentMethods.getItemName(Integer.parseInt(reward_array[0])) + " ";
                    } else {
                        _log.error("Error reward_array.length != 2");
                    }
                }
                level_need = String.valueOf(info.getLevelNeed());
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

                addSTR = info.getSTR();
                addINT = info.getINT();
                addDEX = info.getDEX();
                addWIT = info.getWIT();

                addCON = info.getCON();
                addMEN = info.getMEN();
                addPvePhysDmg = info.getPvePhysDmg();
                addPveMagDmg = info.getPveMagDmg();

                addCHA = info.getCHA();
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

            }
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

            html = html.replace("<?reward_item?>", reward_item);
            html = html.replace("<?level_need?>", level_need);
            html = html.replace("<?content?>", content);
        }
        else {
            html.setFile("scripts/MCST/Reborn_final.htm");
        }

        player.sendPacket(html);
    }

    public static void rebornSkillDelete(Player player, int statId, boolean bbs) {
        if (statId == 1) {
            player.removeSkill(REBORN_STR, true);
        }
        if (statId == 2) {
            player.removeSkill(REBORN_INT, true);
        }
        if (statId == 3) {
            player.removeSkill(REBORN_DEX, true);
        }
        if (statId == 4) {
            player.removeSkill(REBORN_WIT, true);
        }
        if (statId == 5) {
            player.removeSkill(REBORN_CON, true);
        }
        if (statId == 6) {
            player.removeSkill(REBORN_MEN, true);
        }
//        if (statId == 7) {
//            player.removeSkill(REBORN_PVE_ATTACK, true);
//        }
        if (statId == 8) {
            player.removeSkill(REBORN_PVE_ATTACK, true);
        }
        if (statId == 10) {
            player.removeSkill(REBORN_CP_HP_MP, true);
        }
        //if (id == 10) {
        //    player.getStat().addFuncs(new FuncMul(Stats.MAX_HP, 0x30, player, (100. + info.getMaxHP()) / 100., StatsSet.EMPTY));
        //    player.setVar("addMaxHP", addMaxHP + 1, -1);
        //}
        //if (id == 11) {
        //    player.getStat().addFuncs(new FuncMul(Stats.MAX_MP, 0x30, player, (100. + info.getMaxMP()) / 100., StatsSet.EMPTY));
        //    player.setVar("addMaxMP", addMaxMP + 1, -1);
        //}
        if (statId == 13) {
            player.removeSkill(REBORN_PHYSICAL_ATTACK, true);
        }
        if (statId == 14) {
            player.removeSkill(REBORN_MAGE_ATTACK, true);
        }
        if (statId == 15) {
            player.removeSkill(REBORN_PHYSICAL_DEFENCE, true);
        }
        if (statId == 16) {
            player.removeSkill(REBORN_MAGE_DEFENCE, true);
        }
        if (statId == 17) {
            player.removeSkill(REBORN_RAID_BOSS_DAMAGE, true);
        }
        if (statId == 18) {
            player.removeSkill(REBORN_CHA, true);
        }
        //if (id == 18) {
        //    player.getStat().addFuncs(new FuncMul(Stats.P_CRITICAL_RATE, 0x30, player, (100. + (info.getPhysCritRate())) / 100., StatsSet.EMPTY));
        //    player.setVar("addPhysCritRate", addPhysCritRate + 1, -1);
        //}
        //if (id == 19) {
        //    player.getStat().addFuncs(new FuncMul(Stats.M_CRITICAL_RATE, 0x30, player, (100. + (info.getMagCritRate())) / 100., StatsSet.EMPTY));
        //    player.setVar("addMagCritRate", addMagCritRate + 1, -1);
        //}
        if (statId == 21) {
            player.removeSkill(REBORN_PVP_ATTACK, true);
        }
        //if (id == 21) {
        //    player.getStat().addFuncs(new FuncMul(Stats.PVP_MAGIC_SKILL_DMG_BONUS, 0x30, player, (100. + (info.getPvpMagDmg())) / 100., StatsSet.EMPTY));
        //    player.setVar("addPvpMagDmg", addPvpMagDmg + 1, -1);
        //}
        if (statId == 23) {
            player.removeSkill(REBORN_PVP_DEFENCE, true);
        }
        //if (id == 23) {
        //    player.getStat().addFuncs(new FuncMul(Stats.PVP_MAGIC_SKILL_DEFENCE_BONUS, 0x30, player, (100. + (info.getPvpMagDef())) / 100., StatsSet.EMPTY));
        //    player.setVar("addPvpMagDef", addPvpMagDef + 1, -1);
        //}
        //if (id == 24) {
        //    player.getStat().addFuncs(new FuncMul(Stats.MAGIC_REUSE_RATE, 0x30, player, (100. + (info.getMReuse())) / 100., StatsSet.EMPTY));
        //    player.setVar("addMReuse", addMReuse + 1, -1);
        //}
        if (statId == 26) {
            player.removeSkill(REBORN_ADENA_DROP, true);
        }
        if (statId == 27) {
            player.removeSkill(REBORN_EXP, true);
        }
        //if (id == 27) {
        //    player.getStat().addFuncs(new FuncAdd(Stats.DROP_RATE_MULTIPLIER, 0x40, player, 0. + info.getDropRate() / 100., StatsSet.EMPTY));
        //    player.setVar("addDropRate", addDropRate + 1, -1);
        //}
        if (statId == 29) {
            player.removeSkill(REBORN_SOULSHOT_DAMAGE, true);
        }
        if (statId == 30) {
            player.removeSkill(REBORN_SPIRITSHOT_DAMAGE, true);
        }

        player.sendSkillList();

        if (bbs)
            DifferentMethods.communityNextPage(player, "_bbsskill:Reborn_show");
    }

    //Добавление умений за плату
    public static void rebornSkillAdd(Player player, int id, boolean bbs) {
        int REBORN_COUNT = player.getRebirthCount();

        int addSTR = player.getVarInt("addSTR", 0);
        int addINT = player.getVarInt("addINT", 0);
        int addDEX = player.getVarInt("addDEX", 0);
        int addWIT = player.getVarInt("addWIT", 0);

        int addCON = player.getVarInt("addCON", 0);
        int addMEN = player.getVarInt("addMEN", 0);
        int addPvePhysDmg = player.getVarInt("addPvePhysDmg", 0);
        int addPveMagDmg = player.getVarInt("addPveMagDmg", 0);

        int addCHA = player.getVarInt("addCHA", 0);
        int addMaxCP = player.getVarInt("addMaxCP", 0);
        int addMaxHP = player.getVarInt("addMaxHP", 0);
        int addMaxMP = player.getVarInt("addMaxMP", 0);

        int addPhysDmg = player.getVarInt("addPhysDmg", 0);
        int addMagDmg = player.getVarInt("addMagDmg", 0);
        int addPhysDef = player.getVarInt("addPhysDef", 0);
        int addMagDef = player.getVarInt("addMagDef", 0);

        int addPhysCritDmg = player.getVarInt("addPhysCritDmg", 0);
        int addMagCritDmg = player.getVarInt("addMagCritDmg", 0);
        int addPhysCritRate = player.getVarInt("addPhysCritRate", 0);
        int addMagCritRate = player.getVarInt("addMagCritRate", 0);

        int addPvpPhysDmg = player.getVarInt("addPvpPhysDmg", 0);
        int addPvpMagDmg = player.getVarInt("addPvpMagDmg", 0);
        int addPvpPhysDef = player.getVarInt("addPvpPhysDef", 0);
        int addPvpMagDef = player.getVarInt("addPvpMagDef", 0);

        int addMReuse = player.getVarInt("addMReuse", 0);
        int addAdenaRate = player.getVarInt("addAdenaRate", 0);
        int addExpRate = player.getVarInt("addExpRate", 0);
        int addDropRate = player.getVarInt("addDropRate", 0);
        int addSoulShotPowerRate = player.getVarInt("addSoulShotPowerRate", 0);
        int addSpiritShotPowerRate = player.getVarInt("addSpiritShotPowerRate", 0);

        /**
         + STR
         + WIT
         + CON
         + DEX

         + INT
         + MEN
         - пве Физ урон 3%
         - пве маг урон 3%

         + LUC
         + хп 3%
         + мп 3%
         + цп 3%

         + Ф. Атк. 3%
         + М. Атк. 3%
         - Ф. Деф. 3%
         - М. Деф. 3%

         - Сила физ крита 2%
         - Сила маг крита 2%
         - Шанс физ крита 2%
         - Шанс маг крита 2%

         - пвп физ урон 2%
         - пвп маг урон 2%
         - пвп физ защита 3%
         - пвп маг защита 3%

         - м рюз 2%
         - рейт Адены 3%
         - рейт Опыта 3%
         - рейт Дропа 3%

         */
        RebornSystemInfo info = RebornSystemManager.getRebornId(REBORN_COUNT);
        if (info != null) {
           /*if (player.getLevel() < info.getLevelNeed()) {
                player.sendMessage("Ваш уровень мал для перерождения, нужно быть минимум " + info.getLevelNeed());
                if (bbs)
                    DifferentMethods.communityNextPage(player, "_bbsskill:Reborn_show");
                return;
            }*/
            if (player.getVarLong("rebornTime") > System.currentTimeMillis()) {
                player.sendMessage("Будет готово для использования в " + new SimpleDateFormat("dd.MM.yyyy HH:mm").format(player.getVarLong("rebornTime")));
                if (bbs)
                    DifferentMethods.communityNextPage(player, "_bbsskill:Reborn_show");
                return;
            }
            if (player.getRebirthCount() > RebornSystemManager.getSize()) {
                player.sendMessage("Больше нельзя перерождаться.");
                if (bbs)
                    DifferentMethods.communityNextPage(player, "_bbsskill:Reborn_show");
                return;
            }
            if (addSTR >= RebornSystemManager.maxSTR() && id == 0){
                player.sendPacket(new HtmlMessage(5).setFile("scripts/MCST/Reborn_final_stat.htm"));
                if (bbs)
                    DifferentMethods.communityNextPage(player, "_bbsskill:Reborn_show");
                return;
            }
            if (addINT >= RebornSystemManager.maxINT() && id == 1) {
                player.sendPacket(new HtmlMessage(5).setFile("scripts/MCST/Reborn_final_stat.htm"));
                if (bbs)
                    DifferentMethods.communityNextPage(player, "_bbsskill:Reborn_show");
                return;
            }
            if (addDEX >= RebornSystemManager.maxDEX() && id == 2){
                player.sendPacket(new HtmlMessage(5).setFile("scripts/MCST/Reborn_final_stat.htm"));
                if (bbs)
                    DifferentMethods.communityNextPage(player, "_bbsskill:Reborn_show");
                return;
            }
            if (addWIT >= RebornSystemManager.maxWIT() && id == 3) {
                player.sendPacket(new HtmlMessage(5).setFile("scripts/MCST/Reborn_final_stat.htm"));
                if (bbs)
                    DifferentMethods.communityNextPage(player, "_bbsskill:Reborn_show");
                return;
            }
            if (addCON >= RebornSystemManager.maxCON() && id == 4){
                player.sendPacket(new HtmlMessage(5).setFile("scripts/MCST/Reborn_final_stat.htm"));
                if (bbs)
                    DifferentMethods.communityNextPage(player, "_bbsskill:Reborn_show");
                return;
            }
            if (addMEN >= RebornSystemManager.maxMEN() && id == 5){
                player.sendPacket(new HtmlMessage(5).setFile("scripts/MCST/Reborn_final_stat.htm"));
                if (bbs)
                    DifferentMethods.communityNextPage(player, "_bbsskill:Reborn_show");
                return;
            }
            if (addPvePhysDmg >= RebornSystemManager.maxPvePhysDmg() && id == 6) {
                player.sendPacket(new HtmlMessage(5).setFile("scripts/MCST/Reborn_final_stat.htm"));
                if (bbs)
                    DifferentMethods.communityNextPage(player, "_bbsskill:Reborn_show");
                return;
            }
            if (addPveMagDmg >= RebornSystemManager.maxPveMagDmg() && id == 7) {
                player.sendPacket(new HtmlMessage(5).setFile("scripts/MCST/Reborn_final_stat.htm"));
                if (bbs)
                    DifferentMethods.communityNextPage(player, "_bbsskill:Reborn_show");
                return;
            }
            if (addCHA >= RebornSystemManager.maxCHA() && id == 8){
                player.sendPacket(new HtmlMessage(5).setFile("scripts/MCST/Reborn_final_stat.htm"));
                if (bbs)
                    DifferentMethods.communityNextPage(player, "_bbsskill:Reborn_show");
                return;
            }
            if (addMaxCP >= RebornSystemManager.maxMaxCP() && id == 9) {
                player.sendPacket(new HtmlMessage(5).setFile("scripts/MCST/Reborn_final_stat.htm"));
                if (bbs)
                    DifferentMethods.communityNextPage(player, "_bbsskill:Reborn_show");
                return;
            }
            if (addMaxHP >= RebornSystemManager.maxMaxHP() && id == 10) {
                player.sendPacket(new HtmlMessage(5).setFile("scripts/MCST/Reborn_final_stat.htm"));
                if (bbs)
                    DifferentMethods.communityNextPage(player, "_bbsskill:Reborn_show");
                return;
            }
            if (addMaxMP >= RebornSystemManager.maxMaxMP() && id == 11) {
                player.sendPacket(new HtmlMessage(5).setFile("scripts/MCST/Reborn_final_stat.htm"));
                if (bbs)
                    DifferentMethods.communityNextPage(player, "_bbsskill:Reborn_show");
                return;
            }
            if (addPhysDmg >= RebornSystemManager.maxPhysDmg() && id == 12) {
                player.sendPacket(new HtmlMessage(5).setFile("scripts/MCST/Reborn_final_stat.htm"));
                if (bbs)
                    DifferentMethods.communityNextPage(player, "_bbsskill:Reborn_show");
                return;
            }
            if (addMagDmg >= RebornSystemManager.maxMagDmg() && id == 13) {
                player.sendPacket(new HtmlMessage(5).setFile("scripts/MCST/Reborn_final_stat.htm"));
                if (bbs)
                    DifferentMethods.communityNextPage(player, "_bbsskill:Reborn_show");
                return;
            }
            if (addPhysDef >= RebornSystemManager.maxPhysDef() && id == 14) {
                player.sendPacket(new HtmlMessage(5).setFile("scripts/MCST/Reborn_final_stat.htm"));
                if (bbs)
                    DifferentMethods.communityNextPage(player, "_bbsskill:Reborn_show");
                return;
            }
            if (addMagDef >= RebornSystemManager.maxMagDef() && id == 15) {
                player.sendPacket(new HtmlMessage(5).setFile("scripts/MCST/Reborn_final_stat.htm"));
                if (bbs)
                    DifferentMethods.communityNextPage(player, "_bbsskill:Reborn_show");
                return;
            }
            if (addPhysCritDmg >= RebornSystemManager.maxPhysCritDmg() && id == 16) {
                player.sendPacket(new HtmlMessage(5).setFile("scripts/MCST/Reborn_final_stat.htm"));
                if (bbs)
                    DifferentMethods.communityNextPage(player, "_bbsskill:Reborn_show");
                return;
            }
            if (addMagCritDmg >= RebornSystemManager.maxMagCritDmg() && id == 17) {
                player.sendPacket(new HtmlMessage(5).setFile("scripts/MCST/Reborn_final_stat.htm"));
                if (bbs)
                    DifferentMethods.communityNextPage(player, "_bbsskill:Reborn_show");
                return;
            }
            if (addPhysCritRate >= RebornSystemManager.maxPhysCritRate() && id == 18) {
                player.sendPacket(new HtmlMessage(5).setFile("scripts/MCST/Reborn_final_stat.htm"));
                if (bbs)
                    DifferentMethods.communityNextPage(player, "_bbsskill:Reborn_show");
                return;
            }
            if (addMagCritRate >= RebornSystemManager.maxMagCritRate() && id == 19) {
                player.sendPacket(new HtmlMessage(5).setFile("scripts/MCST/Reborn_final_stat.htm"));
                if (bbs)
                    DifferentMethods.communityNextPage(player, "_bbsskill:Reborn_show");
                return;
            }
            if (addPvpPhysDmg >= RebornSystemManager.maxPvpPhysDmg() && id == 20) {
                player.sendPacket(new HtmlMessage(5).setFile("scripts/MCST/Reborn_final_stat.htm"));
                if (bbs)
                    DifferentMethods.communityNextPage(player, "_bbsskill:Reborn_show");
                return;
            }
            if (addPvpMagDmg >= RebornSystemManager.maxPvpMagDmg() && id == 21) {
                player.sendPacket(new HtmlMessage(5).setFile("scripts/MCST/Reborn_final_stat.htm"));
                if (bbs)
                    DifferentMethods.communityNextPage(player, "_bbsskill:Reborn_show");
                return;
            }
            if (addPvpPhysDef >= RebornSystemManager.maxPvpPhysDef() && id == 22) {
                player.sendPacket(new HtmlMessage(5).setFile("scripts/MCST/Reborn_final_stat.htm"));
                if (bbs)
                    DifferentMethods.communityNextPage(player, "_bbsskill:Reborn_show");
                return;
            }
            if (addPvpMagDef >= RebornSystemManager.maxPvpMagDef() && id == 23) {
                player.sendPacket(new HtmlMessage(5).setFile("scripts/MCST/Reborn_final_stat.htm"));
                if (bbs)
                    DifferentMethods.communityNextPage(player, "_bbsskill:Reborn_show");
                return;
            }
            if (addMReuse >= RebornSystemManager.maxMReuse() && id == 24) {
                player.sendPacket(new HtmlMessage(5).setFile("scripts/MCST/Reborn_final_stat.htm"));
                if (bbs)
                    DifferentMethods.communityNextPage(player, "_bbsskill:Reborn_show");
                return;
            }
            if (addAdenaRate >= RebornSystemManager.maxAdenaRate() && id == 25) {
                player.sendPacket(new HtmlMessage(5).setFile("scripts/MCST/Reborn_final_stat.htm"));
                if (bbs)
                    DifferentMethods.communityNextPage(player, "_bbsskill:Reborn_show");
                return;
            }
            if (addExpRate >= RebornSystemManager.maxExpRate() && id == 26) {
                player.sendPacket(new HtmlMessage(5).setFile("scripts/MCST/Reborn_final_stat.htm"));
                if (bbs)
                    DifferentMethods.communityNextPage(player, "_bbsskill:Reborn_show");
                return;
            }
            if (addDropRate >= RebornSystemManager.maxDropRate() && id == 27) {
                player.sendPacket(new HtmlMessage(5).setFile("scripts/MCST/Reborn_final_stat.htm"));
                if (bbs)
                    DifferentMethods.communityNextPage(player, "_bbsskill:Reborn_show");
                return;
            }
            if (addSoulShotPowerRate >= RebornSystemManager.maxSoulShotPowerRate() && id == 28) {
                player.sendPacket(new HtmlMessage(5).setFile("scripts/MCST/Reborn_final_stat.htm"));
                if (bbs)
                    DifferentMethods.communityNextPage(player, "_bbsskill:Reborn_show");
                return;
            }
            if (addSpiritShotPowerRate >= RebornSystemManager.maxSpiritShotPowerRate() && id == 29) {
                player.sendPacket(new HtmlMessage(5).setFile("scripts/MCST/Reborn_final_stat.htm"));
                if (bbs)
                    DifferentMethods.communityNextPage(player, "_bbsskill:Reborn_show");
                return;
            }

            boolean lang = player.isLangRus();
            //проверяем имеет ли вообще чар итем
            if (!player.getInventory().containsItem(REBORN_COIN))
            {
                if (lang) {
                    player.sendMessage("Для изучения Умения Перерождения, нужно иметь предмет " + DifferentMethods.getItemName(REBORN_COIN) + ".");
                } else {
                    player.sendMessage("To learn Reborn Skill, you need to have a item " + "Reborn Coin.");
                }
                return;
            }
            //если итем есть, проверяем на количество
            if (player.getInventory().getCountOf(REBORN_COIN) < 1)
            {
                if (lang) {
                    player.sendMessage("У Вас не хватает количества предмета " + DifferentMethods.getItemName(REBORN_COIN) + ".");
                } else {
                    player.sendMessage("You don't have enough item quantity " + "Reborn Coin.");
                }
                return;
            }
            // забираем итем
             DifferentMethods.getPay(player, REBORN_COIN, 1, true);

            if (id == 0) {
                getCurrentSkillLevel(player, REBORN_STR);
                player.setVar("addSTR", addSTR + info.getSTR(), -1);
            }
            if (id == 1) {
                getCurrentSkillLevel(player, REBORN_INT);
                player.setVar("addINT", addINT + info.getINT(), -1);
            }
            if (id == 2) {
                getCurrentSkillLevel(player, REBORN_DEX);
                player.setVar("addDEX", addDEX + info.getDEX(), -1);
            }
            if (id == 3) {
                getCurrentSkillLevel(player, REBORN_WIT);
                player.setVar("addWIT", addWIT + info.getWIT(), -1);
            }
            if (id == 4) {
                getCurrentSkillLevel(player, REBORN_CON);
                player.setVar("addCON", addCON + info.getCON(), -1);
            }
            if (id == 5) {
                getCurrentSkillLevel(player, REBORN_MEN);
                player.setVar("addMEN", addMEN + info.getMEN(), -1);
            }
            if (id == 6) {
                getCurrentSkillLevel(player, REBORN_PVE_ATTACK);
                player.setVar("addPvePhysDmg", addPvePhysDmg + 1, -1);
            }
            //if (id == 7) {
            //    player.getStat().addFuncs(new FuncMul(Stats.PVE_MAGIC_SKILL_DMG_BONUS, 0x30, player, (100. + info.getPveMagDmg()) / 100., StatsSet.EMPTY));
            //    player.setVar("addPveMagDmg", addPveMagDmg + 1, -1);
            //}
            //if (id == 8) {
            //    getCurrentSkillLevel(player, REBORN_CHA);
            //    player.setVar("addCHA", addCHA + 1, -1);
            //}
            if (id == 9) {
                getCurrentSkillLevel(player, REBORN_CP_HP_MP);
                player.setVar("addMaxCP", addMaxCP + 1, -1);
            }
            //if (id == 10) {
            //    player.getStat().addFuncs(new FuncMul(Stats.MAX_HP, 0x30, player, (100. + info.getMaxHP()) / 100., StatsSet.EMPTY));
            //    player.setVar("addMaxHP", addMaxHP + 1, -1);
            //}
            //if (id == 11) {
            //    player.getStat().addFuncs(new FuncMul(Stats.MAX_MP, 0x30, player, (100. + info.getMaxMP()) / 100., StatsSet.EMPTY));
            //    player.setVar("addMaxMP", addMaxMP + 1, -1);
            //}
            if (id == 12) {
                getCurrentSkillLevel(player, REBORN_PHYSICAL_ATTACK);
                player.setVar("addPhysDmg", addPhysDmg + 1, -1);
            }
            if (id == 13) {
                getCurrentSkillLevel(player, REBORN_MAGE_ATTACK);
                player.setVar("addMagDmg", addMagDmg + 1, -1);
            }
            if (id == 14) {
                getCurrentSkillLevel(player, REBORN_PHYSICAL_DEFENCE);
                player.setVar("addPhysDef", addPhysDef + 1, -1);
            }
            if (id == 15) {
                getCurrentSkillLevel(player, REBORN_MAGE_DEFENCE);
                player.setVar("addMagDef", addMagDef + 1, -1);
            }
           if (id == 16) {
               getCurrentSkillLevel(player, REBORN_RAID_BOSS_DAMAGE);
               player.setVar("addPhysCritDmg", addPhysCritDmg + 1, -1);
           }
           if (id == 17) {
               getCurrentSkillLevel(player, REBORN_CHA);
               player.setVar("addMagCritDmg", addMagCritDmg + 1, -1); // Это умение ХАР
           }
           //if (id == 18) {
           //    player.getStat().addFuncs(new FuncMul(Stats.P_CRITICAL_RATE, 0x30, player, (100. + (info.getPhysCritRate())) / 100., StatsSet.EMPTY));
           //    player.setVar("addPhysCritRate", addPhysCritRate + 1, -1);
           //}
           //if (id == 19) {
           //    player.getStat().addFuncs(new FuncMul(Stats.M_CRITICAL_RATE, 0x30, player, (100. + (info.getMagCritRate())) / 100., StatsSet.EMPTY));
           //    player.setVar("addMagCritRate", addMagCritRate + 1, -1);
           //}
            if (id == 20) {
                getCurrentSkillLevel(player, REBORN_PVP_ATTACK);
                player.setVar("addPvpPhysDmg", addPvpPhysDmg + 1, -1);
            }
            //if (id == 21) {
            //    player.getStat().addFuncs(new FuncMul(Stats.PVP_MAGIC_SKILL_DMG_BONUS, 0x30, player, (100. + (info.getPvpMagDmg())) / 100., StatsSet.EMPTY));
            //    player.setVar("addPvpMagDmg", addPvpMagDmg + 1, -1);
            //}
            if (id == 22) {
                getCurrentSkillLevel(player, REBORN_PVP_DEFENCE);
                player.setVar("addPvpPhysDef", addPvpPhysDef + 1, -1);
            }
            //if (id == 23) {
            //    player.getStat().addFuncs(new FuncMul(Stats.PVP_MAGIC_SKILL_DEFENCE_BONUS, 0x30, player, (100. + (info.getPvpMagDef())) / 100., StatsSet.EMPTY));
            //    player.setVar("addPvpMagDef", addPvpMagDef + 1, -1);
            //}
            //if (id == 24) {
            //    player.getStat().addFuncs(new FuncMul(Stats.MAGIC_REUSE_RATE, 0x30, player, (100. + (info.getMReuse())) / 100., StatsSet.EMPTY));
            //    player.setVar("addMReuse", addMReuse + 1, -1);
            //}
            if (id == 25) {
                getCurrentSkillLevel(player, REBORN_ADENA_DROP);
                player.setVar("addAdenaRate", addAdenaRate + 1, -1);
            }
            if (id == 26) {
                getCurrentSkillLevel(player, REBORN_EXP);
                player.setVar("addExpRate", addExpRate + 1, -1);
            }
            //if (id == 27) {
            //    player.getStat().addFuncs(new FuncAdd(Stats.DROP_RATE_MULTIPLIER, 0x40, player, 0. + info.getDropRate() / 100., StatsSet.EMPTY));
            //    player.setVar("addDropRate", addDropRate + 1, -1);
            //}
            if (id == 28) {
                getCurrentSkillLevel(player, REBORN_SOULSHOT_DAMAGE);
                player.setVar("addSoulShotPowerRate", addSoulShotPowerRate + 1, -1);
            }
            if (id == 29) {
                getCurrentSkillLevel(player, REBORN_SPIRITSHOT_DAMAGE);
                player.setVar("addSpiritShotPowerRate", addSpiritShotPowerRate + 1, -1);
            }

            if (bbs)
                DifferentMethods.communityNextPage(player, "_bbsskill:Reborn_show");
        }
    }

    public static void rebornSystemNew(Player player, boolean bbs) {
        int REBORN_COUNT = player.getRebirthCount();
        RebornSystemInfo info = RebornSystemManager.getRebornId(REBORN_COUNT);
        if (player.getLevel() < info.getLevelNeed()) {
            player.sendMessage(player.isLangRus()
                    ? "Ваш уровень слишком мал для перерождения, нужно иметь минимум " + info.getLevelNeed()
                    : "Your level is too low to be reborn, you need to be at least level " + info.getLevelNeed());
            if (bbs) {
                DifferentMethods.communityNextPage(player, "_bbsskill:Reborn_show");
            }
            return;
        }
        for (String reward : info.getNeedItem().split(";")) {
            String[] reward_array = reward.split(",");
            if (reward_array.length == 3) {
                try {
                    int itemId = Integer.parseInt(reward_array[0]);
                    long itemCount = Long.parseLong(reward_array[1]);
                    int itemEnchant = Integer.parseInt(reward_array[2]);
                    if (!player.getInventory().containsItem(itemId)) {
                        player.sendMessage(player.isLangRus()
                                ? "Для перерождения нужно иметь предмет " + DifferentMethods.getItemName(itemId)
                                : "To be reborn, you need to have the item " + DifferentMethods.getItemName(itemId));
                        return;
                    }
                    if (player.getInventory().getCountOf(itemId) < itemCount) {
                        player.sendMessage(player.isLangRus()
                                ? "У вас нет нужного количества предмета " + DifferentMethods.getItemName(itemId)
                                : "You do not have enough of the item " + DifferentMethods.getItemName(itemId));
                        return;
                    }
                    if (player.getInventory().getItemByItemId(itemId).getEnchantLevel() < itemEnchant) {
                        player.sendMessage(player.isLangRus()
                                ? "Ваш предмет " + DifferentMethods.getItemName(itemId) + " должен быть зачарован на " + itemEnchant + " уровень или выше."
                                : "Your item " + DifferentMethods.getItemName(itemId) + " must be enchanted to level " + itemEnchant + " or higher.");
                        return;
                    }
                } catch (NumberFormatException e) {
                    _log.error("Error parsing item id, count or enchant: " + reward, e);
                }
            } else {
                _log.error("Error reward_array.length != 3: " + reward);
            }
        }

        for (String reward : info.getNeedItem().split(";")) {
            String[] reward_array = reward.split(",");
            if (reward_array.length == 3) {
                try {
                    int itemId = Integer.parseInt(reward_array[0]);
                    int itemCount = Integer.parseInt(reward_array[1]);
                    int itemEnchant = Integer.parseInt(reward_array[2]);
                    DifferentMethods.getPay(player, itemId, itemCount, itemEnchant, false);
                    player.sendMessage(player.isLangRus()
                            ? "Вы потратили " + itemCount + " шт. предмета " + DifferentMethods.getItemName(itemId)
                            : "You have spent " + itemCount + " of item " + DifferentMethods.getItemName(itemId));
                } catch (NumberFormatException e) {
                    _log.error("Error parsing item id, count or enchant: " + reward, e);
                }
            } else {
                _log.error("Error reward_array.length != 3: " + reward);
            }
        }

        for (String reward : info.getReward().split(";")) {
            if (reward.isEmpty()) {
                continue;
            }
            String[] reward_array = reward.split(",");
            if (reward_array.length >= 2) {
                int itemId = Integer.parseInt(reward_array[0]);
                long itemCount = Long.parseLong(reward_array[1]);
                int itemEnchant = reward_array.length == 3 ? Integer.parseInt(reward_array[2]) : 0;

                if (itemEnchant > 0) {
                    ItemFunctions.addItem(player, itemId, itemCount, itemEnchant, true);
                } else {
                    ItemFunctions.addItem(player, itemId, itemCount, true);
                }
            } else {
                _log.error("Error reward_array.length != 2 or 3: " + reward);
            }
        }


        long exp_add = Experience.getExpForLevel(info.getResetLevel()) - player.getExp();
        player.addExpAndSp(exp_add, 0);
        player.setRebirthCount(player.getRebirthCount() + 1);
        player.setLastRebirth(System.currentTimeMillis(), true);
        player.sendClassChangeAlert();
        player.setVar("rebornTime", System.currentTimeMillis() + TimeUnit.HOURS.toMillis(info.getResetTime()), -1);
        _log.info("Player " + player.getName() + " get REBORN: #" + player.getRebirthCount());
        if (bbs)
            DifferentMethods.communityNextPage(player, "_bbsskill:Reborn_show");
    }

    private static void getCurrentSkillLevel(Player player, int skillId) {
        int currentSkillLevel = player.getSkillLevel(skillId);
        if (currentSkillLevel > 0) {
            player.addSkill(SkillEntry.makeSkillEntry(SkillEntryType.NONE, skillId, currentSkillLevel + 1), true);
        } else {
            player.addSkill(SkillEntry.makeSkillEntry(SkillEntryType.NONE, skillId, 1), true);
        }

        player.sendSkillList();
    }

    //public static void RestoreRebornStat(Player player){
//
    //    int REBORN_COUNT = player.getRebirthCount();
    //    RebornSystemInfo info = RebornSystemManager.getRebornId(REBORN_COUNT);
    //    try {
    //        String STR = player.getVar("addSTR");
    //        if (STR != null) {
    //            player.getStat().addFuncs(new FuncAdd(Stats.STAT_STR, 0x60, player, Integer.parseInt(STR), StatsSet.EMPTY));
    //            player.updateStats();
    //        }
    //    } catch (Exception e) {
    //        _log.error("RestoreRebornStat addSTR", e);
    //    }
    //    try {
    //        String INT = player.getVar("addINT");
    //        if (INT != null) {
    //            player.getStat().addFuncs(new FuncAdd(Stats.STAT_INT, 0x60, player, Integer.parseInt(INT), StatsSet.EMPTY));
    //            player.updateStats();
    //        }
    //    } catch (Exception e) {
    //        _log.error("RestoreRebornStat addINT", e);
    //    }
    //    try {
    //        String DEX = player.getVar("addDEX");
    //        if (DEX != null) {
    //            player.getStat().addFuncs(new FuncAdd(Stats.STAT_DEX, 0x60, player, Integer.parseInt(DEX), StatsSet.EMPTY));
    //            player.updateStats();
    //        }
    //    } catch (Exception e) {
    //        _log.error("RestoreRebornStat addDEX", e);
    //    }
    //    try {
    //        String WIT = player.getVar("addWIT");
    //        if (WIT != null) {
    //            player.getStat().addFuncs(new FuncAdd(Stats.STAT_WIT, 0x60, player, Integer.parseInt(WIT), StatsSet.EMPTY));
    //            player.updateStats();
    //        }
    //    } catch (Exception e) {
    //        _log.error("RestoreRebornStat addWIT", e);
    //    }
    //    try {
    //        String CON = player.getVar("addCON");
    //        if (CON != null) {
    //            player.getStat().addFuncs(new FuncAdd(Stats.STAT_CON, 0x60, player, Integer.parseInt(CON), StatsSet.EMPTY));
    //            player.updateStats();
    //        }
    //    } catch (Exception e) {
    //        _log.error("RestoreRebornStat addCON", e);
    //    }
    //    try {
    //        String MEN = player.getVar("addMEN");
    //        if (MEN != null) {
    //            player.getStat().addFuncs(new FuncAdd(Stats.STAT_MEN, 0x60, player, Integer.parseInt(MEN), StatsSet.EMPTY));
    //            player.updateStats();
    //        }
    //    } catch (Exception e) {
    //        _log.error("RestoreRebornStat addMEN", e);
    //    }
    //    try {
    //        String PvePhysDmg = player.getVar("addPvePhysDmg");
    //        if (PvePhysDmg != null) {
    //            player.getStat().addFuncs(new FuncMul(Stats.PVE_PHYS_DMG_BONUS, 0x30, player, (100. + (info.getPvePhysDmg()) * Integer.parseInt(PvePhysDmg)) / 100., StatsSet.EMPTY));
    //            player.getStat().addFuncs(new FuncMul(Stats.PVE_MAGIC_SKILL_DMG_BONUS, 0x30, player, (100. + (info.getPvePhysDmg()) * Integer.parseInt(PvePhysDmg)) / 100., StatsSet.EMPTY));
    //            player.updateStats();
    //        }
    //    } catch (Exception e) {
    //        _log.error("RestoreRebornStat addPvePhysDmg", e);
    //    }
    //    try {
    //        String PveMagDmg = player.getVar("addPveMagDmg");
    //        if (PveMagDmg != null) {
    //            player.getStat().addFuncs(new FuncMul(Stats.PVE_MAGIC_SKILL_DMG_BONUS, 0x30, player, (100. + (info.getPveMagDmg()) * Integer.parseInt(PveMagDmg)) / 100., StatsSet.EMPTY));
    //            player.updateStats();
    //        }
    //    } catch (Exception e) {
    //        _log.error("RestoreRebornStat addPveMagDmg", e);
    //    }
    //    try {
    //        String CHA = player.getVar("addCHA");
    //        if (CHA != null) {
    //            player.getStat().addFuncs(new FuncAdd(Stats.STAT_CHA, 0x60, player, Integer.parseInt(CHA), StatsSet.EMPTY));
    //            player.updateStats();
    //        }
    //    } catch (Exception e) {
    //        _log.error("RestoreRebornStat addCHA", e);
    //    }
    //    try {
    //        String MaxCP = player.getVar("addMaxCP");
    //        if (MaxCP != null) {
    //            player.getStat().addFuncs(new FuncMul(Stats.MAX_CP, 0x30, player, (100. + Integer.parseInt(MaxCP)) / 100., StatsSet.EMPTY));
    //            player.getStat().addFuncs(new FuncMul(Stats.MAX_HP, 0x30, player, (100. + Integer.parseInt(MaxCP)) / 100., StatsSet.EMPTY));
    //            player.getStat().addFuncs(new FuncMul(Stats.MAX_MP, 0x30, player, (100. + Integer.parseInt(MaxCP)) / 100., StatsSet.EMPTY));
    //            player.updateStats();
    //        }
    //    } catch (Exception e) {
    //        _log.error("RestoreRebornStat addMaxCP", e);
    //    }
    //    try {
    //        String MaxHP = player.getVar("addMaxHP");
    //        if (MaxHP != null) {
    //            player.getStat().addFuncs(new FuncMul(Stats.MAX_HP, 0x30, player, (100. + Integer.parseInt(MaxHP)) / 100., StatsSet.EMPTY));
    //            player.updateStats();
    //        }
    //    } catch (Exception e) {
    //        _log.error("RestoreRebornStat addMaxHP", e);
    //    }
    //    try {
    //        String MaxMP = player.getVar("addMaxMP");
    //        if (MaxMP != null) {
    //            player.getStat().addFuncs(new FuncMul(Stats.MAX_MP, 0x30, player, (100. + Integer.parseInt(MaxMP)) / 100., StatsSet.EMPTY));
    //            player.updateStats();
    //        }
    //    } catch (Exception e) {
    //        _log.error("RestoreRebornStat addMaxMP", e);
    //    }
    //    try {
    //        String PhysDmg = player.getVar("addPhysDmg");
    //        if (PhysDmg != null) {
    //            player.getStat().addFuncs(new FuncMul(Stats.POWER_ATTACK, 0x30, player, (100. + (info.getPhysDmg() * Integer.parseInt(PhysDmg))) / 100., StatsSet.EMPTY));
    //            player.updateStats();
    //        }
    //    } catch (Exception e) {
    //        _log.error("RestoreRebornStat addPhysDmg", e);
    //    }
    //    try {
    //        String MagDmg = player.getVar("addMagDmg");
    //        if (MagDmg != null) {
    //            player.getStat().addFuncs(new FuncMul(Stats.MAGIC_ATTACK, 0x30, player, (100. + (info.getMagDmg() * Integer.parseInt(MagDmg))) / 100., StatsSet.EMPTY));
    //            player.updateStats();
    //        }
    //    } catch (Exception e) {
    //        _log.error("RestoreRebornStat addMagDmg", e);
    //    }
    //    try {
    //        String PhysDef = player.getVar("addPhysDef");
    //        if (PhysDef != null) {
    //            player.getStat().addFuncs(new FuncMul(Stats.POWER_DEFENCE, 0x30, player, (100. + (info.getPhysDef() * Integer.parseInt(PhysDef))) / 100., StatsSet.EMPTY));
    //            player.updateStats();
    //        }
    //    } catch (Exception e) {
    //        _log.error("RestoreRebornStat addPhysDef", e);
    //    }
    //    try {
    //        String MagDef = player.getVar("addMagDef");
    //        if (MagDef != null) {
    //            player.getStat().addFuncs(new FuncMul(Stats.MAGIC_DEFENCE, 0x30, player, (100. + (info.getMagDef() * Integer.parseInt(MagDef))) / 100., StatsSet.EMPTY));
    //            player.updateStats();
    //        }
    //    } catch (Exception e) {
    //        _log.error("RestoreRebornStat addMagDef", e);
    //    }
    //    try {
    //        String PhysCritDmg = player.getVar("addPhysCritDmg");
    //        if (PhysCritDmg != null) {
    //            player.getStat().addFuncs(new FuncAdd(Stats.CRITICAL_DAMAGE, 0x30, player, info.getPhysCritDmg() * Integer.parseInt(PhysCritDmg), StatsSet.EMPTY));
    //            player.updateStats();
    //        }
    //    } catch (Exception e) {
    //        _log.error("RestoreRebornStat addPhysCritDmg", e);
    //    }
    //    try {
    //        String MagCritDmg = player.getVar("addMagCritDmg");
    //        if (MagCritDmg != null) {
    //            player.getStat().addFuncs(new FuncAdd(Stats.MAGIC_CRITICAL_DMG, 0x30, player, info.getMagCritDmg() * Integer.parseInt(MagCritDmg), StatsSet.EMPTY));
    //            player.updateStats();
    //        }
    //    } catch (Exception e) {
    //        _log.error("RestoreRebornStat addMagCritDmg", e);
    //    }
    //    try {
    //        String PhysCritRate = player.getVar("addPhysCritRate");
    //        if (PhysCritRate != null) {
    //            player.getStat().addFuncs(new FuncMul(Stats.P_CRITICAL_RATE, 0x30, player, (100. + (info.getPhysCritRate() * Integer.parseInt(PhysCritRate))) / 100., StatsSet.EMPTY));
    //            player.updateStats();
    //        }
    //    } catch (Exception e) {
    //        _log.error("RestoreRebornStat addPhysCritRate", e);
    //    }
    //    try {
    //        String MagCritRate = player.getVar("addMagCritRate");
    //        if (MagCritRate != null) {
    //            player.getStat().addFuncs(new FuncMul(Stats.M_CRITICAL_RATE, 0x30, player, (100. + (info.getMagCritRate() * Integer.parseInt(MagCritRate))) / 100., StatsSet.EMPTY));
    //            player.updateStats();
    //        }
    //    } catch (Exception e) {
    //        _log.error("RestoreRebornStat addMagCritRate", e);
    //    }
    //    try {
    //        String PvpPhysDmg = player.getVar("addPvpPhysDmg");
    //        if (PvpPhysDmg != null) {
    //            player.getStat().addFuncs(new FuncMul(Stats.PVP_PHYS_DMG_BONUS, 0x30, player, (100. + (info.getPvpPhysDmg()) * Integer.parseInt(PvpPhysDmg)) / 100., StatsSet.EMPTY));
    //            player.getStat().addFuncs(new FuncMul(Stats.PVP_MAGIC_SKILL_DMG_BONUS, 0x30, player, (100. + (info.getPvpPhysDmg() * Integer.parseInt(PvpPhysDmg))) / 100., StatsSet.EMPTY));
    //            player.updateStats();
    //        }
    //    } catch (Exception e) {
    //        _log.error("RestoreRebornStat addPvpPhysDmg", e);
    //    }
    //    try {
    //        String PvpMagDmg = player.getVar("addPvpMagDmg");
    //        if (PvpMagDmg != null) {
    //            player.getStat().addFuncs(new FuncMul(Stats.PVP_MAGIC_SKILL_DMG_BONUS, 0x30, player,(100. + (info.getPvpMagDmg() * Integer.parseInt(PvpMagDmg))) / 100., StatsSet.EMPTY));
    //            player.updateStats();
    //        }
    //    } catch (Exception e) {
    //        _log.error("RestoreRebornStat addPvpMagDmg", e);
    //    }
    //    try {
    //        String PvpPhysDef = player.getVar("addPvpPhysDef");
    //        if (PvpPhysDef != null) {
    //            player.getStat().addFuncs(new FuncMul(Stats.PVP_PHYS_DEFENCE_BONUS, 0x30, player, (100. + (info.getPvpPhysDef()) * Integer.parseInt(PvpPhysDef)) / 100., StatsSet.EMPTY));
    //            player.getStat().addFuncs(new FuncMul(Stats.PVP_MAGIC_SKILL_DEFENCE_BONUS, 0x30, player, (100. + (info.getPvpPhysDef() * Integer.parseInt(PvpPhysDef))) / 100., StatsSet.EMPTY));
    //            player.updateStats();
    //        }
    //    } catch (Exception e) {
    //        _log.error("RestoreRebornStat addPvpPhysDef", e);
    //    }
    //    try {
    //        String PvpMagDef = player.getVar("addPvpMagDef");
    //        if (PvpMagDef != null) {
    //            player.getStat().addFuncs(new FuncMul(Stats.PVP_MAGIC_SKILL_DEFENCE_BONUS, 0x30, player, (100. + (info.getPvpMagDef() * Integer.parseInt(PvpMagDef))) / 100., StatsSet.EMPTY));
    //            player.updateStats();
    //        }
    //    } catch (Exception e) {
    //        _log.error("RestoreRebornStat addPvpMagDef", e);
    //    }
    //    try {
    //        String MReuse = player.getVar("addMReuse");
    //        if (MReuse != null) {
    //            player.getStat().addFuncs(new FuncMul(Stats.MAGIC_REUSE_RATE, 0x30, player, (100. + (info.getMReuse() * Integer.parseInt(MReuse))) / 100., StatsSet.EMPTY));
    //            player.updateStats();
    //        }
    //    } catch (Exception e) {
    //        _log.error("RestoreRebornStat addMReuse", e);
    //    }
    //    try {
    //        String AdenaRate = player.getVar("addAdenaRate");
    //        if (AdenaRate != null) {
    //            player.getStat().addFuncs(new FuncAdd(Stats.ADENA_RATE_MULTIPLIER, 0x40, player, 0. + (info.getAdenaRate() * Integer.parseInt(AdenaRate)) / 100., StatsSet.EMPTY));
    //            player.updateStats();
    //        }
    //    } catch (Exception e) {
    //        _log.error("RestoreRebornStat addAdenaRate", e);
    //    }
    //    try {
    //        String ExpRate = player.getVar("addExpRate");
    //        if (ExpRate != null) {
    //            player.getStat().addFuncs(new FuncAdd(Stats.EXP_RATE_MULTIPLIER, 0x40, player, 0. + (info.getAdenaRate() * Integer.parseInt(ExpRate)) / 100., StatsSet.EMPTY));
    //            player.updateStats();
    //        }
    //    } catch (Exception e) {
    //        _log.error("RestoreRebornStat addExpRate", e);
    //    }
    //    try {
    //        String DropRate = player.getVar("addDropRate");
    //        if (DropRate != null) {
    //            player.getStat().addFuncs(new FuncAdd(Stats.DROP_RATE_MULTIPLIER, 0x40, player, 0. + (info.getAdenaRate() * Integer.parseInt(DropRate)) / 100., StatsSet.EMPTY));
    //            player.updateStats();
    //        }
    //    } catch (Exception e) {
    //        _log.error("RestoreRebornStat addDropRate", e);
    //    }
    //    try {
    //        String SoulShotPowerRate = player.getVar("addSoulShotPowerRate", null);
    //        if (SoulShotPowerRate != null) {
    //            player.getStat().addFuncs(new FuncMul(Stats.SOULSHOT_POWER, 0x30, player, (100. + (info.getSoulShotPowerRate() * Integer.parseInt(SoulShotPowerRate))) / 100., StatsSet.EMPTY));
    //            player.updateStats();
    //        }
    //    } catch (Exception e) {
    //        _log.error("RestoreRebornStat addSoulShotPowerRate", e);
    //    }
    //    try {
    //        String SpiritShotPowerRate = player.getVar("addSpiritShotPowerRate", null);
    //        if (SpiritShotPowerRate != null) {
    //            player.getStat().addFuncs(new FuncMul(Stats.SPIRITSHOT_POWER, 0x30, player, (100. + (info.getSpiritShotPowerRate() * Integer.parseInt(SpiritShotPowerRate))) / 100., StatsSet.EMPTY));
    //            player.updateStats();
    //        }
    //    } catch (Exception e) {
    //        _log.error("RestoreRebornStat addSpiritShotPowerRate", e);
    //    }
    //}
}