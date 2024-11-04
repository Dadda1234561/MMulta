package l2s.gameserver.model.actor.instances.player;

import l2s.gameserver.templates.HomunculusTemplate;

/**
 * @author nexvill
 */
public class Homunculus implements Comparable<Homunculus>
{
	private final HomunculusTemplate _template;
	private int _slot;
	private int _level;
	private int _exp;
	private int _skill1_level;
	private int _skill2_level;
	private int _skill3_level;
	private int _skill4_level;
	private int _skill5_level;
	private boolean _isActive;

	public Homunculus(HomunculusTemplate template, int slot, int level, int exp, int skill1_level, int skill2_level, int skill3_level, int skill4_level, int skill5_level, boolean isActive)
	{
		_template = template;
		_slot = slot;
		_level = level;
		_exp = exp;
		_skill1_level = skill1_level;
		_skill2_level = skill2_level;
		_skill3_level = skill3_level;
		_skill4_level = skill4_level;
		_skill5_level = skill5_level;
		_isActive = isActive;
	}

	public HomunculusTemplate getTemplate()
	{
		return _template;
	}
	
	public int getId()
	{
		return _template.getId();
	}
	
	public int getType()
	{
		return _template.getType();
	}
	
	public void setSlot(int slot)
	{
		_slot = slot;
	}
	
	public int getSlot()
	{
		return _slot;
	}
	
	public void setLevel(int level)
	{
		_level = level;
	}
	
	public int getLevel()
	{
		return _level;
	}
	
	public void setExp(int exp)
	{
		_exp = exp;
	}
	
	public int getExp()
	{
		return _exp;
	}
	
	public void setSkill1Level(int level)
	{
		_skill1_level = level;
	}
	
	public int getSkill1Level()
	{
		return _skill1_level;
	}
	
	public void setSkill2Level(int level)
	{
		_skill2_level = level;
	}
	
	public int getSkill2Level()
	{
		return _skill2_level;
	}
	
	public void setSkill3Level(int level)
	{
		_skill3_level = level;
	}
	
	public int getSkill3Level()
	{
		return _skill3_level;
	}
	
	public void setSkill4Level(int level)
	{
		_skill4_level = level;
	}
	
	public int getSkill4Level()
	{
		return _skill4_level;
	}
	
	public void setSkill5Level(int level)
	{
		_skill5_level = level;
	}
	
	public int getSkill5Level()
	{
		return _skill5_level;
	}
	
	public int getHp()
	{
		switch (_level)
		{
			case 1:
				return _template.getHpLevel1();
			case 2:
				return _template.getHpLevel2();
			case 3:
				return _template.getHpLevel3();
			case 4:
				return _template.getHpLevel4();
			case 5:
				return _template.getHpLevel5();
		}
		return _template.getHpLevel1();
	}
	
	public int getAtk()
	{
		switch (_level)
		{
			case 1:
				return _template.getAtkLevel1();
			case 2:
				return _template.getAtkLevel2();
			case 3:
				return _template.getAtkLevel3();
			case 4:
				return _template.getAtkLevel4();
			case 5:
				return _template.getAtkLevel5();
		}
		return _template.getAtkLevel1();
	}
	
	public int getDef()
	{
		switch (_level)
		{
			case 1:
				return _template.getDefLevel1();
			case 2:
				return _template.getDefLevel2();
			case 3:
				return _template.getDefLevel3();
			case 4:
				return _template.getDefLevel4();
			case 5:
				return _template.getDefLevel5();
		}
		return _template.getDefLevel1();
	}
	
	public int getCritRate()
	{
		return _template.getCritRate();
	}
	
	public void setActive(boolean active)
	{
		_isActive = active;
	}

	public boolean isActive()
	{
		return _isActive;
	}

	public static String toString(int id, boolean isActive)
	{
		return "Homunculus[id=" + id + ", isActive=" + isActive + "]";
	}

	@Override
	public String toString()
	{
		return toString(_template.getId(), _isActive);
	}

	@Override
	public int compareTo(Homunculus o)
	{
		return getId() - o.getId();
	}
}