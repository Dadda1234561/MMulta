package l2s.gameserver.tables;

import gnu.trove.map.TIntObjectMap;
import gnu.trove.map.hash.TIntObjectHashMap;
import gnu.trove.set.TIntSet;
import gnu.trove.set.hash.TIntHashSet;

import java.util.Arrays;
import java.util.Collection;

import l2s.gameserver.model.Player;
import l2s.gameserver.model.actor.instances.player.DualClass;
import l2s.gameserver.model.base.ClassId;
import l2s.gameserver.model.base.ClassLevel;
import l2s.gameserver.model.base.Race;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

/**
 * @author Bonux
 */
public final class DualClassTable
{
	private static final Logger _log = LoggerFactory.getLogger(DualClassTable.class);

	private static DualClassTable _instance;

	private TIntObjectMap<TIntSet> _dualClasses;

	public DualClassTable()
	{
		init();
	}

	public static DualClassTable getInstance()
	{
		if(_instance == null)
			_instance = new DualClassTable();
		return _instance;
	}

	private void init()
	{
		_dualClasses = new TIntObjectHashMap<TIntSet>();

		for(ClassId baseClassId : ClassId.VALUES)
		{
			if(baseClassId.isDummy())
				continue;

			if(baseClassId.isOutdated())
				continue;

			if(baseClassId.isOfLevel(ClassLevel.NONE))
				continue;

			if(baseClassId.isOfLevel(ClassLevel.FIRST))
				continue;

			TIntSet availDuals = new TIntHashSet();
			for(ClassId dualClassId : ClassId.VALUES)
			{
				if(dualClassId.isDummy())
					continue;

				if(dualClassId.isOutdated())
					continue;

				if(dualClassId.isOfLevel(ClassLevel.NONE))
					continue;

				if(dualClassId.isOfLevel(ClassLevel.FIRST))
					continue;

				if(!areClassesComportable(baseClassId, dualClassId))
					continue;

				availDuals.add(dualClassId.getId());
			}
			//availDuals.sort();
			_dualClasses.put(baseClassId.getId(), availDuals);
		}
		_log.info("DualClassTable: Loaded " + _dualClasses.size() + " dual-classes variations.");
	}

	public int[] getAvailableDualClasses(Player player, int classId, ClassLevel classLevel)
	{
		TIntSet dualClassesList = _dualClasses.get(classId);
		if(dualClassesList == null || dualClassesList.isEmpty())
			return new int[0];

		TIntSet tempDualClassesList = new TIntHashSet(dualClassesList.size());
		tempDualClassesList.addAll(dualClassesList);

		loop: for(int clsId : tempDualClassesList.toArray())
		{
			ClassId dualClassId = ClassId.VALUES[clsId];
			if(dualClassId.getClassLevel() != classLevel)
			{
				tempDualClassesList.remove(clsId);
				continue;
			}

			Collection<DualClass> playerDualClasses = player.getDualClassList().values();
			for(DualClass playerDualClass : playerDualClasses)
			{
				ClassId playerDualClassId = ClassId.VALUES[playerDualClass.getClassId()];
				if(!areClassesComportable(playerDualClassId, dualClassId))
				{
					tempDualClassesList.remove(clsId);
					continue loop;
				}
			}

			if(classLevel == ClassLevel.AWAKED)
				continue;
		}

		int[] result = tempDualClassesList.toArray();
		Arrays.sort(result);
		return result;
	}

	public int[] getAvailableSubClasses(Player player, int classId)
	{
		TIntSet subClassesList = _dualClasses.get(classId);
		if(subClassesList == null || subClassesList.isEmpty())
			return new int[0];

		TIntSet tempSubClassesList = new TIntHashSet(subClassesList.size());
		tempSubClassesList.addAll(subClassesList);

		loop: for(int clsId : tempSubClassesList.toArray())
		{
			ClassId subClassId = ClassId.valueOf(clsId);
			if(subClassId.getClassLevel() != ClassLevel.SECOND)
			{
				tempSubClassesList.remove(clsId);
				continue;
			}

			if(player.getRace() == Race.ELF && subClassId.isOfRace(Race.DARKELF) || player.getRace() == Race.DARKELF && subClassId.isOfRace(Race.ELF)) // эльфы несовместимы с темными
			{
				tempSubClassesList.remove(clsId);
				continue;
			}

			Collection<DualClass> playerSubClasses = player.getDualClassList().values();
			for(DualClass playerSubClass : playerSubClasses)
			{
				ClassId playerSubClassId = ClassId.valueOf(playerSubClass.getClassId());
				if(!areClassesComportable(playerSubClassId, subClassId))
				{
					tempSubClassesList.remove(clsId);
					continue loop;
				}
			}
		}

		int[] result = tempSubClassesList.toArray();
		Arrays.sort(result);
		return result;
	}

	public static boolean areClassesComportable(ClassId baseClassId, ClassId dualClassId)
	{
		if(baseClassId == dualClassId)
			return false;

		if(!baseClassId.isOfRace(Race.ERTHEIA) && baseClassId.getType2() == dualClassId.getType2())
			return false; // Однотипные.

		/*if(dualClassId == ClassId.TYRR_MAESTRO || dualClassId == ClassId.ISS_DOMINATOR)
			return false; // Данные классы запрещены к получению его как саб-класса.*/

		if(dualClassId.isOfRace(Race.ERTHEIA))
			return false; // Классы Артеас не можно получить в саб-класс.

		return true;
	}
}