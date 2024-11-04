package l2s.gameserver.model.actor.instances.player;

import java.util.Set;
import java.util.concurrent.CopyOnWriteArraySet;
import java.util.concurrent.ScheduledFuture;
import java.util.concurrent.atomic.AtomicInteger;
import java.util.concurrent.locks.ReentrantLock;

import l2s.gameserver.ThreadPoolManager;
import l2s.gameserver.data.xml.holder.SkillHolder;
import l2s.gameserver.model.Creature;
import l2s.gameserver.model.Player;
import l2s.gameserver.model.Servitor;
import l2s.gameserver.model.Skill;
import l2s.gameserver.model.Skill.SkillTargetType;
import l2s.gameserver.model.Skill.SkillType;
import l2s.gameserver.model.actor.instances.creature.Abnormal;
import l2s.gameserver.model.actor.instances.player.ShortCut.ShortCutType;
import l2s.gameserver.model.base.ItemAutouseType;
import l2s.gameserver.model.instances.MonsterInstance;
import l2s.gameserver.model.items.ItemInstance;
import l2s.gameserver.network.l2.c2s.RequestActionUse.Action;
import l2s.gameserver.network.l2.components.IBroadcastPacket;
import l2s.gameserver.network.l2.components.SystemMsg;
import l2s.gameserver.network.l2.s2c.ActionFailPacket;
import l2s.gameserver.network.l2.s2c.ExActivateAutoShortcut;
import l2s.gameserver.network.l2.s2c.ExAutoplayDoMacro;
import l2s.gameserver.network.l2.s2c.FlyToLocationPacket;
import l2s.gameserver.skills.SkillEntry;
import l2s.gameserver.skills.SkillEntryType;

public class AutoShortCuts
{
	private enum AutoUseType
	{
		HEAL,
		ITEM_BUFF,
		SKILL_BUFF,
		SKILL_ATTACK,
		ATTACK,
		PET_SKILL;
	}

	private final Player _owner;

	private int autoHealItem = -1;
	private final ReentrantLock _useLock = new ReentrantLock();
	private final Set<Integer> _autoBuffItems = new CopyOnWriteArraySet<>();
	private final Set<Integer> _autoBuffSkills = new CopyOnWriteArraySet<>();
	private final Set<Integer> _autoPetSkills = new CopyOnWriteArraySet<>();
	private final Set<Integer> _autoAttackSkills = new CopyOnWriteArraySet<>();
	private final Set<Integer> _prioritySkills = new CopyOnWriteArraySet<>();
	private final Set<Integer> _usedAttackSkills = new CopyOnWriteArraySet<>();
	private final Set<Integer> _usedPrioritySkills = new CopyOnWriteArraySet<>();
	private final Set<Integer> _usedBuffSkills = new CopyOnWriteArraySet<>();
	private boolean _autoAttack = false;
	private boolean _autoAttackPet = false;

	private final int _spoilSkillId = 254;

	private ScheduledFuture<?> _autoHealTask = null;
	private ScheduledFuture<?> _autoBuffItemsTask = null;
	private ScheduledFuture<?> _autoBuffSkillsTask = null;
	private ScheduledFuture<?> _autoPetSkillsTask = null;
	private ScheduledFuture<?> _autoAttackSkillsTask = null;
	private ScheduledFuture<?> _autoAttackTask = null;
	private ScheduledFuture<?> _autoAttackPetTask = null;
	private Action action;

	public AutoShortCuts(Player owner)
	{
		_owner = owner;
	}

	public boolean autoSkillsActive()
	{
		return _autoAttackSkillsTask != null;
	}

	private void doAutoShortCut(AutoUseType autoUseType)
	{
		_useLock.lock();
		try {
			if (/*_owner.isInPeaceZone() || */_owner.isDead()) {
				return;
			}

			switch (autoUseType) {
				case HEAL: {
					if (useHealItem()) {
						return;
					}
					break;
				}
				case ITEM_BUFF: {
					if (useItemBuff()) {
						return;
					}
					break;
				}
				case SKILL_BUFF: {
					if (useSkillBuff()) {
						return;
					}
					break;
				}
				case SKILL_ATTACK: {
					if (usePrioritySkill()) {
						return;
					}
					if (useSkillAttack()) {
						return;
					}
					break;
				}

			}
		}
		finally {
			_useLock.unlock();
		}
	}

	private boolean usePrioritySkill() {
		if (!_owner.getAutoFarm().isFarmActivate()) {
			return false;
		}
		loop: for (int skillId : _prioritySkills) {
			SkillEntry skillEntry = _owner.getKnownSkill(skillId);
			if (skillEntry == null) {
				_prioritySkills.remove(skillId);
				_usedPrioritySkills.remove(skillId);
				continue loop;
			}

			if (_usedPrioritySkills.contains(skillId)) {
				continue loop; // skip
			}

			Skill skill = skillEntry.getTemplate();
			Creature target = null;
			target = skill.getAimingTarget(_owner, _owner.getTarget());
			if ((target != null) && (target.isMonster() || skill.getTargetType().equals(SkillTargetType.TARGET_AURA))) {
				if (skill.getMpConsume() > _owner.getCurrentMp()) {
					_usedPrioritySkills.add(skillId);
					continue loop;
				}
				if (!skill.checkCondition(skillEntry, _owner, target, true, false, true, false, skill.isTrigger())) {
					_usedPrioritySkills.add(skillId);
					continue loop;
				}
				if (_prioritySkills.size() == _usedPrioritySkills.size()) {
					_usedPrioritySkills.clear();
					return false;
				}
				if (!_owner.isCastingNow() && _owner.getAI().Cast(skillEntry, target, true, false)) {
					_usedPrioritySkills.add(skillId);
					return true;
				}
			}
		}
		if (_usedPrioritySkills.containsAll(_prioritySkills)) {
			_usedPrioritySkills.clear();
			return false;
		}
		return false;
	}

	private boolean useSkillAttack() {
		loop:for (int skillId : _autoAttackSkills) {
			SkillEntry skillEntry = _owner.getKnownSkill(skillId);
			if (skillEntry == null) {
				_autoAttackSkills.remove(skillId);
				_usedAttackSkills.remove(skillId);
				continue;
			}

			if (_usedAttackSkills.contains(skillId)) {
				continue;
			}

			Skill skill = skillEntry.getTemplate();
			Creature target = null;
			if (_owner.getPlayer().getAutoFarm().isFarmActivate()) {
				if (skill.getSkillType() == SkillType.DEBUFF) {
					target = skill.getAimingTarget(_owner, _owner.getTarget());
					if (target != null && target.isMonster() && isAffectedByDebuff(skill, target)) {
						// Добавляем как юзнутый, что бы не лагала очередь
						_usedAttackSkills.add(skillId);
						continue loop;
					}
				}

				target = skill.getAimingTarget(_owner, _owner.getTarget());
				if (target != null && target != _owner) {
					if (_owner.getMovement().isFollowing(target.getObjectId())) {
						return true;
					}
				}

				if (skill.getSkillType() == SkillType.HEAL && _owner.getCurrentHpPercents() <= 90.0 && skill.getMpConsume() <= _owner.getCurrentMp()) {
					target = skill.getAimingTarget(_owner, _owner);
					if (target != null) {
						if (skill.checkCondition(skillEntry, _owner, target, true, false, true, false, skill.isTrigger())) {
							if (!_owner.isCastingNow() && _owner.getAI().Cast(skillEntry, target, true, false)) {
								return true;
							}
						}
					}
				} else {
					target = skill.getAimingTarget(_owner, _owner.getTarget());
					// затычка для Provoke ?
					if (target != null && (target.isMonster() || skill.getTargetType().equals(SkillTargetType.TARGET_AURA))) {
						if (skill.getId() != _spoilSkillId && skill.getMpConsume() <= _owner.getCurrentMp()) {
							if (skill.checkCondition(skillEntry, _owner, target, true, false, true, false, skill.isTrigger())) {
								if (!_owner.isCastingNow() && _owner.getAI().Cast(skillEntry, target, true, false)) {
									_usedAttackSkills.add(skillId);
									return true;
								}
							} else {
								_usedAttackSkills.add(skillId);
								return true;
							}
						} else {
							_owner.sendPacket(new ExAutoplayDoMacro());
						}
					} else {
						_usedAttackSkills.add(skillId);
						return true;
					}
				}
				if (skill.getId() == _spoilSkillId && skill.getMpConsume() <= _owner.getCurrentMp()) {
					target = skill.getAimingTarget(_owner, _owner.getTarget());
					if (target != null && target.isMonster()) {
						MonsterInstance monster = (MonsterInstance) target;
						if (skill.getMpConsume() <= _owner.getCurrentMp() && target.isMonster() && monster.isSpoiled()) {
							return true;
						}
						if (skill.checkCondition(skillEntry, _owner, target, true, false, true, false, skill.isTrigger())) {
							if (!_owner.isCastingNow() && _owner.getAI().Cast(skillEntry, monster, true, false)) {
								return true;
							}
						}
					}
				}
				if (target == null)
					continue;
			}
		}

		if (_usedAttackSkills.containsAll(_autoAttackSkills)) {
			_usedAttackSkills.clear();
		}

		if (_autoAttackSkills.isEmpty() && _prioritySkills.isEmpty()) {
			_usedAttackSkills.clear();
			_usedPrioritySkills.clear();
			stopAutoAttackSkillsTask();
		}
		return false;
	}

	private boolean useSkillBuff() {

		loop: for (int skillId : _autoBuffSkills) {
			SkillEntry skillEntry = _owner.getKnownSkill(skillId);
			if (skillEntry == null) {
				_usedBuffSkills.remove(skillId);
				_autoBuffSkills.remove(skillId);
				continue;
			}

			if (_usedBuffSkills.contains(skillId)) {
				if (_owner.isCastingNow()) {
					_usedBuffSkills.add(skillId);
					continue;
				}
			}

			Creature target = skillEntry.getTemplate().getAimingTarget(_owner, _owner);
			if (target == null)
				continue;

			for (Abnormal abnormal : target.getAbnormalList()) {
				if (!abnormal.canReplaceAbnormal(skillEntry.getTemplate(), 0.1)) {
					_usedBuffSkills.add(skillId);
					continue loop;
				}
			}

			if (skillEntry.getTemplate().checkCondition(skillEntry, _owner, target, true, false, true, false, skillEntry.getTemplate().isTrigger())) {
				if (!_owner.isCastingNow() && _owner.getAI().Cast(skillEntry, target, false, false)) {
					_usedBuffSkills.add(skillId);
					return true;
				}
			}
		}

		if (_usedBuffSkills.containsAll(_autoBuffSkills)) {
			_usedBuffSkills.clear();
		}

		if (_autoBuffSkills.isEmpty()) {
			_usedBuffSkills.clear();
			stopAutoBuffSkillsTask();
		}
		return false;
	}

	private boolean useItemBuff() {
		loop: for (int itemObjectId : _autoBuffItems) {
			ItemInstance item = _owner.getInventory().getItemByObjectId(itemObjectId);
			if (item == null) {
				_autoBuffItems.remove(itemObjectId);
				continue;
			}

			SkillEntry skillEntry = item.getTemplate().getFirstSkill();
			if (skillEntry == null) {
				_autoBuffItems.remove(itemObjectId);
				continue;
			}

			Skill skill = skillEntry.getTemplate();
			Creature target = skill.getAimingTarget(_owner, _owner);
			if (target == null) {
				target = _owner;
			}

			for (Abnormal abnormal : target.getAbnormalList()) {
				if (!abnormal.canReplaceAbnormal(skill, 0.1))
					continue loop;
			}

			return _owner.useItem(item, false, false);
		}

		if (_autoBuffItems.isEmpty()) {
			stopAutoBuffItemsTask();
		}

		return false;
	}

	private boolean useHealItem() {
		if (_owner.getCurrentHpPercents() >= _owner.getAutoFarm().getHealPercent())
			return true;

		ItemInstance item = _owner.getInventory().getItemByObjectId(autoHealItem);
		if (item == null) {
			autoHealItem = -1;
			stopAutoHealTask();
			return true;
		}

		if (item.getTemplate().getFirstSkill() == null) {
			activate(1, ShortCut.PAGE_AUTOPLAY, false, true);
			return true;
		}

		return _owner.useItem(item, false, false);
	}

	private boolean isAffectedByDebuff(Skill skill, Creature target)
	{
		return skill.getSkillType().equals(SkillType.DEBUFF) && target.getAbnormalList().contains(skill.getId());
	}

	public boolean activate(int slotIndex, boolean active)
	{
		if(slotIndex == 65535)
		{
			boolean success = false;
			for(int s = 0; s < 12; s++)
			{
				if(activate(s, ShortCut.PAGE_AUTOCONSUME, active, false))
					success = true;
			}
			return success;
		}

		int slot = slotIndex % 12;
		int page = slotIndex / 12;
		return activate(slot, page, active, true);
	}

	public synchronized boolean activate(int slot, int page, boolean active, boolean checkPage)
	{
		if(activate0(slot, page, active, checkPage))
		{
			if(autoHealItem > 0) {
				if(_autoHealTask == null)
					_autoHealTask = ThreadPoolManager.getInstance().scheduleAtFixedDelay(() -> doAutoShortCut(AutoUseType.HEAL), 0, 250L);
			}
			else {
				stopAutoHealTask();
			}

			if(!_autoBuffItems.isEmpty()) {
				if(_autoBuffItemsTask == null)
					_autoBuffItemsTask = ThreadPoolManager.getInstance().scheduleAtFixedDelay(() -> doAutoShortCut(AutoUseType.ITEM_BUFF), 0, 100L);
			}
			else {
				stopAutoBuffItemsTask();
			}

			if(!_autoBuffSkills.isEmpty()) {
				if(_autoBuffSkillsTask == null)
					_autoBuffSkillsTask = ThreadPoolManager.getInstance().scheduleAtFixedDelay(() -> doAutoShortCut(AutoUseType.SKILL_BUFF), 0, 100L);
			}
			else {
				stopAutoBuffSkillsTask();
			}

			if(!_autoAttackSkills.isEmpty() || !_prioritySkills.isEmpty()) {
				if(_autoAttackSkillsTask == null)
					_autoAttackSkillsTask = ThreadPoolManager.getInstance().scheduleAtFixedDelay(() -> doAutoShortCut(AutoUseType.SKILL_ATTACK), 0, 100L);
			}
			else {
				stopAutoAttackSkillsTask();
			}

			if (_autoAttack) {
				if (_autoAttackTask == null)
					_autoAttackTask = ThreadPoolManager.getInstance().scheduleAtFixedDelay(() -> doAutoShortCut(AutoUseType.ATTACK), 0, 100L);
			}
			else {
				stopAutoAttackTask();
			}

			return true;
		}
		return false;
	}

	private void stopAutoHealTask()
	{
		if(_autoHealTask != null)
		{
			_autoHealTask.cancel(false);
			_autoHealTask = null;
		}
	}

	private void stopAutoBuffItemsTask()
	{
		if(_autoBuffItemsTask != null)
		{
			_autoBuffItemsTask.cancel(false);
			_autoBuffItemsTask = null;
		}
	}

	private void stopAutoBuffSkillsTask()
	{
		if(_autoBuffSkillsTask != null)
		{
			_autoBuffSkillsTask.cancel(false);
			_autoBuffSkillsTask = null;
		}
	}

	private void stopAutoAttackSkillsTask()
	{
		if(_autoAttackSkillsTask != null)
		{
			_autoAttackSkillsTask.cancel(false);
			_autoAttackSkillsTask = null;
		}
	}

	private void stopAutoPetSkillsTask()
	{
		if(_autoPetSkillsTask != null)
		{
			_autoPetSkillsTask.cancel(false);
			_autoPetSkillsTask = null;
		}
	}

	private void stopAutoAttackTask()
	{
		if(_autoAttackTask != null)
		{
			_autoAttackTask.cancel(false);
			_autoAttackTask = null;
		}
	}

	private void stopAutoAttackPetTask()
	{
		if(_autoAttackPetTask != null)
		{
			_autoAttackPetTask.cancel(false);
			_autoAttackPetTask = null;
		}
	}

	private boolean activate0(int slot, int page, boolean active, boolean checkPage)
	{
		ShortCut shortCut = _owner.getShortCut(slot, page);
		if(shortCut == null)
			return false;

		if(!checkShortCut(shortCut.getSlot(), shortCut.getPage(), shortCut.getType(), shortCut.getId()))
			return false;

		if (shortCut.isToggled() != active) {
			shortCut.setToggled(active);
			// _owner.updateShortCutToggledState(shortCut);
		}


		if(page == ShortCut.PAGE_AUTOCONSUME)
		{
			if(active)
				_autoBuffItems.add(shortCut.getId());
			else
				_autoBuffItems.remove(shortCut.getId());
			if(checkPage)
			{
				for(int s = 0; s < 12; s++)
				{
					ShortCut sc = _owner.getShortCut(s, page);
					if(sc != null && sc.getType() == shortCut.getType() && sc.getId() == shortCut.getId())
						_owner.sendPacket(new ExActivateAutoShortcut(s, page, active));
				}
			}
			else
				_owner.sendPacket(new ExActivateAutoShortcut(slot, page, active));
			return true;
		}
		else if (page == ShortCut.PAGE_AUTOPLAY)
		{
			if(slot == 1)
			{
				autoHealItem = active ? shortCut.getId() : -1;
				_owner.sendPacket(new ExActivateAutoShortcut(slot, page, active));
				return true;
			}
		}
		else if(page >= ShortCut.PAGE_NORMAL_0 && page <= ShortCut.PAGE_FLY_TRANSFORM)
		{
			if (shortCut.getType() == ShortCutType.ITEM)
			{
				ItemInstance item = _owner.getInventory().getItemByObjectId(shortCut.getId());
				if (item == null)
				{
					return false;
				}
				SkillEntry skillEntry = item.getTemplate().getFirstSkill();
				if ((skillEntry != null) && item.getTemplate().getAutouseType() == ItemAutouseType.BUFF)
				{
					if(active)
						_autoBuffItems.add(shortCut.getId());
					else
						_autoBuffItems.remove(shortCut.getId());
				}
			}
			else if (shortCut.getType() != ShortCutType.ACTION)
			{
				SkillEntry skillEntry = _owner.getKnownSkill(shortCut.getId());
				if ((skillEntry.getTemplate().getAutoUseType() == Skill.SkillAutoUseType.BUFF) || (skillEntry.getTemplate().getAutoUseType() == Skill.SkillAutoUseType.APPEARANCE))
				{
					if(active)
						_autoBuffSkills.add(shortCut.getId());
					else {
						_usedBuffSkills.remove(shortCut.getId());
						_autoBuffSkills.remove(shortCut.getId());
					}
				}
				else if (skillEntry.getTemplate().getAutoUseType() == Skill.SkillAutoUseType.ATTACK)
				{
					if(active) {
						final Skill skill = SkillHolder.getInstance().getSkill(shortCut.getId(), shortCut.getLevel());
						if (isPrioritySkill(skill)) {
							_prioritySkills.add(shortCut.getId());
						} else {
							_autoAttackSkills.add(shortCut.getId());
						}
					}
					else {
						_prioritySkills.remove(shortCut.getId());
						_usedPrioritySkills.remove(shortCut.getId());
						_usedAttackSkills.remove(shortCut.getId());
						_autoAttackSkills.remove(shortCut.getId());
					}
				}
			}
			else
			{
				if (active)
				{
					if (shortCut.getId() == 2)
						_autoAttack = true;
					else if ((shortCut.getId() == 16) || (shortCut.getId() == 22))
						_autoAttackPet = true;
					else
					{
						action = Action.find(shortCut.getId());
						if (action.value > 0)
						{
							_autoPetSkills.add(action.value);
						}
					}

				}
				else
				{
					if (shortCut.getId() == 2)
					{
						_autoAttack = false;
						stopAutoAttackTask();
					}
					else if ((shortCut.getId() == 16) || (shortCut.getId() == 22))
					{
						_autoAttackPet = false;
						stopAutoAttackPetTask();
					}
					else
					{
						action = Action.find(shortCut.getId());
						if (action.value > 0)
						{
							_autoPetSkills.remove(action.value);
						}
					}
				}
			}
			if(checkPage)
			{
				for(int p = ShortCut.PAGE_NORMAL_0; p <= ShortCut.PAGE_FLY_TRANSFORM; p++)
				{
					for(int s = 0; s < 12; s++)
					{
						ShortCut sc = _owner.getShortCut(s, p);
						if(sc != null && sc.getType() == shortCut.getType() && sc.getId() == shortCut.getId())
							_owner.sendPacket(new ExActivateAutoShortcut(s, p, active));
					}
				}
			}
			else
				_owner.sendPacket(new ExActivateAutoShortcut(slot, page, active));
			return true;
		}
		return false;
	}

	private static boolean isPrioritySkill(Skill skill) {
		if (skill == null) {
			return false;
		}
		return skill.getFlyType().equals(FlyToLocationPacket.FlyType.CHARGE) || (skill.getId() == 70000);
	}

	public IBroadcastPacket canRegShortCut(int slot, int page, ShortCut.ShortCutType shortCutType, int id)
	{
		if(page >= ShortCut.PAGE_NORMAL_0 && page <= ShortCut.PAGE_FLY_TRANSFORM)
		{
			return null;
		}
		else if(!checkShortCut(slot, page, shortCutType, id))
		{
			if(page == ShortCut.PAGE_AUTOPLAY && slot == 0)
				return SystemMsg.MACRO_USE_ONLY;
			else
				return ActionFailPacket.STATIC;
		}
		return null;
	}

	private boolean checkShortCut(int slot, int page, ShortCut.ShortCutType shortCutType, int id)
	{
		if(shortCutType == ShortCut.ShortCutType.MACRO)
		{
			if(page == ShortCut.PAGE_AUTOPLAY && slot == 0)
				return true;
		}
		else if(shortCutType == ShortCut.ShortCutType.ITEM)
		{
			ItemAutouseType autouseType;
			if(page == ShortCut.PAGE_AUTOPLAY)
			{
				if (slot != 1)
					return false;
				autouseType = ItemAutouseType.HEAL;
			}
			else if(page >= ShortCut.PAGE_NORMAL_0 && (page <= ShortCut.PAGE_FLY_TRANSFORM || page == ShortCut.PAGE_AUTOCONSUME))
			{
				autouseType = ItemAutouseType.BUFF;
			}
			else
				return false;

			ItemInstance item = _owner.getInventory().getItemByObjectId(id);
			if(item == null || item.getTemplate().getAutouseType() != autouseType)
				return false;

			return true;
		}
		else if(shortCutType == ShortCut.ShortCutType.SKILL)
		{
			if(page >= ShortCut.PAGE_NORMAL_0 && page <= ShortCut.PAGE_FLY_TRANSFORM)
			{
				SkillEntry skillEntry = _owner.getKnownSkill(id);
				if(skillEntry != null && (skillEntry.getTemplate().getAutoUseType() == Skill.SkillAutoUseType.BUFF //
						|| skillEntry.getTemplate().getAutoUseType() == Skill.SkillAutoUseType.APPEARANCE//
						|| skillEntry.getTemplate().getAutoUseType() == Skill.SkillAutoUseType.ATTACK))
					return true;
			}
		}
		else if (shortCutType == ShortCut.ShortCutType.ACTION)
		{
			return true;
		}
		return false;
	}

	private boolean servitorUseSkill(Player player, Servitor servitor, int skillId, int actionId)
	{
		if(servitor == null)
			return false;

		int skillLevel = servitor.getActiveSkillLevel(skillId);
		if(skillLevel == 0)
			return false;

		Skill skill = SkillHolder.getInstance().getSkill(skillId, skillLevel);
		if(skill == null)
			return false;

		if(servitor.isDepressed())
		{
			player.sendPacket(SystemMsg.YOUR_PETSERVITOR_IS_UNRESPONSIVE_AND_WILL_NOT_OBEY_ANY_ORDERS);
			return false;
		}

		if(servitor.isNotControlled()) // TODO: [Bonux] Проверить, распостраняется ли данное правило на саммонов.
		{
			player.sendPacket(SystemMsg.YOUR_PET_IS_TOO_HIGH_LEVEL_TO_CONTROL);
			return false;
		}

		if(skill.getId() != 6054)
		{
			int npcId = servitor.getNpcId();
			if(npcId == 16051 || npcId == 16052 || npcId == 16053 || npcId == 1601 || npcId == 1602 || npcId == 1603 || npcId == 1562 || npcId == 1563 || npcId == 1564 || npcId == 1565 || npcId == 1566 || npcId == 1567 || npcId == 1568 || npcId == 1569 || npcId == 1570 || npcId == 1571 || npcId == 1572 || npcId == 1573)
			{
				if(!servitor.getAbnormalList().contains(6054))
				{
					player.sendPacket(SystemMsg.A_PET_ON_AUXILIARY_MODE_CANNOT_USE_SKILLS);
					return false;
				}
			}
		}

		if(skill.isToggle())
		{
			if(servitor.getAbnormalList().contains(skill))
			{
				if(skill.isNecessaryToggle())
					servitor.getAbnormalList().stop(skill.getId());
				return true;
			}
		}

		if (skill.getTemplate().getAutoUseType() == Skill.SkillAutoUseType.BUFF)
			for(Abnormal abnormal : servitor.getAbnormalList())
			{
				if(!abnormal.canReplaceAbnormal(skill, 0.1))
					return false;
			}

		SkillEntry skillEntry = SkillEntry.makeSkillEntry(SkillEntryType.SERVITOR, skill);
		if(skillEntry == null)
			return false;

		Creature aimingTarget = skill.getAimingTarget(servitor, player.getTarget());

		if (!player.getAutoFarm().isFarmActivate() && (skill.getTemplate().getAutoUseType() == Skill.SkillAutoUseType.ATTACK))
			return false;

		if(!skill.checkCondition(skillEntry, servitor, aimingTarget, false, false, true, false, false))
			return false;

		if (servitor.isCastingNow())
			return false;

		servitor.setUsedSkill(skill, actionId); // TODO: [Bonux] Переделать.
		servitor.getAI().Cast(skillEntry, aimingTarget, false, false);
		return true;
	}

	public boolean ContainsAttackSkill(int skillId) {
		return _autoAttackSkills.contains(skillId);
	}
}