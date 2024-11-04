package l2s.gameserver.model.base;

import l2s.gameserver.ThreadPoolManager;
import l2s.gameserver.model.Player;
import l2s.gameserver.model.World;
import l2s.gameserver.model.items.GearScoreType;
import l2s.gameserver.model.items.ItemInstance;
import l2s.gameserver.network.l2.s2c.ExItemScore;
import l2s.gameserver.skills.SkillEntry;
import l2s.gameserver.templates.item.ItemTemplate;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.util.Map;
import java.util.concurrent.ScheduledFuture;
import java.util.concurrent.atomic.AtomicInteger;

public class GearScore {

    private static final boolean DEBUG = true; // ВЫКЛЮЧИТЬ ПОСЛЕ ОТЛАДКИ

    private static final Logger LOGGER = LoggerFactory.getLogger(GearScore.class);

    private final Player _owner;
    private final AtomicInteger _score = new AtomicInteger(0);

    private ScheduledFuture<?> _updateTask = null;

    public GearScore(Player player) {
        _owner = player;
    }

    public int getPoints() {
        return _score.get();
    }

    public void refreshGearScore(boolean sendSelfUpdate, boolean broadcastInfo) {
        int myCurrentScore = _score.get();

        // Item scores
        int itemScore = calculateItemScore();
        DEBUG("[ITEM_SCORE] for player: " + _owner.getName() + " is: " + myCurrentScore);
        int skillScore = calculateSkillScore();
        DEBUG("[SKILL_SCORE] for player: " + _owner.getName() + " is: " + myCurrentScore);

        // Set myCurrentScore
        int totalScore = skillScore + itemScore;
        if (totalScore == 0 || totalScore != myCurrentScore || sendSelfUpdate)
        {
            // Check if there is an active update task
            if (_updateTask != null) {
                return;
            }

            _score.set(totalScore);
            DEBUG("[GEAR_SCORE]: Set " + _owner.getName() + " score to " + totalScore);
            // schedule new broadcast
            if (sendSelfUpdate || broadcastInfo) {
                _updateTask = ThreadPoolManager.getInstance().schedule(() -> {
                    if (sendSelfUpdate) {
                        _owner.sendPacket(new ExItemScore(_score.get()));
                        DEBUG("[GEAR_SCORE]: Send update packet to player " + _owner.getName());
                    }
                    if (broadcastInfo) {
                        _owner.broadcastCharInfo();
                    }
                    _updateTask = null;
                }, 333);
            }
        }
    }

    private int calculateSkillScore() {
        int score = 0;
        for (SkillEntry skillEntry : _owner.getAllSkills()) {
            if (skillEntry.getTemplate().hasNoGearScore()) {
                continue;
            }
            score += skillEntry.getTemplate().getGearScore(GearScoreType.GS_HAS_SKILL, skillEntry.getId());
            DEBUG("[HAVE_SKILL][" + _owner.getName() + "] Skill: " + skillEntry.getName() + " has score: " + skillEntry.getTemplate().getGearScore(GearScoreType.GS_HAS_SKILL, skillEntry.getId()));
            score += skillEntry.getTemplate().getGearScore(skillEntry.getLevel());
            DEBUG("[ENCHANT_SKILL][" + _owner.getName() + "] Skill: " + skillEntry.getName() + " has score: " + skillEntry.getTemplate().getGearScore(GearScoreType.GS_HAS_ENCHANTED_SKILL, skillEntry.getId()));
        }
        return score;
    }

    private int calculateItemScore() {
        DEBUG("Calculating item score for player: " + _owner.getName() + " with current score: " + 0);
        int score = 0;
        for (ItemInstance item : _owner.getInventory().getItems()) {
            if (item == null || !item.isEquipped() || item.getTemplate().hasNoGearScore()) {
                continue;
            }
            for (GearScoreType type : GearScoreType.values()) {
                if (isValidGSCondition(type, item)) {
                    score += item.getTemplate().getGearScore(type, item.getEnchantLevel());
                    DEBUG("[BASE_GEARSCORE]: Item: " + item.getName() + " with enchant level: " + item.getEnchantLevel() + " has score: " + item.getTemplate().getGearScore(type, item.getEnchantLevel()));
                }
            }
        }
        return score;
    }

    private void DEBUG(String msg) {
        if (!DEBUG) {
            return;
        }
        if (_owner.isGM()) {
            _owner.sendMessage(msg);
            LOGGER.info(msg);
        }
    }


    private boolean isValidGSCondition(GearScoreType type, ItemInstance item)
    {
        ItemTemplate template = item.getTemplate();
        if (template == null) return false;
        switch (type) {
            case GS_BASE:
                return true;
            case GS_NORMAL:
                return !template.hasNoGearScore() && template.getGearScore(GearScoreType.GS_NORMAL, item.getEnchantLevel()) > 0;
            case GS_ANY_ENSOUL:
                return !item.getNormalEnsoulsMap().isEmpty() || !item.getSpecialEnsoulsMap().isEmpty();
            case GS_ANY_VARIATION:
                return item.getVariationStoneId() > 0;
            case GS_BLESS:
                return item.isBlessed();
            case GS_VARIATION_BY_MINERAL_ID:
                return item.getVariationStoneId() == template.getGearScore(GearScoreType.GS_VARIATION_BY_MINERAL_ID, -1);
            case GS_VARIATION_BY_OPTION_ID:
                return item.getVariation1Id() == template.getGearScore(GearScoreType.GS_VARIATION_BY_OPTION_ID, -1) || item.getVariation2Id() == template.getGearScore(GearScoreType.GS_VARIATION_BY_OPTION_ID, -1);
            case GS_ANY_ENSOUL_BY_OPTION_ID:
                return item.containsEnsoul(0, template.getGearScore(GearScoreType.GS_ANY_ENSOUL_BY_OPTION_ID, -1)) || item.containsEnsoul(1, template.getGearScore(GearScoreType.GS_ANY_ENSOUL_BY_OPTION_ID, -1));
            case GS_HAS_SKILL:
            case GS_HAS_ENCHANTED_SKILL:
                Player player = World.getPlayer(item.getOwnerId());
                if (player == null) return false;
                Map<Integer, Integer> gearScore = template.getGearScores(GearScoreType.GS_HAS_SKILL);
                for (Map.Entry<Integer, Integer> itemEntry : gearScore.entrySet()) {
                    if (type.equals(GearScoreType.GS_HAS_ENCHANTED_SKILL) && player.getSkillLevel(itemEntry.getKey()) >= itemEntry.getValue()) {
                        return true;
                    } else if (type.equals(GearScoreType.GS_HAS_SKILL) && player.getKnownSkill(itemEntry.getKey()) != null) {
                        return true;
                    }
                }
                return false;
            case GS_NONE:
            default:
                return false;
        }
    }
}
