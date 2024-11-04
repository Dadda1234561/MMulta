package l2s.gameserver.model.actor.instances.player;

import l2s.gameserver.Config;
import l2s.gameserver.model.Player;
import l2s.gameserver.model.base.ClassId;
import l2s.gameserver.model.base.Experience;
import l2s.gameserver.model.base.DualClassType;

public class DualClass
{
	public static final int DUALCERTIFICATION_85 = 1 << 0;
	public static final int DUALCERTIFICATION_90 = 1 << 1;
	public static final int DUALCERTIFICATION_95 = 1 << 2;
	public static final int DUALCERTIFICATION_99 = 1 << 3;
	public static final int DUALCERTIFICATION_101 = 1 << 4;
	public static final int DUALCERTIFICATION_103 = 1 << 5;
	public static final int DUALCERTIFICATION_105 = 1 << 6;
	public static final int DUALCERTIFICATION_107 = 1 << 7;
	public static final int DUALCERTIFICATION_109 = 1 << 8;
	public static final int DUALCERTIFICATION_110 = 1 << 9;

	private final Player _owner;

	private int _classId = 0;
	private int _defaultClassId = 0;
	private int _index = 1;

	private boolean _active = false;
	private DualClassType _type = DualClassType.BASE_CLASS;

	private int _level = 1;
	private long _exp = 0;
	private long _sp = 0;

	private int _maxLvl = Experience.getMaxLevel();
	private long _minExp = 0;
	private long _maxExp = Experience.getExpForLevel(_maxLvl + 1) - 1;

	private int _dualCertification;

	private double _hp = 1;
	private double _mp = 1;
	private double _cp = 1;

	private int _vitality = Player.MAX_VITALITY_POINTS;
	private int _usedVitalityPotions = 0;

	public DualClass(Player owner)
	{
		_owner = owner;
	}

	public int getClassId()
	{
		return _classId;
	}

	public int getDefaultClassId()
	{
		return _defaultClassId;
	}

	public long getExp()
	{
		return _exp;
	}

	public long getMaxExp()
	{
		return _maxExp;
	}

	public void addExp(long val, boolean delevel)
	{
		setExp(_exp + val, delevel);
	}

	public long getSp()
	{
		return _sp;
	}

	public void addSp(long val)
	{
		setSp(_sp + val);
	}

	public int getLevel()
	{
		return _level;
	}

	public void setClassId(int id)
	{
		if(_classId == id)
			return;

		_classId = id;
	}

	public void setDefaultClassId(int id)
	{
		_defaultClassId = id;
	}

	public void setExp(long val, boolean delevel)
	{
		_exp = val;

		if(!delevel)
			_exp = Math.min(Math.max(Experience.getExpForLevel(_level), _exp), _maxExp);

		_exp = Math.min(_exp, _maxExp);
		_exp = Math.max(_minExp, _exp);
		_level = Experience.getLevel(_exp);
	}

	public void setSp(long spValue)
	{
		_sp = Math.min(Math.max(0L, spValue), Config.SP_LIMIT);
	}

	public void setHp(double hpValue)
	{
		_hp = Math.max(0., hpValue);
	}

	public double getHp()
	{
		return _hp;
	}

	public void setMp(final double mpValue)
	{
		_mp = Math.max(0., mpValue);
	}

	public double getMp()
	{
		return _mp;
	}

	public void setCp(final double cpValue)
	{
		_cp = Math.max(0., cpValue);
	}

	public double getCp()
	{
		return _cp;
	}

	public void setActive(final boolean active)
	{
		_active = active;
	}

	public boolean isActive()
	{
		return _active;
	}

	public void setType(final DualClassType type)
	{
		if(_type == type)
			return;

		_type = type;

		if(_type == DualClassType.DUAL_CLASS)
			_owner.getDualClassList().setDualClass(this);

		_maxLvl = Experience.getMaxLevel();
		_minExp = 0;
		_level = Math.min(Math.max(1, _level), _maxLvl);
		_minExp = Math.max(0, _minExp);
		_maxExp = Experience.getExpForLevel(_maxLvl + 1) - 1;
		_exp = Math.min(Math.max(Experience.getExpForLevel(_level), _exp), _maxExp);
	}

	public DualClassType getType()
	{
		return _type;
	}

	public boolean isBase()
	{
		return _type == DualClassType.BASE_CLASS;
	}

	public boolean isDual()
	{
		return _type == DualClassType.DUAL_CLASS;
	}

	public int getDualCertification()
	{
		return _dualCertification;
	}

	public void setDualCertification(int certification)
	{
		_dualCertification = certification;
	}

	public void addDualCertification(int c)
	{
		_dualCertification |= c;
	}

	public boolean isDualCertificationGet(int v)
	{
		return (_dualCertification & v) == v;
	}

	@Override
	public String toString()
	{
		return ClassId.VALUES[_classId].toString() + " " + _level;
	}

	public int getMaxLevel()
	{
		return _maxLvl;
	}

	public void setIndex(int i)
	{
		_index = i;
	}

	public int getIndex()
	{
		return _index;
	}

	public void setVitality(int val)
	{
		_vitality = val;
		if(_vitality > Player.MAX_VITALITY_POINTS)
			_vitality = Player.MAX_VITALITY_POINTS;
		if(_vitality < 0)
			_vitality = 0;
	}

	public int getVitality()
	{
		return _vitality;
	}

	public void setUsedVitalityPotions(int val)
	{
		_usedVitalityPotions = val;
		if(_usedVitalityPotions < 0)
			_usedVitalityPotions = 0;
	}

	public int getUsedVitalityPotions()
	{
		return _usedVitalityPotions;
	}
}