package l2s.gameserver.model.entity.events.objects;

import java.util.List;
import java.util.Set;

import l2s.gameserver.data.xml.holder.SkillHolder;
import l2s.gameserver.geometry.Location;
import l2s.gameserver.instancemanager.ReflectionManager;
import l2s.gameserver.model.Player;
import l2s.gameserver.model.Servitor;
import l2s.gameserver.model.Skill;
import l2s.gameserver.model.World;
import l2s.gameserver.model.actor.instances.creature.Abnormal;
import l2s.gameserver.model.actor.instances.player.Cubic;
import l2s.gameserver.model.entity.Hero;
import l2s.gameserver.model.entity.Reflection;
import l2s.gameserver.model.entity.events.impl.FightBattleEvent;
import l2s.gameserver.model.entity.events.impl.DuelEvent;
import l2s.gameserver.network.l2.s2c.RevivePacket;
import l2s.gameserver.skills.TimeStamp;
import l2s.gameserver.utils.ItemFunctions;

/**
 * @author Bonux
**/
public final class FightBattlePlayerObject implements Comparable<FightBattlePlayerObject>
{
	private Player _player;

	private double _damage = 0.;
	private int _winCount = 0;
	private boolean _killed = false;

	private Location _returnLoc = null;

	public FightBattlePlayerObject(Player player)
	{
		_player = player;
	}

	public String getName()
	{
		if(_player == null)
			return "";

		return _player.getName();
	}

	public int getObjectId()
	{
		if(_player == null)
			return 0;

		return _player.getObjectId();
	}

	public Player getPlayer()
	{
		return _player;
	}

	public void setDamage(double val)
	{
		_damage = val;
	}

	public double getDamage()
	{
		return _damage;
	}

	public void setWinCount(int val)
	{
		_winCount = val;
	}

	public int getWinCount()
	{
		return _winCount;
	}

	public void setKilled(boolean val)
	{
		_killed = val;
	}

	public boolean isKilled()
	{
		return _killed;
	}

	@Override
	public int compareTo(FightBattlePlayerObject o)
	{
		return _player.getLevel() - o.getPlayer().getLevel();
	}

	public void teleportPlayer(FightBattleArenaObject arena)
	{
		Player player = _player;
		if(player == null)
			return;

		if(player.isTeleporting())
		{
			_player = null;
			return;
		}

		if(player.isInObserverMode())
			player.leaveObserverMode();

		// Un activate clan skills
		if(player.getClan() != null)
			player.getClan().disableSkills(player);

		// Remove Hero Skills
		player.activateHeroSkills(false);

		// Abort casting if player casting
		if(player.isCastingNow())
			player.abortCast(true, true);

		// Abort attack if player attacking
		if(player.isAttackingNow())
			player.abortAttack(true, true);

		// Удаляем баффы и чужие кубики
		for(Abnormal abnormal : player.getAbnormalList())
		{
			if(!player.isSpecialAbnormal(abnormal.getSkill()))
				abnormal.exit();
		}

		for(Cubic cubic : player.getCubics())
		{
			if(player.getSkillLevel(cubic.getSkill().getId()) <= 0)
				cubic.delete();
		}

		// Remove Servitor's Buffs
		for(Servitor servitor : player.getServitors())
		{
			if(servitor.isPet())
				servitor.unSummon(false);
			else
			{
				servitor.getAbnormalList().stopAll();
				servitor.transferOwnerBuffs();
			}
		}

		// unsummon agathion
		if(player.getAgathionNpcId() > 0)
			player.deleteAgathion();

		// Сброс кулдауна всех скилов, время отката которых меньше 15 минут
		for(TimeStamp sts : player.getSkillReuses())
		{
			if(sts == null)
				continue;

			Skill skill = SkillHolder.getInstance().getSkill(sts.getId(), sts.getLevel());
			if(skill == null)
				continue;

			if(sts.getReuseBasic() <= 15 * 60001L)
				player.enableSkill(skill);
		}

		// Обновляем скилл лист, после удаления скилов
		player.sendSkillList();

		// Проверяем одетые вещи на возможность ношения.
		player.getInventory().validateItems();

		// remove bsps/sps/ss automation
		player.removeAutoShots(true);

		player.setCurrentCp(player.getMaxCp());
		player.setCurrentMp(player.getMaxMp());

		if(player.isDead())
		{
			player.setCurrentHp(player.getMaxHp(), true);
			player.broadcastPacket(new RevivePacket(player));
			//player.broadcastStatusUpdate();
		}
		else
			player.setCurrentHp(player.getMaxHp(), false);

		player.broadcastUserInfo(true);

		DuelEvent duel = player.getEvent(DuelEvent.class);
		if(duel != null)
			duel.abortDuel(player);

		_returnLoc = player.getStablePoint() == null ? player.getLoc() : player.getStablePoint();

		if(player.isSitting())
			player.standUp();

		player.setTarget(null);

		player.leaveParty(false);

		player.setStablePoint(_returnLoc);

		Location loc = arena.getMember1() == this ? arena.getInfo().getTeleportLoc1() : arena.getInfo().getTeleportLoc2();
		player.teleToLocation(Location.findPointToStay(loc, 0, arena.getReflection().getGeoIndex()), arena.getReflection());

		setDamage(0.);
		setKilled(false);
	}

	public void onStopEvent(FightBattleEvent event)
	{
		Player player = _player;
		if(player == null)
			return;

		if(_returnLoc == null) // игрока не портнуло на стадион
			return;

		player.removeEvent(event);

		if(player.isDead())
		{
			player.setCurrentHp(player.getMaxHp(), true);
			player.broadcastPacket(new RevivePacket(player));
			//player.broadcastStatusUpdate();
		}
		else
			player.setCurrentHp(player.getMaxHp(), false);

		player.setCurrentCp(player.getMaxCp());
		player.setCurrentMp(player.getMaxMp());

		// Возвращаем клановые скиллы если репутация положительная.
		if(player.getClan() != null && player.getClan().getReputationScore() >= 0)
			player.getClan().enableSkills(player);

		// Add Hero Skills
		player.activateHeroSkills(true);

		// Обновляем скилл лист, после добавления скилов
		player.sendSkillList();

		player.setStablePoint(null);
		player.teleToLocation(_returnLoc, ReflectionManager.MAIN);
	}

	public void onDamage(double damage)
	{
		setDamage(getDamage() + damage);
	}

	public void onKill(FightBattleEvent event, FightBattlePlayerObject killer)
	{
		setKilled(true);
	}

	public void onTeleport(FightBattleEvent event, Player player, int x, int y, int z, Reflection reflection)
	{
		onExit(event);
	}

	public void onExit(FightBattleEvent event)
	{
		Player player = _player;
		if(player == null)
			return;

		player.removeEvent(event);

		if(player.isDead())
			player.setCurrentHp(player.getMaxHp(), true);
		else
			player.setCurrentHp(player.getMaxHp(), false);

		player.setCurrentCp(player.getMaxCp());
		player.setCurrentMp(player.getMaxMp());
	}
}
