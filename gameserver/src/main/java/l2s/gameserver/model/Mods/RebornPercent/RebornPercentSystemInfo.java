package l2s.gameserver.model.Mods.RebornPercent;

import l2s.gameserver.model.Player;

import java.text.SimpleDateFormat;

public class RebornPercentSystemInfo {
    int _id;
    int _levelNeed;
    int _resetlevel;
    int _reset_time;
    String _needItem;
    String _reward;

    public int getRebornId(){
        return _id;
    }

    public void setRebornId(int reborn){
        _id = reborn;
    }

    public int getLevelNeed(){
        return _levelNeed;
    }

    public void setLevelNeed(int levelNeed){
        _levelNeed = levelNeed;
    }

    public String getNeedItem(){
        return _needItem;
    }

    public void setNeedItem(String needItem){
        _needItem = needItem;
    }

    public String getReward(){
        return _reward;
    }

    public void setreward(String reward){
        _reward = reward;
    }

    public int getResetLevel()
    {
        return _resetlevel;
    }

    public void setResetLevel(int resetLevel){
        _resetlevel = resetLevel;
    }

    public int getResetTime(){
        return _reset_time;
    }

    public void setResetTime(int resetTime){
        _reset_time = resetTime;
    }

    public String getResetTimeInBoard(Player player)
    {
        String countNo = "Вы не достигли нужного количества перерождений для активации блока по времени";
        if (player.getVarLong("rebornTimeSub") > System.currentTimeMillis()) {
            return new SimpleDateFormat("dd.MM.yyyy HH:mm").format(player.getVarLong("rebornTimeSub"));
        }
        else {
            return countNo;
        }
    }
}
