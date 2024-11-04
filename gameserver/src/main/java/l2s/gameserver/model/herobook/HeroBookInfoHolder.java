package l2s.gameserver.model.herobook;

public class HeroBookInfoHolder
{
    private int _currentLevel;
    private int _currentExp;

    public HeroBookInfoHolder()
    {
    }

    public int getCurrentLevel()
    {
        return _currentLevel;
    }

    public void setCurrentLevel(int currentLevel)
    {
        _currentLevel = currentLevel;
    }

    public int getCurrentExp()
    {
        return _currentExp;
    }

    public void setCurrentExp(int currentExp)
    {
        _currentExp = currentExp;
    }
}
