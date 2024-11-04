package l2s.gameserver.model.actor.instances.player;

import l2s.gameserver.ThreadPoolManager;
import l2s.gameserver.ai.CtrlIntention;
import l2s.gameserver.geodata.GeoEngine;
import l2s.gameserver.geometry.Location;
import l2s.gameserver.model.Creature;
import l2s.gameserver.model.GameObject;
import l2s.gameserver.model.Player;
import l2s.gameserver.model.World;
import l2s.gameserver.model.instances.ChestInstance;
import l2s.gameserver.model.instances.NpcInstance;
import l2s.gameserver.model.items.ItemInstance;
import l2s.gameserver.network.l2.s2c.ExAutoplayDoMacro;
import l2s.gameserver.network.l2.s2c.ExAutoplaySetting;
import l2s.gameserver.network.l2.s2c.ExServerPrimitivePacket;
import l2s.gameserver.utils.ItemFunctions;

import java.awt.Color;
import java.util.ArrayList;
import java.util.Comparator;
import java.util.List;
import java.util.concurrent.ScheduledFuture;
import java.util.concurrent.atomic.AtomicBoolean;
import java.util.concurrent.atomic.AtomicInteger;
import java.util.concurrent.locks.Lock;
import java.util.concurrent.locks.ReentrantLock;

import static l2s.gameserver.ai.CtrlIntention.AI_INTENTION_ACTIVE;
import static l2s.gameserver.ai.CtrlIntention.AI_INTENTION_FOLLOW;
import static l2s.gameserver.ai.PlayableAI.AINextAction.ATTACK;
import static l2s.gameserver.ai.PlayableAI.AINextAction.CAST;

public class AutoFarm
{
	/* Targeting */
	private static final int DEFAULT = 0;
	private static final int HOSTILE_PC = 1;
	private static final int HOSTILE_NPC = 2;
	private static final int FRIENDLY_NPC = 3;

	private final Lock _onUseLock = new ReentrantLock();
	private final Lock _onRangeUseLock = new ReentrantLock();

	private final ThreadLocal<List<ItemInstance>> ITEM_LIST = ThreadLocal.withInitial(ArrayList::new);
	private final ThreadLocal<List<NpcInstance>> NPC_LIST = ThreadLocal.withInitial(ArrayList::new);

	public boolean isLockedMob(int npcId) {
		return false;
	}

    private class DistanceComparator implements Comparator<GameObject>
	{
		@Override
		public int compare(GameObject o1, GameObject o2)
		{
			int dist1 = _owner.getDistance(o1);
			int dist2 = _owner.getDistance(o2);
			return Integer.compare(dist1, dist2);
		}
	}

	private final Player _owner;

	private final DistanceComparator _distanceComparator = new DistanceComparator();

	private int _unkParam1 = 12;
	private int _nextTargetMode = 0;

	private boolean _farmActivate = false;
	private boolean _autoPickUpItems = false;
	private boolean _meleeAttackMode = false;
	private int _healPercent = 0;
	private int _petHealPercent = 0;
	private int _macroIndex = 0;
	private boolean _politeFarm = false;
	private AtomicInteger targetFails = new AtomicInteger(0);
	private final int _sweeperSkillId = 42;

	private AtomicInteger _shortAttackRange = new AtomicInteger(600);
	private AtomicInteger _longAttackRange = new AtomicInteger(1400);
	private AtomicInteger _height = new AtomicInteger(500);

	private AtomicBoolean _targetRaid = new AtomicBoolean(false);
	private AtomicBoolean _fixedZone = new AtomicBoolean(false);
	private AtomicBoolean _showRadius = new AtomicBoolean(false);
	private Location _fixedPoint = null;

	private ScheduledFuture<?> _farmTask = null;
	private ScheduledFuture<?> _rangeUpdateTask = null;

	public AutoFarm(Player owner)
	{
		_owner = owner;
	}

	public Player getOwner()
	{
		return _owner;
	}

	public int getOptions()
	{
		return _unkParam1;
	}

	public void setOptions(int unkParam1)
	{
		this._unkParam1 = unkParam1;
	}

	public boolean isFarmActivate()
	{
		return _farmActivate;
	}

	public void setFarmActivate(boolean farmActivate)
	{
		_farmActivate = farmActivate;
	}

	public boolean isAutoPickUpItems()
	{
		return _autoPickUpItems;
	}

	public void setAutoPickUpItems(boolean autoPickUpItems)
	{
		_autoPickUpItems = autoPickUpItems;
	}

	public int getNextTargetMode()
	{
		return _nextTargetMode;
	}

	public void setNextTargetMode(int nextTargetMode)
	{
		_nextTargetMode = nextTargetMode;
	}

	public boolean isMeleeAttackMode()
	{
		return _meleeAttackMode;
	}

	public void setMeleeAttackMode(boolean meleeAttackMode) {
		_meleeAttackMode = meleeAttackMode;
		if (showRadius()) {
			updateFarmRange(isFixedZone() ? _fixedPoint : _owner.getLoc());
		}
	}

	public void setLongAttackRange(int longAttackRange) {
		_longAttackRange.set(longAttackRange);
		if (showRadius()) {
			updateFarmRange(isFixedZone() ? _fixedPoint : _owner.getLoc());
		}
	}

	public void setShortAttackRange(int shortAttackRange) {
		_shortAttackRange.set(shortAttackRange);
		if (showRadius()) {
			updateFarmRange(isFixedZone() ? _fixedPoint : _owner.getLoc());
		}
	}

	public int getHealPercent() {
		return _healPercent;
	}

	public int getPetHealPercent() {
		return _petHealPercent;
	}

	public void setMacroIndex(int index) {
		_macroIndex = index;
	}
	public int getMacroIndex() {
		return _macroIndex;
	}

	public void setHealPercent(int healPercent) {
		_healPercent = healPercent;
	}

	public void setPetHealPercent(int healPercent) {
		_petHealPercent = healPercent;
	}

	public boolean isPoliteFarm() {
		return _politeFarm;
	}

	public void setPoliteFarm(boolean politeFarm) {
		_politeFarm = politeFarm;
	}

	public boolean isTargetRaid() {
		return _targetRaid.get();
	}

	public void setTargetRaid(boolean targetRaid) {
		_targetRaid.set(targetRaid);
	}

	public boolean isFixedZone() {
		return _fixedZone.get();
	}

	public void setFixedZone(boolean fixedZone, Location loc) {
		_fixedZone.set(fixedZone);
		_fixedPoint = null;
		if (isFixedZone()) {
			_fixedPoint = loc == null ? _owner.getLoc().clone() : loc;
		}
		if (showRadius()) {
			updateFarmRange(isFixedZone() ? _fixedPoint : _owner.getLoc());
		}
	}

	public Location getFixedPoint() {
		return _fixedZone.get() ? _fixedPoint : null;
	}

	public boolean showRadius() {
		return _showRadius.get();
	}

	public void setShowRadius(boolean showRadius) {
		_showRadius.set(showRadius);
		updateFarmRange(isFixedZone() ? _fixedPoint : _owner.getLoc());
		doRangeDisplayUpdate();
	}

	public synchronized void doRangeDisplayUpdate()
	{
		_onRangeUseLock.lock();

		try {
			if (showRadius()) {
				if (_rangeUpdateTask == null) {
					_rangeUpdateTask = ThreadPoolManager.getInstance().scheduleAtFixedDelay(this::updateFarmRange, 222, 222);
				}
			} else if (!showRadius()) {
				if (_rangeUpdateTask != null) {
					_rangeUpdateTask.cancel(false);
					_rangeUpdateTask = null;
				}
			}

		} finally {
			_onRangeUseLock.unlock();
		}

	}

	public synchronized void doAutoFarm()
	{
		_onUseLock.lock();

		try {
			if (_owner.isTeleporting() || _owner.isDead() || _owner.isMounted() || _owner.isTransformed()) {
				_farmActivate = false;
				_owner.sendPacket(new ExAutoplaySetting(_owner));
				return;
			}

			if (!isFarmActivate()) {
				if (_farmTask != null) {
					_farmTask.cancel(false);
					_farmTask = null;
				}
				return;
			}

			if (_farmTask == null) {
				_farmTask = ThreadPoolManager.getInstance().scheduleAtFixedDelay(this::doAutoFarm, 1L, 100L);
			}

			if (_owner.getAI().getIntention() == CtrlIntention.AI_INTENTION_PICK_UP)
				return;

			GameObject target = _owner.getTarget();
			if (!checkTargetCondition(target))
			{
				target = findAutoFarmTarget();
				if (target != null) {
					if (target.isItem()) {
						_owner.getAI().setIntention(CtrlIntention.AI_INTENTION_PICK_UP, target, null);
						return;
					}
					_owner.setTarget(target);
				}
			}

			if ((target == null) || (_owner.getTarget() != null) && (!_owner.getTarget().isMonster()))
				return;

			if (!_owner.getAutoShortCuts().autoSkillsActive()) {
				if (!_owner.isMageClass() || isFarmActivate()) {
					_owner.sendPacket(ExAutoplayDoMacro.STATIC_PACKET);
				}
			}

			if (!_owner.getAutoShortCuts().autoSkillsActive() && _owner.getShortCut(276, 23) != null) {
				_owner.sendPacket(ExAutoplayDoMacro.STATIC_PACKET);
			}

			if (!_owner.isMageClass()) {
				if (_owner.getMovement().isFollowing(target.getObjectId())) {
					return;
				}
				target.onAction(_owner, false);
			}
		}
		finally {
			_onUseLock.unlock();
		}
	}

	private int getTargetRange() {
		return _meleeAttackMode ? _shortAttackRange.get() : _longAttackRange.get();
	}

	private GameObject findAutoFarmTarget()
	{
		// Check for NPCs
		NpcInstance closestNpc = null;
		int closestDistance = Integer.MAX_VALUE;

        List<NpcInstance> aroundNpc = NPC_LIST.get();
		World.getAroundNpc(aroundNpc, _owner, getFixedPoint(), _owner.getCurrentRegion(), _owner.getReflectionId(), getTargetRange(), _height.get());
        for (int i = 0; i < aroundNpc.size(); i++)
		{
            boolean condition;
			if (_owner.hasServitor())
			{
				condition = checkNpcCondition(aroundNpc.get(i), true);
			}
			else
			{
			    condition = checkNpcCondition(aroundNpc.get(i), false) && !(aroundNpc.get(i) instanceof ChestInstance);
			}

            if (condition)
			{
                if (_owner.getDistance(aroundNpc.get(i)) < closestDistance)
				{
                    closestDistance = _owner.getDistance(aroundNpc.get(i));
                    closestNpc = aroundNpc.get(i);
                }
            }
        }

		// Check for items to pick up
		if (isAutoPickUpItems())
		{
			ItemInstance closestItem = null;

			List<ItemInstance> aroundItems = ITEM_LIST.get();
			World.getAroundItems(aroundItems, _owner, getFixedPoint(), getTargetRange(), _height.get());
			for (int i = 0; i < aroundItems.size(); i++)
			{
				if (aroundItems.get(i).isVisible() && ItemFunctions.checkIfCanPickup(_owner, aroundItems.get(i)) && aroundItems.get(i).getDropTimeOwner() <= System.currentTimeMillis() && GeoEngine.canMoveToCoord(_owner, aroundItems.get(i)))
				{
					if (_owner.getDistance(aroundItems.get(i)) < closestDistance)
					{
						closestDistance = _owner.getDistance(aroundItems.get(i));
						closestItem = aroundItems.get(i);
					}
				}
			}
			aroundItems.clear();

			if (closestItem == null) {
				return closestNpc;
			}
			return closestItem;
		}

		aroundNpc.clear();
		return closestNpc;
	}

	private boolean checkTargetCondition(GameObject target)
	{
		if(target == null)
			return false;
		if(!target.isNpc())
			return false;
		if (_fixedZone.get())
			if(!target.isInRange(_fixedZone.get() ? _fixedPoint : _owner, getTargetRange()))
				return false;

        return !((Creature) target).isDead();
    }

	private boolean checkNpcCondition(NpcInstance npc, boolean help)
	{
		if(!npc.isMonster())
			return false;
		if(npc.isAlikeDead())
			return false;
		if(npc.isInvulnerable())
			return false;
		if(npc.isRaid() && !_targetRaid.get())
			return false;
		if(npc.getLeader() != null && npc.getLeader().isRaid())
			return false;
		if(!npc.isInRange(_fixedZone.get() ? _fixedPoint : _owner, getTargetRange()))
			return false;
		if(npc.isInvisible(_owner))
			return false;
		if(!npc.isAutoAttackable(_owner))
			return false;
		if(npc.getReflectionId() != _owner.getReflectionId())
			return false;
		if (!GeoEngine.canSeeTarget(_owner, npc)) {
			return false;
		}

		if(npc.isInCombat())
		{
			Creature[] npcTargets = new Creature[]{npc.getAI().getAttackTarget(), npc.getAI().getCastTarget()};
			for(Creature attackTarget : npcTargets)
			{
				if(attackTarget != null)
				{
					if(!help && attackTarget == _owner)
						return true;
					if(_owner.isMyServitor(attackTarget.getObjectId()))
						return true;
					if(attackTarget.getPlayer() != null && _owner.isInSameParty(attackTarget.getPlayer()))
						return true;
				}
			}
		}

		/*int levelDiff = Math.abs(npc.getLevel() - _owner.getLevel());
		if(levelDiff >= 20)
			return false;*/

		if (isPoliteFarm() && npc.isInCombat()) { // Вежливая охота
			if (npc.getAI().getAttackTarget() != null && npc.getAI().getAttackTarget().isPlayable())
				return false;
            return npc.getAI().getCastTarget() == null || !npc.getAI().getCastTarget().isPlayable();
		}
		return true;
	}

	private void updateFarmRange() {
		if (isFixedZone() || !_owner.getMovement().isMoving()) {
			return;
		}
		updateFarmRange(isFixedZone() ? _fixedPoint : _owner.getLoc());
	}

	private void updateFarmRange(Location loc) {
		ExServerPrimitivePacket packet = new ExServerPrimitivePacket("AutoFarmRange", loc.getX(), loc.getY(), 65535 + loc.getZ());
		if (showRadius() && isFarmActivate()) {
			final int circleRadius = getTargetRange();
			for (int step = 0; step < 3; step++) {
				final int z = loc.getZ() + 10 + (step * 30);
				for (int degrees = 0; degrees < 360; degrees += 6) {
					final int x1 = (int) (loc.getX() - circleRadius * Math.sin(Math.toRadians(degrees)));
					final int y1 = (int) (loc.getY() + circleRadius * Math.cos(Math.toRadians(degrees)));
					final int x2 = (int) (loc.getX() - circleRadius * Math.sin(Math.toRadians(degrees + 6)));
					final int y2 = (int) (loc.getY() + circleRadius * Math.cos(Math.toRadians(degrees + 6)));
					packet.addLine(Color.GREEN, x1, y1, z, x2, y2, z);
				}
			}
		} else {
			packet.addPoint(Color.GREEN, loc.getX(), loc.getY(), Short.MIN_VALUE);
		}
		_owner.sendPacket(packet);
	}
}
