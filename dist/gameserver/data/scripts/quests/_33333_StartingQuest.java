//package quests;
//
//import l2s.commons.util.Rnd;
//import l2s.gameserver.data.QuestHolder;
//import l2s.gameserver.data.xml.holder.SkillHolder;
//import l2s.gameserver.model.Player;
//import l2s.gameserver.model.Skill;
//import l2s.gameserver.model.base.Experience;
//import l2s.gameserver.model.instances.NpcInstance;
//import l2s.gameserver.model.quest.Quest;
//import l2s.gameserver.model.quest.QuestState;
//
//import java.util.Arrays;
//
//public class _33333_StartingQuest extends Quest {
//    // NPC
//    private static final int SHANON = 32974;
//    private static final int ZOMBIE_WORKER = 22140;
//    private static final int BRATTY_ANGMA = 19274;
//
//    // Items
//    private static final int DRAGON_BLOOD = 110001;
//    private static final int DRAGON_BLOOD_CNT = 30;
//    private static final int DRAGON_BLOOD_DROP_CHANCE = 70;
//    private static final int ZOMBIE_HEARTH = 110000;
//    private static final int ZOMBIE_HEARTH_CNT = 10;
//    private static final int ZOMBIE_HEARTH_DROP_CHANCE = 57;
//
//    private static final int REWARD_ONE = 1835;
//    private static final int REWARD_TWO = 2509;
//    private static final int REWARD_LEVEL_10 = 10;
//    private static final int REWARD_LEVEL_20 = 20;
//    private static final int NEWBIE_RUNE = 70067;
//
//    // Buffs
//    private static int[] BUFF_LIST = {
//		1504, 1500, 1501, 1502, 1519, 4699, 4703
//    };
//
//    public _33333_StartingQuest() {
//        super(PARTY_ONE, ONETIME);
//        addStartNpc(SHANON);
//        addKillId(ZOMBIE_WORKER, BRATTY_ANGMA);
//    }
//
//    @Override
//    public String onKill(NpcInstance npc, QuestState st) {
//        Player player = st.getPlayer();
//        if (player == null)
//            return null;
//
//        switch (npc.getNpcId()) {
//            case ZOMBIE_WORKER: {
//                if (st.getCond() == 1) {
//                    if (Rnd.chance(ZOMBIE_HEARTH_DROP_CHANCE)) {
//                        st.giveItems(ZOMBIE_HEARTH, 1);
//                        st.playSound(SOUND_ITEMGET);
//                    }
//
//                    long itemCnt = st.getQuestItemsCount(ZOMBIE_HEARTH);
//                    if (itemCnt >= ZOMBIE_HEARTH_CNT) {
//                        st.setCond(2, true); // go talk to shanon
//                        st.playSound(SOUND_MIDDLE);
//                        return null;
//                    }
//                }
//                break;
//            }
//            case BRATTY_ANGMA: {
//                if (st.getCond() == 4) {
//                    if (Rnd.chance(DRAGON_BLOOD_DROP_CHANCE)) {
//                        st.giveItems(DRAGON_BLOOD, 1);
//                        st.playSound(SOUND_ITEMGET);
//                    }
//
//                    long itemCnt = st.getQuestItemsCount(DRAGON_BLOOD);
//                    if (itemCnt >= DRAGON_BLOOD_CNT) {
//                        st.setCond(5, true);
//                        st.playSound(SOUND_MIDDLE);
//                        return null;
//                    }
//                }
//                break;
//            }
//        }
//        return super.onKill(npc, st);
//    }
//
//    @Override
//    public String onTalk(NpcInstance npc, QuestState qs) {
//        if (qs.isNotAccepted()) {
//            Quest quest = QuestHolder.getInstance().getQuest(33333);
//            Player player = qs.getPlayer();
//            qs = quest.newQuestState(player);
//            qs.setCond(0, true); // accept
//            return "shenon_q33333_01.htm";
//        }
//        else if (qs.getCond() == 1) {
//            long itemCnt = qs.getQuestItemsCount(ZOMBIE_HEARTH);
//            if (itemCnt < ZOMBIE_HEARTH_CNT) {
//                return "shenon_q33333_02_waiting.htm";
//            }
//        } else if (qs.getCond() == 2) {
//            return "shenon_q33333_02_finished.htm";
//        } else if (qs.getCond() == 3) {
//            return "shenon_q33333_03.htm";
//        } else if (qs.getCond() == 4) {
//            long itemCnt = qs.getQuestItemsCount(DRAGON_BLOOD);
//            if (itemCnt >= DRAGON_BLOOD_CNT) {
//                return "shenon_q33333_03_finished.htm";
//            } else {
//                return "shenon_q33333_03_waiting.htm";
//            }
//        } else if (qs.getCond() == 5) {
//            return "shenon_q33333_04.htm";
//        }
//
//        return null;
//    }
//
//    @Override
//    public String onEvent(String event, QuestState qs, NpcInstance npc) {
//        Player player = qs.getPlayer();
//        if (player == null)
//            return null;
//        switch (event) {
//            case "shenon_q33333_02_ok.htm": {
//                qs.setCond(1);
//                qs.playSound(SOUND_MIDDLE);
//                return event;
//            }
//            case "shenon_q33333_03_ok.htm": {
//                qs.setCond(4);
//                qs.playSound(SOUND_MIDDLE);
//                return event;
//            }
//            case "shenon_q33333_02_reward.htm": {
//                if (qs.getCond() < 3) {
//                    // set level to 10
//                    long expReward = calcExpReward(player, REWARD_LEVEL_10);
//                    if (expReward > 0) {
//                        player.addExpAndSp(expReward, 0);
//                    }
//                    // give reward 5k each
//                    qs.giveItems(REWARD_ONE, 5000L);
//                    qs.giveItems(REWARD_TWO, 5000L);
//
//                    qs.setCond(3);
//                    qs.playSound(SOUND_MIDDLE);
//                    return "shenon_q33333_03.htm";
//                }
//            }
//            case "shenon_q33333_03_reward.htm": {
//                if (qs.getCond() < 5) {
//                    long expReward = calcExpReward(player, REWARD_LEVEL_20);
//                    if (expReward > 0) {
//                        player.addExpAndSp(expReward, 0);
//                    }
//
//                    applyBuffList(player);
//                    qs.giveItems(NEWBIE_RUNE, 1L);
//                    qs.setCond(5);
//                    qs.finishQuest();
//                    return "shenon_q33333_04.htm";
//                }
//            }
//            case "shenon_q33333_02.htm":
//            case "shenon_q33333_03.htm": {
//                return event;
//            }
//        }
//        return super.onEvent(event, qs, npc);
//    }
//
//    private void applyBuffList(Player player) {
//        Arrays.stream(BUFF_LIST).forEach(buffId -> {
//            Skill skill = SkillHolder.getInstance().getSkill(buffId, 1);
//            // apply effects
//            if (skill != null) {
//                skill.getEffects(player, player, 600, 1.0);
//            }
//        });
//    }
//
//    private long calcExpReward(Player player, int level) {
//        // get exp for 10 lvl
//        long expForLevel = Experience.getExpForLevel(level);
//        return player.getLevel() >= level ? 0 : expForLevel - player.getExp();
//    }
//}
