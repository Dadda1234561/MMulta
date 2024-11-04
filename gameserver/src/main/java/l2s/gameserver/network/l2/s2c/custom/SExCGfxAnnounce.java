package l2s.gameserver.network.l2.s2c.custom;

public class SExCGfxAnnounce extends ACustomServerPacket {

    private final int _type = 1;
    private final String _message;

    public SExCGfxAnnounce(String text) {
        _message = text;
    }

    @Override
    protected void writeCustomImpl() {
        writeC(SExCustomOpcode.S_EX_C_GFX_ANNOUNCE);

        writeC(_type);
        writeString(_message);
    }
}
