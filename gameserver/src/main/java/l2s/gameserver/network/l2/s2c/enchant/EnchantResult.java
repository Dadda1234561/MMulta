package l2s.gameserver.network.l2.s2c.enchant;

import l2s.gameserver.network.l2.s2c.L2GameServerPacket;

public class EnchantResult extends L2GameServerPacket
{
    private final int _resultId, _crystalId;
    private final long _count;
    private final int _enchantLevel;
    private final int _enchant2;

    // public static final EnchantResultPacket SUCESS = new EnchantResultPacket(0,
    // 0, 0, 0, 0); // вещь заточилась, в статичном виде не используется
    // public static final EnchantResultPacket FAILED = new EnchantResultPacket(1,
    // 0, 0); // вещь разбилась, требует указания получившихся кристаллов, в
    // статичном виде не используется
    public static final EnchantResult CANCEL = new EnchantResult(2, 0, 0, 0); // заточка невозможна
    public static final EnchantResult BLESSED_FAILED = new EnchantResult(3, 0, 0, 0); // заточка не удалась, уровень
    // заточки сброшен на 0
    public static final EnchantResult FAILED_NO_CRYSTALS = new EnchantResult(4, 0, 0, 0); // вещь разбилась, но
    // кристаллов не получилось
    // (видимо для эвента,
    // сейчас
    // использовать невозможно,
    // там заглушка)
    public static final EnchantResult ANCIENT_FAILED = new EnchantResult(5, 0, 0, 0); // заточка не удалась, уровень
    // заточки не изменен (для
    // Ancient Enchant Crystal
    // из итем молла)

    public static final int ENCHANT_DOWNED = 7;
    public static final int REMAINED_UNCHANGED = 8;
    public static final int BLESSED_FAIL = 10;

    public EnchantResult(int resultId, int crystalId, long count, int enchantLevel, int enchantLevel2)
    {
        _resultId = resultId;
        _crystalId = crystalId;
        _count = count;
        _enchantLevel = enchantLevel;
        _enchant2 = enchantLevel2;
    }

    public EnchantResult(int resultId, int crystalId, long count, int enchantLevel)
    {
        _resultId = resultId;
        _crystalId = crystalId;
        _count = count;
        _enchantLevel = enchantLevel;
        _enchant2 = enchantLevel;
    }

    @Override
    protected final void writeImpl()
    {
        writeD(_resultId);
        writeD(_crystalId); // item id кристаллов
        writeQ(_count); // количество кристаллов
        writeD(0); // unk
        writeD(0); // unk
        writeD(0); // unk
        writeD(_enchantLevel); // уровень заточки
        writeD(0x00); // uNK
        writeD(0x00); // uNK
        writeD(0x00); // uNK
    }
}