package l2s.gameserver.instancemanager;

import gnu.trove.map.hash.TIntObjectHashMap;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.concurrent.locks.Lock;
import java.util.concurrent.locks.ReadWriteLock;
import java.util.concurrent.locks.ReentrantReadWriteLock;

import l2s.gameserver.data.xml.holder.DoorHolder;
import l2s.gameserver.data.xml.holder.TimeRestrictFieldHolder;
import l2s.gameserver.data.xml.holder.ZoneHolder;
import l2s.gameserver.geometry.Location;
import l2s.gameserver.model.entity.Reflection;
import l2s.gameserver.templates.TimeRestrictFieldInfo;
import l2s.gameserver.templates.ZoneTemplate;

public class ReflectionManager
{
	public static final Reflection MAIN = Reflection.createReflection(0);
	public static final Reflection PARNASSUS = Reflection.createReflection(-1);
	public static final Reflection GIRAN_HARBOR = Reflection.createReflection(-2);
	public static final Reflection JAIL = Reflection.createReflection(-3);
	public static final Reflection CTF_EVENT = Reflection.createReflection(-4);  //Добавлено
	public static final Reflection ALT_DIMENSION = Reflection.createReflection(-5);
	public static final Reflection STORM_ISLE = Reflection.createReflection(-1000);
	public static final Reflection PRIMEVAL_ISLE = Reflection.createReflection(-1001);
	public static final Reflection GOLDEN_ALTAR = Reflection.createReflection(-1002);
	public static final Reflection COAL_MINES = Reflection.createReflection(-1003);
	public static final Reflection IMPERIAL_TOMB = Reflection.createReflection(-1004);
	public static final Reflection TOWER_OF_INSOLENCE = Reflection.createReflection(-1005);
	public static final Reflection ASTATINE_FACTORY = Reflection.createReflection(-1006);
	public static final Reflection SUPERION_FORTRESS = Reflection.createReflection(-1007);
	public static final Reflection FROST_LORDS_CASTLE = Reflection.createReflection(-1008);
	public static final Reflection FAFURION_TEMPLE = Reflection.createReflection(-1011);
	public static final Reflection ORBIS_TEMPLE = Reflection.createReflection(-1010);
	public static final Reflection FAIRY_COLONY = Reflection.createReflection(-1009);
	public static final Reflection FOG_INSTANCE = Reflection.createReflection(-1012);
	public static final Reflection ADEN_SIEGE_INSTANCE = Reflection.createReflection(-1013);
	//public static final Reflection COAL_MINE = Reflection.createReflection(-1014);
	//public static final Reflection FROZEN_CANYON = Reflection.createReflection(-1015);

	private static final ReflectionManager _instance = new ReflectionManager();

	public static ReflectionManager getInstance() {
		return _instance;
	}

	private final TIntObjectHashMap<Reflection> _reflections = new TIntObjectHashMap<Reflection>();

	private final ReadWriteLock lock = new ReentrantReadWriteLock();
	private final Lock readLock = lock.readLock();
	private final Lock writeLock = lock.writeLock();

	private ReflectionManager() {
		//
	}

	public void init() {
		add(MAIN);
		add(PARNASSUS);
		add(GIRAN_HARBOR);
		add(JAIL);
		add(CTF_EVENT);//Добавлено
		add(ALT_DIMENSION);
		add(STORM_ISLE);
		add(PRIMEVAL_ISLE);
		add(GOLDEN_ALTAR);
		add(COAL_MINES);
		add(IMPERIAL_TOMB);
		add(TOWER_OF_INSOLENCE);
		add(ASTATINE_FACTORY);
		add(SUPERION_FORTRESS);
		add(FROST_LORDS_CASTLE);
		add(FAFURION_TEMPLE);
		add(ORBIS_TEMPLE);
		add(FAIRY_COLONY);
		add(FOG_INSTANCE);
		add(ADEN_SIEGE_INSTANCE);
		//add(COAL_MINE);
		//add(FROZEN_CANYON);

		// создаем в рефлекте все зоны, и все двери
		MAIN.init(DoorHolder.getInstance().getDoors(), ZoneHolder.getInstance().getZones());

		TimeRestrictFieldInfo field = TimeRestrictFieldHolder.getInstance().getFields().get(1);
		STORM_ISLE.setTeleportLoc(field.getEnterLoc());
		STORM_ISLE.setReturnLoc(field.getExitLoc());
		STORM_ISLE.spawnByGroup("storm_isle");
		//-----------------------------------------------
		field = TimeRestrictFieldHolder.getInstance().getFields().get(6);
		//PRIMEVAL_ISLE.setTeleportLoc(field.getEnterLoc());
		//PRIMEVAL_ISLE.setReturnLoc(field.getExitLoc());
		//PRIMEVAL_ISLE.spawnByGroup("primeval_isle");
		//-----------------------------------------------
		field = TimeRestrictFieldHolder.getInstance().getFields().get(7);
		GOLDEN_ALTAR.setTeleportLoc(field.getEnterLoc());
		GOLDEN_ALTAR.setReturnLoc(field.getExitLoc());
		GOLDEN_ALTAR.spawnByGroup("golden_altar");
		//-----------------------------------------------
		field = TimeRestrictFieldHolder.getInstance().getFields().get(11);
		COAL_MINES.setTeleportLoc(field.getEnterLoc());
		COAL_MINES.setReturnLoc(field.getExitLoc());
		COAL_MINES.spawnByGroup("coal_mines");
		//-----------------------------------------------
		field = TimeRestrictFieldHolder.getInstance().getFields().get(12);
		IMPERIAL_TOMB.setTeleportLoc(field.getEnterLoc());
		IMPERIAL_TOMB.setReturnLoc(field.getExitLoc());
		IMPERIAL_TOMB.spawnByGroup("imperial_tomb");
		//-----------------------------------------------
		field = TimeRestrictFieldHolder.getInstance().getFields().get(8);
		TOWER_OF_INSOLENCE.setTeleportLoc(field.getEnterLoc());
		TOWER_OF_INSOLENCE.setReturnLoc(field.getExitLoc());
		TOWER_OF_INSOLENCE.spawnByGroup("tower_of_insolence");
		//-----------------------------------------------
		field = TimeRestrictFieldHolder.getInstance().getFields().get(14);
		ASTATINE_FACTORY.setTeleportLoc(field.getEnterLoc());
		ASTATINE_FACTORY.setReturnLoc(field.getExitLoc());
		ASTATINE_FACTORY.spawnByGroup("AteliaRefineryZone");
		//-----------------------------------------------
		field = TimeRestrictFieldHolder.getInstance().getFields().get(23);
		SUPERION_FORTRESS.setTeleportLoc(field.getEnterLoc());
		SUPERION_FORTRESS.setReturnLoc(field.getExitLoc());
		SUPERION_FORTRESS.spawnByGroup("superion_fortress");
		//-----------------------------------------------
		field = TimeRestrictFieldHolder.getInstance().getFields().get(18);
		FROST_LORDS_CASTLE.setTeleportLoc(field.getEnterLoc());
		FROST_LORDS_CASTLE.setReturnLoc(field.getExitLoc());
		FROST_LORDS_CASTLE.spawnByGroup("frost_lords_castle");
		//-----------------------------------------------
		field = TimeRestrictFieldHolder.getInstance().getFields().get(21);
		FAFURION_TEMPLE.setTeleportLoc(field.getEnterLoc());
		FAFURION_TEMPLE.setReturnLoc(field.getExitLoc());
		FAFURION_TEMPLE.spawnByGroup("FAFURION_TEMPLE");
		//-----------------------------------------------
		field = TimeRestrictFieldHolder.getInstance().getFields().get(20);
		ORBIS_TEMPLE.setTeleportLoc(field.getEnterLoc());
		ORBIS_TEMPLE.setReturnLoc(field.getExitLoc());
		ORBIS_TEMPLE.spawnByGroup("ORBIS_TEMPLE");
		//-----------------------------------------------
		field = TimeRestrictFieldHolder.getInstance().getFields().get(19);
		FAIRY_COLONY.setTeleportLoc(field.getEnterLoc());
		FAIRY_COLONY.setReturnLoc(field.getExitLoc());
		FAIRY_COLONY.spawnByGroup("FAIRY_COLONY");
		//-----------------------------------------------
		field = TimeRestrictFieldHolder.getInstance().getFields().get(22);
		FOG_INSTANCE.setTeleportLoc(field.getEnterLoc());
		FOG_INSTANCE.setReturnLoc(field.getExitLoc());
		FOG_INSTANCE.spawnByGroup("FOG_INSTANCE");
		//-----------------------------------------------
		field = TimeRestrictFieldHolder.getInstance().getFields().get(23);
		ADEN_SIEGE_INSTANCE.setTeleportLoc(field.getEnterLoc());
		ADEN_SIEGE_INSTANCE.setReturnLoc(field.getExitLoc());
		ADEN_SIEGE_INSTANCE.spawnByGroup("ADEN_SIEGE_INSTANCE");
		//-----------------------------------------------
		//field = TimeRestrictFieldHolder.getInstance().getFields().get(24);
		//COAL_MINE.setTeleportLoc(field.getEnterLoc());
		//COAL_MINE.setReturnLoc(field.getExitLoc());
		//COAL_MINE.spawnByGroup("COAL_MINE");
		//-----------------------------------------------
		//field = TimeRestrictFieldHolder.getInstance().getFields().get(25);
		//FROZEN_CANYON.setTeleportLoc(field.getEnterLoc());
		//FROZEN_CANYON.setReturnLoc(field.getExitLoc());
		//FROZEN_CANYON.spawnByGroup("FROZEN_CANYON");

		Map<String, ZoneTemplate> _dummy = new HashMap<String, ZoneTemplate>();

		CTF_EVENT.init(DoorHolder.getInstance().getDoors(), _dummy);

		JAIL.setCoreLoc(new Location(-114648, -249384, -2984));

		// spawn alt spawns
		ALT_DIMENSION.spawnByGroup("alt_spawn");
	}

	public Reflection get(int id) {
		readLock.lock();
		try {
			return _reflections.get(id);
		} finally {
			readLock.unlock();
		}
	}

	public Reflection add(Reflection ref) {
		writeLock.lock();
		try {
			return _reflections.put(ref.getId(), ref);
		} finally {
			writeLock.unlock();
		}
	}

	public Reflection remove(Reflection ref) {
		writeLock.lock();
		try {
			return _reflections.remove(ref.getId());
		} finally {
			writeLock.unlock();
		}
	}

	public Reflection[] getAll() {
		readLock.lock();
		try {
			return _reflections.values(new Reflection[_reflections.size()]);
		} finally {
			readLock.unlock();
		}
	}

	public List<Reflection> getAllByIzId(int izId) {
		List<Reflection> reflections = new ArrayList<Reflection>();

		readLock.lock();
		try {
			for(Reflection r : getAll()) {
				if(r.getInstancedZoneId() == izId)
					reflections.add(r);
			}
		} finally {
			readLock.unlock();
		}
		return reflections;
	}

	public int getCountByIzId(int izId) {
		readLock.lock();
		try {
			int i = 0;
			for(Reflection r : getAll())
				if(r.getInstancedZoneId() == izId)
					i++;
			return i;
		} finally {
			readLock.unlock();
		}
	}

	public int size() {
		return _reflections.size();
	}
}