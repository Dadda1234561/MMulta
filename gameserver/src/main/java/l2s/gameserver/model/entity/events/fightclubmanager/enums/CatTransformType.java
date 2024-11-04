package l2s.gameserver.model.entity.events.fightclubmanager.enums;

/**
 * @author sharp https://t.me/sharp1que
 */
public enum CatTransformType {
    ARCHER(40554),
    WIZARD(40555);

    private final int _transformId;

    CatTransformType(int transform) {
        _transformId = transform;
    }

    public int getTransformId() {
        return _transformId;
    }
}
