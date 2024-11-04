package l2s.gameserver.network.l2.s2c.collection;

import l2s.gameserver.network.l2.s2c.L2GameServerPacket;

/**
 * @author sharp
 * t.me/sharp1que
 */
public class ExCollectionComplete extends L2GameServerPacket {

    private final int _collectionId;
    private final int _remainingTime;

    public ExCollectionComplete(int collectionId, int remainingTime) {
        this._collectionId = collectionId;
        this._remainingTime = remainingTime;
    }

    @Override
    protected void writeImpl() {
        writeH(_collectionId);
        writeD(_remainingTime);
    }
}
