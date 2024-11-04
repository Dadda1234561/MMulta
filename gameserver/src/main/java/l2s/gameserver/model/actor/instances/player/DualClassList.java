package l2s.gameserver.model.actor.instances.player;

import java.util.Collection;
import java.util.Iterator;
import java.util.List;
import java.util.TreeMap;

import l2s.gameserver.dao.CharacterDualClassDAO;
import l2s.gameserver.model.Player;
import l2s.gameserver.model.base.ClassId;
import l2s.gameserver.model.base.ClassLevel;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

/**
 * @author Bonux
 * @date 03/11/2011 12:19 AM
 * @updated by nexvill
**/
public class DualClassList implements Iterable<DualClass>
{
	private static final Logger _log = LoggerFactory.getLogger(DualClassList.class);

	public static final int MAX_DUAL_COUNT = 2;

	private final TreeMap<Integer, DualClass> _listByIndex = new TreeMap<Integer, DualClass>();
	private final TreeMap<Integer, DualClass> _listByClassId = new TreeMap<Integer, DualClass>();

	private final Player _owner;

	private DualClass _baseClass = null;
	private DualClass _activeClass = null;
	private DualClass _dualClass = null;

	public DualClassList(Player owner)
	{
		_owner = owner;
	}

	public boolean restore()
	{
		_listByIndex.clear();
		_listByClassId.clear();

		List<DualClass> dualclasses = CharacterDualClassDAO.getInstance().restore(_owner);
		if(dualclasses.isEmpty())
		{
			_log.warn("DualClassList:restore: Could not restore any dual-classes! Player: " + _owner.getName() + "(" + _owner.getObjectId() + ")");
			return false;
		}

		int index = 2;
		for(DualClass dual : dualclasses)
		{
			if(dual == null) // Невозможно, но хай будет.
				continue;

			if(size() >= MAX_DUAL_COUNT)
			{
				_log.warn("DualClassList:restore: Limit is dualclass! Player: " + _owner.getName() + "(" + _owner.getObjectId() + ")");
				break;
			}

			if(dual.isActive())
				_activeClass = dual;

			if(dual.isDual())
				_dualClass = dual;

			if(dual.isBase())
			{
				_baseClass = dual;
				dual.setIndex(1);
			}
			else
			{
				dual.setIndex(index);
				index++;
			}

			if(_listByIndex.containsKey(dual.getIndex()))
				_log.warn("DualClassList:restore: Duplicate index in player dualclasses! Player: " + _owner.getName() + "(" + _owner.getObjectId() + ")");
			_listByIndex.put(dual.getIndex(), dual);

			if(_listByClassId.containsKey(dual.getClassId()))
				_log.warn("DualClassList:restore: Duplicate class_id in player dualclasses! Player: " + _owner.getName() + "(" + _owner.getObjectId() + ")");
			_listByClassId.put(dual.getClassId(), dual);
		}

		if(_baseClass == null)
		{
			_log.warn("DualClassList:restore: Could not restore base dual-class! Player: " + _owner.getName() + "(" + _owner.getObjectId() + ")");
			return false;
		}

		if(_activeClass == null)
		{
			_activeClass = _baseClass;
			_activeClass.setActive(true);
			_log.warn("DualClassList:restore: Could not restore active dual-class! Base class applied to active dual-class. Player: " + _owner.getName() + "(" + _owner.getObjectId() + ")");
		}

		if(_listByIndex.size() != _listByClassId.size()) // Невозможно, но хай будет.
			_log.warn("DualClassList:restore: The size of the lists do not match! Player: " + _owner.getName() + "(" + _owner.getObjectId() + ")");

		return true;
	}

	@Override
	public Iterator<DualClass> iterator()
	{
		return _listByIndex.values().iterator();
	}

	public Collection<DualClass> values()
	{
		return _listByIndex.values();
	}

	public DualClass getByClassId(int classId)
	{
		return _listByClassId.get(classId);
	}

	public DualClass getByIndex(int index)
	{
		return _listByIndex.get(index);
	}

	public void removeByClassId(int classId)
	{
		if(!_listByClassId.containsKey(classId))
			return;

		int index = _listByClassId.get(classId).getIndex();
		_listByIndex.remove(index);
		_listByClassId.remove(classId);
	}

	public DualClass getActiveDualClass()
	{
		return _activeClass;
	}

	public DualClass getBaseDualClass()
	{
		return _baseClass;
	}

	public boolean isBaseClassActive()
	{
		return _activeClass == _baseClass;
	}

	public DualClass getDualClass()
	{
		return _dualClass;
	}

	public void setDualClass(DualClass dual)
	{
		_dualClass = dual;
	}

	public boolean haveDualClasses()
	{
		return size() > 1;
	}

	public boolean changeDualClassId(int oldClassId, int newClassId)
	{
		if(!_listByClassId.containsKey(oldClassId))
			return false;

		if(_listByClassId.containsKey(newClassId))
			return false;

		DualClass dual = _listByClassId.get(oldClassId);
		dual.setClassId(newClassId);
		if(dual.isBase())
		{
			// Не меняем наследника у базового класса, иначе смениться раса и это оффлайк.
			if(ClassId.VALUES[newClassId].isOfLevel(ClassLevel.AWAKED))
			{
				if(!ClassId.VALUES[oldClassId].isOfLevel(ClassLevel.AWAKED))
					dual.setDefaultClassId(oldClassId);
			}
		}
		else
			dual.setDefaultClassId(ClassId.VALUES[newClassId].getBaseAwakeParent(ClassId.VALUES[oldClassId]).getId());

		_listByClassId.remove(oldClassId);
		_listByClassId.put(dual.getClassId(), dual);
		return true;
	}

	public boolean add(DualClass dual)
	{
		if(dual == null)
			return false;

		if(size() >= MAX_DUAL_COUNT)
			return false;

		if(_listByClassId.containsKey(dual.getClassId()))
			return false;

		int index = 1;
		while(_listByIndex.containsKey(index))
			index++;

		dual.setIndex(index);

		_listByIndex.put(dual.getIndex(), dual);
		_listByClassId.put(dual.getClassId(), dual);
		return true;
	}

	public DualClass changeActiveDualClass(int classId)
	{
		DualClass dual = _listByClassId.get(classId);
		if(dual == null)
			return null;

		if(_activeClass != null)
			_activeClass.setActive(false);

		dual.setActive(true);

		_activeClass = dual;
		return dual;
	}

	public boolean containsClassId(int classId)
	{
		return _listByClassId.containsKey(classId);
	}

	public int size()
	{
		return _listByIndex.size();
	}

	@Override
	public String toString()
	{
		return "DualClassList[owner=" + _owner.getName() + "]";
	}
}
