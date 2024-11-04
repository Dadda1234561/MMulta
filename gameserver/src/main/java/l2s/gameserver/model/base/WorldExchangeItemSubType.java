package l2s.gameserver.model.base;

public enum WorldExchangeItemSubType
{

    Weapon(0),
    Armor(1),
    Accessary(2),
    EtcEquipment(3),
    ArtifactB1(4),
    ArtifactC1(5),
    ArtifactD1(6),
    ArtifactA1(7),
    ENCHANTSCROLL(8),
    BlessEnchantScroll(9),
    MultiEnchantScroll(10),
    AncientEnchantScroll(11),
    Spiritshot(12),
    Soulshot(13),
    Buff(14),
    VariationStone(15),
    dye(16),
    SoulCrystal(17),
    SkillBook(18),
    EtcEnchant(19),
    PotionAndEtcScroll(20),
    ticket(21),
    Craft(22),
    IncEnchantProp(23),
    Adena(24),
    EtcSubtype(25);

    private final int _id;

    private WorldExchangeItemSubType(int id)
    {
        _id = id;
    }

    public int getId()
    {
        return _id;
    }

    public static WorldExchangeItemSubType getWorldExchangeItemSubType(int id)
    {
        for (WorldExchangeItemSubType type : values())
        {
            if (type.getId() == id)
            {
                return type;
            }
        }
        return EtcSubtype;
    }
}
