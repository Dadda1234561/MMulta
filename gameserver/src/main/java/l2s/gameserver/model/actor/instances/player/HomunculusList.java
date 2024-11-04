package l2s.gameserver.model.actor.instances.player;

import gnu.trove.map.TIntObjectMap;
import gnu.trove.map.hash.TIntObjectHashMap;

import java.util.ArrayList;
import java.util.Collections;
import java.util.List;
import l2s.gameserver.dao.CharacterHomunculusDAO;
import l2s.gameserver.model.Player;
import l2s.gameserver.skills.SkillEntry;
import l2s.gameserver.skills.SkillEntryType;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

/**
 * @author nexvill
**/
public class HomunculusList
{
	public static final int MAX_SIZE = 2;

	private static final Logger _log = LoggerFactory.getLogger(HomunculusList.class);
	
	private List<Homunculus> _homunculusList = Collections.emptyList();
	private int _hp, _atk, _def, _critRate;

	private final Player _owner;
	private final TIntObjectMap<SkillEntry> _skills = new TIntObjectHashMap<SkillEntry>();

	public HomunculusList(Player owner)
	{
		_owner = owner;
	}

	public void restore()
	{
		_homunculusList = new ArrayList<>();

		List<Homunculus> homunculuses = CharacterHomunculusDAO.getInstance().select(_owner);
		for(Homunculus homunculus : homunculuses)
		{
				_homunculusList.add(homunculus);
		}

		Collections.sort(_homunculusList);

		if(_homunculusList.size() > MAX_SIZE)
		{
			_log.warn(this + ": Contains more than two homunculus's!");

			for(int i = MAX_SIZE; i < _homunculusList.size(); i++)
				_homunculusList.remove(i);
		}

		refreshStats(false);
	}

	public Homunculus get(int slot)
	{
		for(Homunculus homunculus : values())
		{
			if (homunculus.getSlot() == slot)
				return homunculus;
		}
		return null;
	}

	public int size()
	{
		return _homunculusList.size();
	}

	public int getFreeSize()
	{
		return Math.max(0, MAX_SIZE - size());
	}

	public Homunculus[] values()
	{
		List<Homunculus> homunculuses = new ArrayList<Homunculus>(_homunculusList);

		return homunculuses.toArray(new Homunculus[homunculuses.size()]);
	}

	public boolean isFull()
	{
		return getFreeSize() == 0;
	}

	public boolean canAdd(Homunculus homunculus)
	{
		return !isFull();
	}

	public boolean add(Homunculus homunculus)
	{
		if(!canAdd(homunculus))
			return false;

		if(CharacterHomunculusDAO.getInstance().insert(_owner, homunculus))
		{
			_homunculusList.add(homunculus);
			Collections.sort(_homunculusList);

			if(refreshStats(true))
				_owner.sendSkillList();

			return true;
		}
		return false;
	}
	
	public boolean update(Homunculus homunculus)
	{
		return CharacterHomunculusDAO.getInstance().update(_owner, homunculus);
	}

	public boolean remove(Homunculus homunculus)
	{
		if(!remove0(homunculus))
			return false;

		if(refreshStats(true))
			_owner.sendSkillList();

		return true;
	}

	private boolean remove0(Homunculus homunculus)
	{
		if(!_homunculusList.remove(homunculus))
		{
			return false;
		}

		Collections.sort(_homunculusList);

		return CharacterHomunculusDAO.getInstance().delete(_owner, homunculus);
	}

	public boolean isActive(Homunculus homunculus)
	{
		return homunculus.isActive();
	}

	public boolean refreshStats(boolean send)
	{		
		_hp = 0;
		_atk = 0;
		_def = 0;
		_critRate = 0;

		boolean updateSkillList = false;
		for(int skillId : _skills.keys())
		{
			if(_owner.removeSkill(skillId, false) != null)
				updateSkillList = true;
		}

		_skills.clear();

		for(Homunculus homunculus : values())
		{
			if(!isActive(homunculus))
				continue;
			
			switch (homunculus.getLevel())
			{
				case 1:
				{
					_hp = homunculus.getTemplate().getHpLevel1();
					_atk = homunculus.getTemplate().getAtkLevel1();
					_def = homunculus.getTemplate().getDefLevel1();
					if (homunculus.getSkill1Level() > 0)
					{
						SkillEntry skillEntry = SkillEntry.makeSkillEntry(SkillEntryType.NONE, homunculus.getTemplate().getSkill1Id(), homunculus.getSkill1Level());
						SkillEntry tempSkillEntry = _skills.get(skillEntry.getId());
						if (tempSkillEntry == null || tempSkillEntry.getLevel() < skillEntry.getLevel())
						{
							_skills.put(skillEntry.getId(), skillEntry);
						}
					}
					break;
				}
				case 2:
				{
					_hp = homunculus.getTemplate().getHpLevel2();
					_atk = homunculus.getTemplate().getAtkLevel2();
					_def = homunculus.getTemplate().getDefLevel2();
					if (homunculus.getSkill1Level() > 0)
					{
						SkillEntry skillEntry = SkillEntry.makeSkillEntry(SkillEntryType.NONE, homunculus.getTemplate().getSkill1Id(), homunculus.getSkill1Level());
						SkillEntry tempSkillEntry = _skills.get(skillEntry.getId());
						if (tempSkillEntry == null || tempSkillEntry.getLevel() < skillEntry.getLevel())
						{
							_skills.put(skillEntry.getId(), skillEntry);
						}
					}
					if (homunculus.getSkill2Level() > 0)
					{
						SkillEntry skillEntry = SkillEntry.makeSkillEntry(SkillEntryType.NONE, homunculus.getTemplate().getSkill2Id(), homunculus.getSkill2Level());
						SkillEntry tempSkillEntry = _skills.get(skillEntry.getId());
						if (tempSkillEntry == null || tempSkillEntry.getLevel() < skillEntry.getLevel())
						{
							_skills.put(skillEntry.getId(), skillEntry);
						}
					}
					break;
				}
				case 3:
				{
					_hp = homunculus.getTemplate().getHpLevel3();
					_atk = homunculus.getTemplate().getAtkLevel3();
					_def = homunculus.getTemplate().getDefLevel3();
					if (homunculus.getSkill1Level() > 0)
					{
						SkillEntry skillEntry = SkillEntry.makeSkillEntry(SkillEntryType.NONE, homunculus.getTemplate().getSkill1Id(), homunculus.getSkill1Level());
						SkillEntry tempSkillEntry = _skills.get(skillEntry.getId());
						if (tempSkillEntry == null || tempSkillEntry.getLevel() < skillEntry.getLevel())
						{
							_skills.put(skillEntry.getId(), skillEntry);
						}
					}
					if (homunculus.getSkill2Level() > 0)
					{
						SkillEntry skillEntry = SkillEntry.makeSkillEntry(SkillEntryType.NONE, homunculus.getTemplate().getSkill2Id(), homunculus.getSkill2Level());
						SkillEntry tempSkillEntry = _skills.get(skillEntry.getId());
						if (tempSkillEntry == null || tempSkillEntry.getLevel() < skillEntry.getLevel())
						{
							_skills.put(skillEntry.getId(), skillEntry);
						}
					}
					if (homunculus.getSkill3Level() > 0)
					{
						SkillEntry skillEntry = SkillEntry.makeSkillEntry(SkillEntryType.NONE, homunculus.getTemplate().getSkill3Id(), homunculus.getSkill3Level());
						SkillEntry tempSkillEntry = _skills.get(skillEntry.getId());
						if (tempSkillEntry == null || tempSkillEntry.getLevel() < skillEntry.getLevel())
						{
							_skills.put(skillEntry.getId(), skillEntry);
						}
					}
					break;
				}
				case 4:
				{
					_hp = homunculus.getTemplate().getHpLevel4();
					_atk = homunculus.getTemplate().getAtkLevel4();
					_def = homunculus.getTemplate().getDefLevel4();
					if (homunculus.getSkill1Level() > 0)
					{
						SkillEntry skillEntry = SkillEntry.makeSkillEntry(SkillEntryType.NONE, homunculus.getTemplate().getSkill1Id(), homunculus.getSkill1Level());
						SkillEntry tempSkillEntry = _skills.get(skillEntry.getId());
						if (tempSkillEntry == null || tempSkillEntry.getLevel() < skillEntry.getLevel())
						{
							_skills.put(skillEntry.getId(), skillEntry);
						}
					}
					if (homunculus.getSkill2Level() > 0)
					{
						SkillEntry skillEntry = SkillEntry.makeSkillEntry(SkillEntryType.NONE, homunculus.getTemplate().getSkill2Id(), homunculus.getSkill2Level());
						SkillEntry tempSkillEntry = _skills.get(skillEntry.getId());
						if (tempSkillEntry == null || tempSkillEntry.getLevel() < skillEntry.getLevel())
						{
							_skills.put(skillEntry.getId(), skillEntry);
						}
					}
					if (homunculus.getSkill3Level() > 0)
					{
						SkillEntry skillEntry = SkillEntry.makeSkillEntry(SkillEntryType.NONE, homunculus.getTemplate().getSkill3Id(), homunculus.getSkill3Level());
						SkillEntry tempSkillEntry = _skills.get(skillEntry.getId());
						if (tempSkillEntry == null || tempSkillEntry.getLevel() < skillEntry.getLevel())
						{
							_skills.put(skillEntry.getId(), skillEntry);
						}
					}
					if (homunculus.getSkill4Level() > 0)
					{
						SkillEntry skillEntry = SkillEntry.makeSkillEntry(SkillEntryType.NONE, homunculus.getTemplate().getSkill4Id(), homunculus.getSkill4Level());
						SkillEntry tempSkillEntry = _skills.get(skillEntry.getId());
						if (tempSkillEntry == null || tempSkillEntry.getLevel() < skillEntry.getLevel())
						{
							_skills.put(skillEntry.getId(), skillEntry);
						}
					}
					break;
				}
				case 5:
				{
					_hp = homunculus.getTemplate().getHpLevel5();
					_atk = homunculus.getTemplate().getAtkLevel5();
					_def = homunculus.getTemplate().getDefLevel5();
					if (homunculus.getSkill1Level() > 0)
					{
						SkillEntry skillEntry = SkillEntry.makeSkillEntry(SkillEntryType.NONE, homunculus.getTemplate().getSkill1Id(), homunculus.getSkill1Level());
						SkillEntry tempSkillEntry = _skills.get(skillEntry.getId());
						if (tempSkillEntry == null || tempSkillEntry.getLevel() < skillEntry.getLevel())
						{
							_skills.put(skillEntry.getId(), skillEntry);
						}
					}
					if (homunculus.getSkill2Level() > 0)
					{
						SkillEntry skillEntry = SkillEntry.makeSkillEntry(SkillEntryType.NONE, homunculus.getTemplate().getSkill2Id(), homunculus.getSkill2Level());
						SkillEntry tempSkillEntry = _skills.get(skillEntry.getId());
						if (tempSkillEntry == null || tempSkillEntry.getLevel() < skillEntry.getLevel())
						{
							_skills.put(skillEntry.getId(), skillEntry);
						}
					}
					if (homunculus.getSkill3Level() > 0)
					{
						SkillEntry skillEntry = SkillEntry.makeSkillEntry(SkillEntryType.NONE, homunculus.getTemplate().getSkill3Id(), homunculus.getSkill3Level());
						SkillEntry tempSkillEntry = _skills.get(skillEntry.getId());
						if (tempSkillEntry == null || tempSkillEntry.getLevel() < skillEntry.getLevel())
						{
							_skills.put(skillEntry.getId(), skillEntry);
						}
					}
					if (homunculus.getSkill4Level() > 0)
					{
						SkillEntry skillEntry = SkillEntry.makeSkillEntry(SkillEntryType.NONE, homunculus.getTemplate().getSkill4Id(), homunculus.getSkill4Level());
						SkillEntry tempSkillEntry = _skills.get(skillEntry.getId());
						if (tempSkillEntry == null || tempSkillEntry.getLevel() < skillEntry.getLevel())
						{
							_skills.put(skillEntry.getId(), skillEntry);
						}
					}
					if (homunculus.getSkill5Level() > 0)
					{
						SkillEntry skillEntry = SkillEntry.makeSkillEntry(SkillEntryType.NONE, homunculus.getTemplate().getSkill5Id(), homunculus.getSkill5Level());
						SkillEntry tempSkillEntry = _skills.get(skillEntry.getId());
						if (tempSkillEntry == null || tempSkillEntry.getLevel() < skillEntry.getLevel())
						{
							_skills.put(skillEntry.getId(), skillEntry);
						}
					}
					break;
				}
			}
			
			_critRate = homunculus.getTemplate().getCritRate();
			
			SkillEntry skillEntry = SkillEntry.makeSkillEntry(SkillEntryType.NONE, homunculus.getTemplate().getBasicSkillId(), homunculus.getTemplate().getBasicSkillLevel());
			SkillEntry tempSkillEntry = _skills.get(skillEntry.getId());
			if (tempSkillEntry == null || tempSkillEntry.getLevel() < skillEntry.getLevel())
			{
				_skills.put(skillEntry.getId(), skillEntry);
			}
		}

		for(SkillEntry skillEntry : _skills.valueCollection())
			_owner.addSkill(skillEntry, false);

		if(!_skills.isEmpty())
			updateSkillList = true;

		if(send)
		{
			_owner.sendUserInfo(true);
		}

		return updateSkillList;
	}
	
	public int getHp()
	{
		return _hp;
	}
	
	public int getAtk()
	{
		return _atk;
	}
	
	public int getDef()
	{
		return _def;
	}
	
	public int getCritRate()
	{
		return _critRate;
	}

	@Override
	public String toString()
	{
		return "HomunculusList[owner=" + _owner.getName() + "]";
	}
}
