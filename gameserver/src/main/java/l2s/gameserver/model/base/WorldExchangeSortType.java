package l2s.gameserver.model.base;

public enum WorldExchangeSortType
{

    NONE(0),
    ITEM_NAME_ASCE(1),
    ENCHANT_ASCE(2),
    ENCHANT_DESC(3),
    PRICE_ASCE(4),
    PRICE_DESC(5),
    AMOUNT_ASCE(6),
    AMOUNT_DESC(7),
    PRICE_PER_PIECE_ASCE(8),
    PRICE_PER_PIECE_DESC(9);

    private final int _id;

    private WorldExchangeSortType(int id)
    {
        _id = id;
    }

    public int getId()
    {
        return _id;
    }

    public static WorldExchangeSortType getWorldExchangeSortType(int id)
    {
        for (WorldExchangeSortType type : values())
        {
            if (type.getId() == id)
            {
                return type;
            }
        }
        return NONE;
    }
}