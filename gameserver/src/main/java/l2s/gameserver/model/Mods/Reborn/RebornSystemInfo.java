package l2s.gameserver.model.Mods.Reborn;

import l2s.gameserver.model.Player;

import java.text.SimpleDateFormat;

public class RebornSystemInfo {
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
    int _cha;
    double _PvePhysDmg;
    double _PveMagDmg;

    double _MaxCP;
    double _MaxHP;
    double _MaxMP;

    double _PhysDmg;
    double _MagDmg;
    double _PhysDef;
    double _MagDef;

    double _PhysCritDmg;
    double _MagCritDmg;
    double _PhysCritRate;
    double _MagCritRate;

    double _PvpPhysDmg;
    double _PvpMagDmg;
    double _PvpPhysDef;
    double _PvpMagDef;

    double _MReuse;
    double _AdenaRate;
    double _ExpRate;
    double _DropRate;

    double _SoulShotPowerRate;
    double _SpiritShotPowerRate;

    public int getRebornId() {
        return _id;
    }

    public void setRebornId(int reborn) {
        _id = reborn;
    }

    public int getLevelNeed() {
        return _levelNeed;
    }

    public void setLevelNeed(int levelNeed) {
        _levelNeed = levelNeed;
    }

    public String getNeedItem() {
        return _needItem;
    }

    public void setNeedItem(String needItem) {
        _needItem = needItem;
    }

    public String getReward() {
        return _reward;
    }

    public void setreward(String reward) {
        _reward = reward;
    }

    public int getResetLevel() {
        return _resetlevel;
    }

    public void setResetLevel(int resetLevel) {
        _resetlevel = resetLevel;
    }

    public int getResetTime() {
        return _reset_time;
    }

    public void setResetTime(int resetTime) {
        _reset_time = resetTime;
    }

    public String getResetTimeInBoard(Player player) {
        String countNo = "Вы не достигли нужного количества перерождений для активации блока по времени";
        if (player.getVarLong("rebornTime") > System.currentTimeMillis()) {
            return new SimpleDateFormat("dd.MM.yyyy HH:mm").format(player.getVarLong("rebornTime"));
        } else {
            return countNo;
        }
    }

    public double getRateExp() {
        return _rateExp;
    }

    public void setRateExp(double rateExp) {
        _rateExp = rateExp;
    }

    public double getRateSp() {
        return _ratesp;
    }

    public void setRateSp(double rateSp) {
        _ratesp = rateSp;
    }

    public int getSTR() {
        return _str;
    }

    public void setSTR(int str) {
        _str = str;
    }

    public int getDEX() {
        return _dex;
    }

    public void setDEX(int dex) {
        _dex = dex;
    }

    public int getCON() {
        return _con;
    }

    public void setCON(int con) {
        _con = con;
    }

    public int getWIT() {
        return _wit;
    }

    public void setWIT(int wit) {
        _wit = wit;
    }

    public int getINT() {
        return _int;
    }

    public void setINT(int value) {
        _int = value;
    }

    public int getMEN() {
        return _men;
    }

    public void setMEN(int men) {
        _men = men;
    }

    public int getCHA() {
        return _cha;
    }

    public void setCHA(int value) {
        _cha = value;
    }

    public double getPvePhysDmg() {
        return _PvePhysDmg;
    }

    public void setPvePhysDmg(double value) {
        _PvePhysDmg = value;
    }

    public double getPveMagDmg() {
        return _PveMagDmg;
    }

    public void setPveMagDmg(double value) {
        _PveMagDmg = value;
    }

    public double getPhysDmg() {
        return _PhysDmg;
    }

    public void setPhysDmg(double value) {
        _PhysDmg = value;
    }

    public double getMagDmg() {
        return _MagDmg;
    }

    public void setMagDmg(double value) {
        _MagDmg = value;
    }

    public double getPhysDef() {
        return _PhysDef;
    }

    public void setPhysDef(double value) {
        _PhysDef = value;
    }

    public double getMagDef() {
        return _MagDef;
    }

    public void setMagDef(double value) {
        _MagDef = value;
    }

    public double getMaxCP() {
        return _MaxCP;
    }

    public void setMaxCP(double value) {
        _MaxCP = value;
    }

    public double getMaxHP() {
        return _MaxHP;
    }

    public void setMaxHP(double value) {
        _MaxHP = value;
    }

    public double getMaxMP() {
        return _MaxMP;
    }

    public void setMaxMP(double value) {
        _MaxMP = value;
    }

    public double getPhysCritDmg() {
        return _PhysCritDmg;
    }

    public void setPhysCritDmg(double value) {
        _PhysCritDmg = value;
    }

    public double getMagCritDmg() {
        return _MagCritDmg;
    }

    public void setMagCritDmg(double value) {
        _MagCritDmg = value;
    }

    public double getPhysCritRate() {
        return _PhysCritRate;
    }

    public void setPhysCritRate(double value) {
        _PhysCritRate = value;
    }

    public double getMagCritRate() {
        return _MagCritRate;
    }

    public void setMagCritRate(double value) {
        _MagCritRate = value;
    }

    public double getPvpPhysDmg() {
        return _PvpPhysDmg;
    }

    public void setPvpPhysDmg(double value) {
        _PvpPhysDmg = value;
    }

    public double getPvpMagDmg() {
        return _PvpMagDmg;
    }

    public void setPvpMagDmg(double value) {
        _PvpMagDmg = value;
    }

    public double getPvpPhysDef() {
        return _PvpPhysDef;
    }

    public void setPvpPhysDef(double value) {
        _PvpPhysDef = value;
    }

    public double getPvpMagDef() {
        return _PvpMagDef;
    }

    public void setPvpMagDef(double value) {
        _PvpMagDef = value;
    }

    public double getMReuse() {
        return _MReuse;
    }

    public void setMReuse(double value) {
        _MReuse = value;
    }

    public double getAdenaRate() {
        return _AdenaRate;
    }

    public void setAdenaRate(double value) {
        _AdenaRate = value;
    }

    public double getExpRate() {
        return _ExpRate;
    }

    public void setExpRate(double value) {
        _ExpRate = value;
    }

    public double getDropRate() {
        return _DropRate;
    }

    public void setDropRate(double value) {
        _DropRate = value;
    }

    public double getSoulShotPowerRate() {
        return _SoulShotPowerRate;
    }

    public void setSoulShotPowerRate(double _SoulShotPowerRate) {
        this._SoulShotPowerRate = _SoulShotPowerRate;
    }

    public double getSpiritShotPowerRate() {
        return _SpiritShotPowerRate;
    }

    public void setSpiritShotPowerRate(double _SpiritShotPowerRate) {
        this._SpiritShotPowerRate = _SpiritShotPowerRate;
    }
}
