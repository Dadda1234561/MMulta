package l2s.gameserver.model;

import java.time.Duration;
import java.time.Instant;
import java.time.LocalDateTime;
import java.time.ZoneOffset;
import java.util.ArrayList;
import java.util.LinkedHashSet;
import java.util.List;
import java.util.Set;

import l2s.commons.collections.MultiValueSet;
import l2s.commons.time.cron.SchedulingPattern;
import l2s.commons.util.Rnd;
import l2s.gameserver.Announcements;
import l2s.gameserver.Config;
import l2s.gameserver.ThreadPoolManager;
import l2s.gameserver.data.xml.holder.NpcHolder;
import l2s.gameserver.geodata.GeoEngine;
import l2s.gameserver.geometry.Location;
import l2s.gameserver.instancemanager.ReflectionManager;
import l2s.gameserver.model.entity.Reflection;
import l2s.gameserver.model.entity.events.Event;
import l2s.gameserver.model.entity.events.EventOwner;
import l2s.gameserver.model.instances.NpcInstance;
import l2s.gameserver.model.instances.PetInstance;
import l2s.gameserver.network.l2.components.ChatType;
import l2s.gameserver.taskmanager.SpawnTaskManager;
import l2s.gameserver.templates.npc.MinionData;
import l2s.gameserver.templates.npc.NpcTemplate;
import l2s.gameserver.templates.spawn.SpawnRange;
import l2s.gameserver.templates.spawn.SpawnTemplate;

import l2s.gameserver.utils.TimeUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

/**
 * @author VISTALL
 * @date 5:49/19.05.2011
 */
public abstract class Spawner extends EventOwner implements Cloneable
{
	protected static final Logger _log = LoggerFactory.getLogger(Spawner.class);
	protected static final int MIN_RESPAWN_DELAY = 20;

	protected int _maximumCount;
	protected int _referenceCount;
	protected int _currentCount;
	protected int _scheduledCount;

	protected int _respawnDelay, _respawnDelayRandom;

	protected SchedulingPattern _respawnPattern;

	protected Set<Integer> _announceMinutesBeforeSpawn;
	protected String _announceType;

	protected int _respawnTime;

	protected boolean _doRespawn;

	protected NpcInstance _lastSpawn;

	protected List<NpcInstance> _spawned;

	protected Reflection _reflection = ReflectionManager.MAIN;

	public String getName()
	{
		return "";
	}

	public void decreaseScheduledCount()
	{
		if(_scheduledCount > 0)
			_scheduledCount--;
	}

	public boolean isDoRespawn()
	{
		return _doRespawn;
	}

	public Reflection getReflection()
	{
		return _reflection;
	}

	public void setReflection(Reflection reflection)
	{
		_reflection = reflection;

		for(NpcInstance npc : _spawned)
			npc.setReflection(reflection);
	}

	public int getRespawnDelay()
	{
		return _respawnDelay;
	}

	public int getRespawnDelayRandom()
	{
		return _respawnDelayRandom;
	}

	public int getRespawnDelayWithRnd()
	{
		return _respawnDelayRandom == 0 ? _respawnDelay : Rnd.get(_respawnDelay - _respawnDelayRandom, _respawnDelay);
	}

	public SchedulingPattern getRespawnPattern()
	{
		return _respawnPattern;
	}

	public boolean hasRespawn()
	{
		if(getRespawnDelay() == 0 && getRespawnDelayRandom() == 0 && getRespawnPattern() == null)
			return false;
		return true;
	}

	public int getRespawnTime()
	{
		return _respawnTime;
	}

	public NpcInstance getLastSpawn()
	{
		return _lastSpawn;
	}

	public void setAmount(int amount)
	{
		if(_referenceCount == 0)
			_referenceCount = amount;
		_maximumCount = amount;
	}

	public void deleteAll()
	{
		stopRespawn();
		for(NpcInstance npc : _spawned)
			npc.deleteMe();
		_spawned.clear();
		_respawnTime = 0;
		_scheduledCount = 0;
		_currentCount = 0;
	}

	//-----------------------------------------------------------------------------------------------------------------------------------
	public abstract void decreaseCount(NpcInstance oldNpc);

	public abstract NpcInstance doSpawn(boolean spawn);

	public abstract void respawnNpc(NpcInstance oldNpc);

	protected abstract NpcInstance initNpc(NpcInstance mob, boolean spawn);

	public abstract int getMainNpcId();

	public abstract SpawnRange getRandomSpawnRange();

	public abstract Spawner clone();

	//-----------------------------------------------------------------------------------------------------------------------------------
	public int init()
	{
		while(_currentCount + _scheduledCount < _maximumCount)
			doSpawn(false);

		_doRespawn = true;

		return _currentCount;
	}

	public NpcInstance spawnOne()
	{
		return doSpawn(false);
	}

	public void stopRespawn()
	{
		_doRespawn = false;
	}

	public void startRespawn()
	{
		_doRespawn = true;
	}

	//-----------------------------------------------------------------------------------------------------------------------------------
	public List<NpcInstance> getAllSpawned()
	{
		return _spawned;
	}

	public NpcInstance getFirstSpawned()
	{
		List<NpcInstance> npcs = getAllSpawned();
		return npcs.size() > 0 ? npcs.get(0) : null;
	}

	public void setRespawnDelay(int respawnDelay, int respawnDelayRandom)
	{
		if(respawnDelay < 0 && respawnDelay != -3)
			_log.warn("respawn delay is negative");

		_respawnDelay = respawnDelay;
		_respawnDelayRandom = respawnDelayRandom;
	}

	public void setRespawnDelay(int respawnDelay)
	{
		setRespawnDelay(respawnDelay, 0);
	}

	public void setRespawnPattern(SchedulingPattern pattern)
	{
		_respawnPattern = pattern;
	}

	public boolean hasPreSpawnAnnounces() {
		if (_announceMinutesBeforeSpawn == null) {
			_announceMinutesBeforeSpawn = new LinkedHashSet<>();
		}
		return !_announceMinutesBeforeSpawn.isEmpty();
	}

	public void setPreSpawnAnnounce(Set<Integer> minutes) {
		if (_announceMinutesBeforeSpawn == null) {
			_announceMinutesBeforeSpawn = new LinkedHashSet<>();
		} else {
			_announceMinutesBeforeSpawn.clear();
		}
		_announceMinutesBeforeSpawn.addAll(minutes);
	}


	public void setRespawnTime(int respawnTime)
	{
		_respawnTime = respawnTime;
	}

	//-----------------------------------------------------------------------------------------------------------------------------------
	protected NpcInstance doSpawn0(NpcTemplate template, boolean spawn, MultiValueSet<String> set, List<MinionData> minions)
	{
		if(template.isInstanceOf(PetInstance.class))
		{
			_currentCount++;
			return null;
		}

		NpcInstance tmp = template.getNewInstance(set);
		if(tmp == null)
			return null;

		if(!minions.isEmpty())
		{
			for(MinionData minionData : minions)
				tmp.getMinionList().addMinion(minionData);
		}

		if(!spawn && _respawnDelay != -3)
			spawn = _respawnTime <= System.currentTimeMillis() / 1000 + MIN_RESPAWN_DELAY;

		return initNpc(tmp, spawn);
	}

	protected NpcInstance initNpc0(NpcInstance mob, Location newLoc, boolean spawn)
	{
		// Set the HP and MP of the L2NpcInstance to the max
		mob.setCurrentHpMp(mob.getMaxHp(), mob.getMaxMp(), true); // TODO: Нужно ли здесь? Есть же в NpcInstance:onSpawn

		// Link the L2NpcInstance to this L2Spawn
		mob.setSpawn(this);

		// save spawned points
		mob.setSpawnedLoc(newLoc);

		// Является ли моб "подземным" мобом?
		mob.setUnderground(GeoEngine.getLowerHeight(newLoc, getReflection().getGeoIndex()) < GeoEngine.getLowerHeight(newLoc.clone().changeZ(5000), getReflection().getGeoIndex()));

		for(Event e : getEvents())
			mob.addEvent(e);

		if(spawn)
		{
			// Спавнится в указанном отражении
			mob.setReflection(getReflection());

			// Init other values of the L2NpcInstance (ex : from its CreatureTemplate for INT, STR, DEX...) and add it in the world as a visible object
			mob.spawnMe(newLoc);

			// Increase the current number of L2NpcInstance managed by this L2Spawn
			_currentCount++;
		}
		else
		{
			mob.setLoc(newLoc);

			// Update the current number of SpawnTask in progress or stand by of this L2Spawn
			_scheduledCount++;

			SpawnTaskManager.getInstance().addSpawnTask(mob, _respawnTime * 1000L - System.currentTimeMillis());

			if (hasPreSpawnAnnounces())
			{
				schedulePreSpawnAnnounces(mob);
			}
		}

		_spawned.add(mob);
		_lastSpawn = mob;
		return mob;
	}

	private void schedulePreSpawnAnnounces(NpcInstance npc)
	{
		final long nextSpawnTime = _respawnTime * 1000L;
		for (int minute : _announceMinutesBeforeSpawn)
		{
			// check if we have available time
			if ((nextSpawnTime - System.currentTimeMillis()) < (minute * 60 * 1000L))
			{
				continue;
			}

			switch (_announceType)
			{
				case "EPIC":
					ThreadPoolManager.getInstance().schedule(() -> Announcements.announceToAllFromStringHolder("custom.CustomEpicBoss.PreSpawn", npc.getName(), String.valueOf(minute)), getTimeOffset(nextSpawnTime, minute));
					break;
				case "WORLD":
					ThreadPoolManager.getInstance().schedule(() -> Announcements.announceToAllFromStringHolder("custom.CustomWorldBoss.PreSpawn", npc.getName(), String.valueOf(minute)), getTimeOffset(nextSpawnTime, minute));
					break;
				default:
					ThreadPoolManager.getInstance().schedule(() -> Announcements.announceToAllFromStringHolder("custom.CustomRewardBoss.PreSpawn", npc.getName(), String.valueOf(minute)), getTimeOffset(nextSpawnTime, minute));
					break;
			}

			_log.info("Spawner: [" + _announceType + "] Scheduled pre announce task for [" + npc.getNpcId() + "][" + npc.getName() + "] in " + minute + " minutes.. [" + TimeUtils.toSimpleFormat(nextSpawnTime) + "]");
		}
	}

	private long getTimeOffset(long time, int minutes) {
		LocalDateTime spawnDateTime = LocalDateTime.ofInstant(Instant.ofEpochMilli(time), ZoneOffset.systemDefault());
		return Duration.between(LocalDateTime.now(), spawnDateTime.minusMinutes(minutes)).toMillis();
	}

	public void setAnnounceType(String type)
	{
		_announceType = type;
	}

	public void decreaseCount0(NpcTemplate template, NpcInstance spawnedNpc, long deathTime)
	{
		_currentCount--;

		if(_currentCount < 0)
			_currentCount = 0;

		if(template == null || spawnedNpc == null)
			return;

		if(!hasRespawn())
			return;

		if(isDoRespawn() && _scheduledCount + _currentCount < _maximumCount)
		{
			// Update the current number of SpawnTask in progress or stand by of this L2Spawn
			_scheduledCount++;
			_respawnTime = Math.max(calcRespawnTime(deathTime, template.isRaid), (int) ((System.currentTimeMillis() + 1000) / 1000));

			SpawnTaskManager.getInstance().addSpawnTask(spawnedNpc, _respawnTime * 1000L - System.currentTimeMillis());

			if (hasPreSpawnAnnounces())
			{
				schedulePreSpawnAnnounces(spawnedNpc);
			}
		}
	}

	public int calcRespawnTime(long deathTime, boolean isRaid)
	{
		int respawnTime;
		if(getRespawnPattern() != null)
			respawnTime = (int) (getRespawnPattern().next(deathTime) / 1000);
		else
		{
			long delay = (long) (isRaid ? Config.ALT_RAID_RESPAWN_MULTIPLIER : 1.) * getRespawnDelayWithRnd() * 1000L;
			respawnTime = (int) ((deathTime + delay) / 1000);
		}
		return respawnTime;
	}
	
	public List<NpcInstance> initAndReturn()
	{
		List<NpcInstance> spawnedNpcs = new ArrayList<NpcInstance>();
		while((_currentCount + _scheduledCount) < (_maximumCount))
			spawnedNpcs.add(doSpawn(false));

		_doRespawn = true;

		return spawnedNpcs;
	}

	public SpawnTemplate getTemplate()
	{
		return null;
	}
}
