package l2s.gameserver.model.items;

import java.util.EnumSet;

public enum GearScoreType {

    GS_NONE(-100),
    GS_BASE(-2),
    GS_NORMAL(-1),
    GS_ANY_VARIATION(0),
    GS_VARIATION_BY_MINERAL_ID(0),
    GS_VARIATION_BY_OPTION_ID(1),
    GS_ANY_ENSOUL(2),
    GS_ANY_ENSOUL_BY_OPTION_ID(3),
    GS_BLESS(4),
    GS_HAS_SKILL(5),
    GS_HAS_ENCHANTED_SKILL(6);

    private final int _type;


    GearScoreType(int type) {
        _type = type;
    }

    public static EnumSet<GearScoreType> VALUES = EnumSet.range(GearScoreType.GS_BASE, GS_HAS_ENCHANTED_SKILL);

    public int getType() {
        return _type;
    }
}
