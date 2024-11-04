package l2s.gameserver.model.Mods.RebornSub;

import l2s.gameserver.model.Player;

import java.text.SimpleDateFormat;

public class RebornSubSystemInfo {
    int _id;
    int _levelNeed;
    int _resetlevel;
    int _reset_time;
    String _needItem;
    String _reward;
    double _rateExp;
    double _ratesp;
    int _str;
    int _dex;
    int _con;
    int _wit;

    int _int;
    int _men;
    int _PvePhysDmg;
    int _PveMagDmg;

    int _cha;
    int _MaxCP;
    int _MaxHP;
    int _MaxMP;

    int _PhysDmg;
    int _MagDmg;
    int _PhysDef;
    int _MagDef;

    int _PhysCritDmg;
    int _MagCritDmg;
    int _PhysCritRate;
    int _MagCritRate;

    int _PvpDmg;
    int _PvpMagDmg;
    int _PvpDef;
    int _PvpMagDef;

    int _MReuse;
    int _AdenaRate;
    int _ExpRate;
    int _DropRate;

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
    public double getRateExp(){
        return _rateExp;
    }

    public void setRateExp(double rateExp){
        _rateExp = rateExp;
    }

    public double getRateSp(){
        return _ratesp;
    }

    public void setRateSp(double rateSp){
        _ratesp = rateSp;
    }

    public int getSTR(){
        return _str;
    }

    public void setSTR(int str){
        _str = str;
    }

    public int getDEX(){
        return _dex;
    }

    public void setDEX(int dex){
        _dex = dex;
    }

    public int getCON(){
        return _con;
    }

    public void setCON(int con){
        _con = con;
    }

    public int getWIT(){
        return _wit;
    }

    public void setWIT(int wit){
        _wit = wit;
    }

    public int getINT(){
        return _int;
    }

    public void setINT(int value){
        _int = value;
    }

    public int getMEN(){
        return _men;
    }

    public void setMEN(int men){
        _men = men;
    }

    public int getPvePhysDmg(){
        return _PvePhysDmg;
    }

    public void setPvePhysDmg(int value){
        _PvePhysDmg = value;
    }

    public int getPveMagDmg(){
        return _PveMagDmg;
    }

    public void setPveMagDmg(int value){
        _PveMagDmg = value;
    }

    public int getPhysDmg(){
        return _PhysDmg;
    }

    public void setPhysDmg(int value){
        _PhysDmg = value;
    }

    public int getMagDmg(){
        return _MagDmg;
    }

    public void setMagDmg(int value){
        _MagDmg = value;
    }

    public int getPhysDef(){
        return _PhysDef;
    }

    public void setPhysDef(int value){
        _PhysDef = value;
    }

    public int getMagDef(){
        return _MagDef;
    }

    public void setMagDef(int value){
        _MagDef = value;
    }

    public int getCHA(){
        return _cha;
    }

    public void setCHA(int value){
        _cha = value;
    }

    public int getMaxCP(){
        return _MaxCP;
    }

    public void setMaxCP(int value){
        _MaxCP = value;
    }

    public int getMaxHP(){
        return _MaxHP;
    }

    public void setMaxHP(int value){
        _MaxHP = value;
    }

    public int getMaxMP(){
        return _MaxMP;
    }

    public void setMaxMP(int value){
        _MaxMP = value;
    }

    public int getPhysCritDmg(){
        return _PhysCritDmg;
    }

    public void setPhysCritDmg(int value){
        _PhysCritDmg = value;
    }

    public int getMagCritDmg(){
        return _MagCritDmg;
    }

    public void setMagCritDmg(int value){
        _MagCritDmg = value;
    }

    public int getPhysCritRate(){
        return _PhysCritRate;
    }

    public void setPhysCritRate(int value){
        _PhysCritRate = value;
    }

    public int getMagCritRate(){
        return _MagCritRate;
    }

    public void setMagCritRate(int value){
        _MagCritRate = value;
    }

    public int getPvpDmg(){
        return _PvpDmg;
    }

    public void setPvpDmg(int value){
        _PvpDmg = value;
    }

    public int getPvpMagDmg(){
        return _PvpMagDmg;
    }

    public void setPvpMagDmg(int value){
        _PvpMagDmg = value;
    }

    public int getPvpDef(){
        return _PvpDef;
    }

    public void setPvpDef(int value){
        _PvpDef = value;
    }

    public int getPvpMagDef(){
        return _PvpMagDef;
    }

    public void setPvpMagDef(int value){
        _PvpMagDef = value;
    }

    public int getMReuse(){
        return _MReuse;
    }

    public void setMReuse(int value){
        _MReuse = value;
    }

    public int getAdenaRate(){
        return _AdenaRate;
    }

    public void setAdenaRate(int value){
        _AdenaRate = value;
    }

    public int getExpRate(){
        return _ExpRate;
    }

    public void setExpRate(int value){
        _ExpRate = value;
    }

    public int getDropRate(){
        return _DropRate;
    }

    public void setDropRate(int value){
        _DropRate = value;
    }
}
