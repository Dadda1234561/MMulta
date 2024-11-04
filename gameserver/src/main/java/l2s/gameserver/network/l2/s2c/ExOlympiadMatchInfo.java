package l2s.gameserver.network.l2.s2c;

import l2s.gameserver.model.Player;

public class ExOlympiadMatchInfo extends L2GameServerPacket
{
    private String _player1Name;
    private String _player2Name;
    private int _player1CountWin;
    private int _player2CountWin;
    private int _round;
    private int _time;

    public ExOlympiadMatchInfo(Player player1, Player player2, int player1CountWin, int player2CountWin, int round, int time) 
    {
        _player1Name = player1.getName();
        _player2Name = player2.getName();
        _player1CountWin = player1CountWin;
        _player2CountWin = player2CountWin;
        _round = Math.min(round, 3);
        _time = time;
    }

    public ExOlympiadMatchInfo(String player1Name, String player2Name, int player1CountWin, int player2CountWin, int round, int time) 
    {
        _player1Name = player1Name;
        _player2Name = player2Name;
        _player1CountWin = player1CountWin;
        _player2CountWin = player2CountWin;
        _round = Math.min(round, 3);
        _time = time;
    }

    @Override
    protected void writeImpl() {
        writeS(String.format("%1$-" + 23 + "s", _player1Name));
        writeD(_player1CountWin);
        writeS(String.format("%1$-" + 23 + "s", _player2Name));
        writeD(_player2CountWin);
        writeD(_round);
        writeD(_time);
    }
}
