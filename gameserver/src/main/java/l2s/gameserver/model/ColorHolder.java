package l2s.gameserver.model;

public class ColorHolder
{
    private final int _r;
    private final int _g;
    private final int _b;

    public ColorHolder(int red, int green, int blue)
    {
        _r = red;
        _g = green;
        _b = blue;
    }

    public int getRed()
    {
        return _r;
    }

    public int getGreen()
    {
        return _g;
    }

    public int getBlue()
    {
        return _b;
    }
}
