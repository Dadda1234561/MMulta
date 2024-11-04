package l2s.gameserver.model.entity.events.impl.fightclub;

import java.util.ArrayList;
import java.util.List;
import java.util.concurrent.CopyOnWriteArrayList;

import l2s.commons.collections.MultiValueSet;
import l2s.commons.util.Rnd;
import l2s.gameserver.ThreadPoolManager;
import l2s.gameserver.geometry.Location;
import l2s.gameserver.model.Creature;
import l2s.gameserver.model.Player;
import l2s.gameserver.model.SimpleSpawner;
import l2s.gameserver.model.Zone;
import l2s.gameserver.model.entity.events.fightclubmanager.FightClubPlayer;
import l2s.gameserver.model.entity.events.fightclubmanager.enums.EventState;
import l2s.gameserver.model.entity.events.impl.AbstractFightClub;
import l2s.gameserver.model.instances.NpcInstance;

public class LuckyCreaturesEvent extends AbstractFightClub
{
	private final int _monstersCount;
	private final int[] _monsterTemplates;
	private final int _respawnSeconds;
	private List<NpcInstance> _monsters = new CopyOnWriteArrayList<NpcInstance>();
	private List<Long> _deathTimes = new CopyOnWriteArrayList<Long>();

	public LuckyCreaturesEvent(MultiValueSet<String> set)
	{
		super(set);
		_monstersCount = set.getInteger("monstersCount", 1);
		_respawnSeconds = set.getInteger("monstersRespawn", 60);
		_monsterTemplates = parseExcludedSkills(set.getString("monsterTemplates", "14200"));
	}

	public void onKilled(Creature actor, Creature victim)
	{
		if (victim.isMonster() && actor != null && actor.isPlayable())
		{
			FightClubPlayer fActor = getFightClubPlayer(actor.getPlayer());
			fActor.increaseKills(true);
			updatePlayerScore(fActor);
			actor.getPlayer().sendUserInfo();

			_deathTimes.add(Long.valueOf(System.currentTimeMillis() + _respawnSeconds * 1000));
			_monsters.remove(victim);
		}

		super.onKilled(actor, victim);
	}

	public void startEvent()
	{
		super.startEvent();

		ThreadPoolManager.getInstance().schedule(new RespawnThread(), 30000L);

		for (Zone zone : getReflection().getZones())
			zone.setType(Zone.ZoneType.peace_zone);
	}

	public void startRound()
	{
		super.startRound();

		System.out.println("spawning " + _monstersCount + " monsters");
		for (int i = 0; i < _monstersCount; i++)
		{
			spawnMonster();
		}
	}

	@Override
	public void stopEvent(boolean force)
	{
		super.stopEvent(force);

		for (NpcInstance npc : _monsters)
		{
			if (npc != null)
			{
				npc.doDecay();
			}
		}
		_monsters.clear();
	}

	private void spawnMonster()
	{
		Zone zone = getReflection().getZones().iterator().next();
		Location loc = zone.getTerritory().getRandomLoc(getReflection().getGeoIndex(), false);
		int template = Rnd.get(_monsterTemplates);
		SimpleSpawner spawn = new SimpleSpawner(template);

		spawn.setSpawnRange((geoIndex, fly) -> loc);
		spawn.setAmount(1);
		spawn.setRespawnDelay(0);
		spawn.setReflection(getReflection());

		NpcInstance monster = spawn.spawnOne();
		monster.getMovement().moveToLocation(Location.coordsRandomize(loc.getX(), loc.getY(), loc.getZ(), monster.getHeading(), 100, 200), 10, true);
		monster.sendActionFailed();
		spawn.stopRespawn();

		_monsters.add(monster);
	}

	protected boolean inScreenShowBeScoreNotKills()
	{
		return false;
	}

	public boolean isFriend(Creature c1, Creature c2)
	{
		return !c1.isMonster() && !c2.isMonster();
	}

	public String getVisibleTitle(Player player, String currentTitle, boolean toMe)
	{
		final FightClubPlayer fPlayer = getFightClubPlayer(player);
		if (fPlayer == null)
		{
			return currentTitle;
		}

		return "Kills: " + fPlayer.getKills(true);
	}

	private class RespawnThread implements Runnable
	{
		@Override
		public void run()
		{
			if (getState() == EventState.OVER || getState() == EventState.NOT_ACTIVE)
			{
				return;
			}

			final long current = System.currentTimeMillis();
			final List<Long> toRemove = new ArrayList<Long>();
			for (Long deathTime : _deathTimes)
			{
				if (deathTime.longValue() < current)
				{
					LuckyCreaturesEvent.this.spawnMonster();
					toRemove.add(deathTime);
				}
			}

			for (Long l : toRemove)
			{
				_deathTimes.remove(l);
			}

			ThreadPoolManager.getInstance().schedule(this, 10000L);
		}
	}

	@Override
	public boolean removeBuffsOnEnter() {
		return false;
	}

	@Override
	public boolean removeBuffsOnDeath() {
		return false;
	}

	@Override
	public boolean canUseBuffer(Player player, boolean heal) {
		return true;
	}

	@Override
	public boolean giveKarma() {
		return false;
	}

	@Override
	public boolean startFlagTask() {
		return false;
	}
}