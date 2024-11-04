package quests;

import l2s.commons.util.Rnd;
import l2s.gameserver.data.QuestHolder;
import l2s.gameserver.data.xml.holder.SkillHolder;
import l2s.gameserver.model.Player;
import l2s.gameserver.model.Skill;
import l2s.gameserver.model.base.Experience;
import l2s.gameserver.model.instances.NpcInstance;
import l2s.gameserver.model.items.ItemInstance;
import l2s.gameserver.model.quest.Quest;
import l2s.gameserver.model.quest.QuestPartyType;
import l2s.gameserver.model.quest.QuestRepeatType;
import l2s.gameserver.model.quest.QuestState;
import l2s.gameserver.network.telnet.commands.TelnetDebug;
import l2s.gameserver.skills.SkillEntry;
import l2s.gameserver.skills.SkillEntryType;

import java.util.Arrays;

public class _030_MultiImperiaStartingQuest extends Quest {
    // NPC
    private static final int PANTEON = 32972;
    private static final int TEODOR = 32975;
    private static final int SHENON = 32974;
    private static final int IVEIN = 33464;
    private static final int SOFIA = 33124;
    private static final int ARCHAEOLOGIST = 33448;
    private static final int EINDBRANCH = 32469;
    private static final int RACKSIS = 32977;
    private static final int CHEST = 8710;



    // Monsters
    private static final int WARRIOR_FOX = 13440;
    private static final int WIZARD_FOX = 13441;
    private static final int RED_STONE = 18685;
    private static final int BLUE_STONE = 18688;
    private static final int GREEN_STONE = 18691;


    // Items
    private static final int SCARECROW = 27457;
    private static final int SCARECROW_ITEM = 106506;
    private static final int SCARECROW_COUNT = 5;
    private static final int TOKEN = 106512;

    private static final int RED_STONE_ITEM = 106510;
    private static final int BLUE_STONE_ITEM = 106511;
    private static final int GREEN_STONE_ITEM = 106509;
    private static final int STONE_COUNT = 5;
    private static final int MULTIIMPERIA_COINT = 106513;




    private static final int WARRIOR_FOX_ITEM = 106507;
    private static final int WIZARD_FOX_ITEM = 106508;
    private static final int FOX_COUNT = 10;


    //
    private static int[] BUFF_LIST = {
            1504, 1500, 1501, 1502, 1519, 4699, 4703, 1499
    };

    public _030_MultiImperiaStartingQuest() {
        super(PARTY_NONE, ONETIME);
        addStartNpc(TEODOR, PANTEON, SHENON, IVEIN, SOFIA, EINDBRANCH, ARCHAEOLOGIST, RACKSIS, CHEST);
        addKillId(SCARECROW, WARRIOR_FOX, WIZARD_FOX,RED_STONE, GREEN_STONE, BLUE_STONE);

    }


//    @Override
//    public String onAttack(NpcInstance npc, QuestState qs)
//    {
//
//        }
//        return super.onAttack(npc, qs);
//    }

    @Override
    public String onKill(NpcInstance npc, QuestState qs) {
        Player player = qs.getPlayer();
        int cond = qs.getCond();
        if (player == null)
            return null;

        switch (npc.getNpcId()) {
            case SCARECROW:
                if(cond == 5) {
                    long itemCnt = qs.getQuestItemsCount(SCARECROW_ITEM);
                    if(itemCnt < SCARECROW_COUNT) {
                        qs.giveItems(SCARECROW_ITEM, 1);
                        qs.playSound(SOUND_ITEMGET);
                    }
                    if(qs.getQuestItemsCount(SCARECROW_ITEM) == 5){
                        qs.setCond(6, true); // go talk to SHEN
                        qs.playSound(SOUND_MIDDLE);
                    }
                }
                break;
            case WIZARD_FOX:
                if(cond == 9) {
                    if (qs.getQuestItemsCount(WIZARD_FOX_ITEM) < 10) {
                        qs.giveItems(WIZARD_FOX_ITEM, 1);
                        qs.playSound(SOUND_ITEMGET);
                        checkCompleteFox(qs, player);
                    }
                }
                break;
            case WARRIOR_FOX:
                if(cond == 9) {
                    if (qs.getQuestItemsCount(WARRIOR_FOX_ITEM) < 10) {
                        qs.giveItems(WARRIOR_FOX_ITEM, 1);
                        qs.playSound(SOUND_ITEMGET);
                        checkCompleteFox(qs, player);
                    }
                }
                break;

        }
        if(qs.getCond() == 14 && qs.getPlayer().getActiveWeaponInstance().getItemId() == 167) {
            switch (npc.getNpcId()) {
                case RED_STONE:
                    if (qs.getQuestItemsCount(RED_STONE_ITEM) < 5) {
                        qs.giveItems(RED_STONE_ITEM, 1);
                        qs.playSound(SOUND_ITEMGET);
                        checkStoneItems(qs, qs.getPlayer());
                    }
                    break;
                case GREEN_STONE:
                    if (qs.getQuestItemsCount(GREEN_STONE_ITEM) < 5) {
                        qs.giveItems(GREEN_STONE_ITEM, 1);
                        qs.playSound(SOUND_ITEMGET);
                        checkStoneItems(qs, qs.getPlayer());
                    }
                    break;
                case BLUE_STONE:
                    if (qs.getQuestItemsCount(BLUE_STONE_ITEM) < 5) {
                        qs.giveItems(BLUE_STONE_ITEM, 1);
                        qs.playSound(SOUND_ITEMGET);
                        checkStoneItems(qs, qs.getPlayer());
                    }
                    break;
            }
        }
        return super.onKill(npc, qs);
    }

    @Override
    public String onTalk(NpcInstance npc, QuestState qs) {
        String htmltext = NO_QUEST_DIALOG;
        Player player = qs.getPlayer();
        Quest quest = QuestHolder.getInstance().getQuest(30);
        int npcId = npc.getNpcId();
        int cond = qs.getCond();

        if(npcId == PANTEON) {
            if (cond == 2) {
                htmltext = "MultiImperia_030_01.htm";
            } else{
                qs = quest.newQuestState(player);
                qs.setCond(2, true); // бежим к теодору
                htmltext = "MultiImperia_030_02.htm";
            }
        }

        else if (npcId == TEODOR) {
            if(cond == 2) {
                htmltext = "MultiImperia_030_03.htm";
            }
            else {
                htmltext = "MultiImperia_030_05.htm";
            }
        }

        else if (npcId == SHENON) {
            if(cond == 3){
                htmltext = "MultiImperia_030_06.htm";
            } else if (cond == 4) {
                htmltext = "MultiImperia_030_07.htm";
            } else if(cond == 6){
                ItemInstance questitems = player.getInventory().getItemByItemId(SCARECROW_ITEM);
                player.getInventory().destroyItem(questitems, questitems.getCount());


                htmltext = "MultiImperia_030_09.htm";
                applyBuffList(player);
                long expReward = calcExpReward(player, 6);
                if (expReward > 0) {
                    player.addExpAndSp(expReward, 0);
                }
                qs.giveItems(MULTIIMPERIA_COINT, 10);
                qs.setCond(7,true); // к софе за стальным петухом
                qs.playSound(SOUND_MIDDLE);
            }
            else {
                htmltext = "MultiImperia_030_09.htm";
            }
        }

        else if (npcId == IVEIN) {
            if (cond == 4)
                htmltext = "MultiImperia_030_08.htm";
        }

        else if(npcId == SOFIA){
            if(cond == 7) {
                qs.setCond(8, true);
                qs.playSound(SOUND_MIDDLE);
                htmltext = "MultiImperia_030_10.htm";
            }
            else if(cond >= 7 && cond < 11)
                htmltext = "MultiImperia_030_10.htm";
            else if(cond == 11){
                qs.setCond(12, true); //
                qs.playSound(SOUND_MIDDLE);
                htmltext = "MultiImperia_030_14.htm";
                long expReward = calcExpReward(player, 12);
                if (expReward > 0) {
                    player.addExpAndSp(expReward, 0);
                }
                qs.giveItems(MULTIIMPERIA_COINT, 10);
            }
            else if (cond == 12) {
                htmltext = "MultiImperia_030_14.htm";
            }
            else if (cond == 16) {
                qs.setCond(17, true); // Заключительное путешествие
                qs.playSound(SOUND_MIDDLE);
                htmltext = "MultiImperia_030_18.htm";
            }
            else if (cond == 17 || cond == 18) {
                htmltext = "MultiImperia_030_18.htm";
            }
            SkillEntry.makeSkillEntry(SkillEntryType.NONE, 9204, 1).getEffects(player, player);
        }

        else if (npcId == EINDBRANCH) {
            if(cond == 8){
                htmltext = "MultiImperia_030_11.htm"; // найти Эйнбранча
            }
            else if(cond == 9){
                htmltext = "MultiImperia_030_12.htm"; // убить лисов
            } else if (cond == 10) {
                qs.setCond(11, true); // возвращаемся к Софье за транспортом
                qs.playSound(SOUND_MIDDLE);
                ItemInstance wizardFoxItem = player.getInventory().getItemByItemId(WIZARD_FOX_ITEM);
                ItemInstance warriorFixItem = player.getInventory().getItemByItemId(WARRIOR_FOX_ITEM);
                player.getInventory().destroyItem(wizardFoxItem, wizardFoxItem.getCount());
                player.getInventory().destroyItem(warriorFixItem, warriorFixItem.getCount());
                htmltext = "MultiImperia_030_13.htm"; // сдать лисов
            }
            else if (cond >= 11){
                htmltext = "MultiImperia_030_13.htm"; // сдать лисов
            }
        }

        else if (npcId == ARCHAEOLOGIST) {
            if(cond == 13){
                htmltext = "MultiImperia_030_15.htm"; //
            }
            if(cond >= 15) {
                htmltext = "MultiImperia_030_17.htm"; //
                if(cond == 15) {
                    ItemInstance redStone = player.getInventory().getItemByItemId(RED_STONE_ITEM);
                    ItemInstance greenStone = player.getInventory().getItemByItemId(GREEN_STONE_ITEM);
                    ItemInstance blueStone = player.getInventory().getItemByItemId(BLUE_STONE_ITEM);
                    player.getInventory().destroyItem(redStone, redStone.getCount());
                    player.getInventory().destroyItem(greenStone, greenStone.getCount());
                    player.getInventory().destroyItem(blueStone, blueStone.getCount());
                    long expReward = calcExpReward(player, 16);
                    if (expReward > 0) {
                        player.addExpAndSp(expReward, 0);
                    }
                    qs.giveItems(MULTIIMPERIA_COINT, 10);

                    qs.setCond(16, true);
                }
            }
        }

        else if(npcId == RACKSIS){
            if(cond == 18 || cond == 17){
                htmltext = "MultiImperia_030_19.htm"; //
                qs.setCond(19, true); // поиск Жетона
            }
            else if (cond == 19)
                htmltext = "MultiImperia_030_19.htm"; //
            else if(cond == 20){
                htmltext = "MultiImperia_030_20.htm";

            }
            else return "";
        }

        else if(npcId == CHEST){
            if (cond == 19){
                if(Rnd.get(100) < 50){
                    qs.giveItems(TOKEN, 1);
                    qs.setCond(20, true); // Отдайте жетон Раксису
                    qs.playSound(SOUND_MIDDLE);
                }
                npc.doDie(player);
                htmltext = null;
            }
        }
        return htmltext;

    }

    @Override
    public String onEvent(String event, QuestState qs, NpcInstance npc) {
        Player player = qs.getPlayer();
        if (player == null)
            return null;

        int npcId = npc.getNpcId();
        int cond = qs.getCond();


        if(npcId == PANTEON) {
            if(event.equalsIgnoreCase("MultiImperia_030_01.htm")){
                if(cond < 1) {
                    qs.setCond(1);
                    qs.playSound(SOUND_MIDDLE);

                }
                event = "MultiImperia_030_02.htm";
            }
        }

        if(npcId == TEODOR) {
            if(cond == 2) {
                if (event.equalsIgnoreCase("MultiImperia_030_03.htm")) {
                    event = "MultiImperia_030_04.htm";
                }
                else if (event.equalsIgnoreCase("MultiImperia_030_04.htm")) {
                    qs.setCond(3, true); // найти шенон
                   qs.giveItems(22086, 5000); // soulshot
                   qs.giveItems(3952, 2500); // spiritshot
                    qs.giveItems(MULTIIMPERIA_COINT, 5);

                    qs.playSound(SOUND_MIDDLE);
                    event = "MultiImperia_030_05.htm";
                }
            }
            else {
                event = "MultiImperia_030_05.htm";
            }
        }

        else if(npcId == SHENON){
            if(cond == 3){
                qs.setCond(4, true);
                qs.playSound(SOUND_MIDDLE);
                qs.giveItems(MULTIIMPERIA_COINT, 5);
            }
            event = "MultiImperia_030_07.htm";
        }

        else if (npcId == IVEIN) {
            if(cond == 4){
                qs.setCond(5, true);
                qs.playSound(SOUND_MIDDLE);
                return null;
            }
        }

        else if (npcId == SOFIA) {
            if(cond == 12){
                qs.setCond(13, true); // посылают к нпс “Гном Археолог” [ID 33448] - Изменить название на Гном Археолог и поменять скин на ID 32508.
                qs.playSound(SOUND_MIDDLE);
            }
            else if(cond == 17 || cond == 16){
                qs.setCond(18, true);
//                qs.playSound(SOUND_MIDDLE);
            }
            SkillEntry.makeSkillEntry(SkillEntryType.NONE, 9204, 1).getEffects(player, player);
            return null;
        }

        else if(npcId == EINDBRANCH){
            if(cond == 8){
                qs.setCond(9, true); // убить лисов
                qs.playSound(SOUND_MIDDLE);
                return null;
            }
        }

        else if(npcId == ARCHAEOLOGIST){
            if(cond == 13){
                qs.setCond(14, true); // получить кирку
                qs.giveItems(167, 1);
                qs.playSound(SOUND_MIDDLE);
                return null;
            } else if (cond == 14) {
                event = "MultiImperia_030_16.htm";
            }
        }

        else if (npcId == RACKSIS) {
            if(cond == 20) {
                long expReward = calcExpReward(player, 20);
                if (expReward > 0) {
                    player.addExpAndSp(expReward, 0);
                }
                qs.playSound(SOUND_FINISH);
                qs.giveItems(MULTIIMPERIA_COINT, 10);
                qs.giveItems(70067, 1);
                ItemInstance token = player.getInventory().getItemByItemId(TOKEN);
                player.getInventory().destroyItem(token, token.getCount());
                qs.unset("cond");
                qs.finishQuest();
                event = null;

            }
        }

        return event;
    }

    private void applyBuffList(Player player) {
        for(int skillId : BUFF_LIST){
            Skill skill = SkillHolder.getInstance().getSkill(skillId, 1);
            if (skill != null) {
                skill.getEffects(player, player, true);
            }
        }
    }

    private void checkCompleteFox(QuestState qs, Player player){
        long warriorItemCnt = qs.getQuestItemsCount(WARRIOR_FOX_ITEM);
        long wizardItemCnt = qs.getQuestItemsCount(WIZARD_FOX_ITEM);
        if (warriorItemCnt >= FOX_COUNT && wizardItemCnt >= FOX_COUNT) {
            qs.setCond(10, true); // go talk to Эйндбранч
            qs.playSound(SOUND_MIDDLE);
        }

    }

    private void checkStoneItems(QuestState qs, Player player){
        long redStoneCnt = qs.getQuestItemsCount(RED_STONE_ITEM);
        long greenStoneCnt = qs.getQuestItemsCount(GREEN_STONE_ITEM);
        long blueStoneCnt = qs.getQuestItemsCount(BLUE_STONE_ITEM);
        if (redStoneCnt == STONE_COUNT && greenStoneCnt == STONE_COUNT && blueStoneCnt == STONE_COUNT) {
            qs.setCond(15, true); // Руда собрана, сдать гному
            qs.playSound(SOUND_MIDDLE);
        }
    }

    private long calcExpReward(Player player, int level) {
        long expForLevel = Experience.getExpForLevel(level);
        return player.getLevel() >= level ? 0 : expForLevel - player.getExp();
    }
}
