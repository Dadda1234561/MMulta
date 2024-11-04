package l2s.gameserver.model.actor.basestats;

import l2s.gameserver.model.Creature;
import l2s.gameserver.stats.Stats;
import l2s.gameserver.utils.NpcUtils;

/**
 * @author sharp on 14.02.2023
 * t.me/sharp1que
 */
public class RaidBossBaseStat extends CreatureBaseStats
{
    public RaidBossBaseStat(Creature owner)
    {
        super(owner);
    }

    @Override
    public double getHpMax()
    {
        double maxHP = super.getHpMax();
        maxHP *= NpcUtils.getRaidStatMod(Stats.MAX_HP, getOwner());
        return maxHP;
    }

    @Override
    public double getPAtk()
    {
        double pAtk = super.getPAtk();
        pAtk *= NpcUtils.getRaidStatMod(Stats.POWER_ATTACK, getOwner());
        return pAtk;
    }

    @Override
    public double getMAtk()
    {
        double mAtk = super.getMAtk();
        mAtk *= NpcUtils.getRaidStatMod(Stats.MAGIC_ATTACK, getOwner());
        return mAtk;
    }

    @Override
    public double getPDef()
    {
        double result = super.getPDef();
        result *= NpcUtils.getRaidStatMod(Stats.POWER_DEFENCE, getOwner());
        return result;
    }

    @Override
    public double getMDef()
    {
        double result = super.getMDef();
        result *= NpcUtils.getRaidStatMod(Stats.MAGIC_DEFENCE, getOwner());
        return result;
    }

    @Override
    public double getPAtkSpd()
    {
        double pAtkSpd = super.getPAtkSpd();
        pAtkSpd *= NpcUtils.getRaidStatMod(Stats.POWER_ATTACK_SPEED, getOwner());
        return pAtkSpd;
    }

    @Override
    public double getMAtkSpd()
    {
        double mAtkSpd = super.getMAtkSpd();
        mAtkSpd *= NpcUtils.getRaidStatMod(Stats.MAGIC_ATTACK_SPEED, getOwner());
        return mAtkSpd;
    }

    @Override
    public double getRunSpd()
    {
        double runSpd = super.getRunSpd();
        runSpd *= NpcUtils.getRaidStatMod(Stats.RUN_SPEED, getOwner());
        return runSpd;
    }
}
